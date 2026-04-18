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
    <title>Dashboard - ThueXeMay Khách Hàng</title>
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
                
                <!-- Hero Banner -->
            <div style="background: url('${pageContext.request.contextPath}/public/img/backgroud2.jpg') bottom/cover no-repeat; border-radius: 12px; padding: var(--spacing-3xl); margin-bottom: var(--spacing-3xl); color: white; position: relative; min-height: 250px; display: flex; align-items: center;">
                <div style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.4); border-radius: 12px;"></div>
                <div style="position: relative; z-index: 1;">
                    <h1 style="font-size: var(--text-3xl); font-weight: 700; margin: 0 0 var(--spacing-md) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                        ĐẾN MOTOBOOK 
                    </h1>
                    <p style="font-size: var(--text-lg); margin: 0;">Tìm kiếm, đặt thuê dễ dàng, uy tín, chất lượng</p>
                </div>
            </div>
            
            <div class="app-container" style="display: flex; flex-direction: column; gap: var(--spacing-2xl); margin-bottom: var(--spacing-3xl);">
                
                <!-- Filter Section -->
                <section style="background: white; border: 1px solid #e5e7eb; border-radius: 12px; padding: var(--spacing-lg);">
                    <h2 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                        <iconify-icon icon="mdi:funnel" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                        Bộ Lọc Gói Thuê
                    </h2>
                    <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0 0 var(--spacing-lg) 0;">Vui lòng chọn xã/phường, tỉnh thành phố nơi bạn muốn thuê</p>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--spacing-lg); margin-bottom: var(--spacing-lg);">
                        <!-- Location Filter: Province -->
                        <div>
                            <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary);">Tỉnh/Thành Phố</label>
                            <select id="tinhFilter" style="width: 100%; padding: var(--spacing-sm); border: 1px solid #e5e7eb; border-radius: 6px; font-size: 14px; cursor: pointer;">
                                <option value="">-- Chọn Tỉnh --</option>
                            </select>
                        </div>
                        
                        <!-- Location Filter: Ward -->
                        <div>
                            <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary);">Xã/Phường</label>
                            <select id="xaFilter" style="width: 100%; padding: var(--spacing-sm); border: 1px solid #e5e7eb; border-radius: 6px; font-size: 14px; cursor: pointer;" disabled>
                                <option value="">-- Chọn Xã --</option>
                            </select>
                        </div>
                        
                        <!-- Price Filter: Type -->
                        <div>
                            <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary);">Loại Giá</label>
                            <select id="priceTypeFilter" style="width: 100%; padding: var(--spacing-sm); border: 1px solid #e5e7eb; border-radius: 6px; font-size: 14px; cursor: pointer;">
                                <option value="">-- Tất Cả --</option>
                                <option value="day">Giá Theo Ngày</option>
                                <option value="hour">Giá Theo Giờ</option>
                            </select>
                        </div>
                        
                        <!-- Price Filter: Min -->
                        <div>
                            <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary);">Từ Giá (₫)</label>
                            <input type="number" id="minPriceFilter" style="width: 100%; padding: var(--spacing-sm); border: 1px solid #e5e7eb; border-radius: 6px; font-size: 14px;" placeholder="Từ giá">
                        </div>
                        
                        <!-- Price Filter: Max -->
                        <div>
                            <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary);">Đến Giá (₫)</label>
                            <input type="number" id="maxPriceFilter" style="width: 100%; padding: var(--spacing-sm); border: 1px solid #e5e7eb; border-radius: 6px; font-size: 14px;" placeholder="Đến giá">
                        </div>
                    </div>
                    
                    <div style="display: flex; gap: var(--spacing-md); justify-content: flex-end;">
                        <button onclick="resetFilters()" style="padding: var(--spacing-sm) var(--spacing-lg); background: #f3f4f6; color: #1f2937; border: 1px solid #e5e7eb; border-radius: 6px; font-weight: 600; cursor: pointer; transition: all 0.2s ease;" 
                                onmouseover="this.style.background='#e5e7eb'" onmouseout="this.style.background='#f3f4f6'">
                            <iconify-icon icon="mdi:refresh" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 4px;"></iconify-icon>
                            Reset Bộ Lọc
                        </button>
                    </div>
                </section>

                <!-- Quick Actions / Featured Packages -->
                <section>
                    <h2 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                        <iconify-icon icon="mdi:star" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                        Gói Thuê Nổi Bật
                    </h2>
                    <div id="goiThueContainer" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: var(--spacing-lg);">
                        <!-- Packages will be loaded here -->
                    </div>
                </section>
            </div>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>

    <!-- Modal: Thêm vào giỏ hàng -->
    <div id="addToCartModal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); z-index: 9999; align-items: center; justify-content: center;">
        <div style="background: white; border-radius: 12px; padding: var(--spacing-2xl); max-width: 500px; width: 90%; box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);">
            <!-- Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--spacing-lg);">
                <h2 style="font-size: var(--text-xl); font-weight: 700; margin: 0; display: flex; align-items: center; gap: var(--spacing-md);">
                    <iconify-icon icon="mdi:plus-circle" style="width: 24px; height: 24px; color: var(--color-primary);"></iconify-icon>
                    Thêm Vào Giỏ Hàng
                </h2>
                <button onclick="closeAddToCartModal()" style="background: none; border: none; cursor: pointer; font-size: 24px; color: #999;">×</button>
            </div>

            <!-- Package Info -->
            <div id="packageInfo" style="background: var(--color-bg-secondary); border-radius: 8px; padding: var(--spacing-lg); margin-bottom: var(--spacing-lg);">
                <p id="packageName" style="margin: 0; font-weight: 600; color: var(--color-text-primary); font-size: var(--text-base);"></p>
                <p id="packageBrand" style="margin: var(--spacing-xs) 0 0 0; color: var(--color-primary); font-size: var(--text-sm);"></p>
            </div>

            <!-- Form Fields -->
            <div style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                
                <!-- Start Time -->
                <div>
                    <label style="display: block; font-weight: 600; margin-bottom: var(--spacing-sm); color: var(--color-text-primary);">
                        Thời Gian Thuê
                        <span style="color: var(--color-danger);">*</span>
                    </label>
                    <input type="datetime-local" id="modalBatDau" 
                           style="width: 100%; padding: var(--spacing-sm); border: 1px solid var(--color-border-light); border-radius: 6px; font-size: 14px; box-sizing: border-box;"
                           onchange="onModalTimeChange()">
                </div>

                <!-- End Time -->
                <div>
                    <label style="display: block; font-weight: 600; margin-bottom: var(--spacing-sm); color: var(--color-text-primary);">
                        Thời Gian Trả
                        <span style="color: var(--color-danger);">*</span>
                    </label>
                    <input type="datetime-local" id="modalKetThuc" 
                           style="width: 100%; padding: var(--spacing-sm); border: 1px solid var(--color-border-light); border-radius: 6px; font-size: 14px; box-sizing: border-box;"
                           onchange="onModalTimeChange()">
                </div>

                <!-- Quantity -->
                <div>
                    <label style="display: block; font-weight: 600; margin-bottom: var(--spacing-sm); color: var(--color-text-primary);">
                        Số Lượng
                        <span style="color: var(--color-danger);">*</span>
                    </label>
                    <input type="number" id="modalSoLuong" value="1" min="1" 
                           style="width: 100%; padding: var(--spacing-sm); border: 1px solid var(--color-border-light); border-radius: 6px; font-size: 14px; box-sizing: border-box;"
                           onchange="onModalQuantityChange()" oninput="onModalQuantityChange()">
                </div>

                <!-- Availability Check Result -->
                <div id="availabilityResult" style="display: none; background: #f0fdf4; border: 1px solid #86efac; border-radius: 6px; padding: var(--spacing-md); color: #166534; font-size: var(--text-sm);">
                    <p style="margin: 0; font-weight: 600;">
                        <iconify-icon icon="mdi:check-circle" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 4px;"></iconify-icon>
                        Xe Còn Trống: <span id="availableCount">0</span>/<span id="totalCount">0</span>
                    </p>
                </div>

                <!-- Error Message -->
                <div id="errorMessage" style="display: none; background: #fee2e2; border: 1px solid #fca5a5; border-radius: 6px; padding: var(--spacing-md); color: #991b1b; font-size: var(--text-sm);">
                    <p style="margin: 0; font-weight: 600;">
                        <iconify-icon icon="mdi:alert-circle" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 4px;"></iconify-icon>
                        <span id="errorText"></span>
                    </p>
                </div>
            </div>

            <!-- Action Buttons -->
            <div style="display: flex; gap: var(--spacing-md); margin-top: var(--spacing-2xl); justify-content: flex-end;">
                <button onclick="closeAddToCartModal()" 
                        style="padding: var(--spacing-md) var(--spacing-lg); background: white; color: var(--color-text-primary); border: 1px solid var(--color-border-light); border-radius: 6px; font-weight: 600; cursor: pointer; transition: all 0.2s ease;"
                        onmouseover="this.style.background='var(--color-bg-secondary)'"
                        onmouseout="this.style.background='white'">
                    Hủy
                </button>
                <button onclick="confirmAddToCart()" 
                        style="padding: var(--spacing-md) var(--spacing-lg); background: var(--color-primary); color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; transition: all 0.2s ease; display: flex; align-items: center; gap: var(--spacing-sm);"
                        onmouseover="this.style.background='var(--color-primary-dark)'; this.style.opacity='0.9'"
                        onmouseout="this.style.background='var(--color-primary)'; this.style.opacity='1'">
                    <iconify-icon icon="mdi:check" style="width: 18px; height: 18px;"></iconify-icon>
                    Thêm Vào Giỏ
                </button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/ui-utils.js"></script>
    <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
    <script>
        const ctx = '<%=ctxPath%>';
        const API_BASE = 'https://provinces.open-api.vn/api/v2/';
        let allProvincesData = null;
        let allDistrictsData = null;

        // Load provinces and wards on page load
        async function loadProvinceAndWardData() {
            try {
                console.log('=== LOAD PROVINCES & DISTRICTS (Dashboard) ===');
                
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
                
                // Populate province select - use CODE as value (not name!)
                const tinhSelect = document.getElementById('tinhFilter');
                if (!tinhSelect) {
                    throw new Error('Không tìm thấy element #tinhFilter');
                }
                
                tinhSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành Phố --</option>';
                
                allProvincesData.forEach((province, idx) => {
                    const option = document.createElement('option');
                    option.value = province.code;  // CODE is the key!
                    option.textContent = province.name;
                    option.dataset.name = province.name;  // Store name for display
                    tinhSelect.appendChild(option);
                    if (idx < 3) console.log(`  [${idx + 1}] ${province.name} (${province.code})`);
                });
                if (allProvincesData.length > 3) console.log(`  ... and ${allProvincesData.length - 3} more`);
                
                console.log('✓ Populated province select\n');
                
            } catch (error) {
                console.error('❌ Lỗi loadProvinceAndWardData:', error.message);
                alert('Lỗi tải dữ liệu tỉnh/xã: ' + error.message);
            }
        }

        // Handle province selection - filter wards by province_code (using addEventListener)
        function handleTinhChange() {
            const tinhSelect = document.getElementById('tinhFilter');
            const xaSelect = document.getElementById('xaFilter');
            const selectedCode = tinhSelect.value;
            
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
                    option.value = district.code;  // CODE is the key!
                    option.textContent = district.name;
                    option.dataset.name = district.name;  // Store name for building address
                    xaSelect.appendChild(option);
                });
                
                console.log('✓ Populated district select\n');
                
            } catch (error) {
                console.error('❌ Lỗi load districts:', error.message);
                xaSelect.disabled = true;
                xaSelect.innerHTML = '<option value="">-- ' + error.message + ' --</option>';
            }
        }

        // Attach event listeners to all filter elements
        document.addEventListener('DOMContentLoaded', function() {
            const tinhSelect = document.getElementById('tinhFilter');
            if (tinhSelect) {
                tinhSelect.addEventListener('change', handleTinhChange);
            }
            
            const xaSelect = document.getElementById('xaFilter');
            if (xaSelect) {
                xaSelect.addEventListener('change', handleFilterChange);
            }
            
            const priceTypeSelect = document.getElementById('priceTypeFilter');
            if (priceTypeSelect) {
                priceTypeSelect.addEventListener('change', handleFilterChange);
            }
            
            const minPriceInput = document.getElementById('minPriceFilter');
            if (minPriceInput) {
                minPriceInput.addEventListener('change', handleFilterChange);
            }
            
            const maxPriceInput = document.getElementById('maxPriceFilter');
            if (maxPriceInput) {
                maxPriceInput.addEventListener('change', handleFilterChange);
            }
        });

        // Handle any filter change
        function handleFilterChange() {
            loadFilteredGoiThue();
        }

        // Load filtered packages - build proper location string for matching
        function loadFilteredGoiThue() {
            const tinhCode = document.getElementById('tinhFilter').value;
            const xaCode = document.getElementById('xaFilter').value;
            const priceType = document.getElementById('priceTypeFilter').value;
            const minPrice = document.getElementById('minPriceFilter').value;
            const maxPrice = document.getElementById('maxPriceFilter').value;

            // Build location string in format: "Xã/Phường_Name, Tỉnh_Name"
            let locationFilter = '';
            if (xaCode && tinhCode) {
                const xaOption = document.querySelector('#xaFilter option[value="' + xaCode + '"]');
                const tinhOption = document.querySelector('#tinhFilter option[value="' + tinhCode + '"]');
                
                if (xaOption && tinhOption) {
                    const xaName = xaOption.dataset.name || xaOption.textContent;
                    const tinhName = tinhOption.dataset.name || tinhOption.textContent;
                    locationFilter = xaName + ', ' + tinhName;  // Format: "Xã/Phường, Tỉnh"
                    console.log('Location filter string:', locationFilter);
                }
            }

            // Check if any filter is selected - if not, show message
            if (!locationFilter && !priceType && !minPrice && !maxPrice) {
                const goiThueContainer = document.getElementById('goiThueContainer');
                goiThueContainer.innerHTML = '<div style="grid-column: 1 / -1; text-align: center; padding: var(--spacing-2xl); color: var(--color-text-secondary);"><iconify-icon icon="mdi:information-outline" style="width: 48px; height: 48px; color: #9ca3af; margin-bottom: var(--spacing-md);"></iconify-icon><p style="margin: 0;">Vui lòng chọn bộ lọc để tìm kiếm gói thuê</p></div>';
                return;
            }

            // Build query parameters
            let queryParams = ctx + '/khachhang/danhsachgoithue?api=list';
            
            if (locationFilter) queryParams += '&diaDiem=' + encodeURIComponent(locationFilter);
            if (priceType) queryParams += '&priceType=' + priceType;
            if (minPrice) queryParams += '&minPrice=' + minPrice;
            if (maxPrice) queryParams += '&maxPrice=' + maxPrice;

            console.log('Fetching:', queryParams);

            fetch(queryParams)
                .then(res => res.text())
                .then(xml => {
                    console.log('[FILTER] Raw response length:', xml.length);
                    console.log('[FILTER] Raw response preview:', xml.substring(0, 500));
                    
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(xml, 'application/xml');
                    
                    // Check for error
                    if (doc.querySelector('error')) {
                        console.error('Error:', doc.querySelector('error').textContent);
                        renderPackages([]);
                        return;
                    }

                    // Get packages
                    const packages = Array.from(doc.querySelectorAll('goiThue'));
                    console.log('[FILTER] Total packages found:', packages.length);
                    console.log('[FILTER] Packages:', packages);
                    renderPackages(packages);
                })
                .catch(e => {
                    console.error('Error loading packages:', e);
                    renderPackages([]);
                });
        }

        // Render filtered packages
        function renderPackages(packages) {
            const goiThueContainer = document.getElementById('goiThueContainer');
            
            if (packages.length === 0) {
                goiThueContainer.innerHTML = '<div style="grid-column: 1 / -1; text-align: center; padding: var(--spacing-2xl); color: var(--color-text-secondary);"><iconify-icon icon="mdi:inbox-outline" style="width: 48px; height: 48px; color: #9ca3af; margin-bottom: var(--spacing-md);"></iconify-icon><p style="margin: 0;">Không tìm thấy gói thuê phù hợp</p></div>';
                return;
            }

            let html = '';
            packages.forEach(pkg => {
                const maGoiThue = pkg.querySelector('maGoiThue')?.textContent || '';
                const tenGoiThue = pkg.querySelector('tenGoiThue')?.textContent || '';
                const hangXe = pkg.querySelector('hangXe')?.textContent || '';
                const dongXe = pkg.querySelector('dongXe')?.textContent || '';
                const giaNgay = parseFloat(pkg.querySelector('giaNgay')?.textContent || '0').toLocaleString('vi-VN');
                const giaTuan = parseFloat(pkg.querySelector('giaTuan')?.textContent || '0').toLocaleString('vi-VN');
                const phuKien = pkg.querySelector('phuKien')?.textContent || '';
                const urlHinhAnh = pkg.querySelector('urlHinhAnh')?.textContent || '';
                
                const imageHtml = urlHinhAnh ? 
                    `<img src="` + ctx + urlHinhAnh + `" style="width: 100%; height: 100%; object-fit: cover;" alt="` + escapeHtml(tenGoiThue) + `">` :
                    `<iconify-icon icon="mdi:motorcycle" style="width: 32px; height: 32px; color: var(--color-primary);"></iconify-icon>`;

                html += `
                    <div class="card" style="padding: 0; overflow: hidden; display: flex; flex-direction: column;">
                        <div style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); height: 160px; text-align: center; display: flex; align-items: center; justify-content: center; position: relative;">
                            ` + imageHtml + `
                        </div>
                        <div style="padding: var(--spacing-lg); display: flex; flex-direction: column; gap: var(--spacing-md); flex: 1;">
                            <div>
                                <div style="font-size: 12px; color: #10b981; text-transform: uppercase; font-weight: 600; margin-bottom: 4px;">` + escapeHtml(hangXe) + ` - ` + escapeHtml(dongXe) + `</div>
                                <h3 style="font-weight: 700; margin: 0 0 var(--spacing-xs) 0; color: var(--color-text-primary);">` + escapeHtml(tenGoiThue) + `</h3>
                                <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0 0 var(--spacing-md) 0;">` + escapeHtml(phuKien) + `</p>
                            </div>
                            <div style="border-top: 1px solid var(--color-border-light); padding-top: var(--spacing-md); margin-top: auto;">
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md); margin-bottom: var(--spacing-md);">
                                    <div>
                                        <p style="font-size: 11px; color: var(--color-text-secondary); text-transform: uppercase; margin: 0 0 4px 0; font-weight: 600;">Giá Ngày</p>
                                        <p style="font-size: var(--text-lg); font-weight: 700; color: var(--color-primary); margin: 0;">` + giaNgay + `đ</p>
                                    </div>
                                    <div>
                                        <p style="font-size: 11px; color: var(--color-text-secondary); text-transform: uppercase; margin: 0 0 4px 0; font-weight: 600;">Giá Tuần</p>
                                        <p style="font-size: var(--text-lg); font-weight: 700; color: var(--color-primary); margin: 0;">` + giaTuan + `đ</p>
                                    </div>
                                </div>
                                <button class="btn btn-primary" style="width: 100%; padding: var(--spacing-md); font-size: var(--text-sm);" onclick="addToCart(` + maGoiThue + `)">
                                    <iconify-icon icon="mdi:plus-circle" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 4px;"></iconify-icon>
                                    Thêm Vào Giỏ hàng
                                </button>
                            </div>
                        </div>
                    </div>
                `;
            });

            goiThueContainer.innerHTML = html;
        }

        // Reset filters
        function resetFilters() {
            document.getElementById('tinhFilter').value = '';
            document.getElementById('xaFilter').value = '';
            document.getElementById('xaFilter').disabled = true;
            document.getElementById('priceTypeFilter').value = '';
            document.getElementById('minPriceFilter').value = '';
            document.getElementById('maxPriceFilter').value = '';
            loadGoiThue();  // Load featured packages instead of filtered (empty)
        }

        // Load featured packages (no filter)
        function loadGoiThue() {
            fetch(ctx + '/khachhang/danhsachgoithue?api=1')
                .then(res => res.text())
                .then(xml => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(xml, 'application/xml');
                    const container = document.getElementById('goiThueContainer');
                    
                    let html = '';
                    let idx = 0;
                    doc.querySelectorAll('goiThue').forEach((gt) => {
                        if (idx >= 6) return; // Show only 6 items
                        idx++;
                        
                        const maGoiThue = gt.querySelector('maGoiThue').textContent;
                        const tenGoiThue = gt.querySelector('tenGoiThue').textContent;
                        const moTa = gt.querySelector('moTa')?.textContent || 'Gói thuê tiêu chuẩn';
                        const giaTien = parseFloat(gt.querySelector('giaTien')?.textContent || '0').toLocaleString('vi-VN');
                        const urlHinhAnh = gt.querySelector('urlHinhAnh')?.textContent || '';
                        
                        const imageHtml = urlHinhAnh ? 
                    `<img src="` + ctx + urlHinhAnh + `" style="width: 100%; height: 100%; object-fit: cover;" alt="` + tenGoiThue + `">` :
                        
                        html += `
                            <div class="card" style="padding: 0; overflow: hidden; display: flex; flex-direction: column;">
                                <div style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); height: 180px; text-align: center; display: flex; align-items: center; justify-content: center; overflow: hidden; position: relative;">
                                    ` + imageHtml + `
                                </div>
                                <div style="padding: var(--spacing-lg);">
                                <h3 style="font-weight: 700; margin: 0 0 var(--spacing-xs) 0; color: var(--color-text-primary);">${tenGoiThue}</h3>
                                <p style="font-size: var(--text-sm); color: var(--color-text-secondary); margin: 0 0 var(--spacing-md) 0;">${moTa}</p>
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: auto; padding-top: var(--spacing-md); border-top: 1px solid var(--color-border-light);">
                                    <p style="font-size: var(--text-lg); font-weight: 700; color: var(--color-primary); margin: 0;">${giaTien} VNĐ</p>
                                    <a href="<%=ctxPath%>/khachhang/danhsachgoithue" class="btn btn-primary" style="padding: var(--spacing-sm) var(--spacing-md); font-size: var(--text-sm);">
                                        Chi Tiết
                                    </a>
                                </div>
                                </div>
                            </div>
                        `;
                    });
                    
                    if (html === '') {
                        container.innerHTML = '<p style="grid-column: 1 / -1; text-align: center; color: var(--color-text-secondary);">Chưa có gói thuê nào</p>';
                    } else {
                        container.innerHTML = html;
                    }
                })
                .catch(e => {
                    console.error('Error loading packages:', e);
                    document.getElementById('goiThueContainer').innerHTML = '<p style="color: red;">Lỗi khi tải dữ liệu</p>';
                });
        }

        function addToCart(maGoiThue) {
            // Store current package ID for modal
            window.currentModalPackageId = maGoiThue;
            window.currentModalPackageData = null;
            window.modalAvailableCount = 0;  // Reset available count

            // Find package data from rendered packages
            const goiThueContainer = document.getElementById('goiThueContainer');
            const cards = goiThueContainer.querySelectorAll('.card');
            
            cards.forEach(card => {
                const button = card.querySelector('button[onclick*="addToCart"]');
                if (button && button.getAttribute('onclick').includes(maGoiThue)) {
                    // Found the card - extract data
                    const packageName = card.querySelector('h3')?.textContent || 'N/A';
                    const packageBrand = card.querySelector('p')?.textContent || 'N/A';
                    
                    window.currentModalPackageData = {
                        maGoiThue: maGoiThue,
                        tenGoiThue: packageName,
                        hangXe: packageBrand
                    };
                    
                    // Update modal with package info
                    document.getElementById('packageName').textContent = packageName;
                    document.getElementById('packageBrand').textContent = packageBrand;
                }
            });
            
            // Reset modal fields
            document.getElementById('modalBatDau').value = '';
            document.getElementById('modalKetThuc').value = '';
            document.getElementById('modalSoLuong').value = '1';
            document.getElementById('modalSoLuong').max = '';  // Reset max
            document.getElementById('availabilityResult').style.display = 'none';
            document.getElementById('errorMessage').style.display = 'none';
            
            // Show modal
            document.getElementById('addToCartModal').style.display = 'flex';
        }

        function closeAddToCartModal() {
            document.getElementById('addToCartModal').style.display = 'none';
            window.currentModalPackageId = null;
            window.currentModalPackageData = null;
            window.modalAvailableCount = 0;
        }

        // Helper: Calculate hours between two datetime-local strings
        function calculateModalHours(startStr, endStr) {
            if (!startStr || !endStr) return 0;
            const start = new Date(startStr);
            const end = new Date(endStr);
            const diffMs = end - start;
            if (diffMs <= 0) return 0;
            return diffMs / (1000 * 60 * 60);
        }

        /**
         * Called when time or quantity changes in modal
         * Validates input and checks availability
         */
        function onModalTimeChange() {
            const batDauStr = document.getElementById('modalBatDau').value;
            const ketThucStr = document.getElementById('modalKetThuc').value;
            const soLuong = parseInt(document.getElementById('modalSoLuong').value) || 1;
            
            // Reset messages
            document.getElementById('availabilityResult').style.display = 'none';
            document.getElementById('errorMessage').style.display = 'none';

            // Validate: both times must be filled
            if (!batDauStr || !ketThucStr) {
                return; // Wait for both inputs
            }

            // Validate: end time must be after start time
            const batDau = new Date(batDauStr);
            const ketThuc = new Date(ketThucStr);
            if (batDau >= ketThuc) {
                showModalError('Thời gian trả phải sau thời gian thuê');
                return;
            }

            // Validate: quantity
            if (soLuong < 1) {
                document.getElementById('modalSoLuong').value = 1;
                return;
            }

            // Check availability
            checkModalAvailability(window.currentModalPackageId, batDauStr, ketThucStr);
        }

        /**
         * Called when quantity input changes
         * Validates against available vehicles
         */
        function onModalQuantityChange() {
            const soLuongInput = parseInt(document.getElementById('modalSoLuong').value);
            const availableCount = window.modalAvailableCount || 0;

            // Reset error message first
            document.getElementById('errorMessage').style.display = 'none';

            // Check if availability has been checked
            if (availableCount === 0) {
                // Availability not checked yet, just validate basic constraints
                if (soLuongInput < 1) {
                    document.getElementById('modalSoLuong').value = 1;
                }
                return;
            }

            // Check if quantity exceeds available count
            if (soLuongInput > availableCount) {
                document.getElementById('modalSoLuong').value = availableCount;
                showModalError(`Số lượng xe hiện tại vượt quá số lượng xe khả dụng. Tối đa: ${availableCount}`);
                return;
            }

            // Valid quantity
            if (soLuongInput < 1) {
                document.getElementById('modalSoLuong').value = 1;
            }
        }

        /**
         * Check available vehicles for selected time range
         */
        function checkModalAvailability(maGoiThue, batDauStr, ketThucStr) {
            fetch(ctx + '/khachhang/giohang', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=checkAvailable&maGoiThue=' + maGoiThue + 
                      '&thoiGianBatDau=' + encodeURIComponent(batDauStr) +
                      '&thoiGianKetThuc=' + encodeURIComponent(ketThucStr)
            })
            .then(res => res.text())
            .then(xml => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(xml, 'application/xml');
                
                if (doc.documentElement.nodeName === 'parsererror') {
                    showModalError('Lỗi kiểm tra xe');
                    return;
                }
                
                if (doc.querySelector('error')) {
                    const errorMsg = doc.querySelector('error').textContent;
                    showModalError(errorMsg);
                    return;
                }
                
                const soLuongCon = parseInt(doc.querySelector('soLuongCon').textContent);
                const tongXe = parseInt(doc.querySelector('tongXe').textContent);
                
                if (soLuongCon > 0) {
                    showModalAvailability(soLuongCon, tongXe);
                } else {
                    showModalError('Không có xe trống trong khoảng thời gian này');
                }
            })
            .catch(e => {
                console.error('Error checking availability:', e);
                showModalError('Lỗi kết nối: ' + e.message);
            });
        }

        function showModalAvailability(soLuongCon, tongXe) {
            // Store available count globally for quantity validation
            window.modalAvailableCount = soLuongCon;
            
            document.getElementById('availableCount').textContent = soLuongCon;
            document.getElementById('totalCount').textContent = tongXe;
            document.getElementById('availabilityResult').style.display = 'block';
            document.getElementById('errorMessage').style.display = 'none';
            
            // Update quantity input max attribute
            document.getElementById('modalSoLuong').max = soLuongCon;
            
            // Reset quantity to 1 if it exceeds available
            const currentQty = parseInt(document.getElementById('modalSoLuong').value) || 1;
            if (currentQty > soLuongCon) {
                document.getElementById('modalSoLuong').value = Math.min(currentQty, soLuongCon);
            }
        }

        function showModalError(message) {
            document.getElementById('errorText').textContent = message;
            document.getElementById('errorMessage').style.display = 'block';
            document.getElementById('availabilityResult').style.display = 'none';
        }

        /**
         * Confirm and add to cart with selected time and quantity
         */
        function confirmAddToCart() {
            const maGoiThue = window.currentModalPackageId;
            const batDauStr = document.getElementById('modalBatDau').value;
            const ketThucStr = document.getElementById('modalKetThuc').value;
            const soLuong = parseInt(document.getElementById('modalSoLuong').value);
            const availableCount = window.modalAvailableCount || 0;

            // Final validation
            if (!batDauStr || !ketThucStr) {
                showModalError('Vui lòng nhập cả thời gian thuê và thời gian trả');
                return;
            }

            if (soLuong < 1) {
                showModalError('Số lượng không hợp lệ');
                return;
            }

            const batDau = new Date(batDauStr);
            const ketThuc = new Date(ketThucStr);
            if (batDau >= ketThuc) {
                showModalError('Thời gian trả phải sau thời gian thuê');
                return;
            }

            // CHECK: Quantity must not exceed available vehicles
            if (soLuong > availableCount) {
                showModalError(`Số lượng xe hiện tại vượt quá số lượng xe khả dụng. Tối đa: ${availableCount}`);
                return;
            }

            // Send POST request to add to cart
            const params = new URLSearchParams();
            params.append('maGoiThue', maGoiThue);
            params.append('soLuong', soLuong);
            params.append('thoiGianBatDau', batDauStr);
            params.append('thoiGianKetThuc', ketThucStr);

            fetch(ctx + '/khachhang/themgoivaogio', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: params.toString()
            })
            .then(res => res.text())
            .then(xml => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(xml, 'application/xml');
                
                const statusNode = doc.querySelector('status');
                const messageNode = doc.querySelector('message');
                
                if (statusNode && statusNode.textContent === 'success') {
                    // Show success message
                    if (window.UI && window.UI.toast) {
                        UI.toast('✓ Thêm vào giỏ hàng thành công', 'success', 3000);
                    } else {
                        alert('✓ Thêm vào giỏ hàng thành công');
                    }
                    // Close modal
                    closeAddToCartModal();
                } else {
                    const errorMsg = messageNode ? messageNode.textContent : 'Không thể thêm vào giỏ hàng';
                    showModalError(errorMsg);
                }
            })
            .catch(e => {
                console.error('Error:', e);
                showModalError('Lỗi kết nối server: ' + e.message);
            });
        }

        function confirmLogout() {
            UI.confirm('Đăng Xuất', 'Bạn có chắc muốn đăng xuất khỏi hệ thống?', 
                () => location.href = ctx + '/logout',
                () => {}
            );
        }

        // Close modal when clicking outside
        document.addEventListener('DOMContentLoaded', function() {
            const modal = document.getElementById('addToCartModal');
            modal.addEventListener('click', function(e) {
                if (e.target === modal) {
                    closeAddToCartModal();
                }
            });
        });

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

        // Initialize on page load
        window.addEventListener('DOMContentLoaded', async function() {
            console.log('=== PAGE LOAD - Initializing ===');
            await loadProvinceAndWardData();
            loadGoiThue();
            console.log('=== Initialization Complete ===\n');
        });
    </script>
</body>
</html>
