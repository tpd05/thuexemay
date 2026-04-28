package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cache.PaymentCache;
import dao.GioHangDAO;
import dao.MucHangDAO;
import model.ChiTietDonThue;
import model.DonThue;
import model.GioHang;
import service.ThanhToanService;
import util.Connect;

/**
 * PaymentMockServlet - PUBLIC PAGE (no authentication needed)
 *
 * GET: Hiển thị trang mock payment
 * POST: Xử lý payment (lưu DB + mark completed, respond JSON)
 *
 * Endpoint: GET /khachhang/thanhtoan/mock?maThanhToan=X
 *           POST /khachhang/thanhtoan/mock
 */
@WebServlet("/khachhang/thanhtoan/mock")
public class PaymentMockServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String maThanhToanStr = request.getParameter("maThanhToan");
		if (maThanhToanStr == null || maThanhToanStr.isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu maThanhToan");
			return;
		}

		try {
			int maThanhToan = Integer.parseInt(maThanhToanStr);

			// Validate from PaymentCache (not DB) - supports cross-device QR scanning
			if (!PaymentCache.exists(maThanhToan)) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã thanh toán không tồn tại hoặc đã hết hạn");
				return;
			}

			// Get payment info from cache
			double soTien = PaymentCache.getSoTien(maThanhToan);
			String phuongThuc = PaymentCache.getPhuongThuc(maThanhToan);

			if (soTien <= 0 || phuongThuc == null) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thông tin thanh toán không hợp lệ");
				return;
			}

			// Hiển thị trang mock payment
			response.setContentType("text/html; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				out.println("<!DOCTYPE html>");
				out.println("<html>");
				out.println("<head>");
				out.println("  <meta charset='UTF-8'>");
				out.println("  <title>Giả Lập Thanh Toán</title>");
				out.println("</head>");
				out.println("<body>");
				out.println("<div style='max-width: 600px; margin: 50px auto; border: 1px solid #ccc; padding: 30px; text-align: center;'>");
				out.println("  <h1>GIẢ LẬP CỔNG THANH TOÁN</h1>");
				out.println("  <p><strong>Mã Thanh Toán:</strong> " + maThanhToan + "</p>");
				out.println("  <p><strong>Số Tiền:</strong> " + String.format("%.0f", soTien) + " ₫</p>");
				out.println("  <p><strong>Phương Thức:</strong> " + phuongThuc + "</p>");
				out.println("  <p style='color: #666; font-size: 14px;'>(Đây là trang giả lập - không thực hiện thanh toán thực tế)</p>");
				out.println();
				out.println("  <div style='background: #f0f0f0; padding: 20px; margin: 30px 0; border-radius: 5px;'>");
				out.println("    <h3>Xác Nhận Giao Dịch?</h3>");
				out.println("    <p>Bấm nút bên dưới để hoàn thành hoặc hủy thanh toán</p>");
				out.println("  </div>");
				out.println();
				out.println("  <button onclick=\"confirmPayment(" + maThanhToan + ")\" style='padding: 12px 30px; background: #4CAF50; color: white; border: none; cursor: pointer; font-size: 16px; margin: 10px;'>");
				out.println("    ✓ Xác Nhận Thanh Toán");
				out.println("  </button>");
				out.println("  <button onclick=\"cancelPayment(" + maThanhToan + ")\" style='padding: 12px 30px; background: #f44336; color: white; border: none; cursor: pointer; font-size: 16px; margin: 10px;'>");
				out.println("    ✗ Hủy Thanh Toán");
				out.println("  </button>");
				out.println("</div>");
				out.println();
				out.println("<script>");
				out.println("function confirmPayment(maThanhToan) {");
				out.println("  console.log('Confirming payment: ' + maThanhToan);");
				out.println("  submitPayment(maThanhToan, 'success');");
				out.println("}");
				out.println();
				out.println("function cancelPayment(maThanhToan) {");
				out.println("  console.log('Cancelling payment: ' + maThanhToan);");
				out.println("  submitPayment(maThanhToan, 'cancel');");
				out.println("}");
				out.println();
				out.println("function submitPayment(maThanhToan, action) {");
				out.println("  console.log('submitPayment called with action=' + action);");
				out.println("  ");
				out.println("  const formData = new URLSearchParams();");
				out.println("  formData.append('maThanhToan', maThanhToan);");
				out.println("  formData.append('action', action);");
				out.println("  ");
				out.println("  fetch(window.location.pathname + '?action=' + action + '&maThanhToan=' + maThanhToan, {");
				out.println("    method: 'POST',");
				out.println("    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },");
				out.println("    body: formData");
				out.println("  })");
				out.println("  .then(response => response.json())");
				out.println("  .then(data => {");
				out.println("    console.log('Payment response:', data);");
				out.println("    if (data.success) {");
				out.println("      alert('Thanh toán ' + (action === 'success' ? 'thành công!' : 'đã bị hủy!'));");
				out.println("      window.location.href = window.location.origin;");
				out.println("    } else {");
				out.println("      alert('Lỗi: ' + data.message);");
				out.println("    }");
				out.println("  })");
				out.println("  .catch(error => {");
				out.println("    console.error('Fetch error:', error);");
				out.println("    alert('Lỗi kết nối: ' + error.message);");
				out.println("  });");
				out.println("}");
				out.println("</script>");
				out.println("</body>");
				out.println("</html>");
			}

		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "maThanhToan không hợp lệ");
		} catch (Exception e) {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi: " + e.getMessage());
			e.printStackTrace();
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		String maThanhToanStr = request.getParameter("maThanhToan");

		System.out.println("\n=== PaymentMockServlet.doPost() ===");
		System.out.println("action=" + action + ", maThanhToan=" + maThanhToanStr);
		System.out.flush();

		response.setContentType("application/json; charset=UTF-8");
		PrintWriter out = response.getWriter();

		if (maThanhToanStr == null || maThanhToanStr.isEmpty()) {
			System.out.println("ERROR: Missing maThanhToan");
			System.out.flush();
			out.println("{\"success\": false, \"message\": \"Thiếu maThanhToan\"}");
			return;
		}

		try {
			int maThanhToan = Integer.parseInt(maThanhToanStr);

			if ("success".equals(action)) {
				System.out.println("Processing payment success...");
				System.out.flush();
				handlePaymentSuccess(response, maThanhToan, out);
			} else if ("cancel".equals(action)) {
				System.out.println("Processing payment cancel...");
				System.out.flush();
				handlePaymentCancel(maThanhToan, out);
			} else {
				System.out.println("ERROR: Invalid action");
				System.out.flush();
				out.println("{\"success\": false, \"message\": \"Action không hợp lệ\"}");
			}

		} catch (NumberFormatException e) {
			System.out.println("ERROR: Invalid maThanhToan format");
			System.out.flush();
			out.println("{\"success\": false, \"message\": \"maThanhToan không hợp lệ\"}");
		} catch (Exception e) {
			System.out.println("ERROR in doPost: " + e.getMessage());
			e.printStackTrace();
			System.out.flush();
			out.println("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
		}
	}

	/**
	 * Handle payment success - save to DB + mark completed
	 */
	private void handlePaymentSuccess(HttpServletResponse response, int maThanhToan, PrintWriter out) {
		try {
			// Validate exists in cache
			if (!PaymentCache.exists(maThanhToan)) {
				System.out.println("ERROR: maThanhToan not in cache");
				System.out.flush();
				out.println("{\"success\": false, \"message\": \"Mã thanh toán không tồn tại\"}");
				return;
			}

			// Get payment info from cache
			double soTien = PaymentCache.getSoTien(maThanhToan);
			String phuongThuc = PaymentCache.getPhuongThuc(maThanhToan);
			DonThue donThueAo = PaymentCache.getDonThueAo(maThanhToan);

			System.out.println("Payment info - soTien=" + soTien + ", phuongThuc=" + phuongThuc + ", donThueAo=" + (donThueAo != null ? "OK" : "NULL"));
			System.out.flush();

			if (soTien <= 0 || phuongThuc == null || donThueAo == null) {
				System.out.println("ERROR: Invalid payment data");
				System.out.flush();
				out.println("{\"success\": false, \"message\": \"Thông tin thanh toán không hợp lệ\"}");
				return;
			}

			// Save to database - DonThue + ChiTietDonThue + ThanhToan
			System.out.println("Calling ThanhToanService.luuDonThueVaThanhToan()...");
			System.out.flush();
			boolean success = ThanhToanService.luuDonThueVaThanhToan(donThueAo, soTien, phuongThuc);

			if (!success) {
				System.out.println("ERROR: ThanhToanService returned false");
				System.out.flush();
				out.println("{\"success\": false, \"message\": \"Lưu thanh toán thất bại\"}");
				return;
			}

			// Mark completed in cache - Device A will detect this
			System.out.println("SUCCESS! Marking payment as completed...");
			System.out.flush();
			PaymentCache.markCompleted(maThanhToan);
			System.out.println("Payment marked completed. isCompleted=" + PaymentCache.isCompleted(maThanhToan));
			System.out.flush();

			// Xóa các mục hàng ra khỏi giỏ hàng
			System.out.println("Deleting cart items for this order...");
			System.out.flush();
			deleteCartItems(donThueAo);

			// Respond success to Device B
			out.println("{\"success\": true, \"message\": \"Thanh toán thành công\"}");
			out.flush();

		} catch (Exception e) {
			System.out.println("EXCEPTION in handlePaymentSuccess: " + e.getMessage());
			e.printStackTrace();
			System.out.flush();
			out.println("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
		}
	}

	/**
	 * Handle payment cancel - remove from cache
	 */
	private void handlePaymentCancel(int maThanhToan, PrintWriter out) {
		try {
			PaymentCache.remove(maThanhToan);
			System.out.println("Payment cancelled and removed from cache");
			System.out.flush();
			out.println("{\"success\": true, \"message\": \"Thanh toán đã bị hủy\"}");
			out.flush();
		} catch (Exception e) {
			System.out.println("ERROR in handlePaymentCancel: " + e.getMessage());
			System.out.flush();
			out.println("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
		}
	}

	/**
	 * Delete cart items that were part of this order
	 * Extract maGoiThue from order details and remove from cart
	 */
	private void deleteCartItems(DonThue donThue) {
		Connection con = null;
		try {
			con = Connect.getInstance().getConnect();

			// Get user's GioHang
			GioHangDAO gioHangDAO = new GioHangDAO();
			GioHang gioHang = gioHangDAO.layGioHangByUserID(donThue.getUserID(), con);

			if (gioHang == null) {
				System.out.println("WARNING: GioHang not found for user " + donThue.getUserID());
				System.out.flush();
				return;
			}

			// Extract maGoiThue list from order items
			List<Integer> maGoiThueList = new ArrayList<>();
			if (donThue.getDsChiTiet() != null && !donThue.getDsChiTiet().isEmpty()) {
				for (ChiTietDonThue ct : donThue.getDsChiTiet()) {
					maGoiThueList.add(ct.getMaGoiThue());
				}
			}

			if (maGoiThueList.isEmpty()) {
				System.out.println("WARNING: No order items found to delete from cart");
				System.out.flush();
				return;
			}

			// Delete MucHang items from cart
			MucHangDAO mucHangDAO = new MucHangDAO();
			boolean success = mucHangDAO.xoaMucHang(gioHang.getMaGioHang(), maGoiThueList, con);

			if (success) {
				System.out.println("SUCCESS: Deleted " + maGoiThueList.size() + " cart items for order");
				System.out.flush();
			} else {
				System.out.println("WARNING: Failed to delete cart items (but payment was successful)");
				System.out.flush();
			}

		} catch (Exception e) {
			System.out.println("ERROR in deleteCartItems: " + e.getMessage());
			e.printStackTrace();
			System.out.flush();
			// Don't fail the payment if cart deletion fails
		}
	}
}
