package model;

public class NhanVien {
    private int userID;

    public NhanVien() {}

    public NhanVien(int userID) {
        this.userID = userID;
    }

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}
    
}
