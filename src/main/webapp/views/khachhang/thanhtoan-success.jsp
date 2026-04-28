<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh Toán Thành Công | Thuê Xe May</title>
</head>
<body>

<div style="max-width: 600px; margin: 50px auto; border: 2px solid #4caf50; padding: 30px; text-align: center; background: #c8e6c9;">

    <h1 style="color: #2e7d32;">✓ THANH TOÁN THÀNH CÔNG</h1>

    <p style="font-size: 16px;">Cảm ơn bạn đã hoàn thành thanh toán!</p>

    <div style="background: white; padding: 20px; margin: 20px 0; border-radius: 5px;">
        <p><strong>Thông tin giao dịch:</strong></p>
        <p>Đơn thuê của bạn đã được xác nhận và lưu vào hệ thống.</p>
        <p style="color: #2e7d32; font-weight: bold;">Bạn có thể theo dõi lịch sử đơn thuê tại dashboard.</p>
    </div>

    <div style="margin: 30px 0;">
        <a href="${pageContext.request.contextPath}/khachhang/lich-su-don-hang"
           style="padding: 12px 30px; background: #4caf50; color: white; text-decoration: none; font-size: 16px; border-radius: 3px;">
            Xem Lịch Sử Đơn Thuê
        </a>
    </div>

    <div style="margin: 20px 0;">
        <a href="${pageContext.request.contextPath}/khachhang/dashboard"
           style="padding: 10px 20px; background: #2196F3; color: white; text-decoration: none;">
            Quay Lại Dashboard
        </a>
    </div>

</div>

</body>
</html>
