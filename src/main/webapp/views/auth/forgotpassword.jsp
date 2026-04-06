<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quen Mat Khau</title>
</head>
<body>
    <h1>Quen Mat Khau</h1>
    <form method="POST" action="/thuexemay/auth/forgotpassword">
        <div>
            <label>Email:</label>
            <input type="email" name="email" required>
        </div>
        <div>
            <label>Mat khau moi:</label>
            <input type="password" name="newPassword" required>
            <small>It nhat 8 ky tu, gom chu hoa, chu thuong, so va ky tu dac biet</small>
        </div>
        <button type="submit">Cap Nhat Mat Khau</button>
    </form>

    <p><a href="/thuexemay/dangnhap">Ve trang dang nhap</a></p>
</body>
</html>
