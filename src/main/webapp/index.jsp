<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<html>
<head>
    <meta charset="UTF-8">
    <title>Hệ Thống Cho Thuê Xe Máy</title>
</head>
<body>
    <h1>Hệ Thống Quản Lý Cho Thuê Xe Máy</h1>

    <div>
        <h2>Chào Mừng Bạn</h2>
        <p>Đây là hệ thống cho thuê xe máy trực tuyến. Khách hàng có thể thuê xe từ các đối tác, quản lý đơn hàng và thanh toán trực tuyến.</p>
    </div>

    <hr>

    <div>
        <h2>Các Chức Năng Chính</h2>
        <ul>
            <li><strong>Khách Hàng:</strong>
                <ul>
                    <li>Xem danh sách gói thuê xe</li>
                    <li>Thêm xe vào giỏ hàng</li>
                    <li>Quản lý giỏ hàng (cập nhật thời gian, địa chỉ)</li>
                    <li>Xác nhận đơn hàng và thanh toán</li>
                    <li>Xem lịch sử đơn hàng</li>
                </ul>
            </li>
            <li><strong>Đối Tác:</strong>
                <ul>
                    <li>Quản lý xe máy (thêm, cập nhật trạng thái)</li>
                    <li>Quản lý gói thuê (thêm, cập nhật giá)</li>
                    <li>Xem danh sách đơn hàng</li>
                </ul>
            </li>
            <li><strong>Admin:</strong>
                <ul>
                    <li>Quản lý người dùng (khách hàng, đối tác)</li>
                    <li>Xem thống kê và báo cáo</li>
                    <li>Bảng điều khiển tổng hợp</li>
                </ul>
            </li>
        </ul>
    </div>

    <hr>

    <div>
        <h2>Bắt Đầu Sử Dụng</h2>
        <p>
            <a href="<%=ctxPath%>/dangnhap" style="margin-right: 20px;">
                <button>Đăng Nhập</button>
            </a>
            <a href="<%=ctxPath%>/dangky">
                <button>Đăng Ký</button>
            </a>
        </p>
    </div>

    <hr>

    <div>
        <h2>Liên Hệ</h2>
        <p>Email: support@thuexemay.com</p>
        <p>Điện Thoại: 1900-xxxx</p>
        <p>Địa Chỉ: Thành Phố Hồ Chí Minh, Việt Nam</p>
    </div>

    <hr>

    <footer>
        <p>&copy; 2024 Hệ Thống Cho Thuê Xe Máy. Bản Quyền Được Bảo Vệ.</p>
    </footer>
</body>
</html>