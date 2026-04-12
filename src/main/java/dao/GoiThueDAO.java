package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.GoiThue;
import util.Connect;

public class GoiThueDAO {
	 private Connection con;

	    public GoiThueDAO() {
	        try {
	            this.con = Connect.getInstance().getConnect();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

	    // FIX: throws SQLException thay vì nuốt lỗi
	    public void themGoiThue(GoiThue goiThue) throws SQLException {
	        String sql = "insert into GoiThue (maMauXe, maDoiTac, maChiNhanh, tenGoiThue, phuKien, giaNgay, giaGio, phuThu, giamGia) " +
	                     "values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	        try (PreparedStatement ps = con.prepareStatement(sql)) {
	            ps.setInt(1, goiThue.getMaMauXe());
	            ps.setInt(2, goiThue.getMaDoiTac());
	            ps.setInt(3, goiThue.getMaChiNhanh());
	            ps.setString(4, goiThue.getTenGoiThue());
	            ps.setString(5, goiThue.getPhuKien());
	            ps.setFloat(6, goiThue.getGiaNgay());
	            ps.setFloat(7, goiThue.getGiaGio());
	            ps.setFloat(8, goiThue.getPhuThu());
	            ps.setFloat(9, goiThue.getGiamGia());
	            ps.executeUpdate();
	        }
	    }

	    public List<GoiThue> timkiemGoiThue(String tuKhoa) {
	        List<GoiThue> list = new ArrayList<>();

	        boolean laSo = true;
	        float giaTimKiem = 0;
	        try {
	            giaTimKiem = Float.parseFloat(tuKhoa.trim());
	        } catch (NumberFormatException e) {
	            laSo = false;
	        }

	        StringBuilder sql = new StringBuilder(
	            "select gt.* from GoiThue gt " +
	            "join MauXe mx on gt.maMauXe = mx.maMauXe " +
	            "where (gt.tenGoiThue like ? or gt.phuKien like ? or mx.hangXe like ? or mx.dongXe like ?) "
	        );
	        if (laSo) {
	            sql.append("or (gt.giaNgay >= ? and gt.giaNgay <= ? or gt.giaGio >= ? and gt.giaGio <= ?) ");
	            sql.append("order by least(abs(gt.giaNgay - ?), abs(gt.giaGio - ?)) asc");
	        }

	        try {
	            PreparedStatement ps = con.prepareStatement(sql.toString());
	            String chuoi = "%" + tuKhoa + "%";
	            ps.setString(1, chuoi);
	            ps.setString(2, chuoi);
	            ps.setString(3, chuoi);
	            ps.setString(4, chuoi);
	            if (laSo) {
	                float bienTrai = giaTimKiem * 0.5f;
	                float bienPhai = giaTimKiem * 1.5f;
	                ps.setFloat(5, bienTrai);
	                ps.setFloat(6, bienPhai);
	                ps.setFloat(7, bienTrai);
	                ps.setFloat(8, bienPhai);
	                ps.setFloat(9, giaTimKiem);
	                ps.setFloat(10, giaTimKiem);
	            }
	            try (ResultSet rs = ps.executeQuery()) {
	                while (rs.next()) {
	                    GoiThue gt = new GoiThue();
	                    gt.setMaGoiThue(rs.getInt("maGoiThue"));
	                    gt.setMaMauXe(rs.getInt("maMauXe"));
	                    gt.setMaDoiTac(rs.getInt("maDoiTac"));
	                    gt.setMaChiNhanh(rs.getInt("maChiNhanh"));
	                    gt.setTenGoiThue(rs.getString("tenGoiThue"));
	                    gt.setPhuKien(rs.getString("phuKien"));
	                    gt.setGiaNgay(rs.getFloat("giaNgay"));
	                    gt.setGiaGio(rs.getFloat("giaGio"));
	                    gt.setPhuThu(rs.getFloat("phuThu"));
	                    gt.setGiamGia(rs.getFloat("giamGia"));
	                    list.add(gt);
	                }
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return list;
	    }

	    public List<GoiThue> layDanhSachTheoDoiTac(int maDoiTac) {
	        List<GoiThue> list = new ArrayList<>();

	        String sql =
	            "SELECT gt.maGoiThue, gt.maMauXe, gt.maChiNhanh, gt.tenGoiThue, " +
	            "       gt.phuKien, gt.giaNgay, gt.giaGio, gt.phuThu, gt.giamGia " +
	            "FROM GoiThue gt " +
	            "WHERE gt.maDoiTac = ? " +
	            "ORDER BY gt.maGoiThue DESC";

	        try (Connection con = Connect.getInstance().getConnect();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, maDoiTac);
	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {
	                GoiThue gt = new GoiThue();

	                gt.setMaGoiThue(rs.getInt("maGoiThue"));
	                gt.setMaMauXe(rs.getInt("maMauXe"));
	                gt.setMaChiNhanh(rs.getInt("maChiNhanh"));
	                gt.setTenGoiThue(rs.getString("tenGoiThue"));
	                gt.setPhuKien(rs.getString("phuKien"));
	                gt.setGiaNgay(rs.getFloat("giaNgay"));
	                gt.setGiaGio(rs.getFloat("giaGio"));
	                gt.setPhuThu(rs.getFloat("phuThu"));
	                gt.setGiamGia(rs.getFloat("giamGia"));

	                list.add(gt);
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return list;
	    }
	    
	    public boolean ktraSoLuong() {
	        String sql = "select count(1) from GoiThue";
	        try {
	            PreparedStatement ps = con.prepareStatement(sql);
	            ResultSet rs = ps.executeQuery();
	            if (rs.next()) return rs.getInt(1) > 0;
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return false;
	    }
	
	public Map<Integer, GoiThue> layDanhSachTheoIds(List<Integer> ids, Connection con) throws SQLException {

	    if (ids == null || ids.isEmpty()) return new HashMap<>();

	    StringBuilder sql = new StringBuilder("select * from goithue where maGoiThue in (");

	    for (int i = 0; i < ids.size(); i++) {
	        sql.append("?");
	        if (i < ids.size() - 1) sql.append(",");
	    }
	    sql.append(")");

	    Map<Integer, GoiThue> map = new HashMap<>();

	    try (PreparedStatement pstm = con.prepareStatement(sql.toString())) {

	        for (int i = 0; i < ids.size(); i++) {
	            pstm.setInt(i + 1, ids.get(i));
	        }

	        ResultSet rs = pstm.executeQuery();

	        while (rs.next()) {
	            GoiThue g = new GoiThue();

	            g.setMaGoiThue(rs.getInt("maGoiThue"));
	            g.setTenGoiThue(rs.getString("tenGoiThue"));
	            g.setGiaNgay(rs.getFloat("giaNgay"));
	            g.setGiaGio(rs.getFloat("giaGio"));
	            g.setPhuThu(rs.getFloat("phuThu"));
	            g.setGiamGia(rs.getFloat("giamGia"));

	            map.put(g.getMaGoiThue(), g);
	        }
	    }

	    return map;
	}
	public int demTongXe(int maGoiThue, Connection con) throws SQLException{
		String SQL = "SELECT COUNT(DISTINCT xm.maXe) as tongXe " +
		             "FROM XeMay xm " +
		             "JOIN GoiThue gt ON xm.maMauXe = gt.maMauXe " +
		             "WHERE gt.maGoiThue = ? " +
		             "AND xm.maChiNhanh = gt.maChiNhanh";

		try(PreparedStatement pstm = con.prepareStatement(SQL)){
			pstm.setInt(1, maGoiThue);
			try(ResultSet rs = pstm.executeQuery()){
				if(rs.next()) {
					return rs.getInt("tongXe");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

		// Lấy tất cả gói thuê (không filter theo DoiTac)
		public List<GoiThue> layTatCaGoiThue(Connection con) throws SQLException {
			List<GoiThue> list = new ArrayList<>();
			String sql = "SELECT gt.maGoiThue, gt.maMauXe, gt.maChiNhanh, gt.maDoiTac, gt.tenGoiThue, " +
						 "       gt.phuKien, gt.giaNgay, gt.giaGio, gt.phuThu, gt.giamGia " +
						 "FROM GoiThue gt " +
						 "ORDER BY gt.maGoiThue DESC";
			try (PreparedStatement ps = con.prepareStatement(sql)) {
				ResultSet rs = ps.executeQuery();
				while (rs.next()) {
					GoiThue gt = new GoiThue();
					gt.setMaGoiThue(rs.getInt("maGoiThue"));
					gt.setMaMauXe(rs.getInt("maMauXe"));
					gt.setMaChiNhanh(rs.getInt("maChiNhanh"));
					gt.setMaDoiTac(rs.getInt("maDoiTac"));
					gt.setTenGoiThue(rs.getString("tenGoiThue"));
					gt.setPhuKien(rs.getString("phuKien"));
					gt.setGiaNgay(rs.getFloat("giaNgay"));
					gt.setGiaGio(rs.getFloat("giaGio"));
					gt.setPhuThu(rs.getFloat("phuThu"));
					gt.setGiamGia(rs.getFloat("giamGia"));
					list.add(gt);
				}
			}
			return list;
		}

		// Lấy gói thuê theo ID
		public GoiThue layGoiThueTheoId(int maGoiThue, Connection con) throws SQLException {
			String sql = "SELECT gt.maGoiThue, gt.maMauXe, gt.maChiNhanh, gt.maDoiTac, gt.tenGoiThue, " +
						 "       gt.phuKien, gt.giaNgay, gt.giaGio, gt.phuThu, gt.giamGia " +
						 "FROM GoiThue gt " +
						 "WHERE gt.maGoiThue = ?";
			try (PreparedStatement ps = con.prepareStatement(sql)) {
				ps.setInt(1, maGoiThue);
				try (ResultSet rs = ps.executeQuery()) {
					if (rs.next()) {
						GoiThue gt = new GoiThue();
						gt.setMaGoiThue(rs.getInt("maGoiThue"));
						gt.setMaMauXe(rs.getInt("maMauXe"));
						gt.setMaChiNhanh(rs.getInt("maChiNhanh"));
						gt.setMaDoiTac(rs.getInt("maDoiTac"));
						gt.setTenGoiThue(rs.getString("tenGoiThue"));
						gt.setPhuKien(rs.getString("phuKien"));
						gt.setGiaNgay(rs.getFloat("giaNgay"));
						gt.setGiaGio(rs.getFloat("giaGio"));
						gt.setPhuThu(rs.getFloat("phuThu"));
						gt.setGiamGia(rs.getFloat("giamGia"));
						return gt;
					}
				}
			}
			return null;
		}
}