<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChiNhanhDAO, model.ChiNhanh, java.util.List, java.sql.Connection, util.Connect, java.net.URLEncoder" %>
<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    javax.servlet.http.HttpSession sess = request.getSession(false);
    if (sess == null || !"DOI_TAC".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/dangnhap"); return;
    }
    int maDoiTac = (Integer) sess.getAttribute("maDoiTac");

    if ("POST".equals(request.getMethod())) {
        String tenChiNhanh = request.getParameter("tenChiNhanh");
        String diaDiem     = request.getParameter("diaDiem");
        String redirect    = request.getContextPath() + "/doitac/quanlychinhanh";
        if (tenChiNhanh == null || tenChiNhanh.trim().isEmpty()) {
            response.sendRedirect(redirect + "?msgType=error&msg=" + URLEncoder.encode("Tên chi nhánh không được để trống", "UTF-8")); return;
        }
        if (diaDiem == null || diaDiem.trim().isEmpty()) {
            response.sendRedirect(redirect + "?msgType=error&msg=" + URLEncoder.encode("Địa điểm không được để trống", "UTF-8")); return;
        }
        ChiNhanh cn = new ChiNhanh();
        cn.setMaDoiTac(maDoiTac);
        cn.setTenChiNhanh(tenChiNhanh.trim());
        cn.setDiaDiem(diaDiem.trim());
        Connection con = null;
        try {
            con = Connect.getInstance().getConnect();
            con.setAutoCommit(false);
            new ChiNhanhDAO(con).themChiNhanh(cn, con);
            con.commit();
            response.sendRedirect(redirect + "?msgType=success&msg=" + URLEncoder.encode("Thêm chi nhánh thành công!", "UTF-8"));
        } catch (IllegalArgumentException e) {
            if (con != null) try { con.rollback(); } catch (Exception ignore) {}
            response.sendRedirect(redirect + "?msgType=error&msg=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (Exception ignore) {}
            response.sendRedirect(redirect + "?msgType=error&msg=" + URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(), "UTF-8"));
        } finally {
            if (con != null) try { con.close(); } catch (Exception ignore) {}
        }
        return;
    }

    String msg     = request.getParameter("msg");
    String msgType = request.getParameter("msgType");
    List<ChiNhanh> danhSach = new ChiNhanhDAO().layToanBoChiNhanh(maDoiTac);
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản Lý Chi Nhánh</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{--bg:#f0ede6;--card:#fff;--border:#1a1a1a;--green:#1a7a3c;--green-lt:#e6f4ec;--text:#1a1a1a;--muted:#555}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}

.topbar{background:#1a1a1a;color:#fff;display:flex;align-items:center;justify-content:space-between;padding:0 36px;height:56px;border-bottom:3px solid var(--green)}
.topbar-left{display:flex;align-items:center;gap:16px}
.topbar-brand{font-family:'Space Mono',monospace;font-size:14px;font-weight:700;letter-spacing:3px;text-transform:uppercase}
.topbar-sep{width:1px;height:18px;background:rgba(255,255,255,.2)}
.topbar-page{font-size:12px;color:rgba(255,255,255,.5);text-transform:uppercase;letter-spacing:.5px}
.topbar-nav{display:flex}
.topbar-nav a{color:rgba(255,255,255,.6);text-decoration:none;padding:0 16px;height:56px;display:flex;align-items:center;font-size:12px;font-weight:600;letter-spacing:.5px;text-transform:uppercase;border-left:1px solid rgba(255,255,255,.08);transition:all .15s}
.topbar-nav a:hover{background:rgba(255,255,255,.08);color:#fff}
.topbar-nav a.active{background:var(--green);color:#fff}

.layout{display:grid;grid-template-columns:360px 1fr;min-height:calc(100vh - 56px)}

/* Form panel */
.form-panel{background:var(--card);border-right:2px solid var(--border);padding:32px 28px}
.panel-title{font-family:'Space Mono',monospace;font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:2px;margin-bottom:24px;padding-bottom:14px;border-bottom:2px solid var(--border);display:flex;align-items:center;gap:10px}
.panel-title::before{content:'';display:block;width:5px;height:18px;background:var(--green)}

.alert{padding:12px 16px;font-size:13px;font-weight:600;margin-bottom:20px;border:2px solid}
.alert-success{background:var(--green-lt);color:#145c2c;border-color:var(--green)}
.alert-error{background:#fde8e8;color:#8b1a1a;border-color:#c0392b}

.field{margin-bottom:18px}
.field label{display:block;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;margin-bottom:7px;color:var(--muted)}
.field input,.field textarea{width:100%;border:2px solid var(--border);padding:10px 13px;font-family:'DM Sans',sans-serif;font-size:14px;background:var(--bg);color:var(--text);outline:none;transition:border-color .15s}
.field input:focus,.field textarea:focus{border-color:var(--green);background:#fff}
.field textarea{resize:vertical;min-height:90px}

.btn{padding:11px 24px;font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;border:2px solid var(--border);cursor:pointer;display:inline-block;text-decoration:none;letter-spacing:.3px;transition:all .15s}
.btn-green{background:var(--green);color:#fff;border-color:var(--green)}
.btn-green:hover{background:#155f2f}

/* Main */
.main{padding:32px 36px}
.main-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px}
.main-title{font-family:'Space Mono',monospace;font-size:13px;font-weight:700;text-transform:uppercase;letter-spacing:2px}
.count{background:var(--green);color:#fff;padding:3px 12px;font-size:11px;font-weight:700;letter-spacing:.5px}

/* Table */
.table-wrap{border:2px solid var(--border)}
table{width:100%;border-collapse:collapse}
th{background:#1a1a1a;color:rgba(255,255,255,.9);padding:12px 16px;font-family:'Space Mono',monospace;font-size:10px;text-transform:uppercase;letter-spacing:1.5px;text-align:left}
td{padding:13px 16px;border-bottom:1px solid #e5e2db;font-size:14px}
tr:last-child td{border-bottom:none}
tr:hover td{background:#f7f5f0}
.td-id{font-family:'Space Mono',monospace;font-size:12px;color:var(--muted)}
.no-data{padding:52px;text-align:center;color:var(--muted);font-size:14px;background:var(--card)}
</style>
</head>
<body>

<div class="topbar">
  <div class="topbar-left">
    <span class="topbar-brand">&#9632; MotoRent</span>
    <div class="topbar-sep"></div>
    <span class="topbar-page">Chi Nhánh</span>
  </div>
  <nav class="topbar-nav">
    <a href="<%= ctx %>/doitac/quanlychinhanh" class="active">Chi Nhánh</a>
    <a href="<%= ctx %>/views/doitac/quanlyxe.jsp">Xe Máy</a>
    <a href="<%= ctx %>/doitac/quanlygoithue">Gói Thuê</a>
    <a href="<%= ctx %>/doitac/dashboard">&#8592; Trang Chủ</a>
  </nav>
</div>

<div class="layout">

  <div class="form-panel">
    <div class="panel-title">Thêm Chi Nhánh Mới</div>

    <% if (msg != null && !msg.isEmpty()) { %>
      <div class="alert alert-<%= "error".equals(msgType) ? "error" : "success" %>">
        <%= esc(msg) %>
      </div>
    <% } %>

    <form method="post" action="<%= ctx %>/views/doitac/quanlychinhanh.jsp">
      <div class="field">
        <label>Tên Chi Nhánh *</label>
        <input type="text" name="tenChiNhanh" placeholder="VD: Chi Nhánh Trung Tâm" maxlength="100" required />
      </div>
      <div class="field">
        <label>Địa Điểm *</label>
        <textarea name="diaDiem" placeholder="Địa chỉ cụ thể..." maxlength="255" required></textarea>
      </div>
      <button type="submit" class="btn btn-green">+ Thêm Chi Nhánh</button>
    </form>
  </div>

  <div class="main">
    <div class="main-header">
      <div class="main-title">Danh Sách Chi Nhánh</div>
      <span class="count"><%= danhSach.size() %> chi nhánh</span>
    </div>

    <div class="table-wrap">
      <% if (danhSach.isEmpty()) { %>
        <div class="no-data">Chưa có chi nhánh nào. Hãy thêm chi nhánh đầu tiên!</div>
      <% } else { %>
        <table>
          <thead>
            <tr><th>#</th><th>Mã CN</th><th>Tên Chi Nhánh</th><th>Địa Điểm</th></tr>
          </thead>
          <tbody>
            <% int stt = 1; for (ChiNhanh cn : danhSach) { %>
            <tr>
              <td class="td-id"><%= stt++ %></td>
              <td class="td-id">#<%= cn.getMaChiNhanh() %></td>
              <td><strong><%= esc(cn.getTenChiNhanh()) %></strong></td>
              <td style="color:var(--muted)"><%= esc(cn.getDiaDiem()) %></td>
            </tr>
            <% } %>
          </tbody>
        </table>
      <% } %>
    </div>
  </div>

</div>
</body>
</html>
