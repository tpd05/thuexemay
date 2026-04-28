<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
String ctxPath = request.getContextPath();
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");

if (username == null || role == null || !role.equals("KHACH_HANG")) {
    response.sendRedirect(ctxPath + "/views/403.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xe Đã Thuê - MOTOBOOK</title>
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
            <div class="app-container" style="display: flex; flex-direction: column; gap: var(--spacing-2xl); margin-bottom: var(--spacing-3xl);">
                
                <!-- Page Title -->
                <section style="padding: var(--spacing-lg) 0;">
                    <h1 style="font-size: var(--text-3xl); font-weight: 700; margin: 0 0 var(--spacing-sm) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                        <iconify-icon icon="mdi:check-circle" style="width: 32px; height: 32px; color: var(--color-primary);"></iconify-icon>
                        Xe Đã Thuê
                    </h1>
                    <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Danh sách những đơn thuê xe đã hoàn tất</p>
                </section>

                <!-- Navigation Tabs -->
                <div style="background: white; border: 1px solid var(--color-border-light); border-radius: 12px; padding: var(--spacing-md); display: flex; gap: var(--spacing-lg);">
                    <a href="${pageContext.request.contextPath}/khachhang/lichsuthuexe/xedathue" style="padding: var(--spacing-md) var(--spacing-lg); text-decoration: none; font-weight: 600; color: var(--color-primary); border-bottom: 3px solid var(--color-primary); cursor: pointer;">
                        <iconify-icon icon="mdi:check-all" style="vertical-align: middle; margin-right: var(--spacing-xs);"></iconify-icon>
                        Xe Đã Thuê
                    </a>
                    <a href="${pageContext.request.contextPath}/khachhang/lichsuthuexe/xedangthue" style="padding: var(--spacing-md) var(--spacing-lg); text-decoration: none; font-weight: 600; color: var(--color-text-secondary); cursor: pointer; transition: color 0.2s ease;" onmouseover="this.style.color='var(--color-primary)'" onmouseout="this.style.color='var(--color-text-secondary)'">
                        <iconify-icon icon="mdi:clock-outline" style="vertical-align: middle; margin-right: var(--spacing-xs);"></iconify-icon>
                        Đang Thuê & Sắp Tới
                    </a>
                </div>

                <!-- Rentals List -->
                <c:if test="${not empty donThueDanhSach}">
                    <section style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                        <c:forEach var="don" items="${donThueDanhSach}">
                            <div style="background: white; border: 1px solid var(--color-border-light); border-radius: 12px; padding: var(--spacing-lg); display: grid; grid-template-columns: auto 1fr auto; gap: var(--spacing-lg); align-items: center;">
                                
                                <!-- Order Icon -->
                                <div style="width: 60px; height: 60px; background: linear-gradient(135deg, var(--color-primary-lighter) 0%, rgba(16, 185, 129, 0.1) 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                    <iconify-icon icon="mdi:check-circle" style="width: 32px; height: 32px; color: var(--color-primary);"></iconify-icon>
                                </div>
                                
                                <!-- Order Details -->
                                <div style="display: flex; flex-direction: column; gap: var(--spacing-md);">
                                    <div>
                                        <p style="margin: 0; font-size: var(--text-sm); color: var(--color-text-secondary); font-weight: 600; text-transform: uppercase;">Mã Đơn Thuê</p>
                                        <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-lg); font-weight: 700; color: var(--color-primary);">
                                            #${don.maDonThue}
                                        </p>
                                    </div>
                                    
                                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--spacing-lg);">
                                        <!-- Date -->
                                        <div>
                                            <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">
                                                <iconify-icon icon="mdi:calendar" style="vertical-align: middle; margin-right: 4px;"></iconify-icon>
                                                Ngày Thuê
                                            </p>
                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 600;">
                                                <c:if test="${not empty don.ngayTao}">
                                                    <fmt:formatDate value="${don.ngayTao}" pattern="dd/MM/yyyy" />
                                                </c:if>
                                                <c:if test="${empty don.ngayTao}">
                                                    N/A
                                                </c:if>
                                            </p>
                                        </div>
                                        
                                        <!-- Quantity -->
                                        <div>
                                            <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">
                                                <iconify-icon icon="mdi:bike" style="vertical-align: middle; margin-right: 4px;"></iconify-icon>
                                                Số Xe
                                            </p>
                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 600;">
                                                ${don.soLuongXe} xe
                                            </p>
                                        </div>
                                        
                                        <!-- Total -->
                                        <div>
                                            <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">
                                                <iconify-icon icon="mdi:cash" style="vertical-align: middle; margin-right: 4px;"></iconify-icon>
                                                Tổng Tiền
                                            </p>
                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 700; color: var(--color-primary);">
                                                <fmt:formatNumber value="${don.tongTien}" type="currency" currencySymbol="₫" />
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <!-- Address -->
                                    <div style="padding: var(--spacing-md); background: var(--color-bg-secondary); border-radius: 8px; border-left: 3px solid var(--color-primary);">
                                        <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary); text-transform: uppercase;">Địa Chỉ Nhận Xe</p>
                                        <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); color: var(--color-text-primary); line-height: 1.5;">
                                            ${don.diaChiNhanXe}
                                        </p>
                                    </div>
                                </div>
                                
                                <!-- Actions -->
                                <div style="display: flex; flex-direction: column; gap: var(--spacing-sm); flex-shrink: 0;">
                                    <button onclick="viewOrderDetails('${don.maDonThue}')" disabled style="padding: var(--spacing-md) var(--spacing-lg); background: #ccc; color: #666; border: none; border-radius: 8px; cursor: not-allowed; font-weight: 600; font-size: var(--text-sm); transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: var(--spacing-xs); opacity: 0.6;" title="Tính năng đang phát triển">
                                        <iconify-icon icon="mdi:eye" style="width: 18px; height: 18px;"></iconify-icon>
                                        Chi Tiết
                                    </button>
                                    <button onclick="deleteOrder('${don.maDonThue}')" disabled style="padding: var(--spacing-md) var(--spacing-lg); background: #fee2e2; color: #999; border: 1px solid #ddd; border-radius: 8px; cursor: not-allowed; font-weight: 600; font-size: var(--text-sm); transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: var(--spacing-xs); opacity: 0.6;" title="Tính năng đang phát triển">
                                        <iconify-icon icon="mdi:trash" style="width: 18px; height: 18px;"></iconify-icon>
                                        Xóa
                                    </button>
                                    <button disabled style="padding: var(--spacing-md) var(--spacing-lg); background: #fecaca; color: #b91c1c; border: 1px solid #fca5a5; border-radius: 8px; cursor: not-allowed; font-weight: 600; font-size: var(--text-sm); transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: var(--spacing-xs); opacity: 0.6; position: relative;" title="Tính năng đang phát triển">
                                        <iconify-icon icon="mdi:star" style="width: 18px; height: 18px;"></iconify-icon>
                                        Đánh Giá
                                        <span style="position: absolute; top: -8px; right: -8px; background: #fbbf24; color: #78350f; padding: 2px 6px; border-radius: 4px; font-size: 10px; font-weight: 700; text-transform: uppercase;">Mới</span>
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </section>
                </c:if>

                <!-- Empty State -->
                <c:if test="${empty donThueDanhSach}">
                    <div style="background: linear-gradient(135deg, var(--color-bg-secondary) 0%, white 100%); border: 2px dashed var(--color-border); border-radius: 12px; padding: var(--spacing-2xl); text-align: center;">
                        <iconify-icon icon="mdi:folder-open" style="width: 64px; height: 64px; color: var(--color-text-secondary); margin-bottom: var(--spacing-lg); display: block;"></iconify-icon>
                        <h3 style="margin: 0 0 var(--spacing-sm) 0; font-size: var(--text-lg); color: var(--color-text-secondary);">Chưa Có Đơn Thuê Hoàn Tất</h3>
                        <p style="margin: 0 0 var(--spacing-lg) 0; color: var(--color-text-secondary); font-size: var(--text-sm);">Bạn chưa có đơn thuê nào hoàn tất. Hãy bắt đầu thuê xe ngay!</p>
                        <a href="${pageContext.request.contextPath}/khachhang/dashboard" style="display: inline-block; padding: var(--spacing-md) var(--spacing-lg); background: var(--color-primary); color: white; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: var(--text-sm); transition: all 0.2s ease;" onmouseover="this.style.opacity='0.9'" onmouseout="this.style.opacity='1'">
                            <iconify-icon icon="mdi:plus" style="vertical-align: middle; margin-right: 4px;"></iconify-icon>
                            Khám Phá Gói Thuê
                        </a>
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div style="background: #fee2e2; border: 2px solid var(--color-danger); border-radius: 12px; padding: var(--spacing-lg); color: var(--color-danger);">
                        <div style="display: flex; align-items: center; gap: var(--spacing-md);">
                            <iconify-icon icon="mdi:alert-circle" style="width: 24px; height: 24px; flex-shrink: 0;"></iconify-icon>
                            <div>
                                <p style="margin: 0; font-weight: 600;">Lỗi</p>
                                <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm);">${errorMessage}</p>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>

    <script src="${pageContext.request.contextPath}/js/ui-utils.js"></script>
    <script>
        const ctx = '${pageContext.request.contextPath}';

        function viewOrderDetails(maDonThue) {
            // Navigate to order details page
            if (maDonThue && maDonThue.trim() !== '') {
                window.location.href = ctx + '/khachhang/donchitiet?id=' + encodeURIComponent(maDonThue);
            } else {
                UI.toast('Mã đơn thuê không hợp lệ', 'error', 2000);
            }
        }

        function deleteOrder(maDonThue) {
            if (!maDonThue || maDonThue.trim() === '') {
                UI.toast('Mã đơn thuê không hợp lệ', 'error', 2000);
                return;
            }
            
            UI.confirm('Xóa Đơn Thuê', 'Bạn có chắc muốn xóa đơn thuê #' + maDonThue + '?',
                function() {
                    fetch(ctx + '/khachhang/xedathue?action=delete', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'maDonThue=' + encodeURIComponent(maDonThue)
                    })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            UI.toast('Đơn thuê đã được xóa', 'success', 2000);
                            setTimeout(() => {
                                window.location.reload();
                            }, 1000);
                        } else {
                            UI.toast('Lỗi: ' + data.message, 'error', 3000);
                        }
                    })
                    .catch(err => {
                        UI.toast('Lỗi kết nối: ' + err.message, 'error', 3000);
                    });
                }
            );
        }
    </script>
</body>
</html>
