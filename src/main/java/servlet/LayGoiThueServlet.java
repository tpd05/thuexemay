package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.GoiThueDAO;
import model.GoiThue;

/**
 * GET /api/doitac/goithue
 * Trả về toàn bộ gói thuê của đối tác đang đăng nhập, dạng XML.
 *
 * Lưu ý: Servlet này bổ sung doGet() cho endpoint /api/doitac/goithue.
 * Nếu dùng chung class với TaoGoiThueServlet thì hãy ghép doGet() vào đó.
 */
@WebServlet("/goithue/list")
public class LayGoiThueServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // GET /api/doitac/goithue — lấy danh sách gói thuê của đối tác
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        Integer maDoiTac = (Integer) request.getSession().getAttribute("maDoiTac");
        /*if (maDoiTac == null) {
            response.setStatus(401);
            response.getWriter().write("<error>Chưa đăng nhập</error>");
            return;
        }
        try {
            maDoiTac = Integer.parseInt(request.getParameter("madoitac"));
        } catch (Exception e) {
            response.setStatus(400);
            response.getWriter().write("<error>Thiếu maDoiTac</error>");
            return;
        }*/

        GoiThueDAO dao = new GoiThueDAO();
        List<GoiThue> list = dao.layDanhSachTheoDoiTac(maDoiTac);

        StringBuilder xml = new StringBuilder(
        	    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<goiThues>\n");

        	for (GoiThue gt : list) {
        	    xml.append("    <goiThue>\n")
        	       .append("        <maGoiThue>").append(gt.getMaGoiThue()).append("</maGoiThue>\n")
        	       .append("        <maMauXe>").append(gt.getMaMauXe()).append("</maMauXe>\n")
        	       .append("        <maChiNhanh>").append(gt.getMaChiNhanh()).append("</maChiNhanh>\n")
        	       .append("        <tenGoiThue>").append(escapeXml(gt.getTenGoiThue())).append("</tenGoiThue>\n")
        	       .append("        <phuKien>").append(escapeXml(gt.getPhuKien())).append("</phuKien>\n")
        	       .append("        <giaNgay>").append(gt.getGiaNgay()).append("</giaNgay>\n")
        	       .append("        <giaTuan>").append(gt.getGiaTuan()).append("</giaTuan>\n")
        	       .append("        <phuThu>").append(gt.getPhuThu()).append("</phuThu>\n")
        	       .append("    </goiThue>\n");
        	}

        	xml.append("</goiThues>");
        	response.getWriter().write(xml.toString());
    }

    private String escapeXml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}