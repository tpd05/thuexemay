package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.MucHang;

public class MucHangDAO {
	public boolean themMucHang(MucHang mh, Connection con) throws SQLException {
		String SQL = "INSERT INTO muchang(maGioHang, maGoiThue, soLuong, thoiGianBatDau, thoiGianKetThuc) VALUES(?,?,?,?,?)";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, mh.getMaGioHang());
			pstm.setInt(2, mh.getMaGoiThue());
			pstm.setInt(3, mh.getSoLuong());
			if (mh.getThoiGianBatDau() != null) {
				pstm.setTimestamp(4, java.sql.Timestamp.valueOf(mh.getThoiGianBatDau()));
			} else {
				pstm.setNull(4, java.sql.Types.TIMESTAMP);
			}

			if (mh.getThoiGianKetThuc() != null) {
				pstm.setTimestamp(5, java.sql.Timestamp.valueOf(mh.getThoiGianKetThuc()));
			} else {
				pstm.setNull(5, java.sql.Types.TIMESTAMP);
			}
			return pstm.executeUpdate() > 0;
		}
	}

	// Kiểm tra và lấy MucHang nếu đã tồn tại
	public MucHang layMucHangByGoiThue(int maGioHang, int maGoiThue, Connection con) throws SQLException {
		String SQL = "SELECT maGioHang, maGoiThue, soLuong, thoiGianBatDau, thoiGianKetThuc FROM muchang WHERE maGioHang = ? AND maGoiThue = ?";
		System.out.println("[MucHangDAO.layMucHangByGoiThue] SQL: " + SQL + " | maGioHang=" + maGioHang + ", maGoiThue=" + maGoiThue);
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, maGioHang);
			pstm.setInt(2, maGoiThue);
			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					System.out.println("[MucHangDAO.layMucHangByGoiThue] FOUND! soLuong=" + rs.getInt("soLuong"));
					MucHang mh = new MucHang();
					mh.setMaGioHang(rs.getInt("maGioHang"));
					mh.setMaGoiThue(rs.getInt("maGoiThue"));
					mh.setSoLuong(rs.getInt("soLuong"));
					if (rs.getTimestamp("thoiGianBatDau") != null) {
						mh.setThoiGianBatDau(rs.getTimestamp("thoiGianBatDau").toLocalDateTime());
					}
					if (rs.getTimestamp("thoiGianKetThuc") != null) {
						mh.setThoiGianKetThuc(rs.getTimestamp("thoiGianKetThuc").toLocalDateTime());
					}
					return mh;
				} else {
					System.out.println("[MucHangDAO.layMucHangByGoiThue] NOT FOUND - Will insert new MucHang");
				}
			}
		} catch (SQLException e) {
			System.out.println("[MucHangDAO.layMucHangByGoiThue] SQLException: " + e.getMessage());
			e.printStackTrace();
			throw e;
		}
		return null;
	}

	public boolean suaMucHang(MucHang mh, Connection con) throws SQLException {
		String SQL = "update muchang set soLuong = ?, thoiGianBatDau = ?, thoiGianKetThuc = ? where maGioHang = ? and maGoiThue = ?";
		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, mh.getSoLuong());
			if (mh.getThoiGianBatDau() != null) {
				pstm.setTimestamp(2, java.sql.Timestamp.valueOf(mh.getThoiGianBatDau()));
			} else {
				pstm.setNull(2, java.sql.Types.TIMESTAMP);
			}

			if (mh.getThoiGianKetThuc() != null) {
				pstm.setTimestamp(3, java.sql.Timestamp.valueOf(mh.getThoiGianKetThuc()));
			} else {
				pstm.setNull(3, java.sql.Types.TIMESTAMP);
			}
			pstm.setInt(4, mh.getMaGioHang());
			pstm.setInt(5, mh.getMaGoiThue());
			return pstm.executeUpdate() > 0;
		}
	}

	public boolean xoaMucHang(int maGioHang, List<Integer> ids, Connection con) throws SQLException {

		String sql;

		if (ids == null || ids.isEmpty()) {
			sql = "DELETE FROM muchang WHERE maGioHang = ?";

			try (PreparedStatement pstm = con.prepareStatement(sql)) {
				pstm.setInt(1, maGioHang);
				return pstm.executeUpdate() > 0;
			}

		} else {
			StringBuilder sb = new StringBuilder("DELETE FROM muchang WHERE maGioHang = ? AND maGoiThue IN (");

			for (int i = 0; i < ids.size(); i++) {
				sb.append("?");
				if (i < ids.size() - 1)
					sb.append(",");
			}
			sb.append(")");

			try (PreparedStatement pstm = con.prepareStatement(sb.toString())) {

				pstm.setInt(1, maGioHang);

				for (int i = 0; i < ids.size(); i++) {
					pstm.setInt(i + 2, ids.get(i));
				}

				return pstm.executeUpdate() > 0;
			}
		}
	}

	public List<MucHang> LayMucHangCuaGio(int maGioHang, Connection con) throws SQLException {

		String SQL = "select maGioHang, maGoiThue, soLuong, thoiGianBatDau, thoiGianKetThuc from muchang where maGioHang = ?";

		List<MucHang> list = new ArrayList<>();

		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, maGioHang);
			ResultSet rs = pstm.executeQuery();

			while (rs.next()) {
				MucHang mh = new MucHang();

				mh.setMaGioHang(rs.getInt("maGioHang"));
				mh.setMaGoiThue(rs.getInt("maGoiThue"));
				mh.setSoLuong(rs.getInt("soLuong"));

				java.sql.Timestamp start = rs.getTimestamp("thoiGianBatDau");
				if (start != null) {
					mh.setThoiGianBatDau(start.toLocalDateTime());
				}

				java.sql.Timestamp end = rs.getTimestamp("thoiGianKetThuc");
				if (end != null) {
					mh.setThoiGianKetThuc(end.toLocalDateTime());
				}

				list.add(mh);
			}
		}

		return list;
	}

	public MucHang timMucHang(int maGioHang, int maGoiThue, Connection con) throws SQLException {

		String SQL = "SELECT * FROM muchang WHERE maGioHang = ? AND maGoiThue = ?";

		try (PreparedStatement pstm = con.prepareStatement(SQL)) {

			pstm.setInt(1, maGioHang);
			pstm.setInt(2, maGoiThue);

			ResultSet rs = pstm.executeQuery();

			if (rs.next()) {
				MucHang mh = new MucHang();

				mh.setMaGioHang(rs.getInt("maGioHang"));
				mh.setMaGoiThue(rs.getInt("maGoiThue"));
				mh.setSoLuong(rs.getInt("soLuong"));

				java.sql.Timestamp start = rs.getTimestamp("thoiGianBatDau");
				if (start != null) {
					mh.setThoiGianBatDau(start.toLocalDateTime());
				}

				java.sql.Timestamp end = rs.getTimestamp("thoiGianKetThuc");
				if (end != null) {
					mh.setThoiGianKetThuc(end.toLocalDateTime());
				}

				return mh;
			}
		}

		return null;
	}

}
