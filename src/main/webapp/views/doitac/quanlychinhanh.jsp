<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="dao.ChiNhanhDAO, model.ChiNhanh, java.util.List" %>
<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    javax.servlet.http.HttpSession sess = request.getSession(false);
    if (sess == null || !"DOI_TAC".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/dangnhap"); return;
    }
    int maDoiTac = (Integer) sess.getAttribute("maDoiTac");

    String msg     = request.getParameter("msg");
    String msgType = request.getParameter("msgType");
    List<ChiNhanh> danhSach = new ChiNhanhDAO().layToanBoChiNhanh(maDoiTac);
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Chi Nhánh - Đối Tác</title>
    <link href="${pageContext.request.contextPath}/dist/tailwind.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/globals.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/components.css" rel="stylesheet">
    <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
    <style>
        /* Page-specific styles only */
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

        .form-card input,
        .form-card textarea,
        .form-card label {
            font-family: var(--font-primary);
        }

        .form-card input,
        .form-card textarea,
        .form-card select {
            font-size: 14px;
            line-height: 1.5;
        }

        .form-card label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: var(--spacing-sm);
            color: var(--color-text-primary);
            letter-spacing: 0.5px;
        }

        .form-card input:focus,
        .form-card textarea:focus,
        .form-card select:focus {
            border-color: var(--color-primary);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }

        .form-card select:disabled {
            background: #f3f4f6;
            color: #9ca3af;
            cursor: not-allowed;
        }

        .btn-disabled {
            opacity: 0.6;
            cursor: not-allowed;
            pointer-events: none;
        }

        .action-buttons {
            display: flex;
            gap: var(--spacing-sm);
            align-items: center;
        }

        .action-buttons button {
            padding: var(--spacing-xs) var(--spacing-md);
            border-radius: 4px;
            border: none;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.15s ease;
            cursor: pointer;
        }

        .btn-edit {
            background: #3b82f6;
            color: white;
        }

        .btn-edit:hover:not(.btn-disabled) {
            background: #2563eb;
        }

        .btn-delete {
            background: #ef4444;
            color: white;
        }

        .btn-delete:hover:not(.btn-disabled) {
            background: #dc2626;
        }

        .notification {
            position: fixed;
            top: 100px;
            right: 20px;
            max-width: 400px;
            padding: var(--spacing-lg);
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            display: none;
            z-index: 1000;
            animation: slideIn 0.3s ease-out;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .notification.show {
            display: block;
        }

        .notification.success {
            background: #ecfdf5;
            color: #047857;
            border-left: 4px solid #10b981;
        }

        .notification.error {
            background: #fef2f2;
            color: #991b1b;
            border-left: 4px solid #dc2626;
        }

        @keyframes slideIn {
            from {
                transform: translateX(450px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(450px);
                opacity: 0;
            }
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
                <div style="display: flex; align-items: center; justify-content: space-between; margin-top: var(--spacing-3xl); margin-bottom: var(--spacing-3xl);">
                    <h1 style="font-size: var(--text-3xl); font-weight: 700; margin: 0;">Quản Lý Chi Nhánh</h1>
          
                </div>

                <!-- Form Card -->
                <div class="form-card" style="margin-bottom: var(--spacing-3xl);">
                    <div style="display: flex; align-items: center; gap: var(--spacing-md); font-size: var(--text-lg); font-weight: 700; margin-bottom: var(--spacing-lg); color: var(--color-text-primary); padding-bottom: var(--spacing-md); border-bottom: 2px solid #e5e7eb;">
                        <iconify-icon icon="mdi:plus-circle" width="24" height="24" style="color: #10b981;"></iconify-icon>
                        <span>Thêm Chi Nhánh Mới</span>
                    </div>

                    <form id="formThemChiNhanh" method="post" action="<%= ctx %>/doitac/quanlychinhanh">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-lg); margin-bottom: var(--spacing-lg);">
                            <div>
                                <label for="tenChiNhanh">Tên Chi Nhánh *</label>
                                <input type="text" id="tenChiNhanh" name="tenChiNhanh" placeholder="Chi Nhánh Trung Tâm" maxlength="100" required style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;" />
                            </div>
                            <div>
                                <label for="tinh">Tỉnh/Thành Phố *</label>
                                <select id="tinh" name="tinh" required style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;">
                                    <option value="">-- Chọn Tỉnh/Thành Phố --</option>
                                </select>
                            </div>
                            <div>
                                <label for="xa">Xã/Phường *</label>
                                <select id="xa" name="xa" required disabled style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;">
                                    <option value="">-- Chọn Xã/Phường --</option>
                                </select>
                            </div>
                            <div style="grid-column: 1 / -1;">
                                <label for="diaDiemChiTiet">Địa Chỉ Cụ Thể (Số nhà, Ngõ, Đường...) *</label>
                                <textarea id="diaDiemChiTiet" name="diaDiemChiTiet" placeholder="VD: Số 123, Ngõ Giang Võ, Khu A..." maxlength="200" required style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease; resize: vertical; min-height: 80px;"></textarea>
                            </div>
                            </div>
                        </div>
                        <div style="display: flex; gap: var(--spacing-md); margin-bottom: var(--spacing-2xl);">
                            <button type="submit" style="background: #10b981; color: white; padding: var(--spacing-sm) var(--spacing-md); border: none; border-radius: 6px; font-family: inherit; font-size: 12px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; text-decoration: none; transition: all 0.15s ease;">
                                <iconify-icon icon="mdi:plus" width="14" height="14"></iconify-icon>
                                Thêm Chi Nhánh
                            </button>
                            <button type="reset" style="background: #f9fafb; color: var(--color-text-primary); padding: var(--spacing-sm) var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 12px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; text-decoration: none; transition: all 0.15s ease;">
                                Làm lại
                            </button>
                        </div>
                    </form>

                    <!-- Notification -->
                    <div id="notification" class="notification"></div>

                    <!-- Table Section -->
                    <div style="background: white; border-radius: 12px; padding: var(--spacing-lg); border: 1px solid #e5e7eb; box-shadow: 0 1px 3px rgba(0,0,0,0.08);">
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: var(--spacing-lg); padding-bottom: var(--spacing-lg); border-bottom: 1px solid #e5e7eb;">
                            <h2 style="font-size: 16px; font-weight: 700; color: var(--color-text-primary); margin: 0;">Danh Sách Chi Nhánh</h2>
                        </div>

                        <div style="overflow-x: auto;">
                        <% if (danhSach.isEmpty()) { %>
                            <div style="text-align: center; padding: var(--spacing-3xl); color: #6b7280; font-size: 14px;">
                                <iconify-icon icon="mdi:inbox-outline" width="48" height="48" style="display: block; margin: 0 auto var(--spacing-md); opacity: 0.4;"></iconify-icon>
                                Chưa có chi nhánh nào. Hãy thêm chi nhánh đầu tiên!
                            </div>
                        <% } else { %>
                            <table style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr style="background: #f9fafb;">
                                        <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981; width: 50px;">#</th>
                                        <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981; width: 100px;">Mã CN</th>
                                        <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981;">Tên Chi Nhánh</th>
                                        <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981;">Địa Điểm</th>
                                        <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981; width: 150px;">Hành Động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% int stt = 1; for (ChiNhanh cn : danhSach) { %>
                                    <tr class="table-row" style="border-bottom: 1px solid #e5e7eb;">
                                        <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 14px; color: var(--color-text-primary);"><span style="display: inline-block; padding: var(--spacing-xs) var(--spacing-md); background: #10b981; color: white; border-radius: 6px; font-size: 11px; font-weight: 700; letter-spacing: 0.3px;"><%= stt++ %></span></td>
                                        <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 13px; color: #6b7280;">#<%= cn.getMaChiNhanh() %></td>
                                        <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 14px; color: var(--color-text-primary);"><strong><%= esc(cn.getTenChiNhanh()) %></strong></td>
                                        <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 13px; color: #6b7280;"><%= esc(cn.getDiaDiem()) %></td>
                                        <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 13px;">
                                            <div class="action-buttons">
                                                <button type="button" class="btn-edit btn-disabled" title="Tính năng đang được phát triển">
                                                    <iconify-icon icon="mdi:pencil" width="14" height="14"></iconify-icon>
                                                    Sửa
                                                </button>
                                                <button type="button" class="btn-delete btn-disabled" title="Tính năng đang được phát triển">
                                                    <iconify-icon icon="mdi:trash-can" width="14" height="14"></iconify-icon>
                                                    Xóa
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                        </div>
                    </div>
            </section>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>
</body>
<script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
<script>
    const API_BASE = 'https://provinces.open-api.vn/api/v2/';
    let allProvincesData = null;
    let allDistrictsData = null;

    // Load danh sách tỉnh và xã khi trang load
    async function loadProvinces() {
        try {
            console.log('=== LOAD PROVINCES & DISTRICTS ===');
            
            // Load provinces
            console.log('Loading provinces from:', API_BASE + 'p/');
            const provincesResponse = await fetch(API_BASE + 'p/');
            console.log('Provinces response status:', provincesResponse.status);
            
            if (!provincesResponse.ok) {
                throw new Error(`Provinces HTTP ${provincesResponse.status}`);
            }
            
            const provincesData = await provincesResponse.json();
            let provincesList = Array.isArray(provincesData) ? provincesData : (provincesData.data || []);
            
            if (!Array.isArray(provincesList) || provincesList.length === 0) {
                throw new Error('Danh sách tỉnh trống');
            }
            
            allProvincesData = provincesList;
            console.log('✓ Loaded', allProvincesData.length, 'provinces');
            
            // Load districts
            console.log('Loading districts from:', API_BASE + 'w/');
            const districtsResponse = await fetch(API_BASE + 'w/');
            console.log('Districts response status:', districtsResponse.status);
            
            if (!districtsResponse.ok) {
                throw new Error(`Districts HTTP ${districtsResponse.status}`);
            }
            
            const districtsData = await districtsResponse.json();
            let districtsList = Array.isArray(districtsData) ? districtsData : (districtsData.data || []);
            
            if (!Array.isArray(districtsList) || districtsList.length === 0) {
                throw new Error('Danh sách xã/phường trống');
            }
            
            allDistrictsData = districtsList;
            console.log('✓ Loaded', allDistrictsData.length, 'districts');
            console.log('First district sample:', allDistrictsData[0]);
            
            // Populate select tỉnh
            const tinhSelect = document.getElementById('tinh');
            if (!tinhSelect) {
                throw new Error('Không tìm thấy element #tinh');
            }
            
            tinhSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành Phố --</option>';
            
            allProvincesData.forEach((province, idx) => {
                const option = document.createElement('option');
                option.value = province.code;
                option.textContent = province.name;
                option.dataset.name = province.name;
                tinhSelect.appendChild(option);
                if (idx < 5) console.log(`  [${idx + 1}] ${province.name} (${province.code})`);
            });
            if (allProvincesData.length > 5) console.log(`  ... and ${allProvincesData.length - 5} more`);
            
            console.log('✓ Populated province select\n');
            
        } catch (error) {
            console.error('❌ Lỗi loadProvinces:', error.message);
            showNotification('Lỗi tải dữ liệu: ' + error.message, 'error', 7000);
        }
    }

    // Khi chọn tỉnh, hiển thị danh sách xã/phường của tỉnh đó
    document.getElementById('tinh').addEventListener('change', function() {
        const selectedCode = this.value;
        const xaSelect = document.getElementById('xa');
        
        console.log('=== PROVINCE SELECTED ===');
        console.log('Selected province code:', selectedCode);
        
        if (!selectedCode) {
            xaSelect.disabled = true;
            xaSelect.innerHTML = '<option value="">-- Chọn Xã/Phường --</option>';
            return;
        }

        try {
            // Filter districts by province_code
            const filteredDistricts = allDistrictsData.filter(d => d.province_code === selectedCode || d.province_code == selectedCode);
            
            console.log('Filtered districts for province', selectedCode, ':', filteredDistricts.length);
            if (filteredDistricts.length > 0) {
                console.log('First district:', filteredDistricts[0]);
            }
            
            if (!Array.isArray(filteredDistricts) || filteredDistricts.length === 0) {
                throw new Error('Tỉnh này không có dữ liệu xã/phường');
            }
            
            xaSelect.disabled = false;
            xaSelect.innerHTML = '<option value="">-- Chọn Xã/Phường --</option>';
            
            console.log('✓ Loaded', filteredDistricts.length, 'districts for province:', selectedCode);
            
            filteredDistricts.forEach(district => {
                const option = document.createElement('option');
                option.value = district.code;
                option.textContent = district.name;
                option.dataset.name = district.name;
                xaSelect.appendChild(option);
            });
            
            console.log('✓ Populated district select\n');
            
        } catch (error) {
            console.error('❌ Lỗi load districts:', error.message);
            xaSelect.disabled = true;
            xaSelect.innerHTML = '<option value="">-- ' + error.message + ' --</option>';
        }
    });

    // Helper function để hiển thị notification
    function showNotification(message, type = 'error', duration = 5000) {
        const notification = document.getElementById('notification');
        if (notification) {
            notification.innerHTML = message;
            notification.className = 'notification show ' + type;
            setTimeout(() => {
                notification.classList.add('slideOut');
                setTimeout(() => {
                    notification.classList.remove('show', 'slideOut');
                }, 300);
            }, duration);
        }
    }

    // Submit form
    document.getElementById('formThemChiNhanh').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const tenChiNhanh = document.getElementById('tenChiNhanh').value.trim();
        const tinhSelect = document.getElementById('tinh');
        const xaSelect = document.getElementById('xa');
        const diaDiemChiTiet = document.getElementById('diaDiemChiTiet').value.trim();
        
        console.log('=== FORM SUBMIT ===');
        console.log('tenChiNhanh:', tenChiNhanh);
        console.log('tinhSelect.selectedIndex:', tinhSelect.selectedIndex);
        console.log('xaSelect.selectedIndex:', xaSelect.selectedIndex);
        console.log('diaDiemChiTiet:', diaDiemChiTiet);
        
        // Validation
        if (!tenChiNhanh) {
            showNotification('Tên chi nhánh không được để trống', 'error');
            return;
        }
        
        if (!tinhSelect.value) {
            showNotification('Vui lòng chọn Tỉnh/Thành Phố', 'error');
            return;
        }
        
        if (!xaSelect.value) {
            showNotification('Vui lòng chọn Xã/Phường', 'error');
            return;
        }
        
        if (!diaDiemChiTiet) {
            showNotification('Vui lòng nhập địa chỉ cụ thể', 'error');
            return;
        }
        
        // Lấy selected options
        const selectedTinhOption = tinhSelect.options[tinhSelect.selectedIndex];
        const selectedXaOption = xaSelect.options[xaSelect.selectedIndex];
        
        console.log('selectedTinhOption:', selectedTinhOption);
        console.log('selectedXaOption:', selectedXaOption);
        
        // Lấy tên tỉnh và xã - sử dụng textContent là cách an toàn nhất
        const tinhName = selectedTinhOption.textContent.trim();
        const xaName = selectedXaOption.textContent.trim();
        
        console.log('tinhName extracted:', tinhName);
        console.log('xaName extracted:', xaName);
        
        // Validate names are not empty
        if (!tinhName || tinhName === '-- Chọn Tỉnh/Thành Phố --') {
            showNotification('Tên tỉnh không hợp lệ', 'error');
            return;
        }
        
        if (!xaName || xaName === '-- Chọn Xã/Phường --') {
            showNotification('Tên xã không hợp lệ', 'error');
            return;
        }
        
        // Ghép địa chỉ: Xã/Phường, Tỉnh, Địa chỉ cụ thể
        const fullAddress =  diaDiemChiTiet + ', ' +xaName + ', ' + tinhName ;
        
        console.log('Building address:');
        console.log('  diaDiemChiTiet:', diaDiemChiTiet);
        console.log('  xaName:', xaName);
        console.log('  tinhName:', tinhName);
        console.log('fullAddress result:', fullAddress);
        console.log('fullAddress length:', fullAddress.length);
        
        // Create URL encoded form data
        const params = new URLSearchParams();
        params.append('tenChiNhanh', tenChiNhanh);
        params.append('diaDiem', fullAddress);
        
        console.log('URLSearchParams diaDiem:', params.get('diaDiem'));
        console.log('Sending POST to: <%= ctx %>/doitac/quanlychinhanh');
        
        fetch('<%= ctx %>/doitac/quanlychinhanh', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
            },
            body: params.toString(),
            credentials: 'same-origin'
        })
        .then(response => {
            console.log('Response status:', response.status);
            return response.text();
        })
        .then(data => {
            console.log('Response data:', data);
            
            // Parse XML response
            const parser = new DOMParser();
            const xmlDoc = parser.parseFromString(data, 'text/xml');
            
            const statusElement = xmlDoc.getElementsByTagName('status')[0];
            const messageElement = xmlDoc.getElementsByTagName('message')[0];
            
            if (statusElement && messageElement) {
                const status = statusElement.textContent;
                const message = messageElement.textContent;
                
                console.log('Status:', status, 'Message:', message);
                
                showNotification(message, status, 5000);
                
                // Reset form if success
                if (status === 'success') {
                    document.getElementById('formThemChiNhanh').reset();
                    document.getElementById('xa').disabled = true;
                    // Reload page to see new entry
                    setTimeout(() => {
                        location.reload();
                    }, 1500);
                }
            } else {
                console.error('Could not parse XML response');
                showNotification('Lỗi: Phản hồi không hợp lệ', 'error');
            }
        })
        .catch(error => {
            console.error('Fetch error:', error);
            showNotification('Lỗi: ' + error.message, 'error');
        });
    });

    // Load provinces on page load
    window.addEventListener('DOMContentLoaded', async function() {
        console.log('=== PAGE LOAD - Initializing ===');
        await loadProvinces();
        console.log('=== Initialization Complete ===\n');
    });
</script>
</html>
