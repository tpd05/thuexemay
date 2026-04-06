package model;

import java.time.LocalDateTime;

public class ThanhToan {
    private int maThanhToan;
    private int maDonThue;
    private long soTien;
    private String phuongThuc;      // EWALLET, CARD
    private String trangThai;        // PENDING, SUCCESS, FAILED, EXPIRED
    private String requestId;        // Momo request ID
    private String transactionId;    // Momo transaction ID
    private LocalDateTime createdAt;
    private LocalDateTime expiredAt;
    private String momoResponse;

    public ThanhToan() {}

	public ThanhToan(int maThanhToan, int maDonThue, long soTien, String phuongThuc, String trangThai,
			String requestId, String transactionId, LocalDateTime createdAt, LocalDateTime expiredAt) {
		this.maThanhToan = maThanhToan;
		this.maDonThue = maDonThue;
		this.soTien = soTien;
		this.phuongThuc = phuongThuc;
		this.trangThai = trangThai;
		this.requestId = requestId;
		this.transactionId = transactionId;
		this.createdAt = createdAt;
		this.expiredAt = expiredAt;
	}

	public int getMaThanhToan() {
		return maThanhToan;
	}

	public void setMaThanhToan(int maThanhToan) {
		this.maThanhToan = maThanhToan;
	}

	public int getMaDonThue() {
		return maDonThue;
	}

	public void setMaDonThue(int maDonThue) {
		this.maDonThue = maDonThue;
	}

	public long getSoTien() {
		return soTien;
	}

	public void setSoTien(long soTien) {
		this.soTien = soTien;
	}

	public String getPhuongThuc() {
		return phuongThuc;
	}

	public void setPhuongThuc(String phuongThuc) {
		this.phuongThuc = phuongThuc;
	}

	public String getTrangThai() {
		return trangThai;
	}

	public void setTrangThai(String trangThai) {
		this.trangThai = trangThai;
	}

	public String getRequestId() {
		return requestId;
	}

	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public LocalDateTime getExpiredAt() {
		return expiredAt;
	}

	public void setExpiredAt(LocalDateTime expiredAt) {
		this.expiredAt = expiredAt;
	}

	public String getMomoResponse() {
		return momoResponse;
	}

	public void setMomoResponse(String momoResponse) {
		this.momoResponse = momoResponse;
	}
    
}
