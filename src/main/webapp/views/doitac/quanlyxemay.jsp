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
<title>Quan Ly Xe May</title>
</head>
<body>

<h1>Quan Ly Xe May</h1>

<p><a href="<%=ctxPath%>/doitac/dashboard">← Quay lai Dashboard</a></p>

<h2>Danh Sach Xe May</h2>

<div>
    <label>Loc theo Chi Nhanh:</label>
    <select id="filterChiNhanh">
        <option value="">-- Tat Ca Chi Nhanh --</option>
    </select>
</div>

<div id="xeMayList">
    <p>Dang tai...</p>
</div>

<hr>

<h2>Them Xe May Moi</h2>

<form id="formThemXeMay">
    <div>
        <label>Chi Nhanh:</label>
        <select name="maChiNhanh" id="maChiNhanhForm" required>
            <option value="">-- Chon Chi Nhanh --</option>
        </select>
    </div>
    <br>
    <div>
        <label>Mau Xe:</label>
        <select name="maMauXe" id="maMauXe" required>
            <option value="">-- Chon Mau Xe --</option>
        </select>
    </div>
    <br>
    <div>
        <label>Bien So:</label>
        <input type="text" name="bienSo" required>
    </div>
    <br>
    <div>
        <label>So Khung:</label>
        <input type="text" name="soKhung" required>
    </div>
    <br>
    <div>
        <label>So May:</label>
        <input type="text" name="soMay" required>
    </div>
    <br>
    <div>
        <label>Trang Thai:</label>
        <select name="trangThai" required>
            <option value="AVAILABLE">Co San</option>
            <option value="RENTED">Da Thue</option>
            <option value="MAINTENANCE">Bao Duong</option>
        </select>
    </div>
    <br>
    <button type="submit">Them Xe May</button>
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

// Load danh sach mau xe khi chon chi nhanh trong form
document.addEventListener('change', function(e) {
    if (e.target.id === 'maChiNhanhForm') {
        const maChiNhanh = e.target.value;
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
    }
});

// Load danh sach xe may
function loadXeMay(maChiNhanh = '') {
    let url = ctx + '/doitac/quanlyxemay?api=1';
    if (maChiNhanh) {
        url += '&maChiNhanh=' + maChiNhanh;
    }
    
    fetch(url)
        .then(res => res.text())
        .then(xml => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            let html = '<table border="1" cellpadding="5">';
            html += '<tr><th>Bien So</th><th>Mau Xe</th><th>So Khung</th><th>So May</th><th>Trang Thai</th></tr>';
            doc.querySelectorAll('xeMay').forEach(xm => {
                const hangXe = xm.querySelector('hangXe') ? xm.querySelector('hangXe').textContent : '';
                const dongXe = xm.querySelector('dongXe') ? xm.querySelector('dongXe').textContent : '';
                const tenMauXe = hangXe && dongXe ? hangXe + ' ' + dongXe : (hangXe || dongXe || 'N/A');
                html += '<tr>';
                html += '<td>' + xm.querySelector('bienSo').textContent + '</td>';
                html += '<td>' + tenMauXe + '</td>';
                html += '<td>' + xm.querySelector('soKhung').textContent + '</td>';
                html += '<td>' + xm.querySelector('soMay').textContent + '</td>';
                html += '<td>' + xm.querySelector('trangThai').textContent + '</td>';
                html += '</tr>';
            });
            html += '</table>';
            
            if (doc.querySelectorAll('xeMay').length === 0) {
                html = '<p>Khong co xe may nao.</p>';
            }
            
            document.getElementById('xeMayList').innerHTML = html;
        })
        .catch(e => {
            document.getElementById('xeMayList').innerHTML = '<p style="color: red;">Loi load danh sach: ' + e.message + '</p>';
        });
}

// Load khi trang load
loadChiNhanh();
loadXeMay();

// Loc khi chon chi nhanh
document.getElementById('filterChiNhanh').onchange = function() {
    loadXeMay(this.value);
};

// Submit form them xe may
document.getElementById('formThemXeMay').onsubmit = async function(e) {
    e.preventDefault();
    const btn = this.querySelector('button');
    btn.disabled = true;

    try {
        const res = await fetch(ctx + '/doitac/quanlyxemay', {
            method: 'POST',
            body: new URLSearchParams(new FormData(this))
        });

        const xml = new DOMParser().parseFromString(await res.text(), 'application/xml');
        const status = xml.querySelector('status').textContent;
        const message = xml.querySelector('message').textContent;

        alert(message);

        if (status === 'success') {
            this.reset();
            loadXeMay(document.getElementById('filterChiNhanh').value);
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
