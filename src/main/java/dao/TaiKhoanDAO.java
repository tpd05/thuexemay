package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import model.TaiKhoan;
import service.PasswordService;

public class TaiKhoanDAO {
	// Đăng ký
	public int DangKy(TaiKhoan tk, Connection con) throws SQLException {
		String SQL = "insert into taikhoan(username,password,role) values(?,?,?)";
		try (PreparedStatement pstm = con.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {
			pstm.setString(1, tk.getUsername());
			pstm.setString(2, tk.getPassword());
			pstm.setString(3, tk.getRole());
			int rows = pstm.executeUpdate();
			if (rows > 0) {
				try (ResultSet rs = pstm.getGeneratedKeys()) {
					if (rs.next()) {
						int userID = rs.getInt(1);
						tk.setUserID(userID);
						return userID;
					}
				}
			}
		}
		return -1;
	}

	// Đăng nhập
	public boolean DangNhap(TaiKhoan tk, Connection con) throws SQLException {
		String SQL = "select userID, password, role from taikhoan where username=?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, tk.getUsername());
			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					String hashedPassword = rs.getString("password");

					if (PasswordService.KiemTraPassword(tk.getPassword(), hashedPassword)) {
						int userID = rs.getInt("userID");
						String role = rs.getString("role");

						tk.setUserID(userID);
						tk.setRole(role);

						return true;
					}
				}
			}
		}
		return false;
	}

	// Quên mật khẩu
	public boolean QuenMatKhau(String email, String password, Connection con) throws SQLException {
		String SQL = "update TaiKhoan set password = ? where email = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, password);
			pstm.setString(2, email);
			return pstm.executeUpdate() > 0;
		}
	}

	// Kiểm tra trùng username
	public boolean KiemTraUsernameTonTai(String username, Connection con) throws SQLException {
		String SQL = "select 1 from taikhoan where username = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setString(1, username);
			try (ResultSet rs = pstm.executeQuery()) {
				return rs.next();
			}
		}
	}
}
