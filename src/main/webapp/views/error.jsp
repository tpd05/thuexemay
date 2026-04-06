<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lỗi</title>
</head>
<body>
    <div style="border: 1px solid red; padding: 20px; margin: 20px;">
        <h2 style="color: red;">✗ Lỗi</h2>
        <p id="message">
            <% if (request.getAttribute("message") != null) { %>
                <%= request.getAttribute("message") %>
            <% } else { %>
                Đã xảy ra lỗi. Vui lòng thử lại!
            <% } %>
        </p>
        <p>
            <%
                String redirect = (String) request.getAttribute("redirect");
                if (redirect != null) {
            %>
                <a href="<%= redirect %>">Quay Lại</a>
            <%
                } else {
            %>
                <a href="/thuexemay/">Về Trang Chủ</a>
            <%
                }
            %>
        </p>
    </div>
</body>
</html>
