package model;

import java.sql.Timestamp;

public class ThanhToan {
	private int maThanhToan;
	private int maDonThue;
	private float soTien;
	private String phuongThuc;
	private Timestamp thoiGianTao;
	private String trangThai;
	public ThanhToan(int maThanhToan, int maDonThue, float soTien, String phuongThuc, Timestamp thoiGianTao,
		String trangThai) {
		super();
		this.maThanhToan = maThanhToan;
		this.maDonThue = maDonThue;
		this.soTien = soTien;
		this.phuongThuc = phuongThuc;
		this.thoiGianTao = thoiGianTao;
		this.trangThai = trangThai;
	}

	public ThanhToan(int maDonThue, float soTien, String phuongThuc, String trangThai) {
		super();
		this.maDonThue = maDonThue;
		this.soTien = soTien;
		this.phuongThuc = phuongThuc;
		this.trangThai = trangThai;
		this.thoiGianTao = new Timestamp(System.currentTimeMillis());
	}
	public ThanhToan() {
		super();
	}
	public int getMaThanhToan() {
		return maThanhToan;
	}
	public void setMaThanhToan(int maThanhToan) {
		this.maThanhToan = maThanhToan;
	}
	public int getMaDonThue() {
		return maDonThue;
	}
	public void setMaDonThue(int maDonThue) {
		this.maDonThue = maDonThue;
	}
	public float getSoTien() {
		return soTien;
	}
	public void setSoTien(float soTien) {
		this.soTien = soTien;
	}
	public String getPhuongThuc() {
		return phuongThuc;
	}
	public void setPhuongThuc(String phuongThuc) {
		this.phuongThuc = phuongThuc;
	}
	public Timestamp getThoiGianTao() {
		return thoiGianTao;
	}

	public void setThoiGianTao(Timestamp thoiGianTao) {
		this.thoiGianTao = thoiGianTao;
	}

	public String getTrangThai() {
		return trangThai;
	}

	public void setTrangThai(String trangThai) {
		this.trangThai = trangThai;
	}
}

