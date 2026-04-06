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
<title>Dashboard - Đối Tác</title>
</head>
<body>

<h1>Dashboard Đối Tác</h1>

<p>Xin chào <strong><%=username%></strong> | <a href="javascript:void(0);" onclick="confirmLogout()">Đăng Xuất</a></p>

<h2>Quan Ly</h2>

<ul>
    <li><a href="<%=ctxPath%>/doitac/quanlygoithue">Quan Ly Goi Thue</a></li>
    <li><a href="<%=ctxPath%>/doitac/quanlymauxe">Quan Ly Mau Xe</a></li>
    <li><a href="<%=ctxPath%>/doitac/quanlyxemay">Quan Ly Xe May</a></li>
    <li><a href="<%=ctxPath%>/doitac/quanlychinhanh">Quan Ly Chi Nhanh</a></li>
    <li><a href="<%=ctxPath%>/doitac/donhang">Don Hang</a></li>
</ul>

<script>
const ctx = '<%=ctxPath%>';

function confirmLogout() {
    if (confirm('Bạn có muốn đăng xuất!')) {
        window.location.href = ctx + '/logout';
    }
}
</script>

</body>
</html>
