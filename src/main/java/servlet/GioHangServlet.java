package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ChiTietDonThueDAO;
import dao.GioHangDAO;
import dao.GoiThueDAO;
import dao.MucHangDAO;
import model.DonThue;
import model.GioHang;
import model.GoiThue;
import model.MucHang;
import service.DonThueService;
import service.GioHangService;
import util.Connect;

@WebServlet("/khachhang/giohang")
public class GioHangServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String api = request.getParameter("api");
		String checkout = request.getParameter("checkout");

		HttpSession session = request.getSession();
		Integer userID = (Integer) session.getAttribute("userID");

		if (userID == null) {
			response.sendRedirect(request.getContextPath() + "/views/auth/dangnhap.jsp");
			return;
		}

		// Route: /khachhang/giohang?checkout=1 → show preview + confirmation page
		if ("1".equals(checkout)) {
			try {
				Connection con = Connect.getInstance().getConnect();
				GioHangDAO gioHangDAO = new GioHangDAO();
				MucHangDAO mucHangDAO = new MucHangDAO();
				GoiThueDAO goiThueDAO = new GoiThueDAO();

				GioHang gioHang = gioHangDAO.layGioHangByUserID(userID, con);

				if (gioHang == null) {
					response.sendRedirect(request.getContextPath() + "/khachhang/giohang");
					return;
				}

				// Lấy mục hàng có đầy đủ thông tin
				List<MucHang> mucHangList = mucHangDAO.LayMucHangCuaGio(gioHang.getMaGioHang(), con);

				for (MucHang mh : mucHangList) {
					GoiThue gt = goiThueDAO.layGoiThueTheoId(mh.getMaGoiThue(), con);
					mh.setGoiThue(gt);
				}

				// Tạo đơn ảo
				DonThueService donService = new DonThueService();
				DonThue donThueAo = donService.taoDonThueAo(gioHang, mucHangList);

				// Lưu vào session để dùng trong JSP
				session.setAttribute("donThueAo", donThueAo);
				session.setAttribute("gioHangAo", gioHang);

				// Forward đến checkout.jsp
				request.getRequestDispatcher("/views/khachhang/checkout.jsp").forward(request, response);

			} catch (Exception e) {
				request.setAttribute("errorMessage", e.getMessage());
				request.getRequestDispatcher("/views/khachhang/giohang.jsp").forward(request, response);
			}
			return;
		}

		if ("1".equals(api)) {
			// Trả về XML giỏ hàng của khách hàng
			response.setContentType("application/xml; charset=UTF-8");
			try (PrintWriter out = response.getWriter()) {
				out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				out.println("<gio_hang>");

				Connection con = Connect.getInstance().getConnect();
				GioHangDAO gioHangDAO = new GioHangDAO();
				MucHangDAO mucHangDAO = new MucHangDAO();
				GoiThueDAO goiThueDAO = new GoiThueDAO();

				GioHang gioHang = gioHangDAO.layGioHangByUserID(userID, con);

				if (gioHang != null) {
					out.println("  <maGioHang>" + gioHang.getMaGioHang() + "</maGioHang>");
					out.println("  <userID>" + gioHang.getUserID() + "</userID>");
					out.println("  <diaChiNhanXe>" + escapeXml(gioHang.getDiaChiNhanXe()) + "</diaChiNhanXe>");

					List<MucHang> mucHangList = mucHangDAO.LayMucHangCuaGio(gioHang.getMaGioHang(), con);
					out.println("  <items>");

					for (MucHang mh : mucHangList) {
						GoiThue goiThue = goiThueDAO.layGoiThueTheoId(mh.getMaGoiThue(), con);
						out.println("    <item>");
						out.println("      <maGoiThue>" + mh.getMaGoiThue() + "</maGoiThue>");
						out.println("      <tenGoiThue>" + (goiThue != null ? escapeXml(goiThue.getTenGoiThue()) : "N/A") + "</tenGoiThue>");
						out.println("      <soLuong>" + mh.getSoLuong() + "</soLuong>");
						out.println("      <giaNgay>" + (goiThue != null ? goiThue.getGiaNgay() : 0) + "</giaNgay>");
						out.println("      <giaGio>" + (goiThue != null ? goiThue.getGiaGio() : 0) + "</giaGio>");
						if (mh.getThoiGianBatDau() != null) {
							out.println("      <thoiGianBatDau>" + mh.getThoiGianBatDau() + "</thoiGianBatDau>");
						}
						if (mh.getThoiGianKetThuc() != null) {
							out.println("      <thoiGianKetThuc>" + mh.getThoiGianKetThuc() + "</thoiGianKetThuc>");
						}
						out.println("    </item>");
					}
					out.println("  </items>");
				}

				out.println("</gio_hang>");
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
			request.getRequestDispatcher("/views/khachhang/giohang.jsp").forward(request, response);
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
				out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				out.println("<error>Bạn cần đăng nhập trước</error>");
			}
			return;
		}

		response.setContentType("application/xml; charset=UTF-8");

		try {
			Connection con = Connect.getInstance().getConnect();
			GioHangDAO gioHangDAO = new GioHangDAO();
			MucHangDAO mucHangDAO = new MucHangDAO();
			GoiThueDAO goiThueDAO = new GoiThueDAO();

			GioHang gioHang = gioHangDAO.layGioHangByUserID(userID, con);

			if (gioHang == null) {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				try (PrintWriter out = response.getWriter()) {
					out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
					out.println("<error>Không tìm thấy giỏ hàng</error>");
				}
				return;
			}

			if ("checkAvailable".equals(action)) {
				// Kiểm tra số xe còn trống cho khoảng thời gian
				int maGoiThue = Integer.parseInt(request.getParameter("maGoiThue"));
				String thoiGianBatDauStr = request.getParameter("thoiGianBatDau");
				String thoiGianKetThucStr = request.getParameter("thoiGianKetThuc");

				DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
				LocalDateTime thoiGianBatDau = LocalDateTime.parse(thoiGianBatDauStr, formatter);
				LocalDateTime thoiGianKetThuc = LocalDateTime.parse(thoiGianKetThucStr, formatter);

				// Tính số xe còn trống
				int tongXe = goiThueDAO.demTongXe(maGoiThue, con);
				ChiTietDonThueDAO ctDAO = new ChiTietDonThueDAO();
				int daThue = ctDAO.demXeDaThue(maGoiThue, thoiGianBatDau, thoiGianKetThuc, con);
				int soLuongCon = tongXe - daThue;

				try (PrintWriter out = response.getWriter()) {
					out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
					out.println("<response>");
					out.println("  <status>success</status>");
					out.println("  <soLuongCon>" + soLuongCon + "</soLuongCon>");
					out.println("  <tongXe>" + tongXe + "</tongXe>");
					out.println("  <daThue>" + daThue + "</daThue>");
					out.println("</response>");
				}

			} else if ("update".equals(action)) {
				// Cập nhật thời gian và số lượng xe
				int maGoiThue = Integer.parseInt(request.getParameter("maGoiThue"));
				int soLuong = Integer.parseInt(request.getParameter("soLuong"));
				String thoiGianBatDauStr = request.getParameter("thoiGianBatDau");
				String thoiGianKetThucStr = request.getParameter("thoiGianKetThuc");

				DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
				LocalDateTime thoiGianBatDau = LocalDateTime.parse(thoiGianBatDauStr, formatter);
				LocalDateTime thoiGianKetThuc = LocalDateTime.parse(thoiGianKetThucStr, formatter);

				MucHang mh = new MucHang();
				mh.setMaGioHang(gioHang.getMaGioHang());
				mh.setMaGoiThue(maGoiThue);
				mh.setSoLuong(soLuong);
				mh.setThoiGianBatDau(thoiGianBatDau);
				mh.setThoiGianKetThuc(thoiGianKetThuc);

				GioHangService service = new GioHangService();
				try {
					boolean success = service.capNhatMucHang(mh, gioHang);
					try (PrintWriter out = response.getWriter()) {
						out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
						out.println("<response>");
						out.println("  <status>" + (success ? "success" : "error") + "</status>");
						out.println("</response>");
					}
				} catch (Exception e) {
					try (PrintWriter out = response.getWriter()) {
						out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
						out.println("<response>");
						out.println("  <status>error</status>");
						out.println("  <message>" + escapeXml(e.getMessage()) + "</message>");
						out.println("</response>");
					}
				}

			} else if ("delete".equals(action)) {
				// Xóa mục
				int maGoiThue = Integer.parseInt(request.getParameter("maGoiThue"));
				java.util.List<Integer> ids = new java.util.ArrayList<>();
				ids.add(maGoiThue);

				boolean success = mucHangDAO.xoaMucHang(gioHang.getMaGioHang(), ids, con);

				try (PrintWriter out = response.getWriter()) {
					out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
					out.println("<response>");
					out.println("  <status>" + (success ? "success" : "error") + "</status>");
					out.println("</response>");
				}
			} else if ("checkout".equals(action)) {
				// Redirect to preview/confirmation page
				response.sendRedirect(request.getContextPath() + "/khachhang/giohang?checkout=1");
				return;
				
			} else if ("confirmCheckout".equals(action)) {
				// Xác nhận tạo đơn từ session
				DonThue donThueAo = (DonThue) session.getAttribute("donThueAo");
				
				if (donThueAo == null) {
					try (PrintWriter out = response.getWriter()) {
						out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
						out.println("<response>");
						out.println("  <status>error</status>");
						out.println("  <message>Không tìm thấy đơn ảo, vui lòng quay lại giỏ hàng</message>");
						out.println("</response>");
					}
					return;
				}
				
				try {
					DonThueService donService = new DonThueService();
					int maDon = donService.xacNhanDonThue(donThueAo);
					
					if (maDon > 0) {
						// Xoá session
						session.removeAttribute("donThueAo");
						session.removeAttribute("gioHangAo");
						
						try (PrintWriter out = response.getWriter()) {
							out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
							out.println("<response>");
							out.println("  <status>success</status>");
							out.println("  <message>Đơn thuê được tạo thành công</message>");
							out.println("  <maDon>" + maDon + "</maDon>");
							out.println("</response>");
						}
					} else {
						try (PrintWriter out = response.getWriter()) {
							out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
							out.println("<response>");
							out.println("  <status>error</status>");
							out.println("  <message>Lưu đơn thất bại</message>");
							out.println("</response>");
						}
					}
				} catch (Exception e) {
					try (PrintWriter out = response.getWriter()) {
						out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
						out.println("<response>");
						out.println("  <status>error</status>");
						out.println("  <message>" + escapeXml(e.getMessage()) + "</message>");
						out.println("</response>");
					}
				}
				
			
			} else if ("updateAddress".equals(action)) {
				// Cập nhật địa chỉ nhận xe
				String diaChiNhanXe = request.getParameter("diaChiNhanXe");
				gioHang.setDiaChiNhanXe(diaChiNhanXe);

				boolean success = gioHangDAO.capNhatDiaChi(gioHang, con);

				try (PrintWriter out = response.getWriter()) {
					out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
					out.println("<response>");
					out.println("  <status>" + (success ? "success" : "error") + "</status>");
					out.println("</response>");
				}
			} else if ("prepareCheckout".equals(action)) {
				// Chuẩn bị checkout - tạo DonThueAo từ giỏ hàng
				try {
					String diaChiNhanXe = request.getParameter("diaChiNhanXe");
					if (diaChiNhanXe != null && !diaChiNhanXe.isEmpty()) {
						gioHang.setDiaChiNhanXe(diaChiNhanXe);
						gioHangDAO.capNhatDiaChi(gioHang, con);
					}

					// Lấy mục hàng có đầy đủ thông tin
					List<MucHang> mucHangList = mucHangDAO.LayMucHangCuaGio(gioHang.getMaGioHang(), con);

					for (MucHang mh : mucHangList) {
						GoiThue gt = goiThueDAO.layGoiThueTheoId(mh.getMaGoiThue(), con);
						mh.setGoiThue(gt);
					}

					// Tạo đơn ảo
					DonThueService donService = new DonThueService();
					DonThue donThueAo = donService.taoDonThueAo(gioHang, mucHangList);

					// Lưu vào session
					session.setAttribute("donThueAo", donThueAo);
					session.setAttribute("gioHangAo", gioHang);

					try (PrintWriter out = response.getWriter()) {
						out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
						out.println("<response>");
						out.println("  <status>success</status>");
						out.println("  <message>Chuẩn bị thanh toán thành công</message>");
						out.println("</response>");
					}
				} catch (Exception e) {
					try (PrintWriter out = response.getWriter()) {
						out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
						out.println("<response>");
						out.println("  <status>error</status>");
						out.println("  <message>" + escapeXml(e.getMessage()) + "</message>");
						out.println("</response>");
					}
				}
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
