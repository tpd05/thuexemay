<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>Thanh Toán - MOTOBOOK</title>
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
                        <iconify-icon icon="mdi:credit-card" style="width: 32px; height: 32px; color: var(--color-primary);"></iconify-icon>
                        Thanh Toán
                    </h1>
                    <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Hoàn tất thanh toán đơn thuê xe của bạn</p>
                </section>

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

                <c:if test="${not empty donThueAo}">
                    <!-- Two Column Layout -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-2xl); align-items: flex-start;">
                        
                        <!-- LEFT: Order Details -->
                        <section style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                            
                            <!-- Rental Items Card -->
                            <div style="background: white; border: 1px solid var(--color-border-light); border-radius: 12px; padding: var(--spacing-lg); display: flex; flex-direction: column; gap: var(--spacing-lg);">
                                <h2 style="font-size: var(--text-lg); font-weight: 700; margin: 0; display: flex; align-items: center; gap: var(--spacing-md);">
                                    <iconify-icon icon="mdi:list-box" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                                    Chi Tiết Đơn Thuê
                                </h2>

                                <div style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                                    <c:forEach var="ct" items="${donThueAo.dsChiTiet}">
                                        <!-- Rental Item Container -->
                                        <div style="padding: var(--spacing-lg); background: white; border: 1px solid var(--color-border-light); border-radius: 12px; overflow: hidden;">
                                            
                                            <!-- Item Header: Package Name -->
                                            <div style="display: flex; align-items: center; gap: var(--spacing-md); margin-bottom: var(--spacing-lg); padding-bottom: var(--spacing-lg); border-bottom: 1px solid var(--color-border-light);">
                                                <div style="width: 8px; height: 32px; background: var(--color-primary); border-radius: 4px;"></div>
                                                <div>
                                                    <p style="margin: 0; font-size: var(--text-sm); color: var(--color-text-secondary);">Gói Thuê</p>
                                                    <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-lg); font-weight: 700; color: var(--color-primary);">
                                                        ${ct.tenGoiThue}
                                                    </p>
                                                </div>
                                            </div>

                                            <!-- Two Column Layout: Vehicle Image + Vehicle Details -->
                                            <div style="display: grid; grid-template-columns: 200px 1fr; gap: var(--spacing-lg); margin-bottom: var(--spacing-lg);">
                                                
                                                <!-- Vehicle Image -->
                                                <div style="border: 1px solid var(--color-border-light); border-radius: 12px; overflow: hidden; background: var(--color-bg-secondary); display: flex; align-items: center; justify-content: center; min-height: 200px;">
                                                    <c:choose>
                                                        <c:when test="${not empty ct.urlHinhAnh}">
                                                            <img src="${pageContext.request.contextPath}${ct.urlHinhAnh}" alt="${ct.hangXe} ${ct.dongXe}" style="width: 100%; height: 100%; object-fit: cover;" onerror="handleImageError(this)">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div style="text-align: center; padding: var(--spacing-lg);">
                                                                <iconify-icon icon="mdi:motorcycle" style="width: 64px; height: 64px; color: var(--color-text-secondary);"></iconify-icon>
                                                                <p style="margin: var(--spacing-md) 0 0 0; color: var(--color-text-secondary); font-size: var(--text-sm);">Chưa có hình ảnh</p>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Vehicle Details -->
                                                <div style="display: flex; flex-direction: column; gap: var(--spacing-md);">
                                                    
                                                    <!-- Vehicle Model -->
                                                    <div style="padding: var(--spacing-md); background: var(--color-bg-secondary); border-radius: 8px;">
                                                        <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary); text-transform: uppercase; font-weight: 600;">Mẫu Xe</p>
                                                        <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-lg); font-weight: 700; color: var(--color-primary);">
                                                            ${ct.hangXe} ${ct.dongXe}
                                                        </p>
                                                    </div>

                                                    <!-- Plate Number -->
                                                    <div style="padding: var(--spacing-md); background: var(--color-bg-secondary); border-radius: 8px; border-left: 4px solid #e8d000;">
                                                        <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">
                                                            <iconify-icon icon="mdi:license-plate" style="width: 16px; height: 16px; vertical-align: middle;"></iconify-icon>
                                                            Biển Số Xe
                                                        </p>
                                                        <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-base); font-weight: 700; font-family: monospace; letter-spacing: 2px; color: #333;">
                                                            ${ct.bienSoXe}
                                                        </p>
                                                    </div>

                                                    <!-- Technical Details Row -->
                                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md);">
                                                        <div style="padding: var(--spacing-md); background: var(--color-bg-secondary); border-radius: 8px;">
                                                            <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Số Khung</p>
                                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 700; font-family: monospace; color: var(--color-text-primary);">
                                                                ${ct.soKhung}
                                                            </p>
                                                        </div>
                                                        <div style="padding: var(--spacing-md); background: var(--color-bg-secondary); border-radius: 8px;">
                                                            <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Số Máy</p>
                                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); font-weight: 700; font-family: monospace; color: var(--color-text-primary);">
                                                                ${ct.soMay}
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Rental Timeline Section -->
                                            <div style="background: linear-gradient(135deg, rgba(16, 185, 129, 0.05) 0%, transparent 100%); border: 1px solid var(--color-border-light); border-radius: 8px; padding: var(--spacing-md); margin-bottom: var(--spacing-lg);">
                                                <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary); text-transform: uppercase; font-weight: 600; margin-bottom: var(--spacing-md);">
                                                    <iconify-icon icon="mdi:calendar-clock" style="width: 16px; height: 16px; vertical-align: middle;"></iconify-icon>
                                                    Thời Gian Thuê
                                                </p>
                                                
                                                <div style="display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; gap: var(--spacing-lg);">
                                                    <!-- Ngày Bắt Đầu -->
                                                    <div style="text-align: center;">
                                                        <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Ngày Nhận Xe</p>
                                                        <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-base); font-weight: 700; color: var(--color-primary);">
                                                            <c:if test="${not empty ct.thoiGianBatDauDate}">
                                                                <fmt:formatDate value="${ct.thoiGianBatDauDate}" pattern="dd/MM/yyyy HH:mm" />
                                                            </c:if>
                                                            <c:if test="${empty ct.thoiGianBatDauDate}">
                                                                Không có dữ liệu
                                                            </c:if>
                                                        </p>
                                                    </div>
                                                    
                                                    <!-- Arrow Icon -->
                                                    <div style="color: var(--color-text-secondary);">
                                                        <iconify-icon icon="mdi:arrow-right" style="width: 24px; height: 24px;"></iconify-icon>
                                                    </div>
                                                    
                                                    <!-- Ngày Kết Thúc -->
                                                    <div style="text-align: center;">
                                                        <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Ngày Trả Xe</p>
                                                        <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-base); font-weight: 700; color: #dc2626;">
                                                            <c:if test="${not empty ct.thoiGianKetThucDate}">
                                                                <fmt:formatDate value="${ct.thoiGianKetThucDate}" pattern="dd/MM/yyyy HH:mm" />
                                                            </c:if>
                                                            <c:if test="${empty ct.thoiGianKetThucDate}">
                                                                Không có dữ liệu
                                                            </c:if>
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Price Section -->
                                            <div style="padding: var(--spacing-md); background: linear-gradient(135deg, var(--color-primary-lighter) 0%, rgba(16, 185, 129, 0.05) 100%); border-radius: 8px; display: flex; justify-content: space-between; align-items: center; border-left: 4px solid var(--color-primary);">
                                                <span style="font-weight: 600; color: var(--color-text-secondary);">Giá Tiền:</span>
                                                <span style="font-size: var(--text-lg); font-weight: 700; color: var(--color-primary);">
                                                    <c:if test="${not empty ct.donGia}">
                                                        <fmt:formatNumber value="${ct.donGia}" type="currency" currencySymbol="₫" />
                                                    </c:if>
                                                    <c:if test="${empty ct.donGia}">
                                                        0 ₫
                                                    </c:if>
                                                </span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Delivery Address & Branch Info Card -->
                            <div style="background: white; border: 1px solid var(--color-border-light); border-radius: 12px; padding: var(--spacing-lg);">
                                <h3 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                                    <iconify-icon icon="mdi:map-marker" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                                    Địa Chỉ Nhận Xe
                                </h3>
                                
                                <div style="display: flex; flex-direction: column; gap: var(--spacing-md);">
                                    <!-- Branch Name (if available) -->
                                    <c:if test="${not empty donThueAo.dsChiTiet[0].tenChiNhanh}">
                                        <div style="padding: var(--spacing-md); background: var(--color-bg-secondary); border-radius: 8px; border-left: 4px solid var(--color-primary);">
                                            <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary); text-transform: uppercase;">Chi Nhánh</p>
                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-base); font-weight: 700; color: var(--color-primary);">
                                                ${donThueAo.dsChiTiet[0].tenChiNhanh}
                                            </p>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Address -->
                                    <div style="padding: var(--spacing-md); background: var(--color-bg-secondary); border-radius: 8px;">
                                        <p style="margin: 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Địa Chỉ Chi Tiết</p>
                                        <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); color: var(--color-text-primary); line-height: 1.6;">
                                            ${donThueAo.diaChiNhanXe}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- RIGHT: Payment Section -->
                        <section style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                            
                            <!-- Total Amount Card -->
                            <div style="background: linear-gradient(135deg, var(--color-primary-lighter) 0%, white 100%); border: 1px solid var(--color-border-light); border-radius: 12px; padding: var(--spacing-lg);">
                                <h3 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                                    <iconify-icon icon="mdi:cash" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                                    Thành Tiền
                                </h3>

                                <div style="padding: var(--spacing-lg); background: white; border-radius: 8px; margin-bottom: var(--spacing-lg); border-left: 4px solid var(--color-primary);">
                                    <p style="margin: 0 0 var(--spacing-sm) 0; font-size: var(--text-sm); color: var(--color-text-secondary);">Tổng cộng:</p>
                                    <p style="margin: 0; font-size: var(--text-3xl); font-weight: 700; color: var(--color-primary);">
                                        <c:if test="${not empty soTien}">
                                            <fmt:formatNumber value="${soTien}" type="currency" currencySymbol="₫" />
                                        </c:if>
                                        <c:if test="${empty soTien}">
                                            0 ₫
                                        </c:if>
                                    </p>
                                </div>

                                <!-- Payment Method Selection -->
                                <div id="paymentFormSection" style="display: flex; flex-direction: column; gap: var(--spacing-md);">
                                    <h4 style="font-size: var(--text-sm); font-weight: 600; margin: 0; text-transform: uppercase; color: var(--color-text-secondary);">Phương Thức Thanh Toán</h4>
                                    
                                    <label style="display: flex; align-items: center; gap: var(--spacing-md); padding: var(--spacing-md); border: 2px solid var(--color-border); border-radius: 8px; cursor: pointer; transition: all 0.2s ease;" 
                                           onmouseover="this.style.borderColor='var(--color-primary)'; this.style.backgroundColor='rgba(16, 185, 129, 0.05)'" 
                                           onmouseout="this.style.borderColor='var(--color-border)'; this.style.backgroundColor='white'">
                                        <input type="radio" name="phuongThuc" value="EWALLET" checked style="width: 18px; height: 18px; cursor: pointer;">
                                        <div style="flex: 1;">
                                            <p style="margin: 0; font-weight: 600; color: var(--color-text-primary);">Ví Điện Tử</p>
                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Thanh toán qua ứng dụng ví điện tử</p>
                                        </div>
                                        <iconify-icon icon="mdi:wallet" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                                    </label>

                                    <label style="display: flex; align-items: center; gap: var(--spacing-md); padding: var(--spacing-md); border: 2px solid var(--color-border); border-radius: 8px; cursor: pointer; transition: all 0.2s ease;" 
                                           onmouseover="this.style.borderColor='var(--color-primary)'; this.style.backgroundColor='rgba(16, 185, 129, 0.05)'" 
                                           onmouseout="this.style.borderColor='var(--color-border)'; this.style.backgroundColor='white'">
                                        <input type="radio" name="phuongThuc" value="CARD" style="width: 18px; height: 18px; cursor: pointer;">
                                        <div style="flex: 1;">
                                            <p style="margin: 0; font-weight: 600; color: var(--color-text-primary);">Thẻ Thanh Toán</p>
                                            <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-xs); color: var(--color-text-secondary);">Thẻ tín dụng hoặc thẻ ghi nợ</p>
                                        </div>
                                        <iconify-icon icon="mdi:credit-card" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                                    </label>

                                    <button onclick="taoQR()" style="padding: var(--spacing-md); font-size: var(--text-base); font-weight: 600; background: var(--color-primary); color: white; border: none; border-radius: 8px; cursor: pointer; transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: var(--spacing-sm);" 
                                            onmouseover="this.style.opacity='0.9'" 
                                            onmouseout="this.style.opacity='1'">
                                        <iconify-icon icon="mdi:check-circle" style="width: 18px; height: 18px;"></iconify-icon>
                                        Xác Nhận Thanh Toán
                                    </button>
                                </div>

                                <!-- QR Code Display Section (hidden by default) -->
                                <div id="qrCodeSection" style="display: none; flex-direction: column; gap: var(--spacing-lg); text-align: center;">
                                    <div style="padding: var(--spacing-lg); background: white; border-radius: 8px; border: 2px dashed var(--color-primary);">
                                        <h4 style="font-size: var(--text-sm); font-weight: 600; margin: 0 0 var(--spacing-md) 0; color: var(--color-text-secondary);">MÃ QR THANH TOÁN</h4>
                                        <p style="font-size: var(--text-xs); color: var(--color-text-secondary); margin: 0 0 var(--spacing-md) 0;">Quét mã QR bằng điện thoại để thanh toán</p>
                                        <div id="qrcode" style="display: inline-block; margin: 0 auto;"></div>
                                    </div>

                                    <div style="padding: var(--spacing-md); background: var(--color-bg-secondary); border-radius: 8px;">
                                        <p style="font-size: var(--text-xs); color: var(--color-text-secondary); margin: 0 0 var(--spacing-sm) 0; font-weight: 600; text-transform: uppercase;">Hoặc Truy Cập Liên Kết</p>
                                        <input type="text" id="paymentUrl" readonly style="width: 100%; padding: var(--spacing-sm); border: 1px solid var(--color-border); border-radius: 6px; font-size: var(--text-xs); font-family: monospace; margin-bottom: var(--spacing-sm);" />
                                        <button onclick="copyToClipboard()" style="width: 100%; padding: var(--spacing-sm); background: var(--color-primary); color: white; border: none; border-radius: 6px; cursor: pointer; font-size: var(--text-sm); font-weight: 600; transition: all 0.2s ease;" 
                                                onmouseover="this.style.opacity='0.9'" 
                                                onmouseout="this.style.opacity='1'">
                                            📋 Sao Chép Liên Kết
                                        </button>
                                    </div>

                                    <button onclick="goBackToPaymentForm()" style="padding: var(--spacing-md); background: var(--color-border); color: var(--color-text-primary); border: none; border-radius: 8px; cursor: pointer; font-size: var(--text-sm); font-weight: 600; transition: all 0.2s ease;" 
                                            onmouseover="this.style.background='var(--color-border-light)'" 
                                            onmouseout="this.style.background='var(--color-border)'">
                                        ← Quay Lại
                                    </button>
                                </div>
                            </div>

                            <!-- Back to Cart Button -->
                            <a href="${pageContext.request.contextPath}/khachhang/giohang" style="padding: var(--spacing-md); text-align: center; text-decoration: none; background: white; color: var(--color-text-primary); border: 1px solid var(--color-border-light); border-radius: 8px; cursor: pointer; font-size: var(--text-sm); font-weight: 600; transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: var(--spacing-sm);" 
                                onmouseover="this.style.background='var(--color-bg-secondary)'" 
                                onmouseout="this.style.background='white'">
                                <iconify-icon icon="mdi:arrow-left" style="width: 18px; height: 18px;"></iconify-icon>
                                Quay Lại Giỏ Hàng
                            </a>
                        </section>
                    </div>
                </c:if>

                <c:if test="${empty donThueAo}">
                    <div style="background: #fff3cd; border: 2px solid #ff9800; border-radius: 12px; padding: var(--spacing-lg);">
                        <div style="display: flex; align-items: center; gap: var(--spacing-md);">
                            <iconify-icon icon="mdi:information" style="width: 24px; height: 24px; color: #ff9800; flex-shrink: 0;"></iconify-icon>
                            <div>
                                <p style="margin: 0; font-weight: 600; color: #856404;">Thông báo</p>
                                <p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm); color: #856404;">Không tìm thấy thông tin đơn thuê. <a href="${pageContext.request.contextPath}/khachhang/giohang" style="color: #ff6d00; text-decoration: none; font-weight: 600;">Quay lại giỏ hàng</a></p>
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

    <!-- QR Code Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/ui-utils.js"></script>

    <script>

let currentMaThanhToan = null;
let statusPollingInterval = null;
const ctx = '${pageContext.request.contextPath}';

function taoQR() {
    const phuongThuc = document.querySelector('input[name="phuongThuc"]:checked').value;
    const button = event.target;

    // Disable button while processing
    button.disabled = true;
    button.textContent = 'Đang xử lý...';

    fetch(ctx + '/khachhang/thanhtoan?action=taoQR', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'phuongThuc=' + phuongThuc
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            // Store maThanhToan for polling
            currentMaThanhToan = data.maThanhToan;

            // Display QR code instead of redirecting
            displayQRCode(data.mockPageUrl);

            // Start polling for payment completion
            startPaymentStatusPolling();

            button.disabled = false;
            button.innerHTML = '<iconify-icon icon="mdi:check-circle" style="width: 18px; height: 18px;"></iconify-icon> Xác Nhận Thanh Toán';
        } else {
            if (window.UI && window.UI.toast) {
                UI.toast('Lỗi: ' + data.message, 'error', 3000);
            } else {
                alert('Lỗi: ' + data.message);
            }
            button.disabled = false;
            button.innerHTML = '<iconify-icon icon="mdi:check-circle" style="width: 18px; height: 18px;"></iconify-icon> Xác Nhận Thanh Toán';
        }
    })
    .catch(err => {
        console.error('Error:', err);
        if (window.UI && window.UI.toast) {
            UI.toast('Lỗi tạo mã QR', 'error', 3000);
        } else {
            alert('Lỗi tạo mã QR');
        }
        button.disabled = false;
        button.innerHTML = '<iconify-icon icon="mdi:check-circle" style="width: 18px; height: 18px;"></iconify-icon> Xác Nhận Thanh Toán';
    });
}

function displayQRCode(paymentUrl) {
    // Hide payment form, show QR code section
    document.getElementById('paymentFormSection').style.display = 'none';
    document.getElementById('qrCodeSection').style.display = 'flex';

    // Clear previous QR code if exists
    document.getElementById('qrcode').innerHTML = '';

    // Generate new QR code
    new QRCode(document.getElementById('qrcode'), {
        text: paymentUrl,
        width: 250,
        height: 250,
        colorDark: '#000000',
        colorLight: '#ffffff',
        correctLevel: QRCode.CorrectLevel.H
    });

    // Set the payment URL in the input field
    document.getElementById('paymentUrl').value = paymentUrl;
}

function goBackToPaymentForm() {
    // Stop polling if active
    if (statusPollingInterval !== null) {
        clearInterval(statusPollingInterval);
        statusPollingInterval = null;
    }

    // Show payment form, hide QR code section
    document.getElementById('paymentFormSection').style.display = 'flex';
    document.getElementById('qrCodeSection').style.display = 'none';

    // Clear QR code
    document.getElementById('qrcode').innerHTML = '';
    document.getElementById('paymentUrl').value = '';
    currentMaThanhToan = null;
}

function copyToClipboard() {
    const url = document.getElementById('paymentUrl');
    url.select();
    document.execCommand('copy');
    if (window.UI && window.UI.toast) {
        UI.toast('Đã sao chép liên kết vào bộ nhớ đệm!', 'success', 2000);
    } else {
        alert('Đã sao chép liên kết vào bộ nhớ đệm!');
    }
}

/**
 * Poll for payment status on Device A
 * Checks every 2 seconds if payment has been completed on Device B
 */
function startPaymentStatusPolling() {
    if (statusPollingInterval !== null) {
        return; // Already polling
    }

    statusPollingInterval = setInterval(() => {
        checkPaymentStatus();
    }, 2000); // Check every 2 seconds
}

function checkPaymentStatus() {
    if (currentMaThanhToan === null) {
        stopPaymentStatusPolling();
        return;
    }

    fetch(ctx + '/khachhang/thanhtoan/status?maThanhToan=' + currentMaThanhToan)
        .then(response => response.json())
        .then(data => {
            if (data.completed === true) {
                // Payment successful!
                stopPaymentStatusPolling();
                showSuccessAndRedirect();
            }
        })
        .catch(err => {
            // Silently ignore polling errors
            console.log('Polling error:', err);
        });
}

function stopPaymentStatusPolling() {
    if (statusPollingInterval !== null) {
        clearInterval(statusPollingInterval);
        statusPollingInterval = null;
    }
}

function showSuccessAndRedirect() {
    // Hide QR section
    document.getElementById('qrCodeSection').style.display = 'none';

    // Show success notification
    const successDiv = document.createElement('div');
    successDiv.style.cssText = 'background: #d4edda; padding: 20px; margin: 20px 0; border: 2px solid #28a745; border-radius: 12px; text-align: center; font-size: 18px; color: #155724; font-weight: 700; display: flex; align-items: center; justify-content: center; gap: 12px;';
    successDiv.innerHTML = '<iconify-icon icon="mdi:check-circle" style="width: 32px; height: 32px;"></iconify-icon><div><div>✓ Thanh toán thành công!</div><div style="font-size: 14px; margin-top: 8px;">Đang chuyển hướng đến lịch sử thuê xe...</div></div>';

    document.querySelector('.app-container').insertBefore(successDiv, document.querySelector('.app-container').firstChild);

    // Redirect to rental history after 2 seconds
    setTimeout(() => {
        window.location.href = ctx + '/khachhang/lichsuthuexe/xedangthue';
    }, 2000);
}

/**
 * Handle image loading error - display placeholder
 */
function handleImageError(img) {
    img.parentElement.innerHTML = '<div style="text-align: center; padding: var(--spacing-lg);"><iconify-icon icon="mdi:motorcycle" style="width: 64px; height: 64px; color: var(--color-text-secondary);"></iconify-icon><p style="margin: var(--spacing-md) 0 0 0; color: var(--color-text-secondary); font-size: var(--text-sm);">Không thể tải hình ảnh</p></div>';
}

    </script>
</body>
</html>
