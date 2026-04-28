package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cache.PaymentCache;

/**
 * PaymentStatusServlet - Check payment status for cross-device polling
 *
 * Device A (with QR code) polls this endpoint to check if payment is completed
 * Device B (mock payment page) completes payment
 * Device A detects completion and redirects to /lichsuthuexe
 *
 * Endpoint: GET /khachhang/thanhtoan/status?maThanhToan=X
 * Response: JSON {"completed": true/false, "message": "..."}
 */
@WebServlet("/khachhang/thanhtoan/status")
public class PaymentStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json; charset=UTF-8");
		PrintWriter out = response.getWriter();

		String maThanhToanStr = request.getParameter("maThanhToan");

		System.out.println(">>> PaymentStatusServlet.doGet() called with maThanhToan=" + maThanhToanStr);

		if (maThanhToanStr == null || maThanhToanStr.isEmpty()) {
			System.out.println("ERROR: Missing maThanhToan");
			out.println("{\"error\": \"Thiếu maThanhToan\"}");
			return;
		}

		try {
			int maThanhToan = Integer.parseInt(maThanhToanStr);

			// Check if payment is completed
			boolean isCompleted = PaymentCache.isCompleted(maThanhToan);
			boolean exists = PaymentCache.exists(maThanhToan);

			System.out.println("Cache status - maThanhToan=" + maThanhToan + ", exists=" + exists + ", completed=" + isCompleted);

			if (isCompleted) {
				System.out.println("RETURNING: completed=true");
				out.println("{\"completed\": true, \"message\": \"Thanh toán thành công\"}");
			} else if (exists) {
				System.out.println("RETURNING: completed=false (still pending)");
				out.println("{\"completed\": false, \"message\": \"Chờ xác nhận thanh toán...\"}");
			} else {
				System.out.println("RETURNING: completed=false (expired or not found)");
				out.println("{\"completed\": false, \"message\": \"Mã thanh toán hết hạn hoặc không tồn tại\"}");
			}

		} catch (NumberFormatException e) {
			System.out.println("ERROR: Invalid maThanhToan format");
			out.println("{\"error\": \"maThanhToan không hợp lệ\"}");
		} catch (Exception e) {
			System.out.println("ERROR: " + e.getMessage());
			e.printStackTrace();
			out.println("{\"error\": \"Lỗi: " + e.getMessage() + "\"}");
		}
	}
}
