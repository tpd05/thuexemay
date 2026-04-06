package model;

public class GioHang {
    private int maGioHang;
    private int userID;
    private String diaChiNhanXe;

    public GioHang() {}

    public GioHang(int maGioHang, int userID, String diaChiNhanXe) {
        this.maGioHang = maGioHang;
        this.userID = userID;
        this.diaChiNhanXe = diaChiNhanXe;
    }

	public int getMaGioHang() {
		return maGioHang;
	}

	public void setMaGioHang(int maGioHang) {
		this.maGioHang = maGioHang;
	}



	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

	public String getDiaChiNhanXe() {
		return diaChiNhanXe;
	}

	public void setDiaChiNhanXe(String diaChiNhanXe) {
		this.diaChiNhanXe = diaChiNhanXe;
	}
    
}
