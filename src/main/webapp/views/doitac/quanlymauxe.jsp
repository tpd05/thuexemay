<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChiNhanhDAO,dao.MauXeDAO,model.ChiNhanh,model.MauXe,java.util.List,java.net.URLEncoder" %>
<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    javax.servlet.http.HttpSession sess = request.getSession(false);
    if (sess == null || !"DOI_TAC".equals(sess.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/dangnhap"); return;
    }
    int maDoiTac = (Integer) sess.getAttribute("maDoiTac");
    String ctx   = request.getContextPath();

    String msg           = request.getParameter("msg");
    String msgType       = request.getParameter("msgType");
    String maChiNhanhStr = request.getParameter("maChiNhanh");
    int maChiNhanh = 0;
    if (maChiNhanhStr != null && !maChiNhanhStr.trim().isEmpty()) {
        try { maChiNhanh = Integer.parseInt(maChiNhanhStr.trim()); } catch (NumberFormatException ignore) {}
    }
    List<ChiNhanh> danhSachCN = new ChiNhanhDAO().layToanBoChiNhanh(maDoiTac);
    List<MauXe>    danhSachMX = (maChiNhanh > 0) ? new MauXeDAO().layDanhSachMauXeTheoChiNhanh(maChiNhanh, maDoiTac) : null;
    String tenChiNhanh = "";
    for (ChiNhanh cn : danhSachCN) { if (cn.getMaChiNhanh() == maChiNhanh) { tenChiNhanh = cn.getTenChiNhanh(); break; } }
    int currentStep = (maChiNhanh > 0) ? 2 : 1;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Mẫu Xe - Đối Tác</title>
    <link href="${pageContext.request.contextPath}/dist/tailwind.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/globals.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/components.css" rel="stylesheet">
    <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
    <style>
        /* Page-specific styles */
        .form-card {
            transition: all 0.3s ease;
            background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: var(--spacing-2xl);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        }
        
        .form-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .branch-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 0;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
        }

        .branch-card {
            position: relative;
            padding: var(--spacing-lg);
            background: #f9fafb;
            border-right: 1px solid #e5e7eb;
            border-bottom: 1px solid #e5e7eb;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .branch-card:hover {
            background: #ffffff;
            box-shadow: inset 0 0 0 2px #10b981;
        }

        .branch-card input[type="radio"] {
            position: absolute;
            top: var(--spacing-md);
            right: var(--spacing-md);
            accent-color: #10b981;
            cursor: pointer;
        }

        .branch-name {
            font-weight: 700;
            font-size: 14px;
            margin-bottom: var(--spacing-sm);
            padding-right: 28px;
            color: var(--color-text-primary);
        }

        .branch-address {
            font-size: 12px;
            color: #6b7280;
        }

        .table-row:hover {
            background: rgba(16, 185, 129, 0.02);
        }

        .alert-message {
            padding: var(--spacing-md) var(--spacing-lg);
            margin-bottom: var(--spacing-lg);
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
        }

        .alert-message.alert-error {
            border-left: 4px solid #dc2626;
            background: #fef2f2;
            color: #991b1b;
        }

        .alert-message.alert-success {
            border-left: 4px solid #10b981;
            background: #ecfdf5;
            color: #047857;
        }

        .submit-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: var(--spacing-lg);
        }
    </style>
</head>
<body class="bg-color-bg-primary text-color-text-primary font-body">
    <div class="page-wrapper">
        <header class="page-header">
            <jsp:include page="/components/navbar.jsp" />
        </header>

        <main class="page-main">
            <section class="app-container">
                <div style="display: flex; align-items: center; justify-content: space-between; margin-top: var(--spacing-3xl); margin-bottom: var(--spacing-3xl);">
                    <h1 style="font-size: var(--text-3xl); font-weight: 700; margin: 0;">Quản Lý Mẫu Xe</h1>
                </div>

                <% if (msg != null && !msg.isEmpty()) { %>
                    <div class="alert-message alert-<%= "error".equals(msgType) ? "error" : "success" %>">
                        <%= esc(msg) %>
                    </div>
                <% } %>

                <% if (currentStep == 1) { %>
                    <!-- Step 1: Choose Branch -->
                    <div class="form-card" style="margin-bottom: var(--spacing-3xl);">
                        <div style="display: flex; align-items: center; gap: var(--spacing-md); font-size: var(--text-lg); font-weight: 700; margin-bottom: var(--spacing-lg); color: var(--color-text-primary); padding-bottom: var(--spacing-md); border-bottom: 2px solid #e5e7eb;">
                            <iconify-icon icon="mdi:store" width="24" height="24" style="color: #10b981;"></iconify-icon>
                            <span>Chọn Chi Nhánh</span>
                        </div>

                        <% if (danhSachCN.isEmpty()) { %>
                            <div style="text-align: center; padding: var(--spacing-3xl); color: #6b7280; font-size: 14px;">
                                <iconify-icon icon="mdi:inbox-outline" width="48" height="48" style="display: block; margin: 0 auto var(--spacing-md); opacity: 0.4;"></iconify-icon>
                                Chưa có chi nhánh nào. <a href="<%= ctx %>/doitac/quanlychinhanh" style="color: #10b981; text-decoration: none; font-weight: 600;">Thêm chi nhánh trước</a>.
                            </div>
                        <% } else { %>
                            <form method="get" action="<%= ctx %>/doitac/quanlymauxe">
                                <div class="branch-grid" style="margin-bottom: var(--spacing-lg);">
                                    <% for (ChiNhanh cn : danhSachCN) { %>
                                        <label class="branch-card">
                                            <input type="radio" name="maChiNhanh" value="<%= cn.getMaChiNhanh() %>" required />
                                            <div class="branch-name"><%= esc(cn.getTenChiNhanh()) %></div>
                                            <div class="branch-address"><%= esc(cn.getDiaDiem()) %></div>
                                        </label>
                                    <% } %>
                                </div>
                                <button type="submit" style="background: #10b981; color: white; padding: var(--spacing-sm) var(--spacing-md); border: none; border-radius: 6px; font-family: inherit; font-size: 12px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; text-decoration: none; transition: all 0.15s ease;">
                                    <iconify-icon icon="mdi:arrow-right" width="14" height="14"></iconify-icon>
                                    Xem Mẫu Xe
                                </button>
                            </form>
                        <% } %>
                    </div>

                <% } else { %>
                    <!-- Step 2: Manage Models -->
                    <div style="display: grid; grid-template-columns: 360px 1fr; gap: var(--spacing-lg); margin-bottom: var(--spacing-3xl);">
                        <!-- Left Panel: Add New Model -->
                        <div class="form-card">
                            <div style="display: flex; align-items: center; gap: var(--spacing-md); font-size: var(--text-lg); font-weight: 700; margin-bottom: var(--spacing-lg); color: var(--color-text-primary); padding-bottom: var(--spacing-md); border-bottom: 2px solid #e5e7eb;">
                                <iconify-icon icon="mdi:plus-circle" width="24" height="24" style="color: #10b981;"></iconify-icon>
                                <span>Thêm Mẫu Xe</span>
                            </div>

                            <form method="post" action="<%= ctx %>/doitac/themMauXe" enctype="multipart/form-data">
                                <input type="hidden" name="maChiNhanh" value="<%= maChiNhanh %>" />
                                
                                <div style="margin-bottom: var(--spacing-lg);">
                                    <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary); letter-spacing: 0.5px;">Hãng Xe *</label>
                                    <input type="text" name="hangXe" placeholder="Honda, Yamaha..." maxlength="100" required style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;" />
                                </div>

                                <div style="margin-bottom: var(--spacing-lg);">
                                    <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary); letter-spacing: 0.5px;">Dòng Xe *</label>
                                    <input type="text" name="dongXe" placeholder="Wave, Exciter..." maxlength="100" required style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;" />
                                </div>

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md); margin-bottom: var(--spacing-lg);">
                                    <div>
                                        <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary); letter-spacing: 0.5px;">Đời Xe *</label>
                                        <input type="number" name="doiXe" placeholder="2022" min="1900" max="2100" required style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;" />
                                    </div>
                                    <div>
                                        <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary); letter-spacing: 0.5px;">Dung Tích (cc) *</label>
                                        <input type="number" name="dungTich" placeholder="125" step="0.1" min="0.1" required style="width: 100%; padding: var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease;" />
                                    </div>
                                </div>

                                <div style="margin-bottom: var(--spacing-lg);">
                                    <label style="display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-bottom: var(--spacing-sm); color: var(--color-text-primary); letter-spacing: 0.5px;">Hình Ảnh (Tùy Chọn)</label>
                                    <input type="file" id="hinhAnhInput" name="hinhAnh" accept="image/*" style="width: 100%; padding: var(--spacing-md); border: 2px dashed #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 13px; background: #f9fafb; color: var(--color-text-primary); outline: none; transition: all 0.15s ease; cursor: pointer;" />
                                    <div id="filePreviewContainer" style="margin-top: var(--spacing-md); display: none;">
                                        <div style="font-size: 12px; color: #6b7280; margin-bottom: var(--spacing-sm);">
                                            📁 Tệp đã chọn: <span id="fileNameDisplay" style="font-weight: 600; color: var(--color-text-primary);"></span>
                                            <span id="clearFileBtn" style="margin-left: var(--spacing-md); color: #dc2626; cursor: pointer; font-weight: 600;">[Xóa]</span>
                                        </div>
                                        <div style="width: 100%; max-width: 250px; height: 150px; background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 6px; display: flex; align-items: center; justify-content: center; overflow: hidden;">
                                            <img id="imagePreview" style="max-width: 100%; max-height: 100%; object-fit: contain;" />
                                        </div>
                                    </div>
                                </div>

                                <div style="display: flex; flex-direction: column; gap: var(--spacing-md);">
                                    <button type="submit" style="background: #10b981; color: white; padding: var(--spacing-sm) var(--spacing-md); border: none; border-radius: 6px; font-family: inherit; font-size: 12px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; gap: 6px; text-decoration: none; transition: all 0.15s ease;">
                                        <iconify-icon icon="mdi:plus" width="14" height="14"></iconify-icon>
                                        Thêm Mẫu Xe
                                    </button>
                                    <a href="<%= ctx %>/doitac/quanlymauxe" style="background: #f9fafb; color: var(--color-text-primary); padding: var(--spacing-sm) var(--spacing-md); border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 12px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; gap: 6px; text-decoration: none; transition: all 0.15s ease;">
                                        <iconify-icon icon="mdi:arrow-left" width="14" height="14"></iconify-icon>
                                        Đổi Chi Nhánh
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Right Panel: Models List -->
                        <div style="background: white; border-radius: 12px; padding: var(--spacing-lg); border: 1px solid #e5e7eb; box-shadow: 0 1px 3px rgba(0,0,0,0.08);">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: var(--spacing-lg); padding-bottom: var(--spacing-lg); border-bottom: 1px solid #e5e7eb;">
                                <h2 style="font-size: 16px; font-weight: 700; color: var(--color-text-primary); margin: 0;">Danh Sách Mẫu Xe</h2>
                            </div>

                            <div style="overflow-x: auto;">
                                <% if (danhSachMX == null || danhSachMX.isEmpty()) { %>
                                    <div style="text-align: center; padding: var(--spacing-3xl); color: #6b7280; font-size: 14px;">
                                        <iconify-icon icon="mdi:inbox-outline" width="48" height="48" style="display: block; margin: 0 auto var(--spacing-md); opacity: 0.4;"></iconify-icon>
                                        Chưa có mẫu xe nào tại chi nhánh này.
                                    </div>
                                <% } else { %>
                                    <table style="width: 100%; border-collapse: collapse;">
                                        <thead>
                                            <tr style="background: #f9fafb;">
                                                <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981; width: 50px;">#</th>
                                                <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: center; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981; width: 120px;">Hình Ảnh</th>
                                                <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981;">Hãng Xe</th>
                                                <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981;">Dòng Xe</th>
                                                <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981;">Đời Xe</th>
                                                <th style="padding: var(--spacing-md) var(--spacing-lg); font-size: 12px; font-weight: 700; text-align: left; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #10b981;">Dung Tích</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% int stt = 1; for (MauXe mx : danhSachMX) { %>
                                                <tr class="table-row" style="border-bottom: 1px solid #e5e7eb;">
                                                    <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 14px; color: var(--color-text-primary);"><span style="display: inline-block; padding: var(--spacing-xs) var(--spacing-md); background: #10b981; color: white; border-radius: 6px; font-size: 11px; font-weight: 700; letter-spacing: 0.3px;"><%= stt++ %></span></td>
                                                    <td style="padding: var(--spacing-md) var(--spacing-lg); text-align: center;">
                                                        <% if (mx.getUrlHinhAnh() != null && !mx.getUrlHinhAnh().isEmpty()) { %>
                                                            <div style="width: 100px; height: 80px; background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 6px; display: flex; align-items: center; justify-content: center; overflow: hidden; margin: 0 auto;">
                                                                <img src="<%= ctx %><%= mx.getUrlHinhAnh() %>" alt="<%= esc(mx.getHangXe()) %>" style="max-width: 100%; max-height: 100%; object-fit: contain;" />
                                                            </div>
                                                        <% } else { %>
                                                            <div style="width: 100px; height: 80px; background: #f9fafb; border: 1px dashed #e5e7eb; border-radius: 6px; display: flex; align-items: center; justify-content: center; margin: 0 auto;">
                                                                <span style="font-size: 11px; color: #9ca3af;">Không có ảnh</span>
                                                            </div>
                                                        <% } %>
                                                    </td>
                                                    <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 14px; color: var(--color-text-primary);"><strong><%= esc(mx.getHangXe()) %></strong></td>
                                                    <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 13px; color: #6b7280;"><%= esc(mx.getDongXe()) %></td>
                                                    <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 13px; color: #6b7280;"><%= mx.getDoiXe() %></td>
                                                    <td style="padding: var(--spacing-md) var(--spacing-lg); font-size: 13px; color: #6b7280;"><%= mx.getDungTich() %> cc</td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </section>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>
</body>
<script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
<script>
    // File preview functionality
    const fileInput = document.getElementById('hinhAnhInput');
    const previewContainer = document.getElementById('filePreviewContainer');
    const fileNameDisplay = document.getElementById('fileNameDisplay');
    const imagePreview = document.getElementById('imagePreview');
    const clearFileBtn = document.getElementById('clearFileBtn');

    fileInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            // Check file size (max 5MB)
            if (file.size > 5 * 1024 * 1024) {
                alert('Kích thước file không được vượt quá 5MB');
                this.value = '';
                previewContainer.style.display = 'none';
                return;
            }
            
            // Check file type
            if (!file.type.startsWith('image/')) {
                alert('Vui lòng chọn file ảnh (JPEG, PNG, GIF, WebP...)');
                this.value = '';
                previewContainer.style.display = 'none';
                return;
            }
            
            fileNameDisplay.textContent = file.name;
            previewContainer.style.display = 'block';
            
            // Create preview
            const reader = new FileReader();
            reader.onload = function(event) {
                imagePreview.src = event.target.result;
            };
            reader.readAsDataURL(file);
        }
    });

    clearFileBtn.addEventListener('click', function() {
        fileInput.value = '';
        previewContainer.style.display = 'none';
    });

    // Drag and drop
    fileInput.addEventListener('dragover', function(e) {
        e.preventDefault();
        this.style.borderColor = '#10b981';
        this.style.backgroundColor = 'rgba(16, 185, 129, 0.05)';
    });

    fileInput.addEventListener('dragleave', function(e) {
        e.preventDefault();
        this.style.borderColor = '#e5e7eb';
        this.style.backgroundColor = '#f9fafb';
    });

    fileInput.addEventListener('drop', function(e) {
        e.preventDefault();
        this.style.borderColor = '#e5e7eb';
        this.style.backgroundColor = '#f9fafb';
        
        if (e.dataTransfer.files.length > 0) {
            this.files = e.dataTransfer.files;
            const event = new Event('change', { bubbles: true });
            this.dispatchEvent(event);
        }
    });
</script>
</html>
