package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ChiNhanhDAO;
import dao.ChiTietDonThueDAO;
import dao.GioHangDAO;
import dao.GoiThueDAO;
import dao.MucHangDAO;
import model.ChiNhanh;
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

		HttpSession session = request.getSession();
		Integer userID = (Integer) session.getAttribute("userID");

		if (userID == null) {
			response.sendRedirect(request.getContextPath() + "/views/auth/dangnhap.jsp");
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
			ChiNhanhDAO chiNhanhDAO = new ChiNhanhDAO(con);

			GioHang gioHang = gioHangDAO.layGioHangByUserID(userID, con);

			if (gioHang != null) {
				out.println("  <maGioHang>" + gioHang.getMaGioHang() + "</maGioHang>");
				out.println("  <userID>" + gioHang.getUserID() + "</userID>");
				out.println("  <diaChiNhanXe>" + escapeXml(gioHang.getDiaChiNhanXe()) + "</diaChiNhanXe>");

				List<MucHang> mucHangList = mucHangDAO.LayMucHangCuaGio(gioHang.getMaGioHang(), con);
				System.out.println("[GioHangServlet] LayMucHangCuaGio result size: " + (mucHangList != null ? mucHangList.size() : "NULL"));
				if (mucHangList != null) {
					for (MucHang mh : mucHangList) {
						System.out.println("[GioHangServlet] MucHang: maGoiThue=" + mh.getMaGoiThue() + ", soLuong=" + mh.getSoLuong());
					}
				}
				
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
					
					// Thêm branch info từ GoiThue
					if (goiThue != null) {
						ChiNhanh chiNhanh = chiNhanhDAO.layChiNhanhTheoId(goiThue.getMaChiNhanh(), con);
						if (chiNhanh != null) {
							out.println("      <branch>");
							out.println("        <maChiNhanh>" + chiNhanh.getMaChiNhanh() + "</maChiNhanh>");
							out.println("        <tenChiNhanh>" + escapeXml(chiNhanh.getTenChiNhanh()) + "</tenChiNhanh>");
							out.println("        <diaDiem>" + escapeXml(chiNhanh.getDiaDiem()) + "</diaDiem>");
							out.println("      </branch>");
						}
					}
					out.println("    </item>");
				}
				
				out.println("  </items>");
			out.println("</gio_hang>");
		}} catch (Exception e) {
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
				try {
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
				} catch (Exception e) {
					e.printStackTrace();
					try (PrintWriter out = response.getWriter()) {
						out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
						out.println("<response>");
						out.println("  <error>Lỗi kiểm tra xe: " + escapeXml(e.getMessage()) + "</error>");
						out.println("</response>");
					}
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
					String loaiNhanXe = request.getParameter("loaiNhanXe");
					String diaChiNhanXe = request.getParameter("diaChiNhanXe");
					String maChiNhanhStr = request.getParameter("maChiNhanh");
					
					// Nếu nhận xe tại cửa hàng, lấy địa chỉ chi nhánh
					if ("branch".equals(loaiNhanXe) && maChiNhanhStr != null && !maChiNhanhStr.isEmpty()) {
						int maChiNhanh = Integer.parseInt(maChiNhanhStr);
						ChiNhanhDAO chiNhanhDAO = new ChiNhanhDAO(con);
						ChiNhanh chiNhanh = chiNhanhDAO.layChiNhanhTheoId(maChiNhanh, con);
						
						if (chiNhanh != null && chiNhanh.getDiaDiem() != null) {
							diaChiNhanXe = chiNhanh.getDiaDiem();
							System.out.println("DEBUG prepareCheckout: Using branch address - " + diaChiNhanXe);
						}
					}
					
					// Cập nhật địa chỉ vào giỏ hàng
					if (diaChiNhanXe != null && !diaChiNhanXe.isEmpty()) {
						gioHang.setDiaChiNhanXe(diaChiNhanXe);
						gioHangDAO.capNhatDiaChi(gioHang, con);
						System.out.println("DEBUG prepareCheckout: Updated cart address - " + diaChiNhanXe);
					}

					// Lấy thông tin item từ frontend (format mới: itemCount, itemBatDau_N, etc.)
					String itemCountStr = request.getParameter("itemCount");
					int itemCount = (itemCountStr != null) ? Integer.parseInt(itemCountStr) : 0;
					
					System.out.println("DEBUG prepareCheckout: itemCount=" + itemCount);
					
					// Nếu có item từ frontend, dùng chúng
					List<MucHang> mucHangList = new ArrayList<>();
					
					if (itemCount > 0) {
						// Parse items từ frontend
						for (int i = 0; i < itemCount; i++) {
							String maGoiThue = request.getParameter("itemMaGoiThue_" + i);
							String batDau = request.getParameter("itemBatDau_" + i);
							String ketThuc = request.getParameter("itemKetThuc_" + i);
							String soLuongStr = request.getParameter("itemSoLuong_" + i);
							
							System.out.println("Item " + i + ": maGoiThue=" + maGoiThue + 
									", batDau=" + batDau + ", ketThuc=" + ketThuc + ", soLuong=" + soLuongStr);
							
							if (batDau == null || batDau.isEmpty()) {
								throw new Exception("Thiếu thời gian thuê cho item " + (i+1));
							}
							if (ketThuc == null || ketThuc.isEmpty()) {
								throw new Exception("Thiếu thời gian trả cho item " + (i+1));
							}
							
							// Tạo MucHang mới từ dữ liệu frontend
							MucHang mh = new MucHang();
							mh.setMaGioHang(gioHang.getMaGioHang());
							mh.setMaGoiThue(Integer.parseInt(maGoiThue));
							mh.setSoLuong(Integer.parseInt(soLuongStr));
							
							// Convert datetime-local string (yyyy-MM-ddTHH:mm) to LocalDateTime
							DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
							LocalDateTime batDauLDT = LocalDateTime.parse(batDau, formatter);
							LocalDateTime ketThucLDT = LocalDateTime.parse(ketThuc, formatter);
							
							mh.setThoiGianBatDau(batDauLDT);
							mh.setThoiGianKetThuc(ketThucLDT);
							
							// Lấy GoiThue detail
							GoiThue gt = goiThueDAO.layGoiThueTheoId(mh.getMaGoiThue(), con);
							mh.setGoiThue(gt);
							
							mucHangList.add(mh);
						}
					} else {
						// Fallback: Lấy từ database nếu không có item từ frontend
						mucHangList = mucHangDAO.LayMucHangCuaGio(gioHang.getMaGioHang(), con);
						for (MucHang mh : mucHangList) {
							GoiThue gt = goiThueDAO.layGoiThueTheoId(mh.getMaGoiThue(), con);
							mh.setGoiThue(gt);
						}
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
					System.out.println("ERROR in prepareCheckout: " + e.getMessage());
					e.printStackTrace();
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
