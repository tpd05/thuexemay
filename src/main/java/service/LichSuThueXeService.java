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
    
    /**
     * Lấy danh sách đơn hàng đã thuê (DA_THUE) - Đơn thuê hoàn tất
     * 
     * @param userID ID của khách hàng
     * @return Danh sách đơn hàng
     * @throws SQLException Nếu có lỗi truy vấn database
     */
    public static List<Map<String, Object>> layDanhSachDonDaThue(int userID) throws SQLException {
        List<Map<String, Object>> donThueDanhSach = new ArrayList<>();
        Connection con = null;
        
        try {
            con = Connect.getInstance().getConnect();
            
            String sql = "SELECT maDonThue, userID, diaChiNhanXe, trangThai FROM DonThue WHERE userID = ? AND trangThai = 'DA_THUE' ORDER BY maDonThue DESC";
            
            PreparedStatement pstm = con.prepareStatement(sql);
            pstm.setInt(1, userID);
            ResultSet rs = pstm.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> don = new HashMap<>();
                int maDonThue = rs.getInt("maDonThue");
                
                don.put("maDonThue", maDonThue);
                don.put("diaChiNhanXe", rs.getString("diaChiNhanXe"));
                don.put("trangThai", rs.getString("trangThai"));
                
                java.util.Date ngayTao = layNgayTaoDonThue(maDonThue, con);
                don.put("ngayTao", ngayTao);
                
                java.util.Date ngayKetThuc = layNgayKetThucDonThue(maDonThue, con);
                don.put("ngayKetThuc", ngayKetThuc);
                
                long tongTien = tinhTongTienDonThue(maDonThue, con);
                don.put("tongTien", tongTien);
                
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
     * Lấy danh sách đơn hàng đang thuê - Đơn thuê đang diễn ra (DA_THANH_TOAN + thời gian hiện tại trong khoảng [ngayBatDau, ngayKetThuc])
     * 
     * @param userID ID của khách hàng
     * @return Danh sách đơn hàng
     * @throws SQLException Nếu có lỗi truy vấn database
     */
    public static List<Map<String, Object>> layDanhSachDonDangThue(int userID) throws SQLException {
        List<Map<String, Object>> donThueDanhSach = new ArrayList<>();
        Connection con = null;
        
        try {
            con = Connect.getInstance().getConnect();
            long currentTime = System.currentTimeMillis();
            
            String sql = "SELECT maDonThue, userID, diaChiNhanXe, trangThai FROM DonThue WHERE userID = ? AND trangThai = 'DA_THANH_TOAN' ORDER BY maDonThue DESC";
            
            PreparedStatement pstm = con.prepareStatement(sql);
            pstm.setInt(1, userID);
            ResultSet rs = pstm.executeQuery();
            
            while (rs.next()) {
                int maDonThue = rs.getInt("maDonThue");
                
                java.util.Date ngayBatDau = layNgayTaoDonThue(maDonThue, con);
                java.util.Date ngayKetThuc = layNgayKetThucDonThue(maDonThue, con);
                
                // Chỉ thêm vào danh sách nếu thời gian hiện tại nằm trong khoảng [ngayBatDau, ngayKetThuc]
                if (ngayBatDau != null && ngayKetThuc != null) {
                    long startTime = ngayBatDau.getTime();
                    long endTime = ngayKetThuc.getTime();
                    
                    if (currentTime >= startTime && currentTime <= endTime) {
                        Map<String, Object> don = new HashMap<>();
                        
                        don.put("maDonThue", maDonThue);
                        don.put("diaChiNhanXe", rs.getString("diaChiNhanXe"));
                        don.put("trangThai", rs.getString("trangThai"));
                        don.put("ngayBatDau", ngayBatDau);
                        don.put("ngayKetThuc", ngayKetThuc);
                        
                        long tongTien = tinhTongTienDonThue(maDonThue, con);
                        don.put("tongTien", tongTien);
                        
                        int soLuongXe = demSoLuongXe(maDonThue, con);
                        don.put("soLuongXe", soLuongXe);
                        
                        donThueDanhSach.add(don);
                    }
                }
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
     * Lấy danh sách đơn hàng sắp tới - Đơn thuê đã thanh toán nhưng chưa bắt đầu (DA_THANH_TOAN + thời gian hiện tại < ngayBatDau)
     * 
     * @param userID ID của khách hàng
     * @return Danh sách đơn hàng
     * @throws SQLException Nếu có lỗi truy vấn database
     */
    public static List<Map<String, Object>> layDanhSachDonSapToi(int userID) throws SQLException {
        List<Map<String, Object>> donThueDanhSach = new ArrayList<>();
        Connection con = null;
        
        try {
            con = Connect.getInstance().getConnect();
            long currentTime = System.currentTimeMillis();
            
            String sql = "SELECT maDonThue, userID, diaChiNhanXe, trangThai FROM DonThue WHERE userID = ? AND trangThai = 'DA_THANH_TOAN' ORDER BY maDonThue DESC";
            
            PreparedStatement pstm = con.prepareStatement(sql);
            pstm.setInt(1, userID);
            ResultSet rs = pstm.executeQuery();
            
            while (rs.next()) {
                int maDonThue = rs.getInt("maDonThue");
                
                java.util.Date ngayBatDau = layNgayTaoDonThue(maDonThue, con);
                java.util.Date ngayKetThuc = layNgayKetThucDonThue(maDonThue, con);
                
                // Chỉ thêm vào danh sách nếu thời gian hiện tại < ngayBatDau (chưa bắt đầu)
                if (ngayBatDau != null) {
                    long startTime = ngayBatDau.getTime();
                    
                    if (currentTime < startTime) {
                        Map<String, Object> don = new HashMap<>();
                        
                        don.put("maDonThue", maDonThue);
                        don.put("diaChiNhanXe", rs.getString("diaChiNhanXe"));
                        don.put("trangThai", rs.getString("trangThai"));
                        don.put("ngayBatDau", ngayBatDau);
                        don.put("ngayKetThuc", ngayKetThuc);
                        
                        long tongTien = tinhTongTienDonThue(maDonThue, con);
                        don.put("tongTien", tongTien);
                        
                        int soLuongXe = demSoLuongXe(maDonThue, con);
                        don.put("soLuongXe", soLuongXe);
                        
                        donThueDanhSach.add(don);
                    }
                }
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
     * Lấy ngày kết thúc của đơn thuê
     * 
     * @param maDonThue ID của đơn thuê
     * @param con Connection đến database
     * @return Ngày kết thúc của đơn thuê
     * @throws SQLException Nếu có lỗi truy vấn database
     */
    private static java.util.Date layNgayKetThucDonThue(int maDonThue, Connection con) throws SQLException {
        String sql = "SELECT MAX(thoiGianKetThuc) as ngayKetThuc FROM ChiTietDonThue WHERE maDonThue = ?";
        PreparedStatement pstm = con.prepareStatement(sql);
        pstm.setInt(1, maDonThue);
        ResultSet rs = pstm.executeQuery();
        
        java.util.Date ngayKetThuc = null;
        if (rs.next() && rs.getTimestamp("ngayKetThuc") != null) {
            ngayKetThuc = new java.util.Date(rs.getTimestamp("ngayKetThuc").getTime());
        }
        
        rs.close();
        pstm.close();
        
        return ngayKetThuc;
    }
}
