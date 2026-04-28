package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.DoiTac;
import model.KhachHang;
import model.NguoiDung;
import model.TaiKhoan;
import service.AuthService;

@WebServlet("/dangky")
public class DangKyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Kiểm tra session - nếu đã đăng nhập thì redirect sang dashboard
        javax.servlet.http.HttpSession session = req.getSession(false);
        if (session != null) {
            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");
            
            if (username != null && role != null) {
                String ctxPath = req.getContextPath();
                if ("DOI_TAC".equals(role)) {
                    resp.sendRedirect(ctxPath + "/doitac/dashboard");
                } else if ("KHACH_HANG".equals(role)) {
                    resp.sendRedirect(ctxPath + "/khachhang/dashboard");
                } else if ("ADMIN".equals(role)) {
                    resp.sendRedirect(ctxPath + "/admin/dashboard");
                } else if ("NHAN_VIEN".equals(role)) {
                    resp.sendRedirect(ctxPath + "/nhanvien/dashboard");
                }
                return;
            }
        }
        
        // Nếu chưa đăng nhập thì hiển thị form đăng ký
        req.getRequestDispatcher("/views/auth/dangky.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            String role     = request.getParameter("role");   
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String hoTen    = request.getParameter("hoTen");
            String sdt      = request.getParameter("soDienThoai");
            String email    = request.getParameter("email");
            String cccd     = request.getParameter("soCCCD");

            if (role == null || (!role.equals("DOI_TAC") && !role.equals("KHACH_HANG"))) {
                guiXML(response, 400, "error", "Loại tài khoản không hợp lệ");
                return;
            }

            TaiKhoan tk = new TaiKhoan();
            tk.setUsername(username);
            tk.setPassword(password);

            NguoiDung nd = new NguoiDung();
            nd.setHoTen(hoTen);
            nd.setSoDienThoai(sdt);
            nd.setEmail(email != null ? email : "");
            nd.setSoCCCD(cccd);

            // Branch registration removed - partners add branches after login
            if ("DOI_TAC".equals(role)) {
                authService.dangKyTaiKhoanDoiTac(tk, nd, new DoiTac());
            } else {
                authService.dangKyTaiKhoanKhachHang(tk, nd, new KhachHang());
            }

            guiXML(response, 201, "success", "Đăng ký thành công! Vui lòng đăng nhập.");

        } catch (RuntimeException e) {
            guiXML(response, 400, "error", e.getMessage());

        } catch (Exception e) {
            e.printStackTrace();
            guiXML(response, 500, "error", e.getMessage() != null ? e.getMessage() : "Lỗi hệ thống");
        }
    }

    private void guiXML(HttpServletResponse resp, int status, String type, String msg) throws IOException {
        resp.setStatus(status);
        resp.getWriter().write(
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<response>\n" +
            "    <status>" + type + "</status>\n" +
            "    <message>" + escapeXml(msg) + "</message>\n" +
            "</response>"
        );
    }

    private String escapeXml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}