package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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

	public void themXeMay(XeMay xeMay) throws IllegalArgumentException {
		if (kiemTraTonTai(xeMay)) {
			throw new IllegalArgumentException("Xe đã tồn tại!!!!!!!!!!!!!!!!!!");
		}
		String sql = "insert into XeMay (maDoiTac, maMauXe, maChiNhanh, trangThai, bienSo, soKhung, soMay) values (?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, xeMay.getMaDoiTac());
			ps.setInt(2, xeMay.getMaMauXe());
			ps.setInt(3, xeMay.getMaChiNhanh());
			ps.setString(4, xeMay.getTrangThai());
			ps.setString(5, xeMay.getBienSo());
			ps.setString(6, xeMay.getSoKhung());
			ps.setString(7, xeMay.getSoMay());
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public boolean kiemTraTonTai(XeMay xeMay) {
		String sql = "select 1 from XeMay where bienSo = ? or soKhung = ? or soMay = ?";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
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
}