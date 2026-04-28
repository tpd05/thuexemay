package model;

public class ChiNhanh {
    private int maChiNhanh;
    private int maDoiTac;
    private String tenChiNhanh;
    private String diaDiem;

    public ChiNhanh() {}

    public ChiNhanh(int maChiNhanh, int maDoiTac, String tenChiNhanh, String diaDiem) {
        this.maChiNhanh = maChiNhanh;
        this.maDoiTac = maDoiTac;
        this.tenChiNhanh = tenChiNhanh;
        this.diaDiem = diaDiem;
    }

	public int getMaChiNhanh() {
		return maChiNhanh;
	}

	public void setMaChiNhanh(int maChiNhanh) {
		this.maChiNhanh = maChiNhanh;
	}

	public int getMaDoiTac() {
		return maDoiTac;
	}

	public void setMaDoiTac(int maDoiTac) {
		this.maDoiTac = maDoiTac;
	}

	public String getTenChiNhanh() {
		return tenChiNhanh;
	}

	public void setTenChiNhanh(String tenChiNhanh) {
		this.tenChiNhanh = tenChiNhanh;
	}

	public String getDiaDiem() {
		return diaDiem;
	}

	public void setDiaDiem(String diaDiem) {
		this.diaDiem = diaDiem;
	}
}
