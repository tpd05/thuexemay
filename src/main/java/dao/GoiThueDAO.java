package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

	public void themGoiThue(GoiThue goiThue) throws IllegalArgumentException {
		if (kiemTraTonTai(goiThue)) {
			throw new IllegalArgumentException("Gói thuê đã tồn tại!!!!!!!!!!!!!!!!!!");
		}
		String sql = "insert into GoiThue (maMauXe, maDoiTac, maChiNhanh, tenGoiThue, phuKien, giaNgay, giaGio, phuThu, giamGia) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
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
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public boolean kiemTraTonTai(GoiThue goiThue) {
		String sql = "select 1 from GoiThue where tenGoiThue = ? and maMauXe = ? and maDoiTac = ?";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, goiThue.getTenGoiThue());
			ps.setInt(2, goiThue.getMaMauXe());
			ps.setInt(3, goiThue.getMaDoiTac());
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean ktraSoLuong() {
		String sql = "select count(1) from GoiThue";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1) > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public List<GoiThue> timkiemGoiThue(String tuKhoa) {
		List<GoiThue> list = new ArrayList<>();
		String sql = "select * from GoiThue where tenGoiThue like ? or phuKien like ?";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			String chuoi = "%" + tuKhoa + "%";
			ps.setString(1, chuoi);
			ps.setString(2, chuoi);
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
}