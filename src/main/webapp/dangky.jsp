<%@ page contentType="text/html;charset=UTF-8" %>
<%  String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký</title>
</head>
<body>
<h2>Đăng Ký Tài Khoản</h2>
<form id="f">
    Loại tài khoản:
    <select name="role">
        <option value="KHACH_HANG">Khách hàng</option>
        <option value="DOI_TAC">Đối tác</option>
    </select><br><br>
    Username: <input name="username" required placeholder="4-20 ký tự, không đặc biệt"><br><br>
    Mật khẩu: <input name="password" type="password" required placeholder=">=8 ký tự, hoa+thường+số+đặc biệt"><br><br>
    Họ tên: <input name="hoTen" required><br><br>
    Số điện thoại: <input name="soDienThoai" required placeholder="0xxxxxxxxx"><br><br>
    Email: <input name="email" type="email"><br><br>
    Số CCCD: <input name="soCCCD" required placeholder="12 chữ số"><br><br>
    <button type="submit">Đăng Ký</button>
</form>
<p id="msg" style="color:red"></p>
<p><a href="<%= ctxPath %>/api/xacthuc/dangnhap">Đã có tài khoản? Đăng nhập</a></p>

<script>
const ctx = '<%= ctxPath %>';
document.getElementById('f').onsubmit = async function(e) {
    e.preventDefault();
    const btn = e.target.querySelector('button');
    btn.disabled = true;
    const res = await fetch(ctx + '/api/xacthuc/dangky', {
        method: 'POST',
        body: new URLSearchParams(new FormData(e.target))
    });
    const xml = new DOMParser().parseFromString(await res.text(), 'application/xml');
    const status = xml.querySelector('status').textContent;
    const msg    = xml.querySelector('message').textContent;
    const el = document.getElementById('msg');
    el.textContent = msg;
    el.style.color = status === 'success' ? 'green' : 'red';
    if (status === 'success') {
        setTimeout(() => location.href = ctx + '/api/xacthuc/dangnhap', 1500);
    } else {
        btn.disabled = false;
    }
};
</script>
</body>
</html>
