package model;

public class NguoiDung {
    private int userID;
    private String hoTen;
    private String soDienThoai;
    private String email;
    private boolean trangThaieKYC;
    private String soCCCD;

    public NguoiDung() {}

    public NguoiDung(int userID, String hoTen, String soDienThoai, String email, boolean trangThaieKYC, String soCCCD) {
        this.userID = userID;
        this.hoTen = hoTen;
        this.soDienThoai = soDienThoai;
        this.email = email;
        this.trangThaieKYC = trangThaieKYC;
        this.soCCCD = soCCCD;
    }

	public NguoiDung(String hoTen, String soDienThoai, String email, boolean trangThaieKYC, String soCCCD) {
		super();
		this.hoTen = hoTen;
		this.soDienThoai = soDienThoai;
		this.email = email;
		this.trangThaieKYC = trangThaieKYC;
		this.soCCCD = soCCCD;
	}

	public NguoiDung(String hoTen, String soDienThoai, String email, String soCCCD) {
		super();
		this.hoTen = hoTen;
		this.soDienThoai = soDienThoai;
		this.email = email;
		this.soCCCD = soCCCD;
	}

	public NguoiDung(int userID, String hoTen, String soDienThoai, String email, String soCCCD) {
		super();
		this.userID = userID;
		this.hoTen = hoTen;
		this.soDienThoai = soDienThoai;
		this.email = email;
		this.soCCCD = soCCCD;
	}

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

	public String getHoTen() {
		return hoTen;
	}

	public void setHoTen(String hoTen) {
		this.hoTen = hoTen;
	}

	public String getSoDienThoai() {
		return soDienThoai;
	}

	public void setSoDienThoai(String soDienThoai) {
		this.soDienThoai = soDienThoai;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public boolean isTrangThaieKYC() {
		return trangThaieKYC;
	}

	public void setTrangThaieKYC(boolean trangThaieKYC) {
		this.trangThaieKYC = trangThaieKYC;
	}

	public String getSoCCCD() {
		return soCCCD;
	}

	public void setSoCCCD(String soCCCD) {
		this.soCCCD = soCCCD;
	}
}
