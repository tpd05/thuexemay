<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ChiNhanhDAO,dao.MauXeDAO,dao.GoiThueDAO,model.ChiNhanh,model.MauXe,model.GoiThue,java.util.List,java.util.ArrayList,java.text.NumberFormat,java.util.Locale" %>
<%--
    LƯU Ý: Không dùng 'gt' làm tên biến EL (từ khóa JSP EL).
    File này dùng tên biến 'goiThue' và dùng <%= %>.
--%>
<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    }
    private String fmtTien(float f) {
        return NumberFormat.getNumberInstance(new Locale("vi","VN")).format((long)f) + " ₫";
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

    List<ChiNhanh> danhSachCN      = new ChiNhanhDAO().layToanBoChiNhanh(maDoiTac);
    List<MauXe>    danhSachMauXe   = new MauXeDAO().layDanhSachMauXeTheoDoiTac(maDoiTac);
    List<GoiThue>  danhSachGoiThue = new GoiThueDAO().layDanhSachTheoDoiTac(maDoiTac);
    if (danhSachCN == null)      danhSachCN      = new ArrayList<>();
    if (danhSachMauXe == null)   danhSachMauXe   = new ArrayList<>();
    if (danhSachGoiThue == null) danhSachGoiThue = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Gói Thuê - Đối Tác</title>
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
        /* Tree */
        .tree-node { border: 1px solid #cbd5e1; border-radius: 10px; overflow: hidden; margin-bottom: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        
        /* Cấp 1: Chi nhánh */
        .tree-branch { display: flex; align-items: center; gap: 10px; padding: 14px 16px; background: #f1f5f9; cursor: pointer; user-select: none; font-weight: 700; font-size: 14px; border-bottom: 1px solid #e2e8f0; }
        .tree-branch:hover { background: #e2e8f0; }
        .tree-branch .chevron { transition: transform 0.2s; margin-left: auto; color: #6b7280; }
        .tree-branch.open .chevron { transform: rotate(90deg); }
        .tree-branches { display: none; }
        .tree-branches.open { display: block; }
        
        /* Cấp 2: Mẫu xe */
        .tree-model { border-top: 1px solid #e2e8f0; }
        .tree-model-header { display: flex; align-items: center; gap: 8px; padding: 12px 16px 12px 36px; background: #f8fafc; cursor: pointer; font-size: 13px; font-weight: 600; border-left: 4px solid #cbd5e1; }
        .tree-model-header:hover { background: #f1f5f9; }
        .tree-model-header .chevron2 { transition: transform 0.2s; margin-left: auto; color: #9ca3af; }
        .tree-model-header.open .chevron2 { transform: rotate(90deg); }
        .tree-packages { display: none; }
        .tree-packages.open { display: block; }

        /* Cấp 3: Gói Thuê */
        .pkg-row { display: grid; grid-template-columns: 1fr 110px 110px 90px auto; gap: 8px; align-items: center; 
                   padding: 10px 16px 10px 68px; border-top: 1px solid #f1f5f9; font-size: 12px; 
                   background: #ffffff; border-left: 4px solid #e2e8f0; }
        .pkg-row:hover { background: #f8fafc; }
        .price-tag { font-weight: 700; color: #10b981; font-size: 12px; }

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
        .field input, .field select, .field textarea { width: 100%; padding: 9px 12px; border: 1px solid #e5e7eb; border-radius: 6px; font-family: inherit; font-size: 14px; background: #f9fafb; color: #111827; outline: none; transition: border-color 0.15s; box-sizing: border-box; }
        .field input:focus, .field select:focus, .field textarea:focus { border-color: #10b981; box-shadow: 0 0 0 3px rgba(16,185,129,0.12); background: #fff; }
        .field textarea { resize: vertical; min-height: 72px; }
        .field .hint { font-size: 11px; color: #9ca3af; margin-top: 4px; }
        .btn-submit { width: 100%; background: #10b981; color: #fff; padding: 11px; border: none; border-radius: 7px; font-family: inherit; font-size: 13px; font-weight: 700; cursor: pointer; transition: background 0.15s; display: flex; align-items: center; justify-content: center; gap: 6px; }
        .btn-submit:hover { background: #059669; }
        .btn-submit:disabled { background: #9ca3af; cursor: not-allowed; }

        .toast { position: fixed; top: 80px; right: 20px; max-width: 360px; padding: 14px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; z-index: 9999; display: none; box-shadow: 0 4px 16px rgba(0,0,0,0.12); animation: slideIn 0.25s ease; }
        .toast.show { display: block; }
        .toast.success { background: #ecfdf5; color: #065f46; border-left: 4px solid #10b981; }
        .toast.error   { background: #fef2f2; color: #991b1b; border-left: 4px solid #ef4444; }
        @keyframes slideIn { from { transform: translateX(400px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

        .count-pill { font-size: 11px; background: #e5e7eb; color: #6b7280; padding: 2px 7px; border-radius: 99px; font-weight: 600; margin-left: 4px; }
        .cn-icon  { width: 28px; height: 28px; background: #10b981; border-radius: 6px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .mx-icon  { width: 22px; height: 22px; background: #3b82f6; border-radius: 4px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
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
                <h1 style="font-size:24px;font-weight:800;margin:0 0 4px;">Quản Lý Gói Thuê</h1>
                <p style="margin:0;font-size:13px;color:#6b7280;">Xem gói thuê theo chi nhánh và mẫu xe.</p>
            </div>

            <!-- Action bar -->
            <div class="action-bar">
                <span style="font-size:13px;color:#6b7280;">
                    Tổng: <strong style="color:#111827;"><%= danhSachGoiThue.size() %></strong> gói thuê
                </span>
                <button class="btn-add" onclick="openModal()">
                    <iconify-icon icon="mdi:plus" width="16"></iconify-icon>
                    Tạo Gói Thuê
                </button>
            </div>

            <!-- Cây dữ liệu (full width) -->
            <% if (danhSachCN.isEmpty()) { %>
            <div class="empty-tree">
                <iconify-icon icon="mdi:store-off-outline" width="56" height="56" style="display:block;margin:0 auto 16px;opacity:.25;"></iconify-icon>
                <p style="margin:0 0 6px;font-weight:600;">Chưa có chi nhánh nào</p>
                <p style="margin:0;font-size:13px;">Hãy thêm chi nhánh trước!</p>
            </div>
            <% } else { %>
            <%
            for (ChiNhanh chiNhanh : danhSachCN) {
                int maCN = chiNhanh.getMaChiNhanh();
                int goiCount = 0;
                for (GoiThue goiThue : danhSachGoiThue) {
                    if (goiThue.getMaChiNhanh() == maCN) goiCount++;
                }
            %>
            <div class="tree-node">
                <div class="tree-branch" onclick="toggleBranch(this)">
                    <div class="cn-icon">
                        <iconify-icon icon="mdi:store-outline" width="14" style="color:white;"></iconify-icon>
                    </div>
                    <span><%= esc(chiNhanh.getTenChiNhanh()) %></span>
                    <span style="font-size:11px;color:#6b7280;font-weight:400;"><%= esc(chiNhanh.getDiaDiem()) %></span>
                    <span class="count-pill"><%= goiCount %> gói</span>
                    <iconify-icon icon="mdi:chevron-right" width="16" class="chevron"></iconify-icon>
                </div>
                <div class="tree-branches">
                    <%
                    boolean coMauXe = false;
                    for (MauXe mauXe : danhSachMauXe) {
                        if (mauXe.getMaChiNhanh() != maCN) continue;
                        coMauXe = true;
                        int maMX = mauXe.getMaMauXe();
                        int goiTheoMX = 0;
                        for (GoiThue goiThue : danhSachGoiThue) {
                            if (goiThue.getMaMauXe() == maMX) goiTheoMX++;
                        }
                    %>
                    <div class="tree-model">
                        <div class="tree-model-header" onclick="toggleModel(this)">
                            <div class="mx-icon">
                                <iconify-icon icon="mdi:motorbike" width="12" style="color:white;"></iconify-icon>
                            </div>
                            <span><%= esc(mauXe.getHangXe()) %> <%= esc(mauXe.getDongXe()) %></span>
                            <span style="font-size:11px;color:#9ca3af;font-weight:400;">(<%= mauXe.getDoiXe() %>)</span>
                            <span class="count-pill"><%= goiTheoMX %> gói</span>
                            <iconify-icon icon="mdi:chevron-right" width="14" class="chevron2"></iconify-icon>
                        </div>
                        <div class="tree-packages">
                            <!-- Header row -->
                            <div style="display:grid;grid-template-columns:1fr 110px 110px 90px auto;gap:8px;padding:8px 16px 8px 68px;background:#ffffff;border-top:2px solid #10b981; border-left: 4px solid #e2e8f0;">
                                <span style="font-size:11px;font-weight:700;text-transform:uppercase;color:#6b7280;">Tên Gói</span>
                                <span style="font-size:11px;font-weight:700;text-transform:uppercase;color:#6b7280;">Giá/Ngày</span>
                                <span style="font-size:11px;font-weight:700;text-transform:uppercase;color:#6b7280;">Giá/Giờ</span>
                                <span style="font-size:11px;font-weight:700;text-transform:uppercase;color:#6b7280;">Phụ Thu</span>
                                <span></span>
                            </div>
                            <%
                            boolean coGoi = false;
                            for (GoiThue goiThue : danhSachGoiThue) {
                                if (goiThue.getMaMauXe() != maMX) continue;
                                coGoi = true;
                            %>
                            <div class="pkg-row">
                                <strong><%= esc(goiThue.getTenGoiThue()) %></strong>
                                <span class="price-tag"><%= fmtTien(goiThue.getGiaNgay()) %></span>
                                <span class="price-tag"><%= fmtTien(goiThue.getGiaTuan()) %></span>
                                <span style="color:#6b7280;"><%= goiThue.getPhuThu() > 0 ? fmtTien(goiThue.getPhuThu()) : "—" %></span>
                                <!-- Nút Sửa / Xóa — ẩn, chờ servlet -->
                                <div class="row-actions">
                                    <button class="btn-edit" onclick="suaGoi(<%= goiThue.getMaGoiThue() %>)">
                                        <iconify-icon icon="mdi:pencil-outline" width="11"></iconify-icon> Sửa
                                    </button>
                                    <button class="btn-delete" onclick="xoaGoi(<%= goiThue.getMaGoiThue() %>, '<%= esc(goiThue.getTenGoiThue()) %>')">
                                        <iconify-icon icon="mdi:trash-can-outline" width="11"></iconify-icon> Xóa
                                    </button>
                                </div>
                            </div>
                            <% } %>
                            <% if (!coGoi) { %>
                            <div style="padding:12px 52px;font-size:12px;color:#9ca3af;border-top:1px solid #f3f4f6;">
                                Chưa có gói thuê nào cho mẫu xe này.
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                    <% if (!coMauXe) { %>
                    <div style="padding:16px 36px;font-size:13px;color:#9ca3af;">
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

<!-- Modal tạo gói thuê -->
<div class="modal-overlay" id="modalOverlay" onclick="handleOverlayClick(event)">
    <div class="modal-box" id="modalBox">
        <div class="modal-header">
            <div style="width:34px;height:34px;background:#10b981;border-radius:8px;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                <iconify-icon icon="mdi:package-variant-closed" width="18" style="color:white;"></iconify-icon>
            </div>
            <div>
                <div style="font-size:15px;font-weight:800;">Tạo Gói Thuê</div>
                <div style="font-size:11px;color:#6b7280;">Chọn chi nhánh và mẫu xe trước</div>
            </div>
            <button class="modal-close" onclick="closeModal()">
                <iconify-icon icon="mdi:close" width="20"></iconify-icon>
            </button>
        </div>
        <div class="modal-body">
            <form id="formTaoGoi" onsubmit="submitTaoGoi(event)">

                <div class="field">
                    <label>Chi Nhánh <span style="color:#ef4444;">*</span></label>
                    <select id="selCN" name="maChiNhanh" onchange="loadMauXeGoi()" required>
                        <option value="">-- Chọn chi nhánh --</option>
                        <% for (ChiNhanh chiNhanh : danhSachCN) { %>
                        <option value="<%= chiNhanh.getMaChiNhanh() %>"><%= esc(chiNhanh.getTenChiNhanh()) %></option>
                        <% } %>
                    </select>
                </div>

                <div class="field">
                    <label>Mẫu Xe <span style="color:#ef4444;">*</span></label>
                    <select id="selMX" name="maMauXe" required disabled>
                        <option value="">-- Chọn chi nhánh trước --</option>
                    </select>
                </div>

                <div class="field">
                    <label>Tên Gói Thuê <span style="color:#ef4444;">*</span></label>
                    <input type="text" name="tenGoiThue" placeholder="VD: Gói ngày Honda Wave" maxlength="100" required>
                </div>

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
                    <div class="field" style="margin-bottom:0;">
                        <label>Giá/Ngày (₫) <span style="color:#ef4444;">*</span></label>
                        <input type="number" name="giaNgay" placeholder="150000" min="1" required>
                    </div>
                    <div class="field" style="margin-bottom:0;">
                        <label>Giá/Tuần (₫) <span style="color:#ef4444;">*</span></label>
                        <input type="number" name="giaTuan" placeholder="700000" min="1" required>
                    </div>
                </div>

                <div class="field" style="margin-top:16px;">
                    <label>Phụ Thu (₫)</label>
                    <input type="number" name="phuThu" value="0" min="0">
                    <div class="hint">Phí phát sinh nếu có, để 0 nếu không có</div>
                </div>

                <div class="field">
                    <label>Phụ Kiện Đi Kèm</label>
                    <textarea name="phuKien" placeholder="Mũ bảo hiểm, áo mưa, bơm xe..."></textarea>
                </div>

                <button type="submit" class="btn-submit" id="btnSubmitGoi">
                    <iconify-icon icon="mdi:plus-circle-outline" width="16"></iconify-icon>
                    Tạo Gói Thuê
                </button>
            </form>
        </div>
    </div>
</div>

<div id="toast" class="toast"></div>

<script>
const mauXeTheoNhanh = {
    <%
    boolean firstCN2 = true;
    for (ChiNhanh chiNhanh : danhSachCN) {
        if (!firstCN2) out.print(",");
        firstCN2 = false;
        out.print("\"" + chiNhanh.getMaChiNhanh() + "\": [");
        boolean firstMX = true;
        for (MauXe mauXe : danhSachMauXe) {
            if (mauXe.getMaChiNhanh() != chiNhanh.getMaChiNhanh()) continue;
            if (!firstMX) out.print(",");
            firstMX = false;
            out.print("{id:" + mauXe.getMaMauXe() + ", ten:\"" + esc(mauXe.getHangXe()) + " " + esc(mauXe.getDongXe()) + " (" + mauXe.getDoiXe() + ")\"}");
        }
        out.print("]");
    }
    %>
};

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
function loadMauXeGoi() {
    const cnId = document.getElementById('selCN').value;
    const sel  = document.getElementById('selMX');
    sel.innerHTML = '<option value="">-- Chọn mẫu xe --</option>';
    const list = mauXeTheoNhanh[cnId];
    if (!cnId || !list || list.length === 0) {
        sel.disabled = true;
        sel.innerHTML = '<option value="">-- Chi nhánh này chưa có mẫu xe --</option>';
        return;
    }
    sel.disabled = false;
    list.forEach(mx => {
        const opt = document.createElement('option');
        opt.value = mx.id; opt.textContent = mx.ten;
        sel.appendChild(opt);
    });
}
function toggleBranch(el) {
    el.classList.toggle('open');
    el.nextElementSibling.classList.toggle('open');
}
function toggleModel(el) {
    el.classList.toggle('open');
    el.nextElementSibling.classList.toggle('open');
}
async function submitTaoGoi(e) {
    e.preventDefault();
    const form = e.target;
    const btn  = document.getElementById('btnSubmitGoi');
    const giaNgay = parseFloat(form.giaNgay.value);
    const giaTuan = parseFloat(form.giaTuan.value);
    const phuThu  = parseFloat(form.phuThu.value || '0');
    if (isNaN(giaNgay) || giaNgay <= 0) { showToast('Giá ngày phải lớn hơn 0', 'error'); return; }
    if (isNaN(giaTuan) || giaTuan <= 0) { showToast('Giá tuần phải lớn hơn 0', 'error'); return; }
    if (isNaN(phuThu)  || phuThu  <  0) { showToast('Phụ thu không được âm', 'error'); return; }

    btn.disabled = true; btn.textContent = 'Đang xử lý...';

    const params = new URLSearchParams();
    params.append('maChiNhanh', form.maChiNhanh.value);
    params.append('maMauXe',    form.maMauXe.value);
    params.append('tenGoiThue', form.tenGoiThue.value.trim());
    params.append('giaNgay',    giaNgay);
    params.append('giaTuan',    giaTuan);
    params.append('phuThu',     phuThu);
    params.append('phuKien',    form.phuKien.value.trim());

    try {
        const res = await fetch('<%= ctx %>/doitac/quanlygoithue', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: params.toString(), credentials: 'same-origin'
        });
        const text = await res.text();
        const xml  = new DOMParser().parseFromString(text, 'text/xml');
        const status  = xml.querySelector('status')?.textContent || '';
        const message = xml.querySelector('message')?.textContent || 'Lỗi không xác định';

        if (status === 'success') {
            showToast(message, 'success');
            form.reset();
            document.getElementById('selMX').disabled = true;
            document.getElementById('selMX').innerHTML = '<option value="">-- Chọn chi nhánh trước --</option>';
            closeModal();
            setTimeout(() => location.reload(), 1200);
        } else {
            showToast(message, 'error');
        }
    } catch (err) {
        showToast('Lỗi kết nối: ' + err.message, 'error');
    } finally {
        btn.disabled = false;
        btn.innerHTML = '<iconify-icon icon="mdi:plus-circle-outline" width="16"></iconify-icon> Tạo Gói Thuê';
    }
}
// Chờ servlet
function suaGoi(id) { showToast('Chức năng đang phát triển', 'error'); }
function xoaGoi(id, ten) { showToast('Chức năng đang phát triển', 'error'); }

function showToast(msg, type, duration = 4000) {
    const t = document.getElementById('toast');
    t.textContent = msg; t.className = 'toast show ' + type;
    clearTimeout(t._timer);
    t._timer = setTimeout(() => t.classList.remove('show'), duration);
}
</script>
</body>
</html>
