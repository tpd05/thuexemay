package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DonThue;

/**
 * ✅ CHECKOUTSERVLET - Xử lý checkout page
 * Hiển thị trang xác nhận đơn hàng trước khi thanh toán
 */
@WebServlet("/khachhang/checkout")
public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		Integer userID = (Integer) session.getAttribute("userID");
		String role = (String) session.getAttribute("role");

		// Check authentication
		if (userID == null || role == null || !role.equals("KHACH_HANG")) {
			response.sendRedirect(request.getContextPath() + "/views/auth/dangnhap.jsp");
			return;
		}

		// Check if DonThueAo is in session
		DonThue donThueAo = (DonThue) session.getAttribute("donThueAo");
		if (donThueAo == null) {
			// Redirect back to cart if no order
			response.sendRedirect(request.getContextPath() + "/khachhang/giohang");
			return;
		}

		// Forward to checkout.jsp
		request.getRequestDispatcher("/views/khachhang/checkout.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// POST requests should go through GioHangServlet
		doGet(request, response);
	}
}
