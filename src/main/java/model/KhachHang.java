package model;

public class KhachHang  {
    private int maKH;
    private int userID;

    public KhachHang() {}

    public KhachHang(int maKH, int userID) {
        this.maKH = maKH;
        this.userID = userID;
    }

	public int getMaKH() {
		return maKH;
	}

	public void setMaKH(int maKH) {
		this.maKH = maKH;
	}

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

    // Getter & Setter
}
