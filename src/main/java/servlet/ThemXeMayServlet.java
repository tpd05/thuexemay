package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.XeMayDAO;
import model.XeMay;
import service.KiemTraDoiTac;

@WebServlet("/api/doitac/xemay")
public class ThemXeMayServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private XeMayDAO xeMayDAO;

    @Override
    public void init() throws ServletException {
        xeMayDAO = new XeMayDAO();
    }

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

        // Validate biển số: format Việt Nam cơ bản (vd: 29A-12345)
        if (!bienSo.trim().matches("^[0-9]{2}[A-Z][0-9A-Z]-[0-9]{4,5}$")) {
            guiPhanHoiXML(response, 400, "error", "Biển số không đúng định dạng (vd: 29A-12345)"); return;
        }

        XeMay xeMay = new XeMay();
        xeMay.setMaDoiTac(maDoiTac);
        xeMay.setMaMauXe(maMauXe);
        xeMay.setMaChiNhanh(maChiNhanh);
        xeMay.setBienSo(bienSo.trim().toUpperCase());
        xeMay.setSoKhung(soKhung.trim().toUpperCase());
        xeMay.setSoMay(soMay.trim().toUpperCase());
        xeMay.setTrangThai(trangThai != null ? trangThai.trim() : "san_sang");

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