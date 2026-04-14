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
            if (giaNgay <= 0) throw new IllegalArgumentException("Giá ngày phải lớn hơn 0");
            if (giaGio  <= 0) throw new IllegalArgumentException("Giá giờ phải lớn hơn 0");
             if (phuThu  <  0) throw new IllegalArgumentException("Phụ thu không được âm");
            GoiThue gt = new GoiThue();
            gt.setMaMauXe(maMX); gt.setMaDoiTac(maDoiTac); gt.setMaChiNhanh(maCN);
            gt.setTenGoiThue(tenGoiThue.trim());
            gt.setPhuKien(phuKien != null ? phuKien.trim() : "");
            gt.setGiaNgay(giaNgay);
            gt.setGiaGio(giaGio);
            gt.setPhuThu(phuThu);
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Gói Thuê - Đối Tác</title>
    <link href="${pageContext.request.contextPath}/dist/tailwind.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/globals.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/components.css" rel="stylesheet">
    <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
    <style>
        /* Page-specific styles */
        .form-card {
            transition: all 0.3s ease;
            background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: var(--spacing-2xl);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        }
        
        .form-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .branch-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 0;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
        }

        .branch-card {
            position: relative;
            padding: var(--spacing-lg);
            background: #f9fafb;
            border-right: 1px solid #e5e7eb;
            border-bottom: 1px solid #e5e7eb;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .branch-card:hover {
            background: #ffffff;
            box-shadow: inset 0 0 0 2px #10b981;
        }

        .branch-card input[type="radio"] {
            position: absolute;
            top: var(--spacing-md);
            right: var(--spacing-md);
            accent-color: #10b981;
            cursor: pointer;
        }

        .branch-name {
            font-weight: 700;
            font-size: 14px;
            margin-bottom: var(--spacing-sm);
            padding-right: 28px;
            color: var(--color-text-primary);
        }

        .branch-address {
            font-size: 12px;
            color: #6b7280;
        }

        .table-row:hover {
            background: rgba(16, 185, 129, 0.02);
        }

        .alert-message {
            padding: var(--spacing-md) var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
        }

        .alert-message.alert-error {
            border-left: 4px solid #dc2626;
            background: #fef2f2;
            color: #991b1b;
        }

        .alert-message.alert-success {
            border-left: 4px solid #10b981;
            background: #ecfdf5;
            color: #047857;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: var(--spacing-md);
            padding: var(--spacing-md) var(--spacing-lg);
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            margin-bottom: var(--spacing-lg);
            font-size: 13px;
            flex-wrap: wrap;
        }

        .breadcrumb a {
            color: #10b981;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .breadcrumb-sep {
            color: #ccc;
        }

        .panel-two-column {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-3xl);
        }

        .panel-title {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: var(--spacing-lg);
            background: #1a1a1a;
            color: white;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-radius: 8px 8px 0 0;
        }

        .panel-content {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            overflow: hidden;
        }

        .panel-body {
            padding: var(--spacing-lg);
        }

        .count-badge {
            display: inline-block;
            padding: 2px 10px;
            background: #10b981;
            color: white;
            font-size: 12px;
            font-weight: 700;
            border-radius: 4px;
            letter-spacing: 0.5px;
        }

        .summary-box {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            border-radius: 6px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--spacing-lg);
        }

        .summary-item {
            text-align: center;
        }

        .summary-label {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            color: #6b7280;
            margin-bottom: 4px;
            letter-spacing: 0.5px;
        }

        .summary-value {
            font-size: 14px;
            font-weight: 700;
            color: var(--color-text-primary);
        }

        .no-data {
            text-align: center;
            padding: var(--spacing-3xl);
            color: #6b7280;
            font-size: 14px;
        }

        .price-highlight {
            font-weight: 700;
            color: #10b981;
            font-family: 'Monaco', monospace;
            font-size: 13px;
        }
    </style>
</head>
<body class="bg-color-bg-primary text-color-text-primary font-body">

    <div class="page-wrapper">
        <header class="page-header">
            <jsp:include page="/components/navbar.jsp" />
        </header>

        <main class="page-main">
            <section class="app-container">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-top: var(--spacing-3xl); margin-bottom: var(--spacing-lg);">
                    <h1 style="font-size: var(--text-3xl); font-weight: 700; margin: 0;">Quản Lý Gói Thuê</h1>
                </div>

                <% if (msg != null && !msg.isEmpty()) { %>
                    <div class="alert-message alert-<%= "error".equals(msgType) ? "error" : "success" %>">
                        <%= esc(msg) %>
                    </div>
                <% } %>

                <% if (currentStep == 1) { %>
                    <!-- Step 1: Choose Branch -->
                    <div class="form-card" style="margin-bottom: var(--spacing-3xl);">
                        <div style="display: flex; align-items: center; gap: var(--spacing-md); font-size: var(--text-lg); font-weight: 700; margin-bottom: var(--spacing-lg); color: var(--color-text-primary); padding-bottom: var(--spacing-md); border-bottom: 2px solid #e5e7eb;">
                            <iconify-icon icon="mdi:store" width="24" height="24" style="color: #10b981;"></iconify-icon>
                            <span>Chọn Chi Nhánh</span>
                        </div>

                        <% if (danhSachCN.isEmpty()) { %>
                            <div class="no-data">
                                <iconify-icon icon="mdi:inbox-outline" width="48" height="48" style="display: block; margin: 0 auto var(--spacing-md); opacity: 0.4;"></iconify-icon>
                                Chưa có chi nhánh nào. <a href="<%= ctx %>/doitac/quanlychinhanh" style="color: #10b981; text-decoration: none; font-weight: 600;">Thêm chi nhánh trước</a>.
                            </div>
                        <% } else { %>
                            <form method="get" action="<%= ctx %>/doitac/quanlygoithue">
                                <div class="branch-grid" style="margin-bottom: var(--spacing-lg);">
                                    <% for (ChiNhanh cn : danhSachCN) { %>
                                        <label class="branch-card">
                                            <input type="radio" name="maChiNhanh" value="<%= cn.getMaChiNhanh() %>" required />
                                            <div class="branch-name"><%= esc(cn.getTenChiNhanh()) %></div>
                                            <div class="branch-address"><%= esc(cn.getDiaDiem()) %></div>
                                        </label>
                                    <% } %>
                                </div>
                                <button type="submit" style="background: #10b981; color: white; padding: var(--spacing-sm) var(--spacing-md); border: none; border-radius: 6px; font-family: inherit; font-size: 12px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; text-decoration: none; transition: all 0.15s ease;">
                                    <iconify-icon icon="mdi:arrow-right" width="14" height="14"></iconify-icon>
                                    Chọn Mẫu Xe
                                </button>
                            </form>
                        <% } %>
                    </div>

                <% } else if (currentStep == 2) { %>
                    <!-- Step 2: Choose Model -->
                    <div class="breadcrumb">
                        <a href="<%= ctx %>/doitac/quanlygoithue">
                            <iconify-icon icon="mdi:arrow-left" width="14" height="14"></iconify-icon>
                            Đổi Chi Nhánh
                        </a>
                        <span class="breadcrumb-sep">›</span>
                        <strong><%= esc(tenCN) %></strong>
                    </div>

                    <div class="form-card" style="margin-bottom: var(--spacing-3xl);">
                        <div style="display: flex; align-items: center; gap: var(--spacing-md); font-size: var(--text-lg); font-weight: 700; margin-bottom: var(--spacing-lg); color: var(--color-text-primary); padding-bottom: var(--spacing-md); border-bottom: 2px solid #e5e7eb;">
                            <iconify-icon icon="mdi:shape" width="24" height="24" style="color: #10b981;"></iconify-icon>
                            <span>Chọn Mẫu Xe</span>
                        </div>

                        <% if (danhSachMX == null || danhSachMX.isEmpty()) { %>
                            <div class="no-data">
                                <iconify-icon icon="mdi:inbox-outline" width="48" height="48" style="display: block; margin: 0 auto var(--spacing-md); opacity: 0.4;"></iconify-icon>
                                Chưa có mẫu xe. <a href="<%= ctx %>/doitac/quanlymauxe?maChiNhanh=<%= maChiNhanh %>" style="color: #10b981; text-decoration: none; font-weight: 600;">Thêm mẫu xe</a> trước.
                            </div>
                        <% } else { %>
                            <form method="get" action="<%= ctx %>/doitac/quanlygoithue">
                                <input type="hidden" name="maChiNhanh" value="<%= maChiNhanh %>" />
                                <div class="branch-grid" style="margin-bottom: var(--spacing-lg);">
                                    <% for (MauXe mx : danhSachMX) { %>
                                        <label class="branch-card">
                                            <input type="radio" name="maMauXe" value="<%= mx.getMaMauXe() %>" required />
                                            <div class="branch-name"><%= esc(mx.getHangXe()) %> <%= esc(mx.getDongXe()) %></div>
                                            <div class="branch-address">Đời <%= mx.getDoiXe() %> — <%= mx.getDungTich() %>cc</div>
                                        </label>
                                    <% } %>
                                </div>
                                <button type="submit" style="background: #10b981; color: white; padding: var(--spacing-sm) var(--spacing-md); border: none; border-radius: 6px; font-family: inherit; font-size: 12px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; text-decoration: none; transition: all 0.15s ease;">
                                    <iconify-icon icon="mdi:arrow-right" width="14" height="14"></iconify-icon>
                                    Tạo Gói Thuê
                                </button>
                            </form>
                        <% } %>
                    </div>

                <% } else { %>
                    <!-- Step 3: Create & Manage Packages -->
                    <div class="breadcrumb">
                        <a href="<%= ctx %>/doitac/quanlygoithue">
                            <iconify-icon icon="mdi:arrow-left" width="14" height="14"></iconify-icon>
                            Đổi Chi Nhánh
                        </a>
                        <span class="breadcrumb-sep">›</span>
                        <strong><%= esc(tenCN) %></strong>
                        <span class="breadcrumb-sep">›</span>
                        <a href="<%= ctx %>/doitac/quanlygoithue?maChiNhanh=<%= maChiNhanh %>">Đổi Mẫu Xe</a>
                        <span class="breadcrumb-sep">›</span>
                        <strong><%= esc(tenMX) %></strong>
                    </div>

                    <div class="panel-two-column">
                        <!-- Left Panel: Create Package -->
                        <div class="panel-content">
                            <div class="panel-title">
                                <div style="display: flex; align-items: center; gap: 6px;">
                                    <iconify-icon icon="mdi:plus-circle" width="16" height="16"></iconify-icon>
                                    Tạo Gói Thuê
                                </div>
                            </div>
                            <div class="panel-body">
                                <div class="summary-box">
                                    <div class="summary-item">
                                        <div class="summary-label">Chi Nhánh</div>
                                        <div class="summary-value"><%= esc(tenCN) %></div>
                                    </div>
                                    <div class="summary-item">
                                        <div class="summary-label">Mẫu Xe</div>
                                        <div class="summary-value"><%= esc(tenMX) %></div>
                                    </div>
                                </div>

                                <form method="post" action="<%= ctx %>/views/doitac/quanlygoithue.jsp">
                                    <input type="hidden" name="maChiNhanh" value="<%= maChiNhanh %>" />
                                    <input type="hidden" name="maMauXe" value="<%= maMauXe %>" />

                                    <div style="margin-bottom: var(--spacing-lg);">
                                        <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary); letter-spacing: 0.5px;">Tên Gói Thuê *</label>
                                        <input type="text" name="tenGoiThue" placeholder="VD: Gói ngày Honda Wave" maxlength="100" required style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;" />
                                    </div>

                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md); margin-bottom: var(--spacing-lg);">
                                        <div>
                                            <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary); letter-spacing: 0.5px;">Giá / Ngày (₫) *</label>
                                            <input type="number" name="giaNgay" placeholder="150000" min="1" required style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;" />
                                        </div>
                                        <div>
                                            <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary); letter-spacing: 0.5px;">Giá / Giờ (₫) *</label>
                                            <input type="number" name="giaGio" placeholder="25000" min="1" required style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;" />
                                        </div>
                                    </div>

                                    <div style="margin-bottom: var(--spacing-lg);">
                                        <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary); letter-spacing: 0.5px;">Phụ Thu (₫)</label>
                                        <input type="number" name="phuThu" value="0" min="0" style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;" />
                                        <div style="font-size: 11px; color: #6b7280; margin-top: 4px;">Phí phát sinh nếu có</div>
                                    </div>

                                    <div style="margin-bottom: var(--spacing-lg);">
                                        <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary); letter-spacing: 0.5px;">Phụ Kiện Đi Kèm</label>
                                        <textarea name="phuKien" placeholder="Mũ bảo hiểm, áo mưa, bơm xe..." style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease; resize: vertical; min-height: 80px;"></textarea>
                                    </div>

                                    <button type="submit" style="width: 100%; background: #10b981; color: white; padding: var(--spacing-md); border: none; border-radius: 6px; font-family: inherit; font-size: 13px; font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 6px; text-decoration: none; transition: all 0.15s ease;">
                                        <iconify-icon icon="mdi:plus" width="14" height="14"></iconify-icon>
                                        Tạo Gói Thuê
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Right Panel: Package List -->
                        <div class="panel-content">
                            <div class="panel-title">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <span>Danh Sách Gói Thuê</span>
                                </div>
                                <span class="count-badge"><%= danhSachGT != null ? danhSachGT.size() : 0 %> gói</span>
                            </div>
                            <div class="panel-body" style="padding: 0;">
                                <% if (danhSachGT == null || danhSachGT.isEmpty()) { %>
                                    <div class="no-data" style="padding: var(--spacing-3xl);">
                                        <iconify-icon icon="mdi:inbox-outline" width="48" height="48" style="display: block; margin: 0 auto var(--spacing-md); opacity: 0.4;"></iconify-icon>
                                        Chưa có gói thuê nào. Hãy tạo gói thuê đầu tiên!
                                    </div>
                                <% } else { %>
                                    <div style="overflow-x: auto;">
                                        <table style="width: 100%; border-collapse: collapse;">
                                            <thead>
                                                <tr style="background: #f9fafb;">
                                                    <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981; width: 40px;">#</th>
                                                    <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981;">Tên Gói</th>
                                                    <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981;">Giá/Ngày</th>
                                                    <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981;">Giá/Giờ</th>
                                                    <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981;">Phụ Thu</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% int stt = 1; for (GoiThue gt : danhSachGT) { %>
                                                    <tr class="table-row" style="border-bottom: 1px solid #e5e7eb;">
                                                        <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; color: #6b7280;"><span style="display: inline-block; padding: var(--spacing-xs) var(--spacing-md); background: #10b981; color: white; border-radius: 6px; font-size: 11px; font-weight: 700; letter-spacing: 0.3px;"><%= stt++ %></span></td>
                                                        <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 14px; color: var(--color-text-primary);"><strong><%= esc(gt.getTenGoiThue()) %></strong></td>
                                                        <td style="padding: var(--spacing-md) var(--spacing-lg);"><span class="price-highlight"><%= fmtMoney(gt.getGiaNgay()) %></span></td>
                                                        <td style="padding: var(--spacing-md) var(--spacing-lg);"><span class="price-highlight"><%= fmtMoney(gt.getGiaGio()) %></span></td>
                                                        <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; color: #6b7280;"><%= gt.getPhuThu() > 0 ? fmtMoney(gt.getPhuThu()) : "—" %></td>
                                                    </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </section>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>
</body>
<script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
</html>
