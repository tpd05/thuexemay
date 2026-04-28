package model;

import java.time.LocalDateTime;

public class MucHang {
    private int maGioHang;
    private int maGoiThue;
    private int soLuong;
    private LocalDateTime thoiGianBatDau;
    private LocalDateTime thoiGianKetThuc;
    
    private GoiThue goiThue;

    public GoiThue getGoiThue() {
		return goiThue;
	}

	public void setGoiThue(GoiThue goiThue) {
		this.goiThue = goiThue;
	}

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
	public double tinhTien() {
	    if (this.goiThue == null) return 0;

	    if (this.thoiGianBatDau == null || this.thoiGianKetThuc == null) {
	        return 0;
	    }

	    // Use minutes for accurate calculation (like JavaScript frontend)
	    long minutes = java.time.Duration.between(
	        this.thoiGianBatDau,
	        this.thoiGianKetThuc
	    ).toMinutes();

	    if (minutes <= 0) return 0;

	    double hours = minutes / 60.0;  // Convert to hours with decimal precision
	    double tien = 0;

	    // New pricing logic: giaNgay + giaTuan (1 week = 7 days = 168 hours)
	    if (hours >= 168) {
	        // >= 1 week: weeks × giaTuan + remainingHours × (giaNgay/24)
	        long weeks = (long)(hours / 168);
	        double remainingHours = hours - (weeks * 168);
	        double remainingDays = remainingHours / 24.0;
	        
	        tien = (weeks * this.goiThue.getGiaTuan()) + 
	               (remainingDays * this.goiThue.getGiaNgay());
	    } else {
	        // < 1 week: days × giaNgay + remainingHours × (giaNgay/24)
	        double days = hours / 24.0;
	        tien = days * this.goiThue.getGiaNgay();
	    }

	    return tien * this.soLuong;
	}
}
