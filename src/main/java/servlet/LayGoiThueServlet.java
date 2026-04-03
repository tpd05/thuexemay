package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.KiemTraDoiTac;
import util.Connect;

/**
 * GET /api/doitac/goithue
 * Trả về toàn bộ gói thuê của đối tác đang đăng nhập, dạng XML.
 *
 * Lưu ý: Servlet này bổ sung doGet() cho endpoint /api/doitac/goithue.
 * Nếu dùng chung class với TaoGoiThueServlet thì hãy ghép doGet() vào đó.
 */
@WebServlet("/api/doitac/goithue/list")
public class LayGoiThueServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // GET /api/doitac/goithue — lấy danh sách gói thuê của đối tác
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        if (!KiemTraDoiTac.checkDoiTac(request, response)) return;

        Integer maDoiTac = KiemTraDoiTac.layMaDoiTacCuaPhien(request);

        String sql =
            "SELECT gt.maGoiThue, gt.maMauXe, gt.maChiNhanh, gt.tenGoiThue, " +
            "       gt.phuKien, gt.giaNgay, gt.giaGio, gt.phuThu, gt.giamGia " +
            "FROM GoiThue gt " +
            "WHERE gt.maDoiTac = ? " +
            "ORDER BY gt.maGoiThue DESC";

        Connection con = null;
        try {
            con = Connect.getInstance().getConnect();
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, maDoiTac);
                try (ResultSet rs = ps.executeQuery()) {

                    StringBuilder xml = new StringBuilder(
                        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<goiThues>\n");

                    while (rs.next()) {
                        xml.append("    <goiThue>\n")
                           .append("        <maGoiThue>").append(rs.getInt("maGoiThue")).append("</maGoiThue>\n")
                           .append("        <maMauXe>").append(rs.getInt("maMauXe")).append("</maMauXe>\n")
                           .append("        <maChiNhanh>").append(rs.getInt("maChiNhanh")).append("</maChiNhanh>\n")
                           .append("        <tenGoiThue>").append(escapeXml(rs.getString("tenGoiThue"))).append("</tenGoiThue>\n")
                           .append("        <phuKien>").append(escapeXml(rs.getString("phuKien"))).append("</phuKien>\n")
                           .append("        <giaNgay>").append(rs.getFloat("giaNgay")).append("</giaNgay>\n")
                           .append("        <giaGio>").append(rs.getFloat("giaGio")).append("</giaGio>\n")
                           .append("        <phuThu>").append(rs.getFloat("phuThu")).append("</phuThu>\n")
                           .append("        <giamGia>").append(rs.getFloat("giamGia")).append("</giamGia>\n")
                           .append("    </goiThue>\n");
                    }

                    xml.append("</goiThues>");
                    response.getWriter().write(xml.toString());
                }
            }
        } catch (SQLException e) {
            response.setStatus(500);
            response.getWriter().write(
                "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                "<error><status>500</status><message>" + escapeXml(e.getMessage()) + "</message></error>"
            );
        } finally {
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
    }

    private String escapeXml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}