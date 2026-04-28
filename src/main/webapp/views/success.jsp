<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thành Công</title>
</head>
<body>
    <div style="border: 1px solid green; padding: 20px; margin: 20px;">
        <h2 style="color: green;">✓ Thành Công</h2>
        <p id="message">
            <% if (request.getAttribute("message") != null) { %>
                <%= request.getAttribute("message") %>
            <% } else { %>
                Yêu cầu đã được xử lý thành công!
            <% } %>
        </p>
        <p><a href="<%= request.getAttribute("redirect") != null ? request.getAttribute("redirect") : "/" %>">Quay Lại</a></p>
    </div>
</body>
</html>
