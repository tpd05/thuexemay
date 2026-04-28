<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.DonThue, model.ChiTietDonThue, model.XeMay, java.util.List" %>
<%@ page import="dao.XeMayDAO" %>
<%@ page import="util.Connect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.net.InetAddress" %>
<%
String ctxPath = request.getContextPath();
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");

// Lấy địa chỉ IP của máy tính đang chạy server
String serverIP = null;
try {
    // Lấy IP address thực của máy 
    InetAddress inetAddress = InetAddress.getLocalHost();
    serverIP = inetAddress.getHostAddress();
} catch (Exception e) {
    // Fallback: sử dụng localhost
    serverIP = "localhost";
}

String serverPort = request.getServerPort() == 80 ? "" : ":" + request.getServerPort();
String serverAddress = "http://" + serverIP + serverPort + ctxPath;

if (username == null || role == null || !role.equals("KHACH_HANG")) {
    response.sendRedirect(ctxPath + "/views/403.jsp");
    return;
}

DonThue donThueAo = (DonThue) session.getAttribute("donThueAo");
if (donThueAo == null) {
    response.sendRedirect(ctxPath + "/khachhang/giohang");
    return;
}

List<ChiTietDonThue> dsChiTiet = donThueAo.getDsChiTiet();
long tongTien = 0;
for (ChiTietDonThue ct : dsChiTiet) {
    tongTien += ct.getDonGia();
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác Nhận Đơn Thuê</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 { color: #333; }
        h3 { color: #666; margin-top: 20px; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }
        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        table th {
            background-color: #f9f9f9;
            font-weight: bold;
        }
        .total {
            font-size: 18px;
            font-weight: bold;
            color: #d32f2f;
            margin: 20px 0;
        }
        .buttons {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        button {
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-confirm {
            background-color: #4CAF50;
            color: white;
        }
        .btn-confirm:hover {
            background-color: #45a049;
        }
        .btn-back {
            background-color: #888;
            color: white;
        }
        .btn-back:hover {
            background-color: #777;
        }

        /* Modal CSS */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 30px;
            border: 1px solid #888;
            border-radius: 8px;
            width: 400px;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .modal-content h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .modal-content img {
            max-width: 300px;
            width: 100%;
            margin: 20px 0;
        }
        .modal-content p {
            color: #666;
            font-size: 14px;
        }
        .modal-buttons {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        .btn-modal {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-open-momo {
            background-color: #A50064;
            color: white;
        }
        .btn-open-momo:hover {
            background-color: #850050;
        }
        .btn-cancel {
            background-color: #ccc;
            color: #333;
        }
        .btn-cancel:hover {
            background-color: #bbb;
        }

        .loading {
            display: none;
            text-align: center;
            margin: 20px 0;
        }
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #3498db;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .method-selector {
            margin: 20px 0;
            display: flex;
            gap: 20px;
        }
        .method-option {
            flex: 1;
            padding: 15px;
            border: 2px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            text-align: center;
        }
        .method-option input {
            display: none;
        }
        .method-option input:checked + label {
            font-weight: bold;
            color: #4CAF50;
        }
        .method-option:hover {
            border-color: #4CAF50;
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Xác Nhận Đơn Thuê</h1>
        <p>Xin chào <strong><%=username%></strong></p>

        <h3>Thông Tin Khách Hàng</h3>
        <p>Mã Khách: <%=donThueAo.getUserID()%></p>
        <p>Địa Chỉ Nhận Xe: <%=donThueAo.getDiaChiNhanXe()%></p>

        <h3>Chi Tiết Đơn Thuê</h3>
        <table border="1">
            <tr>
                <th>Gói Thuê</th>
                <th>Biển số xe</th>
                <th>Thời Gian Bắt Đầu</th>
                <th>Thời Gian Kết Thúc</th>
                <th>Đơn Giá (đ)</th>
            </tr>
            <%
            Connection con = null;
            XeMayDAO xeMayDAO = new XeMayDAO();
            for (ChiTietDonThue ct : dsChiTiet) {
                XeMay xe = null;
                try {
                    con = Connect.getInstance().getConnect();
                    xe = xeMayDAO.timXeTheoId(ct.getMaXe(), con);
                } catch (Exception e) {
                    // Nếu không lấy được xe, hiển thị ID
                } finally {
                    if (con != null) {
                        try { con.close(); } catch (Exception e) {}
                    }
                }
            %>
            <tr>
                <td><%=ct.getMaGoiThue()%></td>
                <td><%=(xe != null ? xe.getBienSo() : "N/A")%></td>
                <td><%=ct.getThoiGianBatDau()%></td>
                <td><%=ct.getThoiGianKetThuc()%></td>
                <td><%=String.format("%,d", ct.getDonGia())%></td>
            </tr>
            <%
            }
            %>
        </table>

        <div class="total">Tổng Cộng: <span id="tongTien"><%=String.format("%,d", tongTien)%></span> VND</div>

        <h3>Chọn Phương Thức Thanh Toán</h3>
        <div class="method-selector">
            <div class="method-option" onclick="selectMethod('EWALLET', this)">
                <input type="radio" name="method" value="EWALLET" id="ewallet" checked>
                <label for="ewallet">💳 Ví MoMo (EWALLET)</label>
                <p style="font-size: 12px; margin: 10px 0 0 0;">Quét mã QR hoặc nhập mã để thanh toán</p>
            </div>
            <div class="method-option" onclick="selectMethod('CARD', this)">
                <input type="radio" name="method" value="CARD" id="card">
                <label for="card">🏦 Thẻ Tín Dụng (CARD)</label>
                <p style="font-size: 12px; margin: 10px 0 0 0;">Thanh toán bằng thẻ ngân hàng</p>
            </div>
        </div>

        <div class="buttons">
            <button class="btn-confirm" onclick="confirmOrder()">Xác Nhận & Thanh Toán</button>
            <button class="btn-back" onclick="backToCart()">Quay Lại Giỏ Hàng</button>
        </div>
    </div>

    <!-- Modal hiển thị QR Code -->
    <div id="momoModal" class="modal">
        <div class="modal-content">
            <h2>QR Code Thanh Toán MoMo</h2>
            
            <div class="loading" id="loadingSpinner">
                <div class="spinner"></div>
                <p>Đang gọi API Momo, vui lòng chờ...</p>
            </div>

            <div id="qrContent" style="display: none;">
                <p id="paymentInfo">📱 Quét mã QR bằng điện thoại để thanh toán</p>
                <div id="qrCode" style="display: inline-block; padding: 10px; background: white; border: 2px solid #ddd; border-radius: 4px;"></div>
                <p id="amountText" style="font-size: 16px; font-weight: bold; color: #d32f2f; margin-top: 15px;"></p>
                <p style="font-size: 12px; color: #999;">💡 Mã QR sẽ hết hạn sau 3 phút</p>
            </div>

            <div class="modal-buttons">
                <button class="btn-modal btn-cancel" onclick="closeMomoModal()">Đóng</button>
            </div>
        </div>
    </div>

    <script src="https://davidshimjs.github.io/qrcodejs/qrcode.min.js"></script>
    <script>
    const ctx = '<%=ctxPath%>';
    const serverAddress = '<%=serverAddress%>';
    const tongTienValue = <%=tongTien%>;
    let currentPayUrl = null;
    let currentRequestId = null;
    let currentMaDon = null;

    function selectMethod(method, element) {
        // Xóa class active khỏi tất cả method-option
        document.querySelectorAll('.method-option').forEach(el => {
            el.style.borderColor = '#ddd';
        });
        // Thêm class active cho method được chọn
        element.style.borderColor = '#4CAF50';
        // Cập nhật value của radio button
        document.getElementById(method === 'EWALLET' ? 'ewallet' : 'card').checked = true;
    }

    function confirmOrder() {
        if (!confirm('Bạn có chắc chắn muốn xác nhận và thanh toán đơn thiếu này?')) {
            return;
        }

        // Gọi API tạo QR code trực tiếp (không tạo DonThue ngay)
        // DonThue chỉ được tạo sau khi Momo callback thành công
        createMomoQR(tongTienValue);
    }

    function createMomoQR(soTien) {
        const method = document.querySelector('input[name="method"]:checked').value;
        
        // Hiển thị modal loading
        document.getElementById('momoModal').style.display = 'block';
        document.getElementById('loadingSpinner').style.display = 'block';
        document.getElementById('qrContent').style.display = 'none';

        // Gọi API createQR
        const params = new URLSearchParams();
        params.append('action', 'createQR');
        params.append('soTien', soTien);
        params.append('method', method);

        fetch(ctx + '/khachhang/payment', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: params.toString()
        })
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            
            const status = doc.querySelector('status').textContent;
            const payUrl = doc.querySelector('payUrl') ? doc.querySelector('payUrl').textContent : null;
            const requestId = doc.querySelector('requestId') ? doc.querySelector('requestId').textContent : null;
            const errorMsg = doc.querySelector('message') ? doc.querySelector('message').textContent : '';

            if (status === 'success' && payUrl && requestId) {
                // ✅ Thành công - tạo QR code
                currentPayUrl = payUrl;
                currentRequestId = requestId;
                
                document.getElementById('loadingSpinner').style.display = 'none';
                document.getElementById('qrContent').style.display = 'block';
                document.getElementById('amountText').textContent = '💰 Số tiền: ' + String(soTien).replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' VND';
                
                console.log('✅ Tạo QR thành công!');
                console.log('PayUrl: ' + payUrl);
                console.log('RequestId: ' + requestId);

                // ✅ Tạo QR code pointing to mock payment URL
                const qrCodeContainer = document.getElementById('qrCode');
                qrCodeContainer.innerHTML = ''; // Clear previous
                
                // Full URL for QR code (using server IP address)
                const fullMockPaymentUrl = serverAddress + '/khachhang/payment-mock?requestId=' + requestId + '&amount=' + soTien;
                
                // Generate QR code
                new QRCode(qrCodeContainer, {
                    text: fullMockPaymentUrl,
                    width: 300,
                    height: 300,
                    colorDark: '#000000',
                    colorLight: '#ffffff',
                    correctLevel: QRCode.CorrectLevel.H
                });
                
                console.log('✅ QR Code generated: ' + fullMockPaymentUrl);
                
                // ✅ Bắt đầu polling để kiểm tra trạng thái thanh toán từ điện thoại
                startPaymentPolling(requestId);

            } else {
                // ❌ Lỗi
                document.getElementById('loadingSpinner').style.display = 'none';
                alert('✗ Lỗi tạo QR: ' + errorMsg);
                document.getElementById('momoModal').style.display = 'none';
            }
        })
        .catch(e => {
            document.getElementById('loadingSpinner').style.display = 'none';
            alert('✗ Lỗi: ' + e.message);
            document.getElementById('momoModal').style.display = 'none';
        });
    }

    function openMomoPayment() {
        if (currentPayUrl) {
            // Mở payUrl trong cửa sổ mới
            window.open(currentPayUrl, 'MoMoPayment', 'width=500,height=700');
        }
    }

    function closeMomoModal() {
        document.getElementById('momoModal').style.display = 'none';
    }

    function startPaymentPolling(requestId) {
        let pollCount = 0;
        const maxPolls = 36; // 3 phút / 5 giây = 36 lần polling
        const pollInterval = setInterval(() => {
            pollCount++;

            // Gọi API checkStatus để kiểm tra trạng thái ThanhToan
            const params = new URLSearchParams();
            params.append('action', 'checkStatus');
            params.append('requestId', requestId);

            fetch(ctx + '/khachhang/payment', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: params.toString()
            })
            .then(res => res.text())
            .then(xml => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(xml, 'application/xml');
                const status = doc.querySelector('status') ? doc.querySelector('status').textContent : 'error';

                console.log('📊 Polling #' + pollCount + ' - Status: ' + status);

                if (status === 'success') {
                    // ✅ Thanh toán thành công
                    clearInterval(pollInterval);
                    document.getElementById('momoModal').style.display = 'none';
                    alert('✓ Thanh toán thành công! Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi.');
                    window.location.href = ctx + '/khachhang/lich-su-don-hang';
                }
            })
            .catch(e => {
                console.error('❌ Lỗi polling: ' + e.message);
            });

            // Nếu polling quá lâu, dừng lại
            if (pollCount >= maxPolls) {
                clearInterval(pollInterval);
                console.log('⏰ QR code hết hạn (3 phút)');
                alert('⏰ Mã QR đã hết hạn. Vui lòng thực hiện lại đơn hàng.');
                document.getElementById('momoModal').style.display = 'none';
            }
        }, 5000); // Polling mỗi 5 giây
    }

    function backToCart() {
        window.location.href = ctx + '/khachhang/giohang';
    }

    // Đóng modal khi click bên ngoài
    window.onclick = function(event) {
        const modal = document.getElementById('momoModal');
        if (event.target == modal) {
            modal.style.display = 'none';
        }
    }
    </script>
</body>
</html>