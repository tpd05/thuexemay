<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.DonThue, model.ChiTietDonThue, java.util.List" %>
<%
String ctxPath = request.getContextPath();
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");

if (username == null || !role.equals("KHACH_HANG")) {
    response.sendRedirect(ctxPath + "/views/403.jsp");
    return;
}

Integer maDon = (Integer) request.getAttribute("maDon");
DonThue don = (DonThue) request.getAttribute("don");

if (maDon == null || don == null) {
    response.sendRedirect(ctxPath + "/khachhang/dashboard");
    return;
}

// Tính tổng tiền từ chi tiết đơn
long tongTien = 0;
List<ChiTietDonThue> dsChiTiet = don.getDsChiTiet();
if (dsChiTiet != null) {
    for (ChiTietDonThue ct : dsChiTiet) {
        tongTien += ct.getDonGia();
    }
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chọn Phương Thức Thanh Toán</title>
</head>
<body>
    <h1>Chọn Phương Thức Thanh Toán</h1>
    <p>Xin chào <strong><%=username%></strong></p>
    <p>Đơn thuê: <strong><%=maDon%></strong></p>

    <h3>Thông Tin Thanh Toán</h3>
    <p>Số tiền: <strong><%=String.format("%,d", tongTien)%></strong> VND</p>

    <h3>Chọn Phương Thức Thanh Toán</h3>
    <div>
        <label>
            <input type="radio" name="paymentMethod" value="EWALLET" checked>
            💳 Ví Điện Tử (MoMo)
        </label>
    </div>
    <div>
        <label>
            <input type="radio" name="paymentMethod" value="CARD">
            🏦 Thẻ Tín Dụng
        </label>
    </div>

    <h3>Điều Khoản &amp; Xác Nhận</h3>
    <label>
        <input type="checkbox" id="terms" required>
        Tôi đồng ý với điều khoản thanh toán
    </label>

    <br><br>

    <button onclick="confirmPayment()">Xác Nhận & Thanh Toán</button>
    <button onclick="backToCart()">Quay Lại</button>

    <!-- Loading indicator -->
    <div id="loadingMessage" style="display:none; margin-top:20px; font-weight:bold;">
        <p>Đang kết nối đến Momo...</p>
    </div>

    <!-- QR Display (hidden by default) -->
    <div id="qrContainer" style="display:none; margin-top:30px; text-align:center;">
        <h2>Quét mã QR để thanh toán</h2>
        <img id="qrImage" src="" alt="QR Code" style="max-width:300px;">
        <p id="qrMessage" style="color:blue; margin-top:10px;">Thời hạn: 3 phút</p>
        <p style="color:red; font-size:12px;">(*) Nếu sau 3 phút bạn chưa thanh toán, mã QR sẽ hết hạn. Vui lòng refresh và thử lại.</p>
        <button onclick="checkPaymentStatus()">Kiểm Tra Trạng Thái</button>
        <button onclick="cancelPayment()">Hủy Thanh Toán</button>
    </div>

    <script>
    var ctx = '<%=ctxPath%>';
    var maDon = '<%=maDon%>';
    var tongTien = '<%=tongTien%>';
    let paymentRequestId = null;
    let qrTimer = null;

    function confirmPayment() {
        if (!document.getElementById('terms').checked) {
            alert('Vui lòng đồng ý với điều khoản thanh toán');
            return;
        }

        const method = document.querySelector('[name="paymentMethod"]:checked').value;
        
        // Show loading
        document.getElementById('loadingMessage').style.display = 'block';
        document.querySelector('button').disabled = true;

        fetch(ctx + '/khachhang/payment', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
            body: 'action=createQR&maDon=' + maDon + '&method=' + method + '&soTien=' + tongTien
        })
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            const status = doc.querySelector('status').textContent;

            if (status === 'success') {
                const payUrl = doc.querySelector('payUrl').textContent;
                // ✅ Get requestId từ response
                paymentRequestId = doc.querySelector('requestId').textContent;
                
                // Extract requestId from Momo response (gọi Momo page để lấy)
                // Tạm thời redirect đến Momo payment page
                document.getElementById('loadingMessage').style.display = 'none';
                
                // Open Momo payment in new window
                const momoWindow = window.open(payUrl, 'momo_payment', 'width=600,height=700');
                
                // Check payment status every 5 seconds
                startPaymentPolling();
                
            } else {
                const message = doc.querySelector('message').textContent;
                document.getElementById('loadingMessage').style.display = 'none';
                alert('Lỗi: ' + message + '\nVui lòng thử lại sau');
                location.reload();
            }
        })
        .catch(e => {
            document.getElementById('loadingMessage').style.display = 'none';
            alert('Lỗi kết nối: ' + e.message);
        });
    }

    function startPaymentPolling() {
        // Polling every 5 seconds for 3 minutes max
        let pollCount = 0;
        const maxPolls = 36; // 3 minutes / 5 seconds
        
        qrTimer = setInterval(() => {
            pollCount++;
            
            if (pollCount >= maxPolls) {
                clearInterval(qrTimer);
                alert('Mã QR đã hết hạn (3 phút). Vui lòng thử lại.');
                location.reload();
                return;
            }
            
            checkPaymentStatus();
        }, 5000);
    }

    function checkPaymentStatus() {
        // ✅ Use requestId (not maDon) for checking payment status
        // This checks Momo API via our PaymentServlet which verifies if payment succeeded
        fetch(ctx + '/khachhang/payment', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
            body: 'action=checkStatus&requestId=' + paymentRequestId
        })
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            const status = doc.querySelector('status') ? doc.querySelector('status').textContent : '';
            const trangThai = doc.querySelector('trangThai') ? doc.querySelector('trangThai').textContent : '';

            // Check both status and trangThai fields (for backward compatibility)
            const current_status = status || trangThai;

            if (current_status === 'SUCCESS' || current_status === 'PAID' || current_status === 'success') {
                clearInterval(qrTimer);
                alert('✓ Thanh toán thành công! Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi.');
                window.location.href = ctx + '/khachhang/lich-su-don-hang';
            } else if (current_status === 'FAILED' || current_status === 'CANCELLED') {
                clearInterval(qrTimer);
                alert('❌ Thanh toán thất bại. Vui lòng thử lại.');
                location.reload();
            }
        })
        .catch(e => console.log('Polling error: ' + e.message));
    }

    function cancelPayment() {
        if (!confirm('Bạn có chắc chắn muốn hủy thanh toán không?')) {
            return;
        }
        
        clearInterval(qrTimer);
        alert('Đã hủy thanh toán. Bạn có thể thử lại bất cứ lúc nào.');
        location.reload();
    }

    function backToCart() {
        window.location.href = ctx + '/khachhang/giohang';
    }
    </script>
</body>
</html>
