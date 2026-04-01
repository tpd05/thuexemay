package model;

public class GioHang {
    private int maGioHang;
    private int maKH;
    private String diaChiNhanXe;

    public GioHang() {}

    public GioHang(int maGioHang, int maKH, String diaChiNhanXe) {
        this.maGioHang = maGioHang;
        this.maKH = maKH;
        this.diaChiNhanXe = diaChiNhanXe;
    }

	public int getMaGioHang() {
		return maGioHang;
	}

	public void setMaGioHang(int maGioHang) {
		this.maGioHang = maGioHang;
	}

	public int getMaKH() {
		return maKH;
	}

	public void setMaKH(int maKH) {
		this.maKH = maKH;
	}

	public String getDiaChiNhanXe() {
		return diaChiNhanXe;
	}

	public void setDiaChiNhanXe(String diaChiNhanXe) {
		this.diaChiNhanXe = diaChiNhanXe;
	}
    
}
