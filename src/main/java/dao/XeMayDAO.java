package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
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
                    list.add(xm);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

	public List<Integer> layXeTrong(int maGoiThue, LocalDateTime batDau, LocalDateTime ketThuc, Connection con)
			throws SQLException {

		String SQL = """
				SELECT xm.maXe
				FROM XeMay xm
				JOIN GoiThue gt ON xm.maMauXe = gt.maMauXe
				WHERE gt.maGoiThue = ?
				AND xm.trangThai = 'san_sang'
				AND xm.maXe NOT IN (
					SELECT ct.maXe
					FROM ChiTietDonThue ct
					WHERE ct.maGoiThue = ?
					AND ct.thoiGianBatDau < ?
					AND ct.thoiGianKetThuc > ?
				)
				""";

		List<Integer> list = new ArrayList<>();

		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, maGoiThue);
			pstm.setInt(2, maGoiThue);          // ← FIX: Kiểm tra bikes chỉ của CÙNG GoiThue
			pstm.setTimestamp(3, Timestamp.valueOf(ketThuc));   // request end
			pstm.setTimestamp(4, Timestamp.valueOf(batDau));    // request start

			try (ResultSet rs = pstm.executeQuery()) {
				while (rs.next()) {
					list.add(rs.getInt("maXe"));
				}
			}
		}

		return list;
	}

    public XeMay timXeTheoId(int maXe, Connection con) {
        String sql = "select xm.*, mx.hangXe, mx.dongXe, mx.doiXe from XeMay xm join MauXe mx on xm.maMauXe = mx.maMauXe where xm.maXe = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maXe);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    XeMay xe = new XeMay();
                    xe.setMaXe(rs.getInt("maXe"));
                    xe.setMaDoiTac(rs.getInt("maDoiTac"));
                    xe.setMaMauXe(rs.getInt("maMauXe"));
                    xe.setMaChiNhanh(rs.getInt("maChiNhanh"));
                    xe.setTrangThai(rs.getString("trangThai"));
                    xe.setBienSo(rs.getString("bienSo"));
                    xe.setSoKhung(rs.getString("soKhung"));
                    xe.setSoMay(rs.getString("soMay"));
                    return xe;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}