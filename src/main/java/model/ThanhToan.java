package model;

import java.time.LocalDateTime;

public class ThanhToan {
    private int maThanhToan;
    private int maDonThue;
    private float soTien;
    private String phuongThuc;
    private String trangThai;
    private LocalDateTime createdAt;

    public ThanhToan() {}

	public ThanhToan(int maThanhToan, int maDonThue, float soTien, String phuongThuc, String trangThai,
			LocalDateTime createdAt) {
		super();
		this.maThanhToan = maThanhToan;
		this.maDonThue = maDonThue;
		this.soTien = soTien;
		this.phuongThuc = phuongThuc;
		this.trangThai = trangThai;
		this.createdAt = createdAt;
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

	public String getTrangThai() {
		return trangThai;
	}

	public void setTrangThai(String trangThai) {
		this.trangThai = trangThai;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
    
}
