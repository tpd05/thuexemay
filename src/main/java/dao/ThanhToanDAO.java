package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import model.ThanhToan;

public class ThanhToanDAO {
	
	/**
	 * Tạo bản ghi thanh toán mới
	 */
	public int taoThanhToan(ThanhToan tt, Connection con) throws SQLException {
		String SQL = "INSERT INTO thanhtoan(maDonThue, soTien, phuongThuc, trangThai, requestId, transactionId, createdAt, expiredAt, momoResponse) " +
					 "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		try (PreparedStatement pstm = con.prepareStatement(SQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
			pstm.setInt(1, tt.getMaDonThue());
			pstm.setLong(2, tt.getSoTien());
			pstm.setString(3, tt.getPhuongThuc());
			pstm.setString(4, tt.getTrangThai());
			pstm.setString(5, tt.getRequestId());
			pstm.setString(6, tt.getTransactionId());
			pstm.setTimestamp(7, Timestamp.valueOf(tt.getCreatedAt()));
			
			if (tt.getExpiredAt() != null) {
				pstm.setTimestamp(8, Timestamp.valueOf(tt.getExpiredAt()));
			} else {
				pstm.setNull(8, java.sql.Types.TIMESTAMP);
			}
			
			pstm.setString(9, tt.getMomoResponse());
			
			int result = pstm.executeUpdate();
			
			if (result > 0) {
				try (ResultSet rs = pstm.getGeneratedKeys()) {
					if (rs.next()) {
						return rs.getInt(1);
					}
				}
			}
		}
		return -1;
	}
	
	/**
	 * Cập nhật trạng thái thanh toán
	 */
	public boolean capNhatTrangThai(String requestId, String trangThai, String transactionId, String momoResponse, Connection con) throws SQLException {
		String SQL = "UPDATE thanhtoan SET trangThai = ?, transactionId = ?, momoResponse = ? WHERE requestId = ?";
		
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, trangThai);
			pstm.setString(2, transactionId);
			pstm.setString(3, momoResponse);
			pstm.setString(4, requestId);
			
			return pstm.executeUpdate() > 0;
		}
	}
	
	/**
	 * Cập nhật trạng thái thanh toán (chỉ trangThai)
	 * Dùng cho mock payment
	 */
	public boolean capNhatTrangThaiByRequestId(String requestId, String trangThai, Connection con) throws SQLException {
		String SQL = "UPDATE thanhtoan SET trangThai = ? WHERE requestId = ?";
		
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, trangThai);
			pstm.setString(2, requestId);
			
			return pstm.executeUpdate() > 0;
		}
	}
	
	/**
	 * Lấy thông tin thanh toán theo requestId
	 */
	public ThanhToan layThanhToanByRequestId(String requestId, Connection con) throws SQLException {
		String SQL = "SELECT maThanhToan, maDonThue, soTien, phuongThuc, trangThai, requestId, transactionId, createdAt, expiredAt, momoResponse " +
					 "FROM thanhtoan WHERE requestId = ?";
		
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, requestId);
			
			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					return mapResultSetToThanhToan(rs);
				}
			}
		}
		return null;
	}
	
	/**
	 * Lấy thông tin thanh toán theo maDonThue
	 */
	public ThanhToan layThanhToanByMaDon(int maDonThue, Connection con) throws SQLException {
		String SQL = "SELECT maThanhToan, maDonThue, soTien, phuongThuc, trangThai, requestId, transactionId, createdAt, expiredAt, momoResponse " +
					 "FROM thanhtoan WHERE maDonThue = ? ORDER BY createdAt DESC LIMIT 1";
		
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, maDonThue);
			
			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					return mapResultSetToThanhToan(rs);
				}
			}
		}
		return null;
	}
	
	/**
	 * Lấy thông tin thanh toán theo mã thanh toán
	 */
	public ThanhToan layThanhToanById(int maThanhToan, Connection con) throws SQLException {
		String SQL = "SELECT maThanhToan, maDonThue, soTien, phuongThuc, trangThai, requestId, transactionId, createdAt, expiredAt, momoResponse " +
					 "FROM thanhtoan WHERE maThanhToan = ?";
		
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, maThanhToan);
			
			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					return mapResultSetToThanhToan(rs);
				}
			}
		}
		return null;
	}
	
	/**
	 * Lấy danh sách thanh toán theo mã người dùng
	 */
	public List<ThanhToan> layDanhSachThanhToanByUser(int userID, Connection con) throws SQLException {
		String SQL = "SELECT t.maThanhToan, t.maDonThue, t.soTien, t.phuongThuc, t.trangThai, " +
					 "t.requestId, t.transactionId, t.createdAt, t.expiredAt, t.momoResponse " +
					 "FROM thanhtoan t " +
					 "JOIN dondonthue d ON t.maDonThue = d.maDonThue " +
					 "WHERE d.userID = ? ORDER BY t.createdAt DESC";
		
		List<ThanhToan> list = new ArrayList<>();
		
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, userID);
			
			try (ResultSet rs = pstm.executeQuery()) {
				while (rs.next()) {
					list.add(mapResultSetToThanhToan(rs));
				}
			}
		}
		return list;
	}
	
	/**
	 * Kiểm tra QR hết hạn (quá 3 phút)
	 */
	public boolean isQRExpired(String requestId, Connection con) throws SQLException {
		String SQL = "SELECT expiredAt FROM thanhtoan WHERE requestId = ?";
		
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, requestId);
			
			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					Timestamp expiredAt = rs.getTimestamp("expiredAt");
					if (expiredAt != null) {
						LocalDateTime expired = expiredAt.toLocalDateTime();
						LocalDateTime now = LocalDateTime.now();
						return now.isAfter(expired);
					}
				}
			}
		}
		return false;
	}
	
	/**
	 * Cập nhật QR hết hạn thành EXPIRED
	 */
	public boolean cancelExpiredQR(String requestId, Connection con) throws SQLException {
		String SQL = "UPDATE thanhtoan SET trangThai = 'EXPIRED' WHERE requestId = ? AND trangThai = 'PENDING'";
		
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, requestId);
			return pstm.executeUpdate() > 0;
		}
	}
	
	/**
	 * Map ResultSet to ThanhToan object
	 */
	private ThanhToan mapResultSetToThanhToan(ResultSet rs) throws SQLException {
		ThanhToan tt = new ThanhToan();
		tt.setMaThanhToan(rs.getInt("maThanhToan"));
		tt.setMaDonThue(rs.getInt("maDonThue"));
		tt.setSoTien(rs.getLong("soTien"));
		tt.setPhuongThuc(rs.getString("phuongThuc"));
		tt.setTrangThai(rs.getString("trangThai"));
		tt.setRequestId(rs.getString("requestId"));
		tt.setTransactionId(rs.getString("transactionId"));
		
		Timestamp createdAt = rs.getTimestamp("createdAt");
		if (createdAt != null) {
			tt.setCreatedAt(createdAt.toLocalDateTime());
		}
		
		Timestamp expiredAt = rs.getTimestamp("expiredAt");
		if (expiredAt != null) {
			tt.setExpiredAt(expiredAt.toLocalDateTime());
		}
		
		tt.setMomoResponse(rs.getString("momoResponse"));
		return tt;
	}
}
