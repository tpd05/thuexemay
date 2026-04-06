package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import org.junit.After;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;
import org.junit.Before;
import org.junit.Test;

import model.ChiNhanh;
import util.Connect;

public class ChiNhanhDAOTest {

    private Connection con;
    private ChiNhanhDAO dao;
    private int testUserID = 9999; // Dùng userID test

    /**
     * Main method để debug - chạy trực tiếp để xem có lấy dữ liệu không
     */
    public static void main(String[] args) {
        System.out.println("========== ChiNhanhDAO Direct Test ==========");
        
        Connection con = null;
        try {
            // Kết nối tới database
            con = Connect.getInstance().getConnect();
            System.out.println("✓ Connected to database successfully");
            
            ChiNhanhDAO dao = new ChiNhanhDAO(con);
            System.out.println("✓ ChiNhanhDAO created");
            
            // Test 1: Lấy danh sách chi nhánh của userID 1
            System.out.println("\n--- Test 1: Lấy danh sách chi nhánh của userID = 1 ---");
            List<ChiNhanh> chiNhanhs = dao.layToanBoChiNhanh(1);
            if (chiNhanhs != null) {
                System.out.println("✓ Retrieved list size: " + chiNhanhs.size());
                for (ChiNhanh cn : chiNhanhs) {
                    System.out.println("  - maCN: " + cn.getMaChiNhanh() + 
                                     ", tenCN: " + cn.getTenChiNhanh() + 
                                     ", diaDiem: " + cn.getDiaDiem() +
                                     ", userID: " + cn.getMaDoiTac());
                }
            } else {
                System.out.println("✗ List is null");
            }
            
            // Test 2: Lấy danh sách chi nhánh test (userID 9999)
            System.out.println("\n--- Test 2: Lấy danh sách chi nhánh của userID = 9999 ---");
            List<ChiNhanh> testChiNhanhs = dao.layToanBoChiNhanh(9999);
            if (testChiNhanhs != null) {
                System.out.println("✓ Retrieved list size: " + testChiNhanhs.size());
                if (testChiNhanhs.isEmpty()) {
                    System.out.println("  (empty list)");
                }
            } else {
                System.out.println("✗ List is null");
            }
            
            // Test 3: Kiểm tra kết nối có hoạt động không
            System.out.println("\n--- Test 3: Kiểm tra connection ---");
            try (Statement stmt = con.createStatement()) {
                var rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM ChiNhanh");
                if (rs.next()) {
                    int totalChiNhanhs = rs.getInt("cnt");
                    System.out.println("✓ Total ChiNhanhhs in database: " + totalChiNhanhs);
                }
            }
            
            // Test 3b: Kiểm tra structure của table ChiNhanh
            System.out.println("\n--- Test 3b: Chi tiết cấu trúc table ChiNhanh ---");
            try (Statement stmt = con.createStatement()) {
                var rs = stmt.executeQuery("DESCRIBE ChiNhanh");
                System.out.println("Table Structure:");
                while (rs.next()) {
                    String field = rs.getString("Field");
                    String type = rs.getString("Type");
                    System.out.println("  - " + field + " (" + type + ")");
                }
            }
            
            // Test 3c: Lấy tất cả dữ liệu từ ChiNhanh để xem
            System.out.println("\n--- Test 3c: Tất cả dữ liệu hiện tại trong ChiNhanh ---");
            try (Statement stmt = con.createStatement()) {
                var rs = stmt.executeQuery("SELECT * FROM ChiNhanh LIMIT 10");
                while (rs.next()) {
                    System.out.println("  Row: " + rs.toString());
                    // In tất cả columns
                    var meta = rs.getMetaData();
                    for (int i = 1; i <= meta.getColumnCount(); i++) {
                        System.out.println("    " + meta.getColumnName(i) + ": " + rs.getObject(i));
                    }
                }
            }
            
            // Test 4: Xem database có record nào không
            System.out.println("\n--- Test 4: Danh sách tất cả DoiTac có chi nhánh ---");
            try (Statement stmt = con.createStatement()) {
                var rs = stmt.executeQuery("SELECT DISTINCT userID, COUNT(*) as cnt FROM ChiNhanh GROUP BY userID");
                boolean found = false;
                while (rs.next()) {
                    found = true;
                    int userID = rs.getInt("userID");
                    int cnt = rs.getInt("cnt");
                    System.out.println("  - userID: " + userID + ", chiNhanhCount: " + cnt);
                }
                if (!found) {
                    System.out.println("  (No chi nhánh found in database)");
                }
            }
            
            System.out.println("\n========== Test Complete ==========");
            
        } catch (Exception e) {
            System.out.println("✗ Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (con != null) {
                try {
                    con.close();
                    System.out.println("✓ Connection closed");
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Before
    public void setUp() throws SQLException {
        // Lấy connection từ Connect instance
        con = Connect.getInstance().getConnect();
        dao = new ChiNhanhDAO(con);
        
        // Xóa dữ liệu test cũ nếu có
        try (Statement stmt = con.createStatement()) {
            stmt.execute("DELETE FROM ChiNhanh WHERE userID = " + testUserID);
        }
    }

    @After
    public void tearDown() throws SQLException {
        // Dọn dẹp - xóa dữ liệu test
        try (Statement stmt = con.createStatement()) {
            stmt.execute("DELETE FROM ChiNhanh WHERE userID = " + testUserID);
        }
        
        if (con != null) {
            con.close();
        }
    }

    @Test
    public void testLayToanBoChiNhanhEmpty() {
        // Test khi không có chi nhánh nào
        List<ChiNhanh> result = dao.layToanBoChiNhanh(testUserID);
        assertNotNull("Result should not be null", result);
        assertEquals("List should be empty", 0, result.size());
    }

    @Test
    public void testThemChiNhanhAndLay() throws SQLException {
        // Test thêm chi nhánh rồi lấy lại
        ChiNhanh cn = new ChiNhanh();
        cn.setMaDoiTac(testUserID);
        cn.setTenChiNhanh("Chi Nhanh Test 1");
        cn.setDiaDiem("Dia Diem Test");

        // Thêm chi nhánh
        dao.themChiNhanh(cn, con);
        con.commit();

        // Lấy danh sách
        List<ChiNhanh> result = dao.layToanBoChiNhanh(testUserID);
        
        assertNotNull("Result should not be null", result);
        assertEquals("List should have 1 item", 1, result.size());
        
        ChiNhanh retrieved = result.get(0);
        assertEquals("Tên chi nhánh should match", "Chi Nhanh Test 1", retrieved.getTenChiNhanh());
        assertEquals("Địa điểm should match", "Dia Diem Test", retrieved.getDiaDiem());
        assertEquals("userID should match", testUserID, retrieved.getMaDoiTac());
    }

    @Test
    public void testThemMultipleChiNhanhAndLay() throws SQLException {
        // Test thêm nhiều chi nhánh
        for (int i = 1; i <= 3; i++) {
            ChiNhanh cn = new ChiNhanh();
            cn.setMaDoiTac(testUserID);
            cn.setTenChiNhanh("Chi Nhanh Test " + i);
            cn.setDiaDiem("Dia Diem Test " + i);
            
            dao.themChiNhanh(cn, con);
            con.commit();
        }

        // Lấy danh sách
        List<ChiNhanh> result = dao.layToanBoChiNhanh(testUserID);
        
        assertNotNull("Result should not be null", result);
        assertEquals("List should have 3 items", 3, result.size());
    }

    @Test
    public void testKiemTraTonTai() throws SQLException {
        // Test kiểm tra chi nhánh tồn tại
        ChiNhanh cn = new ChiNhanh();
        cn.setMaDoiTac(testUserID);
        cn.setTenChiNhanh("Chi Nhanh Test");
        cn.setDiaDiem("Dia Diem Test");

        // Trước khi thêm - không tồn tại
        assertFalse("ChiNhanh should not exist before insert", dao.kiemTraTonTai(cn, con));

        // Thêm chi nhánh
        dao.themChiNhanh(cn, con);
        con.commit();

        // Sau khi thêm - tồn tại (từ connection mới)
        Connection conNew = Connect.getInstance().getConnect();
        ChiNhanhDAO daoNew = new ChiNhanhDAO(conNew);
        assertTrue("ChiNhanh should exist after insert", daoNew.kiemTraTonTai(cn, conNew));
        conNew.close();
    }

    @Test
    public void testThemChiNhanhDuplicate() throws SQLException {
        // Test thêm chi nhánh trùng - nên throw exception
        ChiNhanh cn = new ChiNhanh();
        cn.setMaDoiTac(testUserID);
        cn.setTenChiNhanh("Chi Nhanh Test");
        cn.setDiaDiem("Dia Diem Test");

        // Thêm lần 1
        dao.themChiNhanh(cn, con);
        con.commit();

        // Thêm lần 2 - nên throw exception
        try {
            dao.themChiNhanh(cn, con);
            fail("Should throw exception when adding duplicate");
        } catch (IllegalArgumentException e) {
            assertEquals("Exception message matches", "Chi nhánh đã tồn tại!!!", e.getMessage());
        }
    }
}
