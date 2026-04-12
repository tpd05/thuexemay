<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChiNhanhDAO,dao.MauXeDAO,dao.XeMayDAO,model.ChiNhanh,model.MauXe,model.XeMay,java.util.List,java.net.URLEncoder" %>
<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
    private String fmt(String s){ return s == null ? "" : s; }
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
        String maMauXeStr    = request.getParameter("maMauXe");
        String bienSo        = request.getParameter("bienSo");
        String soKhung       = request.getParameter("soKhung");
        String soMay         = request.getParameter("soMay");
        String trangThai     = request.getParameter("trangThai");
        String base          = ctx + "/doitac/quanlyxemay?maChiNhanh=" + fmt(maChiNhanhStr) + "&maMauXe=" + fmt(maMauXeStr);
        if (bienSo == null || bienSo.trim().isEmpty()) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Biển số không được để trống","UTF-8")); return;
        }
        if (!bienSo.trim().toUpperCase().matches("^[0-9]{2}[A-Z][0-9A-Z]-[0-9]{4,5}$")) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Biển số sai định dạng (VD: 20A1-12345)","UTF-8")); return;
        }
        if (soKhung == null || soKhung.trim().isEmpty()) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Số khung không được để trống","UTF-8")); return;
        }
        if (soMay == null || soMay.trim().isEmpty()) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Số máy không được để trống","UTF-8")); return;
        }
        try {
            int maCN = Integer.parseInt(maChiNhanhStr.trim());
            int maMX = Integer.parseInt(maMauXeStr.trim());
            XeMay xm = new XeMay();
            xm.setMaDoiTac(maDoiTac);
            xm.setMaChiNhanh(maCN);
            xm.setMaMauXe(maMX);
            xm.setBienSo(bienSo.trim().toUpperCase());
            xm.setSoKhung(soKhung.trim().toUpperCase());
            xm.setSoMay(soMay.trim().toUpperCase());
            xm.setTrangThai(trangThai != null && !trangThai.trim().isEmpty() ? trangThai.trim() : "san_sang");
            new XeMayDAO().themXeMay(xm);
            response.sendRedirect(base + "&msgType=success&msg=" + URLEncoder.encode("Thêm xe máy thành công!","UTF-8"));
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
    String maMauXeStr    = request.getParameter("maMauXe");
    int maChiNhanh = 0, maMauXe = 0;
    try { if (maChiNhanhStr != null) maChiNhanh = Integer.parseInt(maChiNhanhStr.trim()); } catch (Exception ignore) {}
    try { if (maMauXeStr != null)    maMauXe    = Integer.parseInt(maMauXeStr.trim()); }    catch (Exception ignore) {}
    int currentStep = (maChiNhanh > 0 && maMauXe > 0) ? 3 : (maChiNhanh > 0 ? 2 : 1);
    List<ChiNhanh> danhSachCN = new ChiNhanhDAO().layToanBoChiNhanh(maDoiTac);
    List<MauXe>    danhSachMX = (currentStep >= 2) ? new MauXeDAO().layDanhSachMauXeTheoChiNhanh(maChiNhanh, maDoiTac) : null;
    List<XeMay>    danhSachXE = (currentStep == 3) ? new XeMayDAO().layDanhSachXeMayTheoChiNhanh(maChiNhanh, maDoiTac) : null;
    String tenCN = "", tenMX = "";
    for (ChiNhanh cn : danhSachCN) if (cn.getMaChiNhanh() == maChiNhanh) { tenCN = cn.getTenChiNhanh(); break; }
    if (danhSachMX != null) for (MauXe mx : danhSachMX) if (mx.getMaMauXe() == maMauXe) { tenMX = mx.getHangXe() + " " + mx.getDongXe(); break; }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản Lý Xe Máy</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{--bg:#f0ede6;--card:#fff;--border:#1a1a1a;--orange:#c0550a;--orange-lt:#fff0e8;--text:#1a1a1a;--muted:#555}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}

.topbar{background:#1a1a1a;color:#fff;display:flex;align-items:center;justify-content:space-between;padding:0 36px;height:56px;border-bottom:3px solid var(--orange)}
.topbar-left{display:flex;align-items:center;gap:16px}
.topbar-brand{font-family:'Space Mono',monospace;font-size:14px;font-weight:700;letter-spacing:3px;text-transform:uppercase}
.topbar-sep{width:1px;height:18px;background:rgba(255,255,255,.2)}
.topbar-page{font-size:12px;color:rgba(255,255,255,.5);text-transform:uppercase;letter-spacing:.5px}
.topbar-nav{display:flex}
.topbar-nav a{color:rgba(255,255,255,.6);text-decoration:none;padding:0 16px;height:56px;display:flex;align-items:center;font-size:12px;font-weight:600;letter-spacing:.5px;text-transform:uppercase;border-left:1px solid rgba(255,255,255,.08);transition:all .15s}
.topbar-nav a:hover{background:rgba(255,255,255,.08);color:#fff}
.topbar-nav a.active{background:var(--orange);color:#fff}

/* Steps */
.steps{display:flex;background:var(--card);border-bottom:2px solid var(--border)}
.step{flex:1;padding:14px 20px;display:flex;align-items:center;gap:12px;border-right:2px solid var(--border);opacity:.35}
.step:last-child{border-right:none}
.step.active{opacity:1}
.step.done{opacity:.7}
.step-n{width:28px;height:28px;background:#ddd;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:12px;flex-shrink:0;font-family:'Space Mono',monospace}
.step.active .step-n{background:var(--orange);color:#fff}
.step.done .step-n{background:#1a1a1a;color:#fff}
.step-lbl{font-family:'Space Mono',monospace;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px}
.step-sub{font-size:12px;color:var(--muted);margin-top:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:150px}

.wrap{max-width:1180px;margin:0 auto;padding:28px 36px}

.alert{padding:12px 16px;font-size:13px;font-weight:600;margin-bottom:20px;border:2px solid}
.alert-success{background:#e6f4ec;color:#145c2c;border-color:#1a7a3c}
.alert-error{background:#fde8e8;color:#8b1a1a;border-color:#c0392b}

.crumb{background:var(--card);border:2px solid var(--border);padding:10px 16px;margin-bottom:20px;font-size:12px;display:flex;align-items:center;gap:10px;flex-wrap:wrap}
.crumb a{color:var(--orange);text-decoration:none;font-weight:700}
.crumb a:hover{text-decoration:underline}
.crumb-sep{color:#bbb}

.cn-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:0;margin-bottom:24px;border:2px solid var(--border)}
.radio-card{position:relative;padding:16px 18px;background:var(--card);cursor:pointer;display:block;border-right:2px solid var(--border);border-bottom:2px solid var(--border);transition:background .15s}
.radio-card:hover{background:var(--bg)}
.radio-card input[type=radio]{position:absolute;top:14px;right:14px;accent-color:var(--orange)}
.rc-name{font-weight:700;font-size:14px;padding-right:24px;margin-bottom:4px}
.rc-sub{font-size:12px;color:var(--muted)}
.sec-label{font-family:'Space Mono',monospace;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1.5px;color:var(--muted);margin-bottom:14px}

.panel-split{display:grid;grid-template-columns:320px 1fr;gap:0;border:2px solid var(--border)}
.panel{background:var(--card)}
.panel:first-child{border-right:2px solid var(--border)}
.ph{background:#1a1a1a;color:rgba(255,255,255,.9);padding:12px 18px;font-family:'Space Mono',monospace;font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:2px;display:flex;align-items:center;justify-content:space-between}
.pb{padding:22px}

.field{margin-bottom:15px}
.field label{display:block;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;margin-bottom:6px;color:var(--muted)}
.field input,.field select{width:100%;border:2px solid var(--border);padding:9px 12px;font-family:'DM Sans',sans-serif;font-size:14px;background:var(--bg);color:var(--text);outline:none;transition:border-color .15s}
.field input:focus,.field select:focus{border-color:var(--orange);background:#fff}
.hint{font-size:11px;color:var(--muted);margin-top:4px}

.btn{padding:10px 22px;font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;border:2px solid var(--border);cursor:pointer;text-decoration:none;display:inline-block;letter-spacing:.3px;transition:all .15s}
.btn-orange{background:var(--orange);color:#fff;border-color:var(--orange)}
.btn-orange:hover{background:#9e4208}
.btn-row{display:flex;gap:10px;margin-top:8px}

table{width:100%;border-collapse:collapse}
th{background:#1a1a1a;color:rgba(255,255,255,.9);padding:11px 14px;font-family:'Space Mono',monospace;font-size:10px;text-transform:uppercase;letter-spacing:1.5px;text-align:left}
td{padding:12px 14px;border-bottom:1px solid #e8e5de;font-size:13px}
tr:last-child td{border-bottom:none}
tr:hover td{background:#f7f5f0}

.badge{display:inline-block;padding:3px 10px;font-size:11px;font-weight:700;letter-spacing:.5px;text-transform:uppercase;border:1.5px solid}
.badge-ok{background:#e6f4ec;color:#1a7a3c;border-color:#1a7a3c}
.badge-warn{background:#fff8e1;color:#a35a00;border-color:#a35a00}
.badge-info{background:#e8f0fb;color:#1a5fa8;border-color:#1a5fa8}

.no-data{text-align:center;padding:44px;color:var(--muted);font-size:14px}
.count-badge{background:var(--orange);color:#fff;padding:2px 10px;font-size:10px;font-weight:700;letter-spacing:.5px}
</style>
</head>
<body>

<div class="topbar">
  <div class="topbar-left">
    <span class="topbar-brand">&#9632; MotoRent</span>
    <div class="topbar-sep"></div>
    <span class="topbar-page">Xe Máy</span>
  </div>
  <nav class="topbar-nav">
    <a href="<%= ctx %>/doitac/quanlychinhanh">Chi Nhánh</a>
    <a href="<%= ctx %>/doitac/quanlymauxe">Mẫu Xe</a>
    <a href="<%= ctx %>/doitac/quanlyxemay" class="active">Xe Máy</a>
    <a href="<%= ctx %>/doitac/quanlygoithue">Gói Thuê</a>
    <a href="<%= ctx %>/views/doitac/quanlyxe.jsp">&#8592; Quản Lý Xe</a>
  </nav>
</div>

<div class="steps">
  <div class="step <%= currentStep==1?"active":(currentStep>1?"done":"") %>">
    <div class="step-n"><%= currentStep>1?"✓":"1" %></div>
    <div>
      <div class="step-lbl">Chi Nhánh</div>
      <% if(!tenCN.isEmpty()){ %><div class="step-sub"><%= esc(tenCN) %></div><% } %>
    </div>
  </div>
  <div class="step <%= currentStep==2?"active":(currentStep>2?"done":"") %>">
    <div class="step-n"><%= currentStep>2?"✓":"2" %></div>
    <div>
      <div class="step-lbl">Mẫu Xe</div>
      <% if(!tenMX.isEmpty()){ %><div class="step-sub"><%= esc(tenMX) %></div><% } %>
    </div>
  </div>
  <div class="step <%= currentStep==3?"active":"" %>">
    <div class="step-n">3</div>
    <div><div class="step-lbl">Thêm &amp; Quản Lý</div></div>
  </div>
</div>

<div class="wrap">

  <% if(msg!=null && !msg.isEmpty()){ %>
    <div class="alert alert-<%= "error".equals(msgType)?"error":"success" %>"><%= esc(msg) %></div>
  <% } %>

  <% if(currentStep > 1){ %>
    <div class="crumb">
      <a href="<%= ctx %>/doitac/quanlyxemay">&#8592; Đổi Chi Nhánh</a>
      <span class="crumb-sep">›</span>
      <strong><%= esc(tenCN) %></strong>
      <% if(currentStep == 3){ %>
        <span class="crumb-sep">›</span>
        <a href="<%= ctx %>/doitac/quanlyxemay?maChiNhanh=<%= maChiNhanh %>">Đổi Mẫu Xe</a>
        <span class="crumb-sep">›</span>
        <strong><%= esc(tenMX) %></strong>
      <% } %>
    </div>
  <% } %>

  <% if(currentStep == 1){ %>
    <div class="sec-label">Chọn chi nhánh</div>
    <% if(danhSachCN.isEmpty()){ %>
      <div class="no-data">Chưa có chi nhánh nào. <a href="<%= ctx %>/doitac/quanlychinhanh" style="color:var(--orange)">Thêm chi nhánh</a>.</div>
    <% } else { %>
      <form method="get" action="<%= ctx %>/doitac/quanlyxemay">
        <div class="cn-grid">
          <% for(ChiNhanh cn : danhSachCN){ %>
            <label class="radio-card">
              <input type="radio" name="maChiNhanh" value="<%= cn.getMaChiNhanh() %>" required />
              <div class="rc-name">&#9632; <%= esc(cn.getTenChiNhanh()) %></div>
              <div class="rc-sub"><%= esc(cn.getDiaDiem()) %></div>
            </label>
          <% } %>
        </div>
        <button type="submit" class="btn btn-orange">Chọn Mẫu Xe &#8594;</button>
      </form>
    <% } %>

  <% } else if(currentStep == 2){ %>
    <div class="sec-label">Chọn mẫu xe tại chi nhánh <strong><%= esc(tenCN) %></strong></div>
    <% if(danhSachMX == null || danhSachMX.isEmpty()){ %>
      <div class="no-data">Chưa có mẫu xe. <a href="<%= ctx %>/doitac/quanlymauxe?maChiNhanh=<%= maChiNhanh %>" style="color:var(--orange)">Thêm mẫu xe</a> trước.</div>
    <% } else { %>
      <form method="get" action="<%= ctx %>/doitac/quanlyxemay">
        <input type="hidden" name="maChiNhanh" value="<%= maChiNhanh %>" />
        <div class="cn-grid">
          <% for(MauXe mx : danhSachMX){ %>
            <label class="radio-card">
              <input type="radio" name="maMauXe" value="<%= mx.getMaMauXe() %>" required />
              <div class="rc-name">&#9632; <%= esc(mx.getHangXe()) %> <%= esc(mx.getDongXe()) %></div>
              <div class="rc-sub">Đời <%= mx.getDoiXe() %> &mdash; <%= mx.getDungTich() %>cc</div>
            </label>
          <% } %>
        </div>
        <button type="submit" class="btn btn-orange">Thêm Xe Máy &#8594;</button>
      </form>
    <% } %>

  <% } else { %>
    <div class="panel-split">
      <div class="panel">
        <div class="ph">+ Thêm Xe Máy</div>
        <div class="pb">
          <form method="post" action="<%= ctx %>/views/doitac/quanlyxemay.jsp">
            <input type="hidden" name="maChiNhanh" value="<%= maChiNhanh %>" />
            <input type="hidden" name="maMauXe"    value="<%= maMauXe %>" />
            <div class="field">
              <label>Biển Số *</label>
              <input type="text" name="bienSo" placeholder="20A1-12345" maxlength="20" required />
              <div class="hint">Định dạng: 20A1-12345</div>
            </div>
            <div class="field"><label>Số Khung *</label><input type="text" name="soKhung" placeholder="RLHPCF820HY..." maxlength="50" required /></div>
            <div class="field"><label>Số Máy *</label><input type="text" name="soMay" placeholder="PCF820E..." maxlength="50" required /></div>
            <div class="field">
              <label>Trạng Thái</label>
              <select name="trangThai">
                <option value="san_sang">Sẵn sàng</option>
                <option value="dang_thue">Đang thuê</option>
                <option value="bao_tri">Bảo trì</option>
              </select>
            </div>
            <div class="btn-row"><button type="submit" class="btn btn-orange">+ Thêm Xe</button></div>
          </form>
        </div>
      </div>

      <div class="panel">
        <div class="ph">
          <span>Xe — <%= esc(tenMX) %></span>
          <span class="count-badge"><%= danhSachXE != null ? danhSachXE.size() : 0 %> xe</span>
        </div>
        <% if(danhSachXE == null || danhSachXE.isEmpty()){ %>
          <div class="no-data">Chưa có xe nào với mẫu xe này tại chi nhánh.</div>
        <% } else { %>
          <table>
            <thead><tr><th>#</th><th>Biển Số</th><th>Số Khung</th><th>Số Máy</th><th>Trạng Thái</th></tr></thead>
            <tbody>
              <% int stt=1; for(XeMay xm : danhSachXE){ %>
              <tr>
                <td style="color:var(--muted);font-family:'Space Mono',monospace;font-size:11px"><%= stt++ %></td>
                <td><strong style="font-family:'Space Mono',monospace;font-size:13px"><%= esc(xm.getBienSo()) %></strong></td>
                <td style="color:var(--muted);font-size:12px"><%= esc(xm.getSoKhung()) %></td>
                <td style="color:var(--muted);font-size:12px"><%= esc(xm.getSoMay()) %></td>
                <td>
                  <%
                    String tt = xm.getTrangThai();
                    String bc = "san_sang".equals(tt) ? "badge-ok" : ("bao_tri".equals(tt) ? "badge-warn" : "badge-info");
                    String bl = "san_sang".equals(tt) ? "Sẵn sàng" : ("bao_tri".equals(tt) ? "Bảo trì" : "Đang thuê");
                  %>
                  <span class="badge <%= bc %>"><%= bl %></span>
                </td>
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
