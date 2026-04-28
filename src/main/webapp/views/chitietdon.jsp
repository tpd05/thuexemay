<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiet Don Hang</title>
</head>
<body>
    <h1>Chi Tiet Don Hang</h1>

    <button><a href="/thuexemay/khachhang/donthue">Quay Lai Lich Su</a></button>

    <h2>Thong Tin Don Hang</h2>
    <div>
        <p><strong>Ma Don:</strong> <span id="maDon">-</span></p>
        <p><strong>Trang Thai:</strong> <span id="trangThai">-</span></p>
        <p><strong>Dia Chi Nhan:</strong> <span id="diaChiNhan">-</span></p>
        <p><strong>Ngay Tao:</strong> <span id="ngayTao">-</span></p>
    </div>

    <h2>Chi Tiet Xe Thue</h2>
    <table border="1">
        <tr>
            <th>Ma Xe</th>
            <th>Ma Goi</th>
            <th>Thoi Gian Bat Dau</th>
            <th>Thoi Gian Ket Thuc</th>
            <th>Don Gia</th>
            <th>Thanh Tien</th>
        </tr>
        <tr>
            <td colspan="6">
                <% if (request.getAttribute("chiTietDonThue") != null) { %>
                    Du lieu se duoc load tu servlet
                <% } else { %>
                    Khong co chi tiet
                <% } %>
            </td>
        </tr>
    </table>

    <h2>Tom Tat Thanh Toan</h2>
    <div>
        <p><strong>So Luong Xe:</strong> <span id="soXe">-</span></p>
        <p><strong>Tong Tien:</strong> <span id="tongTien">-</span> VND</p>
    </div>
</body>
</html>
