CREATE DATABASE IF NOT EXISTS thuexemay
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE thuexemay;

-- 1. TaiKhoan
CREATE TABLE TaiKhoan (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE,
    password VARCHAR(255),
    role VARCHAR(50)
);

-- 2. NguoiDung
CREATE TABLE NguoiDung (
    userID INT PRIMARY KEY,
    hoTen VARCHAR(100),
    soDienThoai VARCHAR(15) UNIQUE,
    email VARCHAR(100),
    trangThaieKYC BOOLEAN DEFAULT FALSE,
    soCCCD VARCHAR(20) UNIQUE,
    FOREIGN KEY (userID) REFERENCES TaiKhoan(userID)
        ON DELETE CASCADE
);

-- 3. KhachHang
CREATE TABLE KhachHang (
    userID INT PRIMARY KEY UNIQUE,
    FOREIGN KEY (userID) REFERENCES NguoiDung(userID)
        ON DELETE CASCADE
);

-- 4. DoiTac
CREATE TABLE DoiTac (
    maDoiTac INT PRIMARY KEY AUTO_INCREMENT,
    userID INT  UNIQUE,
    FOREIGN KEY (userID) REFERENCES NguoiDung(userID)
        ON DELETE CASCADE
);

-- 5. NhanVien
CREATE TABLE NhanVien (
    maNhanVien INT PRIMARY KEY AUTO_INCREMENT,
    userID INT UNIQUE,
    FOREIGN KEY (userID) REFERENCES NguoiDung(userID)
        ON DELETE CASCADE
);

-- 6. ChiNhanh
CREATE TABLE ChiNhanh (
    maChiNhanh INT PRIMARY KEY AUTO_INCREMENT,
    maDoiTac INT,
    tenChiNhanh VARCHAR(100),
    diaDiem VARCHAR(255),
    FOREIGN KEY (maDoiTac) REFERENCES DoiTac(maDoiTac)
        ON DELETE CASCADE
);

-- 7. MauXe
CREATE TABLE MauXe (
    maMauXe INT PRIMARY KEY AUTO_INCREMENT,
    maDoiTac INT,
    maChiNhanh INT,
    hangXe VARCHAR(100),
    dongXe VARCHAR(100),
    doiXe INT,
    dungTich FLOAT,
    urlHinhAnh TEXT,
    FOREIGN KEY (maDoiTac) REFERENCES DoiTac(maDoiTac),
    FOREIGN KEY (maChiNhanh) REFERENCES ChiNhanh(maChiNhanh)
);

-- 8. XeMay
CREATE TABLE XeMay (
    maXe INT PRIMARY KEY AUTO_INCREMENT,
    maDoiTac INT,
    maMauXe INT,
    maChiNhanh INT,
    trangThai VARCHAR(50),
    bienSo VARCHAR(20) UNIQUE,
    soKhung VARCHAR(50) UNIQUE,
    soMay VARCHAR(50) UNIQUE,
    FOREIGN KEY (maDoiTac) REFERENCES DoiTac(maDoiTac),
    FOREIGN KEY (maMauXe) REFERENCES MauXe(maMauXe),
    FOREIGN KEY (maChiNhanh) REFERENCES ChiNhanh(maChiNhanh)
);

-- 9. GoiThue
CREATE TABLE GoiThue (
    maGoiThue INT PRIMARY KEY AUTO_INCREMENT,
    maMauXe INT,
    maDoiTac INT,
    maChiNhanh INT,
    tenGoiThue VARCHAR(100),
    phuKien TEXT,
    giaNgay FLOAT,
    giaGio FLOAT,
    phuThu FLOAT,
    FOREIGN KEY (maMauXe) REFERENCES MauXe(maMauXe),
    FOREIGN KEY (maDoiTac) REFERENCES DoiTac(maDoiTac),
    FOREIGN KEY (maChiNhanh) REFERENCES ChiNhanh(maChiNhanh)
);

-- 10. GioHang
CREATE TABLE GioHang (
    maGioHang INT PRIMARY KEY AUTO_INCREMENT,
   userID INT,
    diaChiNhanXe VARCHAR(255),
    FOREIGN KEY (userID) REFERENCES TaiKhoan(userID)
        ON DELETE CASCADE
);

-- 11. MucHang
CREATE TABLE MucHang (
    maGioHang INT,
    maGoiThue INT,
    soLuong INT,
    thoiGianBatDau DATETIME,
    thoiGianKetThuc DATETIME,
    PRIMARY KEY (maGioHang, maGoiThue),
    FOREIGN KEY (maGioHang) REFERENCES GioHang(maGioHang)
        ON DELETE CASCADE,
    FOREIGN KEY (maGoiThue) REFERENCES GoiThue(maGoiThue)
);

-- 12. DonThue
CREATE TABLE DonThue (
    maDonThue INT PRIMARY KEY AUTO_INCREMENT,
    userID INT,
    diaChiNhanXe VARCHAR(255),
    trangThai VARCHAR(50),
    FOREIGN KEY (userID) REFERENCES TaiKhoan(userID)
);

-- 13. ChiTietDonThue
CREATE TABLE ChiTietDonThue (
    maChiTiet INT PRIMARY KEY AUTO_INCREMENT,
    maDonThue INT,
    maXe INT,
    maGoiThue INT,
    thoiGianBatDau DATETIME,
    thoiGianKetThuc DATETIME,
    thoiGianTra DATETIME,
    donGia INT,
    FOREIGN KEY (maDonThue) REFERENCES DonThue(maDonThue)
        ON DELETE CASCADE,
    FOREIGN KEY (maXe) REFERENCES XeMay(maXe),
    FOREIGN KEY (maGoiThue) REFERENCES GoiThue(maGoiThue)
);

-- 14. ThanhToan
CREATE TABLE ThanhToan (
    maThanhToan INT PRIMARY KEY AUTO_INCREMENT,
    maDonThue INT,
    soTien FLOAT,
    phuongThuc VARCHAR(50),
    thoiGianTao DATETIME,
    trangThai VARCHAR(50),
    FOREIGN KEY (maDonThue) REFERENCES DonThue(maDonThue)
        ON DELETE CASCADE
);

-- 15. HoanTien
CREATE TABLE HoanTien (
    maHoanTien INT PRIMARY KEY AUTO_INCREMENT,
    maDonThue INT,
    soTien INT,
    lyDo TEXT,
    trangThai VARCHAR(50),
    FOREIGN KEY (maDonThue) REFERENCES DonThue(maDonThue)
        ON DELETE CASCADE
);

-- 16. DanhGiaTraiNghiemThue
CREATE TABLE DanhGiaTraiNghiemThue (
    maDanhGia INT PRIMARY KEY AUTO_INCREMENT,
    maDonThue INT,
    userID INT,
    mucDo INT,
    tieuDe VARCHAR(255),
    noiDung TEXT,
    trangThaiDuyet VARCHAR(50),
    FOREIGN KEY (maDonThue) REFERENCES DonThue(maDonThue),
    FOREIGN KEY (userID) REFERENCES TaiKhoan(userID)
);

-- 17. DanhSachMongMuon
CREATE TABLE DanhSachMongMuon (
    maDS INT PRIMARY KEY AUTO_INCREMENT,
    userID INT,
    FOREIGN KEY (userID) REFERENCES TaiKhoan(userID)
        ON DELETE CASCADE
);

-- 18. WishListItems
CREATE TABLE MucDanhSachMongMuon (
    maWishList INT,
    maGoiThue INT,
    PRIMARY KEY (maWishList, maGoiThue),
    FOREIGN KEY (maWishList) REFERENCES DanhSachMongMuon(maDS)
        ON DELETE CASCADE,
    FOREIGN KEY (maGoiThue) REFERENCES GoiThue(maGoiThue)
);

