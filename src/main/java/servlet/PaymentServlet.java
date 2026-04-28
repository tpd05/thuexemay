package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cache.PaymentCache;
import model.DonThue;
import service.ThanhToanService;

/**
 * PaymentServlet - Xử lý thanh toán (Redesigned)
 *
 * Flow:
 * - GET /khachhang/thanhtoan → Show payment page (get DonThueAo from session created by GioHangServlet)
 * - POST /khachhang/thanhtoan?action=taoQR → Create ThanhToan in DB, return maThanhToan for mock payment
 * - GET /khachhang/thanhtoan/mock?maThanhToan=X → PUBLIC PAGE - validate from DB, simulate payment
 * - /khachhang/thanhtoan/callback → Callback from mock payment (update DB status, save DonThue)
 */
@WebServlet("/khachhang/thanhtoan")
public class PaymentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Integer userID = (Integer) session.getAttribute("userID");

		// Check authentication
		if (userID == null) {
			response.sendRedirect(request.getContextPath() + "/views/auth/dangnhap.jsp");
			return;
		}

		try {
			// Lấy DonThueAo từ session (được tạo từ GioHangServlet.prepareCheckout)
			DonThue donThueAo = (DonThue) session.getAttribute("donThueAo");
			if (donThueAo == null) {
				// Không có đơn ảo, redirect về giỏ hàng
				response.sendRedirect(request.getContextPath() + "/khachhang/giohang");
				return;
			}

			// Tính tổng tiền
			double soTien = ThanhToanService.tinhTongTienDonThue(donThueAo.getDsChiTiet());

			// Set attributes for JSP
			request.setAttribute("donThueAo", donThueAo);
			request.setAttribute("soTien", soTien);

			// Forward to thanhtoan.jsp
			request.getRequestDispatcher("/views/khachhang/thanhtoan.jsp").forward(request, response);

		} catch (Exception e) {
			request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
			request.getRequestDispatcher("/views/khachhang/thanhtoan.jsp").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Integer userID = (Integer) session.getAttribute("userID");

		// Check authentication
		if (userID == null) {
			sendJsonResponse(response, "error", "Bạn cần đăng nhập");
			return;
		}

		String action = request.getParameter("action");
		response.setContentType("application/json; charset=UTF-8");

		if ("taoQR".equals(action)) {
			handleTaoQR(request, response, session, userID);
		} else {
			sendJsonResponse(response, "error", "Action không hợp lệ");
		}
	}

	/**
	 * Handle taoQR action - Create temporary payment session (don't save to DB yet)
	 *
	 * Parameters:
	 * - phuongThuc: Payment method (EWALLET, CARD)
	 *
	 * Flow:
	 * 1. Get DonThueAo from session
	 * 2. Calculate total
	 * 3. Store payment info in session ONLY (NOT in DB yet)
	 * 4. Generate temporary maThanhToan ID (base on timestamp)
	 * 5. Return QR code URL with temporary ID
	 * 6. ThanhToan will be created in DB ONLY if payment is confirmed
	 */
	private void handleTaoQR(HttpServletRequest request, HttpServletResponse response,
							  HttpSession session, Integer userID) throws IOException {
		try {
			String phuongThuc = request.getParameter("phuongThuc");
			if (phuongThuc == null) {
				sendJsonResponse(response, "error", "Thiếu tham số phuongThuc");
				return;
			}

			// 1. Get DonThueAo from session
			DonThue donThueAo = (DonThue) session.getAttribute("donThueAo");
			if (donThueAo == null) {
				sendJsonResponse(response, "error", "Không tìm thấy đơn ảo. Quay lại giỏ hàng");
				return;
			}

			// 2. Calculate total
			double soTien = ThanhToanService.tinhTongTienDonThue(donThueAo.getDsChiTiet());
			if (soTien <= 0) {
				sendJsonResponse(response, "error", "Số tiền không hợp lệ");
				return;
			}

			// 3. Generate temporary maThanhToan (NOT saved to DB yet)
			long qrCreatedTime = System.currentTimeMillis();
			int maThanhToanTemp = (int)(qrCreatedTime / 1000) % 1000000; // Use timestamp as temp ID

			// 4. Store payment info in CACHE (for cross-device validation)
			// Include DonThueAo so Device B can complete payment without session
			PaymentCache.put(maThanhToanTemp, soTien, phuongThuc, donThueAo);

			// 5. Store payment info in SESSION (for same-device processing)
			session.setAttribute("paymentMethod", phuongThuc);
			session.setAttribute("paymentAmount", soTien);
			session.setAttribute("maThanhToan", maThanhToanTemp);
			session.setAttribute("paymentQRCreatedTime", qrCreatedTime);

			// 5. Return QR code URL (maThanhToan is temporary, will be created in DB on success)
			String serverHostName = getServerIP(request);
			String mockPageUrl = request.getScheme() + "://" + serverHostName +
								(request.getServerPort() == 80 ? "" : ":" + request.getServerPort()) +
								request.getContextPath() + "/khachhang/thanhtoan/mock?maThanhToan=" + maThanhToanTemp;

			response.setContentType("application/json; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				out.println("{");
				out.println("  \"status\": \"success\",");
				out.println("  \"mockPageUrl\": \"" + mockPageUrl + "\",");
				out.println("  \"maThanhToan\": " + maThanhToanTemp + ",");
				out.println("  \"timeoutSeconds\": 180");
				out.println("}");
			}

		} catch (Exception e) {
			sendJsonResponse(response, "error", "Lỗi: " + e.getMessage());
			e.printStackTrace();
		}
	}

	private void sendJsonResponse(HttpServletResponse response, String status, String message)
			throws IOException {
		response.setContentType("application/json; charset=UTF-8");
		try (PrintWriter out = response.getWriter()) {
			out.println("{");
			out.println("  \"status\": \"" + status + "\",");
			out.println("  \"message\": \"" + message + "\"");
			out.println("}");
		}
	}

	/**
	 * Lấy IP thực của server
	 * - Nếu request đến localhost/127.0.0.1 → lấy IP local của máy
	 * - Nếu request đến IP khác → sử dụng IP đó
	 */
	private String getServerIP(HttpServletRequest request) {
		String serverName = request.getServerName();

		// Nếu là localhost / 127.0.0.1, lấy IP thực của máy
		if ("localhost".equals(serverName) || "127.0.0.1".equals(serverName)) {
			try {
				InetAddress inetAddress = InetAddress.getLocalHost();
				return inetAddress.getHostAddress();
			} catch (Exception e) {
				// Fallback về getServerName nếu lỗi
				return serverName;
			}
		}

		return serverName;
	}
}
