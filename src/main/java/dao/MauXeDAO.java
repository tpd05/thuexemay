package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.MauXe;
import util.Connect;

public class MauXeDAO {
    private Connection con;

    public MauXeDAO() {
        try {
            this.con = Connect.getInstance().getConnect();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<MauXe> layDanhSachMauXe() {
        List<MauXe> list = new ArrayList<>();
        String sql = "SELECT * FROM MauXe";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToMauXe(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- 2 HÀM BỔ SUNG MỚI VÀO ĐÂY --- //

    public List<MauXe> layDanhSachMauXeTheoDoiTac(int maDoiTac) {
        List<MauXe> list = new ArrayList<>();
        String sql = "SELECT * FROM MauXe WHERE maDoiTac = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maDoiTac);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToMauXe(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<MauXe> layDanhSachMauXeTheoChiNhanh(int maChiNhanh, int maDoiTac) {
        List<MauXe> list = new ArrayList<>();
        String sql = "SELECT * FROM MauXe WHERE maChiNhanh = ? AND maDoiTac = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maChiNhanh);
            ps.setInt(2, maDoiTac);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToMauXe(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --------------------------------- //

    public void themMauXe(MauXe mauXe) throws SQLException {
        if (kiemTraTonTai(mauXe)) {
            throw new IllegalArgumentException("Mẫu xe đã tồn tại!!!");
        }

        String sql = "INSERT INTO MauXe (maDoiTac, maChiNhanh, hangXe, dongXe, doiXe, dungTich, urlHinhAnh) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, mauXe.getMaDoiTac());
            ps.setInt(2, mauXe.getMaChiNhanh());
            ps.setString(3, mauXe.getHangXe());
            ps.setString(4, mauXe.getDongXe());
            ps.setInt(5, mauXe.getDoiXe());
            ps.setFloat(6, mauXe.getDungTich());
            ps.setString(7, mauXe.getUrlHinhAnh());

            ps.executeUpdate();
        }
    }

    public boolean kiemTraTonTai(MauXe mauXe) {
        String sql = "SELECT 1 FROM MauXe WHERE maDoiTac = ? AND maChiNhanh = ? AND hangXe = ? AND dongXe = ? AND doiXe = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, mauXe.getMaDoiTac());
            ps.setInt(2, mauXe.getMaChiNhanh());
            ps.setString(3, mauXe.getHangXe());
            ps.setString(4, mauXe.getDongXe());
            ps.setInt(5, mauXe.getDoiXe());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hàm tiện ích (Helper) để map dữ liệu từ ResultSet sang Object tránh lặp code nhiều lần
    private MauXe mapResultSetToMauXe(ResultSet rs) throws SQLException {
        MauXe mx = new MauXe();
        mx.setMaMauXe(rs.getInt("maMauXe"));
        mx.setMaDoiTac(rs.getInt("maDoiTac"));
        mx.setMaChiNhanh(rs.getInt("maChiNhanh"));
        mx.setHangXe(rs.getString("hangXe"));
        mx.setDongXe(rs.getString("dongXe"));
        mx.setDoiXe(rs.getInt("doiXe"));
        mx.setDungTich(rs.getFloat("dungTich"));
        mx.setUrlHinhAnh(rs.getString("urlHinhAnh"));
        return mx;
    }

    // Lấy mẫu xe theo ID
    public MauXe layMauXeTheoId(int maMauXe, Connection con) throws SQLException {
        String sql = "SELECT * FROM MauXe WHERE maMauXe = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maMauXe);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMauXe(rs);
                }
            }
        }
        return null;
    }
	// Cập nhật mẫu xe
	public void capNhatMauXe(MauXe mauXe) throws SQLException {
		String sql = "UPDATE MauXe SET urlHinhAnh = ? WHERE maMauXe = ?";
		try (PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setString(1, mauXe.getUrlHinhAnh());
			ps.setInt(2, mauXe.getMaMauXe());
			ps.executeUpdate();
		}
	}
	
}