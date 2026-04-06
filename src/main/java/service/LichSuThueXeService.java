package service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import util.Connect;

/**
 * Service để xử lý lịch sử đơn hàng thuê xe
 */
public class LichSuThueXeService {
    
    /**
     * Lấy danh sách đơn hàng thanh toán của khách hàng
     * 
     * @param userID ID của khách hàng
     * @return Danh sách đơn hàng với thông tin chi tiết
     * @throws SQLException Nếu có lỗi truy vấn database
     */
    public static List<Map<String, Object>> layDanhSachDonThue(int userID) throws SQLException {
        List<Map<String, Object>> donThueDanhSach = new ArrayList<>();
        Connection con = null;
        
        try {
            con = Connect.getInstance().getConnect();
            
            // Query để lấy danh sách đơn thuê với trạng thái DA_THANH_TOAN
            String sql = "SELECT maDonThue, userID, diaChiNhanXe, trangThai FROM DonThue WHERE userID = ? AND trangThai = 'DA_THANH_TOAN' ORDER BY maDonThue DESC";
            
            PreparedStatement pstm = con.prepareStatement(sql);
            pstm.setInt(1, userID);
            ResultSet rs = pstm.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> don = new HashMap<>();
                int maDonThue = rs.getInt("maDonThue");
                
                don.put("maDonThue", maDonThue);
                don.put("diaChiNhanXe", rs.getString("diaChiNhanXe"));
                don.put("trangThai", rs.getString("trangThai"));
                
                // Lấy ngày tạo từ ChiTietDonThue (thời gian bắt đầu của chi tiết đầu tiên)
                java.util.Date ngayTao = layNgayTaoDonThue(maDonThue, con);
                don.put("ngayTao", ngayTao);
                
                // Lấy chi tiết đơn thuê để tính tổng tiền
                long tongTien = tinhTongTienDonThue(maDonThue, con);
                don.put("tongTien", tongTien);
                
                // Đếm số lượng xe trong đơn thuê
                int soLuongXe = demSoLuongXe(maDonThue, con);
                don.put("soLuongXe", soLuongXe);
                
                donThueDanhSach.add(don);
            }
            
            rs.close();
            pstm.close();
            
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return donThueDanhSach;
    }
    
    /**
     * Lấy ngày tạo đơn thuê (từ thời gian bắt đầu của chi tiết đầu tiên)
     * 
     * @param maDonThue ID của đơn thuê
     * @param con Connection đến database
     * @return Ngày tạo của đơn thuê
     * @throws SQLException Nếu có lỗi truy vấn database
     */
    private static java.util.Date layNgayTaoDonThue(int maDonThue, Connection con) throws SQLException {
        String sql = "SELECT MIN(thoiGianBatDau) as ngayTao FROM ChiTietDonThue WHERE maDonThue = ?";
        PreparedStatement pstm = con.prepareStatement(sql);
        pstm.setInt(1, maDonThue);
        ResultSet rs = pstm.executeQuery();
        
        java.util.Date ngayTao = null;
        if (rs.next() && rs.getTimestamp("ngayTao") != null) {
            ngayTao = new java.util.Date(rs.getTimestamp("ngayTao").getTime());
        }
        
        rs.close();
        pstm.close();
        
        return ngayTao;
    }
    
    /**
     * Tính tổng tiền của một đơn thuê
     * 
     * @param maDonThue ID của đơn thuê
     * @param con Connection đến database
     * @return Tổng tiền của đơn thuê
     * @throws SQLException Nếu có lỗi truy vấn database
     */
    private static long tinhTongTienDonThue(int maDonThue, Connection con) throws SQLException {
        String sql = "SELECT SUM(donGia) as tongTien FROM ChiTietDonThue WHERE maDonThue = ?";
        PreparedStatement pstm = con.prepareStatement(sql);
        pstm.setInt(1, maDonThue);
        ResultSet rs = pstm.executeQuery();
        
        long tongTien = 0;
        if (rs.next()) {
            tongTien = rs.getLong("tongTien");
        }
        
        rs.close();
        pstm.close();
        
        return tongTien;
    }
    
    /**
     * Đếm số lượng xe trong một đơn thuê
     * 
     * @param maDonThue ID của đơn thuê
     * @param con Connection đến database
     * @return Số lượng xe
     * @throws SQLException Nếu có lỗi truy vấn database
     */
    private static int demSoLuongXe(int maDonThue, Connection con) throws SQLException {
        String sql = "SELECT COUNT(*) as soLuong FROM ChiTietDonThue WHERE maDonThue = ?";
        PreparedStatement pstm = con.prepareStatement(sql);
        pstm.setInt(1, maDonThue);
        ResultSet rs = pstm.executeQuery();
        
        int soLuong = 0;
        if (rs.next()) {
            soLuong = rs.getInt("soLuong");
        }
        
        rs.close();
        pstm.close();
        
        return soLuong;
    }
}
