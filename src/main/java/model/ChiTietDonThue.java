package model;

import java.time.LocalDateTime;
import java.util.Date;

public class ChiTietDonThue {
	private int maChiTiet;
    private int maDonThue;
    private int maXe;
    private int maGoiThue;
    private LocalDateTime thoiGianBatDau;
    private LocalDateTime thoiGianKetThuc;
    private LocalDateTime thoiGianTra;
    private int donGia;
    
    // Date versions for JSTL fmt:formatDate compatibility
    private Date thoiGianBatDauDate;
    private Date thoiGianKetThucDate;
    
    // Chi tiết mở rộng để hiển thị trên trang thanh toán
    private String tenGoiThue;
    private String tenChiNhanh;
    private String bienSoXe;
    private String soKhung;
    private String soMay;
    private String hangXe;
    private String dongXe;
    private String urlHinhAnh;

    public ChiTietDonThue() {}

	public ChiTietDonThue(int maChiTiet, int maDonThue, int maXe, int maGoiThue, LocalDateTime thoiGianBatDau,
			LocalDateTime thoiGianKetThuc, LocalDateTime thoiGianTra, int donGia) {
		super();
		this.maChiTiet = maChiTiet;
		this.maDonThue = maDonThue;
		this.maXe = maXe;
		this.maGoiThue = maGoiThue;
		this.thoiGianBatDau = thoiGianBatDau;
		this.thoiGianKetThuc = thoiGianKetThuc;
		this.thoiGianTra = thoiGianTra;
		this.donGia = donGia;
	}

	public int getMaChiTiet() {
		return maChiTiet;
	}

	public void setMaChiTiet(int maChiTiet) {
		this.maChiTiet = maChiTiet;
	}

	public int getMaDonThue() {
		return maDonThue;
	}

	public void setMaDonThue(int maDonThue) {
		this.maDonThue = maDonThue;
	}

	public int getMaXe() {
		return maXe;
	}

	public void setMaXe(int maXe) {
		this.maXe = maXe;
	}

	public int getMaGoiThue() {
		return maGoiThue;
	}

	public void setMaGoiThue(int maGoiThue) {
		this.maGoiThue = maGoiThue;
	}

	public LocalDateTime getThoiGianBatDau() {
		return thoiGianBatDau;
	}

	public void setThoiGianBatDau(LocalDateTime thoiGianBatDau) {
		this.thoiGianBatDau = thoiGianBatDau;
	}

	public LocalDateTime getThoiGianKetThuc() {
		return thoiGianKetThuc;
	}

	public void setThoiGianKetThuc(LocalDateTime thoiGianKetThuc) {
		this.thoiGianKetThuc = thoiGianKetThuc;
	}

	public LocalDateTime getThoiGianTra() {
		return thoiGianTra;
	}

	public void setThoiGianTra(LocalDateTime thoiGianTra) {
		this.thoiGianTra = thoiGianTra;
	}

	public int getDonGia() {
		return donGia;
	}

	public void setDonGia(int donGia) {
		this.donGia = donGia;
	}

	public String getTenGoiThue() {
		return tenGoiThue;
	}

	public void setTenGoiThue(String tenGoiThue) {
		this.tenGoiThue = tenGoiThue;
	}

	public String getTenChiNhanh() {
		return tenChiNhanh;
	}

	public void setTenChiNhanh(String tenChiNhanh) {
		this.tenChiNhanh = tenChiNhanh;
	}

	public String getBienSoXe() {
		return bienSoXe;
	}

	public void setBienSoXe(String bienSoXe) {
		this.bienSoXe = bienSoXe;
	}

	public String getSoKhung() {
		return soKhung;
	}

	public void setSoKhung(String soKhung) {
		this.soKhung = soKhung;
	}

	public String getSoMay() {
		return soMay;
	}

	public void setSoMay(String soMay) {
		this.soMay = soMay;
	}

	public String getHangXe() {
		return hangXe;
	}

	public void setHangXe(String hangXe) {
		this.hangXe = hangXe;
	}

	public String getDongXe() {
		return dongXe;
	}

	public void setDongXe(String dongXe) {
		this.dongXe = dongXe;
	}

	public String getUrlHinhAnh() {
		return urlHinhAnh;
	}

	public void setUrlHinhAnh(String urlHinhAnh) {
		this.urlHinhAnh = urlHinhAnh;
	}

	public Date getThoiGianBatDauDate() {
		return thoiGianBatDauDate;
	}

	public void setThoiGianBatDauDate(Date thoiGianBatDauDate) {
		this.thoiGianBatDauDate = thoiGianBatDauDate;
	}

	public Date getThoiGianKetThucDate() {
		return thoiGianKetThucDate;
	}

	public void setThoiGianKetThucDate(Date thoiGianKetThucDate) {
		this.thoiGianKetThucDate = thoiGianKetThucDate;
	}
    
}
