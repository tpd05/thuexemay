<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChiNhanhDAO,dao.MauXeDAO,dao.GoiThueDAO,model.ChiNhanh,model.MauXe,model.GoiThue,java.util.List,java.net.URLEncoder,java.text.NumberFormat,java.util.Locale" %>
<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
    private String fmt(String s){ return s == null ? "" : s; }
    private String fmtMoney(float f){
        return NumberFormat.getNumberInstance(new Locale("vi","VN")).format((long)f) + " ₫";
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
        String maMauXeStr    = request.getParameter("maMauXe");
        String tenGoiThue    = request.getParameter("tenGoiThue");
        String phuKien       = request.getParameter("phuKien");
        String giaNgayStr    = request.getParameter("giaNgay");
        String giaGioStr     = request.getParameter("giaGio");
        String phuThuStr     = request.getParameter("phuThu");
        String giamGiaStr    = request.getParameter("giamGia");
        String base          = ctx + "/doitac/quanlygoithue?maChiNhanh=" + fmt(maChiNhanhStr) + "&maMauXe=" + fmt(maMauXeStr);
        if (tenGoiThue == null || tenGoiThue.trim().isEmpty()) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Tên gói thuê không được để trống","UTF-8")); return;
        }
        if (giaNgayStr == null || giaNgayStr.trim().isEmpty()) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Giá ngày không được để trống","UTF-8")); return;
        }
        if (giaGioStr == null || giaGioStr.trim().isEmpty()) {
            response.sendRedirect(base + "&msgType=error&msg=" + URLEncoder.encode("Giá giờ không được để trống","UTF-8")); return;
        }
        try {
            int   maCN    = Integer.parseInt(maChiNhanhStr.trim());
            int   maMX    = Integer.parseInt(maMauXeStr.trim());
            float giaNgay = Float.parseFloat(giaNgayStr.trim());
            float giaGio  = Float.parseFloat(giaGioStr.trim());
            float phuThu  = (phuThuStr  != null && !phuThuStr.trim().isEmpty())  ? Float.parseFloat(phuThuStr.trim())  : 0f;
            float giamGia = (giamGiaStr != null && !giamGiaStr.trim().isEmpty()) ? Float.parseFloat(giamGiaStr.trim()) : 0f;
            if (giaNgay <= 0) throw new IllegalArgumentException("Giá ngày phải lớn hơn 0");
            if (giaGio  <= 0) throw new IllegalArgumentException("Giá giờ phải lớn hơn 0");
            if (phuThu  <  0) throw new IllegalArgumentException("Phụ thu không được âm");
            if (giamGia < 0 || giamGia > 100) throw new IllegalArgumentException("Giảm giá phải từ 0 đến 100 (%)");
            GoiThue gt = new GoiThue();
            gt.setMaMauXe(maMX); gt.setMaDoiTac(maDoiTac); gt.setMaChiNhanh(maCN);
            gt.setTenGoiThue(tenGoiThue.trim());
            gt.setPhuKien(phuKien != null ? phuKien.trim() : "");
            gt.setGiaNgay(giaNgay); gt.setGiaGio(giaGio); gt.setPhuThu(phuThu); gt.setGiamGia(giamGia);
            new GoiThueDAO().themGoiThue(gt);
            response.sendRedirect(base + "&msgType=success&msg=" + URLEncoder.encode("Tạo gói thuê thành công!","UTF-8"));
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
    List<GoiThue>  danhSachGT = (currentStep == 3) ? new GoiThueDAO().layDanhSachTheoDoiTac(maDoiTac) : null;
    String tenCN = "", tenMX = "";
    for (ChiNhanh cn : danhSachCN) if (cn.getMaChiNhanh() == maChiNhanh) { tenCN = cn.getTenChiNhanh(); break; }
    if (danhSachMX != null) for (MauXe mx : danhSachMX) if (mx.getMaMauXe() == maMauXe) { tenMX = mx.getHangXe() + " " + mx.getDongXe(); break; }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Quản Lý Gói Thuê</title>
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

.steps{display:flex;background:var(--card);border-bottom:2px solid var(--border)}
.step{flex:1;padding:14px 20px;display:flex;align-items:center;gap:12px;border-right:2px solid var(--border);opacity:.35}
.step:last-child{border-right:none}
.step.active{opacity:1}
.step.done{opacity:.7}
.step-n{width:28px;height:28px;background:#ddd;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:12px;flex-shrink:0;font-family:'Space Mono',monospace}
.step.active .step-n{background:var(--blue);color:#fff}
.step.done .step-n{background:#1a1a1a;color:#fff}
.step-lbl{font-family:'Space Mono',monospace;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px}
.step-sub{font-size:12px;color:var(--muted);margin-top:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:160px}

.wrap{max-width:1200px;margin:0 auto;padding:28px 36px}

.alert{padding:12px 16px;font-size:13px;font-weight:600;margin-bottom:20px;border:2px solid}
.alert-success{background:#e6f4ec;color:#145c2c;border-color:#1a7a3c}
.alert-error{background:#fde8e8;color:#8b1a1a;border-color:#c0392b}

.crumb{background:var(--card);border:2px solid var(--border);padding:10px 16px;margin-bottom:20px;font-size:12px;display:flex;align-items:center;gap:10px;flex-wrap:wrap}
.crumb a{color:var(--blue);text-decoration:none;font-weight:700}
.crumb a:hover{text-decoration:underline}
.crumb-sep{color:#bbb}

.cn-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:0;margin-bottom:24px;border:2px solid var(--border)}
.radio-card{position:relative;padding:16px 18px;background:var(--card);cursor:pointer;display:block;border-right:2px solid var(--border);border-bottom:2px solid var(--border);transition:background .15s}
.radio-card:hover{background:var(--bg)}
.radio-card input[type=radio]{position:absolute;top:14px;right:14px;accent-color:var(--blue)}
.rc-name{font-weight:700;font-size:14px;padding-right:24px;margin-bottom:4px}
.rc-sub{font-size:12px;color:var(--muted)}
.sec-label{font-family:'Space Mono',monospace;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1.5px;color:var(--muted);margin-bottom:14px}

.panel-split{display:grid;grid-template-columns:380px 1fr;gap:0;border:2px solid var(--border)}
.panel{background:var(--card)}
.panel:first-child{border-right:2px solid var(--border)}
.ph{background:#1a1a1a;color:rgba(255,255,255,.9);padding:12px 18px;font-family:'Space Mono',monospace;font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:2px;display:flex;align-items:center;justify-content:space-between}
.pb{padding:22px}

.summary{background:var(--bg);border:2px solid var(--border);padding:12px 16px;margin-bottom:18px;display:flex;gap:28px;flex-wrap:wrap}
.sum-lbl{font-size:10px;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:3px}
.sum-val{font-size:14px;font-weight:700}

.field{margin-bottom:16px}
.field label{display:block;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;margin-bottom:6px;color:var(--muted)}
.field input,.field textarea{width:100%;border:2px solid var(--border);padding:9px 12px;font-family:'DM Sans',sans-serif;font-size:14px;background:var(--bg);color:var(--text);outline:none;transition:border-color .15s}
.field input:focus,.field textarea:focus{border-color:var(--blue);background:#fff}
.field textarea{resize:vertical;min-height:72px}
.hint{font-size:11px;color:var(--muted);margin-top:4px}
.row2{display:grid;grid-template-columns:1fr 1fr;gap:12px}

.btn{padding:10px 22px;font-family:'DM Sans',sans-serif;font-size:13px;font-weight:700;border:2px solid var(--border);cursor:pointer;text-decoration:none;display:inline-block;letter-spacing:.3px;transition:all .15s}
.btn-blue{background:var(--blue);color:#fff;border-color:var(--blue)}
.btn-blue:hover{background:#154d8c}
.btn-row{display:flex;gap:10px;margin-top:8px}

table{width:100%;border-collapse:collapse}
th{background:#1a1a1a;color:rgba(255,255,255,.9);padding:11px 14px;font-family:'Space Mono',monospace;font-size:10px;text-transform:uppercase;letter-spacing:1.5px;text-align:left}
td{padding:12px 14px;border-bottom:1px solid #e8e5de;font-size:13px}
tr:last-child td{border-bottom:none}
tr:hover td{background:#f7f5f0}
.price{font-weight:700;color:var(--blue);font-family:'Space Mono',monospace;font-size:12px}
.no-data{text-align:center;padding:44px;color:var(--muted);font-size:14px}
.count-badge{background:var(--blue);color:#fff;padding:2px 10px;font-size:10px;font-weight:700;letter-spacing:.5px}
</style>
</head>
<body>

<div class="topbar">
  <div class="topbar-left">
    <span class="topbar-brand">&#9632; MotoRent</span>
    <div class="topbar-sep"></div>
    <span class="topbar-page">Gói Thuê</span>
  </div>
  <nav class="topbar-nav">
    <a href="<%= ctx %>/doitac/quanlychinhanh">Chi Nhánh</a>
    <a href="<%= ctx %>/views/doitac/quanlyxe.jsp">Xe Máy</a>
    <a href="<%= ctx %>/doitac/quanlygoithue" class="active">Gói Thuê</a>
    <a href="<%= ctx %>/doitac/dashboard">&#8592; Trang Chủ</a>
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
    <div><div class="step-lbl">Tạo &amp; Quản Lý Gói</div></div>
  </div>
</div>

<div class="wrap">

  <% if(msg!=null && !msg.isEmpty()){ %>
    <div class="alert alert-<%= "error".equals(msgType)?"error":"success" %>"><%= esc(msg) %></div>
  <% } %>

  <% if(currentStep > 1){ %>
    <div class="crumb">
      <a href="<%= ctx %>/doitac/quanlygoithue">&#8592; Đổi Chi Nhánh</a>
      <span class="crumb-sep">›</span>
      <strong><%= esc(tenCN) %></strong>
      <% if(currentStep == 3){ %>
        <span class="crumb-sep">›</span>
        <a href="<%= ctx %>/doitac/quanlygoithue?maChiNhanh=<%= maChiNhanh %>">Đổi Mẫu Xe</a>
        <span class="crumb-sep">›</span>
        <strong><%= esc(tenMX) %></strong>
      <% } %>
    </div>
  <% } %>

  <% if(currentStep == 1){ %>
    <div class="sec-label">Chọn chi nhánh để tạo gói thuê</div>
    <% if(danhSachCN.isEmpty()){ %>
      <div class="no-data">Chưa có chi nhánh. <a href="<%= ctx %>/doitac/quanlychinhanh" style="color:var(--blue)">Thêm chi nhánh</a>.</div>
    <% } else { %>
      <form method="get" action="<%= ctx %>/doitac/quanlygoithue">
        <div class="cn-grid">
          <% for(ChiNhanh cn : danhSachCN){ %>
            <label class="radio-card">
              <input type="radio" name="maChiNhanh" value="<%= cn.getMaChiNhanh() %>" required />
              <div class="rc-name">&#9632; <%= esc(cn.getTenChiNhanh()) %></div>
              <div class="rc-sub"><%= esc(cn.getDiaDiem()) %></div>
            </label>
          <% } %>
        </div>
        <button type="submit" class="btn btn-blue">Chọn Mẫu Xe &#8594;</button>
      </form>
    <% } %>

  <% } else if(currentStep == 2){ %>
    <div class="sec-label">Chọn mẫu xe muốn tạo gói thuê</div>
    <% if(danhSachMX == null || danhSachMX.isEmpty()){ %>
      <div class="no-data">Chưa có mẫu xe tại chi nhánh này. <a href="<%= ctx %>/doitac/quanlymauxe?maChiNhanh=<%= maChiNhanh %>" style="color:var(--blue)">Thêm mẫu xe</a> trước.</div>
    <% } else { %>
      <form method="get" action="<%= ctx %>/doitac/quanlygoithue">
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
        <button type="submit" class="btn btn-blue">Tạo Gói Thuê &#8594;</button>
      </form>
    <% } %>

  <% } else { %>
    <div class="panel-split">
      <div class="panel">
        <div class="ph">+ Tạo Gói Thuê Mới</div>
        <div class="pb">
          <div class="summary">
            <div><div class="sum-lbl">Chi Nhánh</div><div class="sum-val"><%= esc(tenCN) %></div></div>
            <div><div class="sum-lbl">Mẫu Xe</div><div class="sum-val"><%= esc(tenMX) %></div></div>
          </div>
          <form method="post" action="<%= ctx %>/views/doitac/quanlygoithue.jsp">
            <input type="hidden" name="maChiNhanh" value="<%= maChiNhanh %>" />
            <input type="hidden" name="maMauXe"    value="<%= maMauXe %>" />
            <!-- Giảm giá ẩn, mặc định 0, backend vẫn xử lý bình thường -->
            <input type="hidden" name="giamGia" value="0" />
            <div class="field"><label>Tên Gói Thuê *</label><input type="text" name="tenGoiThue" placeholder="VD: Gói ngày Honda Wave" maxlength="100" required /></div>
            <div class="row2">
              <div class="field"><label>Giá / Ngày (₫) *</label><input type="number" name="giaNgay" placeholder="150000" min="1" required /></div>
              <div class="field"><label>Giá / Giờ (₫) *</label><input type="number" name="giaGio" placeholder="25000" min="1" required /></div>
            </div>
            <div class="field">
              <label>Phụ Thu (₫)</label>
              <input type="number" name="phuThu" value="0" min="0" />
              <div class="hint">Phí phát sinh nếu có</div>
            </div>
            <div class="field"><label>Phụ Kiện Đi Kèm</label><textarea name="phuKien" placeholder="Mũ bảo hiểm, áo mưa, bơm xe..."></textarea></div>
            <div class="btn-row"><button type="submit" class="btn btn-blue">+ Tạo Gói Thuê</button></div>
          </form>
        </div>
      </div>

      <div class="panel">
        <div class="ph">
          <span>Tất Cả Gói Thuê</span>
          <span class="count-badge"><%= danhSachGT != null ? danhSachGT.size() : 0 %> gói</span>
        </div>
        <% if(danhSachGT == null || danhSachGT.isEmpty()){ %>
          <div class="no-data">Chưa có gói thuê nào. Hãy tạo gói thuê đầu tiên!</div>
        <% } else { %>
          <table>
            <thead>
              <tr><th>#</th><th>Tên Gói</th><th>Giá / Ngày</th><th>Giá / Giờ</th><th>Phụ Thu</th><th>Phụ Kiện</th></tr>
            </thead>
            <tbody>
              <% int stt=1; for(GoiThue gt : danhSachGT){ %>
              <tr>
                <td style="color:var(--muted);font-family:'Space Mono',monospace;font-size:11px"><%= stt++ %></td>
                <td><strong><%= esc(gt.getTenGoiThue()) %></strong></td>
                <td class="price"><%= fmtMoney(gt.getGiaNgay()) %></td>
                <td class="price"><%= fmtMoney(gt.getGiaGio()) %></td>
                <td style="color:var(--muted)"><%= gt.getPhuThu() > 0 ? fmtMoney(gt.getPhuThu()) : "—" %></td>
                <td style="max-width:150px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;color:var(--muted);font-size:12px">
                  <%= gt.getPhuKien() != null && !gt.getPhuKien().isEmpty() ? esc(gt.getPhuKien()) : "—" %>
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
