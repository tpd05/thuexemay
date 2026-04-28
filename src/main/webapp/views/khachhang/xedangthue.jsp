<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    <title>Đang Thuê & Sắp Tới - MOTOBOOK</title>
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
                        <iconify-icon icon="mdi:clock-outline" style="width: 32px; height: 32px; color: var(--color-primary);"></iconify-icon>
                        Đang Thuê & Sắp Tới
                    </h1>
                    <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Quản lý những đơn thuê xe đang diễn ra và sắp tới</p>
                </section>

                <!-- Navigation Tabs -->
                <div style="background: white; border: 1px solid var(--color-border-light); border-radius: 12px; padding: var(--spacing-md); display: flex; gap: var(--spacing-lg);">
                    <a href="${pageContext.request.contextPath}/khachhang/lichsuthuexe/xedathue" style="padding: var(--spacing-md) var(--spacing-lg); text-decoration: none; font-weight: 600; color: var(--color-text-secondary); cursor: pointer; transition: color 0.2s ease;" onmouseover="this.style.color='var(--color-primary)'" onmouseout="this.style.color='var(--color-text-secondary)'">
                        <iconify-icon icon="mdi:check-all" style="vertical-align: middle; margin-right: var(--spacing-xs);"></iconify-icon>
                        Xe Đã Thuê
                    </a>
                    <a href="${pageContext.request.contextPath}/khachhang/lichsuthuexe/xedangthue" style="padding: var(--spacing-md) var(--spacing-lg); text-decoration: none; font-weight: 600; color: var(--color-primary); border-bottom: 3px solid var(--color-primary); cursor: pointer;">
                        <iconify-icon icon="mdi:clock-outline" style="vertical-align: middle; margin-right: var(--spacing-xs);"></iconify-icon>
                        Đang Thuê & Sắp Tới
                    </a>
                </div>

                <!-- Modal Selection -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-lg);">
                    <!-- Modal 1: Đang Thuê -->
                    <button onclick="switchModal('dang_thue')" id="btn-dang-thue" style="padding: var(--spacing-lg); background: linear-gradient(135deg, var(--color-primary) 0%, #0d9488 100%); color: white; border: none; border-radius: 12px; cursor: pointer; transition: all 0.3s ease; display: flex; flex-direction: column; gap: var(--spacing-md); align-items: flex-start;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 12px 24px rgba(0,0,0,0.15)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 1px 3px rgba(0,0,0,0.1)'">
                        <iconify-icon icon="mdi:motion-play" style="width: 32px; height: 32px;"></iconify-icon>
                        <div style="text-align: left;">
                            <p style="margin: 0; font-size: var(--text-xl); font-weight: 700;">Đang Thuê</p>
                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); opacity: 0.9;">
                                <span id="count-dang-thue">${fn:length(donDangThue)}</span> đơn
                            </p>
                        </div>
                    </button>

                    <!-- Modal 2: Sắp Tới -->
                    <button onclick="switchModal('sap_toi')" id="btn-sap-toi" style="padding: var(--spacing-lg); background: white; color: var(--color-text-primary); border: 2px solid var(--color-border-light); border-radius: 12px; cursor: pointer; transition: all 0.3s ease; display: flex; flex-direction: column; gap: var(--spacing-md); align-items: flex-start;" onmouseover="this.style.borderColor='var(--color-primary)'; this.style.boxShadow='0 12px 24px rgba(16, 185, 129, 0.1)'" onmouseout="this.style.borderColor='var(--color-border-light)'; this.style.boxShadow='0 1px 3px rgba(0,0,0,0.1)'">
                        <iconify-icon icon="mdi:timer-outline" style="width: 32px; height: 32px; color: var(--color-primary);"></iconify-icon>
                        <div style="text-align: left;">
                            <p style="margin: 0; font-size: var(--text-xl); font-weight: 700;">Sắp Tới</p>
                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); color: var(--color-text-secondary);">
                                <span id="count-sap-toi">${fn:length(donSapToi)}</span> đơn
                            </p>
                        </div>
                    </button>
                </div>

                <!-- Modal 1: Đang Thuê Content -->
                <section id="modal-dang-thue" style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                    <h2 style="font-size: var(--text-2xl); font-weight: 700; margin: 0; display: flex; align-items: center; gap: var(--spacing-md); color: var(--color-primary);">
                        <iconify-icon icon="mdi:motion-play" style="width: 28px; height: 28px;"></iconify-icon>
                        Những Đơn Thuê Đang Diễn Ra
                    </h2>

                    <c:if test="${not empty donDangThue}">
                        <div style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                            <c:forEach var="don" items="${donDangThue}">
                                <div style="background: white; border: 2px solid #fbbf24; border-radius: 12px; padding: var(--spacing-lg); display: grid; grid-template-columns: auto 1fr auto; gap: var(--spacing-lg); align-items: center;">
                                    
                                    <!-- Status Icon -->
                                    <div style="width: 60px; height: 60px; background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                        <iconify-icon icon="mdi:motion-play" style="width: 32px; height: 32px; color: #f59e0b;"></iconify-icon>
                                    </div>
                                    
                                    <!-- Details -->
                                    <div style="display: flex; flex-direction: column; gap: var(--spacing-md);">
                                        <div>
                                            <p style="margin: 0; font-size: var(--text-sm); color: var(--color-text-secondary); font-weight: 600; text-transform: uppercase;">Mã Đơn</p>
                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-lg); font-weight: 700; color: #f59e0b;">
                                                #${don.maDonThue}
                                            </p>
                                        </div>
                                        
                                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--spacing-lg);">
                                            <div>
                                                <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Bắt Đầu</p>
                                                <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 600;">
                                                    <c:if test="${not empty don.ngayBatDau}">
                                                        <fmt:formatDate value="${don.ngayBatDau}" pattern="dd/MM HH:mm" />
                                                    </c:if>
                                                </p>
                                            </div>
                                            <div>
                                                <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Kết Thúc</p>
                                                <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 600;">
                                                    <c:if test="${not empty don.ngayKetThuc}">
                                                        <fmt:formatDate value="${don.ngayKetThuc}" pattern="dd/MM HH:mm" />
                                                    </c:if>
                                                </p>
                                            </div>
                                            <div>
                                                <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Số Xe</p>
                                                <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 600;">
                                                    ${don.soLuongXe} xe
                                                </p>
                                            </div>
                                        </div>
                                        
                                        <div style="padding: var(--spacing-md); background: var(--color-bg-secondary); border-radius: 8px; border-left: 3px solid #f59e0b;">
                                            <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary); text-transform: uppercase;">Địa Chỉ</p>
                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); color: var(--color-text-primary); line-height: 1.5;">
                                                ${don.diaChiNhanXe}
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <!-- Action -->
                                    <div style="display: flex; flex-direction: column; gap: var(--spacing-sm);">
                                        <button onclick="viewOrderDetails('${don.maDonThue}')" disabled style="padding: var(--spacing-md) var(--spacing-lg); background: #ccc; color: #666; border: none; border-radius: 8px; cursor: not-allowed; font-weight: 600; font-size: var(--text-sm); transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: var(--spacing-xs); flex-shrink: 0; opacity: 0.6;" title="Tính năng đang phát triển">
                                            <iconify-icon icon="mdi:eye" style="width: 18px; height: 18px;"></iconify-icon>
                                            Chi Tiết
                                        </button>
                                        <button disabled style="padding: var(--spacing-md) var(--spacing-lg); background: #fee2e2; color: #999; border: 1px solid #ddd; border-radius: 8px; cursor: not-allowed; font-weight: 600; font-size: var(--text-sm); transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: var(--spacing-xs); flex-shrink: 0; opacity: 0.6;" title="Tính năng đang phát triển">
                                            <iconify-icon icon="mdi:close" style="width: 18px; height: 18px;"></iconify-icon>
                                            Hủy Đơn
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <c:if test="${empty donDangThue}">
                        <div style="background: linear-gradient(135deg, var(--color-bg-secondary) 0%, white 100%); border: 2px dashed var(--color-border); border-radius: 12px; padding: var(--spacing-2xl); text-align: center;">
                            <iconify-icon icon="mdi:folder-open" style="width: 64px; height: 64px; color: var(--color-text-secondary); margin-bottom: var(--spacing-lg); display: block;"></iconify-icon>
                            <p style="margin: 0 0 var(--spacing-lg) 0; color: var(--color-text-secondary); font-size: var(--text-sm);">Không có đơn thuê nào đang diễn ra</p>
                        </div>
                    </c:if>
                </section>

                <!-- Modal 2: Sắp Tới Content -->
                <section id="modal-sap-toi" style="display: none; flex-direction: column; gap: var(--spacing-lg);">
                    <h2 style="font-size: var(--text-2xl); font-weight: 700; margin: 0; display: flex; align-items: center; gap: var(--spacing-md); color: var(--color-primary);">
                        <iconify-icon icon="mdi:timer-outline" style="width: 28px; height: 28px;"></iconify-icon>
                        Những Đơn Thuê Sắp Tới
                    </h2>

                    <c:if test="${not empty donSapToi}">
                        <div style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                            <c:forEach var="don" items="${donSapToi}">
                                <div style="background: white; border: 2px solid #93c5fd; border-radius: 12px; padding: var(--spacing-lg); display: grid; grid-template-columns: auto 1fr auto; gap: var(--spacing-lg); align-items: center;">
                                    
                                    <!-- Status Icon -->
                                    <div style="width: 60px; height: 60px; background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                        <iconify-icon icon="mdi:timer-outline" style="width: 32px; height: 32px; color: #3b82f6;"></iconify-icon>
                                    </div>
                                    
                                    <!-- Details -->
                                    <div style="display: flex; flex-direction: column; gap: var(--spacing-md);">
                                        <div>
                                            <p style="margin: 0; font-size: var(--text-sm); color: var(--color-text-secondary); font-weight: 600; text-transform: uppercase;">Mã Đơn</p>
                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-lg); font-weight: 700; color: #3b82f6;">
                                                #${don.maDonThue}
                                            </p>
                                        </div>
                                        
                                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--spacing-lg);">
                                            <div>
                                                <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Bắt Đầu</p>
                                                <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 600;">
                                                    <c:if test="${not empty don.ngayBatDau}">
                                                        <fmt:formatDate value="${don.ngayBatDau}" pattern="dd/MM HH:mm" />
                                                    </c:if>
                                                </p>
                                            </div>
                                            <div>
                                                <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Kết Thúc</p>
                                                <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 600;">
                                                    <c:if test="${not empty don.ngayKetThuc}">
                                                        <fmt:formatDate value="${don.ngayKetThuc}" pattern="dd/MM HH:mm" />
                                                    </c:if>
                                                </p>
                                            </div>
                                            <div>
                                                <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Tổng Tiền</p>
                                                <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 700; color: var(--color-primary);">
                                                    <fmt:formatNumber value="${don.tongTien}" type="currency" currencySymbol="₫" />
                                                </p>
                                            </div>
                                        </div>
                                        
                                        <div style="padding: var(--spacing-md); background: var(--color-bg-secondary); border-radius: 8px; border-left: 3px solid #3b82f6;">
                                            <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary); text-transform: uppercase;">Địa Chỉ Nhận Xe</p>
                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); color: var(--color-text-primary); line-height: 1.5;">
                                                ${don.diaChiNhanXe}
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <!-- Action -->
                                    <div style="display: flex; flex-direction: column; gap: var(--spacing-sm);">
                                        <button onclick="viewOrderDetails('${don.maDonThue}')" disabled style="padding: var(--spacing-md) var(--spacing-lg); background: #ccc; color: #666; border: none; border-radius: 8px; cursor: not-allowed; font-weight: 600; font-size: var(--text-sm); transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: var(--spacing-xs); flex-shrink: 0; opacity: 0.6;" title="Tính năng đang phát triển">
                                            <iconify-icon icon="mdi:eye" style="width: 18px; height: 18px;"></iconify-icon>
                                            Chi Tiết
                                        </button>
                                        <button disabled style="padding: var(--spacing-md) var(--spacing-lg); background: #fee2e2; color: #999; border: 1px solid #ddd; border-radius: 8px; cursor: not-allowed; font-weight: 600; font-size: var(--text-sm); transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: var(--spacing-xs); flex-shrink: 0; opacity: 0.6;" title="Tính năng đang phát triển">
                                            <iconify-icon icon="mdi:close" style="width: 18px; height: 18px;"></iconify-icon>
                                            Hủy Đơn
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <c:if test="${empty donSapToi}">
                        <div style="background: linear-gradient(135deg, var(--color-bg-secondary) 0%, white 100%); border: 2px dashed var(--color-border); border-radius: 12px; padding: var(--spacing-2xl); text-align: center;">
                            <iconify-icon icon="mdi:folder-open" style="width: 64px; height: 64px; color: var(--color-text-secondary); margin-bottom: var(--spacing-lg); display: block;"></iconify-icon>
                            <p style="margin: 0 0 var(--spacing-lg) 0; color: var(--color-text-secondary); font-size: var(--text-sm);">Không có đơn thuê sắp tới</p>
                        </div>
                    </c:if>
                </section>

                <c:if test="${not empty error}">
                    <div style="background: #fee2e2; border: 2px solid var(--color-danger); border-radius: 12px; padding: var(--spacing-lg); color: var(--color-danger);">
                        <div style="display: flex; align-items: center; gap: var(--spacing-md);">
                            <iconify-icon icon="mdi:alert-circle" style="width: 24px; height: 24px; flex-shrink: 0;"></iconify-icon>
                            <div>
                                <p style="margin: 0; font-weight: 600;">Lỗi</p>
                                <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm);">${error}</p>
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

        function switchModal(modalType) {
            const dangThueSection = document.getElementById('modal-dang-thue');
            const sapToiSection = document.getElementById('modal-sap-toi');
            const btnDangThue = document.getElementById('btn-dang-thue');
            const btnSapToi = document.getElementById('btn-sap-toi');

            if (modalType === 'dang_thue') {
                dangThueSection.style.display = 'flex';
                sapToiSection.style.display = 'none';
                btnDangThue.style.background = 'linear-gradient(135deg, var(--color-primary) 0%, #0d9488 100%)';
                btnDangThue.style.color = 'white';
                btnDangThue.style.borderColor = 'transparent';
                btnSapToi.style.background = 'white';
                btnSapToi.style.color = 'var(--color-text-primary)';
                btnSapToi.style.borderColor = 'var(--color-border-light)';
            } else {
                dangThueSection.style.display = 'none';
                sapToiSection.style.display = 'flex';
                btnDangThue.style.background = 'white';
                btnDangThue.style.color = 'var(--color-text-primary)';
                btnDangThue.style.borderColor = 'var(--color-border-light)';
                btnSapToi.style.background = 'linear-gradient(135deg, var(--color-primary) 0%, #0d9488 100%)';
                btnSapToi.style.color = 'white';
                btnSapToi.style.borderColor = 'transparent';
            }
        }

        function viewOrderDetails(maDonThue) {
            // Navigate to order details page
            if (maDonThue && maDonThue.trim() !== '') {
                window.location.href = ctx + '/khachhang/donchitiet?id=' + encodeURIComponent(maDonThue);
            } else {
                UI.toast('Mã đơn thuê không hợp lệ', 'error', 2000);
            }
        }
    </script>
</body>
</html>
