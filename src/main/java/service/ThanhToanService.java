package service;

import java.sql.Connection;
import java.sql.Timestamp;
import java.util.UUID;

import dao.ChiTietDonThueDAO;
import dao.DonThueDAO;
import dao.ThanhToanDAO;
import model.ChiTietDonThue;
import model.DonThue;
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
	 * Lưu DonThue + ChiTietDonThue + ThanhToan vào DB (gọi khi thanh toán THÀNH CÔNG)
	 *
	 * Flow:
	 * 1. Create DonThue with status DA_THANH_TOAN
	 * 2. Create ChiTietDonThue entries linked to DonThue
	 * 3. Create ThanhToan with status DA_THANH_TOAN (linked to DonThue)
	 * 4. All 3 records saved atomically - if any fails, rollback everything
	 *
	 * @param don: DonThueAo từ session
	 * @param soTien: Số tiền thanh toán
	 * @param phuongThuc: Payment method
	 * @return true nếu lưu thành công
	 */
	public static boolean luuDonThueVaThanhToan(DonThue don, double soTien, String phuongThuc)
			throws Exception {
		Connection con = null;
		try {
			con = Connect.getInstance().getConnect();
			con.setAutoCommit(false);

			// 1. Lưu DonThue với trạng thái DA_THANH_TOAN
			don.setTrangThai("DA_THANH_TOAN");
			DonThueDAO donDAO = new DonThueDAO();
			int maDon = donDAO.taoDonThue(don, con);

			if (maDon <= 0) {
				con.rollback();
				throw new Exception("Tạo đơn thuê thất bại - maDon=" + maDon);
			}

			System.out.println("DEBUG: DonThue created with maDon=" + maDon);

			// 2. Lưu tất cả ChiTietDonThue
			if (don.getDsChiTiet() != null && !don.getDsChiTiet().isEmpty()) {
				ChiTietDonThueDAO ctDAO = new ChiTietDonThueDAO();
				for (ChiTietDonThue ct : don.getDsChiTiet()) {
					ct.setMaDonThue(maDon);
					if (!ctDAO.themChiTiet(ct, con)) {
						con.rollback();
						throw new Exception("Lưu chi tiết đơn thất bại");
					}
				}
			}

			System.out.println("DEBUG: ChiTietDonThue saved");

			// 3. CREATE ThanhToan (not update) with maDon linked and status DA_THANH_TOAN
			ThanhToan tt = new ThanhToan();
			tt.setMaDonThue(maDon);
			tt.setSoTien((float)soTien);
			tt.setPhuongThuc(phuongThuc);
			tt.setTrangThai("DA_THANH_TOAN");
			tt.setThoiGianTao(new Timestamp(System.currentTimeMillis()));

			ThanhToanDAO ttDAO = new ThanhToanDAO();
			int maThanhToan = ttDAO.taoThanhToan(tt, con);

			if (maThanhToan <= 0) {
				con.rollback();
				throw new Exception("Tạo ghi nhận thanh toán thất bại - maThanhToan=" + maThanhToan);
			}

			System.out.println("DEBUG: ThanhToan created with maThanhToan=" + maThanhToan);

			// Commit - all 3 records saved atomically
			con.commit();
			System.out.println("DEBUG: Transaction committed successfully");
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
	 * Kiểm tra QR code có hết hạn không (3 phút)
	 */
	public static boolean isQRExpired(long createdTime) {
		long elapsed = System.currentTimeMillis() - createdTime;
		return elapsed > 180000; // 3 minutes
	}
}
