package model;

import java.time.LocalDateTime;

public class MucHang {
    private int maGioHang;
    private int maGoiThue;
    private int soLuong;
    private LocalDateTime thoiGianBatDau;
    private LocalDateTime thoiGianKetThuc;

    public MucHang() {}

    public MucHang(int maGioHang, int maGoiThue, int soLuong,
                   LocalDateTime thoiGianBatDau, LocalDateTime thoiGianKetThuc) {
        this.maGioHang = maGioHang;
        this.maGoiThue = maGoiThue;
        this.soLuong = soLuong;
        this.thoiGianBatDau = thoiGianBatDau;
        this.thoiGianKetThuc = thoiGianKetThuc;
    }

	public int getMaGioHang() {
		return maGioHang;
	}

	public void setMaGioHang(int maGioHang) {
		this.maGioHang = maGioHang;
	}

	public int getMaGoiThue() {
		return maGoiThue;
	}

	public void setMaGoiThue(int maGoiThue) {
		this.maGoiThue = maGoiThue;
	}

	public int getSoLuong() {
		return soLuong;
	}

	public void setSoLuong(int soLuong) {
		this.soLuong = soLuong;
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
    
}
