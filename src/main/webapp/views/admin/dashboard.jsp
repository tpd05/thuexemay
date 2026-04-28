<%@ page contentType="text/html; charset=UTF-8" %>
<%
String ctxPath = request.getContextPath();
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");

if (username == null || role == null || !role.equals("ADMIN")) {
    response.sendRedirect(ctxPath + "/views/403.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ThueXeMay</title>
    <link href="${pageContext.request.contextPath}/dist/tailwind.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/globals.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/components.css" rel="stylesheet">
    <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
</head>
<body class="bg-color-bg-primary text-color-text-primary font-body">
    <div class="page-wrapper">
        <header class="page-header">
            <jsp:include page="/components/navbar.jsp" />
        </header>

        <main class="page-main">
            <div class="app-container" style="display: flex; flex-direction: column; gap: var(--spacing-2xl);">
                
                <!-- Admin Header -->
                <section class="card" style="background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); color: white; padding: var(--spacing-2xl);">
                    <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: var(--spacing-lg);">
                        <div>
                            <h1 style="font-size: var(--text-2xl); font-weight: 700; margin: 0 0 var(--spacing-xs) 0;">
                                <iconify-icon icon="mdi:shield-admin" style="width: 32px; height: 32px; vertical-align: middle; margin-right: 8px;"></iconify-icon>
                                Bảng Điều Khiển Admin
                            </h1>
                            <p style="margin: 0; opacity: 0.9; font-size: var(--text-md);">Quản lý toàn bộ hệ thống ThueXeMay</p>
                        </div>
                        <button onclick="confirmLogout()" class="btn" style="background-color: rgba(255,255,255,0.2); color: white; border: 2px solid white; padding: var(--spacing-md) var(--spacing-lg);">
                            <iconify-icon icon="mdi:logout" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                            Đăng Xuất
                        </button>
                    </div>
                </section>

                <!-- Quick Statistics -->
                <section>
                    <h2 style="font-size: var(--text-xl); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                        <iconify-icon icon="mdi:chart-line" style="width: 24px; height: 24px; color: #2563eb;"></iconify-icon>
                        Thống Kê Toàn Hệ Thống
                    </h2>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: var(--spacing-lg);">
                        <div class="card" style="padding: var(--spacing-lg); border-left: 4px solid #10b981;">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: var(--spacing-md);">
                                <h3 style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0; font-weight: 600;">
                                    <iconify-icon icon="mdi:account-multiple" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                    Khách Hàng
                                </h3>
                                <iconify-icon icon="mdi:chevron-right" style="width: 20px; height: 20px; color: #10b981;"></iconify-icon>
                            </div>
                            <p id="tongKhachHang" style="font-size: var(--text-2xl); font-weight: 700; color: #10b981; margin: 0;">0</p>
                        </div>

                        <div class="card" style="padding: var(--spacing-lg); border-left: 4px solid #f97316;">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: var(--spacing-md);">
                                <h3 style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0; font-weight: 600;">
                                    <iconify-icon icon="mdi:briefcase-multiple" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                    Đối Tác
                                </h3>
                                <iconify-icon icon="mdi:chevron-right" style="width: 20px; height: 20px; color: #f97316;"></iconify-icon>
                            </div>
                            <p id="tongDoiTac" style="font-size: var(--text-2xl); font-weight: 700; color: #f97316; margin: 0;">0</p>
                        </div>

                        <div class="card" style="padding: var(--spacing-lg); border-left: 4px solid #3b82f6;">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: var(--spacing-md);">
                                <h3 style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0; font-weight: 600;">
                                    <iconify-icon icon="mdi:receipt" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                    Đơn Hàng
                                </h3>
                                <iconify-icon icon="mdi:chevron-right" style="width: 20px; height: 20px; color: #3b82f6;"></iconify-icon>
                            </div>
                            <p id="tongDonHang" style="font-size: var(--text-2xl); font-weight: 700; color: #3b82f6; margin: 0;">0</p>
                        </div>

                        <div class="card" style="padding: var(--spacing-lg); border-left: 4px solid #06b6d4;">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: var(--spacing-md);">
                                <h3 style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0; font-weight: 600;">
                                    <iconify-icon icon="mdi:cash" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                    Doanh Thu Hôm Nay
                                </h3>
                                <iconify-icon icon="mdi:chevron-right" style="width: 20px; height: 20px; color: #06b6d4;"></iconify-icon>
                            </div>
                            <p id="doanhThuHomNay" style="font-size: var(--text-lg); font-weight: 700; color: #06b6d4; margin: 0;">0 VNĐ</p>
                        </div>
                    </div>
                </section>

                <!-- Management Sections -->
                <section>
                    <h2 style="font-size: var(--text-xl); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                        <iconify-icon icon="mdi:cog-multiple" style="width: 24px; height: 24px; color: #2563eb;"></iconify-icon>
                        Quản Lý Hệ Thống
                    </h2>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: var(--spacing-lg);">
                        
                        <!-- User Management -->
                        <a href="<%=ctxPath%>/admin/quanlynguoidung" class="card" style="padding: var(--spacing-lg); text-decoration: none; transition: all var(--transition-normal); cursor: pointer;"
                           onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-2xl)'"
                           onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)'">
                            <div style="display: flex; align-items: center; gap: var(--spacing-md); margin-bottom: var(--spacing-md);">
                                <div style="width: 48px; height: 48px; background-color: #dbeafe; border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center;">
                                    <iconify-icon icon="mdi:account-multiple" style="width: 24px; height: 24px; color: #2563eb;"></iconify-icon>
                                </div>
                                <div>
                                    <h3 style="font-weight: 700; margin: 0 0 4px 0; color: var(--color-text-primary);">Quản Lý Người Dùng</h3>
                                    <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Người dùng & tài khoản</p>
                                </div>
                            </div>
                            <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Quản lý, kích hoạt, vô hiệu hóa và xóa tài khoản người dùng</p>
                        </a>

                        <!-- Partner Management -->
                        <a href="<%=ctxPath%>/admin/quanlydoitac" class="card" style="padding: var(--spacing-lg); text-decoration: none; transition: all var(--transition-normal); cursor: pointer;"
                           onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-2xl)'"
                           onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)'">
                            <div style="display: flex; align-items: center; gap: var(--spacing-md); margin-bottom: var(--spacing-md);">
                                <div style="width: 48px; height: 48px; background-color: #fed7aa; border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center;">
                                    <iconify-icon icon="mdi:briefcase" style="width: 24px; height: 24px; color: #d97706;"></iconify-icon>
                                </div>
                                <div>
                                    <h3 style="font-weight: 700; margin: 0 0 4px 0; color: var(--color-text-primary);">Quản Lý Đối Tác</h3>
                                    <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Các nhà cung cấp</p>
                                </div>
                            </div>
                            <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Phê duyệt, xem thông tin và quản lý các đối tác trong hệ thống</p>
                        </a>

                        <!-- Reports -->
                        <div class="card" style="padding: var(--spacing-lg);">
                            <div style="display: flex; align-items: center; gap: var(--spacing-md); margin-bottom: var(--spacing-md);">
                                <div style="width: 48px; height: 48px; background-color: #e0e7ff; border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center;">
                                    <iconify-icon icon="mdi:file-chart" style="width: 24px; height: 24px; color: #6366f1;"></iconify-icon>
                                </div>
                                <div>
                                    <h3 style="font-weight: 700; margin: 0 0 4px 0; color: var(--color-text-primary);">Báo Cáo</h3>
                                    <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Phân tích & thống kê</p>
                                </div>
                            </div>
                            <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Xem báo cáo doanh thu, người dùng, đơn hàng và hiệu suất hệ thống</p>
                        </div>
                    </div>
                </section>

                <!-- Activity Log -->
                <section>
                    <h2 style="font-size: var(--text-xl); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                        <iconify-icon icon="mdi:history" style="width: 24px; height: 24px; color: #2563eb;"></iconify-icon>
                        Hoạt Động Gần Đây
                    </h2>
                    <div class="card" style="padding: var(--spacing-lg);">
                        <div style="display: flex; align-items: center; justify-content: center; gap: var(--spacing-md); color: var(--color-text-secondary); min-height: 100px;">
                            <iconify-icon icon="mdi:information" style="width: 20px; height: 20px;"></iconify-icon>
                            <p style="margin: 0;">Danh sách hoạt động sẽ được cập nhật từ hệ thống</p>
                        </div>
                    </div>
                </section>
            </div>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>

    <script src="${pageContext.request.contextPath}/js/ui-utils.js"></script>
    <script>
    function confirmLogout() {
        if (confirm('Bạn có muốn đăng xuất!')) {
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    }
    </script>
</body>
</html>
