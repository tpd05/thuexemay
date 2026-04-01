package model;

public class NhanVien {
    private int maNV;
    private int userID;

    public NhanVien() {}

    public NhanVien(int maNV, int userID) {
        this.maNV = maNV;
        this.userID = userID;
    }

	public int getMaNV() {
		return maNV;
	}

	public void setMaNV(int maNV) {
		this.maNV = maNV;
	}

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}
    
}
