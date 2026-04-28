package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.GoiThueDAO;
import model.GoiThue;
import service.KiemTraDoiTac;

@WebServlet("/doitac/quanlygoithue")
public class TaoGoiThueServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private GoiThueDAO goiThueDAO;

    @Override
    public void init() throws ServletException {
        goiThueDAO = new GoiThueDAO();
    }

    // GET /doitac/quanlygoithue — display form hoặc API
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!KiemTraDoiTac.checkDoiTac(request, response)) return;

        String api = request.getParameter("api");
        if ("1".equals(api)) {
            handleAPIGet(request, response);
        } else {
            request.getRequestDispatcher("/views/doitac/quanlygoithue.jsp").forward(request, response);
        }
    }

    private void handleAPIGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        Integer maDoiTac = KiemTraDoiTac.layMaDoiTacCuaPhien(request);

        try {
            java.util.List<GoiThue> danhSach = goiThueDAO.layDanhSachTheoDoiTac(maDoiTac);
            
            StringBuilder xml = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<goiThues>\n");
            for (GoiThue gt : danhSach) {
                xml.append("    <goiThue>\n")
                   .append("        <maGoiThue>").append(gt.getMaGoiThue()).append("</maGoiThue>\n")
                   .append("        <maMauXe>").append(gt.getMaMauXe()).append("</maMauXe>\n")
                   .append("        <tenGoiThue>").append(escapeXml(gt.getTenGoiThue())).append("</tenGoiThue>\n")
                   .append("        <giaNgay>").append(gt.getGiaNgay()).append("</giaNgay>\n")
                   .append("        <giaTuan>").append(gt.getGiaTuan()).append("</giaTuan>\n")
                   .append("        <phuThu>").append(gt.getPhuThu()).append("</phuThu>\n")
                   .append("    </goiThue>\n");
            }
            xml.append("</goiThues>");
            response.getWriter().write(xml.toString());
        } catch (Exception e) {
            guiPhanHoiXML(response, 500, "error", "Lỗi hệ thống: " + e.getMessage());
        }
    }

    // POST /doitac/quanlygoithue — tạo gói thuê mới
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        if (!KiemTraDoiTac.checkDoiTac(request, response)) return;

        Integer maDoiTac = KiemTraDoiTac.layMaDoiTacCuaPhien(request);

        String maMauXeStr    = request.getParameter("maMauXe");
        String maChiNhanhStr = request.getParameter("maChiNhanh");
        String tenGoiThue    = request.getParameter("tenGoiThue");
        String phuKien       = request.getParameter("phuKien");
        String giaNgayStr    = request.getParameter("giaNgay");
        String giaTuanStr    = request.getParameter("giaTuan");
        String phuThuStr     = request.getParameter("phuThu");

        // Validate bắt buộc
        if (maMauXeStr == null || maMauXeStr.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Mã mẫu xe không được để trống"); return;
        }
        if (maChiNhanhStr == null || maChiNhanhStr.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Mã chi nhánh không được để trống"); return;
        }
        if (tenGoiThue == null || tenGoiThue.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Tên gói thuê không được để trống"); return;
        }
        if (giaNgayStr == null || giaNgayStr.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Giá ngày không được để trống"); return;
        }
        if (giaTuanStr == null || giaTuanStr.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Giá tuần không được để trống"); return;
        }

        int maMauXe, maChiNhanh;
        float giaNgay, giaTuan, phuThu;
        try {
            maMauXe    = Integer.parseInt(maMauXeStr.trim());
            maChiNhanh = Integer.parseInt(maChiNhanhStr.trim());
            giaNgay    = Float.parseFloat(giaNgayStr.trim());
            giaTuan    = Float.parseFloat(giaTuanStr.trim());
            phuThu     = (phuThuStr != null && !phuThuStr.trim().isEmpty())
                            ? Float.parseFloat(phuThuStr.trim()) : 0f;
        } catch (NumberFormatException e) {
            guiPhanHoiXML(response, 400, "error", "Giá trị số không hợp lệ");
            return;
        }

        // Validate giá
        if (giaNgay <= 0) {
            guiPhanHoiXML(response, 400, "error", "Giá ngày phải lớn hơn 0"); return;
        }
        if (giaTuan <= 0) {
            guiPhanHoiXML(response, 400, "error", "Giá tuần phải lớn hơn 0"); return;
        }
        if (phuThu < 0) {
            guiPhanHoiXML(response, 400, "error", "Phụ thu không được âm"); return;
        }

        GoiThue goiThue = new GoiThue();
        goiThue.setMaMauXe(maMauXe);
        goiThue.setMaDoiTac(maDoiTac);
        goiThue.setMaChiNhanh(maChiNhanh);
        goiThue.setTenGoiThue(tenGoiThue.trim());
        goiThue.setPhuKien(phuKien != null ? phuKien.trim() : "");
        goiThue.setGiaNgay(giaNgay);
        goiThue.setGiaTuan(giaTuan);
        goiThue.setPhuThu(phuThu);

        try {
            goiThueDAO.themGoiThue(goiThue);
            guiPhanHoiXML(response, 201, "success", "Tạo gói thuê thành công!");
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