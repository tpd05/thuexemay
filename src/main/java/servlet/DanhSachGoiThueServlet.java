package servlet;


import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.GoiThueDAO;
import dao.MauXeDAO;
import model.GoiThue;
import model.MauXe;
import util.Connect;

@WebServlet("/khachhang/danhsachgoithue")
public class DanhSachGoiThueServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String api = request.getParameter("api");

		if ("1".equals(api)) {
			// Trả về XML danh sách tất cả gói thuê
			response.setContentType("application/xml; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				out.println("<goithue_list>");

				Connection con = Connect.getInstance().getConnect();
				GoiThueDAO goiThueDAO = new GoiThueDAO();
				MauXeDAO mauXeDAO = new MauXeDAO();

				// Lấy tất cả gói thuê từ database
				List<GoiThue> list = goiThueDAO.layTatCaGoiThue(con);

				for (GoiThue goiThue : list) {
					MauXe mauXe = mauXeDAO.layMauXeTheoId(goiThue.getMaMauXe(), con);
					String hangXe = mauXe != null ? escapeXml(mauXe.getHangXe()) : "N/A";
					String dongXe = mauXe != null ? escapeXml(mauXe.getDongXe()) : "N/A";

					out.println("  <goiThue>");
					out.println("    <maGoiThue>" + goiThue.getMaGoiThue() + "</maGoiThue>");
					out.println("    <tenGoiThue>" + escapeXml(goiThue.getTenGoiThue()) + "</tenGoiThue>");
					out.println("    <hangXe>" + hangXe + "</hangXe>");
					out.println("    <dongXe>" + dongXe + "</dongXe>");
					out.println("    <giaNgay>" + goiThue.getGiaNgay() + "</giaNgay>");
					out.println("    <giaGio>" + goiThue.getGiaGio() + "</giaGio>");
					out.println("    <phuThu>" + goiThue.getPhuThu() + "</phuThu>");
					out.println("    <giamGia>" + goiThue.getGiamGia() + "</giamGia>");
					out.println("    <phuKien>" + (goiThue.getPhuKien() != null ? escapeXml(goiThue.getPhuKien()) : "") + "</phuKien>");
					out.println("  </goiThue>");
				}

				out.println("</goithue_list>");
			} catch (Exception e) {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				try (PrintWriter out = response.getWriter()) {
					out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
					out.println("<error>" + escapeXml(e.getMessage()) + "</error>");
				}
				e.printStackTrace();
			}
		} else {
			// Forward đến JSP view
			request.getRequestDispatcher("/views/khachhang/danh-sach-goi-thue.jsp").forward(request, response);
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
