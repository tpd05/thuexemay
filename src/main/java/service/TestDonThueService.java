package service;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import dao.ChiTietDonThueDAO;
import dao.DonThueDAO;
import model.ChiTietDonThue;
import model.DonThue;
import model.GioHang;
import model.MucHang;
import util.Connect;

public class TestDonThueService {

	public static void main(String[] args) {

	    GioHangService ghService = new GioHangService();
	    DonThueService donService = new DonThueService();

	    // =============================
	    // 1. GIỎ HÀNG
	    // =============================
	    GioHang gh = new GioHang();
	    gh.setMaGioHang(1);
	    gh.setUserID(15);
	    gh.setDiaChiNhanXe("Thái Nguyên");

		// =============================
		// 2. LẤY MỤC HÀNG
		// =============================
		List<MucHang> list = null;
		try {
			list = ghService.layDanhSachMucHangDayDu(gh);
		} catch (Exception e) {
			System.out.println("Lỗi khi lấy danh sách mục hàng");
			e.printStackTrace();
			return;
		}

		if (list.isEmpty()) {
			System.out.println("Giỏ hàng trống");
			return;
		}

	    // =============================
	    // 3. GIẢ LẬP CHỌN (chọn tất cả)
	    // =============================
	    List<MucHang> selected = list;

		// =============================
		// 4. TẠO ĐƠN ẢO
		// =============================
		DonThue don = null;
		try {
			don = donService.taoDonThueAo(gh, selected);
		} catch (Exception e) {
			System.out.println("Lỗi khi tạo đơn thuê");
			e.printStackTrace();
			return;
		}

		if (don == null) {
			System.out.println("Tạo đơn thất bại");
			return;
		}

	    // =============================
	    // 5. HIỂN THỊ
	    // =============================
	    System.out.println("\n===== ĐƠN THUÊ ẢO =====");

	    System.out.println("Khách: " + don.getUserID());
	    System.out.println("Địa chỉ: " + don.getDiaChiNhanXe());

	    int tong = 0;

	    for (ChiTietDonThue ct : don.getDsChiTiet()) {
	        System.out.println("Xe: " + ct.getMaXe());
	        System.out.println("Gói: " + ct.getMaGoiThue());
	        System.out.println("Từ: " + ct.getThoiGianBatDau());
	        System.out.println("Đến: " + ct.getThoiGianKetThuc());
	        System.out.println("Giá: " + ct.getDonGia());
	        System.out.println("----------------------");

	        tong += ct.getDonGia();
	    }

		System.out.println("TỔNG TIỀN: " + tong);
		int saved = 0;
		try {
			saved = donService.xacNhanDonThue(don);
		} catch (Exception e) {
			System.out.println("Lỗi khi xác nhận đơn thuê");
			e.printStackTrace();
		}

		System.out.println("Lưu DB: " + saved);
	}
}