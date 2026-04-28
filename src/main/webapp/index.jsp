<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String ctxPath = request.getContextPath();
HttpSession userSession = request.getSession(false);

// Nếu đã đăng nhập thì redirect sang dashboard tương ứng
if (userSession != null) {
    String username = (String) userSession.getAttribute("username");
    String role = (String) userSession.getAttribute("role");
    
    if (username != null && role != null) {
        if ("DOI_TAC".equals(role)) {
            response.sendRedirect(ctxPath + "/doitac/dashboard");
        } else if ("KHACH_HANG".equals(role)) {
            response.sendRedirect(ctxPath + "/khachhang/dashboard");
        } else if ("ADMIN".equals(role)) {
            response.sendRedirect(ctxPath + "/admin/dashboard");
        } else if ("NHAN_VIEN".equals(role)) {
            response.sendRedirect(ctxPath + "/nhanvien/dashboard");
        }
        return;
    }
}
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ThueXeMay - Hệ Thống Cho Thuê Xe Máy</title>
    <link href="<%= ctxPath %>/dist/tailwind.css" rel="stylesheet">
    <link href="<%= ctxPath %>/css/globals.css" rel="stylesheet">
    <link href="<%= ctxPath %>/css/components.css" rel="stylesheet">
    <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
</head>
<body class="bg-color-bg-primary text-color-text-primary font-body">
    <div class="page-wrapper">
        <header class="page-header">
            <jsp:include page="/components/navbar.jsp" />
        </header>

        <main class="page-main">
            <!-- ===== HERO SECTION ===== -->
            <section style="background-image: url('<%= ctxPath %>/public/img/backgroud.png'); background-position: center; background-size: cover; background-repeat: no-repeat; min-height: 500px; display: flex; align-items: flex-end; padding-bottom: var(--spacing-2xl);">
                <div class="app-container" style="text-align: center; width: 100%; background-color: rgba(0,0,0,0.5); padding: var(--spacing-2xl); border-radius: var(--radius-lg);">
                    <p style="font-size: var(--text-2xl); font-weight: 700; color: white; margin: 0 0 var(--spacing-md) 0; text-transform: uppercase; letter-spacing: 1px;">Dịch vụ</p>
                    <h1 style="font-size: var(--text-4xl); font-weight: 800; color: #10b981; margin: 0 0 var(--spacing-md) 0;"><span>Thuê xe máy</span></h1>
                    <p style="font-size: var(--text-lg); font-weight: 600; color: white; margin: 0; max-width: 800px; margin-left: auto; margin-right: auto; line-height: 1.8;">
                        Thấu hiểu cảm giác của người đi thuê xe máy, phải làm sao để có được một chiếc xe đủ tốt, không gặp rắc rối khi đi trên đường. Vì vậy <strong>MOTOBOOK</strong> - cung cấp dịch vụ thuê xe máy tự lái, tiên phong trở thành đơn vị số 1 về tại Việt Nam.
                    </p>
                </div>
            </section>

            <!-- ===== HERO BOOKING FORM ===== -->
            <section style="padding: var(--spacing-2xl) var(--spacing-md); background-color: white; position: relative; z-index: 10; margin-top: calc(-1 * var(--spacing-lg));">
                <div class="app-container">
                    <div style="background: white; border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); padding: var(--spacing-lg); overflow: hidden;">
                        <!-- Tabs -->
                        <div style="display: flex; border-bottom: 2px solid var(--color-bg-secondary); margin-bottom: var(--spacing-lg);">
                            <button style="flex: 1; padding: var(--spacing-md); font-weight: 600; color: var(--color-primary); border: none; background: none; cursor: pointer; border-bottom: 3px solid var(--color-primary); position: relative; margin-bottom: -2px;">
                                <iconify-icon icon="mdi:motorcycle" style="width: 18px; height: 18px; margin-right: 6px; vertical-align: middle;"></iconify-icon>
                                Thuê xe máy
                            </button>
                        </div>

                        <!-- Form Content -->
                        <form style="display: grid; grid-template-columns: repeat(4, 1fr); gap: var(--spacing-md); align-items: end;">
                            <div>
                                <label style="display: block; font-size: var(--text-sm); font-weight: 600; margin-bottom: 6px; color: var(--color-text-primary);">Địa điểm nhận xe</label>
                                <div style="display: flex; border: 1px solid var(--color-border-light); border-radius: var(--radius-md); overflow: hidden;">
                                    <span style="display: flex; align-items: center; padding: 0 var(--spacing-md); background: var(--color-bg-secondary);">
                                        <iconify-icon icon="mdi:map-marker" style="width: 18px; height: 18px; color: var(--color-text-secondary);"></iconify-icon>
                                    </span>
                                    <select id="pickup-location" style="flex: 1; border: none; padding: var(--spacing-md); background: white; font-size: inherit;">
                                        <option>Chọn điểm nhận xe</option>
                                        <option>Hà Nội</option>
                                        <option>Hà Giang</option>
                                        <option>Đà Nẵng</option>
                                        <option>TP. Hồ Chí Minh</option>
                                        <option>Phú Quốc</option>
                                    </select>
                                </div>
                            </div>

                            <div>
                                <label style="display: block; font-size: var(--text-sm); font-weight: 600; margin-bottom: 6px; color: var(--color-text-primary); ">Địa điểm trả xe</label>
                                <div style="display: flex; border: 1px solid var(--color-border-light); border-radius: var(--radius-md); overflow: hidden;">
                                    <span style="display: flex; align-items: center; padding: 0 var(--spacing-md); background: var(--color-bg-secondary);">
                                        <iconify-icon icon="mdi:map-marker" style="width: 18px; height: 18px; color: var(--color-text-secondary);"></iconify-icon>
                                    </span>
                                    <select id="dropoff-location" disabled style="flex: 1; border: none; padding: var(--spacing-md); background: white; font-size: inherit; opacity: 0.6; cursor: not-allowed;">
                                        <option>Chọn điểm trả xe</option>
                                        <option>Hà Nội</option>
                                        <option>Hà Giang</option>
                                        <option>Đà Nẵng</option>
                                        <option>TP. Hồ Chí Minh</option>
                                        <option>Phú Quốc</option>
                                    </select>
                                </div>
                            </div>

                            <div>
                                <label style="display: block; font-size: var(--text-sm); font-weight: 600; margin-bottom: 6px; color: var(--color-text-primary);">Thời gian nhận xe</label>
                                <div style="display: flex; border: 1px solid var(--color-border-light); border-radius: var(--radius-md); overflow: hidden;">
                                    <span style="display: flex; align-items: center; padding: 0 var(--spacing-md); background: var(--color-bg-secondary);">
                                        <iconify-icon icon="mdi:calendar" style="width: 18px; height: 18px; color: var(--color-text-secondary);"></iconify-icon>
                                    </span>
                                    <input type="date" style="flex: 1; border: none; padding: var(--spacing-md); background: white; font-size: inherit;">
                                </div>
                            </div>



                            <div>
                                <label style="display: block; font-size: var(--text-sm); font-weight: 600; margin-bottom: 6px; color: var(--color-text-primary);">Thời gian trả xe</label>
                                <div style="display: flex; border: 1px solid var(--color-border-light); border-radius: var(--radius-md); overflow: hidden;">
                                    <span style="display: flex; align-items: center; padding: 0 var(--spacing-md); background: var(--color-bg-secondary);">
                                        <iconify-icon icon="mdi:calendar" style="width: 18px; height: 18px; color: var(--color-text-secondary);"></iconify-icon>
                                    </span>
                                    <input type="date" style="flex: 1; border: none; padding: var(--spacing-md); background: white; font-size: inherit;">
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary" style="padding: var(--spacing-md); font-weight: 600; height: 48px; display: flex; align-items: center; justify-content: center; grid-column: 1 / -1;">
                                <iconify-icon icon="mdi:magnify" style="width: 18px; height: 18px; margin-right: 6px;"></iconify-icon>
                                Đặt xe ngay
                            </button>
                            <div style="margin-top: 8px; display: flex; gap: var(--spacing-sm);">
                                <input type="checkbox" id="same-location" checked disabled>
                                <label for="same-location" style="font-size: var(--text-sm); color: var(--color-text-secondary);">Nhận, trả xe cùng địa điểm</label>
                            </div>
                        </form>
                        <script>
                            document.getElementById('pickup-location').addEventListener('change', function() {
                                document.getElementById('dropoff-location').value = this.value;
                            });
                        </script>
                    </div>
                </div>
            </section>

            <!-- ===== LOCATIONS SECTION ===== -->
            <section style="padding: var(--spacing-3xl) var(--spacing-md);">
                <div class="app-container">
                    <h2 style="font-size: var(--text-2xl); font-weight: 700; margin: 0 0 var(--spacing-2xl) 0; text-align: center; color: var(--color-text-primary);">Địa điểm thuê xe máy</h2>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--spacing-lg);">
                        <a href="#" class="card" style="background-image: url('<%= ctxPath %>/public/img/placeholders/hanoi.png'); background-size: cover; background-position: center; text-align: center; padding: var(--spacing-lg); text-decoration: none; transition: all var(--transition-normal); position: relative; overflow: hidden; min-height: 350px; display: flex; flex-direction: column; justify-content: flex-end;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)'; this.querySelector('div').style.backgroundColor='white'; this.querySelector('h3').style.color='black'; this.querySelector('p').style.color='black';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)'; this.querySelector('div').style.backgroundColor='rgba(0,0,0,0.5)'; this.querySelector('h3').style.color='white'; this.querySelector('p').style.color='rgba(255,255,255,0.9)';">
                            <div style="position: relative; z-index: 2; background-color: rgba(0,0,0,0.5); padding: var(--spacing-md); border-radius: var(--radius-md);">
                                <h3 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-xs) 0; color: white;">Hà Nội</h3>
                                <p style="margin: 0; color: rgba(255,255,255,0.9); font-size: var(--text-sm);">3 cơ sở cho thuê xe máy</p>
                            </div>
                        </a>
                        <a href="#" class="card" style="background-image: url('<%= ctxPath %>/public/img/placeholders/hagiang.jpg'); background-size: cover; background-position: center; text-align: center; padding: var(--spacing-lg); text-decoration: none; transition: all var(--transition-normal); position: relative; overflow: hidden; min-height: 350px; display: flex; flex-direction: column; justify-content: flex-end;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)'; this.querySelector('div').style.backgroundColor='white'; this.querySelector('h3').style.color='black'; this.querySelector('p').style.color='black';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)'; this.querySelector('div').style.backgroundColor='rgba(0,0,0,0.5)'; this.querySelector('h3').style.color='white'; this.querySelector('p').style.color='rgba(255,255,255,0.9)';">
                            <div style="position: relative; z-index: 2; background-color: rgba(0,0,0,0.5); padding: var(--spacing-md); border-radius: var(--radius-md);">
                                <h3 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-xs) 0; color: white;">Hà Giang</h3>
                                <p style="margin: 0; color: rgba(255,255,255,0.9); font-size: var(--text-sm);">1 cơ sở cho thuê xe máy</p>
                            </div>
                        </a>
                        <a href="#" class="card" style="background-image: url('<%= ctxPath %>/public/img/placeholders/danang.jpg'); background-size: cover; background-position: center; text-align: center; padding: var(--spacing-lg); text-decoration: none; transition: all var(--transition-normal); position: relative; overflow: hidden; min-height: 350px; display: flex; flex-direction: column; justify-content: flex-end;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)'; this.querySelector('div').style.backgroundColor='white'; this.querySelector('h3').style.color='black'; this.querySelector('p').style.color='black';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)'; this.querySelector('div').style.backgroundColor='rgba(0,0,0,0.5)'; this.querySelector('h3').style.color='white'; this.querySelector('p').style.color='rgba(255,255,255,0.9)';">
                            <div style="position: relative; z-index: 2; background-color: rgba(0,0,0,0.5); padding: var(--spacing-md); border-radius: var(--radius-md);">
                                <h3 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-xs) 0; color: white;">Đà Nẵng</h3>
                                <p style="margin: 0; color: rgba(255,255,255,0.9); font-size: var(--text-sm);">1 cơ sở cho thuê xe máy</p>
                            </div>
                        </a>
                        <a href="#" class="card" style="background-image: url('<%= ctxPath %>/public/img/placeholders/hochiminh.jpg'); background-size: cover; background-position: center; text-align: center; padding: var(--spacing-lg); text-decoration: none; transition: all var(--transition-normal); position: relative; overflow: hidden; min-height: 350px; display: flex; flex-direction: column; justify-content: flex-end;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)'; this.querySelector('div').style.backgroundColor='white'; this.querySelector('h3').style.color='black'; this.querySelector('p').style.color='black';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)'; this.querySelector('div').style.backgroundColor='rgba(0,0,0,0.5)'; this.querySelector('h3').style.color='white'; this.querySelector('p').style.color='rgba(255,255,255,0.9)';">
                            <div style="position: relative; z-index: 2; background-color: rgba(0,0,0,0.5); padding: var(--spacing-md); border-radius: var(--radius-md);">
                                <h3 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-xs) 0; color: white;">TP.HCM</h3>
                                <p style="margin: 0; color: rgba(255,255,255,0.9); font-size: var(--text-sm);">2 cơ sở cho thuê xe máy</p>
                            </div>
                        </a>
                        <a href="#" class="card" style="background-image: url('<%= ctxPath %>/public/img/placeholders/phuquoc.jpeg'); background-size: cover; background-position: center; text-align: center; padding: var(--spacing-lg); text-decoration: none; transition: all var(--transition-normal); position: relative; overflow: hidden; min-height: 350px; display: flex; flex-direction: column; justify-content: flex-end;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)'; this.querySelector('div').style.backgroundColor='white'; this.querySelector('h3').style.color='black'; this.querySelector('p').style.color='black';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)'; this.querySelector('div').style.backgroundColor='rgba(0,0,0,0.5)'; this.querySelector('h3').style.color='white'; this.querySelector('p').style.color='rgba(255,255,255,0.9)';">
                            <div style="position: relative; z-index: 2; background-color: rgba(0,0,0,0.5); padding: var(--spacing-md); border-radius: var(--radius-md);">
                                <h3 style="font-size: var(--text-lg); font-weight: 700; margin: 0 0 var(--spacing-xs) 0; color: white;">Phú Quốc</h3>
                                <p style="margin: 0; color: rgba(255,255,255,0.9); font-size: var(--text-sm);">Sắp khai trương</p>
                            </div>
                        </a>
                    </div>
                </div>
            </section>

            <!-- ===== MOTORCYCLES SECTION ===== -->
            <section style="padding: var(--spacing-3xl) var(--spacing-md); background-color: var(--color-bg-secondary);">
                <div class="app-container">
                    <h2 style="font-size: var(--text-2xl); font-weight: 700; margin: 0 0 var(--spacing-lg) 0; text-align: center; color: var(--color-text-primary);">Danh mục xe máy</h2>
                    <p style="text-align: center; color: var(--color-text-secondary); margin: 0 0 var(--spacing-2xl) 0; max-width: 700px; margin-left: auto; margin-right: auto; line-height: 1.6;">
                        Toàn bộ xe máy tại MotoBook đều là xe mới 100%, được mua mới và đăng ký chính chủ ngay từ đầu. Sau mỗi hợp đồng thuê, xe sẽ được kiểm tra toàn diện, bảo dưỡng định kỳ và thay thế các bộ phận có dấu hiệu hao mòn hoặc hư hỏng.
                    </p>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: var(--spacing-lg); margin-bottom: var(--spacing-2xl);">
                        <!-- Yamaha -->
                        <div class="card" style="overflow: hidden; display: flex; flex-direction: column; transition: all var(--transition-normal);" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)';"  >
                            <div style="background-image: url('<%= ctxPath %>/public/img/mauXe/yamaha-sirius.png'); background-size: cover; background-position: center; padding: var(--spacing-lg); text-align: center; height: 250px;">
                            </div>
                            <div style="padding: var(--spacing-lg); flex: 1; display: flex; flex-direction: column; position: relative; z-index: 10; background-color: white;">
                                <h3 style="margin: 0 0 var(--spacing-md) 0; color: var(--color-text-primary); font-weight: 700;">Yamaha Sirius 110cc</h3>
                                <ul style="margin: 0 0 var(--spacing-md) 0; padding: 0; list-style: none; font-size: var(--text-sm); color: var(--color-text-secondary);">
                                    <li style="margin-bottom: 4px;">✓ 02 mũ bảo hiểm 1/2 đầu</li>
                                    <li style="margin-bottom: 4px;">✓ 02 áo mưa dùng 1 lần</li>
                                    <li style="margin-bottom: 4px;">✓ Giá đỡ điện thoại</li>
                                    <li>✓ Dịch vụ cứu hộ</li>
                                </ul>
                                <a href="/thuexemay/dangnhap" class="btn btn-primary" style="width: 100%; font-weight: 600; padding: var(--spacing-md); display: block; text-align: center; text-decoration: none; margin-top: auto; color: white;" onmouseover="this.style.color='white'; this.style.opacity='0.9';" onmouseout="this.style.color='white'; this.style.opacity='1';">Thuê ngay</a>
                            </div>
                        </div>

                        <!-- Honda Vision - Best Choice -->
                        <div class="card" style="overflow: hidden; border: 2px solid var(--color-primary); position: relative; display: flex; flex-direction: column; transition: all var(--transition-normal);" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)';" >
                            <div style="position: absolute; top: 10px; right: 10px; background: var(--color-primary); color: white; padding: 4px 12px; border-radius: var(--radius-md); font-size: var(--text-xs); font-weight: 600; z-index: 1;">⭐ Lựa chọn tốt nhất</div>
                            <div style="background-image: url('<%= ctxPath %>/public/img/mauXe/Honda-vision.png'); background-size: cover; background-position: center; padding: var(--spacing-lg); text-align: center; height: 250px;">
                            </div>
                            <div style="padding: var(--spacing-lg); flex: 1; display: flex; flex-direction: column; position: relative; z-index: 10; background-color: white;">
                                <h3 style="margin: 0 0 var(--spacing-md) 0; color: var(--color-text-primary); font-weight: 700;">Honda Vision 110cc</h3>
                                <ul style="margin: 0 0 var(--spacing-md) 0; padding: 0; list-style: none; font-size: var(--text-sm); color: var(--color-text-secondary);">
                                    <li style="margin-bottom: 4px;">✓ 02 mũ bảo hiểm 1/2 đầu</li>
                                    <li style="margin-bottom: 4px;">✓ 02 áo mưa dùng 1 lần</li>
                                    <li style="margin-bottom: 4px;">✓ Giá đỡ điện thoại</li>
                                    <li>✓ Dịch vụ cứu hộ</li>
                                </ul>
                                <a href="/thuexemay/dangnhap" class="btn btn-primary" style="width: 100%; font-weight: 600; padding: var(--spacing-md); display: block; text-align: center; text-decoration: none; margin-top: auto; color: white;" onmouseover="this.style.color='white'; this.style.opacity='0.9';" onmouseout="this.style.color='white'; this.style.opacity='1';">Thuê ngay</a>
                            </div>
                        </div>

                        <!-- Honda AirBlade -->
                        <div class="card" style="overflow: hidden; display: flex; flex-direction: column; transition: all var(--transition-normal);" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)';" >
                            <div style="background-image: url('<%= ctxPath %>/public/img/mauXe/Honda-Airblade-125cc.png'); background-size: cover; background-position: center; padding: var(--spacing-lg); text-align: center; height: 250px;">
                            </div>
                            <div style="padding: var(--spacing-lg); flex: 1; display: flex; flex-direction: column; position: relative; z-index: 10; background-color: white;">
                                <h3 style="margin: 0 0 var(--spacing-md) 0; color: var(--color-text-primary); font-weight: 700;">Honda AirBlade 125cc</h3>
                                <ul style="margin: 0 0 var(--spacing-md) 0; padding: 0; list-style: none; font-size: var(--text-sm); color: var(--color-text-secondary);">
                                    <li style="margin-bottom: 4px;">✓ 02 mũ bảo hiểm 1/2 đầu</li>
                                    <li style="margin-bottom: 4px;">✓ 02 áo mưa dùng 1 lần</li>
                                    <li style="margin-bottom: 4px;">✓ Giá đỡ điện thoại</li>
                                    <li>✓ Dịch vụ cứu hộ</li>
                                </ul>
            
                                <a href="/thuexemay/dangnhap" class="btn btn-primary" style="width: 100%; font-weight: 600; padding: var(--spacing-md); display: block; text-align: center; text-decoration: none; margin-top: auto; color: white;" onmouseover="this.style.color='white'; this.style.opacity='0.9';" onmouseout="this.style.color='white'; this.style.opacity='1';">Thuê ngay</a>
                            </div>
                        </div>

                        <!-- Honda WinnerX -->
                        <div class="card" style="overflow: hidden; display: flex; flex-direction: column; transition: all var(--transition-normal);" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='var(--shadow-md)';" >
                            <div style="background-image: url('<%= ctxPath %>/public/img/mauXe/WinnerX-150cc.png'); background-size: cover; background-position: center; padding: var(--spacing-lg); text-align: center; height: 250px;">
                            </div>
                            <div style="padding: var(--spacing-lg); flex: 1; display: flex; flex-direction: column; position: relative; z-index: 10; background-color: white;">
                                <h3 style="margin: 0 0 var(--spacing-md) 0; color: var(--color-text-primary); font-weight: 700;">Honda WinnerX 150cc</h3>
                                <ul style="margin: 0 0 var(--spacing-md) 0; padding: 0; list-style: none; font-size: var(--text-sm); color: var(--color-text-secondary);">
                                    <li style="margin-bottom: 4px;">✓ 02 mũ bảo hiểm 1/2 đầu</li>
                                    <li style="margin-bottom: 4px;">✓ 02 áo mưa dùng 1 lần</li>
                                    <li style="margin-bottom: 4px;">✓ Giá đỡ điện thoại</li>
                                    <li>✓ Dịch vụ cứu hộ</li>
                                </ul>
                    
                                <a href="/thuexemay/dangnhap" class="btn btn-primary" style="width: 100%; font-weight: 600; padding: var(--spacing-md); display: block; text-align: center; text-decoration: none; margin-top: auto; color: white;" onmouseover="this.style.color='white'; this.style.opacity='0.9';" onmouseout="this.style.color='white'; this.style.opacity='1';">Thuê ngay</a>
                            </div>
                        </div>
                    </div>
                    <div style="text-align: center;">
                        <a href="#" style="display: inline-block; color: var(--color-primary); font-weight: 600; text-decoration: none; border-bottom: 2px solid var(--color-primary); padding-bottom: 4px;">
                            Xem thêm <iconify-icon icon="mdi:chevron-right" style="width: 18px; height: 18px; vertical-align: middle;"></iconify-icon>
                        </a>
                    </div>
                </div>
            </section>

            <!-- ===== CTA FINAL SECTION ===== -->
            <section style="padding: var(--spacing-3xl) var(--spacing-md);">
                <div class="app-container" style="text-align: center;">
                    <h2 style="font-size: var(--text-2xl); font-weight: 700; margin: 0 0 var(--spacing-md) 0;">Sẵn Sàng Bắt Đầu?</h2>
                    <p style="font-size: var(--text-md); color: var(--color-text-secondary); margin: 0 0 var(--spacing-lg) 0; max-width: 500px; margin-left: auto; margin-right: auto;">Tham gia hàng nghìn người dùng đã tin tưởng MotoBook</p>
                    <div style="display: flex; gap: var(--spacing-md); justify-content: center; flex-wrap: wrap;">
                        <a href="<%= ctxPath %>/dangky" class="btn btn-primary" style="padding: var(--spacing-md) var(--spacing-2xl); font-weight: 600;">
                            <iconify-icon icon="mdi:account-plus" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                            Tạo Tài Khoản
                        </a>
                        <a href="<%= ctxPath %>/dangnhap" class="btn btn-outline" style="padding: var(--spacing-md) var(--spacing-2xl); font-weight: 600;">
                            <iconify-icon icon="mdi:login" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                            Đã Có Tài Khoản
                        </a>
                    </div>
                </div>
            </section>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>

    <script src="<%= ctxPath %>/js/ui-utils.js"></script>
</body>
</html>