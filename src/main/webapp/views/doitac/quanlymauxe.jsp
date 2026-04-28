<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChiNhanhDAO,dao.MauXeDAO,model.ChiNhanh,model.MauXe,java.util.List,java.util.ArrayList" %>
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
    String ctx = request.getContextPath();

    List<ChiNhanh> danhSachCN = new ChiNhanhDAO().layToanBoChiNhanh(maDoiTac);
    List<MauXe>    danhSachMX = new MauXeDAO().layDanhSachMauXeTheoDoiTac(maDoiTac);
    if (danhSachCN == null) danhSachCN = new ArrayList<>();
    if (danhSachMX == null) danhSachMX = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Mẫu Xe - Đối Tác</title>
    <link href="<%= ctx %>/dist/tailwind.css" rel="stylesheet">
    <link href="<%= ctx %>/css/globals.css" rel="stylesheet">
    <link href="<%= ctx %>/css/components.css" rel="stylesheet">
    <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
    <style>
        /* Action bar */
        .action-bar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; padding: 12px 16px; background: #fff; border: 1px solid #e5e7eb; border-radius: 10px; }
        .btn-add { background: #10b981; color: #fff; border: none; border-radius: 7px; padding: 9px 18px; font-family: inherit; font-size: 13px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 6px; transition: background 0.15s; }
        .btn-add:hover { background: #059669; }

        /* Tree */
        .tree-node { border: 1px solid #cbd5e1; border-radius: 10px; overflow: hidden; margin-bottom: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        
        /* Cấp 1: Chi nhánh */
        .tree-branch { display: flex; align-items: center; gap: 10px; padding: 14px 16px; background: #f1f5f9; cursor: pointer; user-select: none; font-weight: 700; font-size: 14px; border-bottom: 1px solid #e2e8f0; }
        .tree-branch:hover { background: #e2e8f0; }
        .tree-branch .chevron { transition: transform 0.2s; margin-left: auto; color: #6b7280; }
        .tree-branch.open .chevron { transform: rotate(90deg); }
        .tree-models-body { display: none; }
        .tree-models-body.open { display: block; }

        /* Cấp 2: Mẫu xe */
        .model-row { display: grid; grid-template-columns: 70px 110px 1fr 60px 70px auto; gap: 8px; align-items: center; 
                     padding: 12px 16px 12px 48px; border-top: 1px solid #f1f5f9; font-size: 13px; 
                     background: #fff; border-left: 4px solid #cbd5e1; }
        .model-row:hover { background: #f8fafc; }
        .model-img { width: 60px; height: 48px; object-fit: contain; border-radius: 4px; background: #f9fafb; border: 1px solid #e5e7eb; }
        .model-img-placeholder { width: 60px; height: 48px; display: flex; align-items: center; justify-content: center; background: #f3f4f6; border: 1px dashed #e5e7eb; border-radius: 4px; }

        /* Row action buttons (hidden) */
        .row-actions { display: none; align-items: center; gap: 5px; }
        .btn-edit { background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe; border-radius: 5px; padding: 3px 9px; font-size: 11px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 3px; white-space: nowrap; }
        .btn-edit:hover { background: #dbeafe; }
        .btn-delete { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; border-radius: 5px; padding: 3px 9px; font-size: 11px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 3px; white-space: nowrap; }
        .btn-delete:hover { background: #fee2e2; }

        /* Modal */
        .modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.45); z-index: 1000; display: none; align-items: center; justify-content: center; padding: 20px; }
        .modal-overlay.open { display: flex; }
        .modal-box { background: #fff; border-radius: 14px; width: 100%; max-width: 520px; box-shadow: 0 20px 60px rgba(0,0,0,0.2); animation: modalIn 0.2s ease; max-height: 90vh; overflow-y: auto; }
        @keyframes modalIn { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-header { padding: 18px 20px; border-bottom: 1px solid #e5e7eb; display: flex; align-items: center; gap: 10px; }
        .modal-body { padding: 20px; }
        .modal-close { margin-left: auto; background: none; border: none; cursor: pointer; color: #9ca3af; padding: 4px; border-radius: 4px; display: flex; align-items: center; }
        .modal-close:hover { background: #f3f4f6; color: #374151; }

        /* Form */
        .field { margin-bottom: 16px; }
        .field label { display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.4px; color: #374151; margin-bottom: 6px; }
        .field input, .field select { width: 100%; padding: 9px 12px; border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: #111827; outline: none; transition: border-color 0.15s; box-sizing: border-box; }
        .field input:focus, .field select:focus { border-color: #10b981; box-shadow: 0 0 0 3px rgba(16,185,129,0.12); background: #fff; }
        .field .hint { font-size: 11px; color: #9ca3af; margin-top: 4px; }
        .upload-area { border: 2px dashed #e5e7eb; border-radius: 8px; padding: 20px; text-align: center; cursor: pointer; transition: all 0.15s; background: #f9fafb; }
        .upload-area:hover { border-color: #10b981; background: #f0fdf4; }
        .upload-area input[type="file"] { display: none; }
        .preview-box { display: none; margin-top: 10px; text-align: center; }
        .preview-box img { max-width: 100%; max-height: 120px; border-radius: 6px; border: 1px solid #e5e7eb; }
        .btn-submit { width: 100%; background: #10b981; color: #fff; padding: 11px; border: none; border-radius: 7px; font-family: inherit; font-size: 13px; font-weight: 700; cursor: pointer; transition: background 0.15s; display: flex; align-items: center; justify-content: center; gap: 6px; }
        .btn-submit:hover { background: #059669; }

        .toast { position: fixed; top: 80px; right: 20px; max-width: 360px; padding: 14px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; z-index: 9999; display: none; box-shadow: 0 4px 16px rgba(0,0,0,0.12); animation: slideIn 0.25s ease; }
        .toast.show { display: block; }
        .toast.success { background: #ecfdf5; color: #065f46; border-left: 4px solid #10b981; }
        .toast.error   { background: #fef2f2; color: #991b1b; border-left: 4px solid #ef4444; }
        @keyframes slideIn { from { transform: translateX(400px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

        .count-pill { font-size: 11px; background: #e5e7eb; color: #6b7280; padding: 2px 7px; border-radius: 99px; font-weight: 600; margin-left: 4px; }
        .cn-icon { width: 28px; height: 28px; background: #10b981; border-radius: 6px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .empty-tree { text-align: center; padding: 64px 20px; color: #9ca3af; font-size: 14px; }
    </style>
</head>
<body class="bg-color-bg-primary text-color-text-primary font-body">
<div class="page-wrapper">
    <header class="page-header"><jsp:include page="/components/navbar.jsp" /></header>

    <main class="page-main">
        <section class="app-container" style="padding-top:32px;padding-bottom:48px;">

            <!-- Tiêu đề -->
            <div style="margin-bottom:24px;">
                <h1 style="font-size:24px;font-weight:800;margin:0 0 4px;">Quản Lý Mẫu Xe</h1>
                <p style="margin:0;font-size:13px;color:#6b7280;">Danh sách mẫu xe theo từng chi nhánh.</p>
            </div>

            <!-- Action bar -->
            <div class="action-bar">
                <span style="font-size:13px;color:#6b7280;">
                    Tổng: <strong style="color:#111827;"><%= danhSachMX.size() %></strong> mẫu xe
                </span>
                <button class="btn-add" onclick="openModal()">
                    <iconify-icon icon="mdi:plus" width="16"></iconify-icon>
                    Thêm Mẫu Xe
                </button>
            </div>

            <!-- Cây chi nhánh > mẫu xe (full width) -->
            <% if (danhSachCN.isEmpty()) { %>
            <div class="empty-tree">
                <iconify-icon icon="mdi:store-off-outline" width="56" height="56" style="display:block;margin:0 auto 16px;opacity:.25;"></iconify-icon>
                <p style="margin:0 0 6px;font-weight:600;">Chưa có chi nhánh nào</p>
                <p style="margin:0;font-size:13px;">Hãy thêm chi nhánh trước khi thêm mẫu xe.</p>
            </div>
            <% } else { %>
            <%
            for (ChiNhanh cn : danhSachCN) {
                int maCN = cn.getMaChiNhanh();
                int mxCount = 0;
                for (MauXe mx : danhSachMX) { if (mx.getMaChiNhanh() == maCN) mxCount++; }
            %>
            <div class="tree-node">
                <div class="tree-branch" onclick="toggleBranch(this)">
                    <div class="cn-icon">
                        <iconify-icon icon="mdi:store-outline" width="14" style="color:white;"></iconify-icon>
                    </div>
                    <span><%= esc(cn.getTenChiNhanh()) %></span>
                    <span style="font-size:11px;color:#6b7280;font-weight:400;"><%= esc(cn.getDiaDiem()) %></span>
                    <span class="count-pill"><%= mxCount %> mẫu</span>
                    <iconify-icon icon="mdi:chevron-right" width="16" class="chevron"></iconify-icon>
                </div>
                <div class="tree-models-body">
                    <!-- Header -->
                    <div style="display:grid;grid-template-columns:70px 110px 1fr 60px 70px auto;gap:8px;padding:8px 16px 8px 48px;background:#f8fafc;border-top:2px solid #10b981; border-left: 4px solid #cbd5e1;">
                        <span style="font-size:11px;font-weight:700;text-transform:uppercase;color:#6b7280;">Ảnh</span>
                        <span style="font-size:11px;font-weight:700;text-transform:uppercase;color:#6b7280;">Hãng Xe</span>
                        <span style="font-size:11px;font-weight:700;text-transform:uppercase;color:#6b7280;">Dòng Xe</span>
                        <span style="font-size:11px;font-weight:700;text-transform:uppercase;color:#6b7280;">Đời</span>
                        <span style="font-size:11px;font-weight:700;text-transform:uppercase;color:#6b7280;">Dung Tích</span>
                        <span></span>
                    </div>
                    <%
                    boolean coMX = false;
                    for (MauXe mx : danhSachMX) {
                        if (mx.getMaChiNhanh() != maCN) continue;
                        coMX = true;
                        String imgUrl = mx.getUrlHinhAnh();
                    %>
                    <div class="model-row">
                        <% if (imgUrl != null && !imgUrl.isEmpty()) { %>
                        <img class="model-img" src="<%= ctx %><%= esc(imgUrl) %>" alt="<%= esc(mx.getHangXe()) %>">
                        <% } else { %>
                        <div class="model-img-placeholder">
                            <iconify-icon icon="mdi:image-off-outline" width="20" style="color:#d1d5db;"></iconify-icon>
                        </div>
                        <% } %>
                        <strong style="font-size:13px;"><%= esc(mx.getHangXe()) %></strong>
                        <span style="color:#374151;"><%= esc(mx.getDongXe()) %></span>
                        <span style="color:#6b7280;"><%= mx.getDoiXe() %></span>
                        <span style="color:#6b7280;"><%= mx.getDungTich() %>cc</span>
                        <!-- Nút Sửa / Xóa — ẩn, chờ servlet -->
                        <div class="row-actions">
                            <button class="btn-edit" onclick="suaMauXe(<%= mx.getMaMauXe() %>)">
                                <iconify-icon icon="mdi:pencil-outline" width="11"></iconify-icon> Sửa
                            </button>
                            <button class="btn-delete" onclick="xoaMauXe(<%= mx.getMaMauXe() %>, '<%= esc(mx.getHangXe()) %> <%= esc(mx.getDongXe()) %>')">
                                <iconify-icon icon="mdi:trash-can-outline" width="11"></iconify-icon> Xóa
                            </button>
                        </div>
                    </div>
                    <% } %>
                    <% if (!coMX) { %>
                    <div style="padding:20px 44px;font-size:13px;color:#9ca3af;border-top:1px solid #f3f4f6;">
                        Chi nhánh này chưa có mẫu xe nào.
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>
            <% } %>

        </section>
    </main>

    <footer class="page-footer"><jsp:include page="/components/footer.jsp" /></footer>
</div>

<!-- Modal thêm mẫu xe -->
<div class="modal-overlay" id="modalOverlay" onclick="handleOverlayClick(event)">
    <div class="modal-box" id="modalBox">
        <div class="modal-header">
            <div style="width:34px;height:34px;background:#10b981;border-radius:8px;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                <iconify-icon icon="mdi:car-multiple" width="18" style="color:white;"></iconify-icon>
            </div>
            <div>
                <div style="font-size:15px;font-weight:800;">Thêm Mẫu Xe</div>
                <div style="font-size:11px;color:#6b7280;">Upload ảnh tùy chọn (tối đa 5MB)</div>
            </div>
            <button class="modal-close" onclick="closeModal()">
                <iconify-icon icon="mdi:close" width="20"></iconify-icon>
            </button>
        </div>
        <div class="modal-body">
            <form id="formThemMauXe" method="post" action="<%= ctx %>/doitac/themMauXe" enctype="multipart/form-data">

                <div class="field">
                    <label>Chi Nhánh <span style="color:#ef4444;">*</span></label>
                    <select name="maChiNhanh" required>
                        <option value="">-- Chọn chi nhánh --</option>
                        <% for (ChiNhanh cn : danhSachCN) { %>
                        <option value="<%= cn.getMaChiNhanh() %>"><%= esc(cn.getTenChiNhanh()) %></option>
                        <% } %>
                    </select>
                </div>

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
                    <div class="field" style="margin-bottom:0;">
                        <label>Hãng Xe <span style="color:#ef4444;">*</span></label>
                        <input type="text" name="hangXe" placeholder="Honda, Yamaha..." maxlength="50" required>
                    </div>
                    <div class="field" style="margin-bottom:0;">
                        <label>Dòng Xe <span style="color:#ef4444;">*</span></label>
                        <input type="text" name="dongXe" placeholder="Wave, Exciter..." maxlength="100" required>
                    </div>
                </div>

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:16px;">
                    <div class="field" style="margin-bottom:0;">
                        <label>Đời Xe <span style="color:#ef4444;">*</span></label>
                        <input type="number" name="doiXe" placeholder="2022" min="1900" max="2100" required>
                    </div>
                    <div class="field" style="margin-bottom:0;">
                        <label>Dung Tích (cc) <span style="color:#ef4444;">*</span></label>
                        <input type="number" name="dungTich" placeholder="110" min="1" step="0.1" required>
                    </div>
                </div>

                <div class="field" style="margin-top:16px;">
                    <label>Hình Ảnh <span style="font-size:11px;color:#9ca3af;font-weight:400;">(không bắt buộc)</span></label>
                    <div class="upload-area" id="uploadArea" onclick="document.getElementById('hinhAnh').click()">
                        <iconify-icon icon="mdi:image-plus-outline" width="28" style="color:#9ca3af;display:block;margin:0 auto 6px;"></iconify-icon>
                        <span id="uploadLabel" style="font-size:13px;color:#6b7280;">Nhấn để chọn ảnh</span>
                        <div style="font-size:11px;color:#9ca3af;margin-top:4px;">JPG, PNG, GIF — tối đa 5MB</div>
                        <input type="file" name="hinhAnh" id="hinhAnh" accept="image/*" onchange="previewImage(this)">
                    </div>
                    <div class="preview-box" id="previewBox">
                        <img id="previewImg" src="" alt="Preview">
                        <div style="margin-top:6px;">
                            <button type="button" onclick="clearImage()" style="font-size:11px;color:#ef4444;background:none;border:none;cursor:pointer;">✕ Xóa ảnh</button>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                    <iconify-icon icon="mdi:plus-circle-outline" width="16"></iconify-icon>
                    Thêm Mẫu Xe
                </button>
            </form>
        </div>
    </div>
</div>

<div id="toast" class="toast"></div>

<script>
function openModal() {
    document.getElementById('modalOverlay').classList.add('open');
    document.body.style.overflow = 'hidden';
}
function closeModal() {
    document.getElementById('modalOverlay').classList.remove('open');
    document.body.style.overflow = '';
}
function handleOverlayClick(e) {
    if (e.target === document.getElementById('modalOverlay')) closeModal();
}
function toggleBranch(el) {
    el.classList.toggle('open');
    el.nextElementSibling.classList.toggle('open');
}
function previewImage(input) {
    if (!input.files || !input.files[0]) return;
    const file = input.files[0];
    if (file.size > 5 * 1024 * 1024) { showToast('Ảnh không được vượt quá 5MB', 'error'); input.value = ''; return; }
    if (!file.type.startsWith('image/')) { showToast('Vui lòng chọn file ảnh', 'error'); input.value = ''; return; }
    document.getElementById('uploadLabel').textContent = file.name;
    const reader = new FileReader();
    reader.onload = e => {
        document.getElementById('previewImg').src = e.target.result;
        document.getElementById('previewBox').style.display = 'block';
    };
    reader.readAsDataURL(file);
}
function clearImage() {
    document.getElementById('hinhAnh').value = '';
    document.getElementById('previewBox').style.display = 'none';
    document.getElementById('uploadLabel').textContent = 'Nhấn để chọn ảnh';
}
// Chờ servlet
function suaMauXe(id) { showToast('Chức năng đang phát triển', 'error'); }
function xoaMauXe(id, ten) { showToast('Chức năng đang phát triển', 'error'); }

function showToast(msg, type, duration = 4000) {
    const t = document.getElementById('toast');
    t.textContent = msg; t.className = 'toast show ' + type;
    clearTimeout(t._timer);
    t._timer = setTimeout(() => t.classList.remove('show'), duration);
}
// Msg từ redirect
(function() {
    const params = new URLSearchParams(window.location.search);
    const msg = params.get('msg');
    const msgType = params.get('msgType');
    if (msg) showToast(decodeURIComponent(msg), msgType || 'error', 5000);
})();
</script>
</body>
</html>
