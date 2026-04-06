<%@ page contentType="text/html;charset=UTF-8"%>
<%
String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>403 - Forbidden</title>
</head>
<body>

<h1>403 - Forbidden</h1>
<p>Bạn không có quyền truy cập tài nguyên này.</p>

<p>
	<a href="<%=ctxPath%>/dangnhap">Quay về đăng nhập</a> |
	<a href="<%=ctxPath%>/">Trang chủ</a>
</p>

</body>
</html>
