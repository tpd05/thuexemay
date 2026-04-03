package service;

import dao.DoiTacDAO;
import dao.KhachHangDAO;
import dao.NguoiDungDao;
import dao.TaiKhoanDAO;
import java.sql.Connection;
import java.sql.SQLException;
import model.DoiTac;
import model.KhachHang;
import model.NguoiDung;
import model.TaiKhoan;
import util.Connect;
import util.Role;

public class AuthService {
    private TaiKhoanDAO tkdao = new TaiKhoanDAO();
    private NguoiDungDao nddao = new NguoiDungDao();

    public int dangKyTaiKhoanNguoiDung(TaiKhoan tk, NguoiDung nd, Connection con) throws SQLException {
        String check = kiemTraDangKyHopLe(tk, nd, con);
        if (!check.equals("OK")) throw new RuntimeException(check);

        tk.setPassword(PasswordService.bamPassword(tk.getPassword()));
        int userid = tkdao.dangKy(tk, con);
        if (userid == -1) throw new RuntimeException("Lỗi tạo tài khoản");

        nd.setUserID(userid);
        if (!nddao.themNguoiDung(nd, con)) throw new RuntimeException("Lỗi tạo thông tin người dùng");
        return userid;
    }

    // FIX: ném RuntimeException với message cụ thể thay vì trả về false âm thầm
    public boolean dangKyTaiKhoanKhachHang(TaiKhoan tk, NguoiDung nd, KhachHang kh) {
        KhachHangDAO khdao = new KhachHangDAO();
        Connection con = null;
        try {
            con = Connect.getInstance().getConnect();
            con.setAutoCommit(false);
            tk.setRole(Role.KHACH_HANG);
            int userID = dangKyTaiKhoanNguoiDung(tk, nd, con);
            kh.setUserID(userID);
            if (!khdao.themKhachHang(userID, con)) {
                con.rollback();
                throw new RuntimeException("Lỗi tạo khách hàng");
            }
            con.commit();
            return true;
        } catch (RuntimeException e) {
            try { if (con != null) con.rollback(); } catch (Exception ignored) {}
            throw e; // ném lại để servlet bắt được message
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ignored) {}
            throw new RuntimeException(e.getMessage());
        } finally {
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (Exception ignored) {}
        }
    }

    public boolean dangKyTaiKhoanDoiTac(TaiKhoan tk, NguoiDung nd, DoiTac dt) {
        DoiTacDAO dtdao = new DoiTacDAO();
        Connection con = null;
        try {
            con = Connect.getInstance().getConnect();
            con.setAutoCommit(false);
            tk.setRole(Role.DOI_TAC);
            int userID = dangKyTaiKhoanNguoiDung(tk, nd, con);
            dt.setUserID(userID);
            if (!dtdao.themDoiTac(userID, con)) {
                con.rollback();
                throw new RuntimeException("Lỗi tạo đối tác");
            }
            con.commit();
            return true;
        } catch (RuntimeException e) {
            try { if (con != null) con.rollback(); } catch (Exception ignored) {}
            throw e;
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ignored) {}
            throw new RuntimeException(e.getMessage());
        } finally {
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (Exception ignored) {}
        }
    }

    public boolean quenMatKhauTaiKhoan(String email, String newPassword) {
        Connection con = null;
        try {
            con = Connect.getInstance().getConnect();
            String hashed = PasswordService.bamPassword(newPassword);
            return tkdao.quenMatKhau(email, hashed, con);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
        return false;
    }

    public TaiKhoan dangNhapTaiKhoan(TaiKhoan tk) {
        Connection con = null;
        try {
            con = Connect.getInstance().getConnect();
            if (tkdao.dangNhap(tk, con)) return tk;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
        return null;
    }

    public String kiemTraDangKyHopLe(TaiKhoan tk, NguoiDung nd, Connection con) throws SQLException {
        if (tk.getUsername() == null || tk.getUsername().trim().isEmpty())
            return "Username không được để trống";
        if (tk.getPassword() == null || tk.getPassword().trim().isEmpty())
            return "Mật khẩu không được để trống";
        if (nd.getHoTen() == null || nd.getHoTen().trim().isEmpty())
            return "Họ tên không được để trống";
        if (nd.getSoDienThoai() == null || nd.getSoDienThoai().trim().isEmpty())
            return "Số điện thoại không được để trống";
        if (nd.getSoCCCD() == null || nd.getSoCCCD().trim().isEmpty())
            return "CCCD không được để trống";
        if (!tk.getUsername().matches("^[a-zA-Z0-9]{4,20}$"))
            return "Username phải từ 4-20 ký tự, không chứa ký tự đặc biệt";
        if (!tk.getPassword().matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$"))
            return "Mật khẩu phải >=8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt";
        if (nd.getEmail() != null && !nd.getEmail().isEmpty())
            if (!nd.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$"))
                return "Email không hợp lệ";
        if (!nd.getSoDienThoai().matches("^0[0-9]{9}$"))
            return "Số điện thoại không hợp lệ";
        if (!nd.getSoCCCD().matches("^[0-9]{12}$"))
            return "CCCD phải gồm 12 chữ số";
        if (tkdao.kiemTraUsernameTonTai(tk.getUsername(), con))
            return "Username đã tồn tại";
        if (nddao.kiemTraSoDienThoaiTonTai(nd.getSoDienThoai(), con))
            return "Số điện thoại đã được sử dụng";
        if (nddao.kiemTraSoCCCDTonTai(nd.getSoCCCD(), con))
            return "CCCD đã tồn tại";
        if (nd.getEmail() != null && !nd.getEmail().isEmpty())
            if (nddao.kiemTraEmailTonTai(nd.getEmail(), con))
                return "Email đã được sử dụng";
        return "OK";
    }

    public String kiemTraDangNhapHopLe(TaiKhoan tk) {
        if (tk.getUsername() == null || tk.getUsername().trim().isEmpty())
            return "Username không được để trống";
        if (tk.getPassword() == null || tk.getPassword().isEmpty())
            return "Mật khẩu không được để trống";
        return "OK";
    }
}