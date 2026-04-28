<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quan Ly Nguoi Dung</title>
</head>
<body>
    <h1>Quan Ly Nguoi Dung</h1>

    <button><a href="/thuexemay/admin/quanlydoitac">Quan Ly Doi Tac</a></button>
    <button><a href="/thuexemay/admin/dashboard">Bang Dieu Khien</a></button>
    <button><a href="/thuexemay/auth/logout">Dang Xuat</a></button>

    <h2>Danh Sach Nguoi Dung</h2>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Ho Ten</th>
            <th>Email</th>
            <th>So Dien Thoai</th>
            <th>Role</th>
            <th>Hanh Dong</th>
        </tr>
        <tr>
            <td colspan="7">
                <% if (request.getAttribute("nguoiDungDanhSach") != null) { %>
                    Du lieu se duoc load tu servlet
                <% } else { %>
                    Khong co nguoi dung nao
                <% } %>
            </td>
        </tr>
    </table>

    <h3>Tim Kiem Nguoi Dung</h3>
    <form method="GET" action="/thuexemay/admin/quanlynguoidung">
        <div>
            <label>Username:</label>
            <input type="text" name="username">
        </div>
        <div>
            <label>Email:</label>
            <input type="email" name="email">
        </div>
        <div>
            <label>Role:</label>
            <select name="role">
                <option value="">Tat Ca</option>
                <option value="KHACH_HANG">Khach Hang</option>
                <option value="DOI_TAC">Doi Tac</option>
                <option value="NHAN_VIEN">Nhan Vien</option>
            </select>
        </div>
        <button type="submit">Tim Kiem</button>
    </form>

    <h3>Chi Tiet Nguoi Dung</h3>
    <form method="GET" action="/thuexemay/admin/chitietnguoidung">
        <div>
            <label>ID Nguoi Dung:</label>
            <input type="number" name="userID" required>
        </div>
        <button type="submit">Xem Chi Tiet</button>
    </form>
</body>
</html>
