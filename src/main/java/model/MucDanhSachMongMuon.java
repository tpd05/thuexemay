package model;

public class MucDanhSachMongMuon {
	private int maWishList;
    private int maGoiThue;
    
	public MucDanhSachMongMuon() {
		super();
	}
	public MucDanhSachMongMuon(int maWishList, int maGoiThue) {
		super();
		this.maWishList = maWishList;
		this.maGoiThue = maGoiThue;
	}
	public int getMaWishList() {
		return maWishList;
	}
	public void setMaWishList(int maWishList) {
		this.maWishList = maWishList;
	}
	public int getMaGoiThue() {
		return maGoiThue;
	}
	public void setMaGoiThue(int maGoiThue) {
		this.maGoiThue = maGoiThue;
	}

    

}
