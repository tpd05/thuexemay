package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ChiNhanhDAO;
import model.ChiNhanh;
import service.KiemTraDoiTac;

@WebServlet("/doitac/chinhanh")
public class ThemChiNhanhServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ChiNhanhDAO chiNhanhDAO;

    @Override
    public void init() throws ServletException {
        chiNhanhDAO = new ChiNhanhDAO();
    }

    // GET /api/doitac/chinhanh — lấy danh sách chi nhánh của đối tác
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        if (!KiemTraDoiTac.checkDoiTac(request, response)) return;

        Integer maDoiTac = KiemTraDoiTac.layMaDoiTacCuaPhien(request);

        try {
            var danhSach = chiNhanhDAO.layToanBoChiNhanh(maDoiTac);
            StringBuilder xml = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<chiNhanhs>\n");
            for (ChiNhanh cn : danhSach) {
                xml.append("    <chiNhanh>\n")
                   .append("        <maChiNhanh>").append(cn.getMaChiNhanh()).append("</maChiNhanh>\n")
                   .append("        <tenChiNhanh>").append(escapeXml(cn.getTenChiNhanh())).append("</tenChiNhanh>\n")
                   .append("        <diaDiem>").append(escapeXml(cn.getDiaDiem())).append("</diaDiem>\n")
                   .append("    </chiNhanh>\n");
            }
            xml.append("</chiNhanhs>");
            response.getWriter().write(xml.toString());
        } catch (Exception e) {
            guiPhanHoiXML(response, 500, "error", "Lỗi hệ thống: " + e.getMessage());
        }
    }

    // POST /api/doitac/chinhanh — thêm chi nhánh mới
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        if (!KiemTraDoiTac.checkDoiTac(request, response)) return;

        Integer maDoiTac = KiemTraDoiTac.layMaDoiTacCuaPhien(request);
        String tenChiNhanh = request.getParameter("tenChiNhanh");
        String diaDiem = request.getParameter("diaDiem");

        // Validate
        if (tenChiNhanh == null || tenChiNhanh.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Tên chi nhánh không được để trống");
            return;
        }
        if (diaDiem == null || diaDiem.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Địa điểm không được để trống");
            return;
        }

        ChiNhanh chiNhanh = new ChiNhanh();
        chiNhanh.setMaDoiTac(maDoiTac);
        chiNhanh.setTenChiNhanh(tenChiNhanh.trim());
        chiNhanh.setDiaDiem(diaDiem.trim());

        try {
            chiNhanhDAO.themChiNhanh(chiNhanh);
            guiPhanHoiXML(response, 201, "success", "Thêm chi nhánh thành công!");
        } catch (IllegalArgumentException e) {
            guiPhanHoiXML(response, 409, "error", e.getMessage());
        } catch (Exception e) {
            guiPhanHoiXML(response, 500, "error", "Lỗi hệ thống: " + e.getMessage());
        }
    }

    private void guiPhanHoiXML(HttpServletResponse response, int status,
                                String type, String message) throws IOException {
        response.setStatus(status);
        response.getWriter().write(
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<response>\n" +
            "    <status>" + type + "</status>\n" +
            "    <message>" + escapeXml(message) + "</message>\n" +
            "</response>"
        );
    }

    private String escapeXml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}