package model;

public class GoiThue {
    private int maGoiThue;
    private int maMauXe;
    private int maDoiTac;
    private int maChiNhanh;
    private String tenGoiThue;
    private String phuKien;
    private float giaNgay;
    private float giaTuan;
    private float phuThu;
    public GoiThue() {}

    public GoiThue(int maGoiThue, int maMauXe, int maDoiTac, int maChiNhanh,
                   String tenGoiThue, String phuKien, float giaNgay, float giaTuan,
                   float phuThu) {
        this.maGoiThue = maGoiThue;
        this.maMauXe = maMauXe;
        this.maDoiTac = maDoiTac;
        this.maChiNhanh = maChiNhanh;
        this.tenGoiThue = tenGoiThue;
        this.phuKien = phuKien;
        this.giaNgay = giaNgay;
        this.giaTuan = giaTuan;
        this.phuThu = phuThu;
    }

	public int getMaGoiThue() {
		return maGoiThue;
	}

	public void setMaGoiThue(int maGoiThue) {
		this.maGoiThue = maGoiThue;
	}

	public int getMaMauXe() {
		return maMauXe;
	}

	public void setMaMauXe(int maMauXe) {
		this.maMauXe = maMauXe;
	}

	public int getMaDoiTac() {
		return maDoiTac;
	}

	public void setMaDoiTac(int maDoiTac) {
		this.maDoiTac = maDoiTac;
	}

	public int getMaChiNhanh() {
		return maChiNhanh;
	}

	public void setMaChiNhanh(int maChiNhanh) {
		this.maChiNhanh = maChiNhanh;
	}

	public String getTenGoiThue() {
		return tenGoiThue;
	}

	public void setTenGoiThue(String tenGoiThue) {
		this.tenGoiThue = tenGoiThue;
	}

	public String getPhuKien() {
		return phuKien;
	}

	public void setPhuKien(String phuKien) {
		this.phuKien = phuKien;
	}

	public float getGiaNgay() {
		return giaNgay;
	}

	public void setGiaNgay(float giaNgay) {
		this.giaNgay = giaNgay;
	}

	public float getGiaTuan() {
		return giaTuan;
	}

	public void setGiaTuan(float giaTuan) {
		this.giaTuan = giaTuan;
	}

	public float getPhuThu() {
		return phuThu;
	}

	public void setPhuThu(float phuThu) {
		this.phuThu = phuThu;
	}

}
