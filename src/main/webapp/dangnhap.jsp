<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctxPath = request.getContextPath();
    // Nếu đã đăng nhập thì chuyển hướng
    String role = (String) session.getAttribute("role");
    if ("DOI_TAC".equals(role)) { response.sendRedirect(ctxPath + "/doitac.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập</title>
</head>
<body>
<h2>Đăng Nhập</h2>
<form id="f">
    Username: <input name="username" required><br><br>
    Mật khẩu: <input name="password" type="password" required><br><br>
    <button type="submit">Đăng Nhập</button>
</form>
<p id="msg" style="color:red"></p>
<p><a href="<%= ctxPath %>/dangky">Chưa có tài khoản? Đăng ký</a></p>

<script>
const ctx = '<%= ctxPath %>';
document.getElementById('f').onsubmit = async function(e) {
    e.preventDefault();
    const res = await fetch(ctx + '/dangnhap', {
        method: 'POST',
        body: new URLSearchParams(new FormData(e.target))
    });
    const xml = new DOMParser().parseFromString(await res.text(), 'application/xml');
    const status = xml.querySelector('status').textContent;
    const msg    = xml.querySelector('message').textContent;
    document.getElementById('msg').textContent = msg;
    if (status === 'success') {
        const role = xml.querySelector('role')?.textContent;
        location.href = role === 'DOI_TAC' ? ctx + '/doitac.jsp' : ctx + '/index.jsp';
    }
};
</script>
</body>
</html>
