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

@WebServlet("/khachhang/lichsuthuexe")
public class LichSuThueXeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String api = request.getParameter("api");

		HttpSession session = request.getSession();
		Integer userID = (Integer) session.getAttribute("userID");

		if (userID == null) {
			response.sendRedirect(request.getContextPath() + "/views/auth/dangnhap.jsp");
			return;
		}

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

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
