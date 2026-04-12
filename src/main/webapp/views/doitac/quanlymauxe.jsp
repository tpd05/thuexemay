<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChiNhanhDAO,dao.MauXeDAO,model.ChiNhanh,model.MauXe,java.util.List,java.net.URLEncoder" %>
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
    String ctx   = request.getContextPath();

    if ("POST".equals(request.getMethod())) {
        String maChiNhanhStr = request.getParameter("maChiNhanh");
        String hangXe        = request.getParameter("hangXe");
        String dongXe        = request.getParameter("dongXe");
        String doiXeStr      = request.getParameter("doiXe");
        String dungTichStr   = request.getParameter("dungTich");
        String urlHinhAnh    = request.getParameter("urlHinhAnh");
        String base          = ctx + "/doitac/quanlymauxe?maChiNhanh=" + esc(maChiNhanhStr);
        if (maChiNhanhStr == null || maChiNhanhStr.trim().isEmpty()) {
            response.sendRedirect(ctx + "/doitac/quanlymauxe?msgType=error&msg=" + URLEncoder.encode("Thiếu mã chi nhánh","UTF-8")); return;
        }
        if (hangXe == null || hangXe.trim().isEmpty()) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Hãng xe không được để trống","UTF-8")); return;
        }
        if (dongXe == null || dongXe.trim().isEmpty()) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Dòng xe không được để trống","UTF-8")); return;
        }
        if (doiXeStr == null || doiXeStr.trim().isEmpty()) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Đời xe không được để trống","UTF-8")); return;
        }
        if (dungTichStr == null || dungTichStr.trim().isEmpty()) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Dung tích không được để trống","UTF-8")); return;
        }
        try {
            int   maChiNhanh = Integer.parseInt(maChiNhanhStr.trim());
            int   doiXe      = Integer.parseInt(doiXeStr.trim());
            float dungTich   = Float.parseFloat(dungTichStr.trim());
            if (doiXe < 1900 || doiXe > 2100) throw new IllegalArgumentException("Đời xe không hợp lệ (1900–2100)");
            if (dungTich <= 0)                 throw new IllegalArgumentException("Dung tích phải lớn hơn 0");
            MauXe mx = new MauXe();
            mx.setMaDoiTac(maDoiTac);
            mx.setMaChiNhanh(maChiNhanh);
            mx.setHangXe(hangXe.trim());
            mx.setDongXe(dongXe.trim());
            mx.setDoiXe(doiXe);
            mx.setDungTich(dungTich);
            mx.setUrlHinhAnh(urlHinhAnh != null ? urlHinhAnh.trim() : "");
            new MauXeDAO().themMauXe(mx);
            response.sendRedirect(base + "&msgType=success&msg=" + URLEncoder.encode("Thêm mẫu xe thành công!","UTF-8"));
        } catch (IllegalArgumentException e) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode(e.getMessage(),"UTF-8"));
        } catch (Exception e) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(),"UTF-8"));
        }
        return;
    }

    String msg           = request.getParameter("msg");
    String msgType       = request.getParameter("msgType");
    String maChiNhanhStr = request.getParameter("maChiNhanh");
    int maChiNhanh = 0;
    if (maChiNhanhStr != null && !maChiNhanhStr.trim().isEmpty()) {
        try { maChiNhanh = Integer.parseInt(maChiNhanhStr.trim()); } catch (NumberFormatException ignore) {}
    }
    List<ChiNhanh> danhSachCN = new ChiNhanhDAO().layToanBoChiNhanh(maDoiTac);
    List<MauXe>    danhSachMX = (maChiNhanh > 0) ? new MauXeDAO().layDanhSachMauXeTheoChiNhanh(maChiNhanh, maDoiTac) : null;
    String tenChiNhanh = "";
    for (ChiNhanh cn : danhSachCN) { if (cn.getMaChiNhanh() == maChiNhanh) { tenChiNhanh = cn.getTenChiNhanh(); break; } }
    int currentStep = (maChiNhanh > 0) ? 2 : 1;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản Lý Mẫu Xe</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{--bg:#f0ede6;--card:#fff;--border:#1a1a1a;--blue:#1a5fa8;--blue-lt:#e8f0fb;--text:#1a1a1a;--muted:#555}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}

.topbar{background:#1a1a1a;color:#fff;display:flex;align-items:center;justify-content:space-between;padding:0 36px;height:56px;border-bottom:3px solid var(--blue)}
.topbar-left{display:flex;align-items:center;gap:16px}
.topbar-brand{font-family:'Space Mono',monospace;font-size:14px;font-weight:700;letter-spacing:3px;text-transform:uppercase}
.topbar-sep{width:1px;height:18px;background:rgba(255,255,255,.2)}
.topbar-page{font-size:12px;color:rgba(255,255,255,.5);text-transform:uppercase;letter-spacing:.5px}
.topbar-nav{display:flex}
.topbar-nav a{color:rgba(255,255,255,.6);text-decoration:none;padding:0 16px;height:56px;display:flex;align-items:center;font-size:12px;font-weight:600;letter-spacing:.5px;text-transform:uppercase;border-left:1px solid rgba(255,255,255,.08);transition:all .15s}
.topbar-nav a:hover{background:rgba(255,255,255,.08);color:#fff}
.topbar-nav a.active{background:var(--blue);color:#fff}

/* Steps */
.steps{display:flex;background:var(--card);border-bottom:2px solid var(--border)}
.step{flex:1;padding:14px 20px;display:flex;align-items:center;gap:12px;border-right:2px solid var(--border);opacity:.35}
.step:last-child{border-right:none}
.step.active{opacity:1}
.step.done{opacity:.7}
.step-n{width:28px;height:28px;background:#ddd;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:12px;flex-shrink:0;font-family:'Space Mono',monospace}
.step.active .step-n{background:var(--blue);color:#fff}
.step.done .step-n{background:#1a1a1a;color:#fff}
.step-lbl{font-family:'Space Mono',monospace;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px}
.step-sub{font-size:12px;color:var(--muted);margin-top:2px}

.wrap{max-width:1180px;margin:0 auto;padding:28px 36px}

.alert{padding:12px 16px;font-size:13px;font-weight:600;margin-bottom:20px;border:2px solid}
.alert-success{background:#e6f4ec;color:#145c2c;border-color:#1a7a3c}
.alert-error{background:#fde8e8;color:#8b1a1a;border-color:#c0392b}

/* Branch cards */
.cn-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:0;margin-bottom:24px;border:2px solid var(--border)}
.radio-card{position:relative;padding:16px 18px;background:var(--card);cursor:pointer;display:block;border-right:2px solid var(--border);border-bottom:2px solid var(--border);transition:background .15s}
.radio-card:hover{background:#f0ede6}
.radio-card input[type=radio]{position:absolute;top:14px;right:14px;accent-color:var(--blue)}
.rc-name{font-weight:700;font-size:14px;padding-right:24px;margin-bottom:4px}
.rc-sub{font-size:12px;color:var(--muted)}
.sec-label{font-family:'Space Mono',monospace;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1.5px;color:var(--muted);margin-bottom:14px}

/* Panel split */
.panel-split{display:grid;grid-template-columns:360px 1fr;gap:0;border:2px solid var(--border)}
.panel{background:var(--card)}
.panel:first-child{border-right:2px solid var(--border)}
.ph{background:#1a1a1a;color:rgba(255,255,255,.9);padding:12px 18px;font-family:'Space Mono',monospace;font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:2px;display:flex;align-items:center;justify-content:space-between}
.pb{padding:22px}

.field{margin-bottom:16px}
.field label{display:block;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;margin-bottom:7px;color:var(--muted)}
.field input{width:100%;border:2px solid var(--border);padding:9px 12px;font-family:'DM Sans',sans-serif;font-size:14px;background:var(--bg);color:var(--text);outline:none;transition:border-color .15s}
.field input:focus{border-color:var(--blue);background:#fff}
.row2{display:grid;grid-template-columns:1fr 1fr;gap:12px}

.btn{padding:10px 22px;font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;border:2px solid var(--border);cursor:pointer;text-decoration:none;display:inline-block;letter-spacing:.3px;transition:all .15s}
.btn-blue{background:var(--blue);color:#fff;border-color:var(--blue)}
.btn-blue:hover{background:#154d8c}
.btn-ghost{background:var(--bg);color:var(--text)}
.btn-ghost:hover{background:#e5e2db}
.btn-row{display:flex;gap:10px;margin-top:8px}

table{width:100%;border-collapse:collapse}
th{background:#1a1a1a;color:rgba(255,255,255,.9);padding:11px 14px;font-family:'Space Mono',monospace;font-size:10px;text-transform:uppercase;letter-spacing:1.5px;text-align:left}
td{padding:12px 14px;border-bottom:1px solid #e8e5de;font-size:13px}
tr:last-child td{border-bottom:none}
tr:hover td{background:#f7f5f0}
.no-data{text-align:center;padding:44px;color:var(--muted);font-size:14px}
.count-badge{background:var(--blue);color:#fff;padding:2px 10px;font-size:10px;font-weight:700;letter-spacing:.5px}
</style>
</head>
<body>

<div class="topbar">
  <div class="topbar-left">
    <span class="topbar-brand">&#9632; MotoRent</span>
    <div class="topbar-sep"></div>
    <span class="topbar-page">Mẫu Xe</span>
  </div>
  <nav class="topbar-nav">
    <a href="<%= ctx %>/doitac/quanlychinhanh">Chi Nhánh</a>
    <a href="<%= ctx %>/doitac/quanlymauxe" class="active">Mẫu Xe</a>
    <a href="<%= ctx %>/doitac/quanlyxemay">Xe Máy</a>
    <a href="<%= ctx %>/doitac/quanlygoithue">Gói Thuê</a>
    <a href="<%= ctx %>/views/doitac/quanlyxe.jsp">&#8592; Quản Lý Xe</a>
  </nav>
</div>

<div class="steps">
  <div class="step <%= currentStep == 1 ? "active" : "done" %>">
    <div class="step-n"><%= currentStep > 1 ? "✓" : "1" %></div>
    <div>
      <div class="step-lbl">Chọn Chi Nhánh</div>
      <% if (!tenChiNhanh.isEmpty()) { %><div class="step-sub"><%= esc(tenChiNhanh) %></div><% } %>
    </div>
  </div>
  <div class="step <%= currentStep == 2 ? "active" : "" %>">
    <div class="step-n">2</div>
    <div><div class="step-lbl">Quản Lý Mẫu Xe</div></div>
  </div>
</div>

<div class="wrap">

  <% if (msg != null && !msg.isEmpty()) { %>
    <div class="alert alert-<%= "error".equals(msgType) ? "error" : "success" %>"><%= esc(msg) %></div>
  <% } %>

  <% if (currentStep == 1) { %>
    <div class="sec-label">Chọn chi nhánh để quản lý mẫu xe</div>
    <% if (danhSachCN.isEmpty()) { %>
      <div class="no-data">Chưa có chi nhánh nào. <a href="<%= ctx %>/doitac/quanlychinhanh" style="color:var(--blue)">Thêm chi nhánh trước</a>.</div>
    <% } else { %>
      <form method="get" action="<%= ctx %>/doitac/quanlymauxe">
        <div class="cn-grid">
          <% for (ChiNhanh cn : danhSachCN) { %>
            <label class="radio-card">
              <input type="radio" name="maChiNhanh" value="<%= cn.getMaChiNhanh() %>" required />
              <div class="rc-name">&#9632; <%= esc(cn.getTenChiNhanh()) %></div>
              <div class="rc-sub"><%= esc(cn.getDiaDiem()) %></div>
            </label>
          <% } %>
        </div>
        <button type="submit" class="btn btn-blue">Xem Mẫu Xe &#8594;</button>
      </form>
    <% } %>

  <% } else { %>
    <div class="panel-split">
      <div class="panel">
        <div class="ph">+ Thêm Mẫu Xe</div>
        <div class="pb">
          <form method="post" action="<%= ctx %>/views/doitac/quanlymauxe.jsp">
            <input type="hidden" name="maChiNhanh" value="<%= maChiNhanh %>" />
            <div class="field"><label>Hãng Xe *</label><input type="text" name="hangXe" placeholder="Honda, Yamaha..." maxlength="100" required /></div>
            <div class="field"><label>Dòng Xe *</label><input type="text" name="dongXe" placeholder="Wave, Exciter..." maxlength="100" required /></div>
            <div class="row2">
              <div class="field"><label>Đời Xe *</label><input type="number" name="doiXe" placeholder="2022" min="1900" max="2100" required /></div>
              <div class="field"><label>Dung Tích (cc) *</label><input type="number" name="dungTich" placeholder="125" step="0.1" min="0.1" required /></div>
            </div>
            <div class="field"><label>URL Hình Ảnh</label><input type="text" name="urlHinhAnh" placeholder="https://..." maxlength="500" /></div>
            <div class="btn-row">
              <button type="submit" class="btn btn-blue">+ Thêm Mẫu Xe</button>
              <a href="<%= ctx %>/doitac/quanlymauxe" class="btn btn-ghost">&#8592; Đổi Chi Nhánh</a>
            </div>
          </form>
        </div>
      </div>

      <div class="panel">
        <div class="ph">
          <span>Mẫu Xe — <%= esc(tenChiNhanh) %></span>
          <span class="count-badge"><%= danhSachMX != null ? danhSachMX.size() : 0 %> mẫu</span>
        </div>
        <% if (danhSachMX == null || danhSachMX.isEmpty()) { %>
          <div class="no-data">Chưa có mẫu xe nào tại chi nhánh này.</div>
        <% } else { %>
          <table>
            <thead><tr><th>#</th><th>Hãng</th><th>Dòng Xe</th><th>Đời</th><th>Dung Tích</th></tr></thead>
            <tbody>
              <% int stt=1; for(MauXe mx : danhSachMX) { %>
              <tr>
                <td style="color:var(--muted);font-family:'Space Mono',monospace;font-size:12px"><%= stt++ %></td>
                <td><strong><%= esc(mx.getHangXe()) %></strong></td>
                <td><%= esc(mx.getDongXe()) %></td>
                <td style="font-family:'Space Mono',monospace;font-size:12px"><%= mx.getDoiXe() %></td>
                <td style="font-family:'Space Mono',monospace;font-size:12px"><%= mx.getDungTich() %> cc</td>
              </tr>
              <% } %>
            </tbody>
          </table>
        <% } %>
      </div>
    </div>
  <% } %>

</div>
</body>
</html>
