package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.DoiTacDAO;
import model.Role;
import model.TaiKhoan;
import service.AuthService;
import util.Connect;

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
        // Kiểm tra session - nếu đã đăng nhập thì redirect sang dashboard
        HttpSession session = req.getSession(false);
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
        
        // Nếu chưa đăng nhập thì hiển thị form đăng nhập
        req.getRequestDispatcher("views/auth/dangnhap.jsp").forward(req, resp);
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

        TaiKhoan tkThanhCong = null;

        try {
            tkThanhCong = authService.dangNhap(tk);
        } catch (RuntimeException e) {
            guiXML(response, 400, "error", e.getMessage(), null);
            return;
        } catch (Exception e) {
        	e.printStackTrace();
            guiXML(response, 500, "error", "Lỗi hệ thống", null);
            return;
        }
        
        if (tkThanhCong != null) {
        	HttpSession oldSession = request.getSession(false);
        	if (oldSession != null) {
        	    oldSession.invalidate();
        	}
        	HttpSession session = request.getSession(true);
            session.setAttribute("user", tkThanhCong);
            session.setAttribute("role", tkThanhCong.getRole().name());
            session.setAttribute("userID", tkThanhCong.getUserID());
            session.setAttribute("username", tkThanhCong.getUsername());
            
            // Nếu là DOI_TAC, lấy maDoiTac từ database
            if (Role.DOI_TAC.equals(tkThanhCong.getRole())) {
                try {
                    Connection con = Connect.getInstance().getConnect();
                    DoiTacDAO doiTacDAO = new DoiTacDAO();
                    int maDoiTac = doiTacDAO.layMaDoiTacTuUserID(tkThanhCong.getUserID(), con);
                    if (maDoiTac > 0) {
                        session.setAttribute("maDoiTac", maDoiTac);
                    }
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    // Fallback: sử dụng userID nếu có lỗi
                    session.setAttribute("maDoiTac", tkThanhCong.getUserID());
                }
            }

            guiXML(response, 200, "success", "Đăng nhập thành công!", tkThanhCong.getRole().name());
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
        try (PrintWriter out = resp.getWriter()) {
            out.write(xml.toString());
        }
    }
}