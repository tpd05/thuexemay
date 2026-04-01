package model;

public class DanhSachMongMuon {
	 private int maDS;
	 private int maKH;

	 public DanhSachMongMuon() {}

	public DanhSachMongMuon(int maDS, int maKH) {
		super();
		this.maDS = maDS;
		this.maKH = maKH;
	}

	public int getMaDS() {
		return maDS;
	}

	public void setMaDS(int maDS) {
		this.maDS = maDS;
	}

	public int getMaKH() {
		return maKH;
	}

	public void setMaKH(int maKH) {
		this.maKH = maKH;
	}
	    
}
