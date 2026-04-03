package dao;

import model.DoiTac;
import model.KhachHang;
import model.NguoiDung;
import model.Role;
import model.TaiKhoan;
import service.AuthService;
import util.Connect;

import java.sql.Connection;

public class test {

    public static void main(String[] args) {
        AuthService auth = new AuthService();

//        // ===== TEST ĐĂNG KÝ =====
//        TaiKhoan tk = new TaiKhoan();
//        tk.setUsername("testuser2");
//        tk.setPassword("Abcd1234@"); // password mạnh
//
//        NguoiDung nd = new NguoiDung();
//        nd.setHoTen("Trần Test");
//        nd.setSoDienThoai("0123456797");
//        nd.setEmail("test2@gmail.com");
//        nd.setSoCCCD("123456780023");
//
//        DoiTac kh = new DoiTac();
//
//        System.out.println("===== TEST ĐĂNG KÝ =====");
//
//        boolean dk = auth.dangKyTaiDoiTac(tk, nd, kh);
//
//        if (dk) {
//            System.out.println("Đăng ký thành công");
//        } else {
//            System.out.println("Đăng ký thất bại");
//        }

        // ===== TEST ĐĂNG NHẬP =====
        System.out.println("\n===== TEST ĐĂNG NHẬP =====");

        TaiKhoan loginTK = new TaiKhoan();
        loginTK.setUsername("testuser2");
        loginTK.setPassword("Abcd1234@");

        try {
            Connection con = Connect.getInstance().getConnect();

            TaiKhoanDAO tkdao = new TaiKhoanDAO();

            boolean login = tkdao.dangNhap(loginTK, con);

            if (login) {
                System.out.println("Đăng nhập thành công");
                System.out.println("UserID: " + loginTK.getUserID());
                System.out.println("Role: " + loginTK.getRole().roleName());
            } else {
                System.out.println("Đăng nhập thất bại");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
