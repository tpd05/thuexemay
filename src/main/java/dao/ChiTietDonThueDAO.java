package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

import model.ChiTietDonThue;

public class ChiTietDonThueDAO {
	public int demXeDaThue(int maGoiThue, LocalDateTime batDau, LocalDateTime ketThuc, Connection con)
			throws SQLException {

		String SQL = "select COUNT(*) as daThue from ChiTietDonThue where maGoiThue = ? and (thoiGianBatDau < ? and thoiGianKetThuc > ?)";

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
}
