package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DonThue;
import model.GioHang;
import service.ThanhToanService;

/**
 * PaymentCallbackServlet - Callback from PaymentMockServlet
 *
 * - Nếu result=success → Create DonThue + ChiTietDonThue + ThanhToan atomically → Redirect to success page
 * - Nếu result=cancel → Don't save anything, rollback → Redirect to payment page (retry)
 *
 * Endpoint: /khachhang/thanhtoan/callback?maThanhToan=X&result=success/cancel
 */
@WebServlet("/khachhang/thanhtoan/callback")
public class PaymentCallbackServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("\n========================================");
		System.out.println("=== PaymentCallbackServlet.doGet() CALLED ===");
		System.out.println("========================================");
		System.out.flush();

		String result = request.getParameter("result");
		String maThanhToanStr = request.getParameter("maThanhToan");
		HttpSession session = request.getSession(true);

		System.out.println("result=" + result + ", maThanhToan=" + maThanhToanStr);
		System.out.flush();

		if (maThanhToanStr == null || maThanhToanStr.isEmpty()) {
			System.out.println("ERROR: Missing maThanhToan");
			System.out.flush();
			response.sendRedirect(request.getContextPath() + "/khachhang/giohang");
			return;
		}

		try {
			int maThanhToan = Integer.parseInt(maThanhToanStr);

			if ("success".equals(result)) {
				System.out.println("Processing success result...");
				System.out.flush();
				handlePaymentSuccess(request, response, session, maThanhToan);
			} else if ("cancel".equals(result)) {
				System.out.println("Processing cancel result...");
				System.out.flush();
				handlePaymentCancel(request, response, session, maThanhToan);
			} else {
				System.out.println("ERROR: Unknown result=" + result);
				System.out.flush();
				response.sendRedirect(request.getContextPath() + "/khachhang/giohang");
			}
		} catch (NumberFormatException e) {
			System.out.println("ERROR: Invalid maThanhToan format: " + maThanhToanStr);
			e.printStackTrace();
			System.out.flush();
			response.sendRedirect(request.getContextPath() + "/khachhang/giohang");
		} catch (Exception e) {
			System.out.println("ERROR in doGet: " + e.getMessage());
			e.printStackTrace();
			System.out.flush();
			request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
			request.getRequestDispatcher("/views/khachhang/thanhtoan.jsp").forward(request, response);
		}
	}

	/**
	 * Handle successful payment
	 * - Verify maThanhToan exists in cache (cross-device validation)
	 * - Create DonThue + ChiTietDonThue + ThanhToan atomically (all with status DA_THANH_TOAN)
	 * - Mark payment as completed for Device A polling
	 * - Redirect to success page
	 */
	private void handlePaymentSuccess(HttpServletRequest request, HttpServletResponse response,
			HttpSession session, int maThanhToan) throws Exception {

		System.out.println(">>> handlePaymentSuccess() called with maThanhToan=" + maThanhToan);

		try {
			// Validate maThanhToan exists in cache (supports cross-device)
			if (!cache.PaymentCache.exists(maThanhToan)) {
				System.out.println("ERROR: maThanhToan not in cache");
				throw new Exception("Mã thanh toán không tồn tại hoặc đã hết hạn");
			}

			// Get payment info from cache (not session - supports cross-device)
			double soTien = cache.PaymentCache.getSoTien(maThanhToan);
			String phuongThuc = cache.PaymentCache.getPhuongThuc(maThanhToan);
			DonThue donThueAo = cache.PaymentCache.getDonThueAo(maThanhToan);

			System.out.println("Cache data - soTien=" + soTien + ", phuongThuc=" + phuongThuc + ", donThueAo=" + (donThueAo != null ? "OK" : "NULL"));

			if (soTien <= 0 || phuongThuc == null || donThueAo == null) {
				System.out.println("ERROR: Invalid payment data from cache");
				throw new Exception("Thông tin thanh toán không hợp lệ");
			}

			// Get userID and GioHang info from session
			Integer userID = (Integer) session.getAttribute("userID");
			Integer maGioHang = (Integer) session.getAttribute("maGioHang");

			System.out.println("Session data - userID=" + userID + ", maGioHang=" + maGioHang);

			// Create GioHang object if we have the info
			GioHang gh = null;
			if (userID != null && maGioHang != null) {
				gh = new GioHang();
				gh.setUserID(userID);
				gh.setMaGioHang(maGioHang);
				System.out.println("GioHang object created for cart cleanup");
			} else {
				System.out.println("WARNING: userID or maGioHang not in session - cart items won't be deleted");
			}

			// Call service to create ALL 4 records atomically (Order + Payment + Cart cleanup)
			// New signature: (DonThue don, double soTien, String phuongThuc, GioHang gh)
			System.out.println("Calling ThanhToanService.luuDonThueVaThanhToan() with cart cleanup...");
			boolean success = ThanhToanService.luuDonThueVaThanhToan(donThueAo, soTien, phuongThuc, gh);

			if (success) {
				System.out.println("SUCCESS! Marking payment as completed...");
				// Mark payment as completed in cache for cross-device notification
				cache.PaymentCache.markCompleted(maThanhToan);
				System.out.println("Payment marked completed. isCompleted=" + cache.PaymentCache.isCompleted(maThanhToan));

				// Clear session (if on same device)
				session.removeAttribute("donThueAo");
				session.removeAttribute("gioHangAo");
				session.removeAttribute("paymentMethod");
				session.removeAttribute("paymentAmount");
				session.removeAttribute("maThanhToan");
				session.removeAttribute("paymentQRCreatedTime");

				// Forward to success page
				request.getRequestDispatcher("/views/khachhang/thanhtoan-success.jsp").forward(request, response);
			} else {
				System.out.println("ERROR: ThanhToanService returned false");
				throw new Exception("Lưu thanh toán thất bại");
			}

		} catch (Exception e) {
			System.out.println("EXCEPTION in handlePaymentSuccess: " + e.getMessage());
			e.printStackTrace();
			// If error, return to payment page with error message
			request.setAttribute("errorMessage", "Lỗi khi lưu thanh toán: " + e.getMessage());
			request.getRequestDispatcher("/views/khachhang/thanhtoan.jsp").forward(request, response);
		}
	}

	/**
	 * Handle cancelled/failed payment
	 * - Don't save anything to database (rollback)
	 * - Keep DonThueAo in session for retry
	 * - Redirect back to payment page
	 */
	private void handlePaymentCancel(HttpServletRequest request, HttpServletResponse response,
			HttpSession session, int maThanhToan) throws IOException {

		try {
			// Don't update database - ThanhToan was never created (only stored in session)
			// Just clear payment-specific session attributes
			session.removeAttribute("paymentMethod");
			session.removeAttribute("paymentAmount");
			session.removeAttribute("maThanhToan");
			session.removeAttribute("paymentQRCreatedTime");

			// Remove from cache too
			cache.PaymentCache.remove(maThanhToan);

			// Keep donThueAo + gioHangAo in session for retry
			// Redirect back to payment page
			response.sendRedirect(request.getContextPath() + "/khachhang/thanhtoan");

		} catch (Exception e) {
			// If error, still redirect to payment page
			response.sendRedirect(request.getContextPath() + "/khachhang/thanhtoan");
		}
	}
}
