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
<title>Quan Ly Chi Nhanh</title>
</head>
<body>

<h1>Quan Ly Chi Nhanh</h1>

<p><a href="<%=ctxPath%>/doitac/dashboard">← Quay lai Dashboard</a></p>

<h2>Danh Sach Chi Nhanh</h2>

<div id="chiNhanhList">
    <p>Dang tai...</p>
</div>

<hr>

<h2>Them Chi Nhanh Moi</h2>

<form id="formThemChiNhanh">
    <div>
        <label>Ten Chi Nhanh:</label>
        <input type="text" name="tenChiNhanh" required>
    </div>
    <br>
    <div>
        <label>Dia Diem:</label>
        <input type="text" name="diaDiem" required>
    </div>
    <br>
    <button type="submit">Them Chi Nhanh</button>
</form>

<script>
const ctx = '<%=ctxPath%>';

// Load danh sach chi nhanh
function loadChiNhanh() {
    fetch(ctx + '/doitac/quanlychinhanh?api=1')
        .then(res => res.text())
        .then(xml => {
            console.log('XML Response:', xml);
            
            const parser = new DOMParser();
            const doc = parser.parseFromString(xml, 'application/xml');
            
            // Check for parse errors
            if (doc.documentElement.nodeName === 'parsererror') {
                throw new Error('XML Parse Error: ' + doc.documentElement.textContent);
            }
            
            let html = '<table border="1" cellpadding="5">';
            html += '<tr><th>Ma Chi Nhanh</th><th>Ten Chi Nhanh</th><th>Dia Diem</th><th>Thao Tac</th></tr>';
            
            const chiNhanhs = doc.querySelectorAll('chiNhanh');
            console.log('Found chiNhanhs:', chiNhanhs.length);
            
            if (chiNhanhs.length === 0) {
                html = '<p>Khong co chi nhanh nao.</p>';
            } else {
                chiNhanhs.forEach(cn => {
                    const ma = cn.querySelector('maChiNhanh').textContent;
                    const ten = cn.querySelector('tenChiNhanh').textContent;
                    const dia = cn.querySelector('diaDiem').textContent;
                    
                    html += '<tr>';
                    html += '<td>' + ma + '</td>';
                    html += '<td>' + ten + '</td>';
                    html += '<td>' + dia + '</td>';
                    html += '<td><button onclick="suaChiNhanh(' + ma + ')">Sua</button> <button onclick="xoaChiNhanh(' + ma + ')">Xoa</button></td>';
                    html += '</tr>';
                });
                html += '</table>';
            }
            
            document.getElementById('chiNhanhList').innerHTML = html;
        })
        .catch(e => {
            console.error('Error:', e);
            document.getElementById('chiNhanhList').innerHTML = '<p style="color: red;">Loi load danh sach: ' + e.message + '</p>';
        });
}

// Load khi trang load
loadChiNhanh();

// Sua chi nhanh
function suaChiNhanh(maChiNhanh) {
    alert('Chuc nang sua chi nhanh dang phat trien');
}

// Xoa chi nhanh
function xoaChiNhanh(maChiNhanh) {
    if (confirm('Ban chac chan muon xoa chi nhanh nay?')) {
        alert('Chuc nang xoa chi nhanh dang phat trien');
    }
}

// Submit form them chi nhanh
document.getElementById('formThemChiNhanh').onsubmit = async function(e) {
    e.preventDefault();
    const btn = this.querySelector('button');
    btn.disabled = true;

    try {
        const formData = new FormData(this);
        
        const res = await fetch(ctx + '/doitac/quanlychinhanh', {
            method: 'POST',
            body: new URLSearchParams(formData)
        });

        const responseText = await res.text();
        console.log('Response Status:', res.status);
        console.log('Response Text:', responseText);
        
        const parser = new DOMParser();
        const doc = parser.parseFromString(responseText, 'application/xml');
        
        // Check for parse errors
        if (doc.documentElement.nodeName === 'parsererror') {
            throw new Error('Invalid XML response');
        }
        
        const status = doc.querySelector('status').textContent;
        const message = doc.querySelector('message').textContent;

        alert(message);

        if (status === 'success') {
            this.reset();
            loadChiNhanh();
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Loi: ' + error.message);
    } finally {
        btn.disabled = false;
    }
};
</script>

</body>
</html>
