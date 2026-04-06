package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.XeMayDAO;
import model.XeMay;
import service.KiemTraDoiTac;

@WebServlet("/doitac/quanlyxemay")
public class ThemXeMayServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private XeMayDAO xeMayDAO;

    @Override
    public void init() throws ServletException {
        xeMayDAO = new XeMayDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!KiemTraDoiTac.checkDoiTac(request, response)) return;

        String api = request.getParameter("api");
        if ("1".equals(api)) {
            handleAPIGet(request, response);
        } else {
            request.getRequestDispatcher("/views/doitac/quanlyxemay.jsp").forward(request, response);
        }
    }

    private void handleAPIGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        Integer maDoiTac = KiemTraDoiTac.layMaDoiTacCuaPhien(request);

        try {
            List<XeMay> danhSach;
            String maChiNhanhStr = request.getParameter("maChiNhanh");
            if (maChiNhanhStr != null && !maChiNhanhStr.trim().isEmpty()) {
                int maChiNhanh = Integer.parseInt(maChiNhanhStr.trim());
                danhSach = xeMayDAO.layDanhSachXeMayTheoChiNhanh(maChiNhanh, maDoiTac);
            } else {
                danhSach = xeMayDAO.layDanhSachXeMayTheoDoiTac(maDoiTac);
            }

            StringBuilder xml = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<xeMays>\n");
            for (XeMay xm : danhSach) {
                xml.append("    <xeMay>\n")
                   .append("        <maXe>").append(xm.getMaXe()).append("</maXe>\n")
                   .append("        <maMauXe>").append(xm.getMaMauXe()).append("</maMauXe>\n")
                   .append("        <maChiNhanh>").append(xm.getMaChiNhanh()).append("</maChiNhanh>\n")
                   .append("        <bienSo>").append(escapeXml(xm.getBienSo())).append("</bienSo>\n")
                   .append("        <soKhung>").append(escapeXml(xm.getSoKhung())).append("</soKhung>\n")
                   .append("        <soMay>").append(escapeXml(xm.getSoMay())).append("</soMay>\n")
                   .append("        <hangXe>").append(escapeXml(xm.getHangXe())).append("</hangXe>\n")
                   .append("        <dongXe>").append(escapeXml(xm.getDongXe())).append("</dongXe>\n")
                   .append("        <trangThai>").append(escapeXml(xm.getTrangThai())).append("</trangThai>\n")
                   .append("    </xeMay>\n");
            }
            xml.append("</xeMays>");
            response.getWriter().write(xml.toString());

        } catch (NumberFormatException e) {
            guiPhanHoiXML(response, 400, "error", "Mã chi nhánh không hợp lệ");
        } catch (Exception e) {
            guiPhanHoiXML(response, 500, "error", "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * POST /doitac/xemay – thêm xe máy mới.
     * maDoiTac lấy từ session, không nhận từ form.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        if (!KiemTraDoiTac.checkDoiTac(request, response)) return;

        Integer maDoiTac = KiemTraDoiTac.layMaDoiTacCuaPhien(request);

        String maMauXeStr    = request.getParameter("maMauXe");
        String maChiNhanhStr = request.getParameter("maChiNhanh");
        String bienSo        = request.getParameter("bienSo");
        String soKhung       = request.getParameter("soKhung");
        String soMay         = request.getParameter("soMay");
        String trangThai     = request.getParameter("trangThai");

        // Validate
        if (maMauXeStr == null || maMauXeStr.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Mã mẫu xe không được để trống"); return;
        }
        if (maChiNhanhStr == null || maChiNhanhStr.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Mã chi nhánh không được để trống"); return;
        }
        if (bienSo == null || bienSo.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Biển số không được để trống"); return;
        }
        if (soKhung == null || soKhung.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Số khung không được để trống"); return;
        }
        if (soMay == null || soMay.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Số máy không được để trống"); return;
        }

        int maMauXe, maChiNhanh;
        try {
            maMauXe    = Integer.parseInt(maMauXeStr.trim());
            maChiNhanh = Integer.parseInt(maChiNhanhStr.trim());
        } catch (NumberFormatException e) {
            guiPhanHoiXML(response, 400, "error", "Mã mẫu xe hoặc mã chi nhánh không hợp lệ");
            return;
        }

        if (!bienSo.trim().matches("^[0-9]{2}[A-Z][0-9A-Z]-[0-9]{4,5}$")) {
            guiPhanHoiXML(response, 400, "error", "Biển số không đúng định dạng (VD: 20A1-12345)"); return;
        }

        XeMay xeMay = new XeMay();
        xeMay.setMaDoiTac(maDoiTac);
        xeMay.setMaMauXe(maMauXe);
        xeMay.setMaChiNhanh(maChiNhanh);
        xeMay.setBienSo(bienSo.trim().toUpperCase());
        xeMay.setSoKhung(soKhung.trim().toUpperCase());
        xeMay.setSoMay(soMay.trim().toUpperCase());
        xeMay.setTrangThai(trangThai != null && !trangThai.trim().isEmpty()
                            ? trangThai.trim() : "san_sang");

        try {
            xeMayDAO.themXeMay(xeMay);
            guiPhanHoiXML(response, 201, "success", "Thêm xe máy thành công!");
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