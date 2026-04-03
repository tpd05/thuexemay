package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.DoiTac;

public class DoiTacDAO {
	public boolean themDoiTac(int userID, Connection con) throws SQLException {
		String SQL = "insert into doitac(userID) values(?)";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, userID);
			return pstm.executeUpdate() > 0;
		}

	}

	public boolean xoaDoiTac(int userID, Connection con) throws SQLException {
		String SQL = "delete from doitac where userID = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, userID);
			return pstm.executeUpdate() > 0;
		}
	}
}
