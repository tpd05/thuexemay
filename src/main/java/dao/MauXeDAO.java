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
		String sql = "select * from MauXe";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				MauXe mx = new MauXe();
				mx.setMaMauXe(rs.getInt("maMauXe"));
				mx.setMaDoiTac(rs.getInt("maDoiTac"));
				mx.setMaChiNhanh(rs.getInt("maChiNhanh"));
				mx.setHangXe(rs.getString("hangXe"));
				mx.setDongXe(rs.getString("dongXe"));
				mx.setDoiXe(rs.getInt("doiXe"));
				mx.setDungTich(rs.getFloat("dungTich"));
				mx.setUrlHinhAnh(rs.getString("urlHinhAnh"));
				list.add(mx);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	public void themMauXe(MauXe mauXe) throws SQLException {
	    if (kiemTraTonTai(mauXe)) {
	        throw new IllegalArgumentException("Mẫu xe đã tồn tại!!!");
	    }

	    String sql = "insert into MauXe (maDoiTac, maChiNhanh, hangXe, dongXe, doiXe, dungTich, urlHinhAnh) values (?, ?, ?, ?, ?, ?, ?)";

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
	    String sql = "select 1 from MauXe where maDoiTac = ? and maChiNhanh = ? and hangXe = ? and dongXe = ? and doiXe = ?";
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
	
}