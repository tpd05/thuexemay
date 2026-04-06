package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.util.logging.Logger;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Base64;

import dao.ThanhToanDAO;
import util.Connect;

/**
 * PaymentCallbackServlet
 * 
 * Nhận callback từ Momo sau khi user thanh toán
 * Endpoint: /khachhang/payment-callback (GET/POST)
 * 
 * FLOW:
 * 1. User scan QR + nhập OTP trên Momo app
 * 2. Momo process payment
 * 3. Momo POST callback đến endpoint này
 * 4. Verify signature (security check)
 * 5. Update THANHTOAN status = SUCCESS/FAILED
 * 6. Return response to Momo
 */
@WebServlet("/khachhang/payment-callback")
public class PaymentCallbackServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(PaymentCallbackServlet.class.getName());
    
    // Demo credentials - REPLACE with real from Momo business account
    private static final String PARTNER_CODE = System.getenv("MOMO_PARTNER_CODE") != null ? 
        System.getenv("MOMO_PARTNER_CODE") : "MOMO5W0J7IJ0";
    private static final String ACCESS_KEY = System.getenv("MOMO_ACCESS_KEY") != null ? 
        System.getenv("MOMO_ACCESS_KEY") : "F8BF47D1D07F9454";
    private static final String SECRET_KEY = System.getenv("MOMO_SECRET_KEY") != null ? 
        System.getenv("MOMO_SECRET_KEY") : "cc5e81487edf4541f2b88e8f3bf40db0";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleCallback(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleCallback(request, response);
    }

    /**
     * Xử lý callback từ Momo
     * 
     * Expected parameters từ Momo:
     * - partnerCode
     * - accessKey
     * - requestId        (do ta gửi, unique identifier)
     * - orderId          (do ta gửi)
     * - amount
     * - orderInfo
     * - orderType
     * - transactionId    (từ Momo, dùng để track)
     * - resultCode       (0 = success)
     * - resultDescription
     * - payType
     * - signature        (HMAC-SHA256 verification)
     * - extraData
     * - responseTime
     */
    private void handleCallback(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            // 1️⃣ Lấy parameters từ request (Momo callback)
            String partnerCode = request.getParameter("partnerCode");
            String accessKey = request.getParameter("accessKey");
            String requestId = request.getParameter("requestId");
            String orderId = request.getParameter("orderId");
            String amount = request.getParameter("amount");
            String resultCode = request.getParameter("resultCode");
            String signature = request.getParameter("signature");
            String transactionId = request.getParameter("transactionId");
            String extraData = request.getParameter("extraData");
            
            logger.info("[Callback] Received from Momo: requestId=" + requestId + 
                       ", resultCode=" + resultCode + ", transactionId=" + transactionId);
            
            // 2️⃣ Validate required parameters
            if (requestId == null || signature == null) {
                logger.warning("[Callback] Missing required parameters");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Missing parameters\"}");
                return;
            }
            
            // 3️⃣ Verify signature (SECURITY CHECK)
            // Signature format: HMAC-SHA256(rawData, secretKey)
            // Raw data: accessKey=X&amount=Y&extraData=Z&orderId=...&orderType=...&partnerCode=...&requestId=...&responseTime=...
            
            String rawSignature = buildRawSignature(
                accessKey, 
                amount, 
                extraData != null ? extraData : "", 
                orderId, 
                partnerCode, 
                requestId, 
                request.getParameter("responseTime") != null ? request.getParameter("responseTime") : ""
            );
            
            String expectedSignature = generateSignature(rawSignature, SECRET_KEY);
            
            if (!signature.equals(expectedSignature)) {
                logger.warning("[Callback] Signature mismatch! Expected: " + expectedSignature + 
                             ", Got: " + signature);
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"Invalid signature\"}");
                return;
            }
            
            logger.info("[Callback] Signature verified ✓");
            
            // 4️⃣ Update THANHTOAN in database
            ThanhToanDAO ttDAO = new ThanhToanDAO();
            Connection con = null;
            
            try {
                con = Connect.getInstance().getConnect();
                
                String status = "0".equals(resultCode) ? "SUCCESS" : "FAILED";
                String momoResponse = buildMomoResponse(request);
                
                // Update: status, transactionId, momoResponse
                ttDAO.capNhatTrangThai(
                    requestId, 
                    status, 
                    transactionId != null ? transactionId : "", 
                    momoResponse, 
                    con
                );
                
                logger.info("[Callback] Updated THANHTOAN: requestId=" + requestId + 
                           ", status=" + status);
                
                // 5️⃣ Return success response to Momo
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\":\"ok\"}");
                
            } catch (Exception e) {
                logger.severe("[Callback] Database error: " + e.getMessage());
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"Database error\"}");
            } finally {
                if (con != null) {
                    try { con.close(); } catch (Exception e) {}
                }
            }
            
        } catch (Exception e) {
            logger.severe("[Callback] Exception: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try {
                response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
            } catch (Exception ex) {}
        }
    }

    /**
     * Build raw signature string for verification
     * Format: accessKey=X&amount=Y&extraData=Z&orderId=...&orderType=...&partnerCode=...&requestId=...&responseTime=...
     * 
     * ⚠️ IMPORTANT: Parameters MUST be in alphabetical order!
     */
    private String buildRawSignature(String accessKey, String amount, String extraData, 
                                    String orderId, String partnerCode, String requestId,
                                    String responseTime) {
        // Alphabetical order: a-e-e-o-o-p-r-r
        StringBuilder raw = new StringBuilder();
        raw.append("accessKey=").append(accessKey);
        raw.append("&amount=").append(amount);
        raw.append("&extraData=").append(extraData);
        raw.append("&orderId=").append(orderId);
        raw.append("&partnerCode=").append(partnerCode);
        raw.append("&requestId=").append(requestId);
        raw.append("&responseTime=").append(responseTime);
        
        return raw.toString();
    }

    /**
     * Generate HMAC-SHA256 signature
     * 
     * @param data Raw signature string
     * @param secretKey SECRET_KEY from Momo
     * @return Base64 encoded signature
     */
    private String generateSignature(String data, String secretKey) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey.getBytes(), "HmacSHA256");
            mac.init(secretKeySpec);
            
            byte[] digest = mac.doFinal(data.getBytes());
            return Base64.getEncoder().encodeToString(digest);
        } catch (Exception e) {
            throw new RuntimeException("Error generating signature: " + e.getMessage(), e);
        }
    }

    /**
     * Build JSON response from Momo parameters (for logging/audit)
     */
    private String buildMomoResponse(HttpServletRequest request) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"partnerCode\":\"").append(request.getParameter("partnerCode")).append("\",");
        sb.append("\"requestId\":\"").append(request.getParameter("requestId")).append("\",");
        sb.append("\"resultCode\":\"").append(request.getParameter("resultCode")).append("\",");
        sb.append("\"resultDescription\":\"").append(request.getParameter("resultDescription")).append("\",");
        sb.append("\"transactionId\":\"").append(request.getParameter("transactionId")).append("\",");
        sb.append("\"amount\":").append(request.getParameter("amount")).append(",");
        sb.append("\"responseTime\":\"").append(request.getParameter("responseTime")).append("\"");
        sb.append("}");
        return sb.toString();
    }
}
