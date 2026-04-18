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
        String SQL = "select maDonThue, userID, diaChiNhanXe, trangThai " +
                     "from donthue where userID = ? order by maDonThue DESC";
        try (PreparedStatement pstm = con.prepareStatement(SQL)) {
            pstm.setInt(1, userID);
            try (ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    DonThue dt = new DonThue();
                    dt.setMaDonThue(rs.getInt("maDonThue"));
                    dt.setUserID(rs.getInt("userID"));
                    dt.setDiaChiNhanXe(rs.getString("diaChiNhanXe"));
                    dt.setTrangThai(rs.getString("trangThai"));
                    list.add(dt);
                }
            }
        }
        return list;
    }
    
    // Lấy thông tin đơn thuê theo maDonThue (kèm chi tiết)
    public DonThue layDonThueTheoId(int maDonThue, Connection con) throws Exception {
        String SQL = "select maDonThue, userID, diaChiNhanXe, trangThai " +
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
                            dt.setDsChiTiet(dsChiTiet);  
                        }
                    }
                    
                    return dt;
                }
            }
        }
        return null;
    }

    /**
     * Lưu DonThue + tất cả ChiTietDonThue cùng một lúc (atomic)
     * 
     * @param dt: DonThue object (với dsChiTiet)
     * @param con: Connection (connection phải đang mở)
     * @return maDonThue (ID của đơn vừa tạo)
     * @throws Exception nếu có lỗi
     */
    public int luuDonThueVaChiTiet(DonThue dt, Connection con) throws Exception {
        // 1. Tạo DonThue
        String sqlDonThue = "insert into donthue (userID, diaChiNhanXe, trangThai) VALUES (?, ?, ?)";
        
        try (PreparedStatement pstm = con.prepareStatement(sqlDonThue, Statement.RETURN_GENERATED_KEYS)) {
            pstm.setInt(1, dt.getUserID());
            pstm.setString(2, dt.getDiaChiNhanXe());
            pstm.setString(3, dt.getTrangThai());
            
            int affectedRows = pstm.executeUpdate();
            if (affectedRows == 0) {
                throw new RuntimeException("Tạo đơn thuê thất bại");
            }
            
            int maDon = 0;
            try (ResultSet rs = pstm.getGeneratedKeys()) {
                if (rs.next()) {
                    maDon = rs.getInt(1);
                } else {
                    throw new RuntimeException("Không lấy được ID đơn thuê");
                }
            }
            
            // 2. Tạo tất cả ChiTietDonThue
            String sqlChiTiet = "insert into chitietdonthue (maDonThue, maXe, maGoiThue, " +
                               "thoiGianBatDau, thoiGianKetThuc, donGia) VALUES (?, ?, ?, ?, ?, ?)";
            
            if (dt.getDsChiTiet() != null && !dt.getDsChiTiet().isEmpty()) {
                try (PreparedStatement pstmChiTiet = con.prepareStatement(sqlChiTiet)) {
                    for (ChiTietDonThue ct : dt.getDsChiTiet()) {
                        pstmChiTiet.setInt(1, maDon);
                        pstmChiTiet.setInt(2, ct.getMaXe());
                        pstmChiTiet.setInt(3, ct.getMaGoiThue());
                        pstmChiTiet.setTimestamp(4, java.sql.Timestamp.valueOf(ct.getThoiGianBatDau()));
                        pstmChiTiet.setTimestamp(5, java.sql.Timestamp.valueOf(ct.getThoiGianKetThuc()));
                        pstmChiTiet.setInt(6, ct.getDonGia());
                        
                        int rowsInserted = pstmChiTiet.executeUpdate();
                        if (rowsInserted == 0) {
                            throw new RuntimeException("Lưu chi tiết đơn thất bại");
                        }
                    }
                }
            }
            
            return maDon;
        }
    }
}