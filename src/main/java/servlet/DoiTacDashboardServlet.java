package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ChiNhanhDAO;
import dao.GoiThueDAO;
import model.GoiThue;
import util.Connect;

@WebServlet("/doitac/dashboard")
public class DoiTacDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer maDoiTac = (Integer) session.getAttribute("maDoiTac");
        
        if (maDoiTac == null) {
            response.sendRedirect(request.getContextPath() + "/dangnhap");
            return;
        }
        
        try {
            // Thống kê số lượng gói thuê
            GoiThueDAO goiThueDAO = new GoiThueDAO();
            List<GoiThue> danhSachGoiThue = goiThueDAO.layDanhSachTheoDoiTac(maDoiTac);
            int soGoiThue = danhSachGoiThue != null ? danhSachGoiThue.size() : 0;
            request.setAttribute("soGoiThue", soGoiThue);
            
            // Thống kê số lượng xe sẵn có
            int soXeSanCo = demXeSanCoTheoDoiTac(maDoiTac);
            request.setAttribute("soXeSanCo", soXeSanCo);
            
            // Thống kê số lượng chi nhánh
            ChiNhanhDAO chiNhanhDAO = new ChiNhanhDAO();
            List<?> danhSachChiNhanh = chiNhanhDAO.layToanBoChiNhanh(maDoiTac);
            int soChiNhanh = danhSachChiNhanh != null ? danhSachChiNhanh.size() : 0;
            request.setAttribute("soChiNhanh", soChiNhanh);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/views/doitac/dashboard.jsp").forward(request, response);
    }
    
    private int demXeSanCoTheoDoiTac(int maDoiTac) {
        String sql = "SELECT COUNT(*) as tongXe FROM XeMay WHERE maDoiTac = ?";
        try (Connection con = Connect.getInstance().getConnect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maDoiTac);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("tongXe");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
