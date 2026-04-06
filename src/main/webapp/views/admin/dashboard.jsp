<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bang Dieu Khien Admin</title>
</head>
<body>
    <h1>Bang Dieu Khien Admin</h1>

    <button><a href="/thuexemay/admin/quanlynguoidung">Quan Ly Nguoi Dung</a></button>
    <button><a href="/thuexemay/admin/quanlydoitac">Quan Ly Doi Tac</a></button>
    <button onclick="confirmLogout()">Dang Xuat</button>

    <h2>Thong Ke</h2>
    <div>
        <h3>Tong So Khach Hang: <span id="tongKhachHang">0</span></h3>
    </div>
    <div>
        <h3>Tong So Doi Tac: <span id="tongDoiTac">0</span></h3>
    </div>
    <div>
        <h3>Tong So Don Hang: <span id="tongDonHang">0</span></h3>
    </div>
    <div>
        <h3>Doanh Thu Hom Nay: <span id="doanhThuHomNay">0</span> VND</h3>
    </div>

    <h2>Hoat Dong Gan Day</h2>
    <div>
        <p>Danh sach hoat dong se duoc load tu servlet</p>
    </div>

    <script>
    function confirmLogout() {
        if (confirm('Bạn có muốn đăng xuất!')) {
            window.location.href = '/thuexemay/logout';
        }
    }
    </script>
</body>
</html>
