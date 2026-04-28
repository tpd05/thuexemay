<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quan Ly Doi Tac</title>
</head>
<body>
    <h1>Quan Ly Doi Tac</h1>

    <button><a href="/thuexemay/admin/quanlynguoidung">Quan Ly Nguoi Dung</a></button>
    <button><a href="/thuexemay/admin/dashboard">Bang Dieu Khien</a></button>
    <button><a href="/thuexemay/auth/logout">Dang Xuat</a></button>

    <h2>Danh Sach Doi Tac</h2>
    <table border="1">
        <tr>
            <th>ID Doi Tac</th>
            <th>Username</th>
            <th>Ho Ten</th>
            <th>Email</th>
            <th>So Dien Thoai</th>
            <th>Hanh Dong</th>
        </tr>
        <tr>
            <td colspan="6">
                <% if (request.getAttribute("doiTacDanhSach") != null) { %>
                    Du lieu se duoc load tu servlet
                <% } else { %>
                    Khong co doi tac nao
                <% } %>
            </td>
        </tr>
    </table>

    <h3>Tim Kiem Doi Tac</h3>
    <form method="GET" action="/thuexemay/admin/quanlydoitac">
        <div>
            <label>Username:</label>
            <input type="text" name="username">
        </div>
        <div>
            <label>Email:</label>
            <input type="email" name="email">
        </div>
        <button type="submit">Tim Kiem</button>
    </form>

    <h3>Chi Tiet Doi Tac</h3>
    <form method="GET" action="/thuexemay/admin/chitietdoitac">
        <div>
            <label>ID Doi Tac:</label>
            <input type="number" name="userID" required>
        </div>
        <button type="submit">Xem Chi Tiet</button>
    </form>
</body>
</html>
