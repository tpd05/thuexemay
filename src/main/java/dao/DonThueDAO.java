package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.ChiTietDonThue;
import model.DonThue;

public class DonThueDAO {

    public int taoDonThue(DonThue dt, Connection con) throws Exception {

        String SQL = "insert into donthue (userID, diaChiNhanXe, trangThai) VALUES (?, ?, ?)";

        try (PreparedStatement pstm = con.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {

            pstm.setInt(1, dt.getUserID());
            pstm.setString(2, dt.getDiaChiNhanXe());
            pstm.setString(3, dt.getTrangThai());

            int affectedRows = pstm.executeUpdate();

            if (affectedRows == 0) {
                throw new RuntimeException("Tạo đơn thuê thất bại");
            }

            try (ResultSet rs = pstm.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new RuntimeException("Không lấy được ID đơn thuê");
                }
            }
        }
    }

    // Lấy danh sách đơn thuê theo userID
    public List<DonThue> layDanhSachByUserID(int userID, Connection con) throws Exception {
        List<DonThue> list = new ArrayList<>();
        String SQL = "select maDonThue, userID, diaChiNhanXe, trangThai, ngayTao " +
                     "from donthue where userID = ? order by ngayTao DESC";
        try (PreparedStatement pstm = con.prepareStatement(SQL)) {
            pstm.setInt(1, userID);
            try (ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    DonThue dt = new DonThue();
                    dt.setMaDonThue(rs.getInt("maDonThue"));
                    dt.setUserID(rs.getInt("userID"));
                    dt.setDiaChiNhanXe(rs.getString("diaChiNhanXe"));
                    dt.setTrangThai(rs.getString("trangThai"));
                    dt.setNgayTao(rs.getTimestamp("ngayTao"));
                    list.add(dt);
                }
            }
        }
        return list;
    }
    
    // Lấy thông tin đơn thuê theo maDonThue (kèm chi tiết)
    public DonThue layDonThueTheoId(int maDonThue, Connection con) throws Exception {
        String SQL = "select maDonThue, userID, diaChiNhanXe, trangThai, ngayTao " +
                     "from donthue where maDonThue = ?";
        try (PreparedStatement pstm = con.prepareStatement(SQL)) {
            pstm.setInt(1, maDonThue);
            try (ResultSet rs = pstm.executeQuery()) {
                if (rs.next()) {
                    DonThue dt = new DonThue();
                    dt.setMaDonThue(rs.getInt("maDonThue"));
                    dt.setUserID(rs.getInt("userID"));
                    dt.setDiaChiNhanXe(rs.getString("diaChiNhanXe"));
                    dt.setTrangThai(rs.getString("trangThai"));
                    dt.setNgayTao(rs.getTimestamp("ngayTao"));
                    
                    // ✅ Fetch chi tiết đơn để tính tổng tiền
                    String sqlChiTiet = "select maChiTiet, maDonThue, maXe, maGoiThue, " +
                                       "thoiGianBatDau, thoiGianKetThuc, thoiGianTra, donGia " +
                                       "from chitietdonthue where maDonThue = ?";
                    try (PreparedStatement pstmChiTiet = con.prepareStatement(sqlChiTiet)) {
                        pstmChiTiet.setInt(1, maDonThue);
                        try (ResultSet rsChiTiet = pstmChiTiet.executeQuery()) {
                            List<ChiTietDonThue> dsChiTiet = new ArrayList<>();
                            while (rsChiTiet.next()) {
                                ChiTietDonThue ct = new ChiTietDonThue();
                                ct.setMaChiTiet(rsChiTiet.getInt("maChiTiet"));
                                ct.setMaDonThue(rsChiTiet.getInt("maDonThue"));
                                ct.setMaXe(rsChiTiet.getInt("maXe"));
                                ct.setMaGoiThue(rsChiTiet.getInt("maGoiThue"));
                                ct.setThoiGianBatDau(rsChiTiet.getTimestamp("thoiGianBatDau").toLocalDateTime());
                                ct.setThoiGianKetThuc(rsChiTiet.getTimestamp("thoiGianKetThuc").toLocalDateTime());
                                if (rsChiTiet.getTimestamp("thoiGianTra") != null) {
                                    ct.setThoiGianTra(rsChiTiet.getTimestamp("thoiGianTra").toLocalDateTime());
                                }
                                ct.setDonGia(rsChiTiet.getInt("donGia"));
                                dsChiTiet.add(ct);
                            }
                            dt.setDsChiTiet(dsChiTiet);  // ✅ Gán danh sách chi tiết
                        }
                    }
                    
                    return dt;
                }
            }
        }
        return null;
    }
}