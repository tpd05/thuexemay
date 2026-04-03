package service;

import java.sql.Connection;
import java.sql.SQLException;

import dao.NguoiDungDao;
import dao.TaiKhoanDAO;
import model.NguoiDung;
import model.TaiKhoan;
import util.Connect;

public class AuthService {
	private TaiKhoanDAO tkdao = new TaiKhoanDAO();
	private NguoiDungDao nddao = new NguoiDungDao();

	// Đăng ký tài khoản người dùng
	public boolean DangKyTaiKhoanNguoiDung(TaiKhoan tk, NguoiDung nd) {
		Connection con = null;
		try {
			con = Connect.getInstance().getConnect();
			con.setAutoCommit(false);

			// Băm mật khẩu
			tk.setPassword(PasswordService.BamPassword(tk.getPassword()));

			int userid = tkdao.DangKy(tk, con);
			if (userid == -1) {
				con.rollback();
				return false;
			}

			nd.setUserID(userid);
			boolean ok = nddao.ThemNguoiDung(nd, con);

			if (!ok) {
				con.rollback();
				return false;
			}
			con.commit();
			return true;
		} catch (SQLException e) {
			try {
				if (con != null)
					con.rollback();
			} catch (Exception e1) {
				e1.printStackTrace();
				// TODO: handle exception
			}
			e.printStackTrace();
		} finally {
			try {
				if (con != null) {
					con.setAutoCommit(true);
					con.close();
				}

			} catch (Exception e) {

				e.printStackTrace();
				// TODO: handle exception
			}
		}
		// TODO Auto-generated catch block
		return false;
	}

	// Quên mật khẩu
	public boolean QuenMatKhauTaiKhoan(String email, String newPassword) {
		Connection con = null;

		try {
			con = Connect.getInstance().getConnect();

			// Băm mật khẩu
			String hashed = PasswordService.BamPassword(newPassword);

			return tkdao.QuenMatKhau(email, hashed, con);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (con != null)
					con.close();
			} catch (Exception e) {
			}
		}

		return false;
	}

	// Kiểm tra giá trị hợp lệ khi đăng ký
	public String KiemTraDangKyHopLe(TaiKhoan tk, NguoiDung nd, Connection con) throws SQLException {

		if (tk.getUsername() == null || tk.getUsername().trim().isEmpty()) {
			return "Username không được để trống";
		}

		if (tk.getPassword() == null || tk.getPassword().trim().isEmpty()) {
			return "Mật khẩu không được để trống";
		}

		if (nd.getHoTen() == null || nd.getHoTen().trim().isEmpty()) {
			return "Họ tên không được để trống";
		}

		if (nd.getSoDienThoai() == null || nd.getSoDienThoai().trim().isEmpty()) {
			return "Số điện thoại không được để trống";
		}

		if (nd.getSoCCCD() == null || nd.getSoCCCD().trim().isEmpty()) {
			return "CCCD không được để trống";
		}

		// Username (chỉ chữ + số, 4-20 ký tự)
		if (!tk.getUsername().matches("^[a-zA-Z0-9]{4,20}$")) {
			return "Username phải từ 4-20 ký tự, không chứa ký tự đặc biệt";
		}

		// Password (>=8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt)
		if (!tk.getPassword().matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$")) {
			return "Mật khẩu phải >=8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt";
		}

		// Email
		if (nd.getEmail() != null && !nd.getEmail().isEmpty()) {
			if (!nd.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
				return "Email không hợp lệ";
			}
		}

		// SĐT (Việt Nam: 10 số)
		if (!nd.getSoDienThoai().matches("^0[0-9]{9}$")) {
			return "Số điện thoại không hợp lệ";
		}

		// CCCD (12 số)
		if (!nd.getSoCCCD().matches("^[0-9]{12}$")) {
			return "CCCD phải gồm 12 chữ số";
		}

		if (tkdao.KiemTraUsernameTonTai(tk.getUsername(), con)) {
			return "Username đã tồn tại";
		}

		if (nddao.KiemTraSoDienThoaiTonTai(nd.getSoDienThoai(), con)) {
			return "Số điện thoại đã được sử dụng";
		}

		if (nddao.KiemTraSoCCCDTonTai(nd.getSoCCCD(), con)) {
			return "CCCD đã tồn tại";
		}

		if (nd.getEmail() != null && !nd.getEmail().isEmpty()) {
			if (nddao.KiemTraEmailTonTai(nd.getEmail(), con)) {
				return "Email đã được sử dụng";
			}
		}

		return "OK";
	}

	// Kiểm tra giá trị hợp lệ khi đăng nhập
	public String KiemTraDangNhapHopLe(TaiKhoan tk, Connection con) {
		// Username không được để trống
		if (tk.getUsername() == null || tk.getUsername().trim().isEmpty()) {
			return "Username không được để trống";
		}

		// Mật khẩu không được để trống
		if (tk.getPassword() == null || tk.getPassword().isEmpty()) {
			return "Mật khẩu không được để trống";
		}
		return "OK";
	}
	public TaiKhoan DangNhapTaiKhoan(TaiKhoan tk) {
	    Connection con = null;
	    try {
	        con = Connect.getInstance().getConnect();

	        boolean kt = tkdao.DangNhap(tk, con);
	        
	        if (kt) {
	            return tk;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (con != null) con.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    return null;
	}
}
