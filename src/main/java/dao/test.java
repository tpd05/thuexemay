package dao;

import java.sql.SQLException;

import model.KhachHang;
import model.NguoiDung;
import model.TaiKhoan;
import service.AuthService;

public class test {
    public static void main(String[] args) {
        AuthService auth = new AuthService();

        // ===== TEST ĐĂNG KÝ =====
        TaiKhoan tk = new TaiKhoan();
        tk.setUsername("testuser1");
        tk.setPassword("Abcd1234@"); 

        NguoiDung nd = new NguoiDung();
        nd.setHoTen("Trần Test");
        nd.setSoDienThoai("0133459797");
        nd.setEmail("test1@gmail.com");
        nd.setSoCCCD("155459780023");

        KhachHang kh = new KhachHang();

        System.out.println("===== TEST ĐĂNG KÝ =====");

        try {
            boolean dk = auth.dangKyTaiKhoanKhachHang(tk, nd, kh);

            if (dk) {
                System.out.println("Đăng ký thành công");
            } else {
                System.out.println("Đăng ký thất bại");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

//        // ===== TEST ĐĂNG NHẬP =====
//        System.out.println("\n===== TEST ĐĂNG NHẬP =====");
//
//        TaiKhoan loginTK = new TaiKhoan();
//        loginTK.setUsername("testuser5");
//        loginTK.setPassword("Abcd1234@");
//
//        try {
//            Connection con = Connect.getInstance().getConnect();
//
//            TaiKhoanDAO tkdao = new TaiKhoanDAO();
//
//            boolean login = tkdao.dangNhap(loginTK, con);
//
//            if (login) {
//                System.out.println("Đăng nhập thành công");
//                System.out.println("UserID: " + loginTK.getUserID());
//                System.out.println("Role: " + loginTK.getRole().roleName());
//            } else {
//                System.out.println("Đăng nhập thất bại");
//            }
//
//            con.close();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }
}
