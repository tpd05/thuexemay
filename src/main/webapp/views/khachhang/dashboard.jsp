<%@ page contentType="text/html; charset=UTF-8" %>
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
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Khách Hàng</title>
</head>
<body>
    <h1>Trang Chủ Khách Hàng</h1>
    <p>Xin chào <strong><%=username%></strong> | <a href="javascript:void(0);" onclick="confirmLogout()">Đăng Xuất</a></p>

    <hr>

    <h2>Menu</h2>
    <ul>
        <li><a href="<%=ctxPath%>/khachhang/giohang">Giỏ Hàng</a></li>
        <li><a href="<%=ctxPath%>/khachhang/lichsuthuexe">Lịch Sử Thuê Xe</a></li>
    </ul>

    <hr>

    <h2>Các Gói Thuê Xe Máy</h2>
    <div id="goiThueContainer"></div>

    <hr>

    <script>
    const ctx = '<%=ctxPath%>';

    // Load danh sách gói thuê
    function loadGoiThue() {
        fetch(ctx + '/khachhang/danhsachgoithue?api=1')
            .then(res => res.text())
            .then(xml => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(xml, 'application/xml');
                
                const container = document.getElementById('goiThueContainer');
                
                let html = '';
                let hasData = false;
                
                doc.querySelectorAll('goiThue').forEach(gt => {
                    hasData = true;
                    const maGoiThue = gt.querySelector('maGoiThue').textContent;
                    const tenGoiThue = gt.querySelector('tenGoiThue').textContent;
                    const phuKien = gt.querySelector('phuKien') ? gt.querySelector('phuKien').textContent : 'Không có';
                    const giaNgay = gt.querySelector('giaNgay').textContent;
                    const giaGio = gt.querySelector('giaGio').textContent;
                    const phuThu = gt.querySelector('phuThu').textContent;
                    const giamGia = gt.querySelector('giamGia').textContent;
                    
                    html += '<div style="border: 1px solid #ccc; padding: 15px; margin: 10px 0; width: 300px; display: inline-block;">' +
                            '<h3>' + escapeHtml(tenGoiThue) + '</h3>' +
                            '<p><strong>Phụ kiện:</strong> ' + escapeHtml(phuKien) + '</p>' +
                            '<p><strong>Giá/Ngày:</strong> ' + giaNgay + ' đ</p>' +
                            '<p><strong>Giá/Giờ:</strong> ' + giaGio + ' đ</p>' +
                            '<p><strong>Phụ thu:</strong> ' + phuThu + ' đ</p>' +
                            '<p><strong>Giảm giá:</strong> ' + giamGia + '%</p>' +
                            '<button onclick="themVaoGio(' + maGoiThue + ')">Thêm Vào Giỏ</button>' +
                            '</div>';
                });
                
                if (!hasData) {
                    html = '<p>Không có gói thuê nào</p>';
                }
                
                container.innerHTML = html;
            })
            .catch(e => {
                document.getElementById('goiThueContainer').innerHTML = '<p style="color: red;">Lỗi: ' + e.message + '</p>';
            });
    }

    function themVaoGio(maGoiThue) {
        fetch(ctx + '/khachhang/them-goi-vao-gio', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'maGoiThue=' + maGoiThue + '&soLuong=1'
        })
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            const status = doc.querySelector('status')?.textContent || 'error';
            const message = doc.querySelector('message')?.textContent || 'Thêm vào giỏ hàng thành công';
            
            if (status === 'success') {
                alert(message);
            } else {
                alert('Lỗi: ' + message);
            }
        })
        .catch(e => alert('Lỗi: ' + e.message));
    }

    function confirmLogout() {
        if (confirm('Bạn có muốn đăng xuất!')) {
            window.location.href = ctx + '/logout';
        }
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

    // Load on page load
    window.addEventListener('DOMContentLoaded', loadGoiThue);
    </script>
</body>
</html>