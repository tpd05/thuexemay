package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import model.ChiTietDonThue;

public class ChiTietDonThueDAO {
	public int demXeDaThue(int maGoiThue, LocalDateTime batDau, LocalDateTime ketThuc, Connection con)
			throws SQLException {

		String SQL = "SELECT COUNT(DISTINCT ct.maXe) as daThue " +
		             "FROM ChiTietDonThue ct " +
		             "JOIN GoiThue gt ON ct.maGoiThue = gt.maGoiThue " +
		             "JOIN DonThue dt ON ct.maDonThue = dt.maDonThue " +
		             "WHERE ct.maGoiThue = ? " +
		             "AND dt.trangThai = 'DA_THANH_TOAN' " +
		             "AND ct.thoiGianBatDau < ? " +
		             "AND ct.thoiGianKetThuc > ?";

		try (PreparedStatement pstm = con.prepareStatement(SQL)) {

			pstm.setInt(1, maGoiThue);
			pstm.setTimestamp(2, java.sql.Timestamp.valueOf(ketThuc));
			pstm.setTimestamp(3, java.sql.Timestamp.valueOf(batDau));

			try (ResultSet rs = pstm.executeQuery()) {
				if (rs.next()) {
					return rs.getInt("daThue");
				}
			}
		}

		return 0;
	}
	public boolean themChiTiet(ChiTietDonThue ct, Connection con) throws SQLException {
	    String SQL = "insert into ChiTietDonThue(maDonThue, maXe, maGoiThue, thoiGianBatDau, thoiGianKetThuc, donGia) values (?, ?, ?, ?, ?, ?)";

	    try (PreparedStatement pstm = con.prepareStatement(SQL)) {
	        pstm.setInt(1, ct.getMaDonThue());
	        pstm.setInt(2, ct.getMaXe());
	        pstm.setInt(3, ct.getMaGoiThue());
	        pstm.setTimestamp(4, Timestamp.valueOf(ct.getThoiGianBatDau()));
	        pstm.setTimestamp(5, Timestamp.valueOf(ct.getThoiGianKetThuc()));
	        pstm.setInt(6, ct.getDonGia());

	        return pstm.executeUpdate() > 0;
	    }
	}

	// Get all chi tiet by maDonThue
	public List<ChiTietDonThue> layChiTietByDonThue(int maDonThue, Connection con) throws SQLException {
		List<ChiTietDonThue> list = new ArrayList<>();
		String SQL = "SELECT maChiTiet, maDonThue, maXe, maGoiThue, thoiGianBatDau, thoiGianKetThuc, thoiGianTra, donGia " +
					 "FROM ChiTietDonThue WHERE maDonThue = ?";

		try (PreparedStatement pstm = con.prepareStatement(SQL)) {
			pstm.setInt(1, maDonThue);
			try (ResultSet rs = pstm.executeQuery()) {
				while (rs.next()) {
					ChiTietDonThue ct = new ChiTietDonThue();
					ct.setMaChiTiet(rs.getInt("maChiTiet"));
					ct.setMaDonThue(rs.getInt("maDonThue"));
					ct.setMaXe(rs.getInt("maXe"));
					ct.setMaGoiThue(rs.getInt("maGoiThue"));
					ct.setThoiGianBatDau(rs.getTimestamp("thoiGianBatDau").toLocalDateTime());
					ct.setThoiGianKetThuc(rs.getTimestamp("thoiGianKetThuc").toLocalDateTime());
					Timestamp traTime = rs.getTimestamp("thoiGianTra");
					if (traTime != null) {
						ct.setThoiGianTra(traTime.toLocalDateTime());
					}
					ct.setDonGia(rs.getInt("donGia"));
					list.add(ct);
				}
			}
		}
		return list;
	}
}
