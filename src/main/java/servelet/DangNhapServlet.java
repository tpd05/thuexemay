package servelet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class DangNhapServlet
 */
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
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DangNhapServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        TaiKhoan tk = new TaiKhoan();
        tk.setUsername(username);
        tk.setPassword(password);

        String kiemTraHopLe = authService.KiemTraDangNhapHopLe(tk, null);
        if(!kiemTraHopLe.equals("OK")) {
            guiPhanHoiXML(response, 400, "error", kiemTraHopLe);
            return;
        }

        TaiKhoan tkDangNhapThanhCong = authService.DangNhapTaiKhoan(tk);

        if(tkDangNhapThanhCong != null) {
            HttpSession session = request.getSession(true);

            session.setAttribute("role", tkDangNhapThanhCong.getRole());
            
            session.setAttribute("username", tkDangNhapThanhCong.getUsername());

            if(tkDangNhapThanhCong.getRole().equalsIgnoreCase(Role.DOI_TAC.name())) {
                session.setAttribute("maDoiTac", tkDangNhapThanhCong.getUserID());
            }
            guiPhanHoiXML(response, 200, "success", "Đăng nhập thành công!");
        }else{
            guiPhanHoiXML(response, 401, "error", "Sai tài khoản hoặc mật khẩu!");
        }
    }

    private void guiPhanHoiXML(HttpServletResponse request, int statusCode, String status, String message) throws IOException {
    	request.setStatus(statusCode);
        String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                "<response>\n" +
                "    <status>" + status + "</status>\n" +
                "    <message>" + message + "</message>\n" +
                "</response>";
        request.getWriter().write(xml);
    }
}

