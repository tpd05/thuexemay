# MOTOBOOK - Ứng Dụng Cho Thuê Xe Máy

Ứng dụng web cho phép khách hàng thuê xe máy, đối tác quản lý gói thuê, và admin quản lý hệ thống.

## 🛠️ Yêu Cầu Hệ Thống

- **Java**: JDK 17 trở lên
- **Maven**: 3.8.0 trở lên
- **MySQL**: 5.7 hoặc 8.0
- **Tomcat**: 9.x (để deploy)

## 📋 Hướng Dẫn Cài Đặt

### 1. Clone và Setup Database

```bash
# Clone project
git clone <repository-url>
cd thuexemay

# Tạo database
Vào thuexemay\src\main\java\model\db.sql copy db.sql vào MySQL để tạo database và bảng cần thiết.
```

### 2. Cấu Hình Database Connection

Chỉnh sửa file `src/main/resources/db.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<database>
    <driver>com.mysql.cj.jdbc.Driver</driver>
    <url>jdbc:mysql://localhost:3307/thuexemay</url>
    <user>root</user>
    <password></password>
</database>
```

### 3. Build Project

build lại project bằng cmd hoặc bằng eclipse maven->update project

Kết quả file WAR sẽ nằm tại: `target/thuexemay.war`

## 🚀 Chạy Project

## 📁 Cấu Trúc Project

```
thuexemay/
├── src/main/
│   ├── java/           # Source code Java
│   │   ├── dao/        # Data Access Objects
│   │   ├── model/      # JPA/Model classes
│   │   ├── servlet/    # Servlet controllers
│   │   ├── service/    # Business logic
│   │   ├── filter/     # Filters
│   │   ├── util/       # Utilities
│   │   └── cache/      # Caching
│   ├── resources/      # Config files (db.xml)
│   └── webapp/         # Web resources
│       ├── index.jsp   # Home page
│       ├── views/      # JSP pages
│       ├── css/        # Stylesheets
│       ├── js/         # JavaScript
│       └── WEB-INF/    # web.xml, lib/
├── pom.xml             # Maven configuration
└── target/             # Build output
```

## 📦 Dependencies Chính

- MySQL Connector: 8.3.0
- jBCrypt: 0.4 (mã hoá mật khẩu)
- OkHttp: 4.12.0 (Momo API)
- Gson: 2.10.1 (JSON parsing)
- JSTL: 1.2 (JSP tags)

## ⚙️ Command Maven Thường Dùng

```bash
# Clean và build
mvn clean package

# Build mà không run test
mvn clean package -DskipTests

# Compile
mvn compile

# Run test
mvn test

# View dependencies
mvn dependency:tree
```

## 🐛 Troubleshooting

**Lỗi: Connection refused (MySQL)**
- Kiểm tra MySQL service đang chạy
- Kiểm tra cấu hình connection trong `db.xml`

**Lỗi: ClassNotFoundException**
- Chạy `mvn clean package` để tải dependencies
- Kiểm tra file WAR có chứa `lib/` folder không

**Lỗi: JSP compile error**
- Kiểm tra Java version: `java -version`
- Đảm bảo maven.compiler.source và target = 17

## 📝 Ghi Chú

- Dự án sử dụng JSP + Servlet (Traditional)
- Database: MySQL
- Authentication: Session-based
- Payment: Momo API integration
- UI: Tailwind CSS + Iconify

## 👥 Cấu Trúc Role

- **KHACH_HANG**: Khách hàng thuê xe
- **DOI_TAC**: Đối tác cung cấp xe
- **ADMIN**: Quản trị hệ thống(Chưa phát triển)

---

**Chúc bạn phát triển vui vẻ! 🎉**
