package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import model.ThanhToan;

public class ThanhToanDAO {

	// Tạo record thanh toán mới
	public int taoThanhToan(ThanhToan tt, Connection con) throws Exception {
		String sql = "INSERT INTO ThanhToan (maDonThue, soTien, phuongThuc, thoiGianTao, thoiGianThanhToan, trangThai) " +
					 "VALUES (?, ?, ?, ?, ?, ?)";

		try (PreparedStatement pstm = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
			// If maDonThue is 0, set as NULL (will be linked later)
			if (tt.getMaDonThue() <= 0) {
				pstm.setNull(1, java.sql.Types.INTEGER);
			} else {
				pstm.setInt(1, tt.getMaDonThue());
			}
			pstm.setFloat(2, tt.getSoTien());
			pstm.setString(3, tt.getPhuongThuc());
			pstm.setTimestamp(4, tt.getThoiGianTao());
			pstm.setTimestamp(5, tt.getThoiGianThanhToan());
			pstm.setString(6, tt.getTrangThai());

			int affectedRows = pstm.executeUpdate();
			if (affectedRows == 0) {
				throw new RuntimeException("Tạo ghi nhận thanh toán thất bại");
			}

			try (ResultSet rs = pstm.getGeneratedKeys()) {
				if (rs.next()) {
					return rs.getInt(1);
				} else {
					throw new RuntimeException("Không lấy được ID ghi nhận thanh toán");
				}
			}
		}
	}

	// Lấy thanh toán theo ID
	public ThanhToan layThanhToanTheoId(int maThanhToan, Connection con) throws Exception {
		String sql = "SELECT maThanhToan, maDonThue, soTien, phuongThuc, thoiGianTao, thoiGianThanhToan, trangThai " +
					 "FROM ThanhToan WHERE maThanhToan = ?";

		try (PreparedStatement pstm = con.prepareStatement(sql)) {
			pstm.setInt(1, maThanhToan);
			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					return mapResultSetToThanhToan(rs);
				}
			}
		}
		return null;
	}

	// Lấy thanh toán theo maDonThue (order ID)
	public ThanhToan layThanhToanByDonThue(int maDonThue, Connection con) throws Exception {
		String sql = "SELECT maThanhToan, maDonThue, soTien, phuongThuc, thoiGianTao, thoiGianThanhToan, trangThai " +
					 "FROM ThanhToan WHERE maDonThue = ? ORDER BY thoiGianTao DESC LIMIT 1";

		try (PreparedStatement pstm = con.prepareStatement(sql)) {
			pstm.setInt(1, maDonThue);
			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					return mapResultSetToThanhToan(rs);
				}
			}
		}
		return null;
	}

	// Cập nhật trạng thái thanh toán
	public boolean capNhatTrangThai(int maThanhToan, String trangThai, Connection con) throws Exception {
		String sql = "UPDATE ThanhToan SET trangThai = ? WHERE maThanhToan = ?";

		try (PreparedStatement pstm = con.prepareStatement(sql)) {
			pstm.setString(1, trangThai);
			pstm.setInt(2, maThanhToan);

			int affectedRows = pstm.executeUpdate();
			return affectedRows > 0;
		}
	}

	// Helper method
	private ThanhToan mapResultSetToThanhToan(ResultSet rs) throws Exception {
		ThanhToan tt = new ThanhToan();
		tt.setMaThanhToan(rs.getInt("maThanhToan"));
		tt.setMaDonThue(rs.getInt("maDonThue"));
		tt.setSoTien(rs.getFloat("soTien"));
		tt.setPhuongThuc(rs.getString("phuongThuc"));
		tt.setThoiGianTao(rs.getTimestamp("thoiGianTao"));
		tt.setThoiGianThanhToan(rs.getTimestamp("thoiGianThanhToan"));
		tt.setTrangThai(rs.getString("trangThai"));
		return tt;
	}
}
