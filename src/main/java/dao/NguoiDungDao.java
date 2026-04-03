package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.NguoiDung;

public class NguoiDungDao {
//Thêm thông tin người dùng
	public boolean themNguoiDung(NguoiDung nd, Connection con) throws SQLException {
		String SQL = "insert into NguoiDung(userID, hoTen, soDienThoai, email, soCCCD) values(?,?,?,?,?)";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, nd.getUserID());
			pstm.setString(2, nd.getHoTen());
			pstm.setString(3, nd.getSoDienThoai());
			pstm.setString(4, nd.getEmail());
			pstm.setString(5, nd.getSoCCCD());
			return pstm.executeUpdate() > 0;
		}
	}

//Sửa thông tin người dùng
	public boolean suaNguoiDung(NguoiDung nd, Connection con) throws SQLException {
		String SQL = "update NguoiDung set hoTen = ?, soDienThoai = ?, email = ?, trangThaieKYC = ?, soCCCD = ? where userID = ? ";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, nd.getHoTen());
			pstm.setString(2, nd.getSoDienThoai());
			pstm.setString(3, nd.getEmail());
			pstm.setBoolean(4, nd.isTrangThaieKYC());
			pstm.setString(5, nd.getSoCCCD());
			pstm.setInt(6, nd.getUserID());
			return pstm.executeUpdate() > 0;
		}
	}

//Xóa người dùng
	public boolean xoaNguoiDung(int id, Connection con) throws SQLException {
		String SQL = "delete from NguoiDung where userID = ? ";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, id);
			return pstm.executeUpdate() > 0;
		}
	}

//Kiểm tra trùng số điện thoại
	public boolean kiemTraSoDienThoaiTonTai(String soDienThoai, Connection con) throws SQLException {
		String SQL = "select 1 from nguoidung where soDienThoai = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, soDienThoai);
			try (ResultSet rs = pstm.executeQuery()) {
				return rs.next();
			}
		}
	}

//Kiểm tra trùng email
	public boolean kiemTraEmailTonTai(String email, Connection con) throws SQLException {
		String SQL = "select 1 from nguoidung where email = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, email);
			try (ResultSet rs = pstm.executeQuery()) {
				return rs.next();
			}
		}
	}

//Kiểm tra trùng số CCCD
	public boolean kiemTraSoCCCDTonTai(String socccd, Connection con) throws SQLException {
		String SQL = "select 1 from nguoidung where socccd = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, socccd);
			try (ResultSet rs = pstm.executeQuery()) {
				return rs.next();
			}
		}
	}
}
