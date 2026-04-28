package service;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import dao.ChiNhanhDAO;
import dao.ChiTietDonThueDAO;
import dao.DonThueDAO;
import dao.GioHangDAO;
import dao.GoiThueDAO;
import dao.MauXeDAO;
import dao.MucHangDAO;
import dao.XeMayDAO;
import model.ChiNhanh;
import model.ChiTietDonThue;
import model.DonThue;
import model.GioHang;
import model.GoiThue;
import model.MauXe;
import model.MucHang;
import model.XeMay;
import util.Connect;

public class DonThueService {
	
	// Helper method to convert LocalDateTime to java.util.Date for JSTL fmt:formatDate
	private Date convertLocalDateTimeToDate(LocalDateTime localDateTime) {
		if (localDateTime == null) {
			return null;
		}
		return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
	}
	
	public DonThue taoDonThueAo(GioHang gh, List<MucHang> selected) throws Exception {

		Connection con = null;

		try {
			con = Connect.getInstance().getConnect();

			XeMayDAO xeDAO = new XeMayDAO();
			GoiThueDAO goiThueDAO = new GoiThueDAO();
			MauXeDAO mauXeDAO = new MauXeDAO();
			ChiNhanhDAO chiNhanhDAO = new ChiNhanhDAO(con);

			DonThue don = new DonThue();
			don.setUserID(gh.getUserID());
			don.setDiaChiNhanXe(gh.getDiaChiNhanXe());
			don.setTrangThai("AO");

			List<ChiTietDonThue> dsChiTiet = new ArrayList<>();

			for (MucHang mh : selected) {

				if (mh.getThoiGianBatDau() == null || mh.getThoiGianKetThuc() == null) {
					throw new RuntimeException("Thiếu thời gian thuê");
				}

				// Lấy thông tin gói thuê
				GoiThue goiThue = goiThueDAO.layGoiThueTheoId(mh.getMaGoiThue(), con);
				
				List<Integer> xeTrong = xeDAO.layXeTrong(mh.getMaGoiThue(), mh.getThoiGianBatDau(),
						mh.getThoiGianKetThuc(), con);

				if (xeTrong.size() < mh.getSoLuong()) {
					throw new RuntimeException("Không đủ xe cho gói: " + mh.getMaGoiThue());
				}

				for (int i = 0; i < mh.getSoLuong(); i++) {

					ChiTietDonThue ct = new ChiTietDonThue();

					int maXe = xeTrong.get(i);
					ct.setMaXe(maXe);
					ct.setMaGoiThue(mh.getMaGoiThue());
					ct.setThoiGianBatDau(mh.getThoiGianBatDau());
					ct.setThoiGianKetThuc(mh.getThoiGianKetThuc());
					// Convert to java.util.Date for JSTL fmt:formatDate
					ct.setThoiGianBatDauDate(convertLocalDateTimeToDate(mh.getThoiGianBatDau()));
					ct.setThoiGianKetThucDate(convertLocalDateTimeToDate(mh.getThoiGianKetThuc()));
				// Calculate price per vehicle (divide by soLuong since tinhTien() already multiplies)
				double giaMotXe = mh.tinhTien() / mh.getSoLuong();
				ct.setDonGia((int) Math.ceil(giaMotXe));

				// Lấy thông tin chi tiết xe
					XeMay xeMay = xeDAO.timXeTheoId(maXe, con);
					if (xeMay != null) {
						ct.setBienSoXe(xeMay.getBienSo());
						ct.setSoKhung(xeMay.getSoKhung());
						ct.setSoMay(xeMay.getSoMay());

						// Lấy thông tin mẫu xe
						MauXe mauXe = mauXeDAO.layMauXeTheoId(xeMay.getMaMauXe(), con);
						if (mauXe != null) {
							ct.setHangXe(mauXe.getHangXe());
							ct.setDongXe(mauXe.getDongXe());
							ct.setUrlHinhAnh(mauXe.getUrlHinhAnh());
						}

						// Lấy thông tin chi nhánh
						ChiNhanh chiNhanh = chiNhanhDAO.layChiNhanhTheoId(xeMay.getMaChiNhanh(), con);
						if (chiNhanh != null) {
							ct.setTenChiNhanh(chiNhanh.getTenChiNhanh());
						}
					}

					// Lấy tên gói thuê
					if (goiThue != null) {
						ct.setTenGoiThue(goiThue.getTenGoiThue());
					}

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
