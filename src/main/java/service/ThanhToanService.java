package service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Logger;

import dao.ThanhToanDAO;
import model.ThanhToan;
import util.Connect;

/**
 * ThanhToanService - Mock Mode Only
 * 
 * Simplified service that only checks payment status from database.
 * All Momo API code has been removed as mock payment mode is sufficient.
 */
public class ThanhToanService {
    
    private static final Logger logger = Logger.getLogger(ThanhToanService.class.getName());
    
    /**
     * Kiểm tra trạng thái thanh toán từ database (Mock Mode)
     * 
     * Flow:
     * 1. Query THANHTOAN by requestId
     * 2. Check if trangThai = "SUCCESS"
     * 3. Return boolean result
     * 
     * @param requestId ID request từ lúc tạo QR
     * @return true nếu đã thanh toán, false nếu chưa
     */
    public static boolean checkPaymentStatus(String requestId) throws Exception {
        
        logger.info("\n🔷 KIỂM TRA TRẠNG THÁI THANH TOÁN");
        logger.info("🔍 requestId: " + requestId);
        
        // Kiểm tra database
        Connection con = null;
        try {
            con = Connect.getInstance().getConnect();
            ThanhToanDAO ttDAO = new ThanhToanDAO();
            
            // Lấy thông tin THANHTOAN từ database
            ThanhToan tt = ttDAO.layThanhToanByRequestId(requestId, con);
            
            if (tt != null && "SUCCESS".equals(tt.getTrangThai())) {
                logger.info("✅ THANH TOÁN THÀNH CÔNG!");
                logger.info("✅ Status: " + tt.getTrangThai() + " | MaDon: " + tt.getMaDonThue());
                return true;
            } else if (tt != null) {
                logger.info("⏳ THANHTOAN status: " + tt.getTrangThai() + " - Chờ xác nhận");
                return false;
            } else {
                logger.warning("⚠️ Không tìm thấy THANHTOAN với requestId: " + requestId);
                return false;
            }
            
        } catch (SQLException e) {
            logger.severe("❌ Lỗi kiểm tra database: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    logger.severe("❌ Lỗi đóng connection: " + e.getMessage());
                }
            }
        }
    }
}
