<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background: #f0f0f0; }
        .box { background: #fff; padding: 30px; border: 1px solid #ccc; border-radius: 6px; width: 320px; }
        h2 { margin: 0 0 20px; text-align: center; }
        label { display: block; margin-bottom: 4px; font-size: 14px; }
        input { width: 100%; padding: 8px; margin-bottom: 14px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 9px; background: #1976d2; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 15px; }
        button:hover { background: #1565c0; }
        #msg { margin-top: 12px; font-size: 13px; color: red; text-align: center; }
    </style>
</head>
<body>
<div class="box">
    <h2>Đăng nhập</h2>
    <label>Tài khoản</label>
    <input type="text" id="username" placeholder="Nhập username">
    <label>Mật khẩu</label>
    <input type="password" id="password" placeholder="Nhập mật khẩu">
    <button onclick="dangNhap()">Đăng nhập</button>
    <div id="msg"></div>
</div>
<script>
async function dangNhap() {
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value;
    const msg = document.getElementById('msg');
    msg.textContent = '';

    if (!username || !password) { msg.textContent = 'Vui lòng nhập đủ thông tin'; return; }

    const params = new URLSearchParams({ username, password });
    try {
        const res = await fetch('/api/xacthuc/dangnhap', { method: 'POST', credentials: 'include', body: params });
        const text = await res.text();
        const xml = new DOMParser().parseFromString(text, 'application/xml');
        const status = xml.getElementsByTagName('status')[0]?.textContent;
        const message = xml.getElementsByTagName('message')[0]?.textContent;

        if (status === 'success') {
            window.location.href = 'dashboard.jsp';
        } else {
            msg.textContent = message || 'Sai tài khoản hoặc mật khẩu';
        }
    } catch (e) {
        msg.textContent = 'Lỗi kết nối';
    }
}

document.addEventListener('keydown', e => { if (e.key === 'Enter') dangNhap(); });
</script>
</body>
</html>
