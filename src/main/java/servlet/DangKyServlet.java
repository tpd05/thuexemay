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
        req.getRequestDispatcher("/dangky.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String role     = request.getParameter("role");       // "DOI_TAC" hoặc "KHACH_HANG"
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

        try {
            if ("DOI_TAC".equals(role)) {
                authService.dangKyTaiKhoanDoiTac(tk, nd, new DoiTac());
            } else {
                authService.dangKyTaiKhoanKhachHang(tk, nd, new KhachHang());
            }
            guiXML(response, 201, "success", "Đăng ký thành công! Vui lòng đăng nhập.");
        } catch (RuntimeException e) {
            guiXML(response, 400, "error", e.getMessage() != null ? e.getMessage() : "Đăng ký thất bại");
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