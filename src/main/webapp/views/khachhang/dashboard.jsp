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
                const giaGio = parseFloat(pkg.querySelector('giaGio')?.textContent || '0').toLocaleString('vi-VN');
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
                                        <p style="font-size: 11px; color: var(--color-text-secondary); text-transform: uppercase; margin: 0 0 4px 0; font-weight: 600;">Giá Giờ</p>
                                        <p style="font-size: var(--text-lg); font-weight: 700; color: var(--color-primary); margin: 0;">` + giaGio + `đ</p>
                                    </div>
                                </div>
                                <button class="btn btn-primary" style="width: 100%; padding: var(--spacing-md); font-size: var(--text-sm);" onclick="addToCart(` + maGoiThue + `)">
                                    <iconify-icon icon="mdi:plus-circle" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 4px;"></iconify-icon>
                                    Thêm Vào Giỏ
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
            // Send POST request with quantity = 1 using URLSearchParams for better server compatibility
            const params = new URLSearchParams();
            params.append('maGoiThue', maGoiThue);
            params.append('soLuong', 1);
            
            const url = ctx + '/khachhang/themgoivaogio';
            console.log('[DEBUG] addToCart URL:', url);
            console.log('[DEBUG] Context path (ctx):', ctx);
            console.log('[DEBUG] maGoiThue:', maGoiThue);
            console.log('[DEBUG] Full URL would be:', window.location.origin + url);
            
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: params.toString()
            })
            .then(res => {
                console.log('[DEBUG] Response status:', res.status);
                console.log('[DEBUG] Response statusText:', res.statusText);
                return res.text();
            })
            .then(xml => {
                console.log('[DEBUG] Response XML:', xml);
                const parser = new DOMParser();
                const doc = parser.parseFromString(xml, 'application/xml');
                
                // Check response status
                const statusNode = doc.querySelector('status');
                const messageNode = doc.querySelector('message');
                console.log('[DEBUG] Status node:', statusNode?.textContent);
                console.log('[DEBUG] Message node:', messageNode?.textContent);
                
                if (statusNode && statusNode.textContent === 'success') {
                    UI.toast('Thêm vào giỏ hàng thành công', 'success', 3000);
                } else {
                    const errorMsg = messageNode ? messageNode.textContent : 'Không thể thêm vào giỏ hàng';
                    UI.toast(errorMsg, 'error', 3000);
                }
            })
            .catch(e => {
                console.error('[DEBUG] Error:', e);
                console.error('[DEBUG] Error message:', e.message);
                console.error('[DEBUG] Error stack:', e.stack);
                UI.toast('Lỗi kết nối server: ' + e.message, 'error', 3000);
            });
        }

        function confirmLogout() {
            UI.confirm('Đăng Xuất', 'Bạn có chắc muốn đăng xuất khỏi hệ thống?', 
                () => location.href = ctx + '/logout',
                () => {}
            );
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
