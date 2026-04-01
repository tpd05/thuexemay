package model;

public class DonThue {
	private int maDonThue;
    private int khID;
    private String diaChiNhanXe;
    private String trangThai;

    public DonThue() {}

    public DonThue(int maDonThue, int khID, String diaChiNhanXe, String trangThai) {
        this.maDonThue = maDonThue;
        this.khID = khID;
        this.diaChiNhanXe = diaChiNhanXe;
        this.trangThai = trangThai;
    }

	public int getMaDonThue() {
		return maDonThue;
	}

	public void setMaDonThue(int maDonThue) {
		this.maDonThue = maDonThue;
	}

	public int getKhID() {
		return khID;
	}

	public void setKhID(int khID) {
		this.khID = khID;
	}

	public String getDiaChiNhanXe() {
		return diaChiNhanXe;
	}

	public void setDiaChiNhanXe(String diaChiNhanXe) {
		this.diaChiNhanXe = diaChiNhanXe;
	}

	public String getTrangThai() {
		return trangThai;
	}

	public void setTrangThai(String trangThai) {
		this.trangThai = trangThai;
	}
    
}
