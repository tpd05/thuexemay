package fillter;

import service.KiemTraDoiTac;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/doitac/*")
public class DoiTacFillter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        if (!KiemTraDoiTac.checkDoiTac(req, resp)) {
            return;
        }
        chain.doFilter(request, response);
    }
}