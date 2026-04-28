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

		if ("filter-options".equals(api)) {
			// Return provinces and wards data from API (frontend will load)
			response.setContentType("application/json; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				out.println("{");
				out.println("  \"status\": \"success\",");
				out.println("  \"message\": \"Frontend loads provinces/wards from https://provinces.open-api.vn/api/v2/\"");
				out.println("}");
			}
		} else if ("price-stats".equals(api)) {
			// Return price statistics
			response.setContentType("application/json; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				Connection con = Connect.getInstance().getConnect();
				GoiThueDAO goiThueDAO = new GoiThueDAO();
				Map<String, Object> stats = goiThueDAO.getPriceStats(con);

				out.println("{");
				out.println("  \"status\": \"success\",");
				out.println("  \"giaNgay\": {");
				out.println("    \"min\": " + stats.getOrDefault("minNgay", 0) + ",");
				out.println("    \"max\": " + stats.getOrDefault("maxNgay", 0));
				out.println("  },");
				out.println("  \"giaTuan\": {");
				out.println("    \"min\": " + stats.getOrDefault("minTuan", 0) + ",");
				out.println("    \"max\": " + stats.getOrDefault("maxTuan", 0));
				out.println("  }");
				out.println("}");
			} catch (Exception e) {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				try (PrintWriter out = response.getWriter()) {
					out.println("{\"status\": \"error\", \"message\": \"" + escapeJson(e.getMessage()) + "\"}");
				}
				e.printStackTrace();
			}
		} else if ("list".equals(api)) {
			// Return filtered GoiThue list
			response.setContentType("application/xml; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				// Parse filter parameters
				String diaDiem = request.getParameter("diaDiem");  // Format: "Xã/Phường, Tỉnh"
				String priceType = request.getParameter("priceType");
				String minPriceStr = request.getParameter("minPrice");
				String maxPriceStr = request.getParameter("maxPrice");

				Float minPrice = null, maxPrice = null;
				if (minPriceStr != null && !minPriceStr.isEmpty()) {
					minPrice = Float.parseFloat(minPriceStr);
				}
				if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
					maxPrice = Float.parseFloat(maxPriceStr);
				}

				Connection con = Connect.getInstance().getConnect();
				GoiThueDAO goiThueDAO = new GoiThueDAO();
				MauXeDAO mauXeDAO = new MauXeDAO();

				// Get ChiNhanh IDs by diaDiem if provided
				List<Integer> chiNhanhIds = null;
				if (diaDiem != null && !diaDiem.isEmpty()) {
					chiNhanhIds = goiThueDAO.layChiNhanhIdsByDiaDiem(diaDiem, con);
					// If location is selected but no branches found with this location, return empty result
					if (chiNhanhIds.isEmpty()) {
						out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
						out.println("<goithue_list>");
						out.println("  <filter_applied>");
						out.println("    <diaDiem>" + escapeXml(diaDiem) + "</diaDiem>");
						out.println("  </filter_applied>");
						out.println("  <total_count>0</total_count>");
						out.println("</goithue_list>");
						return;
					}
				}

				// Get filtered GoiThue list
				List<GoiThue> list = goiThueDAO.layGoiThueByLocationAndPrice(
					chiNhanhIds, priceType, minPrice, maxPrice, con
				);

				out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				out.println("<goithue_list>");
				out.println("  <filter_applied>");
				if (diaDiem != null && !diaDiem.isEmpty()) {
					out.println("    <diaDiem>" + escapeXml(diaDiem) + "</diaDiem>");
				}
				if (priceType != null && !priceType.isEmpty()) {
					out.println("    <priceType>" + escapeXml(priceType) + "</priceType>");
				}
				if (minPrice != null) {
					out.println("    <minPrice>" + minPrice + "</minPrice>");
				}
				if (maxPrice != null) {
					out.println("    <maxPrice>" + maxPrice + "</maxPrice>");
				}
				out.println("  </filter_applied>");
				out.println("  <total_count>" + list.size() + "</total_count>");

				for (GoiThue goiThue : list) {
					MauXe mauXe = mauXeDAO.layMauXeTheoId(goiThue.getMaMauXe(), con);
					String hangXe = mauXe != null ? escapeXml(mauXe.getHangXe()) : "N/A";
					String dongXe = mauXe != null ? escapeXml(mauXe.getDongXe()) : "N/A";
					String urlHinhAnh = "";
					if (mauXe != null && mauXe.getUrlHinhAnh() != null && !mauXe.getUrlHinhAnh().isEmpty()) {
						urlHinhAnh = mauXe.getUrlHinhAnh();
						// If it's just a filename, prepend the path
						if (!urlHinhAnh.startsWith("/")) {
							urlHinhAnh = "/public/img/mauXe/" + urlHinhAnh;
						}
						urlHinhAnh = escapeXml(urlHinhAnh);
					}

					out.println("  <goiThue>");
					out.println("    <maGoiThue>" + goiThue.getMaGoiThue() + "</maGoiThue>");
					out.println("    <tenGoiThue>" + escapeXml(goiThue.getTenGoiThue()) + "</tenGoiThue>");
					out.println("    <maMauXe>" + goiThue.getMaMauXe() + "</maMauXe>");
					out.println("    <hangXe>" + hangXe + "</hangXe>");
					out.println("    <dongXe>" + dongXe + "</dongXe>");
					out.println("    <urlHinhAnh>" + urlHinhAnh + "</urlHinhAnh>");
					out.println("    <giaNgay>" + goiThue.getGiaNgay() + "</giaNgay>");
					out.println("    <giaTuan>" + goiThue.getGiaTuan() + "</giaTuan>");
					out.println("    <phuThu>" + goiThue.getPhuThu() + "</phuThu>");
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
		} else if ("1".equals(api)) {
			// Legacy endpoint: Return all GoiThue without filters
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
					String urlHinhAnh = "";
					if (mauXe != null && mauXe.getUrlHinhAnh() != null && !mauXe.getUrlHinhAnh().isEmpty()) {
						urlHinhAnh = mauXe.getUrlHinhAnh();
						// If it's just a filename, prepend the path
						if (!urlHinhAnh.startsWith("/")) {
							urlHinhAnh = "/public/img/mauXe/" + urlHinhAnh;
						}
						urlHinhAnh = escapeXml(urlHinhAnh);
					}

					out.println("  <goiThue>");
					out.println("    <maGoiThue>" + goiThue.getMaGoiThue() + "</maGoiThue>");
					out.println("    <tenGoiThue>" + escapeXml(goiThue.getTenGoiThue()) + "</tenGoiThue>");
					out.println("    <maMauXe>" + goiThue.getMaMauXe() + "</maMauXe>");
					out.println("    <hangXe>" + hangXe + "</hangXe>");
					out.println("    <dongXe>" + dongXe + "</dongXe>");
					out.println("    <urlHinhAnh>" + urlHinhAnh + "</urlHinhAnh>");
					out.println("    <giaNgay>" + goiThue.getGiaNgay() + "</giaNgay>");
					out.println("    <giaTuan>" + goiThue.getGiaTuan() + "</giaTuan>");
					out.println("    <phuThu>" + goiThue.getPhuThu() + "</phuThu>");

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
			// Forward đến JSP view (danh-sach-goi-thue.jsp)
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

	private String escapeJson(String text) {
		if (text == null) return "";
		return text.replace("\\", "\\\\")
				   .replace("\"", "\\\"")
				   .replace("\n", "\\n")
				   .replace("\r", "\\r");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
