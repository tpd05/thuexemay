package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Role;
import model.TaiKhoan;

/**
 * Servlet Filter implementation class AuthFilter
 */
@WebFilter("/*")
public class AuthFilter extends HttpFilter implements Filter {
       
    /**
     * @see HttpFilter#HttpFilter()
     */
    public AuthFilter() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	protected void doFilter(HttpServletRequest req, HttpServletResponse resp, FilterChain chain)
	        throws IOException, ServletException {

	    String uri = req.getRequestURI();
	    String context = req.getContextPath();
	    String path = uri.substring(context.length());

	    if (path.startsWith("/dangnhap") || path.startsWith("/dangky")
	        || path.startsWith("/views/auth")
	        || path.startsWith("/khachhang/thanhtoan/mock")
	        || path.startsWith("/css")
	        || path.startsWith("/js")
	        || path.startsWith("/dist")
	        || path.startsWith("/images")
	        || path.startsWith("/public")
	        || path.equals("/")
	        || path.equals("")) {
	        chain.doFilter(req, resp);
	        return;
	    }

	    HttpSession session = req.getSession(false);
	    TaiKhoan user = (session != null) ? (TaiKhoan) session.getAttribute("user") : null;

	    if (user == null) {
	        resp.sendRedirect(context + "/dangnhap");
	        return;
	    }

	    if (path.startsWith("/views/doitac") && !Role.DOI_TAC.equals(user.getRole())) {
	        resp.sendRedirect(context + "/views/403.jsp");
	        return;
	    }

	    if (path.startsWith("/views/khachhang") && !Role.KHACH_HANG.equals(user.getRole())) {
	        resp.sendRedirect(context + "/views/403.jsp");
	        return;
	    }

	    chain.doFilter(req, resp);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
