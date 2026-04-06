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
<html>
<head>
<meta charset="UTF-8">
<title>Quan Ly Goi Thue</title>
</head>
<body>

<h1>Quan Ly Goi Thue</h1>

<p><a href="<%=ctxPath%>/doitac/dashboard">← Quay lai Dashboard</a></p>

<h2>Danh Sach Goi Thue</h2>

<div id="goiThueList">
    <p>Dang tai...</p>
</div>

<hr>

<h2>Tao Goi Thue Moi</h2>

<form id="formTaoGoiThue">
    <div>
        <label>Ma Chi Nhanh:</label>
        <select name="maChiNhanh" id="maChiNhanh" required>
            <option value="">-- Chon Chi Nhanh --</option>
        </select>
    </div>
    <br>
    <div>
        <label>Ma Mau Xe:</label>
        <select name="maMauXe" id="maMauXe" required>
            <option value="">-- Chon Mau Xe --</option>
        </select>
    </div>
    <br>
    <div>
        <label>Ten Goi Thue:</label>
        <input type="text" name="tenGoiThue" required>
    </div>
    <br>
    <div>
        <label>Phu Kien:</label>
        <textarea name="phuKien" rows="3"></textarea>
    </div>
    <br>
    <div>
        <label>Gia Ngay (VND):</label>
        <input type="number" name="giaNgay" step="0.01" required>
    </div>
    <br>
    <div>
        <label>Gia Gio (VND):</label>
        <input type="number" name="giaGio" step="0.01" required>
    </div>
    <br>
    <div>
        <label>Phu Thu (VND):</label>
        <input type="number" name="phuThu" step="0.01" value="0">
    </div>
    <br>
    <div>
        <label>Giam Gia (%):</label>
        <input type="number" name="giamGia" step="0.01" min="0" max="100" value="0">
    </div>
    <br>
    <button type="submit">Tao Goi Thue</button>
</form>

<script>
const ctx = '<%=ctxPath%>';

// Load danh sach chi nhanh
fetch(ctx + '/doitac/quanlychinhanh?api=1')
    .then(res => res.text())
    .then(xml => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(xml, 'application/xml');
        const select = document.getElementById('maChiNhanh');
        doc.querySelectorAll('chiNhanh').forEach(cn => {
            const option = document.createElement('option');
            option.value = cn.querySelector('maChiNhanh').textContent;
            option.text = cn.querySelector('tenChiNhanh').textContent;
            select.appendChild(option);
        });
    })
    .catch(e => console.error('Loi load chi nhanh:', e));

// Load danh sach mau xe khi chon chi nhanh
document.getElementById('maChiNhanh').onchange = function() {
    const maChiNhanh = this.value;
    if (!maChiNhanh) {
        document.getElementById('maMauXe').innerHTML = '<option value="">-- Chon Mau Xe --</option>';
        return;
    }
    fetch(ctx + '/doitac/quanlymauxe?api=1&maChiNhanh=' + maChiNhanh)
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            const select = document.getElementById('maMauXe');
            select.innerHTML = '<option value="">-- Chon Mau Xe --</option>';
            doc.querySelectorAll('mauXe').forEach(mx => {
                const option = document.createElement('option');
                option.value = mx.querySelector('maMauXe').textContent;
                option.text = mx.querySelector('hangXe').textContent + ' ' + mx.querySelector('dongXe').textContent;
                select.appendChild(option);
            });
        })
        .catch(e => console.error('Loi load mau xe:', e));
};

// Load danh sach goi thue
function loadGoiThue() {
    fetch(ctx + '/doitac/quanlygoithue?api=1')
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            let html = '<table border="1" cellpadding="5">';
            html += '<tr><th>Ten Goi</th><th>Gia Ngay</th><th>Gia Gio</th><th>Phu Thu</th><th>Giam Gia</th></tr>';
            doc.querySelectorAll('goiThue').forEach(gt => {
                html += '<tr>';
                html += '<td>' + gt.querySelector('tenGoiThue').textContent + '</td>';
                html += '<td>' + gt.querySelector('giaNgay').textContent + '</td>';
                html += '<td>' + gt.querySelector('giaGio').textContent + '</td>';
                html += '<td>' + gt.querySelector('phuThu').textContent + '</td>';
                html += '<td>' + gt.querySelector('giamGia').textContent + '%</td>';
                html += '</tr>';
            });
            html += '</table>';
            document.getElementById('goiThueList').innerHTML = html;
        })
        .catch(e => {
            document.getElementById('goiThueList').innerHTML = '<p style="color: red;">Loi load danh sach: ' + e.message + '</p>';
        });
}

// Load khi trang load
loadGoiThue();

// Submit form tao goi thue
document.getElementById('formTaoGoiThue').onsubmit = async function(e) {
    e.preventDefault();
    const btn = this.querySelector('button');
    btn.disabled = true;

    try {
        const res = await fetch(ctx + '/doitac/quanlygoithue', {
            method: 'POST',
            body: new URLSearchParams(new FormData(this))
        });

        const xml = new DOMParser().parseFromString(await res.text(), 'application/xml');
        const status = xml.querySelector('status').textContent;
        const message = xml.querySelector('message').textContent;

        alert(message);

        if (status === 'success') {
            this.reset();
            loadGoiThue();
        }
    } catch (error) {
        alert('Loi: ' + error.message);
    } finally {
        btn.disabled = false;
    }
};
</script>

</body>
</html>
