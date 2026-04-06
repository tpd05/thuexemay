package service;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import dao.ChiTietDonThueDAO;
import dao.DonThueDAO;
import dao.GioHangDAO;
import dao.MucHangDAO;
import dao.XeMayDAO;
import model.ChiTietDonThue;
import model.DonThue;
import model.GioHang;
import model.MucHang;
import util.Connect;

public class DonThueService {
	public DonThue taoDonThueAo(GioHang gh, List<MucHang> selected) throws Exception {

		Connection con = null;

		try {
			con = Connect.getInstance().getConnect();

			XeMayDAO xeDAO = new XeMayDAO();

			DonThue don = new DonThue();
			don.setUserID(gh.getUserID());
			don.setDiaChiNhanXe(gh.getDiaChiNhanXe());
			don.setTrangThai("AO");

			List<ChiTietDonThue> dsChiTiet = new ArrayList<>();

			for (MucHang mh : selected) {

				if (mh.getThoiGianBatDau() == null || mh.getThoiGianKetThuc() == null) {
					throw new RuntimeException("Thiếu thời gian thuê");
				}

				List<Integer> xeTrong = xeDAO.layXeTrong(mh.getMaGoiThue(), mh.getThoiGianBatDau(),
						mh.getThoiGianKetThuc(), con);

				if (xeTrong.size() < mh.getSoLuong()) {
					throw new RuntimeException("Không đủ xe cho gói: " + mh.getMaGoiThue());
				}

				for (int i = 0; i < mh.getSoLuong(); i++) {

					ChiTietDonThue ct = new ChiTietDonThue();

					ct.setMaXe(xeTrong.get(i));
					ct.setMaGoiThue(mh.getMaGoiThue());
					ct.setThoiGianBatDau(mh.getThoiGianBatDau());
					ct.setThoiGianKetThuc(mh.getThoiGianKetThuc());

					ct.setDonGia((int) mh.tinhTien());

					dsChiTiet.add(ct);
				}
			}

			don.setDsChiTiet(dsChiTiet);

			return don;

		} finally {
			try {
				if (con != null)
					con.close();
			} catch (Exception e) {
				throw new Exception("Lỗi đóng kết nối", e);
			}
		}
	}

	public int xacNhanDonThue(DonThue don) throws Exception {

		Connection con = null;

		try {
			con = Connect.getInstance().getConnect();
			con.setAutoCommit(false);

			DonThueDAO donDAO = new DonThueDAO();
			ChiTietDonThueDAO ctDAO = new ChiTietDonThueDAO();

			don.setTrangThai("DA_THANH_TOAN");

			int maDon = donDAO.taoDonThue(don, con);

			if (maDon <= 0) {
				throw new RuntimeException("Tạo đơn thất bại");
			}

			for (ChiTietDonThue ct : don.getDsChiTiet()) {

				ct.setMaDonThue(maDon);

				boolean ok = ctDAO.themChiTiet(ct, con);

				if (!ok) {
					throw new RuntimeException("Lưu chi tiết thất bại");
				}
			}

			con.commit();
			
			// Xóa các mục hàng trong giỏ hàng sau khi đơn được lưu
			try {
				GioHangDAO gioHangDAO = new GioHangDAO();
				MucHangDAO mucHangDAO = new MucHangDAO();
				
				GioHang gioHang = gioHangDAO.layGioHangByUserID(don.getUserID(), con);
				
				if (gioHang != null) {
					// Lấy danh sách maGoiThue từ đơn thuê
					List<Integer> maGoiThueList = new ArrayList<>();
					for (ChiTietDonThue ct : don.getDsChiTiet()) {
						if (!maGoiThueList.contains(ct.getMaGoiThue())) {
							maGoiThueList.add(ct.getMaGoiThue());
						}
					}
					
					// Xóa các mục hàng khỏi giỏ hàng
					if (!maGoiThueList.isEmpty()) {
						mucHangDAO.xoaMucHang(gioHang.getMaGioHang(), maGoiThueList, con);
					}
				}
			} catch (Exception e) {
				// Log lỗi nhưng không làm hỏng transaction chính
				System.err.println("Lỗi xóa mục hàng giỏ hàng: " + e.getMessage());
			}
			
			return maDon;

		} catch (Exception e) {

			try {
				if (con != null)
					con.rollback();
			} catch (Exception ex) {
				throw new Exception("Lỗi rollback", ex);
			}

			throw new Exception("Lỗi xác nhận đơn thuê", e);
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
}
