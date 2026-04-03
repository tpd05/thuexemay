package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class KhachHangDAO {

    public boolean themKhachHang(int userID, Connection con) throws SQLException {
        String SQL = "insert into KhachHang(userID) values(?)";
        try (PreparedStatement pstm = con.prepareStatement(SQL)) {
            pstm.setInt(1, userID);
            return pstm.executeUpdate() > 0;
        }
    }

    public boolean xoaKhachHang(int userID, Connection con) throws SQLException {
        String SQL = "delete from KhachHang where userID = ?";
        try (PreparedStatement pstm = con.prepareStatement(SQL)) {
            pstm.setInt(1, userID);
            return pstm.executeUpdate() > 0;
        }
    }
}