<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Giỏ Hàng - MOTOBOOK</title>
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
                        <iconify-icon icon="mdi:shopping-cart" style="width: 32px; height: 32px; color: var(--color-primary);"></iconify-icon>
                        Giỏ Hàng Của Bạn
                    </h1>
                    <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Xin chào <strong style="color: var(--color-primary);"><%=username%></strong></p>
                </section>

                <!-- Two Column Layout: Cart Items + Summary -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-2xl); align-items: start;">
                    
                    <!-- LEFT: Cart Items List -->
                    <section style="grid-column: 1; display: flex; flex-direction: column; gap: var(--spacing-lg);">
                        <div style="background: white; border: 1px solid var(--color-border-light); border-radius: 12px; padding: var(--spacing-lg); display: flex; align-items: center; justify-content: space-between; gap: var(--spacing-md);">
                            <div style="display: flex; align-items: center; gap: var(--spacing-md);">
                                <iconify-icon icon="mdi:package-multiple" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                                <div>
                                    <h2 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 4px 0;">Chi Tiết Gói Thuê</h2>
                                    <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Cập nhật thời gian thuê và thông tin xe</p>
                                </div>
                            </div>
                            <label style="display: flex; align-items: center; gap: var(--spacing-sm); cursor: pointer; white-space: nowrap;">
                                <input type="checkbox" id="selectAllCheckbox" onchange="toggleSelectAll()" style="width: 18px; height: 18px; cursor: pointer;">
                                <span style="font-size: var(--text-sm); font-weight: 500; color: var(--color-text-primary);">Chọn tất cả</span>
                            </label>
                        </div>
                        
                        <!-- Cart Items Container -->
                        <div id="cartContainer" style="display: flex; flex-direction: column; gap: var(--spacing-lg);"></div>
                    </section>

                    <!-- RIGHT: Order Summary & Checkout -->
                    <section style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                        
                        <!-- Price Summary Card -->
                        <div id="summarySectionCard" style="background: linear-gradient(135deg, var(--color-primary-lighter) 0%, white 100%); border: 1px solid var(--color-border-light); border-radius: 12px; padding: var(--spacing-lg); position: sticky; top: var(--spacing-lg); transition: opacity 0.3s ease;">
                            <h3 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                                <iconify-icon icon="mdi:receipt-text" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                                Tóm Tắt Đơn Hàng
                            </h3>
                            
                            <!-- Breakdown -->
                            <div id="priceBreakdown" style="font-size: var(--text-sm); color: var(--color-text-secondary); margin-bottom: var(--spacing-lg); padding-bottom: var(--spacing-lg); border-bottom: 1px solid var(--color-border-light);">
                                <p style="margin: 0; color: var(--color-text-secondary);">Chưa có gói nào</p>
                            </div>
                            
                            <!-- Total Price -->
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--spacing-lg);">
                                <span style="font-size: var(--text-sm); color: var(--color-text-secondary);">Tổng Cộng:</span>
                                <span id="tongTien" style="font-size: var(--text-2xl); font-weight: 700; color: var(--color-primary);">0đ</span>
                            </div>
                            
                            <!-- Checkout Button -->
                            <button onclick="checkout()" id="checkoutBtn" class="btn btn-primary" style="width: 100%; padding: var(--spacing-md); font-size: var(--text-base); font-weight: 600;">
                                <iconify-icon icon="mdi:credit-card" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 4px;"></iconify-icon>
                                Tiếp Tục Thanh Toán
                            </button>
                        </div>

                        <!-- Delivery Address Card -->
                        <div style="background: white; border: 1px solid var(--color-border-light); border-radius: 12px; padding: var(--spacing-lg);">
                            <h3 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                                <iconify-icon icon="mdi:map-marker" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                                Nhận Xe
                            </h3>
                            
                            <!-- Delivery Method Selection -->
                            <div style="display: flex; gap: var(--spacing-lg); margin-bottom: var(--spacing-lg);">
                                <label style="display: flex; align-items: center; gap: var(--spacing-sm); cursor: pointer;">
                                    <input type="radio" id="deliveryCustom" name="deliveryMethod" value="custom" checked onchange="onDeliveryMethodChange()" style="cursor: pointer;">
                                    <span style="font-size: var(--text-sm); font-weight: 500;">Nhập địa chỉ</span>
                                </label>
                                <label style="display: flex; align-items: center; gap: var(--spacing-sm); cursor: pointer;">
                                    <input type="radio" id="deliveryBranch" name="deliveryMethod" value="branch" onchange="onDeliveryMethodChange()" style="cursor: pointer;">
                                    <span style="font-size: var(--text-sm); font-weight: 500;">Nhận tại cửa hàng</span>
                                </label>
                            </div>
                            
                            <!-- Custom Address Section -->
                            <div id="customAddressSection" style="display: block; margin-bottom: var(--spacing-lg);">
                                <textarea id="diaChiNhanXe" 
                                          placeholder="Nhập địa chỉ nhận xe của bạn" 
                                          style="width: 100%; height: 100px; padding: var(--spacing-md); border: 1px solid var(--color-border); border-radius: 6px; font-size: var(--text-sm); font-family: var(--font-primary); resize: vertical; margin-bottom: var(--spacing-md);" 
                                          lang="vi" charset="UTF-8"></textarea>
                                
                                <button onclick="updateDiaChi()" class="btn btn-secondary" style="width: 100%; padding: var(--spacing-sm); font-size: var(--text-sm);">
                                    <iconify-icon icon="mdi:content-save" style="width: 16px; height: 16px; vertical-align: middle; margin-right: 4px;"></iconify-icon>
                                    Cập Nhật Địa Chỉ
                                </button>
                            </div>
                            
                            <!-- Branch Selection Section -->
                            <div id="branchSelectionSection" style="display: none; margin-bottom: var(--spacing-lg);">
                                <div id="branchList" style="display: flex; flex-direction: column; gap: var(--spacing-sm);">
                                    <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0; text-align: center;">Chọn chi nhánh nhận xe</p>
                                </div>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div style="display: flex; flex-direction: column; gap: var(--spacing-md);">
                            <button onclick="goToDashboard()" class="btn btn-outline" style="width: 100%; padding: var(--spacing-md); font-size: var(--text-sm); border: 1px solid var(--color-border); background: white; color: var(--color-text-primary); border-radius: 6px; cursor: pointer; transition: all 0.2s ease;" 
                                    onmouseover="this.style.background='var(--color-gray-50)'" onmouseout="this.style.background='white'">
                                <iconify-icon icon="mdi:arrow-left" style="width: 16px; height: 16px; vertical-align: middle; margin-right: 4px;"></iconify-icon>
                                Tiếp Tục Mua Sắm
                            </button>
                        </div>
                    </section>
                </div>
            </div>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>

    <script src="${pageContext.request.contextPath}/js/ui-utils.js"></script>

    <script>
        const ctx = '<%=ctxPath%>';
        
        // Lưu trữ state của các item trong giỏ
        const cartState = {};
        
        // Tính khoảng thời gian (giờ)
        function calculateHours(startStr, endStr) {
            if (!startStr || !endStr) return 0;
            const start = new Date(startStr);
            const end = new Date(endStr);
            const diffMs = end - start;
            if (diffMs <= 0) return 0;
            return diffMs / (1000 * 60 * 60); // chuyển thành giờ
        }
        
        // Tính giá cho một item dựa trên thời gian
        function calculatePrice(startStr, endStr, giaNgay, giaTuan, soLuong) {
            if (!startStr || !endStr || soLuong < 1) return 0;
            
            const hours = calculateHours(startStr, endStr);
            if (hours <= 0) return 0;
            
            // Calculate price PER UNIT first, then round, then multiply by quantity
            // This matches backend logic: Math.ceil(giaMotXe) * soLuong
            let pricePerUnit = 0;
            if (hours >= 168) {
                // >= 1 week: weeks × giaTuan + remainingHours × (giaNgay/24)
                const weeks = Math.floor(hours / 168);
                const remainingHours = hours - (weeks * 168);
                const remainingDays = remainingHours / 24;
                
                pricePerUnit = (weeks * giaTuan) + (remainingDays * giaNgay);
            } else {
                // < 1 week: days × giaNgay + remainingHours × (giaNgay/24)
                const days = hours / 24;
                pricePerUnit = days * giaNgay;
            }
            
            // Round per unit, then multiply by quantity (match backend)
            return Math.ceil(pricePerUnit) * soLuong;
        }
        
        // Load giỏ hàng
        function loadCart() {
            fetch(ctx + '/khachhang/giohang?api=1')
                .then(res => res.text())
                .then(xml => {
                    console.log('=== Raw XML Response ===');
                    console.log(xml);
                    
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(xml, 'application/xml');
                    
                    // RESET cartState để clear dữ liệu cũ
                    for (const key in cartState) {
                        delete cartState[key];
                    }
                    console.log('cartState reset, cleared all old entries');
                    
                    const container = document.getElementById('cartContainer');
                    const diaChiInput = document.getElementById('diaChiNhanXe');
                    
                    const diaChi = doc.querySelector('diaChiNhanXe');
                    if (diaChi && diaChi.textContent) {
                        diaChiInput.value = diaChi.textContent;
                    }
                    
                    const items = doc.querySelectorAll('item');
                    let html = '';
                    
                    console.log('Total items loaded:', items.length);
                    if (items.length === 0) {
                        html = '<div style="background: white; border: 1px solid var(--color-border-light); border-radius: 12px; padding: var(--spacing-3xl); text-align: center;">' +
                            '<iconify-icon icon="mdi:cart-outline" style="width: 64px; height: 64px; color: #d1d5db; display: block; margin: 0 auto var(--spacing-md) auto;"></iconify-icon>' +
                            '<p style="font-size: var(--text-lg); color: var(--color-text-secondary); margin: 0;">Giỏ hàng của bạn đang trống</p>' +
                            '<p style="font-size: var(--text-sm); color: var(--color-text-muted); margin: var(--spacing-md) 0 0 0;">Hãy thêm gói thuê để bắt đầu</p>' +
                            '</div>';
                        document.getElementById('tongTien').textContent = '0đ';
                        document.getElementById('priceBreakdown').innerHTML = '<p style="margin: 0; color: var(--color-text-secondary);">Chưa có gói nào</p>';
                    } else {
                        items.forEach((item, index) => {
                            const maGoiThue = item.querySelector('maGoiThue').textContent;
                            const tenGoiThue = item.querySelector('tenGoiThue').textContent;
                            const hangXe = item.querySelector('hangXe')?.textContent || '';
                            const dongXe = item.querySelector('dongXe')?.textContent || '';
                            const soLuong = parseInt(item.querySelector('soLuong').textContent);
                            const giaNgay = parseFloat(item.querySelector('giaNgay').textContent);
                            const giaTuan = parseFloat(item.querySelector('giaTuan').textContent);
                            
                            console.log('Processing item ' + index, '| maGoiThue:', maGoiThue, '| tenGoiThue:', tenGoiThue, '| soLuong:', soLuong);
                            
                            let batDauValue = '';
                            let ketThucValue = '';
                            
                            const bdElem = item.querySelector('thoiGianBatDau');
                            const ktElem = item.querySelector('thoiGianKetThuc');
                            
                            if (bdElem && bdElem.textContent) {
                                batDauValue = bdElem.textContent.substring(0, 16);
                            }
                            if (ktElem && ktElem.textContent) {
                                ketThucValue = ktElem.textContent.substring(0, 16);
                            }
                            
                            // Khởi tạo state cho item này
                            if (!cartState[maGoiThue]) {
                                cartState[maGoiThue] = {
                                    tenGoiThue: tenGoiThue,
                                    hangXe: hangXe,
                                    dongXe: dongXe,
                                    giaNgay: giaNgay,
                                    giaTuan: giaTuan,
                                    soLuong: soLuong,
                                    batDau: batDauValue,
                                    ketThuc: ketThucValue,
                                    soXeCon: 0,
                                    thanhTien: 0,
                                    isSelected: false,
                                    branches: []
                                };
                                console.log('Created new cartState entry for maGoiThue:', maGoiThue);
                            }
                            
                            // Lấy danh sách chi nhánh
                            const branchesElem = item.querySelectorAll('branch');
                            console.log('Item maGoiThue:', maGoiThue, 'Số branch:', branchesElem.length);
                            branchesElem.forEach(branchElem => {
                                const branch = {
                                    maChiNhanh: branchElem.querySelector('maChiNhanh')?.textContent || '',
                                    tenChiNhanh: branchElem.querySelector('tenChiNhanh')?.textContent || '',
                                    diaDiem: branchElem.querySelector('diaDiem')?.textContent || ''
                                };
                                console.log('Branch:', branch);
                                if (branch.maChiNhanh) {
                                    cartState[maGoiThue].branches.push(branch);
                                }
                            });
                            console.log('Final branches for item:', cartState[maGoiThue].branches);
                            
                            const thanhTien = calculatePrice(batDauValue, ketThucValue, giaNgay, giaTuan, soLuong);
                            cartState[maGoiThue].thanhTien = thanhTien;
                            
                            html += '<div class="card" style="padding: var(--spacing-lg); background: white; border: 1px solid var(--color-border-light); border-radius: 12px; position: relative; transition: all 0.2s ease; border-color: var(--color-primary); background-color: rgba(16, 185, 129, 0.01);" id="itemCard_' + maGoiThue + '">' +
                                '<div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: var(--spacing-lg);">' +
                                '<label style="display: flex; align-items: center; gap: var(--spacing-md); flex: 1; cursor: pointer;">' +
                                '<input type="checkbox" id="select_' + maGoiThue + '" onchange="toggleItemSelection(' + maGoiThue + ')" style="width: 20px; height: 20px; cursor: pointer;">'+  
                                '<div style="flex: 1;">' +
                                '<h3 style="font-size: var(--text-base); font-weight: 700; margin: 0 0 4px 0; color: var(--color-text-primary);">' + escapeHtml(tenGoiThue) + '</h3>' +
                                '<p style="font-size: var(--text-sm); color: var(--color-primary); margin: 0;">' + escapeHtml(hangXe) + ' ' + escapeHtml(dongXe) + '</p>' +
                                '</div>' +
                                '</label>' +
                                '<button onclick="removeItem(' + maGoiThue + ')" ' +
                                'style="background: #fee2e2; color: var(--color-danger); padding: var(--spacing-xs) var(--spacing-sm); border: none; border-radius: 6px; cursor: pointer; font-size: var(--text-sm); transition: all 0.2s ease;" ' +
                                'onmouseover="this.style.background=\'var(--color-danger)\'; this.style.color=\'white\'" ' +
                                'onmouseout="this.style.background=\'#fee2e2\'; this.style.color=\'var(--color-danger)\'">' +
                                '<iconify-icon icon="mdi:trash-can-outline" style="width: 16px; height: 16px; vertical-align: middle;"></iconify-icon>' +
                                '</button>' +
                                '</div>' +
                                '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md); margin-bottom: var(--spacing-lg);">' +
                                '<div>' +
                                '<label style="display: block; font-size: 12px; font-weight: 600; text-transform: uppercase; color: var(--color-text-secondary); margin-bottom: var(--spacing-xs);">Thuê Từ</label>' +
                                '<input type="datetime-local" ' +
                                'id="bd_' + maGoiThue + '" ' +
                                'value="' + batDauValue + '" ' +
                                'onchange="onTimeChange(' + maGoiThue + ')" ' +
                                'style="width: 100%; padding: var(--spacing-sm); border: 1px solid var(--color-border); border-radius: 6px; font-size: var(--text-sm);">' +
                                '</div>' +
                                '<div>' +
                                '<label style="display: block; font-size: 12px; font-weight: 600; text-transform: uppercase; color: var(--color-text-secondary); margin-bottom: var(--spacing-xs);">Trả Lại</label>' +
                                '<input type="datetime-local" ' +
                                'id="kt_' + maGoiThue + '" ' +
                                'value="' + ketThucValue + '" ' +
                                'onchange="onTimeChange(' + maGoiThue + ')" ' +
                                'style="width: 100%; padding: var(--spacing-sm); border: 1px solid var(--color-border); border-radius: 6px; font-size: var(--text-sm);">' +
                                '</div>' +
                                '</div>' +
                                '<div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md); margin-bottom: var(--spacing-lg);">' +
                                '<div>' +
                                '<label style="display: block; font-size: 12px; font-weight: 600; text-transform: uppercase; color: var(--color-text-secondary); margin-bottom: var(--spacing-xs);">Số Lượng</label>' +
                                '<input type="number" ' +
                                'id="qty_' + maGoiThue + '" ' +
                                'value="' + soLuong + '" ' +
                                'min="1" ' +
                                'onchange="onQuantityChange(' + maGoiThue + ')" ' +
                                'style="width: 100%; padding: var(--spacing-sm); border: 1px solid var(--color-border); border-radius: 6px; font-size: var(--text-sm);">' +
                                '</div>' +
                                '<div>' +
                                '<label style="display: block; font-size: 12px; font-weight: 600; text-transform: uppercase; color: var(--color-text-secondary); margin-bottom: var(--spacing-xs);">Xe Còn Lại</label>' +
                                '<div style="padding: var(--spacing-sm); border: 1px solid var(--color-border); border-radius: 6px; font-size: var(--text-sm); display: flex; align-items: center;">' +
                                '<span id="avail_' + maGoiThue + '" style="color: #9ca3af;">-</span>' +
                                '</div>' +
                                '</div>' +
                                '</div>' +
                                '<div style="display: flex; justify-content: space-between; align-items: center; padding-top: var(--spacing-lg); border-top: 1px solid var(--color-border-light);">' +
                                '<div>' +
                                '<p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Thời gian:</p>' +
                                '<p id="unitPrice_' + maGoiThue + '" style="font-size: var(--text-base); font-weight: 600; color: var(--color-text-primary); margin: 0;">-</p>' +
                                '</div>' +
                                '<div style="text-align: right;">' +
                                '<p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0;">Thành tiền:</p>' +
                                '<p id="totalPrice_' + maGoiThue + '" style="font-size: var(--text-xl); font-weight: 700; color: var(--color-primary); margin: 0;">' + formatCurrency(thanhTien) + '</p>' +
                                '</div>' +
                                '<button onclick="saveItem(' + maGoiThue + ')" ' +
                                'class="btn btn-primary" ' +
                                'style="padding: var(--spacing-md) var(--spacing-lg); font-size: var(--text-sm); whitespace: nowrap;">' +
                                '<iconify-icon icon="mdi:check-circle" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 4px;"></iconify-icon>' +
                                'Cập Nhật' +
                                '</button>' +
                                '</div>' +
                                '</div>';
                        });
                    }
                    
                    console.log('=== FINAL cartState ===');
                    console.log('Total entries in cartState:', Object.keys(cartState).length);
                    console.log('cartState keys:', Object.keys(cartState));
                    Object.keys(cartState).forEach(key => {
                        console.log('  -', key, ':', cartState[key].tenGoiThue);
                    });
                    console.log('HTML content length:', html.length);
                    console.log('HTML contains how many itemCard_ :', (html.match(/itemCard_/g) || []).length);
                    
                    container.innerHTML = html;
                    calculateTotal();
                    updateSelectAllCheckbox();
                    
                    // Tự động check số xe còn lại cho các item có thời gian
                    Object.keys(cartState).forEach(maGoiThue => {
                        const state = cartState[maGoiThue];
                        if (state.batDau && state.ketThuc) {
                            console.log('Auto checking availability for:', maGoiThue);
                            checkAvailabilityAuto(maGoiThue, state.batDau, state.ketThuc);
                        }
                    });
                })
                .catch(e => {
                    console.error('[ERROR] loadCart:', e);
                    document.getElementById('cartContainer').innerHTML = 
                        '<div style="background: #fee2e2; border: 1px solid var(--color-danger); border-radius: 12px; padding: var(--spacing-lg); color: var(--color-danger);">' +
                        '<p style="margin: 0; font-weight: 600;">Lỗi tải giỏ hàng</p>' +
                        '<p style="margin: var(--spacing-xs) 0 0 0; font-size: var(--text-sm);">' + escapeHtml(e.message) + '</p>' +
                        '</div>';
                });
        }
        
        // Sự kiện thay đổi thời gian
        function onTimeChange(maGoiThue) {
            const batDauInput = document.getElementById('bd_' + maGoiThue).value;
            const ketThucInput = document.getElementById('kt_' + maGoiThue).value;
            
            // Cập nhật state
            if (cartState[maGoiThue]) {
                cartState[maGoiThue].batDau = batDauInput;
                cartState[maGoiThue].ketThuc = ketThucInput;
            }
            
            // Nếu cả hai thời gian đã nhập, kiểm tra xe còn trống
            if (batDauInput && ketThucInput) {
                checkAvailabilityAuto(maGoiThue, batDauInput, ketThucInput);
                updateItemPrice(maGoiThue);
            }
            
            calculateTotal();
        }
        
        // Sự kiện thay đổi số lượng
        function onQuantityChange(maGoiThue) {
            const soLuongInput = parseInt(document.getElementById('qty_' + maGoiThue).value);
            
            // Validate số lượng
            if (soLuongInput < 1) {
                document.getElementById('qty_' + maGoiThue).value = 1;
            }
            
            // Cập nhật state
            if (cartState[maGoiThue]) {
                cartState[maGoiThue].soLuong = Math.max(1, soLuongInput);
            }
            
            updateItemPrice(maGoiThue);
            calculateTotal();
        }
        
        // Kiểm tra số xe còn trống (tự động, không cần click)
        function checkAvailabilityAuto(maGoiThue, batDauStr, ketThucStr) {
            if (!batDauStr || !ketThucStr) return;
            
            // Gửi giá trị datetime-local trực tiếp mà không convert timezone
            const batDau = batDauStr;
            const ketThuc = ketThucStr;
            
            // Validate thời gian
            if (new Date(batDau) >= new Date(ketThuc)) {
                document.getElementById('avail_' + maGoiThue).innerHTML = 'Thời gian không hợp lệ';
                document.getElementById('avail_' + maGoiThue).style.color = 'var(--color-danger)';
                if (cartState[maGoiThue]) {
                    cartState[maGoiThue].soXeCon = 0;
                }
                return;
            }
            
            fetch(ctx + '/khachhang/giohang', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=checkAvailable&maGoiThue=' + maGoiThue + 
                      '&thoiGianBatDau=' + encodeURIComponent(batDau) +
                      '&thoiGianKetThuc=' + encodeURIComponent(ketThuc)
            })
            .then(res => res.text())
            .then(xml => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(xml, 'application/xml');
                
                // Check for parsing errors
                if (doc.documentElement.nodeName === 'parsererror') {
                    document.getElementById('avail_' + maGoiThue).innerHTML = 'Lỗi!';
                    document.getElementById('avail_' + maGoiThue).style.color = 'var(--color-danger)';
                    if (cartState[maGoiThue]) {
                        cartState[maGoiThue].soXeCon = 0;
                    }
                    console.error('XML parse error:', xml);
                    return;
                }
                
                // Check for error response
                if (doc.querySelector('error')) {
                    const errorMsg = doc.querySelector('error').textContent;
                    document.getElementById('avail_' + maGoiThue).innerHTML = 'Lỗi';
                    document.getElementById('avail_' + maGoiThue).style.color = 'var(--color-danger)';
                    if (cartState[maGoiThue]) {
                        cartState[maGoiThue].soXeCon = 0;
                    }
                    console.error('API error:', errorMsg);
                    return;
                }
                
                const soLuongConElem = doc.querySelector('soLuongCon');
                if (!soLuongConElem) {
                    document.getElementById('avail_' + maGoiThue).innerHTML = 'Lỗi!';
                    document.getElementById('avail_' + maGoiThue).style.color = 'var(--color-danger)';
                    if (cartState[maGoiThue]) {
                        cartState[maGoiThue].soXeCon = 0;
                    }
                    console.error('Missing soLuongCon in response');
                    return;
                }
                
                const soLuongCon = parseInt(soLuongConElem.textContent);
                const availSpan = document.getElementById('avail_' + maGoiThue);
                
                if (cartState[maGoiThue]) {
                    cartState[maGoiThue].soXeCon = soLuongCon;
                }
                
                if (soLuongCon > 0) {
                    availSpan.innerHTML = soLuongCon + ' xe';
                    availSpan.style.color = 'var(--color-success)';
                } else {
                    availSpan.innerHTML = 'Hết xe';
                    availSpan.style.color = 'var(--color-danger)';
                }
            })
            .catch(e => {
                console.error('[ERROR] checkAvailabilityAuto:', e);
                document.getElementById('avail_' + maGoiThue).innerHTML = 'Lỗi!';
                document.getElementById('avail_' + maGoiThue).style.color = 'var(--color-danger)';
            });
        }
        
        // Cập nhật giá hiển thị cho một item
        function updateItemPrice(maGoiThue) {
            if (!cartState[maGoiThue]) return;
            
            const state = cartState[maGoiThue];
            const price = calculatePrice(state.batDau, state.ketThuc, state.giaNgay, state.giaTuan, state.soLuong);
            
            cartState[maGoiThue].thanhTien = price;
            
            // Cập nhật giá hiển thị
            const hours = calculateHours(state.batDau, state.ketThuc);
            let unitPriceText = '-';
            
            if (hours > 0) {
                const days = Math.floor(hours / 24);
                const remainingHours = hours - (days * 24);
                
                if (days > 0 && remainingHours > 0) {
                    unitPriceText = days + ' ngày + ' + Math.floor(remainingHours) + ' giờ';
                } else if (days > 0) {
                    unitPriceText = days + ' ngày';
                } else {
                    unitPriceText = Math.ceil(hours) + ' giờ';
                }
            }
            
            document.getElementById('unitPrice_' + maGoiThue).textContent = unitPriceText;
            document.getElementById('totalPrice_' + maGoiThue).textContent = formatCurrency(price);
        }
        
        // Lưu item sau khi xác nhận
        function saveItem(maGoiThue) {
            if (!cartState[maGoiThue]) return;
            
            const state = cartState[maGoiThue];
            const batDauInput = document.getElementById('bd_' + maGoiThue).value;
            const ketThucInput = document.getElementById('kt_' + maGoiThue).value;
            const soLuong = parseInt(document.getElementById('qty_' + maGoiThue).value);
            
            // Validate
            if (!batDauInput || !ketThucInput) {
                UI.toast('Vui lòng nhập cả thời gian thuê và thời gian trả', 'error', 3000);
                return;
            }
            
            if (soLuong < 1) {
                UI.toast('Số lượng không hợp lệ', 'error', 3000);
                return;
            }
            
            if (new Date(batDauInput) >= new Date(ketThucInput)) {
                UI.toast('Thời gian trả phải sau thời gian thuê', 'error', 3000);
                return;
            }
            
            if (state.soXeCon <= 0) {
                UI.toast('Không có xe còn trống trong khoảng thời gian này', 'error', 3000);
                return;
            }
            
            // Gửi giá trị datetime-local trực tiếp mà không convert timezone
            const batDau = batDauInput;
            const ketThuc = ketThucInput;
            
            fetch(ctx + '/khachhang/giohang', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=update&maGoiThue=' + maGoiThue + 
                      '&soLuong=' + soLuong +
                      '&thoiGianBatDau=' + encodeURIComponent(batDau) +
                      '&thoiGianKetThuc=' + encodeURIComponent(ketThuc)
            })
            .then(res => res.text())
            .then(xml => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(xml, 'application/xml');
                
                if (doc.querySelector('error')) {
                    UI.toast('Lỗi: ' + escapeHtml(doc.querySelector('error').textContent || doc.querySelector('message').textContent), 'error', 3000);
                    return;
                }
                
                const status = doc.querySelector('status').textContent;
                if (status === 'success') {
                    UI.toast('Đã cập nhật gói xe', 'success', 3000);
                    loadCart();
                } else {
                    UI.toast('Cập nhật thất bại', 'error', 3000);
                    loadCart();
                }
            })
            .catch(e => {
                console.error('[ERROR] saveItem:', e);
                UI.toast('Lỗi: ' + escapeHtml(e.message), 'error', 3000);
            });
        }

        function removeItem(maGoiThue) {
            UI.confirm('Xóa Gói Thuê', 'Bạn có chắc muốn xóa gói này khỏi giỏ hàng?',
                () => {
                    fetch(ctx + '/khachhang/giohang', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: 'action=delete&maGoiThue=' + maGoiThue
                    })
                    .then(res => res.text())
                    .then(xml => {
                        const parser = new DOMParser();
                        const doc = parser.parseFromString(xml, 'application/xml');
                        const status = doc.querySelector('status').textContent;
                        
                        if (status === 'success') {
                            delete cartState[maGoiThue];
                            UI.toast('Đã xóa khỏi giỏ hàng', 'success', 3000);
                            loadCart();
                        } else {
                            UI.toast('Xóa thất bại', 'error', 3000);
                        }
                    })
                    .catch(e => {
                        console.error('[ERROR] removeItem:', e);
                        UI.toast('Lỗi: ' + escapeHtml(e.message), 'error', 3000);
                    });
                },
                () => {}
            );
        }

        function updateDiaChi() {
            const deliveryMethod = document.getElementById('deliveryCustom').checked ? 'custom' : 'branch';
            
            if (deliveryMethod === 'custom') {
                const diaChi = document.getElementById('diaChiNhanXe').value.trim();
                if (!diaChi) {
                    UI.toast('Vui lòng nhập địa chỉ', 'error', 3000);
                    return;
                }
                
                fetch(ctx + '/khachhang/giohang', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
                    body: 'action=updateAddress&diaChiNhanXe=' + encodeURIComponent(diaChi)
                })
                .then(res => res.text())
                .then(xml => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(xml, 'application/xml');
                    const status = doc.querySelector('status').textContent;
                    
                    if (status === 'success') {
                        UI.toast('Cập nhật địa chỉ thành công', 'success', 3000);
                    } else {
                        UI.toast('Cập nhật thất bại', 'error', 3000);
                    }
                })
                .catch(e => {
                    console.error('[ERROR] updateDiaChi:', e);
                    UI.toast('Lỗi: ' + escapeHtml(e.message), 'error', 3000);
                });
            } else {
                if (!window.selectedBranchId) {
                    UI.toast('Vui lòng chọn chi nhánh nhận xe', 'error', 3000);
                    return;
                }
                
                fetch(ctx + '/khachhang/giohang', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'action=updateAddress&maChiNhanh=' + window.selectedBranchId
                })
                .then(res => res.text())
                .then(xml => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(xml, 'application/xml');
                    const status = doc.querySelector('status').textContent;
                    
                    if (status === 'success') {
                        UI.toast('Cập nhật chi nhánh nhận xe thành công', 'success', 3000);
                    } else {
                        UI.toast('Cập nhật thất bại', 'error', 3000);
                    }
                })
                .catch(e => {
                    console.error('[ERROR] updateDiaChi:', e);
                    UI.toast('Lỗi: ' + escapeHtml(e.message), 'error', 3000);
                });
            }
        }

        // Tính tổng tiền từ các item được chọn
        function calculateTotal() {
            let totalPrice = 0;
            let breakdownText = '';
            let hasSelected = false;
            
            Object.keys(cartState).forEach(maGoiThue => {
                const state = cartState[maGoiThue];
                
                if (state.isSelected && state.thanhTien > 0) {
                    hasSelected = true;
                    totalPrice += state.thanhTien;
                    breakdownText += '<div style="display: flex; justify-content: space-between; align-items: center; padding: var(--spacing-xs) 0; border-bottom: 1px solid rgba(0,0,0,0.05);">' +
                        '<span>• ' + escapeHtml(state.tenGoiThue) + ' (' + state.soLuong + ' xe)</span>' +
                        '<span style="font-weight: 600; color: var(--color-primary);">' + formatCurrency(state.thanhTien) + '</span>' +
                        '</div>';
                }
            });
            
            document.getElementById('tongTien').textContent = formatCurrency(totalPrice);
            document.getElementById('priceBreakdown').innerHTML = breakdownText || '<p style="margin: 0; color: var(--color-text-secondary);">Chưa có gói nào được chọn</p>';
            
            // Làm mờ/sáng tóm tắt đơn hàng dựa trên có item được chọn hay không
            const summaryCard = document.getElementById('summarySectionCard');
            if (summaryCard) {
                summaryCard.style.opacity = hasSelected ? '1' : '0.5';
                summaryCard.style.pointerEvents = hasSelected ? 'auto' : 'none';
            }
            
            // Disable checkout button nếu không có item được chọn
            const checkoutBtn = document.getElementById('checkoutBtn');
            if (checkoutBtn) {
                checkoutBtn.disabled = !hasSelected;
            }
        }

        function checkout() {
            console.log('=== CHECKOUT DEBUG START ===');
            console.log('Current cartState:', JSON.stringify(cartState, null, 2));
            
            // Validate cart - check if any items are selected
            let hasSelectedItems = false;
            for (const maGoiThue in cartState) {
                if (cartState[maGoiThue].isSelected) {
                    hasSelectedItems = true;
                    break;
                }
            }
            
            if (!hasSelectedItems) {
                UI.toast('Vui lòng chọn ít nhất một gói để thanh toán', 'error', 3000);
                return;
            }
            
            // Validate các item được chọn có thời gian
            for (const maGoiThue in cartState) {
                const state = cartState[maGoiThue];
                console.log('\n--- Processing item:', maGoiThue, '---');
                console.log('isSelected:', state.isSelected);
                
                if (!state.isSelected) {
                    console.log('Skipping - not selected');
                    continue;
                }
                
                // Đọc giá trị từ input thực tế (không phải cartState)
                const inputElement = document.getElementById('bd_' + maGoiThue);
                const inputElement2 = document.getElementById('kt_' + maGoiThue);
                
                console.log('Looking for inputs: bd_' + maGoiThue + ' | kt_' + maGoiThue);
                console.log('bd_ element exists:', !!inputElement);
                console.log('kt_ element exists:', !!inputElement2);
                
                const batDauInput = inputElement?.value || '';
                const ketThucInput = inputElement2?.value || '';
                
                console.log('Input values:');
                console.log('  batDauInput:', batDauInput);
                console.log('  ketThucInput:', ketThucInput);
                console.log('  cartState.batDau:', state.batDau);
                console.log('  cartState.ketThuc:', state.ketThuc);
                
                if (!batDauInput || !ketThucInput) {
                    console.error('ERROR: Missing time values!');
                    console.error('  batDauInput empty:', !batDauInput);
                    console.error('  ketThucInput empty:', !ketThucInput);
                    UI.toast('Vui lòng nhập thời gian thuê và trả cho gói "' + state.tenGoiThue + '"', 'error', 3000);
                    return;
                }
                
                // Cập nhật cartState để đồng bộ
                state.batDau = batDauInput;
                state.ketThuc = ketThucInput;
                console.log('Updated cartState for item - now has times');
                
                if (state.soXeCon <= 0) {
                    console.error('ERROR: No vehicles available - soXeCon:', state.soXeCon);
                    UI.toast('Gói "' + state.tenGoiThue + '" không có xe còn trống', 'error', 3000);
                    return;
                }
                console.log('Vehicle availability OK - soXeCon:', state.soXeCon);
            }
            
            console.log('=== ALL VALIDATIONS PASSED ===');
            
            // Validate delivery address
            const deliveryMethod = document.getElementById('deliveryCustom').checked ? 'custom' : 'branch';
            let deliveryInfo = '';
            
            if (deliveryMethod === 'custom') {
                deliveryInfo = document.getElementById('diaChiNhanXe').value.trim();
                if (!deliveryInfo) {
                    UI.toast('Vui lòng nhập địa chỉ nhận xe', 'error', 3000);
                    return;
                }
            } else {
                if (!window.selectedBranchId) {
                    UI.toast('Vui lòng chọn chi nhánh nhận xe', 'error', 3000);
                    return;
                }
                deliveryInfo = window.selectedBranchId;
            }

            const total = parseInt(document.getElementById('tongTien').textContent.replace(/\D/g, ''));
            UI.confirm('Tiếp Tục Thanh Toán', 'Xác nhận thanh toán tổng cộng ' + formatCurrency(total) + '?',
                () => {
                    // Prepare checkout - INCLUDE ALL SELECTED ITEMS
                    let checkoutBody = 'action=prepareCheckout&loaiNhanXe=' + deliveryMethod;
                    
                    // Thêm danh sách các item được chọn với format flattened (không nested)
                    let itemCount = 0;
                    for (const maGoiThue in cartState) {
                        const state = cartState[maGoiThue];
                        if (!state.isSelected) continue;
                        
                        const batDauInput = document.getElementById('bd_' + maGoiThue)?.value || '';
                        const ketThucInput = document.getElementById('kt_' + maGoiThue)?.value || '';
                        
                        console.log('Adding item to checkout:', maGoiThue, 'batDau=' + batDauInput, 'ketThuc=' + ketThucInput);
                        
                        // Use flattened format that Java servlets can parse
                        checkoutBody += '&itemMaGoiThue_' + itemCount + '=' + encodeURIComponent(maGoiThue);
                        checkoutBody += '&itemBatDau_' + itemCount + '=' + encodeURIComponent(batDauInput);
                        checkoutBody += '&itemKetThuc_' + itemCount + '=' + encodeURIComponent(ketThucInput);
                        checkoutBody += '&itemSoLuong_' + itemCount + '=' + encodeURIComponent(state.soLuong);
                        
                        itemCount++;
                    }
                    
                    // Add total item count so backend knows how many items to process
                    checkoutBody += '&itemCount=' + itemCount;
                    
                    console.log('Final checkout body:', checkoutBody);
                    
                    if (deliveryMethod === 'custom') {
                        checkoutBody += '&diaChiNhanXe=' + encodeURIComponent(deliveryInfo);
                    } else {
                        checkoutBody += '&maChiNhanh=' + deliveryInfo;
                    }
                    
                    console.log('Before fetch - checkout body:', checkoutBody);
                    
                    fetch(ctx + '/khachhang/giohang', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
                        body: checkoutBody
                    })
                    .then(res => res.text())
                    .then(xml => {
                        const parser = new DOMParser();
                        const doc = parser.parseFromString(xml, 'application/xml');
                        const status = doc.querySelector('status').textContent;
                        
                        if (status === 'success') {
                            window.location.href = ctx + '/khachhang/thanhtoan';
                        } else {
                            UI.toast('Lỗi: ' + (doc.querySelector('message') ? escapeHtml(doc.querySelector('message').textContent) : 'Không xác định'), 'error', 3000);
                        }
                    })
                    .catch(e => {
                        console.error('[ERROR] checkout:', e);
                        UI.toast('Lỗi: ' + escapeHtml(e.message), 'error', 3000);
                    });
                },
                () => {}
            );
        }

        function goToDashboard() {
            window.location.href = ctx + '/khachhang/dashboard';
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount) + 'đ';
        }

        function escapeHtml(text) {
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text.replace(/[&<>"']/g, m => map[m]);
        }
        
        // Toggle item selection
        // Chọn/bỏ chọn tất cả mục hàng
        function toggleSelectAll() {
            const selectAllCheckbox = document.getElementById('selectAllCheckbox');
            const isChecked = selectAllCheckbox.checked;
            
            // Cập nhật trạng thái cho tất cả items
            Object.keys(cartState).forEach(maGoiThue => {
                cartState[maGoiThue].isSelected = isChecked;
                
                // Cập nhật checkbox
                const checkbox = document.getElementById('select_' + maGoiThue);
                if (checkbox) {
                    checkbox.checked = isChecked;
                }
                
                // Cập nhật styling card
                const card = document.getElementById('itemCard_' + maGoiThue);
                if (card) {
                    if (isChecked) {
                        card.style.borderColor = 'var(--color-primary)';
                        card.style.backgroundColor = 'rgba(16, 185, 129, 0.01)';
                    } else {
                        card.style.borderColor = 'var(--color-border-light)';
                        card.style.backgroundColor = 'white';
                    }
                }
            });
            
            calculateTotal();
            updateBranchList();
        }
        
        function toggleItemSelection(maGoiThue) {
            if (cartState[maGoiThue]) {
                cartState[maGoiThue].isSelected = !cartState[maGoiThue].isSelected;
                
                // Update card styling
                const card = document.getElementById('itemCard_' + maGoiThue);
                if (card) {
                    if (cartState[maGoiThue].isSelected) {
                        card.style.borderColor = 'var(--color-primary)';
                        card.style.backgroundColor = 'rgba(16, 185, 129, 0.01)';
                    } else {
                        card.style.borderColor = 'var(--color-border-light)';
                        card.style.backgroundColor = 'white';
                    }
                }
                
                // Update "select all" checkbox state
                updateSelectAllCheckbox();
                
                calculateTotal();
                updateBranchList();
            }
        }
        
        // Cập nhật trạng thái checkbox "Chọn tất cả"
        function updateSelectAllCheckbox() {
            const selectAllCheckbox = document.getElementById('selectAllCheckbox');
            const allItems = Object.keys(cartState);
            
            if (allItems.length === 0) {
                selectAllCheckbox.checked = false;
                selectAllCheckbox.indeterminate = false;
                return;
            }
            
            const selectedCount = allItems.filter(key => cartState[key].isSelected).length;
            
            if (selectedCount === 0) {
                selectAllCheckbox.checked = false;
                selectAllCheckbox.indeterminate = false;
            } else if (selectedCount === allItems.length) {
                selectAllCheckbox.checked = true;
                selectAllCheckbox.indeterminate = false;
            } else {
                selectAllCheckbox.checked = false;
                selectAllCheckbox.indeterminate = true;
            }
        }
        
        // Handle delivery method change
        function onDeliveryMethodChange() {
            const customSection = document.getElementById('customAddressSection');
            const branchSection = document.getElementById('branchSelectionSection');
            const isCustom = document.getElementById('deliveryCustom').checked;
            
            if (isCustom) {
                customSection.style.display = 'block';
                branchSection.style.display = 'none';
            } else {
                customSection.style.display = 'none';
                branchSection.style.display = 'block';
                updateBranchList();
            }
        }
        
        // Update and display branch list from selected items
        function updateBranchList() {
            const branchSet = new Map(); // Dùng Map để tránh duplicate
            
            console.log('=== updateBranchList called ===');
            console.log('cartState keys:', Object.keys(cartState));
            
            // Lấy danh sách chi nhánh từ các item được chọn
            Object.keys(cartState).forEach(maGoiThue => {
                const state = cartState[maGoiThue];
                console.log('Item:', maGoiThue, 'isSelected:', state.isSelected, 'branches count:', state.branches?.length || 0);
                
                if (state.isSelected && state.branches && state.branches.length > 0) {
                    state.branches.forEach(branch => {
                        console.log('Adding branch:', branch);
                        if (!branchSet.has(branch.maChiNhanh)) {
                            branchSet.set(branch.maChiNhanh, branch);
                        }
                    });
                }
            });
            
            console.log('Final branchSet size:', branchSet.size);
            
            const branchList = document.getElementById('branchList');
            let html = '';
            
            if (branchSet.size === 0) {
                html = '<p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0; text-align: center; padding: var(--spacing-md);">Không có chi nhánh nào khả dụng</p>';
            } else {
                branchSet.forEach((branch, maChiNhanh) => {
                    html += '<label style="display: flex; align-items: center; gap: var(--spacing-md); padding: var(--spacing-md); border: 1px solid var(--color-border); border-radius: 6px; cursor: pointer; transition: all 0.2s ease;\" ' +
                        'onmouseover="this.style.backgroundColor=\'rgba(16, 185, 129, 0.05)\'" ' +
                        'onmouseout="this.style.backgroundColor=\'transparent\'">' +
                        '<input type=\"radio\" name=\"selectedBranch\" value=\"' + maChiNhanh + '\" onchange=\"selectBranch(\'' + maChiNhanh + '\')\" style=\"cursor: pointer;\">' +
                        '<div style=\"flex: 1;\">' +
                        '<p style=\"font-size: var(--text-sm); font-weight: 600; margin: 0; color: var(--color-text-primary);\">' + escapeHtml(branch.tenChiNhanh) + '</p>' +
                        '<p style=\"font-size: var(--text-xs); color: var(--color-text-secondary); margin: 0;\">' + escapeHtml(branch.diaDiem) + '</p>' +
                        '</div>' +
                        '</label>';
                });
            }
            
            branchList.innerHTML = html;
        }
        
        // Select a branch for pickup
        function selectBranch(maChiNhanh) {
            window.selectedBranchId = maChiNhanh;
        }

        // Load on page load
        window.addEventListener('DOMContentLoaded', function() {
            console.log('=== PAGE LOAD - Cart Page ===');
            loadCart();
        });

        /**
         * Override confirmLogout to show data loss warning
         * Show warning that unsaved data will be lost
         */
        window.confirmLogout = function() {
            const ctx = '${pageContext.request.contextPath}';
            if (window.UI && window.UI.confirm) {
                UI.confirm(
                    'Đăng Xuất',
                    '⚠️ Tất cả dữ liệu giỏ hàng chưa lưu sẽ bị mất!\n\nBạn có chắc muốn đăng xuất?',
                    function() {
                        // User clicked Xác Nhận (Confirm)
                        window.location.href = ctx + '/logout';
                    }
                    // No callback for Cancel - just closes the dialog
                );
            } else {
                // Fallback to browser confirm
                if (confirm('⚠️ Tất cả dữ liệu giỏ hàng chưa lưu sẽ bị mất!\n\nBạn có chắc muốn đăng xuất?')) {
                    window.location.href = ctx + '/logout';
                }
            }
        };
    </script>
</body>
</html>
