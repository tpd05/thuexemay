package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.DonThueDAO;
import model.DonThue;
import service.ThanhToanService;
import util.Connect;

@WebServlet("/khachhang/payment")
public class PaymentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		Integer userID = (Integer) session.getAttribute("userID");

		if (userID == null) {
			response.sendRedirect(request.getContextPath() + "/views/auth/dangnhap.jsp");
			return;
		}

		String maDonStr = request.getParameter("maDon");
		if (maDonStr == null || maDonStr.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/khachhang/dashboard");
			return;
		}

		try {
			int maDon = Integer.parseInt(maDonStr);
			
			// Lấy thông tin đơn thuê để hiển thị giá tiền
			Connection con = Connect.getInstance().getConnect();
			DonThueDAO donDAO = new DonThueDAO();
			DonThue don = donDAO.layDonThueTheoId(maDon, con);
			con.close();
			
			if (don == null) {
				response.sendRedirect(request.getContextPath() + "/khachhang/dashboard");
				return;
			}
			
			request.setAttribute("maDon", maDon);
			request.setAttribute("don", don);
			request.getRequestDispatcher("/views/khachhang/payment.jsp").forward(request, response);
			
		} catch (Exception e) {
			response.sendRedirect(request.getContextPath() + "/khachhang/dashboard");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String action = request.getParameter("action");
		HttpSession session = request.getSession();
		Integer userID = (Integer) session.getAttribute("userID");

		if (userID == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\"?><error>Chưa đăng nhập</error>");
			}
			return;
		}

		response.setContentType("application/xml; charset=UTF-8");

		if ("createQR".equals(action)) {
			handleCreateQR(request, response);
		} else if ("checkStatus".equals(action)) {
			handleCheckStatus(request, response);
		}
	}
	
	/**
	 * Xử lý tạo QR code thanh toán
	 * 
	 * Lưu ý: DonThue sẽ được tạo sau khi Momo callback thành công
	 * Tạm thời chỉ lưu thông tin thanh toán vào THANHTOAN table
	 */
	private void handleCreateQR(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		try {
			HttpSession session = request.getSession();
			Integer userID = (Integer) session.getAttribute("userID");
			
			if (userID == null) {
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				try (PrintWriter out = response.getWriter()) {
					out.println("<?xml version=\"1.0\"?>");
					out.println("<response>");
					out.println("  <status>error</status>");
					out.println("  <message>Chưa đăng nhập</message>");
					out.println("</response>");
				}
				return;
			}
			
			String method = request.getParameter("method"); // EWALLET, CARD
			long soTien = Long.parseLong(request.getParameter("soTien"));

			// Tạo URLs
			String baseUrl = request.getScheme() + "://" + request.getServerName() + 
					(request.getServerPort() == 80 ? "" : ":" + request.getServerPort()) + 
					request.getContextPath();
			String redirectUrl = baseUrl + "/khachhang/lich-su-don-hang";
			String callbackUrl = baseUrl + "/khachhang/payment-callback";
			
			// Sử dụng mock payment thay vì Momo API thực tế
			String payUrl = baseUrl + "/khachhang/payment-mock";
			
			// Extract requestId từ response (tạo trong service)
			String requestId = "THUEXE" + System.currentTimeMillis();
			
			// ❌ KHÔNG TẠO THANHTOAN ở ĐÂY (FOREIGN KEY FAIL)
			// ✅ THANHTOAN sẽ được tạo sau khi DonThue tạo thành công trong PaymentMockServlet
			// Lưu requestId + soTien vào session để PaymentMockServlet sử dụng
			session.setAttribute("paymentRequestId", requestId);
			session.setAttribute("paymentAmount", soTien);
			session.setAttribute("paymentMethod", method);

			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				out.println("<response>");
				out.println("  <status>success</status>");
				out.println("  <payUrl>" + payUrl + "</payUrl>");
				out.println("  <requestId>" + requestId + "</requestId>");
				out.println("</response>");
			}

		} catch (Exception e) {
			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\"?>");
				out.println("<response>");
				out.println("  <status>error</status>");
				out.println("  <message>" + escapeXml(e.getMessage()) + "</message>");
				out.println("</response>");
			}
			e.printStackTrace();
		}
	}
	
	/**
	 * Kiểm tra trạng thái thanh toán
	 */
	private void handleCheckStatus(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		try {
			String requestId = request.getParameter("requestId");
			
			// Gọi static method checkPaymentStatus
			boolean success = ThanhToanService.checkPaymentStatus(requestId);

			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				out.println("<response>");
				out.println("  <status>" + (success ? "success" : "failed") + "</status>");
				out.println("</response>");
			}

		} catch (Exception e) {
			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\"?>");
				out.println("<response>");
				out.println("  <status>error</status>");
				out.println("  <message>" + escapeXml(e.getMessage()) + "</message>");
				out.println("</response>");
			}
		}
	}
	
	private String escapeXml(String text) {
		if (text == null) return "";
		return text.replace("&", "&amp;")
				   .replace("<", "&lt;")
				   .replace(">", "&gt;")
				   .replace("\"", "&quot;")
				   .replace("'", "&apos;");
	}
}
