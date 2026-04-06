package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DoiTacDAO {
	
	public int layMaDoiTacTuUserID(int userID, Connection con) throws SQLException {
		String SQL = "select maDoiTac from DoiTac where userID = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, userID);
			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("maDoiTac");
				}
			}
		}
		return -1; // Không tìm thấy
	}
	
	public int themDoiTac(int userID, Connection con) throws SQLException {
		String SQL = "insert into doitac(userID) values(?)";
		try (PreparedStatement pstm = con.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {
			pstm.setInt(1, userID);
			int rows = pstm.executeUpdate();
			
			if (rows <= 0) {
				throw new SQLException("Không thể tạo DoiTac");
			}
			
			// Lấy maDoiTac vừa được tạo
			try (ResultSet rs = pstm.getGeneratedKeys()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}
			
			throw new SQLException("Không thể lấy maDoiTac");
		}
	}

	public boolean xoaDoiTac(int maDoiTac, Connection con) throws SQLException {
		String SQL = "delete from doitac where maDoiTac = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, maDoiTac);
			return pstm.executeUpdate() > 0;
		}
	}
}
