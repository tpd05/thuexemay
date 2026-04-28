package service;

import java.sql.Connection;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import dao.DonThueDAO;
import dao.ThanhToanDAO;
import model.ChiTietDonThue;
import model.DonThue;
import model.GioHang;
import model.ThanhToan;
import util.Connect;

/**
 * ThanhToanService - Payment Business Logic (Session-based QR → atomic DB save)
 *
 * Flow:
 * 1. User creates cart (DonThueAo) - not saved to DB
 * 2. User clicks payment → generate QR code (store payment info in session only)
 * 3. User scans QR code → confirm payment on mock page
 * 4. Callback: Save DonThue + ChiTietDonThue + ThanhToan atomically (DA_THANH_TOAN status)
 * 5. If cancelled: rollback - nothing saved to DB
 */
public class ThanhToanService {

	/**
	 * Tính tổng tiền từ danh sách chi tiết đơn
	 */
	public static double tinhTongTienDonThue(java.util.List<ChiTietDonThue> dsChiTiet) {
		double total = 0;
		if (dsChiTiet != null) {
			for (ChiTietDonThue ct : dsChiTiet) {
				total += ct.getDonGia();
			}
		}
		return total;
	}

	/**
	 * Tạo mã QR dùng để redirect đến trang giả lập thanh toán
	 * Format: THUEXE_[timestamp]_[random_uuid]
	 */
	public static String taoMaQR() {
		String qrCode = "THUEXE_" + System.currentTimeMillis() + "_" +
					   UUID.randomUUID().toString().substring(0, 8);
		return qrCode;
	}

	/**
	 * Lưu DonThue + ChiTietDonThue vào DB
	 * 
	 * @param don: DonThue object (với dsChiTiet)
	 * @param con: Connection
	 * @return maDon (ID đơn vừa tạo)
	 * @throws Exception
	 */
	public static int luuDonThue(DonThue don, Connection con) throws Exception {
		don.setTrangThai("DA_THANH_TOAN");
		DonThueDAO donDAO = new DonThueDAO();
		int maDon = donDAO.luuDonThueVaChiTiet(don, con);
		
		if (maDon <= 0) {
			throw new Exception("Tạo đơn thuê thất bại - maDon=" + maDon);
		}
		
		System.out.println("DEBUG: DonThue + ChiTietDonThue saved with maDon=" + maDon);
		return maDon;
	}

	/**
	 * Lưu ThanhToan vào DB
	 * 
	 * @param maDon: ID đơn thuê
	 * @param soTien: Số tiền thanh toán
	 * @param phuongThuc: Phương thức thanh toán
	 * @param con: Connection
	 * @return maThanhToan (ID thanh toán vừa tạo)
	 * @throws Exception
	 */
	public static int luuThanhToan(int maDon, double soTien, String phuongThuc, Connection con) throws Exception {
		ThanhToan tt = new ThanhToan();
		tt.setMaDonThue(maDon);
		tt.setSoTien((float)soTien);
		tt.setPhuongThuc(phuongThuc);
		tt.setTrangThai("DA_THANH_TOAN");
		tt.setThoiGianTao(new Timestamp(System.currentTimeMillis()));
		
		ThanhToanDAO ttDAO = new ThanhToanDAO();
		int maThanhToan = ttDAO.taoThanhToan(tt, con);
		
		if (maThanhToan <= 0) {
			throw new Exception("Tạo ghi nhận thanh toán thất bại - maThanhToan=" + maThanhToan);
		}
		
		System.out.println("DEBUG: ThanhToan created with maThanhToan=" + maThanhToan);
		return maThanhToan;
	}

	/**
	 * Lưu DonThue + ChiTietDonThue + ThanhToan vào DB (gọi khi thanh toán THÀNH CÔNG)
	 *
	 * Flow:
	 * 1. Lưu DonThue + ChiTietDonThue (gọi luuDonThue)
	 * 2. Lưu ThanhToan (gọi luuThanhToan)
	 * 3. DELETE corresponding MucHang from GioHang
	 * 4. All records saved atomically - if any fails, rollback everything
	 *
	 * @param don: DonThueAo từ session
	 * @param soTien: Số tiền thanh toán
	 * @param phuongThuc: Payment method
	 * @param gh: GioHang object (to delete cart items after order saved)
	 * @return true nếu lưu thành công
	 */
	public static boolean luuDonThueVaThanhToan(DonThue don, double soTien, String phuongThuc, GioHang gh)
			throws Exception {
		Connection con = null;
		try {
			con = Connect.getInstance().getConnect();
			con.setAutoCommit(false);

			// 1. Lưu DonThue + ChiTietDonThue
			int maDon = luuDonThue(don, con);

			// 2. Lưu ThanhToan
			int maThanhToan = luuThanhToan(maDon, soTien, phuongThuc, con);

			// 3. DELETE MucHang from GioHang (items in this order)
			List<Integer> goiThueIds = new ArrayList<>();
			if (don.getDsChiTiet() != null && !don.getDsChiTiet().isEmpty()) {
				for (ChiTietDonThue ct : don.getDsChiTiet()) {
					if (!goiThueIds.contains(ct.getMaGoiThue())) {
						goiThueIds.add(ct.getMaGoiThue());
					}
				}
			}

			if (gh != null && !goiThueIds.isEmpty()) {
				GioHangService gioHangService = new GioHangService();
				boolean delResult = gioHangService.xoaMucHangTheoGoiThue(gh, goiThueIds, con);
				if (!delResult) {
					con.rollback();
					throw new Exception("Xóa mục hàng khỏi giỏ thất bại");
				}
				System.out.println("DEBUG: MucHang deleted from GioHang");
			}

			// Commit - all records saved atomically
			con.commit();
			System.out.println("DEBUG: Transaction committed successfully - Order + Payment + Cart cleanup");
			return true;

		} catch (Exception e) {
			System.out.println("DEBUG: Exception in luuDonThueVaThanhToan: " + e.getMessage());
			e.printStackTrace();
			if (con != null) {
				try {
					con.rollback();
					System.out.println("DEBUG: Transaction rolled back");
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			throw new Exception("Lỗi lưu thanh toán: " + e.getMessage());
		} finally {
			if (con != null) {
				try {
					con.setAutoCommit(true);
					con.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * Overloaded method - backward compatible (without GioHang parameter)
	 * For cases where cart cleanup is not needed
	 */
	public static boolean luuDonThueVaThanhToan(DonThue don, double soTien, String phuongThuc)
			throws Exception {
		return luuDonThueVaThanhToan(don, soTien, phuongThuc, null);
	}

	/**
	 * Kiểm tra QR code có hết hạn không (3 phút)
	 */
	public static boolean isQRExpired(long createdTime) {
		long elapsed = System.currentTimeMillis() - createdTime;
		return elapsed > 180000; // 3 minutes
	}
}
