package model;

public class DanhGiaTraiNghiemThue {
	private int maDanhGia;
    private int maDonThue;
    private int maKH;
    private int mucDo;
    private String tieuDe;
    private String noiDung;
    private String trangThaiDuyet;
	public DanhGiaTraiNghiemThue() {
		super();
	}
	public DanhGiaTraiNghiemThue(int maDanhGia, int maDonThue, int maKH, int mucDo, String tieuDe, String noiDung,
			String trangThaiDuyet) {
		super();
		this.maDanhGia = maDanhGia;
		this.maDonThue = maDonThue;
		this.maKH = maKH;
		this.mucDo = mucDo;
		this.tieuDe = tieuDe;
		this.noiDung = noiDung;
		this.trangThaiDuyet = trangThaiDuyet;
	}
	public int getMaDanhGia() {
		return maDanhGia;
	}
	public void setMaDanhGia(int maDanhGia) {
		this.maDanhGia = maDanhGia;
	}
	public int getMaDonThue() {
		return maDonThue;
	}
	public void setMaDonThue(int maDonThue) {
		this.maDonThue = maDonThue;
	}
	public int getMaKH() {
		return maKH;
	}
	public void setMaKH(int maKH) {
		this.maKH = maKH;
	}
	public int getMucDo() {
		return mucDo;
	}
	public void setMucDo(int mucDo) {
		this.mucDo = mucDo;
	}
	public String getTieuDe() {
		return tieuDe;
	}
	public void setTieuDe(String tieuDe) {
		this.tieuDe = tieuDe;
	}
	public String getNoiDung() {
		return noiDung;
	}
	public void setNoiDung(String noiDung) {
		this.noiDung = noiDung;
	}
	public String getTrangThaiDuyet() {
		return trangThaiDuyet;
	}
	public void setTrangThaiDuyet(String trangThaiDuyet) {
		this.trangThaiDuyet = trangThaiDuyet;
	}
    
}
