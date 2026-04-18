package model;

import java.util.List;

public class DonThue {
	private int maDonThue;
    private int userID;
    private String diaChiNhanXe;
    private String trangThai;
    private List<ChiTietDonThue> dsChiTiet;

    public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

	public List<ChiTietDonThue> getDsChiTiet() {
		return dsChiTiet;
	}

	public void setDsChiTiet(List<ChiTietDonThue> dsChiTiet) {
		this.dsChiTiet = dsChiTiet;
	}

	public DonThue() {}

    public DonThue(int maDonThue, int userID, String diaChiNhanXe, String trangThai) {
        this.maDonThue = maDonThue;
        this.userID = userID;
        this.diaChiNhanXe = diaChiNhanXe;
        this.trangThai = trangThai;
    }

	public int getMaDonThue() {
		return maDonThue;
	}

	public void setMaDonThue(int maDonThue) {
		this.maDonThue = maDonThue;
	}

	public String getDiaChiNhanXe() {
		return diaChiNhanXe;
	}

	public void setDiaChiNhanXe(String diaChiNhanXe) {
		this.diaChiNhanXe = diaChiNhanXe;
	}

	public String getTrangThai() {
		return trangThai;
	}

	public void setTrangThai(String trangThai) {
		this.trangThai = trangThai;
	}

	/**
	 * Tính tổng tiền đơn thuê từ danh sách chi tiết
	 * @return Tổng tiền của tất cả chi tiết đơn
	 */
	public long tinhTongTien() {
		long total = 0;
		if (dsChiTiet != null && !dsChiTiet.isEmpty()) {
			for (ChiTietDonThue ct : dsChiTiet) {
				total += ct.getDonGia();
			}
		}
		return total;
	}
    
}
