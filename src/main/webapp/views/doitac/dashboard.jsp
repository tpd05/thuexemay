<%@ page contentType="text/html;charset=UTF-8"%>
<%
String ctxPath = request.getContextPath();
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");

if (username == null || role == null || !role.equals("DOI_TAC")) {
    response.sendRedirect(ctxPath + "/views/403.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Dashboard — Đối Tác</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --bg:#f0ede6;
  --card:#fff;
  --border:#1a1a1a;
  --blue:#1a5fa8;
  --blue-lt:#e8f0fb;
  --green:#1a7a3c;
  --green-lt:#e6f4ec;
  --amber:#a35a00;
  --amber-lt:#fef3e2;
  --text:#1a1a1a;
  --muted:#555;
}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}

/* Topbar */
.topbar{
  background:#1a1a1a;color:#fff;
  display:flex;align-items:center;justify-content:space-between;
  padding:0 36px;height:56px;
  border-bottom:3px solid var(--blue);
}
.topbar-brand{
  font-family:'Space Mono',monospace;font-size:14px;font-weight:700;
  letter-spacing:3px;text-transform:uppercase;
}
.topbar-right{display:flex;align-items:center;gap:20px}
.topbar-user{font-size:13px;color:rgba(255,255,255,.6)}
.topbar-user strong{color:#fff}
.btn-logout{
  border:1px solid rgba(255,255,255,.3);background:transparent;
  color:rgba(255,255,255,.8);padding:6px 16px;font-family:'DM Sans',sans-serif;
  font-size:12px;font-weight:600;cursor:pointer;letter-spacing:.3px;transition:all .15s;
}
.btn-logout:hover{background:rgba(255,255,255,.1);color:#fff;border-color:#fff}

/* Page */
.page{max-width:960px;margin:0 auto;padding:52px 32px}
.page-title{
  font-family:'Space Mono',monospace;font-size:20px;font-weight:700;
  text-transform:uppercase;letter-spacing:2px;
  display:flex;align-items:center;gap:14px;margin-bottom:6px;
}
.page-title::before{content:'';display:block;width:6px;height:28px;background:var(--blue)}
.page-sub{font-size:14px;color:var(--muted);margin-left:20px;margin-bottom:40px}

/* Cards */
.cards{display:grid;grid-template-columns:repeat(3,1fr);border:2px solid var(--border)}
.card{
  background:var(--card);border-right:2px solid var(--border);
  padding:40px 30px 32px;text-decoration:none;color:var(--text);
  display:block;position:relative;overflow:hidden;transition:background .15s;
}
.card:last-child{border-right:none}
.card:hover{background:#f9f7f3}
.card-top-bar{position:absolute;top:0;left:0;right:0;height:5px}
.card-blue .card-top-bar{background:var(--blue)}
.card-green .card-top-bar{background:var(--green)}
.card-amber .card-top-bar{background:var(--amber)}

.card-icon{
  font-size:28px;margin-bottom:20px;
  width:56px;height:56px;border:2px solid var(--border);background:var(--bg);
  display:flex;align-items:center;justify-content:center;
}
.card-label{
  display:inline-block;font-size:10px;font-weight:700;letter-spacing:1.5px;
  text-transform:uppercase;padding:2px 8px;margin-bottom:12px;border:1.5px solid;
}
.card-blue .card-label{color:var(--blue);border-color:var(--blue);background:var(--blue-lt)}
.card-green .card-label{color:var(--green);border-color:var(--green);background:var(--green-lt)}
.card-amber .card-label{color:var(--amber);border-color:var(--amber);background:var(--amber-lt)}

.card-name{
  font-family:'Space Mono',monospace;font-size:14px;font-weight:700;
  text-transform:uppercase;letter-spacing:1px;line-height:1.5;margin-bottom:12px;
}
.card-desc{font-size:13px;color:var(--muted);line-height:1.65;margin-bottom:28px}
.card-cta{
  font-size:12px;font-weight:700;letter-spacing:1px;text-transform:uppercase;
  display:inline-flex;align-items:center;gap:8px;
  padding:8px 16px;border:2px solid var(--border);background:transparent;
  transition:all .15s;
}
.card:hover .card-cta{background:var(--border);color:#fff}

/* Bottom strip */
.info-strip{
  border:2px solid var(--border);border-top:none;
  background:#fff;padding:12px 20px;
  font-size:12px;color:var(--muted);
  display:flex;gap:28px;
}
</style>
</head>
<body>

<div class="topbar">
  <span class="topbar-brand">&#9632; MotoRent — Đối Tác</span>
  <div class="topbar-right">
    <span class="topbar-user">Xin chào, <strong><%=username%></strong></span>
    <button class="btn-logout" onclick="confirmLogout()">Đăng Xuất</button>
  </div>
</div>

<div class="page">
  <div class="page-title">Dashboard</div>
  <div class="page-sub">Chọn mục cần quản lý</div>

  <div class="cards">

    <a href="<%=ctxPath%>/doitac/quanlygoithue" class="card card-blue">
      <div class="card-top-bar"></div>
      <div class="card-icon">📦</div>
      <div class="card-label">Gói Thuê</div>
      <div class="card-name">Quản Lý Gói Thuê</div>
      <div class="card-desc">Tạo và quản lý các gói cho thuê theo ngày, theo giờ với phụ kiện đi kèm.</div>
      <div class="card-cta">Vào Trang →</div>
    </a>

    <a href="<%=ctxPath%>/doitac/quanlychinhanh" class="card card-green">
      <div class="card-top-bar"></div>
      <div class="card-icon">🏢</div>
      <div class="card-label">Chi Nhánh</div>
      <div class="card-name">Quản Lý Chi Nhánh</div>
      <div class="card-desc">Thêm và xem danh sách các chi nhánh thuộc hệ thống đối tác của bạn.</div>
      <div class="card-cta">Vào Trang →</div>
    </a>

    <a href="<%=ctxPath%>/views/doitac/quanlyxe.jsp" class="card card-amber">
      <div class="card-top-bar"></div>
      <div class="card-icon">🏍</div>
      <div class="card-label">Xe Máy</div>
      <div class="card-name">Quản Lý Xe Máy</div>
      <div class="card-desc">Quản lý mẫu xe và xe máy theo từng chi nhánh trong hệ thống.</div>
      <div class="card-cta">Vào Trang →</div>
    </a>

  </div>

  <div class="info-strip">
    <span>Vai trò: <strong style="color:var(--text)">Đối Tác</strong></span>
    <span>Tài khoản: <strong style="color:var(--text)"><%=username%></strong></span>
  </div>
</div>

<script>
const ctx='<%=ctxPath%>';
function confirmLogout(){
  if(confirm('Bạn có muốn đăng xuất không?'))
    window.location.href=ctx+'/logout';
}
</script>
</body>
</html>
