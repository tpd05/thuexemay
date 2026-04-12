<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    javax.servlet.http.HttpSession sess = request.getSession(false);
    if (sess == null || !"DOI_TAC".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/dangnhap"); return;
    }
    String username = (String) sess.getAttribute("username");
    String ctx = request.getContextPath();
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
:root{
  --bg:#f0ede6;--card:#fff;--border:#1a1a1a;
  --amber:#a35a00;--amber-lt:#fef3e2;
  --blue:#1a5fa8;--blue-lt:#e8f0fb;
  --orange:#c0550a;--orange-lt:#fff0e8;
  --text:#1a1a1a;--muted:#555;
}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}

/* Topbar */
.topbar{
  background:#1a1a1a;color:#fff;
  display:flex;align-items:center;justify-content:space-between;
  padding:0 36px;height:56px;border-bottom:3px solid var(--amber);
}
.topbar-left{display:flex;align-items:center;gap:16px}
.topbar-brand{font-family:'Space Mono',monospace;font-size:14px;font-weight:700;letter-spacing:3px;text-transform:uppercase}
.topbar-sep{width:1px;height:18px;background:rgba(255,255,255,.2)}
.topbar-page{font-size:12px;color:rgba(255,255,255,.5);font-weight:500;letter-spacing:.5px;text-transform:uppercase}
.topbar-nav{display:flex;gap:2px}
.topbar-nav a{
  color:rgba(255,255,255,.6);text-decoration:none;
  padding:0 14px;height:56px;display:flex;align-items:center;
  font-size:12px;font-weight:600;letter-spacing:.5px;
  text-transform:uppercase;border-left:1px solid rgba(255,255,255,.08);
  transition:all .15s;
}
.topbar-nav a:hover{background:rgba(255,255,255,.08);color:#fff}
.topbar-nav a.active{background:var(--amber);color:#fff}

/* Page */
.page{max-width:820px;margin:0 auto;padding:52px 32px}

/* Breadcrumb */
.breadcrumb{
  display:flex;align-items:center;gap:10px;
  font-size:12px;font-weight:600;letter-spacing:.5px;text-transform:uppercase;
  margin-bottom:36px;color:var(--muted);
}
.breadcrumb a{color:var(--amber);text-decoration:none}
.breadcrumb a:hover{text-decoration:underline}
.breadcrumb-sep{color:#bbb}

.page-title{
  font-family:'Space Mono',monospace;font-size:19px;font-weight:700;
  text-transform:uppercase;letter-spacing:2px;
  display:flex;align-items:center;gap:14px;margin-bottom:6px;
}
.page-title::before{content:'';display:block;width:6px;height:28px;background:var(--amber)}
.page-sub{font-size:14px;color:var(--muted);margin-left:20px;margin-bottom:44px}

/* Two cards */
.xe-cards{display:grid;grid-template-columns:1fr 1fr;border:2px solid var(--border)}

.xe-card{
  background:var(--card);padding:44px 36px 36px;
  text-decoration:none;color:var(--text);
  display:block;position:relative;overflow:hidden;
  transition:background .15s;
}
.xe-card:first-child{border-right:2px solid var(--border)}
.xe-card:hover{background:#f8f5f0}
.xe-card:hover .xe-cta{background:var(--border);color:#fff}

.xe-card-bar{position:absolute;top:0;left:0;right:0;height:5px}
.xe-card-blue .xe-card-bar{background:var(--blue)}
.xe-card-orange .xe-card-bar{background:var(--orange)}

.xe-icon{
  width:64px;height:64px;border:2px solid var(--border);background:var(--bg);
  display:flex;align-items:center;justify-content:center;font-size:28px;
  margin-bottom:24px;
}
.xe-badge{
  display:inline-block;font-size:10px;font-weight:700;letter-spacing:1.5px;
  text-transform:uppercase;padding:3px 9px;border:1.5px solid;margin-bottom:14px;
}
.xe-card-blue .xe-badge{color:var(--blue);border-color:var(--blue);background:var(--blue-lt)}
.xe-card-orange .xe-badge{color:var(--orange);border-color:var(--orange);background:var(--orange-lt)}

.xe-name{
  font-family:'Space Mono',monospace;font-size:16px;font-weight:700;
  text-transform:uppercase;letter-spacing:1.5px;margin-bottom:14px;line-height:1.4;
}
.xe-desc{font-size:13px;color:var(--muted);line-height:1.65;margin-bottom:32px}

.xe-cta{
  display:inline-flex;align-items:center;gap:10px;
  border:2px solid var(--border);padding:10px 20px;
  font-size:12px;font-weight:700;letter-spacing:1px;text-transform:uppercase;
  transition:all .15s;background:transparent;color:var(--text);
}

/* Bottom strip */
.back-strip{
  border:2px solid var(--border);border-top:none;
  background:#fff;padding:14px 20px;
  display:flex;align-items:center;gap:12px;
}
.back-link{
  font-size:12px;font-weight:700;letter-spacing:.5px;text-transform:uppercase;
  color:var(--muted);text-decoration:none;display:flex;align-items:center;gap:6px;
}
.back-link:hover{color:var(--text)}
</style>
</head>
<body>

<div class="topbar">
  <div class="topbar-left">
    <span class="topbar-brand">&#9632; MotoRent</span>
    <div class="topbar-sep"></div>
    <span class="topbar-page">Quản Lý Xe Máy</span>
  </div>
  <nav class="topbar-nav">
    <a href="<%= ctx %>/doitac/quanlychinhanh">Chi Nhánh</a>
    <a href="<%= ctx %>/views/doitac/quanlyxe.jsp" class="active">Xe Máy</a>
    <a href="<%= ctx %>/doitac/quanlygoithue">Gói Thuê</a>
    <a href="<%= ctx %>/doitac/dashboard">&#8592; Trang Chủ</a>
  </nav>
</div>

<div class="page">

  <div class="breadcrumb">
    <a href="<%= ctx %>/doitac/dashboard">Dashboard</a>
    <span class="breadcrumb-sep">›</span>
    <span>Quản Lý Xe Máy</span>
  </div>

  <div class="page-title">Quản Lý Xe</div>
  <div class="page-sub">Chọn loại quản lý bên dưới</div>

  <div class="xe-cards">

    <!-- Mẫu xe -->
    <a href="<%= ctx %>/doitac/quanlymauxe" class="xe-card xe-card-blue">
      <div class="xe-card-bar"></div>
      <div class="xe-icon">🗂</div>
      <div class="xe-badge">Mẫu Xe</div>
      <div class="xe-name">Quản Lý<br>Mẫu Xe</div>
      <div class="xe-desc">
        Thêm và xem danh sách các mẫu xe (hãng, dòng xe, đời, dung tích) 
        theo từng chi nhánh của bạn.
      </div>
      <div class="xe-cta">Vào Trang →</div>
    </a>

    <!-- Xe máy -->
    <a href="<%= ctx %>/doitac/quanlyxemay" class="xe-card xe-card-orange">
      <div class="xe-card-bar"></div>
      <div class="xe-icon">🔑</div>
      <div class="xe-badge">Xe Máy</div>
      <div class="xe-name">Quản Lý<br>Xe Máy</div>
      <div class="xe-desc">
        Thêm xe máy theo biển số, số khung, số máy và theo dõi 
        trạng thái từng xe (sẵn sàng, đang thuê, bảo trì).
      </div>
      <div class="xe-cta">Vào Trang →</div>
    </a>

  </div>

  <div class="back-strip">
    <a href="<%= ctx %>/doitac/dashboard" class="back-link">&#8592; Về Dashboard</a>
  </div>

</div>

</body>
</html>
