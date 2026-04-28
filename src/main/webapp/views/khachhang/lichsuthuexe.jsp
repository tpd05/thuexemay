<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch Sử Đơn Hàng</title>
</head>
<body>
    <h1>Lịch Sử Đơn Hàng Thanh Toán</h1>
    
    <div>
        <a href="/thuexemay/khachhang/giohang">Về Giỏ Hàng</a>
        <a href="/thuexemay/index.jsp">Trang Chủ</a>
        <a href="/thuexemay/auth/logout">Đăng Xuất</a>
    </div>

    <% 
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <p style="color: red;">Lỗi: <%= error %></p>
    <% 
        }
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> donThueDanhSach = (List<Map<String, Object>>) request.getAttribute("donThueDanhSach");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>

    <% if (donThueDanhSach != null && !donThueDanhSach.isEmpty()) { %>
        <table border="1" cellpadding="10" cellspacing="0">
            <thead>
                <tr>
                    <th>Mã Đơn</th>
                    <th>Trạng Thái</th>
                    <th>Địa Chỉ Nhận Xe</th>
                    <th>Ngày Tạo</th>
                    <th>Số Lượng Xe</th>
                    <th>Tổng Tiền</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, Object> don : donThueDanhSach) { %>
                    <tr>
                        <td>#<%= don.get("maDonThue") %></td>
                        <td>Đã Thanh Toán</td>
                        <td><%= don.get("diaChiNhanXe") %></td>
                        <td>
                            <% 
                                java.util.Date date = (java.util.Date) don.get("ngayTao");
                                if (date != null) {
                                    out.print(sdf.format(date));
                                }
                            %>
                        </td>
                        <td><%= don.get("soLuongXe") %> xe</td>
                        <td><%= String.format("%,d", don.get("tongTien")) %> đ</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p>Chưa có đơn hàng thanh toán</p>
        <a href="/thuexemay/khachhang/danhsachgoithue">Tìm Gói Thuê Xe</a>
    <% } %>
</body>
</html>
