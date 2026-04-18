package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.GoiThue;
import util.Connect;


public class GoiThueDAO {
	 private Connection con;

	    public GoiThueDAO() {
	        try {
	            this.con = Connect.getInstance().getConnect();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }

	    // FIX: throws SQLException thay vì nuốt lỗi
	    public void themGoiThue(GoiThue goiThue) throws SQLException {
        String sql = "insert into GoiThue (maMauXe, maDoiTac, maChiNhanh, tenGoiThue, phuKien, giaNgay, giaTuan, phuThu) " +
                     "values (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, goiThue.getMaMauXe());
            ps.setInt(2, goiThue.getMaDoiTac());
            ps.setInt(3, goiThue.getMaChiNhanh());
            ps.setString(4, goiThue.getTenGoiThue());
            ps.setString(5, goiThue.getPhuKien());
            ps.setFloat(6, goiThue.getGiaNgay());
            ps.setFloat(7, goiThue.getGiaTuan());
	            ps.setFloat(8, goiThue.getPhuThu());
	            ps.executeUpdate();
	        }
	    }

	    public List<GoiThue> timkiemGoiThue(String tuKhoa) {
	        List<GoiThue> list = new ArrayList<>();

	        boolean laSo = true;
	        float giaTimKiem = 0;
	        try {
	            giaTimKiem = Float.parseFloat(tuKhoa.trim());
	        } catch (NumberFormatException e) {
	            laSo = false;
	        }

	        StringBuilder sql = new StringBuilder(
	            "select gt.* from GoiThue gt " +
	            "join MauXe mx on gt.maMauXe = mx.maMauXe " +
	            "where (gt.tenGoiThue like ? or gt.phuKien like ? or mx.hangXe like ? or mx.dongXe like ?) "
	        );
	        if (laSo) {
            sql.append("or (gt.giaNgay >= ? and gt.giaNgay <= ? or gt.giaTuan >= ? and gt.giaTuan <= ?) ");
            sql.append("order by least(abs(gt.giaNgay - ?), abs(gt.giaTuan - ?)) asc");
	        }

	        try {
	            PreparedStatement ps = con.prepareStatement(sql.toString());
	            String chuoi = "%" + tuKhoa + "%";
	            ps.setString(1, chuoi);
	            ps.setString(2, chuoi);
	            ps.setString(3, chuoi);
	            ps.setString(4, chuoi);
	            if (laSo) {
	                float bienTrai = giaTimKiem * 0.5f;
	                float bienPhai = giaTimKiem * 1.5f;
	                ps.setFloat(5, bienTrai);
	                ps.setFloat(6, bienPhai);
	                ps.setFloat(7, bienTrai);
	                ps.setFloat(8, bienPhai);
	                ps.setFloat(9, giaTimKiem);
	                ps.setFloat(10, giaTimKiem);
	            }
	            try (ResultSet rs = ps.executeQuery()) {
	                while (rs.next()) {
	                    GoiThue gt = new GoiThue();
	                    gt.setMaGoiThue(rs.getInt("maGoiThue"));
	                    gt.setMaMauXe(rs.getInt("maMauXe"));
	                    gt.setMaDoiTac(rs.getInt("maDoiTac"));
	                    gt.setMaChiNhanh(rs.getInt("maChiNhanh"));
	                    gt.setTenGoiThue(rs.getString("tenGoiThue"));
	                    gt.setPhuKien(rs.getString("phuKien"));
	                    gt.setGiaNgay(rs.getFloat("giaNgay"));
                    gt.setGiaTuan(rs.getFloat("giaTuan"));
	                    gt.setPhuThu(rs.getFloat("phuThu"));

	                    list.add(gt);
	                }
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return list;
	    }

	    public List<GoiThue> layDanhSachTheoDoiTac(int maDoiTac) {
	        List<GoiThue> list = new ArrayList<>();

	        String sql =
	            "SELECT gt.maGoiThue, gt.maMauXe, gt.maChiNhanh, gt.tenGoiThue, " +
            "       gt.phuKien, gt.giaNgay, gt.giaTuan, gt.phuThu " +
	            "FROM GoiThue gt WHERE gt.maDoiTac = ? " +
	            "ORDER BY gt.maGoiThue DESC";

	        try (Connection con = Connect.getInstance().getConnect();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, maDoiTac);
	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {
	                GoiThue gt = new GoiThue();

	                gt.setMaGoiThue(rs.getInt("maGoiThue"));
	                gt.setMaMauXe(rs.getInt("maMauXe"));
	                gt.setMaChiNhanh(rs.getInt("maChiNhanh"));
	                gt.setTenGoiThue(rs.getString("tenGoiThue"));
	                gt.setPhuKien(rs.getString("phuKien"));
	                gt.setGiaNgay(rs.getFloat("giaNgay"));
                gt.setGiaTuan(rs.getFloat("giaTuan"));
	                gt.setPhuThu(rs.getFloat("phuThu"));


	                list.add(gt);
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return list;
	    }
	    
	    public boolean ktraSoLuong() {
	        String sql = "select count(1) from GoiThue";
	        try {
	            PreparedStatement ps = con.prepareStatement(sql);
	            ResultSet rs = ps.executeQuery();
	            if (rs.next()) return rs.getInt(1) > 0;
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return false;
	    }
	
	public Map<Integer, GoiThue> layDanhSachTheoIds(List<Integer> ids, Connection con) throws SQLException {

	    if (ids == null || ids.isEmpty()) return new HashMap<>();

	    StringBuilder sql = new StringBuilder("select * from goithue where maGoiThue in (");

	    for (int i = 0; i < ids.size(); i++) {
	        sql.append("?");
	        if (i < ids.size() - 1) sql.append(",");
	    }
	    sql.append(")");

	    Map<Integer, GoiThue> map = new HashMap<>();

	    try (PreparedStatement pstm = con.prepareStatement(sql.toString())) {

	        for (int i = 0; i < ids.size(); i++) {
	            pstm.setInt(i + 1, ids.get(i));
	        }

	        ResultSet rs = pstm.executeQuery();

	        while (rs.next()) {
	            GoiThue g = new GoiThue();

	            g.setMaGoiThue(rs.getInt("maGoiThue"));
	            g.setTenGoiThue(rs.getString("tenGoiThue"));
	            g.setGiaNgay(rs.getFloat("giaNgay"));
            g.setGiaTuan(rs.getFloat("giaTuan"));
	            g.setPhuThu(rs.getFloat("phuThu"));


	            map.put(g.getMaGoiThue(), g);
	        }
	    }

	    return map;
	}
	public int demTongXe(int maGoiThue, Connection con) throws SQLException{
		// Đếm tổng số xe SẴN SÀNG (san_sang) thuộc GoiThue (phục vụ cho availability check)
		// Điều kiện: maMauXe, maChiNhanh, maDoiTac đều phải khớp, và xe phải ở trạng thái san_sang
		String SQL = "SELECT COUNT(DISTINCT xm.maXe) as tongXe " +
		             "FROM XeMay xm " +
		             "JOIN GoiThue gt ON xm.maMauXe = gt.maMauXe " +
		             "WHERE gt.maGoiThue = ? " +
		             "AND xm.maChiNhanh = gt.maChiNhanh " +
		             "AND xm.maDoiTac = gt.maDoiTac " +
		             "AND xm.trangThai = 'san_sang'";
		try(PreparedStatement pstm = con.prepareStatement(SQL)){
			pstm.setInt(1, maGoiThue);
			try(ResultSet rs = pstm.executeQuery()){
				if(rs.next()) {
					return rs.getInt("tongXe");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

		// Lấy tất cả gói thuê (không filter theo DoiTac)
		public List<GoiThue> layTatCaGoiThue(Connection con) throws SQLException {
			List<GoiThue> list = new ArrayList<>();
			String sql = "SELECT gt.maGoiThue, gt.maMauXe, gt.maChiNhanh, gt.maDoiTac, gt.tenGoiThue, " +
						 "       gt.phuKien, gt.giaNgay, gt.giaTuan, gt.phuThu " +
						 "FROM GoiThue gt " +
						 "ORDER BY gt.maGoiThue DESC";
			try (PreparedStatement ps = con.prepareStatement(sql)) {
				ResultSet rs = ps.executeQuery();
				while (rs.next()) {
					GoiThue gt = new GoiThue();
					gt.setMaGoiThue(rs.getInt("maGoiThue"));
					gt.setMaMauXe(rs.getInt("maMauXe"));
					gt.setMaChiNhanh(rs.getInt("maChiNhanh"));
					gt.setMaDoiTac(rs.getInt("maDoiTac"));
					gt.setTenGoiThue(rs.getString("tenGoiThue"));
					gt.setPhuKien(rs.getString("phuKien"));
					gt.setGiaNgay(rs.getFloat("giaNgay"));
				gt.setGiaTuan(rs.getFloat("giaTuan"));
					gt.setPhuThu(rs.getFloat("phuThu"));

					list.add(gt);
				}
			}
			return list;
		}

		// Lấy gói thuê theo ID
		public GoiThue layGoiThueTheoId(int maGoiThue, Connection con) throws SQLException {
			String sql = "SELECT gt.maGoiThue, gt.maMauXe, gt.maChiNhanh, gt.maDoiTac, gt.tenGoiThue, " +
						 "       gt.phuKien, gt.giaNgay, gt.giaTuan, gt.phuThu " +
						 "FROM GoiThue gt " +
						 "WHERE gt.maGoiThue = ?";
			try (PreparedStatement ps = con.prepareStatement(sql)) {
				ps.setInt(1, maGoiThue);
				try (ResultSet rs = ps.executeQuery()) {
					if (rs.next()) {
						GoiThue gt = new GoiThue();
						gt.setMaGoiThue(rs.getInt("maGoiThue"));
						gt.setMaMauXe(rs.getInt("maMauXe"));
						gt.setMaChiNhanh(rs.getInt("maChiNhanh"));
						gt.setMaDoiTac(rs.getInt("maDoiTac"));
						gt.setTenGoiThue(rs.getString("tenGoiThue"));
						gt.setPhuKien(rs.getString("phuKien"));
						gt.setGiaNgay(rs.getFloat("giaNgay"));
					gt.setGiaTuan(rs.getFloat("giaTuan"));
						gt.setPhuThu(rs.getFloat("phuThu"));

						return gt;
					}
				}
			}
			return null;
		}

		// Filter Method 1: Get price statistics (min/max for day & week rates)
		public Map<String, Object> getPriceStats(Connection con) throws SQLException {
			Map<String, Object> stats = new HashMap<>();
			String sql = "SELECT MIN(giaNgay) as minNgay, MAX(giaNgay) as maxNgay, " +
						 "       MIN(giaTuan) as minTuan, MAX(giaTuan) as maxTuan " +
						 "FROM GoiThue";
			try (PreparedStatement ps = con.prepareStatement(sql);
				 ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					stats.put("minNgay", rs.getFloat("minNgay"));
					stats.put("maxNgay", rs.getFloat("maxNgay"));
					stats.put("minTuan", rs.getFloat("minTuan"));
					stats.put("maxTuan", rs.getFloat("maxTuan"));
				}
			}
			return stats;
		}

		// Filter Method 2b: Get ChiNhanh IDs by diaDiem (complete address string)
		// Format: "Xã/Phường, Tỉnh"
		public List<Integer> layChiNhanhIdsByDiaDiem(String diaDiem, Connection con) throws SQLException {
			List<Integer> chiNhanhIds = new ArrayList<>();
			// Search for matches in diaDiem field (should contain "xã, tỉnh" substring)
			String sql = "SELECT DISTINCT maChiNhanh FROM ChiNhanh WHERE diaDiem LIKE ?";
			try (PreparedStatement ps = con.prepareStatement(sql)) {
				// Search for diaDiem containing the filter string
				ps.setString(1, "%" + diaDiem + "%");
				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						chiNhanhIds.add(rs.getInt("maChiNhanh"));
					}
				}
			}
			return chiNhanhIds;
		}

		// Filter Method 2: Get ChiNhanh IDs by location (province + ward)
		public List<Integer> layChiNhanhIdsByLocation(String xaName, String tinhName, Connection con) throws SQLException {
			List<Integer> chiNhanhIds = new ArrayList<>();
			String sql = "SELECT DISTINCT maChiNhanh FROM ChiNhanh " +
						 "WHERE diaDiem LIKE ? AND diaDiem LIKE ?";
			try (PreparedStatement ps = con.prepareStatement(sql)) {
				ps.setString(1, "%" + xaName + "%");
				ps.setString(2, "%" + tinhName + "%");
				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						chiNhanhIds.add(rs.getInt("maChiNhanh"));
					}
				}
			}
			return chiNhanhIds;
		}

		// Filter Method 3: Filter GoiThue by location + price range
		public List<GoiThue> layGoiThueByLocationAndPrice(List<Integer> chiNhanhIds, String priceType,
														   Float minPrice, Float maxPrice, Connection con) throws SQLException {
			List<GoiThue> list = new ArrayList<>();
			StringBuilder sql = new StringBuilder(
				"SELECT DISTINCT gt.maGoiThue, gt.maMauXe, gt.maChiNhanh, gt.maDoiTac, gt.tenGoiThue, " +
				"       gt.phuKien, gt.giaNgay, gt.giaTuan, gt.phuThu " +
				"FROM GoiThue gt " +
				"WHERE 1=1"
			);

			// Add location filter if chi nhánh IDs provided
			if (chiNhanhIds != null && !chiNhanhIds.isEmpty()) {
				sql.append(" AND gt.maChiNhanh IN (");
				for (int i = 0; i < chiNhanhIds.size(); i++) {
					if (i > 0) sql.append(",");
					sql.append("?");
				}
				sql.append(")");
			}

			// Add price filter
			if (priceType != null && !priceType.isEmpty() && minPrice != null && maxPrice != null) {
				if ("day".equals(priceType)) {
					sql.append(" AND gt.giaNgay BETWEEN ? AND ?");
				} else if ("week".equals(priceType)) {
					sql.append(" AND gt.giaTuan BETWEEN ? AND ?");
				}
			}

			sql.append(" ORDER BY gt.tenGoiThue ASC");

			try (PreparedStatement ps = con.prepareStatement(sql.toString())) {
				int paramIndex = 1;

				// Set chi nhánh IDs
				if (chiNhanhIds != null && !chiNhanhIds.isEmpty()) {
					for (int id : chiNhanhIds) {
						ps.setInt(paramIndex++, id);
					}
				}

				// Set price range
				if (priceType != null && !priceType.isEmpty() && minPrice != null && maxPrice != null) {
					ps.setFloat(paramIndex++, minPrice);
					ps.setFloat(paramIndex++, maxPrice);
				}

				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						GoiThue gt = new GoiThue();
						gt.setMaGoiThue(rs.getInt("maGoiThue"));
						gt.setMaMauXe(rs.getInt("maMauXe"));
						gt.setMaChiNhanh(rs.getInt("maChiNhanh"));
						gt.setMaDoiTac(rs.getInt("maDoiTac"));
						gt.setTenGoiThue(rs.getString("tenGoiThue"));
						gt.setPhuKien(rs.getString("phuKien"));
						gt.setGiaNgay(rs.getFloat("giaNgay"));
					gt.setGiaTuan(rs.getFloat("giaTuan"));
						gt.setPhuThu(rs.getFloat("phuThu"));
						list.add(gt);
					}
				}
			}
			return list;
		}
}