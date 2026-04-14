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

import dao.GioHangDAO;
import dao.MucHangDAO;
import model.GioHang;
import model.MucHang;
import util.Connect;

@WebServlet("/khachhang/themgoivaogio")
public class ThemGoiVaoGioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// SET CHARACTER ENCODING FIRST - BEFORE accessing any parameters!
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/xml; charset=UTF-8");
		
		// DEBUG: Log servlet được gọi
		System.out.println("[ThemGoiVaoGioServlet] ===== SERVLET CALLED =====");
		System.out.println("[ThemGoiVaoGioServlet] Request URL: " + request.getRequestURI());
		System.out.println("[ThemGoiVaoGioServlet] Context Path: " + request.getContextPath());
		System.out.println("[ThemGoiVaoGioServlet] Servlet Path: " + request.getServletPath());
		System.out.println("[ThemGoiVaoGioServlet] Parameters: maGoiThue=" + request.getParameter("maGoiThue") + ", soLuong=" + request.getParameter("soLuong"));

		try {
			HttpSession session = request.getSession();
			Integer userID = (Integer) session.getAttribute("userID");
			System.out.println("[ThemGoiVaoGioServlet] UserID from session: " + userID);

			if (userID == null) {
				System.out.println("[ThemGoiVaoGioServlet] ERROR: User not logged in");
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				try (PrintWriter out = response.getWriter()) {
					out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
					out.println("<error>Bạn cần đăng nhập trước</error>");
				}
				return;
			}

			int maGoiThue = Integer.parseInt(request.getParameter("maGoiThue"));
			int soLuong = Integer.parseInt(request.getParameter("soLuong"));
			System.out.println("[ThemGoiVaoGioServlet] Processing: maGoiThue=" + maGoiThue + ", soLuong=" + soLuong);

			Connection con = Connect.getInstance().getConnect();
			GioHangDAO gioHangDAO = new GioHangDAO();
			MucHangDAO mucHangDAO = new MucHangDAO();

			// Lấy hoặc tạo giỏ hàng cho khách hàng
			GioHang gioHang = gioHangDAO.layGioHangByUserID(userID, con);
			System.out.println("[ThemGoiVaoGioServlet] gioHang before check: " + (gioHang != null ? "FOUND (maGioHang=" + gioHang.getMaGioHang() + ")" : "NULL"));
			
			if (gioHang == null) {
				gioHang = new GioHang();
				gioHang.setUserID(userID);
				gioHang.setDiaChiNhanXe("");
				System.out.println("[ThemGoiVaoGioServlet] Creating new gioHang for userID=" + userID);
				gioHangDAO.taoGioHang(gioHang, con);
				gioHang = gioHangDAO.layGioHangByUserID(userID, con);
				System.out.println("[ThemGoiVaoGioServlet] After creation: maGioHang=" + (gioHang != null ? gioHang.getMaGioHang() : "FAILED"));
			}

			// Kiểm tra nếu gói thuê đã tồn tại trong giỏ, cập nhật số lượng; nếu không, thêm mới
			System.out.println("[ThemGoiVaoGioServlet] Checking existing - maGioHang=" + gioHang.getMaGioHang() + ", maGoiThue=" + maGoiThue);
			MucHang existingMucHang = mucHangDAO.layMucHangByGoiThue(gioHang.getMaGioHang(), maGoiThue, con);
			System.out.println("[ThemGoiVaoGioServlet] existingMucHang: " + (existingMucHang != null ? "FOUND (soLuong=" + existingMucHang.getSoLuong() + ")" : "NOT FOUND"));
			
			boolean success;
			if (existingMucHang != null) {
				// Cập nhật số lượng nếu đã tồn tại
				int oldQty = existingMucHang.getSoLuong();
				int newQty = oldQty + soLuong;
				existingMucHang.setSoLuong(newQty);
				System.out.println("[ThemGoiVaoGioServlet] UPDATING - oldQty=" + oldQty + " -> newQty=" + newQty);
				success = mucHangDAO.suaMucHang(existingMucHang, con);
				System.out.println("[ThemGoiVaoGioServlet] UPDATE RESULT: " + (success ? "SUCCESS" : "FAILED"));
			} else {
				// Thêm mục gói thuê vào giỏ nếu chưa tồn tại
				MucHang mucHang = new MucHang();
				mucHang.setMaGioHang(gioHang.getMaGioHang());
				mucHang.setMaGoiThue(maGoiThue);
				mucHang.setSoLuong(soLuong);

				String thoiGianBatDauStr = request.getParameter("thoiGianBatDau");
				String thoiGianKetThucStr = request.getParameter("thoiGianKetThuc");

				if (thoiGianBatDauStr != null && !thoiGianBatDauStr.isEmpty()) {
					mucHang.setThoiGianBatDau(java.time.LocalDateTime.parse(thoiGianBatDauStr));
				}
				if (thoiGianKetThucStr != null && !thoiGianKetThucStr.isEmpty()) {
					mucHang.setThoiGianKetThuc(java.time.LocalDateTime.parse(thoiGianKetThucStr));
				}

				System.out.println("[ThemGoiVaoGioServlet] INSERTING NEW - maGioHang=" + mucHang.getMaGioHang() + ", maGoiThue=" + mucHang.getMaGoiThue() + ", soLuong=" + mucHang.getSoLuong());
				success = mucHangDAO.themMucHang(mucHang, con);
				System.out.println("[ThemGoiVaoGioServlet] INSERT RESULT: " + (success ? "SUCCESS" : "FAILED"));
			}

			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				if (success) {
					out.println("<response>");
					out.println("  <status>success</status>");
					out.println("  <message>Đã thêm gói thuê vào giỏ hàng</message>");
					out.println("</response>");
				} else {
					out.println("<response>");
					out.println("  <status>error</status>");
					out.println("  <message>Thêm gói thuê thất bại</message>");
					out.println("</response>");
				}
			}

		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				out.println("<error>Dữ liệu không hợp lệ: " + escapeXml(e.getMessage()) + "</error>");
			}
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				out.println("<error>" + escapeXml(e.getMessage()) + "</error>");
			}
			e.printStackTrace();
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
