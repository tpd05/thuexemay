package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MauXeDAO;
import model.MauXe;
import service.KiemTraDoiTac;

@WebServlet("/doitac/quanlymauxe")
public class ThemMauXeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private MauXeDAO mauXeDAO;

    @Override
    public void init() throws ServletException {
        mauXeDAO = new MauXeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!KiemTraDoiTac.checkDoiTac(request, response)) return;

        String api = request.getParameter("api");
        if ("1".equals(api)) {
            handleAPIGet(request, response);
        } else {
            request.getRequestDispatcher("/views/doitac/quanlymauxe.jsp").forward(request, response);
        }
    }

    private void handleAPIGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        Integer maDoiTac = KiemTraDoiTac.layMaDoiTacCuaPhien(request);

        try {
            List<MauXe> danhSach;

            String maChiNhanhStr = request.getParameter("maChiNhanh");
            if (maChiNhanhStr != null && !maChiNhanhStr.trim().isEmpty()) {
                int maChiNhanh = Integer.parseInt(maChiNhanhStr.trim());
                danhSach = mauXeDAO.layDanhSachMauXeTheoChiNhanh(maChiNhanh, maDoiTac);
            } else {
                danhSach = mauXeDAO.layDanhSachMauXeTheoDoiTac(maDoiTac);
            }

            StringBuilder xml = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<mauXes>\n");
            for (MauXe mx : danhSach) {
                xml.append("    <mauXe>\n")
                   .append("        <maMauXe>").append(mx.getMaMauXe()).append("</maMauXe>\n")
                   .append("        <maChiNhanh>").append(mx.getMaChiNhanh()).append("</maChiNhanh>\n")
                   .append("        <hangXe>").append(escapeXml(mx.getHangXe())).append("</hangXe>\n")
                   .append("        <dongXe>").append(escapeXml(mx.getDongXe())).append("</dongXe>\n")
                   .append("        <doiXe>").append(mx.getDoiXe()).append("</doiXe>\n")
                   .append("        <dungTich>").append(mx.getDungTich()).append("</dungTich>\n")
                   .append("        <urlHinhAnh>").append(escapeXml(mx.getUrlHinhAnh())).append("</urlHinhAnh>\n")
                   .append("    </mauXe>\n");
            }
            xml.append("</mauXes>");
            response.getWriter().write(xml.toString());

        } catch (NumberFormatException e) {
            guiPhanHoiXML(response, 400, "error", "Mã chi nhánh không hợp lệ");
        } catch (Exception e) {
            guiPhanHoiXML(response, 500, "error", "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * POST /doitac/mauxe – thêm mẫu xe mới.
     * maDoiTac lấy từ session, không nhận từ form.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/xml;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        if (!KiemTraDoiTac.checkDoiTac(request, response)) return;

        Integer maDoiTac = KiemTraDoiTac.layMaDoiTacCuaPhien(request);

        String hangXe        = request.getParameter("hangXe");
        String dongXe        = request.getParameter("dongXe");
        String doiXeStr      = request.getParameter("doiXe");
        String dungTichStr   = request.getParameter("dungTich");
        String urlHinhAnh    = request.getParameter("urlHinhAnh");
        String maChiNhanhStr = request.getParameter("maChiNhanh");

        // Validate bắt buộc
        if (hangXe == null || hangXe.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Hãng xe không được để trống"); return;
        }
        if (dongXe == null || dongXe.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Dòng xe không được để trống"); return;
        }
        if (doiXeStr == null || doiXeStr.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Đời xe không được để trống"); return;
        }
        if (dungTichStr == null || dungTichStr.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Dung tích không được để trống"); return;
        }
        if (maChiNhanhStr == null || maChiNhanhStr.trim().isEmpty()) {
            guiPhanHoiXML(response, 400, "error", "Chi nhánh không được để trống"); return;
        }

        int doiXe, maChiNhanh;
        float dungTich;
        try {
            doiXe      = Integer.parseInt(doiXeStr.trim());
            maChiNhanh = Integer.parseInt(maChiNhanhStr.trim());
            dungTich   = Float.parseFloat(dungTichStr.trim());
        } catch (NumberFormatException e) {
            guiPhanHoiXML(response, 400, "error", "Đời xe, mã chi nhánh hoặc dung tích không hợp lệ");
            return;
        }

        if (doiXe < 1900 || doiXe > 2100) {
            guiPhanHoiXML(response, 400, "error", "Đời xe không hợp lệ (1900–2100)"); return;
        }
        if (dungTich <= 0) {
            guiPhanHoiXML(response, 400, "error", "Dung tích phải lớn hơn 0"); return;
        }

        MauXe mauXe = new MauXe();
        mauXe.setMaDoiTac(maDoiTac);
        mauXe.setMaChiNhanh(maChiNhanh);
        mauXe.setHangXe(hangXe.trim());
        mauXe.setDongXe(dongXe.trim());
        mauXe.setDoiXe(doiXe);
        mauXe.setDungTich(dungTich);
        mauXe.setUrlHinhAnh(urlHinhAnh != null ? urlHinhAnh.trim() : "");

        try {
            mauXeDAO.themMauXe(mauXe);
            guiPhanHoiXML(response, 201, "success", "Thêm mẫu xe thành công!");
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