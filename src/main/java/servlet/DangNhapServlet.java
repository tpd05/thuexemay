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

@WebServlet("/api/xacthuc/dangnhap")
public class DangNhapServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	req.getRequestDispatcher("dangnhap.jsp");
    	
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

        String kiemTraHopLe = authService.kiemTraDangNhapHopLe(tk);
        if (!kiemTraHopLe.equals("OK")) {
            guiPhanHoiXML(response, 400, "error", kiemTraHopLe);
            return;
        }

        TaiKhoan tkDangNhapThanhCong = authService.dangNhapTaiKhoan(tk);

        if (tkDangNhapThanhCong != null) {
            HttpSession session = request.getSession(true);

            session.setAttribute("role", tkDangNhapThanhCong.getRole().layGiaTri());
            session.setAttribute("userID", tkDangNhapThanhCong.getUserID());
            session.setAttribute("username", tkDangNhapThanhCong.getUsername());

            if (Role.DOI_TAC.equals(tkDangNhapThanhCong.getRole())) {
                session.setAttribute("maDoiTac", tkDangNhapThanhCong.getUserID());
            }

            guiPhanHoiXML(response, 200, "success", "Đăng nhập thành công!");
        } else {
            guiPhanHoiXML(response, 401, "error", "Sai tài khoản hoặc mật khẩu!");
        }
    }

    private void guiPhanHoiXML(HttpServletResponse response, int statusCode,
                                String status, String message) throws IOException {
        response.setStatus(statusCode);
        String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                "<response>\n" +
                "    <status>" + status + "</status>\n" +
                "    <message>" + message + "</message>\n" +
                "</response>";
        response.getWriter().write(xml);
    }
}