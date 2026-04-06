package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.GioHangDAO;
import dao.ThanhToanDAO;
import model.DonThue;
import model.GioHang;
import model.MucHang;
import model.ThanhToan;
import service.DonThueService;
import service.GioHangService;
import util.Connect;

/**
 * ✅ PAYMENT MOCK SERVLET - Giả lập Momo Payment UI
 * 
 * Flow:
 * 1. GET /khachhang/payment-mock?requestId=XXX → Hiển thị giao diện mock Momo
 * 2. POST /khachhang/payment-mock?action=confirm&requestId=XXX → Xác nhận thanh toán
 *    - Tạo DonThue từ donThueAo
 *    - Set trạng thái DA_THANH_TOAN
 *    - Update ThanhToan status = SUCCESS
 *    - Trả về JSON success
 */
@WebServlet("/khachhang/payment-mock")
public class PaymentMockServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String requestId = request.getParameter("requestId");
		String amount = request.getParameter("amount");
		
		if (requestId == null || amount == null) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters: requestId or amount");
			return;
		}

		// Hiển thị giao diện giả lập thanh toán Momo
		response.setContentType("text/html; charset=UTF-8");
		try (PrintWriter out = response.getWriter()) {
			out.println("<!DOCTYPE html>");
			out.println("<html>");
			out.println("<head>");
			out.println("    <meta charset='UTF-8'>");
			out.println("    <meta name='viewport' content='width=device-width, initial-scale=1.0'>");
			out.println("    <title>MoMo - Xác nhận thanh toán</title>");
			out.println("    <style>");
			out.println("        * { margin: 0; padding: 0; box-sizing: border-box; }");
			out.println("        body {");
			out.println("            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;");
			out.println("            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);");
			out.println("            min-height: 100vh;");
			out.println("            display: flex;");
			out.println("            justify-content: center;");
			out.println("            align-items: center;");
			out.println("            padding: 20px;");
			out.println("        }");
			out.println("        .container {");
			out.println("            background: white;");
			out.println("            border-radius: 12px;");
			out.println("            box-shadow: 0 10px 40px rgba(0,0,0,0.2);");
			out.println("            max-width: 400px;");
			out.println("            width: 100%;");
			out.println("            padding: 30px;");
			out.println("            text-align: center;");
			out.println("        }");
			out.println("        .logo {");
			out.println("            font-size: 32px;");
			out.println("            color: #a50064;");
			out.println("            font-weight: bold;");
			out.println("            margin-bottom: 20px;");
			out.println("        }");
			out.println("        h1 {");
			out.println("            font-size: 24px;");
			out.println("            color: #333;");
			out.println("            margin-bottom: 10px;");
			out.println("        }");
			out.println("        .subtitle {");
			out.println("            color: #666;");
			out.println("            font-size: 14px;");
			out.println("            margin-bottom: 30px;");
			out.println("        }");
			out.println("        .amount-box {");
			out.println("            background: #f5f5f5;");
			out.println("            padding: 20px;");
			out.println("            border-radius: 8px;");
			out.println("            margin: 20px 0;");
			out.println("            border-left: 4px solid #a50064;");
			out.println("        }");
			out.println("        .amount-label {");
			out.println("            color: #666;");
			out.println("            font-size: 12px;");
			out.println("            text-transform: uppercase;");
			out.println("            letter-spacing: 1px;");
			out.println("        }");
			out.println("        .amount-value {");
			out.println("            font-size: 32px;");
			out.println("            color: #a50064;");
			out.println("            font-weight: bold;");
			out.println("            margin: 10px 0;");
			out.println("        }");
			out.println("        .info {");
			out.println("            background: #f0f4ff;");
			out.println("            padding: 15px;");
			out.println("            border-radius: 8px;");
			out.println("            margin: 20px 0;");
			out.println("            font-size: 13px;");
			out.println("            color: #555;");
			out.println("            line-height: 1.6;");
			out.println("        }");
			out.println("        .steps {");
			out.println("            text-align: left;");
			out.println("            margin: 20px 0;");
			out.println("        }");
			out.println("        .step {");
			out.println("            display: flex;");
			out.println("            align-items: center;");
			out.println("            margin: 10px 0;");
			out.println("            font-size: 13px;");
			out.println("        }");
			out.println("        .step-number {");
			out.println("            background: #a50064;");
			out.println("            color: white;");
			out.println("            width: 24px;");
			out.println("            height: 24px;");
			out.println("            border-radius: 50%;");
			out.println("            display: flex;");
			out.println("            align-items: center;");
			out.println("            justify-content: center;");
			out.println("            font-weight: bold;");
			out.println("            margin-right: 10px;");
			out.println("            flex-shrink: 0;");
			out.println("        }");
			out.println("        .buttons {");
			out.println("            display: flex;");
			out.println("            gap: 10px;");
			out.println("            margin-top: 30px;");
			out.println("        }");
			out.println("        button {");
			out.println("            flex: 1;");
			out.println("            padding: 12px 20px;");
			out.println("            border: none;");
			out.println("            border-radius: 8px;");
			out.println("            font-size: 14px;");
			out.println("            font-weight: 600;");
			out.println("            cursor: pointer;");
			out.println("            transition: all 0.3s ease;");
			out.println("        }");
			out.println("        .btn-confirm {");
			out.println("            background: #a50064;");
			out.println("            color: white;");
			out.println("        }");
			out.println("        .btn-confirm:hover {");
			out.println("            background: #850050;");
			out.println("            transform: translateY(-2px);");
			out.println("            box-shadow: 0 4px 12px rgba(165, 0, 100, 0.3);");
			out.println("        }");
			out.println("        .btn-cancel {");
			out.println("            background: #e0e0e0;");
			out.println("            color: #333;");
			out.println("        }");
			out.println("        .btn-cancel:hover {");
			out.println("            background: #d0d0d0;");
			out.println("        }");
			out.println("        .loading {");
			out.println("            display: none;");
			out.println("            text-align: center;");
			out.println("        }");
			out.println("        .spinner {");
			out.println("            border: 4px solid #f3f3f3;");
			out.println("            border-top: 4px solid #a50064;");
			out.println("            border-radius: 50%;");
			out.println("            width: 40px;");
			out.println("            height: 40px;");
			out.println("            animation: spin 1s linear infinite;");
			out.println("            margin: 0 auto 15px;");
			out.println("        }");
			out.println("        @keyframes spin {");
			out.println("            0% { transform: rotate(0deg); }");
			out.println("            100% { transform: rotate(360deg); }");
			out.println("        }");
			out.println("        .success-icon {");
			out.println("            font-size: 48px;");
			out.println("            margin-bottom: 15px;");
			out.println("        }");
			out.println("    </style>");
			out.println("</head>");
			out.println("<body>");
			out.println("    <div class='container'>");
			out.println("        <div id='paymentForm'>");
			out.println("            <div class='logo'>💳 MoMo</div>");
			out.println("            <h1>Xác nhận thanh toán</h1>");
			out.println("            <p class='subtitle'>ThueXeMay.com</p>");
			out.println("");
			out.println("            <div class='amount-box'>");
			out.println("                <div class='amount-label'>Số tiền thanh toán</div>");
			out.println("                <div class='amount-value'>" + String.format("%,d", Long.parseLong(amount)) + " ₫</div>");
			out.println("            </div>");
			out.println("");
			out.println("            <div class='info'>");
			out.println("                📱 Để xác nhận thanh toán, vui lòng nhấn nút '<strong>Xác nhận</strong>' bên dưới");
			out.println("            </div>");
			out.println("");
			out.println("            <div class='steps'>");
			out.println("                <div class='step'>");
			out.println("                    <div class='step-number'>1</div>");
			out.println("                    <div>Kiểm tra thông tin thanh toán</div>");
			out.println("                </div>");
			out.println("                <div class='step'>");
			out.println("                    <div class='step-number'>2</div>");
			out.println("                    <div>Nhấn nút 'Xác nhận' để thanh toán</div>");
			out.println("                </div>");
			out.println("                <div class='step'>");
			out.println("                    <div class='step-number'>3</div>");
			out.println("                    <div>Quay lại để xem lịch sử đơn hàng</div>");
			out.println("                </div>");
			out.println("            </div>");
			out.println("");
			out.println("            <div class='buttons'>");
			out.println("                <button class='btn-confirm' onclick='confirmPayment()'>Xác nhận 💚</button>");
			out.println("                <button class='btn-cancel' onclick='cancelPayment()'>Huỷ</button>");
			out.println("            </div>");
			out.println("        </div>");
			out.println("");
			out.println("        <div id='loadingState' class='loading'>");
			out.println("            <div class='spinner'></div>");
			out.println("            <p>Đang xử lý thanh toán...</p>");
			out.println("        </div>");
			out.println("");
			out.println("        <div id='successState' class='loading'>");
			out.println("            <div class='success-icon'>✅</div>");
			out.println("            <h1>Thanh toán thành công!</h1>");
			out.println("            <p class='subtitle'>Đơn hàng của bạn đã được xác nhận</p>");
			out.println("            <div class='info' style='margin-top: 30px;'>");
			out.println("                Hệ thống sẽ tự động chuyển hướng về lịch sử đơn hàng trong 3 giây...");
			out.println("            </div>");
			out.println("        </div>");
			out.println("    </div>");
			out.println("");
			out.println("    <script>");
			out.println("        const requestId = '" + requestId + "';");
			out.println("        const amount = " + amount + ";");
			out.println("");
			out.println("        function confirmPayment() {");
			out.println("            document.getElementById('paymentForm').style.display = 'none';");
			out.println("            document.getElementById('loadingState').style.display = 'block';");
			out.println("");
			out.println("            // Gửi request xác nhận thanh toán");
			out.println("            const params = new URLSearchParams();");
			out.println("            params.append('action', 'confirm');");
			out.println("            params.append('requestId', requestId);");
			out.println("            params.append('amount', amount);");
			out.println("");
			out.println("            fetch('/thuexemay/khachhang/payment-mock', {");
			out.println("                method: 'POST',");
			out.println("                headers: {'Content-Type': 'application/x-www-form-urlencoded'},");
			out.println("                body: params.toString()");
			out.println("            })");
			out.println("            .then(res => res.json())");
			out.println("            .then(data => {");
			out.println("                if (data.status === 'success') {");
			out.println("                    // ✅ Thành công");
			out.println("                    document.getElementById('loadingState').style.display = 'none';");
			out.println("                    document.getElementById('successState').style.display = 'block';");
			out.println("                    ");
			out.println("                    // Redirect sau 3 giây");
			out.println("                    setTimeout(() => {");
			out.println("                        window.parent.location.href = '/thuexemay/khachhang/lichsuthuexe';");
			out.println("                    }, 3000);");
			out.println("                } else {");
			out.println("                    alert('❌ Lỗi: ' + data.message);");
			out.println("                    cancelPayment();");
			out.println("                }");
			out.println("            })");
			out.println("            .catch(e => {");
			out.println("                alert('❌ Lỗi: ' + e.message);");
			out.println("                cancelPayment();");
			out.println("            });");
			out.println("        }");
			out.println("");
			out.println("        function cancelPayment() {");
			out.println("            window.parent.document.getElementById('momoModal').style.display = 'none';");
			out.println("        }");
			out.println("    </script>");
			out.println("</body>");
			out.println("</html>");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String action = request.getParameter("action");
		if (!"confirm".equals(action)) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.setContentType("application/json; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				out.println("{\"status\":\"error\",\"message\":\"Invalid action\"}");
			}
			return;
		}

		HttpSession session = request.getSession(false);
		String requestId = request.getParameter("requestId");
		String amountStr = request.getParameter("amount");

		response.setContentType("application/json; charset=UTF-8");

		if (requestId == null || amountStr == null) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			try (PrintWriter out = response.getWriter()) {
				out.println("{\"status\":\"error\",\"message\":\"Missing requestId or amount\"}");
			}
			return;
		}

		try {
			long amount = Long.parseLong(amountStr);

			// ========== BƯỚC 1: XÁC ĐỊNH USER ==========
			Integer userID = (session != null) ? (Integer) session.getAttribute("userID") : null;
			
			if (userID == null) {
				// Phone user: sử dụng test user
				userID = 1;
				System.out.println("ℹ️ [MOCK PAYMENT] Phone user - sử dụng test userID: " + userID);
			}

			// ========== BƯỚC 2: LẤY GIỎ HÀNG VÀ MỤC HÀNG ==========
			GioHangDAO gioHangDAO = new GioHangDAO();
			Connection con = Connect.getInstance().getConnect();
			GioHang userCart = gioHangDAO.layGioHangByUserID(userID, con);
			con.close();

			if (userCart == null) {
				throw new Exception("Không tìm thấy giỏ hàng cho userID: " + userID);
			}

			GioHangService ghService = new GioHangService();
			List<MucHang> danhSachMucHang = ghService.layDanhSachMucHangDayDu(userCart);

			if (danhSachMucHang == null || danhSachMucHang.isEmpty()) {
				throw new Exception("Giỏ hàng trống");
			}

			// ========== BƯỚC 3: TẠO DONTHUE ẢO ==========
			DonThueService donService = new DonThueService();
			DonThue donThueAo = donService.taoDonThueAo(userCart, danhSachMucHang);
			
			System.out.println("✅ [MOCK PAYMENT] Tạo DonThueAo thành công:");
			System.out.println("   - UserID: " + donThueAo.getUserID());
			System.out.println("   - Địa chỉ: " + donThueAo.getDiaChiNhanXe());
			System.out.println("   - Chi tiết: " + donThueAo.getDsChiTiet().size() + " mục");

			// ========== BƯỚC 4: LƯU DONTHUE VÀO DB (và xóa giỏ hàng) ==========
			int maDon = donService.xacNhanDonThue(donThueAo);
			
			System.out.println("✅ [MOCK PAYMENT] Lưu DonThue vào DB thành công: " + maDon);

			// ========== BƯỚC 5: TẠO THANHTOAN RECORD ==========
			con = Connect.getInstance().getConnect();
			ThanhToanDAO ttDAO = new ThanhToanDAO();
			ThanhToan tt = new ThanhToan();
			tt.setMaDonThue(maDon);
			tt.setSoTien(amount);
			tt.setPhuongThuc(session != null && session.getAttribute("paymentMethod") != null ? 
				(String) session.getAttribute("paymentMethod") : "EWALLET");
			tt.setTrangThai("SUCCESS");
			tt.setRequestId(requestId);
			tt.setCreatedAt(LocalDateTime.now());
			tt.setExpiredAt(LocalDateTime.now().plusMinutes(15));
			tt.setMomoResponse("{\"resultCode\":0,\"message\":\"MockMode - Payment Confirmed\"}");
			
			ttDAO.taoThanhToan(tt, con);
			con.close();
			
			System.out.println("✅ [MOCK PAYMENT] Tạo ThanhToan thành công: " + maDon);

			// ========== BƯỚC 6: CLEAR SESSION ==========
			if (session != null) {
				session.removeAttribute("donThueAo");
			}

			// Trả về JSON success
			try (PrintWriter out = response.getWriter()) {
				out.println("{\"status\":\"success\",\"message\":\"Thanh toán thành công\",\"maDon\":" + maDon + "}");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			try (PrintWriter out = response.getWriter()) {
				out.println("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
			}
		}
	}
}
