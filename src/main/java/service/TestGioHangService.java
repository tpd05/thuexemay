package service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import model.GioHang;
import model.MucHang;
import service.GioHangService;

public class TestGioHangService {

	public static void main(String[] args) {

	    GioHangService service = new GioHangService();

	    GioHang gh = new GioHang();
	    gh.setMaGioHang(1);

	    // =============================
	    // 1. TEST THÊM MỤC HÀNG
	    // =============================
	    MucHang mh = new MucHang();
	    mh.setMaGoiThue(1);

//	    boolean them = service.themMucHangVaoGio(mh, gh);
//	    System.out.println("Thêm vào giỏ: " + them);

//	     =============================
//	     2. TEST CẬP NHẬT HỢP LỆ
//	     =============================
	    MucHang mhUpdate = new MucHang();
	    mhUpdate.setMaGioHang(1);
	    mhUpdate.setMaGoiThue(1);

	    mhUpdate.setSoLuong(1);
	    mhUpdate.setThoiGianBatDau(
	    	    LocalDateTime.of(2026, 4, 5, 7, 15, 0)
	    	);

	    	mhUpdate.setThoiGianKetThuc(
	    	    LocalDateTime.of(2026, 4, 5, 18, 15, 0)
	    	);

		boolean capNhat = false;
		try {
			capNhat = service.capNhatMucHang(mhUpdate, gh);
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Cập nhật hợp lệ: " + capNhat);

	    // =============================
	    // 3. TEST THÊM QUÁ SỐ LƯỢNG
	    // =============================
//	    MucHang mhOver = new MucHang();
//	    mhOver.setMaGioHang(1);
//	    mhOver.setMaGoiThue(2);
//
//	    mhOver.setSoLuong(1); // ⚠️ cố tình vượt
//	    mhOver.setThoiGianBatDau(LocalDateTime.now());
//	    mhOver.setThoiGianKetThuc(LocalDateTime.now().plusDays(1));
//
//	    boolean over = service.capNhatMucHang(mhOver, gh);
//	    System.out.println("Test vượt số lượng: " + over);
//
//	    // =============================
//	    // 4. TEST THỜI GIAN BỊ TRÙNG
//	    // =============================
//	    MucHang mhTrung = new MucHang();
//	    mhTrung.setMaGioHang(1);
//	    mhTrung.setMaGoiThue(1);
//
//	    mhTrung.setSoLuong(1);
//
//	    // ⚠️ giả lập trùng thời gian với đơn đã thuê
//	    mhTrung.setThoiGianBatDau(LocalDateTime.now().minusHours(1));
//	    mhTrung.setThoiGianKetThuc(LocalDateTime.now().plusHours(2));
//
//	    boolean trung = service.capNhatMucHang(mhTrung, gh);
//	    System.out.println("Test trùng thời gian: " + trung);
//
//	    // =============================
//	    // 5. TEST XÓA NHIỀU
//	    // =============================
//	    List<Integer> ids = Arrays.asList(1);
//
//	    boolean xoa = service.xoaMucHang(gh, ids);
//	    System.out.println("Xóa nhiều mục: " + xoa);

		// =============================
		// 6. TEST LẤY DANH SÁCH
		// =============================
		List<MucHang> list = null;
		try {
			list = service.layDanhSachMucHangDayDu(gh);
		} catch (Exception e) {
			e.printStackTrace();
		}

	    System.out.println("\n===== DANH SÁCH GIỎ HÀNG =====");

	    for (MucHang item : list) {
	        System.out.println("Mã gói: " + item.getMaGoiThue());
	        System.out.println("Số lượng: " + item.getSoLuong());

	        if (item.getGoiThue() != null) {
	            System.out.println("Tên gói: " + item.getGoiThue().getTenGoiThue());
	            System.out.println("Giá ngày: " + item.getGoiThue().getGiaNgay());
//	            System.out.pr
	        }

	        System.out.println("------------------------");
	    }
	    List<Integer> selected = Arrays.asList(1);

	    double tongTien = service.tinhTongTien(gh, selected);
	    System.out.println("Tổng tiền: " + tongTien);
	}
}
