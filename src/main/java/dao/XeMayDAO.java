package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.XeMay;
import util.Connect;

public class XeMayDAO {
    private Connection con;

    public XeMayDAO() {
        try {
            this.con = Connect.getInstance().getConnect();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void themXeMay(XeMay xeMay) throws IllegalArgumentException, SQLException {
        if (kiemTraTonTai(xeMay)) {
            throw new IllegalArgumentException("Xe đã tồn tại!!!");
        }
        String sql = "insert into XeMay (maDoiTac, maMauXe, maChiNhanh, trangThai, bienSo, soKhung, soMay) " +
                     "values (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, xeMay.getMaDoiTac());
            ps.setInt(2, xeMay.getMaMauXe());
            ps.setInt(3, xeMay.getMaChiNhanh());
            ps.setString(4, xeMay.getTrangThai());
            ps.setString(5, xeMay.getBienSo());
            ps.setString(6, xeMay.getSoKhung());
            ps.setString(7, xeMay.getSoMay());
            ps.executeUpdate();
        }
    }

    public boolean kiemTraTonTai(XeMay xeMay) {
        String sql = "select 1 from XeMay where bienSo = ? or soKhung = ? or soMay = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, xeMay.getBienSo());
            ps.setString(2, xeMay.getSoKhung());
            ps.setString(3, xeMay.getSoMay());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy toàn bộ xe máy của một đối tác, kèm thông tin hãng/dòng xe từ MauXe.
     */
    public List<XeMay> layDanhSachXeMayTheoDoiTac(int maDoiTac) {
        return truyVanXeMay(
            "select xm.*, mx.hangXe, mx.dongXe, mx.doiXe " +
            "from XeMay xm join MauXe mx on xm.maMauXe = mx.maMauXe " +
            "where xm.maDoiTac = ? order by xm.maXe desc",
            new Object[]{maDoiTac}
        );
    }

    /**
     * Lấy xe máy theo chi nhánh + đối tác (dùng để lọc theo tab chi nhánh).
     */
    public List<XeMay> layDanhSachXeMayTheoChiNhanh(int maChiNhanh, int maDoiTac) {
        return truyVanXeMay(
            "select xm.*, mx.hangXe, mx.dongXe, mx.doiXe " +
            "from XeMay xm join MauXe mx on xm.maMauXe = mx.maMauXe " +
            "where xm.maChiNhanh = ? and xm.maDoiTac = ? order by xm.maXe desc",
            new Object[]{maChiNhanh, maDoiTac}
        );
    }

    // ---- Helper ----
    private List<XeMay> truyVanXeMay(String sql, Object[] params) {
        List<XeMay> list = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                if (params[i] instanceof Integer) ps.setInt(i + 1, (Integer) params[i]);
                else ps.setObject(i + 1, params[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    XeMay xm = new XeMay();
                    xm.setMaXe(rs.getInt("maXe"));
                    xm.setMaDoiTac(rs.getInt("maDoiTac"));
                    xm.setMaMauXe(rs.getInt("maMauXe"));
                    xm.setMaChiNhanh(rs.getInt("maChiNhanh"));
                    xm.setTrangThai(rs.getString("trangThai"));
                    xm.setBienSo(rs.getString("bienSo"));
                    xm.setSoKhung(rs.getString("soKhung"));
                    xm.setSoMay(rs.getString("soMay"));
                    // Extra display fields – set vào transient hoặc dùng wrapper,
                    // ở đây lưu tạm vào hangXe/dongXe nếu model có; nếu không có
                    // thì servlet sẽ đọc thẳng từ ResultSet (xem ThemXeMayServlet).
                    list.add(xm);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}