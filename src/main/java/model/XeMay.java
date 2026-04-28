package model;

public class XeMay {
    private int maXe;
    private int maDoiTac;
    private int maMauXe;
    private int maChiNhanh;
    private String trangThai;
    private String bienSo;
    private String soKhung;
    private String soMay;

    public XeMay() {}

    public XeMay(int maXe, int maDoiTac, int maMauXe, int maChiNhanh,
                 String trangThai, String bienSo, String soKhung, String soMay) {
        this.maXe = maXe;
        this.maDoiTac = maDoiTac;
        this.maMauXe = maMauXe;
        this.maChiNhanh = maChiNhanh;
        this.trangThai = trangThai;
        this.bienSo = bienSo;
        this.soKhung = soKhung;
        this.soMay = soMay;
    }

	public int getMaXe() {
		return maXe;
	}

	public void setMaXe(int maXe) {
		this.maXe = maXe;
	}

	public int getMaDoiTac() {
		return maDoiTac;
	}

	public void setMaDoiTac(int maDoiTac) {
		this.maDoiTac = maDoiTac;
	}

	public int getMaMauXe() {
		return maMauXe;
	}

	public void setMaMauXe(int maMauXe) {
		this.maMauXe = maMauXe;
	}

	public int getMaChiNhanh() {
		return maChiNhanh;
	}

	public void setMaChiNhanh(int maChiNhanh) {
		this.maChiNhanh = maChiNhanh;
	}

	public String getTrangThai() {
		return trangThai;
	}

	public void setTrangThai(String trangThai) {
		this.trangThai = trangThai;
	}

	public String getBienSo() {
		return bienSo;
	}

	public void setBienSo(String bienSo) {
		this.bienSo = bienSo;
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
    
}
