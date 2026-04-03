package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.TaiKhoan;
import service.AuthService;
import util.Role;

@WebServlet("/dangnhap")
public class DangNhapServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }

    // FIX: thêm .forward() để JSP load được
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/dangnhap.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        TaiKhoan tk = new TaiKhoan();
        tk.setUsername(username);
        tk.setPassword(password);

        String kiemTra = authService.kiemTraDangNhapHopLe(tk);
        if (!kiemTra.equals("OK")) {
            guiXML(response, 400, "error", kiemTra, null);
            return;
        }

        TaiKhoan tkThanhCong = authService.dangNhapTaiKhoan(tk);
        if (tkThanhCong != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("role", tkThanhCong.getRole().layGiaTri());
            session.setAttribute("userID", tkThanhCong.getUserID());
            session.setAttribute("username", tkThanhCong.getUsername());
            if (Role.DOI_TAC.equals(tkThanhCong.getRole())) {
                session.setAttribute("maDoiTac", tkThanhCong.getUserID());
            }

            guiXML(response, 200, "success", "Đăng nhập thành công!", tkThanhCong.getRole().layGiaTri());
        } else {
            guiXML(response, 401, "error", "Sai tài khoản hoặc mật khẩu!", null);
        }
    }

    private void guiXML(HttpServletResponse resp, int status, String type,
                        String message, String role) throws IOException {
        resp.setStatus(status);
        StringBuilder xml = new StringBuilder(
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<response>\n" +
            "    <status>" + type + "</status>\n" +
            "    <message>" + message + "</message>\n"
        );
        if (role != null) xml.append("    <role>").append(role).append("</role>\n");
        xml.append("</response>");
        resp.getWriter().write(xml.toString());
    }
}