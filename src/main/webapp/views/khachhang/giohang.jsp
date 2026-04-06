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
    <title>Giỏ Hàng</title></head>
<body>
    <h1>Giỏ Hàng</h1>
    <p>Xin chào <strong><%=username%></strong> | <a href="javascript:void(0);" onclick="confirmLogout()">Đăng Xuất</a></p>

    <hr>

    <h2>Menu</h2>
    <ul>
        <li><a href="<%=ctxPath%>/khachhang/dashboard">Trở Về Dashboard</a></li>
        <li><a href="<%=ctxPath%>/khachhang/lichsuthuexe">Lịch Sử Thuê Xe</a></li>
    </ul>

    <hr>

    <h2>Chi Tiết Giỏ Hàng</h2>
    <div id="cartContainer"></div>

    <hr>

    <h2>Địa Chỉ Nhận Xe</h2>
    <div>
        <textarea id="diaChiNhanXe" placeholder="Nhập địa chỉ nhận xe" style="width: 100%; height: 80px;" lang="vi" charset="UTF-8"></textarea>
        <br><br>
        <button onclick="updateDiaChi()">Cập Nhật Địa Chỉ</button>
    </div>

    <hr>

    <h2>Tổng Tiền</h2>
    <div id="totalContainer" style="font-size: 18px; font-weight: bold;">
        Tổng cộng: <span id="tongTien">0</span> VND
    </div>

    <hr>

    <button onclick="goToDashboard()">Quay Lại Dashboard</button>
    <button onclick="checkout()">Xác Nhận & Thanh Toán</button>

    <script>
    const ctx = '<%=ctxPath%>';

    // Load giỏ hàng
    function loadCart() {
        fetch(ctx + '/khachhang/giohang?api=1')
            .then(res => res.text())
            .then(xml => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(xml, 'application/xml');
                
                const container = document.getElementById('cartContainer');
                const diaChiInput = document.getElementById('diaChiNhanXe');
                
                const diaChi = doc.querySelector('diaChiNhanXe');
                if (diaChi && diaChi.textContent) {
                    diaChiInput.value = diaChi.textContent;
                }
                
                const items = doc.querySelectorAll('item');
                let html = '';
                
                if (items.length === 0) {
                    html = '<p>Giỏ hàng của bạn đang trống</p>';
                    document.getElementById('tongTien').textContent = '0';
                } else {
                    html += '<table>';
                    html += '<tr>';
                    html += '<th>Tên Gói</th>';
                    html += '<th>Thời Gian Thuê</th>';
                    html += '<th>Thời Gian Trả</th>';
                    html += '<th>Kiểm Tra</th>';
                    html += '<th>Số Xe Còn</th>';
                    html += '<th>Số Lượng</th>';
                    html += '<th>Giá/Ngày (đ)</th>';
                    html += '<th>Giá/Giờ (đ)</th>';
                    html += '<th>Hành Động</th>';
                    html += '</tr>';
                    
                    items.forEach(item => {
                        const maGoiThue = item.querySelector('maGoiThue').textContent;
                        const tenGoiThue = item.querySelector('tenGoiThue').textContent;
                        const soLuong = parseInt(item.querySelector('soLuong').textContent);
                        const giaNgay = item.querySelector('giaNgay').textContent;
                        const giaGio = item.querySelector('giaGio').textContent;
                        
                        let batDauValue = '';
                        let ketThucValue = '';
                        
                        const bdElem = item.querySelector('thoiGianBatDau');
                        const ktElem = item.querySelector('thoiGianKetThuc');
                        
                        if (bdElem && bdElem.textContent) {
                            batDauValue = bdElem.textContent.substring(0, 16);
                        }
                        if (ktElem && ktElem.textContent) {
                            ketThucValue = ktElem.textContent.substring(0, 16);
                        }
                        
                        html += '<tr>';
                        html += '<td>' + escapeHtml(tenGoiThue) + '</td>';
                        html += '<td><input type="datetime-local" id="bd_' + maGoiThue + '" value="' + batDauValue + '"></td>';
                        html += '<td><input type="datetime-local" id="kt_' + maGoiThue + '" value="' + ketThucValue + '"></td>';
                        html += '<td><button onclick="checkAvailable(' + maGoiThue + ')">Kiểm Tra</button></td>';
                        html += '<td><span id="avail_' + maGoiThue + '">-</span></td>';
                        html += '<td><input type="number" id="qty_' + maGoiThue + '" value="' + soLuong + '" min="1"></td>';
                        html += '<td>' + giaNgay + '</td>';
                        html += '<td>' + giaGio + '</td>';
                        html += '<td>';
                        html += '<button onclick="updateItem(' + maGoiThue + ')">Cập Nhật</button> ';
                        html += '<button onclick="removeItem(' + maGoiThue + ')">Xóa</button>';
                        html += '</td>';
                        html += '</tr>';
                    });
                    
                    html += '</table>';
                }
                
                container.innerHTML = html;
                calculateTotal();
            })
            .catch(e => {
                document.getElementById('cartContainer').innerHTML = '<p style="color: red;">Lỗi: ' + e.message + '</p>';
            });
    }

    function updateItem(maGoiThue) {
        const batDauInput = document.getElementById('bd_' + maGoiThue).value;
        const ketThucInput = document.getElementById('kt_' + maGoiThue).value;
        const soLuong = document.getElementById('qty_' + maGoiThue).value;
        
        if (!batDauInput || !ketThucInput) {
            alert('Vui lòng nhập cả thời gian thuê và thời gian trả');
            return;
        }
        
        if (!soLuong || soLuong < 1) {
            alert('Số lượng không hợp lệ');
            return;
        }
        
        const batDau = new Date(batDauInput).toISOString().substring(0, 19);
        const ketThuc = new Date(ketThucInput).toISOString().substring(0, 19);
        
        fetch(ctx + '/khachhang/giohang', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'action=update&maGoiThue=' + maGoiThue + 
                  '&soLuong=' + soLuong +
                  '&thoiGianBatDau=' + encodeURIComponent(batDau) +
                  '&thoiGianKetThuc=' + encodeURIComponent(ketThuc)
        })
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            
            if (doc.querySelector('error')) {
                alert('Lỗi: ' + escapeHtml(doc.querySelector('error').textContent || doc.querySelector('message').textContent));
                loadCart();
                return;
            }
            
            const status = doc.querySelector('status').textContent;
            if (status === 'success') {
                alert('Cập nhật thành công');
                loadCart();
            } else {
                alert('Cập nhật thất bại');
                loadCart();
            }
        })
        .catch(e => alert('Lỗi: ' + escapeHtml(e.message)));
    }

    function checkAvailable(maGoiThue) {
        const batDauInput = document.getElementById('bd_' + maGoiThue).value;
        const ketThucInput = document.getElementById('kt_' + maGoiThue).value;
        
        if (!batDauInput || !ketThucInput) {
            alert('Vui lòng nhập cả thời gian thuê và thời gian trả');
            return;
        }
        
        const batDau = new Date(batDauInput).toISOString().substring(0, 19);
        const ketThuc = new Date(ketThucInput).toISOString().substring(0, 19);
        
        fetch(ctx + '/khachhang/giohang', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'action=checkAvailable&maGoiThue=' + maGoiThue + 
                  '&thoiGianBatDau=' + encodeURIComponent(batDau) +
                  '&thoiGianKetThuc=' + encodeURIComponent(ketThuc)
        })
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            
            if (doc.querySelector('error')) {
                alert('Lỗi: ' + escapeHtml(doc.querySelector('error').textContent));
                return;
            }
            
            const soLuongCon = parseInt(doc.querySelector('soLuongCon').textContent);
            const availSpan = document.getElementById('avail_' + maGoiThue);
            
            if (soLuongCon > 0) {
                availSpan.innerHTML = soLuongCon + ' xe';
                availSpan.style.color = 'green';
            } else {
                availSpan.innerHTML = 'Hết xe';
                availSpan.style.color = 'red';
            }
        })
        .catch(e => alert('Lỗi: ' + escapeHtml(e.message)));
    }

    function removeItem(maGoiThue) {
        if (!confirm('Bạn có chắc chắn muốn xóa gói này?')) return;
        
        fetch(ctx + '/khachhang/giohang', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'action=delete&maGoiThue=' + maGoiThue
        })
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            const status = doc.querySelector('status').textContent;
            
            if (status === 'success') {
                loadCart();
            } else {
                alert('Xóa thất bại');
            }
        })
        .catch(e => alert('Lỗi: ' + escapeHtml(e.message)));
    }

    function updateDiaChi() {
        const diaChi = document.getElementById('diaChiNhanXe').value.trim();
        if (!diaChi) {
            alert('Vui lòng nhập địa chỉ');
            return;
        }
        
        fetch(ctx + '/khachhang/giohang', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
            body: 'action=updateAddress&diaChiNhanXe=' + encodeURIComponent(diaChi)
        })
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            const status = doc.querySelector('status').textContent;
            
            if (status === 'success') {
                alert('Cập nhật địa chỉ thành công');
            } else {
                alert('Cập nhật thất bại');
            }
        })
        .catch(e => alert('Lỗi: ' + escapeHtml(e.message)));
    }

    function calculateTotal() {
        // Placeholder: total calculation would require loading full cart data
        // For now, users will see total after updating rental times
        const tongTienSpan = document.getElementById('tongTien');
        tongTienSpan.textContent = '(Nhập thời gian và cập nhật để tính giá)';
    }

    function checkout() {
        // Validate cart has items
        const cartContainer = document.getElementById('cartContainer');
        const table = cartContainer.querySelector('table');
        
        if (!table) {
            alert('Giỏ hàng trống');
            return;
        }
        
        const diaChi = document.getElementById('diaChiNhanXe').value;
        if (!diaChi.trim()) {
            alert('Vui lòng cập nhật địa chỉ nhận xe trước khi thanh toán');
            return;
        }
        
        // Check all items have time info
        const rows = table.querySelectorAll('tr');
        let hasData = false;
        
        for (let row of rows) {
            const bdInput = row.querySelector('[id^="bd_"]');
            const ktInput = row.querySelector('[id^="kt_"]');
            
            if (bdInput && ktInput) {
                hasData = true;
                if (!bdInput.value || !ktInput.value) {
                    alert('Vui lòng nhập thời gian thuê và trả cho tất cả gói');
                    return;
                }
            }
        }
        
        if (!hasData) {
            alert('Giỏ hàng trống');
            return;
        }

        if (!confirm('Bạn có chắc chắn muốn tiếp tục đến trang thanh toán?')) {
            return;
        }
        
        // Prepare checkout - create DonThueAo in session
        fetch(ctx + '/khachhang/giohang', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
            body: 'action=prepareCheckout&diaChiNhanXe=' + encodeURIComponent(diaChi)
        })
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            const status = doc.querySelector('status').textContent;
            
            if (status === 'success') {
                // Redirect to checkout page
                window.location.href = ctx + '/khachhang/checkout';
            } else {
                const message = doc.querySelector('message') ? doc.querySelector('message').textContent : 'Lỗi không xác định';
                alert('Lỗi: ' + escapeHtml(message));
            }
        })
        .catch(e => alert('Lỗi: ' + escapeHtml(e.message)));
    }

    function goToDashboard() {
        window.location.href = ctx + '/khachhang/dashboard';
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
    window.addEventListener('DOMContentLoaded', loadCart);
    </script>
</body>
</html>
