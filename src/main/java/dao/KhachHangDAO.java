package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.KhachHang;

public class KhachHangDAO {
	public boolean themKhachHang(int userID, Connection con) throws SQLException {
		String SQL = "insert into khachhang(userID) values(?)";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, userID);
			return pstm.executeUpdate() > 0;
		}

	}

	public boolean xoaKhachHang(int userID, Connection con) throws SQLException {
		String SQL = "delete from khachhang where userID = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, userID);
			return pstm.executeUpdate() > 0;
		}
	}
}
