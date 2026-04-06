package service;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import dao.ChiNhanhDAO;
import model.ChiNhanh;
import util.Connect;

public class ChiNhanhService {

    public List<ChiNhanh> layDanhSach(int maDoiTac) {
        Connection con = null;
        try {
            con = Connect.getInstance().getConnect();
            ChiNhanhDAO dao = new ChiNhanhDAO(con);
            return dao.layToanBoChiNhanh(maDoiTac);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (con != null) try { con.close(); } catch (Exception ignore) {}
        }
    }

    public void themChiNhanh(ChiNhanh cn) {
        Connection con = null;

        try {
            con = Connect.getInstance().getConnect();
            con.setAutoCommit(false);

            if (cn.getTenChiNhanh() == null || cn.getTenChiNhanh().trim().isEmpty()) {
                throw new RuntimeException("Tên chi nhánh không hợp lệ");
            }

            ChiNhanhDAO dao = new ChiNhanhDAO(con);
            dao.themChiNhanh(cn, con);

            con.commit();

        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (Exception ignore) {}

            throw new RuntimeException(e.getMessage());

        } finally {
            if (con != null) try { con.close(); } catch (Exception ignore) {}
        }
    }
}