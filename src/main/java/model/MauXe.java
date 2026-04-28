package model;

public class MauXe {
    private int maMauXe;
    private int maDoiTac;
    private int maChiNhanh;
    private String hangXe;
    private String dongXe;
    private int doiXe;
    private float dungTich;
    private String urlHinhAnh;

    public MauXe() {}

    public MauXe(int maMauXe, int maDoiTac, int maChiNhanh,
                 String hangXe, String dongXe, int doiXe,
                 float dungTich, String urlHinhAnh) {
        this.maMauXe = maMauXe;
        this.maDoiTac = maDoiTac;
        this.maChiNhanh = maChiNhanh;
        this.hangXe = hangXe;
        this.dongXe = dongXe;
        this.doiXe = doiXe;
        this.dungTich = dungTich;
        this.urlHinhAnh = urlHinhAnh;
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

	public int getDoiXe() {
		return doiXe;
	}

	public void setDoiXe(int doiXe) {
		this.doiXe = doiXe;
	}

	public float getDungTich() {
		return dungTich;
	}

	public void setDungTich(float dungTich) {
		this.dungTich = dungTich;
	}

	public String getUrlHinhAnh() {
		return urlHinhAnh;
	}

	public void setUrlHinhAnh(String urlHinhAnh) {
		this.urlHinhAnh = urlHinhAnh;
	}
    
}
