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
<title>Quan Ly Mau Xe</title>
</head>
<body>

<h1>Quan Ly Mau Xe</h1>

<p><a href="<%=ctxPath%>/doitac/dashboard">← Quay lai Dashboard</a></p>

<h2>Danh Sach Mau Xe</h2>

<div>
    <label>Loc theo Chi Nhanh:</label>
    <select id="filterChiNhanh">
        <option value="">-- Tat Ca Chi Nhanh --</option>
    </select>
</div>

<div id="mauXeList">
    <p>Dang tai...</p>
</div>

<hr>

<h2>Them Mau Xe Moi</h2>

<form id="formThemMauXe">
    <div>
        <label>Chi Nhanh:</label>
        <select name="maChiNhanh" id="maChiNhanhForm" required>
            <option value="">-- Chon Chi Nhanh --</option>
        </select>
    </div>
    <br>
    <div>
        <label>Hang Xe:</label>
        <input type="text" name="hangXe" required>
    </div>
    <br>
    <div>
        <label>Dong Xe:</label>
        <input type="text" name="dongXe" required>
    </div>
    <br>
    <div>
        <label>Doi Xe:</label>
        <input type="text" name="doiXe" required>
    </div>
    <br>
    <div>
        <label>Dung Tich (cc):</label>
        <input type="number" name="dungTich" required>
    </div>
    <br>
    <div>
        <label>URL Hinh Anh:</label>
        <input type="text" name="urlHinhAnh">
    </div>
    <br>
    <button type="submit">Them Mau Xe</button>
</form>

<script>
const ctx = '<%=ctxPath%>';

// Load danh sach chi nhanh
function loadChiNhanh() {
    fetch(ctx + '/doitac/quanlychinhanh?api=1')
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            
            const selectFilter = document.getElementById('filterChiNhanh');
            const selectForm = document.getElementById('maChiNhanhForm');
            
            doc.querySelectorAll('chiNhanh').forEach(cn => {
                const maChiNhanh = cn.querySelector('maChiNhanh').textContent;
                const tenChiNhanh = cn.querySelector('tenChiNhanh').textContent;
                
                const optionFilter = document.createElement('option');
                optionFilter.value = maChiNhanh;
                optionFilter.text = tenChiNhanh;
                selectFilter.appendChild(optionFilter);
                
                const optionForm = document.createElement('option');
                optionForm.value = maChiNhanh;
                optionForm.text = tenChiNhanh;
                selectForm.appendChild(optionForm);
            });
        })
        .catch(e => console.error('Loi load chi nhanh:', e));
}

// Load danh sach mau xe
function loadMauXe(maChiNhanh = '') {
    let url = ctx + '/doitac/quanlymauxe?api=1';
    if (maChiNhanh) {
        url += '&maChiNhanh=' + maChiNhanh;
    }
    
    fetch(url)
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            let html = '<table border="1" cellpadding="5">';
            html += '<tr><th>Hang Xe</th><th>Dong Xe</th><th>Doi Xe</th><th>Dung Tich</th></tr>';
            doc.querySelectorAll('mauXe').forEach(mx => {
                html += '<tr>';
                html += '<td>' + mx.querySelector('hangXe').textContent + '</td>';
                html += '<td>' + mx.querySelector('dongXe').textContent + '</td>';
                html += '<td>' + mx.querySelector('doiXe').textContent + '</td>';
                html += '<td>' + mx.querySelector('dungTich').textContent + ' cc</td>';
                html += '</tr>';
            });
            html += '</table>';
            
            if (doc.querySelectorAll('mauXe').length === 0) {
                html = '<p>Khong co mau xe nao.</p>';
            }
            
            document.getElementById('mauXeList').innerHTML = html;
        })
        .catch(e => {
            document.getElementById('mauXeList').innerHTML = '<p style="color: red;">Loi load danh sach: ' + e.message + '</p>';
        });
}

// Load khi trang load
loadChiNhanh();
loadMauXe();

// Loc khi chon chi nhanh
document.getElementById('filterChiNhanh').onchange = function() {
    loadMauXe(this.value);
};

// Submit form them mau xe
document.getElementById('formThemMauXe').onsubmit = async function(e) {
    e.preventDefault();
    const btn = this.querySelector('button');
    btn.disabled = true;

    try {
        const res = await fetch(ctx + '/doitac/quanlymauxe', {
            method: 'POST',
            body: new URLSearchParams(new FormData(this))
        });

        const xml = new DOMParser().parseFromString(await res.text(), 'application/xml');
        const status = xml.querySelector('status').textContent;
        const message = xml.querySelector('message').textContent;

        alert(message);

        if (status === 'success') {
            this.reset();
            loadMauXe(document.getElementById('filterChiNhanh').value);
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
