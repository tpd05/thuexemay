package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.GioHang;

public class GioHangDAO {
	public boolean taoGioHang(GioHang gh, Connection con) throws SQLException {
		String SQL = "insert into giohang(userID, diaChiNhanXe) values(?,?)";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, gh.getUserID());
			pstm.setString(2, gh.getDiaChiNhanXe());
			return pstm.executeUpdate() > 0;
		}
	}
	
	public boolean capNhatDiaChi(GioHang gh, Connection con) throws SQLException{
		String SQL = "update giohang set diaChiNhanXe = ? where maGioHang = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)){
			pstm.setString(1, gh.getDiaChiNhanXe());
			pstm.setInt(2, gh.getMaGioHang());
			return pstm.executeUpdate()>0;
		}
	}
	
	// Lấy giỏ hàng theo userID
	public GioHang layGioHangByUserID(int userID, Connection con) throws SQLException {
		String SQL = "select maGioHang, userID, diaChiNhanXe from giohang where userID = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, userID);
			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					GioHang gh = new GioHang();
					gh.setMaGioHang(rs.getInt("maGioHang"));
					gh.setUserID(rs.getInt("userID"));
					gh.setDiaChiNhanXe(rs.getString("diaChiNhanXe"));
					return gh;
				}
			}
		}
		return null;
	}
}
