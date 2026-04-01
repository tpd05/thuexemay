package model;

public class HoanTien {
	private int maHoanTien;
    private int maDonThue;
    private int soTien;
    private String lyDo;
    private String trangThai;

    public HoanTien() {}

	public HoanTien(int maHoanTien, int maDonThue, int soTien, String lyDo, String trangThai) {
		super();
		this.maHoanTien = maHoanTien;
		this.maDonThue = maDonThue;
		this.soTien = soTien;
		this.lyDo = lyDo;
		this.trangThai = trangThai;
	}

	public int getMaHoanTien() {
		return maHoanTien;
	}

	public void setMaHoanTien(int maHoanTien) {
		this.maHoanTien = maHoanTien;
	}

	public int getMaDonThue() {
		return maDonThue;
	}

	public void setMaDonThue(int maDonThue) {
		this.maDonThue = maDonThue;
	}

	public int getSoTien() {
		return soTien;
	}

	public void setSoTien(int soTien) {
		this.soTien = soTien;
	}

	public String getLyDo() {
		return lyDo;
	}

	public void setLyDo(String lyDo) {
		this.lyDo = lyDo;
	}

	public String getTrangThai() {
		return trangThai;
	}

	public void setTrangThai(String trangThai) {
		this.trangThai = trangThai;
	}
    
}
