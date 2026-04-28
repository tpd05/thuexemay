<%@ page contentType="text/html;charset=UTF-8"%>
<%
String ctxPath = request.getContextPath();
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");

if (username == null || role == null || !role.equals("DOI_TAC")) {
    response.sendRedirect(ctxPath + "/views/403.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Đối tác</title>
    <link href="${pageContext.request.contextPath}/dist/tailwind.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/globals.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/components.css" rel="stylesheet">
    <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
    <style>
        .card {
            transition: all 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }
        
        /* Thống kê cards hover effects */
        .stats-card-1:hover {
            background: #fafaf9;
            border-top-color: #78511a;
        }
        
        .stats-card-2:hover {
            background: #f5f7fa;
            border-top-color: #1f2937;
        }
        
        .stats-card-3:hover {
            background: #f6f7f9;
            border-top-color: #3c3c3c;
        }
        
        /* Timeline step cards hover */
        .timeline-step {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .timeline-step:hover {
            background: #f0fdf4;
            border-radius: 8px;
            transform: scale(1.02);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .timeline-step:hover .step-circle {
            transform: scale(1.08);
        }
        
        .timeline-step:hover .step-icon-box {
            transform: scale(1.1);
        }
        
        /* Step circle colors */
        .step-1 .step-circle {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }
        
        .step-2 .step-circle {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .step-3 .step-circle {
            background: linear-gradient(135deg, #f97316, #ea580c);
            color: white;
            box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3);
        }
        
        .step-4 .step-circle {
            background: linear-gradient(135deg, #8b5cf6, #7c3aed);
            color: white;
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
        }
        
        /* Step icon boxes */
        .step-1 .step-icon-box {
            background: #dbeafe;
        }
        
        .step-2 .step-icon-box {
            background: #dbeafe;
        }
        
        .step-3 .step-icon-box {
            background: #fed7aa;
        }
        
        .step-4 .step-icon-box {
            background: #ede9fe;
        }
        
        /* Tips cards hover */
        .tip-card {
            transition: all 0.3s ease;
            background: linear-gradient(to right, rgba(255, 255, 255, 0.5), #ffffff);
        }
        
        .tip-card:hover {
            transform: translateY(-4px);
        }
        
        .tip-card:hover .tip-icon-box {
            transform: scale(1.1);
        }
        
        /* Timeline connecting line */
        .timeline-container {
            position: relative;
            padding-top: 0;
        }
        
        .timeline-arrow {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #d1d5db;
            font-size: 24px;
        }
        
        @media (max-width: 768px) {
            .timeline-arrow {
                display: none;
            }
        }
        
        /* Tip card 1 - Xanh lục */
        .tip-card-1 {
            border-left-color: #10b981;
        }
        
        .tip-card-1 .tip-icon-box {
            background: #dbeafe;
            color: #059669;
        }
        
        .tip-card-1:hover {
            background: linear-gradient(135deg, #f0fdf4, #ffffff);
            box-shadow: 0 8px 20px rgba(16, 185, 129, 0.15);
        }
        
        /* Tip card 2 - Xanh dương */
        .tip-card-2 {
            border-left-color: #3b82f6;
        }
        
        .tip-card-2 .tip-icon-box {
            background: #dbeafe;
            color: #2563eb;
        }
        
        .tip-card-2:hover {
            background: linear-gradient(135deg, #eff6ff, #ffffff);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.15);
        }
        
        /* Tip card 3 - Cam */
        .tip-card-3 {
            border-left-color: #f97316;
        }
        
        .tip-card-3 .tip-icon-box {
            background: #fed7aa;
            color: #ea580c;
        }
        
        .tip-card-3:hover {
            background: linear-gradient(135deg, #fff7ed, #ffffff);
            box-shadow: 0 8px 20px rgba(249, 115, 22, 0.15);
        }
    </style></head>
<body class="bg-color-bg-primary text-color-text-primary font-body">
    <div class="page-wrapper">
        <header class="page-header">
            <jsp:include page="/components/navbar.jsp" />
        </header>

        <main class="page-main">
            <!-- Hero Banner -->
            <div style="background: url('${pageContext.request.contextPath}/public/img/backgroud1.jpg') bottom/cover no-repeat; border-radius: 12px; padding: var(--spacing-3xl); margin-bottom: var(--spacing-3xl); color: white; position: relative; min-height: 250px; display: flex; align-items: center;">
                <div style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.4); border-radius: 12px;"></div>
                <div style="position: relative; z-index: 1;">
                    <h1 style="font-size: var(--text-3xl); font-weight: 700; margin: 0 0 var(--spacing-md) 0; display: flex; align-items: center; gap: var(--spacing-md);">
                        <iconify-icon icon="mdi:speedometer" style="width: 40px; height: 40px;"></iconify-icon>
                        Bảng Điều Khiển Đối Tác
                    </h1>
                    <p style="font-size: var(--text-lg); margin: 0;">Quản lý kinh doanh cho thuê xe máy của bạn một cách hiệu quả</p>
                </div>
            </div>

            <div class="app-container" style="display: flex; flex-direction: column; gap: var(--spacing-2xl); margin-bottom: var(--spacing-3xl);">

                <!-- Statistics Section with Enhanced Design -->
                <section>
                    <h2 style="font-size: var(--text-xl); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md); padding-bottom: var(--spacing-md); border-bottom: 2px solid #e5e7eb;">
                        <iconify-icon icon="mdi:chart-box" style="width: 28px; height: 28px; color: #6b7280;"></iconify-icon>
                        Thống Kê Nhanh
                    </h2>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--spacing-lg);">
                        <!-- Gói Thuê Card - Xanh lục -->
                        <div class="card stats-card-1" style="padding: var(--spacing-lg); text-align: center; border-top: 3px solid #10b981; border-radius: 8px;">
                            <div class="stat-icon-box" style="width: 100px; height: 100px; border-radius: 16px; display: flex; align-items: center; justify-content: center; margin: 0 auto var(--spacing-md) auto;">
                                <iconify-icon icon="mdi:package-variant" width="56" height="56" style="color: #059669;"></iconify-icon>
                            </div>
                            <p style="font-size: var(--text-md); color: #059669; margin: 0 0 var(--spacing-sm) 0; font-weight: 600;">Gói Thuê</p>
                            <p style="font-size: var(--text-3xl); font-weight: 700; color: #10b981; margin: 0;">${soGoiThue != null ? soGoiThue : 0}</p>
                        </div>
                        
                        <!-- Xe Máy Card - Xanh dương -->
                        <div class="card stats-card-2" style="padding: var(--spacing-lg); text-align: center; border-top: 3px solid #3b82f6; border-radius: 8px;">
                            <div class="stat-icon-box" style="width: 100px; height: 100px; border-radius: 16px; display: flex; align-items: center; justify-content: center; margin: 0 auto var(--spacing-md) auto;">
                                <iconify-icon icon="mdi:motorcycle" width="56" height="56" style="color: #2563eb;"></iconify-icon>
                            </div>
                            <p style="font-size: var(--text-md); color: #2563eb; margin: 0 0 var(--spacing-sm) 0; font-weight: 600;">Tổng Xe Máy</p>
                            <p style="font-size: var(--text-3xl); font-weight: 700; color: #3b82f6; margin: 0;">${soXeSanCo != null ? soXeSanCo : 0}</p>
                        </div>
                        
                        <!-- Chi Nhánh Card - Cam -->
                        <div class="card stats-card-3" style="padding: var(--spacing-lg); text-align: center; border-top: 3px solid #f97316; border-radius: 8px;">
                            <div class="stat-icon-box" style="width: 100px; height: 100px; border-radius: 16px; display: flex; align-items: center; justify-content: center; margin: 0 auto var(--spacing-md) auto;">
                                <iconify-icon icon="mdi:storefront" width="56" height="56" style="color: #ea580c;"></iconify-icon>
                            </div>
                            <p style="font-size: var(--text-md); color: #ea580c; margin: 0 0 var(--spacing-sm) 0; font-weight: 600;">Chi Nhánh</p>
                            <p style="font-size: var(--text-3xl); font-weight: 700; color: #f97316; margin: 0;">${soChiNhanh != null ? soChiNhanh : 0}</p>
                        </div>
                    </div>
                </section>

                <!-- Steps to Create Rental Package -->
                <section>
                    <h2 style="font-size: var(--text-xl); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md); padding-bottom: var(--spacing-md); border-bottom: 2px solid #e5e7eb;">
                        <iconify-icon icon="mdi:clipboard-list-outline" style="width: 28px; height: 28px; color: #6b7280;"></iconify-icon>
                        Quy Trình Tạo Gói Thuê
                    </h2>
                    <div style="display: flex; flex-direction: column; gap: var(--spacing-lg);">
                        <!-- Timeline visualization -->
                        <div style="background: #f9fafb; border-radius: 12px; padding: var(--spacing-lg); border: 1px solid #e5e7eb;">
                            <div class="timeline-container" style="display: grid; grid-template-columns: repeat(7, 1fr); gap: var(--spacing-md); align-items: center;">
                                <!-- Step 1 - Xanh lục -->
                                <a href="${pageContext.request.contextPath}/doitac/quanlychinhanh" style="text-decoration: none; color: inherit;">
                                <div class="timeline-step step-1" style="display: flex; flex-direction: column; align-items: center; text-align: center; padding: var(--spacing-md); border-radius: 8px; grid-column: 1;">
                                    <div class="step-circle" style="width: 70px; height: 70px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: var(--spacing-md); font-weight: 700; font-size: 24px; transition: all 0.3s ease;">1</div>
                                    <h3 style="font-size: var(--text-md); font-weight: 700; margin: 0 0 var(--spacing-sm) 0; color: #1f2937;">Thêm Chi Nhánh</h3>
                                    <p style="font-size: var(--text-xs); color: #6b7280; margin: 0;">Tạo cơ sở cho gói thuê</p>
                                    <div class="step-icon-box" style="width: 50px; height: 50px; border-radius: 8px; display: flex; align-items: center; justify-content: center; margin: var(--spacing-sm) auto 0 auto; transition: all 0.3s ease;">
                                        <iconify-icon icon="mdi:store-plus" style="width: 28px; height: 28px; color: #059669;"></iconify-icon>
                                    </div>
                                </div>
                                </a>

                                <!-- Arrow 1->2 -->
                                <div class="timeline-arrow" style="grid-column: 2;">
                                    <iconify-icon icon="mdi:chevron-right" style="width: 32px; height: 32px;"></iconify-icon>
                                </div>

                                <!-- Step 2 - Xanh dương -->
                                <a href="${pageContext.request.contextPath}/doitac/quanlymauxe" style="text-decoration: none; color: inherit;">
                                <div class="timeline-step step-2" style="display: flex; flex-direction: column; align-items: center; text-align: center; padding: var(--spacing-md); border-radius: 8px; grid-column: 3;">
                                    <div class="step-circle" style="width: 70px; height: 70px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: var(--spacing-md); font-weight: 700; font-size: 24px; transition: all 0.3s ease;">2</div>
                                    <h3 style="font-size: var(--text-md); font-weight: 700; margin: 0 0 var(--spacing-sm) 0; color: #1f2937;">Thêm Mẫu Xe</h3>
                                    <p style="font-size: var(--text-xs); color: #6b7280; margin: 0;">Định nghĩa loại xe</p>
                                    <div class="step-icon-box" style="width: 50px; height: 50px; border-radius: 8px; display: flex; align-items: center; justify-content: center; margin: var(--spacing-sm) auto 0 auto; transition: all 0.3s ease;">
                                        <iconify-icon icon="mdi:car-multiple" style="width: 28px; height: 28px; color: #2563eb;"></iconify-icon>
                                    </div>
                                </div>
                                </a>

                                <!-- Arrow 2->3 -->
                                <div class="timeline-arrow" style="grid-column: 4;">
                                    <iconify-icon icon="mdi:chevron-right" style="width: 32px; height: 32px;"></iconify-icon>
                                </div>

                                <!-- Step 3 - Cam -->
                                <a href="${pageContext.request.contextPath}/doitac/quanlyxemay" style="text-decoration: none; color: inherit;">
                                <div class="timeline-step step-3" style="display: flex; flex-direction: column; align-items: center; text-align: center; padding: var(--spacing-md); border-radius: 8px; grid-column: 5;">
                                    <div class="step-circle" style="width: 70px; height: 70px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: var(--spacing-md); font-weight: 700; font-size: 24px; transition: all 0.3s ease;">3</div>
                                    <h3 style="font-size: var(--text-md); font-weight: 700; margin: 0 0 var(--spacing-sm) 0; color: #1f2937;">Thêm Xe Máy</h3>
                                    <p style="font-size: var(--text-xs); color: #6b7280; margin: 0;">Thêm cụ thể cho từng mẫu</p>
                                    <div class="step-icon-box" style="width: 50px; height: 50px; border-radius: 8px; display: flex; align-items: center; justify-content: center; margin: var(--spacing-sm) auto 0 auto; transition: all 0.3s ease;">
                                        <iconify-icon icon="mdi:motorcycle-electric" style="width: 28px; height: 28px; color: #ea580c;"></iconify-icon>
                                    </div>
                                </div>
                                </a>

                                <!-- Arrow 3->4 -->
                                <div class="timeline-arrow" style="grid-column: 6;">
                                    <iconify-icon icon="mdi:chevron-right" style="width: 32px; height: 32px;"></iconify-icon>
                                </div>

                                <!-- Step 4 - Tím -->
                                <a href="${pageContext.request.contextPath}/doitac/quanlygoithue" style="text-decoration: none; color: inherit;">
                                <div class="timeline-step step-4" style="display: flex; flex-direction: column; align-items: center; text-align: center; padding: var(--spacing-md); border-radius: 8px; grid-column: 7;">
                                    <div class="step-circle" style="width: 70px; height: 70px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: var(--spacing-md); font-weight: 700; font-size: 24px; transition: all 0.3s ease;">4</div>
                                    <h3 style="font-size: var(--text-md); font-weight: 700; margin: 0 0 var(--spacing-sm) 0; color: #1f2937;">Tạo Gói Thuê</h3>
                                    <p style="font-size: var(--text-xs); color: #6b7280; margin: 0;">Đặt giá và điều kiện</p>
                                    <div class="step-icon-box" style="width: 50px; height: 50px; border-radius: 8px; display: flex; align-items: center; justify-content: center; margin: var(--spacing-sm) auto 0 auto; transition: all 0.3s ease;">
                                        <iconify-icon icon="mdi:package-variant-closed" style="width: 28px; height: 28px; color: #7c3aed;"></iconify-icon>
                                    </div>
                                </div>
                                </a>
                            </div>

                            <div style="text-align: center; margin-top: var(--spacing-lg); padding-top: var(--spacing-lg); border-top: 1px solid #e5e7eb;">
                                <p style="font-size: var(--text-sm); color: #6b7280; margin: 0;">
                                    <iconify-icon icon="mdi:information-outline" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 4px;"></iconify-icon>
                                    Hoàn thành 4 bước trên để bắt đầu nhận đơn hàng
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Additional Information Section -->
                <section>
                    <h2 style="font-size: var(--text-xl); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; display: flex; align-items: center; gap: var(--spacing-md); padding-bottom: var(--spacing-md); border-bottom: 2px solid #e5e7eb;">
                        <iconify-icon icon="mdi:lightbulb-on-outline" style="width: 28px; height: 28px; color: #6b7280;"></iconify-icon>
                        Mẹo Quản Lý Kinh Doanh
                    </h2>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: var(--spacing-lg);">
                        <!-- Tip 1 - Xanh lục -->
                        <div class="card tip-card tip-card-1" style="padding: var(--spacing-lg); border-left: 4px solid #10b981; border-radius: 8px;">
                            <div style="display: flex; align-items: center; gap: var(--spacing-md); margin-bottom: var(--spacing-md);">
                                <div class="tip-icon-box" style="width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; transition: all 0.3s ease;">
                                    <iconify-icon icon="mdi:target" style="width: 24px; height: 24px;"></iconify-icon>
                                </div>
                                <h3 style="font-size: var(--text-md); font-weight: 700; margin: 0; color: #059669;">Giá Cạnh Tranh</h3>
                            </div>
                            <p style="font-size: var(--text-sm); color: #6b7280; margin: 0; line-height: 1.5;">Nghiên cứu thị trường và đặt giá hợp lý để thu hút khách hàng</p>
                        </div>

                        <!-- Tip 2 - Xanh dương -->
                        <div class="card tip-card tip-card-2" style="padding: var(--spacing-lg); border-left: 4px solid #3b82f6; border-radius: 8px;">
                            <div style="display: flex; align-items: center; gap: var(--spacing-md); margin-bottom: var(--spacing-md);">
                                <div class="tip-icon-box" style="width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; transition: all 0.3s ease;">
                                    <iconify-icon icon="mdi:heart" style="width: 24px; height: 24px;"></iconify-icon>
                                </div>
                                <h3 style="font-size: var(--text-md); font-weight: 700; margin: 0; color: #2563eb;">Chất Lượng Phục Vụ</h3>
                            </div>
                            <p style="font-size: var(--text-sm); color: #6b7280; margin: 0; line-height: 1.5;">Bảo trì xe theo định kỳ để tạo ấn tượng tốt với khách</p>
                        </div>

                        <!-- Tip 3 - Cam -->
                        <div class="card tip-card tip-card-3" style="padding: var(--spacing-lg); border-left: 4px solid #f97316; border-radius: 8px;">
                            <div style="display: flex; align-items: center; gap: var(--spacing-md); margin-bottom: var(--spacing-md);">
                                <div class="tip-icon-box" style="width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; transition: all 0.3s ease;">
                                    <iconify-icon icon="mdi:chart-line-variant" style="width: 24px; height: 24px;"></iconify-icon>
                                </div>
                                <h3 style="font-size: var(--text-md); font-weight: 700; margin: 0; color: #ea580c;">Theo Dõi Doanh Số</h3>
                            </div>
                            <p style="font-size: var(--text-sm); color: #6b7280; margin: 0; line-height: 1.5;">Kiểm tra báo cáo hàng tháng để tối ưu hoá kinh doanh</p>
                        </div>
                    </div>
                </section>
                
            </div>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>
</body>
</html>
