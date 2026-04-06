<%@ page contentType="text/html; charset=UTF-8" %>
<%
String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập</title>
</head>
<body>
    <h1>Đăng Nhập</h1>
    <form id="loginForm">
        <div>
            <label>Username:</label>
            <input type="text" name="username" required>
        </div>
        <div>
            <label>Mật khẩu:</label>
            <input type="password" name="password" required>
        </div>
        <button type="submit">Đăng Nhập</button>
    </form>

    <p>
        <a href="<%=ctxPath%>/dangky" style="margin-right: 10px;">Đăng ký</a> |
        <a href="<%=ctxPath%>/views/auth/forgot-password.jsp">Quên mật khẩu</a>
    </p>

    <script>
        const ctx = '<%=ctxPath%>';
        
        document.getElementById('loginForm').onsubmit = async function(e) {
            e.preventDefault();
            const btn = e.target.querySelector('button[type="submit"]');
            btn.disabled = true;

            try {
                const res = await fetch(ctx + '/dangnhap', {
                    method: 'POST',
                    body: new URLSearchParams(new FormData(e.target))
                });

                const xml = new DOMParser().parseFromString(await res.text(), 'application/xml');
                const status = xml.querySelector('status').textContent;
                const message = xml.querySelector('message').textContent;

                if (status === 'success') {
                    const role = xml.querySelector('role').textContent;
                    alert(message);
                    
                    if (role === 'KHACH_HANG') {
                        location.href = ctx + '/khachhang/dashboard';
                    } else if (role === 'DOI_TAC') {
                        location.href = ctx + '/doitac/dashboard';
                    } else if (role === 'ADMIN') {
                        location.href = ctx + '/admin/dashboard';
                    } else if (role === 'NHAN_VIEN') {
                        location.href = ctx + '/nhanvien/dashboard';
                    } else {
                        location.href = ctx + '/';
                    }
                } else {
                    alert(message);
                    btn.disabled = false;
                }
            } catch (error) {
                alert('Lỗi hệ thống!');
                btn.disabled = false;
            }
        };
    </script>
</body>
</html>
