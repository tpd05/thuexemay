package service;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import dao.ChiTietDonThueDAO;
import dao.GioHangDAO;
import dao.GoiThueDAO;
import dao.MucHangDAO;
import model.GioHang;
import model.GoiThue;
import model.MucHang;
import util.Connect;

public class GioHangService {
	private MucHangDAO mhdao = new MucHangDAO();
	private GioHangDAO ghdao = new GioHangDAO();

	public boolean themMucHangVaoGio(MucHang mh, GioHang gh) throws Exception {
		Connection con = null;

		try {
			con = Connect.getInstance().getConnect();
			con.setAutoCommit(false);

			mh.setMaGioHang(gh.getMaGioHang());

			MucHang mhtontai = mhdao.timMucHang(gh.getMaGioHang(), mh.getMaGoiThue(), con);

			boolean rs;

			if (mhtontai != null) {

				mhtontai.setSoLuong(mhtontai.getSoLuong() + 1);

				rs = mhdao.suaMucHang(mhtontai, con);

			} else {

				mh.setSoLuong(1);
				mh.setThoiGianBatDau(null);
				mh.setThoiGianKetThuc(null);

				rs = mhdao.themMucHang(mh, con);
			}

			con.commit();
			return rs;

		} catch (Exception e) {
			try {
				if (con != null)
					con.rollback();
			} catch (Exception ex) {
				throw new Exception("Lỗi rollback", ex);
			}
			throw new Exception("Lỗi thêm mục hàng vào giỏ", e);
		} finally {
			try {
				if (con != null) {
					con.setAutoCommit(true);
					con.close();
				}
			} catch (Exception e) {
				throw new Exception("Lỗi đóng kết nối", e);
			}
		}
	}

	public boolean capNhatMucHang(MucHang mh, GioHang gh) throws Exception {
		Connection con = null;

		try {
			con = Connect.getInstance().getConnect();
			con.setAutoCommit(false);

			mh.setMaGioHang(gh.getMaGioHang());

			// 1. Lấy mục hàng cũ
			MucHang mhtontai = mhdao.timMucHang(gh.getMaGioHang(), mh.getMaGoiThue(), con);

			if (mhtontai == null) {
				throw new RuntimeException("Mục hàng không tồn tại");
			}

			// 2. Validate thời gian
			if (mh.getThoiGianBatDau() == null || mh.getThoiGianKetThuc() == null) {
				throw new RuntimeException("Phải nhập thời gian thuê");
			}

			if (mh.getThoiGianBatDau().isAfter(mh.getThoiGianKetThuc())) {
				throw new RuntimeException("Thời gian không hợp lệ");
			}

			// 3. Lấy DAO
			GoiThueDAO goiThueDAO = new GoiThueDAO();
			ChiTietDonThueDAO ctDAO = new ChiTietDonThueDAO();

			// 4. Tính số lượng còn
			int tongXe = goiThueDAO.demTongXe(mh.getMaGoiThue(), con);
			int daThue = ctDAO.demXeDaThue(mh.getMaGoiThue(), mh.getThoiGianBatDau(), mh.getThoiGianKetThuc(), con);

			int soLuongCon = tongXe - daThue;

			// 5. Xử lý số lượng (QUAN TRỌNG)
			int soLuongMoi;

			if (mh.getSoLuong() > 0) {
				soLuongMoi = mh.getSoLuong(); // user nhập
			} else {
				soLuongMoi = mhtontai.getSoLuong(); // giữ nguyên
			}

			// 6. Check vượt
			if (soLuongMoi > soLuongCon) {
				throw new RuntimeException("Chỉ còn " + soLuongCon + " xe có thể thuê");
			}

			// 7. Update
			mhtontai.setSoLuong(soLuongMoi);
			mhtontai.setThoiGianBatDau(mh.getThoiGianBatDau());
			mhtontai.setThoiGianKetThuc(mh.getThoiGianKetThuc());

			boolean rs = mhdao.suaMucHang(mhtontai, con);

			if (!rs) {
				throw new RuntimeException("Cập nhật thất bại");
			}

			con.commit();
			return true;

		} catch (Exception e) {
			try {
				if (con != null)
					con.rollback();
			} catch (Exception ex) {
				throw new Exception("Lỗi rollback", ex);
			}
			throw new Exception("Lỗi cập nhật mục hàng", e);
		} finally {
			try {
				if (con != null) {
					con.setAutoCommit(true);
					con.close();
				}
			} catch (Exception e) {
				throw new Exception("Lỗi đóng kết nối", e);
			}
		}
	}

	public boolean capNhatDiaChiNhanXe(GioHang gh) throws Exception {
		Connection con = null;

		try {
			con = Connect.getInstance().getConnect();
			con.setAutoCommit(false);

			if (gh.getDiaChiNhanXe() == null || gh.getDiaChiNhanXe().trim().isEmpty()) {
				throw new RuntimeException("Phải nhập địa chỉ nhận xe");
			}

			boolean rs = ghdao.capNhatDiaChi(gh, con);

			if (!rs) {
				throw new RuntimeException("Cập nhật địa chỉ thất bại");
			}

			con.commit();
			return true;

		} catch (Exception e) {
			try {
				if (con != null)
					con.rollback();
			} catch (Exception ex) {
				throw new Exception("Lỗi rollback", ex);
			}
			throw new Exception("Lỗi cập nhật địa chỉ", e);
		} finally {
			try {
				if (con != null) {
					con.setAutoCommit(true);
					con.close();
				}
			} catch (Exception e) {
				throw new Exception("Lỗi đóng kết nối", e);
			}
		}
	}

	public List<MucHang> layDanhSachMucHangDayDu(GioHang gh) throws Exception {
		Connection con = null;

		try {
			con = Connect.getInstance().getConnect();

			// 1. Lấy mục hàng
			List<MucHang> list = mhdao.LayMucHangCuaGio(gh.getMaGioHang(), con);

			if (list.isEmpty())
				return list;

			// 2. Lấy ID gói thuê (loại trùng)
			Set<Integer> idSet = new HashSet<>();
			for (MucHang mh : list) {
				idSet.add(mh.getMaGoiThue());
			}

			// 3. Query 1 lần
			GoiThueDAO goiThueDAO = new GoiThueDAO();
			Map<Integer, GoiThue> map = goiThueDAO.layDanhSachTheoIds(new ArrayList<>(idSet), con);

			// 4. Map lại
			for (MucHang mh : list) {
				mh.setGoiThue(map.get(mh.getMaGoiThue()));
			}

			return list;

		} catch (Exception e) {
			throw new Exception("Lỗi lấy danh sách mục hàng", e);
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (Exception e) {
				throw new Exception("Lỗi đóng kết nối", e);
			}
		}
	}

	public boolean xoaMucHang(GioHang gh, List<Integer> ids) throws Exception {
		Connection con = null;
		try {
			con = Connect.getInstance().getConnect();
			con.setAutoCommit(false);

			boolean rs = mhdao.xoaMucHang(gh.getMaGioHang(), ids, con);

			if (!rs) {
				throw new RuntimeException("Xóa thất bại");
			}
			con.commit();
			return true;

		} catch (Exception e) {
			try {
				if (con != null)
					con.rollback();
			} catch (Exception e1) {
				throw new Exception("Lỗi rollback", e1);
			}
			throw new Exception("Lỗi xóa mục hàng", e);
		} finally {
			try {
				if (con != null) {
					con.setAutoCommit(true);
					con.close();
				}
			} catch (Exception e) {
				throw new Exception("Lỗi đóng kết nối", e);
			}
		}
	}

	/**
	 * Xóa mục hàng từ giỏ hàng theo danh sách GoiThue IDs (không tạo connection mới)
	 * Sử dụng cho atomic transaction từ ThanhToanService
	 *
	 * @param gh: GioHang object chứa maGioHang
	 * @param goalThueIds: Danh sách maGoiThue cần xóa
	 * @param con: Connection hiện tại (từ transaction)
	 * @return true nếu xóa thành công
	 * @throws Exception nếu xóa thất bại
	 */
	public boolean xoaMucHangTheoGoiThue(GioHang gh, List<Integer> goalThueIds, Connection con) throws Exception {
		if (gh == null || goalThueIds == null || goalThueIds.isEmpty()) {
			System.out.println("DEBUG: Skip delete - gh=" + (gh == null ? "null" : gh.getMaGioHang()) +
							   ", goalThueIds=" + (goalThueIds == null ? "null" : goalThueIds.size()));
			return true; // Không có gì để xóa
		}

		boolean rs = mhdao.xoaMucHang(gh.getMaGioHang(), goalThueIds, con);

		if (!rs) {
			System.out.println("DEBUG: Delete cart items failed for maGioHang=" + gh.getMaGioHang());
			throw new Exception("Xóa mục hàng khỏi giỏ hàng thất bại");
		}

		System.out.println("DEBUG: Deleted " + goalThueIds.size() + " cart items for maGioHang=" +
						   gh.getMaGioHang() + " - GoiThueIds=" + goalThueIds);
		return true;
	}

	public double tinhTongTien(GioHang gh, List<Integer> selectedGoiThueIds) {
		double tong = 0;

		List<MucHang> list = null;
		try {
			list = layDanhSachMucHangDayDu(gh);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		for (MucHang mh : list) {
			if (selectedGoiThueIds.contains(mh.getMaGoiThue())) {
				tong += mh.tinhTien();
			}
		}

		return tong;
	}
}
