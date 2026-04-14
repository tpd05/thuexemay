package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.DonThueDAO;
import model.DonThue;
import service.LichSuThueXeService;
import util.Connect;

@WebServlet({"/khachhang/lichsuthuexe", "/khachhang/lichsuthuexe/xedathue", "/khachhang/lichsuthuexe/xedangthue"})
public class LichSuThueXeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String api = request.getParameter("api");
		String pathInfo = request.getPathInfo();
		String requestURI = request.getRequestURI();

		HttpSession session = request.getSession();
		Integer userID = (Integer) session.getAttribute("userID");

		if (userID == null) {
			response.sendRedirect(request.getContextPath() + "/views/auth/dangnhap.jsp");
			return;
		}
		
		// Determine which route is being accessed
		if (requestURI.contains("/xedathue")) {
			handleDaThue(request, response, userID, api);
		} else if (requestURI.contains("/xedangthue")) {
			handleDangThue(request, response, userID, api);
		} else {
			handleDefault(request, response, userID, api);
		}
	}

	/**
	 * Handle /khachhang/lichsuthuexe/xedathue - Completed rentals (DA_THUE)
	 */
	private void handleDaThue(HttpServletRequest request, HttpServletResponse response, Integer userID, String api)
			throws ServletException, IOException {
		if ("1".equals(api)) {
			response.setContentType("application/json; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				List<Map<String, Object>> donThueDanhSach = LichSuThueXeService.layDanhSachDonDaThue(userID);
				
				// Convert to JSON format
				StringBuilder json = new StringBuilder("[");
				for (int i = 0; i < donThueDanhSach.size(); i++) {
					Map<String, Object> don = donThueDanhSach.get(i);
					json.append("{");
					json.append("\"maDonThue\":").append(don.get("maDonThue")).append(",");
					json.append("\"diaChiNhanXe\":\"").append(escapeJson((String)don.get("diaChiNhanXe"))).append("\",");
					json.append("\"trangThai\":\"").append(don.get("trangThai")).append("\",");
					json.append("\"ngayTao\":").append(don.get("ngayTao") != null ? "\"" + don.get("ngayTao") + "\"" : "null").append(",");
					json.append("\"tongTien\":").append(don.get("tongTien")).append(",");
					json.append("\"soLuongXe\":").append(don.get("soLuongXe"));
					json.append("}");
					if (i < donThueDanhSach.size() - 1) json.append(",");
				}
				json.append("]");
				out.print(json.toString());
			} catch (Exception e) {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				try (PrintWriter out = response.getWriter()) {
					out.print("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
				}
			}
		} else {
			try {
				List<Map<String, Object>> donThueDanhSach = LichSuThueXeService.layDanhSachDonDaThue(userID);
				request.setAttribute("donThueDanhSach", donThueDanhSach);
				request.getRequestDispatcher("/views/khachhang/xedathue.jsp").forward(request, response);
			} catch (Exception e) {
				e.printStackTrace();
				request.setAttribute("error", e.getMessage());
				request.getRequestDispatcher("/views/khachhang/xedathue.jsp").forward(request, response);
			}
		}
	}
	
	/**
	 * Handle /khachhang/lichsuthuexe/xedangthue - Active rentals (DANG_THUE) + Upcoming (DA_THANH_TOAN)
	 */
	private void handleDangThue(HttpServletRequest request, HttpServletResponse response, Integer userID, String api)
			throws ServletException, IOException {
		if ("1".equals(api)) {
			response.setContentType("application/json; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				String type = request.getParameter("type"); // "dang_thue" or "sap_toi"
				
				List<Map<String, Object>> donThueDanhSach;
				if ("sap_toi".equals(type)) {
					donThueDanhSach = LichSuThueXeService.layDanhSachDonSapToi(userID);
				} else {
					donThueDanhSach = LichSuThueXeService.layDanhSachDonDangThue(userID);
				}
				
				// Convert to JSON format
				StringBuilder json = new StringBuilder("[");
				for (int i = 0; i < donThueDanhSach.size(); i++) {
					Map<String, Object> don = donThueDanhSach.get(i);
					json.append("{");
					json.append("\"maDonThue\":").append(don.get("maDonThue")).append(",");
					json.append("\"diaChiNhanXe\":\"").append(escapeJson((String)don.get("diaChiNhanXe"))).append("\",");
					json.append("\"trangThai\":\"").append(don.get("trangThai")).append("\",");
					json.append("\"ngayBatDau\":").append(don.get("ngayBatDau") != null ? "\"" + don.get("ngayBatDau") + "\"" : "null").append(",");
					json.append("\"ngayKetThuc\":").append(don.get("ngayKetThuc") != null ? "\"" + don.get("ngayKetThuc") + "\"" : "null").append(",");
					json.append("\"tongTien\":").append(don.get("tongTien")).append(",");
					json.append("\"soLuongXe\":").append(don.get("soLuongXe"));
					json.append("}");
					if (i < donThueDanhSach.size() - 1) json.append(",");
				}
				json.append("]");
				out.print(json.toString());
			} catch (Exception e) {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				try (PrintWriter out = response.getWriter()) {
					out.print("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
				}
			}
		} else {
			try {
				List<Map<String, Object>> donDangThue = LichSuThueXeService.layDanhSachDonDangThue(userID);
				List<Map<String, Object>> donSapToi = LichSuThueXeService.layDanhSachDonSapToi(userID);
				request.setAttribute("donDangThue", donDangThue);
				request.setAttribute("donSapToi", donSapToi);
				request.getRequestDispatcher("/views/khachhang/xedangthue.jsp").forward(request, response);
			} catch (Exception e) {
				e.printStackTrace();
				request.setAttribute("error", e.getMessage());
				request.getRequestDispatcher("/views/khachhang/xedangthue.jsp").forward(request, response);
			}
		}
	}
	
	/**
	 * Handle default /khachhang/lichsuthuexe - All paid rentals (DA_THANH_TOAN)
	 */
	private void handleDefault(HttpServletRequest request, HttpServletResponse response, Integer userID, String api)
			throws ServletException, IOException {
		if ("1".equals(api)) {
			// Trả về XML lịch sử đơn thuê của khách hàng
			response.setContentType("application/xml; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				out.println("<lich_su_don_thue>");

				Connection con = Connect.getInstance().getConnect();
				DonThueDAO donThueDAO = new DonThueDAO();

				List<DonThue> list = donThueDAO.layDanhSachByUserID(userID, con);

				for (DonThue donThue : list) {
					out.println("  <don>");
					out.println("    <maDonThue>" + donThue.getMaDonThue() + "</maDonThue>");
					out.println("    <userID>" + donThue.getUserID() + "</userID>");
					out.println("    <diaChiNhanXe>" + escapeXml(donThue.getDiaChiNhanXe()) + "</diaChiNhanXe>");
					out.println("    <trangThai>" + escapeXml(donThue.getTrangThai()) + "</trangThai>");
					if (donThue.getNgayTao() != null) {
						out.println("    <ngayTao>" + donThue.getNgayTao() + "</ngayTao>");
					}
					out.println("  </don>");
				}

				out.println("</lich_su_don_thue>");
				con.close();
			} catch (Exception e) {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				try (PrintWriter out = response.getWriter()) {
					out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
					out.println("<error>" + escapeXml(e.getMessage()) + "</error>");
				}
				e.printStackTrace();
			}
		} else {
			// Load danh sách đơn thuê có trạng thái DA_THANH_TOAN sử dụng Service
			try {
				List<Map<String, Object>> donThueDanhSach = LichSuThueXeService.layDanhSachDonThue(userID);
				request.setAttribute("donThueDanhSach", donThueDanhSach);
				request.getRequestDispatcher("/views/khachhang/lichsuthuexe.jsp").forward(request, response);
				
			} catch (Exception e) {
				e.printStackTrace();
				request.setAttribute("error", e.getMessage());
				request.getRequestDispatcher("/views/khachhang/lichsuthuexe.jsp").forward(request, response);
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
	
	private String escapeJson(String text) {
		if (text == null) return "";
		return text.replace("\\", "\\\\")
				   .replace("\"", "\\\"")
				   .replace("\n", "\\n")
				   .replace("\r", "\\r")
				   .replace("\t", "\\t");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
