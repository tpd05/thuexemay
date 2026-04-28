package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ChiNhanh;
import service.ChiNhanhService;
import service.KiemTraDoiTac;

@WebServlet("/doitac/quanlychinhanh")
public class ThemChiNhanhServlet extends HttpServlet {

    private ChiNhanhService service;

    @Override
    public void init() throws ServletException {
        service = new ChiNhanhService();
    }

    // GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!KiemTraDoiTac.checkDoiTac(request, response)) return;

        String api = request.getParameter("api");
        if ("1".equals(api)) {
            // API call - return XML
            handleAPIGet(request, response);
        } else {
            // Page request - forward JSP
            request.getRequestDispatcher("/views/doitac/quanlychinhanh.jsp").forward(request, response);
        }
    }

    private void handleAPIGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/xml;charset=UTF-8");

        Integer maDoiTac = KiemTraDoiTac.layMaDoiTacCuaPhien(request);

        try {
            if (maDoiTac == null) {
                System.out.println("DEBUG: maDoiTac is null");
                guiPhanHoiXML(response, 400, "error", "Không tìm thấy mã đối tác trong session");
                return;
            }
            
            System.out.println("DEBUG: maDoiTac = " + maDoiTac);
            var danhSach = service.layDanhSach(maDoiTac);
            
            System.out.println("DEBUG: danhSach size = " + (danhSach != null ? danhSach.size() : "null"));

            StringBuilder xml = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<chiNhanhs>\n");

            if (danhSach != null && !danhSach.isEmpty()) {
                for (ChiNhanh cn : danhSach) {
                    xml.append("    <chiNhanh>\n")
                       .append("        <maChiNhanh>").append(cn.getMaChiNhanh()).append("</maChiNhanh>\n")
                       .append("        <tenChiNhanh>").append(escapeXml(cn.getTenChiNhanh())).append("</tenChiNhanh>\n")
                       .append("        <diaDiem>").append(escapeXml(cn.getDiaDiem())).append("</diaDiem>\n")
                       .append("    </chiNhanh>\n");
                }
            }

            xml.append("</chiNhanhs>");

            String xmlResponse = xml.toString();
            System.out.println("DEBUG: XML Response = " + xmlResponse);
            response.getWriter().write(xmlResponse);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG: Exception = " + e.getMessage());
            guiPhanHoiXML(response, 500, "error", "Lỗi: " + e.getMessage());
        }
    }

    // POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/xml;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        // Check authentication without redirect for AJAX POST
        javax.servlet.http.HttpSession sess = request.getSession(false);
        if (sess == null || !"DOI_TAC".equals(sess.getAttribute("role"))) {
            guiPhanHoiXML(response, 401, "error", "Không có quyền truy cập");
            return;
        }

        Integer maDoiTac = (Integer) sess.getAttribute("maDoiTac");
        
        // Check if maDoiTac is null
        if (maDoiTac == null) {
            guiPhanHoiXML(response, 400, "error", "Không tìm thấy mã đối tác trong session");
            return;
        }

        String tenChiNhanh = request.getParameter("tenChiNhanh");
        String diaDiem = request.getParameter("diaDiem");

        if (tenChiNhanh == null || tenChiNhanh.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Tên chi nhánh không được để trống");
            return;
        }

        if (diaDiem == null || diaDiem.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Địa điểm không được để trống");
            return;
        }

        ChiNhanh cn = new ChiNhanh();
        cn.setMaDoiTac(maDoiTac);
        cn.setTenChiNhanh(tenChiNhanh.trim());
        cn.setDiaDiem(diaDiem.trim());

        try {
            service.themChiNhanh(cn);

            guiPhanHoiXML(response, 201, "success", "Thêm chi nhánh thành công!");

        } catch (RuntimeException e) {
            e.printStackTrace();
            guiPhanHoiXML(response, 400, "error", e.getMessage());

        } catch (Exception e) {
            e.printStackTrace();
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