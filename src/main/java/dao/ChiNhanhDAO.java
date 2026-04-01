package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.ChiNhanh;
import util.Connect;

public class ChiNhanhDAO {
	private Connection con;

	public ChiNhanhDAO() {
		try {
			this.con = Connect.getInstance().getConnect();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void themChiNhanh(ChiNhanh chiNhanh) throws SQLException {
	    if (kiemTraTonTai(chiNhanh)) {
	        throw new IllegalArgumentException("Chi nhánh đã tồn tại!!!");
	    }

	    String sql = "insert into ChiNhanh (maDoiTac, tenChiNhanh, diaDiem) values (?, ?, ?)";

	    try (PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setInt(1, chiNhanh.getMaDoiTac());
	        ps.setString(2, chiNhanh.getTenChiNhanh());
	        ps.setString(3, chiNhanh.getDiaDiem());

	        ps.executeUpdate();
	    }
	}

	public boolean kiemTraTonTai(ChiNhanh chiNhanh) {
	    String sql = "select 1 from ChiNhanh where maDoiTac = ? and tenChiNhanh = ?";
	    try {
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setInt(1, chiNhanh.getMaDoiTac());
	        ps.setString(2, chiNhanh.getTenChiNhanh());

	        try (ResultSet rs = ps.executeQuery()) {
	            return rs.next();
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	public List<ChiNhanh> layToanBoChiNhanh(int maDoiTac) {
		List<ChiNhanh> list = new ArrayList<>();
		String sql = "select * from ChiNhanh where maDoiTac = ?";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, maDoiTac);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				ChiNhanh cn = new ChiNhanh();
				cn.setMaChiNhanh(rs.getInt("maChiNhanh"));
				cn.setMaDoiTac(rs.getInt("maDoiTac"));
				cn.setTenChiNhanh(rs.getString("tenChiNhanh"));
				cn.setDiaDiem(rs.getString("diaDiem"));
				list.add(cn);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
}