package service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.Role;

import java.io.IOException;

public class KiemTraDoiTac {

	public static boolean checkDoiTac(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);

        if (session == null) {
            sendXmlError(response, 401, "Chưa đăng nhập");
            return false;
        }

        String roleStr = (String) session.getAttribute("role");
        Role role = Role.chuyenRoleTuChuoi(roleStr);
        Integer maDoiTac = (Integer) session.getAttribute("maDoiTac");

        if (role != Role.DOI_TAC || maDoiTac == null) {
            sendXmlError(response, 403, "Chỉ đối tác mới được truy cập chức năng này");
            return false;
        }

        return true;
    }

    public static Integer layMaDoiTacCuaPhien(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (Integer) session.getAttribute("maDoiTac") : null;
    }

    private static void sendXmlError(HttpServletResponse resp, int status, String message) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/xml;charset=UTF-8");

        String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                     "<error>\n" +
                     "    <status>" + status + "</status>\n" +
                     "    <message>" + message + "</message>\n" +
                     "</error>";

        resp.getWriter().write(xml);
    }
}