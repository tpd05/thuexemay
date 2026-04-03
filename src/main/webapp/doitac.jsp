<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctxPath = request.getContextPath();
    String role    = (String) session.getAttribute("role");
    Integer maDoiTac = (Integer) session.getAttribute("maDoiTac");
    if (!"DOI_TAC".equals(role) || maDoiTac == null) {
        response.sendRedirect(ctxPath + "/dangnhap");
        return;
    }
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Đối Tác – Quản lý xe</title>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: 'Segoe UI', sans-serif; background: #f0f2f5; color: #222; }

  /* ---- Topbar ---- */
  .topbar {
    background: #1a73e8; color: #fff;
    display: flex; align-items: center; justify-content: space-between;
    padding: 0 24px; height: 56px;
  }
  .topbar h1 { font-size: 1.1rem; font-weight: 600; }
  .topbar .user { font-size: .9rem; display: flex; align-items: center; gap: 12px; }
  .topbar a { color: #cfe2ff; text-decoration: none; font-size: .85rem; }
  .topbar a:hover { text-decoration: underline; }

  /* ---- Tabs ---- */
  .tabs { display: flex; background: #fff; border-bottom: 2px solid #e0e0e0; }
  .tab-btn {
    padding: 14px 24px; cursor: pointer; font-size: .95rem; font-weight: 500;
    color: #666; border: none; background: none; outline: none;
    border-bottom: 3px solid transparent; margin-bottom: -2px;
    transition: color .15s, border-color .15s;
  }
  .tab-btn:hover { color: #1a73e8; }
  .tab-btn.active { color: #1a73e8; border-bottom-color: #1a73e8; }

  /* ---- Content ---- */
  .content { padding: 24px; max-width: 1100px; margin: 0 auto; }
  .section { display: none; }
  .section.active { display: block; }

  /* ---- Card ---- */
  .card {
    background: #fff; border-radius: 10px;
    box-shadow: 0 1px 4px rgba(0,0,0,.1);
    padding: 20px 24px; margin-bottom: 20px;
  }
  .card h3 { font-size: 1rem; font-weight: 600; margin-bottom: 14px;
             padding-bottom: 10px; border-bottom: 1px solid #f0f0f0; }

  /* ---- Form grid ---- */
  .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px 20px; }
  .form-grid.single { grid-template-columns: 1fr; }
  .field { display: flex; flex-direction: column; gap: 4px; }
  .field.full { grid-column: 1 / -1; }
  label { font-size: .82rem; font-weight: 600; color: #555; }
  input, select, textarea {
    padding: 8px 10px; border: 1px solid #d0d0d0; border-radius: 6px;
    font-size: .9rem; font-family: inherit; transition: border-color .15s;
  }
  input:focus, select:focus, textarea:focus {
    border-color: #1a73e8; outline: none; box-shadow: 0 0 0 2px #e8f0fe;
  }
  textarea { resize: vertical; min-height: 68px; }
  .btn {
    padding: 9px 20px; border: none; border-radius: 6px; cursor: pointer;
    font-size: .9rem; font-weight: 600; transition: background .15s;
  }
  .btn-primary { background: #1a73e8; color: #fff; }
  .btn-primary:hover { background: #1558b0; }
  .btn-row { margin-top: 14px; display: flex; align-items: center; gap: 12px; }
  .msg { font-size: .87rem; font-weight: 500; }
  .msg.ok { color: #2e7d32; }
  .msg.err { color: #c62828; }

  /* ---- Table ---- */
  .tbl-wrap { overflow-x: auto; }
  table { width: 100%; border-collapse: collapse; font-size: .88rem; }
  th { background: #f5f7fa; text-align: left; padding: 9px 12px;
       font-weight: 600; color: #555; border-bottom: 2px solid #e0e0e0; }
  td { padding: 8px 12px; border-bottom: 1px solid #f0f0f0; color: #333; }
  tr:last-child td { border-bottom: none; }
  tr:hover td { background: #fafbff; }
  .empty-row td { text-align: center; color: #aaa; padding: 20px; }

  /* ---- Badge ---- */
  .badge {
    display: inline-block; padding: 2px 8px; border-radius: 20px; font-size: .78rem;
    font-weight: 600; text-transform: uppercase;
  }
  .badge-green { background: #e6f4ea; color: #2e7d32; }
  .badge-orange { background: #fff3e0; color: #e65100; }
  .badge-gray { background: #f0f0f0; color: #666; }

  /* ---- Filter bar ---- */
  .filter-bar { display: flex; align-items: center; gap: 10px; margin-bottom: 14px; }
  .filter-bar select { min-width: 200px; }
  .filter-bar label { white-space: nowrap; font-size: .85rem; color: #555; font-weight: 600; }

  @media (max-width: 680px) {
    .form-grid { grid-template-columns: 1fr; }
    .tabs { overflow-x: auto; }
    .tab-btn { white-space: nowrap; padding: 12px 16px; }
  }
</style>
</head>
<body>

<div class="topbar">
  <h1>🏍️ Cổng Đối Tác</h1>
  <div class="user">
    Xin chào, <strong><%= username %></strong>
    <a href="<%= ctxPath %>/dangnhap">Đăng xuất</a>
  </div>
</div>

<div class="tabs">
  <button class="tab-btn active" onclick="showTab('chinhanh')">🏢 Chi Nhánh</button>
  <button class="tab-btn" onclick="showTab('mauxe')">📋 Mẫu Xe</button>
  <button class="tab-btn" onclick="showTab('xemay')">🏍️ Xe Máy</button>
  <button class="tab-btn" onclick="showTab('goithue')">💼 Gói Thuê</button>
</div>

<div class="content">

  <!-- ==================== CHI NHÁNH ==================== -->
  <div id="sec-chinhanh" class="section active">

    <div class="card">
      <h3>Thêm chi nhánh mới</h3>
      <form id="f-chinhanh">
        <div class="form-grid">
          <div class="field">
            <label>Tên chi nhánh *</label>
            <input name="tenChiNhanh" required placeholder="VD: Chi nhánh Hoàn Kiếm">
          </div>
          <div class="field">
            <label>Địa điểm *</label>
            <input name="diaDiem" required placeholder="VD: 12 Lý Thái Tổ, Hà Nội">
          </div>
        </div>
        <div class="btn-row">
          <button type="submit" class="btn btn-primary">+ Thêm chi nhánh</button>
          <span id="msg-chinhanh" class="msg"></span>
        </div>
      </form>
    </div>

    <div class="card">
      <h3>Danh sách chi nhánh</h3>
      <div class="tbl-wrap">
        <table>
          <thead><tr><th>#</th><th>Tên chi nhánh</th><th>Địa điểm</th></tr></thead>
          <tbody id="tb-chinhanh"><tr class="empty-row"><td colspan="3">Đang tải…</td></tr></tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- ==================== MẪU XE ==================== -->
  <div id="sec-mauxe" class="section">

    <div class="card">
      <h3>Thêm mẫu xe mới</h3>
      <form id="f-mauxe">
        <div class="form-grid">
          <div class="field">
            <label>Chi nhánh *</label>
            <select name="maChiNhanh" id="dd-mauxe-chinhanh" required>
              <option value="">— Chọn chi nhánh —</option>
            </select>
          </div>
          <div class="field">
            <label>Hãng xe *</label>
            <input name="hangXe" required placeholder="VD: Honda, Yamaha">
          </div>
          <div class="field">
            <label>Dòng xe *</label>
            <input name="dongXe" required placeholder="VD: Wave Alpha, Exciter 155">
          </div>
          <div class="field">
            <label>Đời xe *</label>
            <input name="doiXe" required type="number" min="1990" max="2100" placeholder="VD: 2022">
          </div>
          <div class="field">
            <label>Dung tích (cc) *</label>
            <input name="dungTich" required type="number" min="0.1" placeholder="VD: 110">
          </div>
          <div class="field">
            <label>URL hình ảnh</label>
            <input name="urlHinhAnh" type="url" placeholder="https://…">
          </div>
        </div>
        <div class="btn-row">
          <button type="submit" class="btn btn-primary">+ Thêm mẫu xe</button>
          <span id="msg-mauxe" class="msg"></span>
        </div>
      </form>
    </div>

    <div class="card">
      <h3>Danh sách mẫu xe</h3>
      <div class="filter-bar">
        <label>Lọc theo chi nhánh:</label>
        <select id="filter-mauxe-cn" onchange="loadMauXe()">
          <option value="">— Tất cả —</option>
        </select>
      </div>
      <div class="tbl-wrap">
        <table>
          <thead><tr><th>#</th><th>Hãng xe</th><th>Dòng xe</th><th>Đời</th><th>Dung tích</th><th>Hình ảnh</th></tr></thead>
          <tbody id="tb-mauxe"><tr class="empty-row"><td colspan="6">Chọn tab để tải…</td></tr></tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- ==================== XE MÁY ==================== -->
  <div id="sec-xemay" class="section">

    <div class="card">
      <h3>Thêm xe máy mới</h3>
      <form id="f-xemay">
        <div class="form-grid">
          <div class="field">
            <label>Chi nhánh *</label>
            <select name="maChiNhanh" id="dd-xemay-chinhanh" required onchange="loadMauXeChoXeMay()">
              <option value="">— Chọn chi nhánh —</option>
            </select>
          </div>
          <div class="field">
            <label>Mẫu xe *</label>
            <select name="maMauXe" id="dd-xemay-mauxe" required>
              <option value="">— Chọn chi nhánh trước —</option>
            </select>
          </div>
          <div class="field">
            <label>Biển số *</label>
            <input name="bienSo" required placeholder="VD: 29A-12345" style="text-transform:uppercase">
          </div>
          <div class="field">
            <label>Số khung *</label>
            <input name="soKhung" required placeholder="VD: RLHSC…" style="text-transform:uppercase">
          </div>
          <div class="field">
            <label>Số máy *</label>
            <input name="soMay" required placeholder="VD: SC110…" style="text-transform:uppercase">
          </div>
          <div class="field">
            <label>Trạng thái</label>
            <select name="trangThai">
              <option value="san_sang">✅ Sẵn sàng</option>
              <option value="dang_thue">🔄 Đang thuê</option>
              <option value="bao_duong">🔧 Bảo dưỡng</option>
            </select>
          </div>
        </div>
        <div class="btn-row">
          <button type="submit" class="btn btn-primary">+ Thêm xe máy</button>
          <span id="msg-xemay" class="msg"></span>
        </div>
      </form>
    </div>

    <div class="card">
      <h3>Danh sách xe máy</h3>
      <div class="filter-bar">
        <label>Lọc theo chi nhánh:</label>
        <select id="filter-xemay-cn" onchange="loadXeMay()">
          <option value="">— Tất cả —</option>
        </select>
      </div>
      <div class="tbl-wrap">
        <table>
          <thead><tr><th>#</th><th>Biển số</th><th>Mẫu xe (ID)</th><th>Chi nhánh (ID)</th><th>Số khung</th><th>Số máy</th><th>Trạng thái</th></tr></thead>
          <tbody id="tb-xemay"><tr class="empty-row"><td colspan="7">Chọn tab để tải…</td></tr></tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- ==================== GÓI THUÊ ==================== -->
  <div id="sec-goithue" class="section">

    <div class="card">
      <h3>Tạo gói thuê mới</h3>
      <form id="f-goithue">
        <div class="form-grid">
          <div class="field">
            <label>Chi nhánh *</label>
            <select name="maChiNhanh" id="dd-goithue-chinhanh" required onchange="loadMauXeChoGoiThue()">
              <option value="">— Chọn chi nhánh —</option>
            </select>
          </div>
          <div class="field">
            <label>Mẫu xe *</label>
            <select name="maMauXe" id="dd-goithue-mauxe" required>
              <option value="">— Chọn chi nhánh trước —</option>
            </select>
          </div>
          <div class="field">
            <label>Tên gói thuê *</label>
            <input name="tenGoiThue" required placeholder="VD: Thuê ngày cơ bản">
          </div>
          <div class="field">
            <label>Giá / ngày (VNĐ) *</label>
            <input name="giaNgay" required type="number" min="1" placeholder="VD: 150000">
          </div>
          <div class="field">
            <label>Giá / giờ (VNĐ) *</label>
            <input name="giaGio" required type="number" min="1" placeholder="VD: 20000">
          </div>
          <div class="field">
            <label>Phụ thu (VNĐ)</label>
            <input name="phuThu" type="number" min="0" value="0">
          </div>
          <div class="field">
            <label>Giảm giá (%)</label>
            <input name="giamGia" type="number" min="0" max="100" value="0">
          </div>
          <div class="field full">
            <label>Phụ kiện kèm theo</label>
            <textarea name="phuKien" placeholder="VD: Mũ bảo hiểm, áo mưa, bơm xe…"></textarea>
          </div>
        </div>
        <div class="btn-row">
          <button type="submit" class="btn btn-primary">+ Tạo gói thuê</button>
          <span id="msg-goithue" class="msg"></span>
        </div>
      </form>
    </div>

    <div class="card">
      <h3>Danh sách gói thuê</h3>
      <div class="tbl-wrap">
        <table>
          <thead><tr><th>#</th><th>Tên gói</th><th>Mẫu xe (ID)</th><th>Chi nhánh (ID)</th><th>Giá/ngày</th><th>Giá/giờ</th><th>Phụ thu</th><th>Giảm giá</th><th>Phụ kiện</th></tr></thead>
          <tbody id="tb-goithue"><tr class="empty-row"><td colspan="9">Chọn tab để tải…</td></tr></tbody>
        </table>
      </div>
    </div>
  </div>

</div><!-- /content -->

<script>
const ctx = '<%= ctxPath %>';

/* ===============================================================
   Helpers
   =============================================================== */
function parseXml(text) {
  return new DOMParser().parseFromString(text, 'application/xml');
}
function txt(node, tag) {
  const el = node.querySelector(tag);
  return el ? el.textContent : '';
}
function setMsg(id, xmlText, isOk) {
  const doc  = parseXml(xmlText);
  const msg  = doc.querySelector('message')?.textContent || 'Lỗi không xác định';
  const type = doc.querySelector('status')?.textContent;
  const el   = document.getElementById('msg-' + id);
  el.textContent = msg;
  el.className   = 'msg ' + (isOk && type === 'success' ? 'ok' : 'err');
}
function fmt(n) { return Number(n).toLocaleString('vi-VN') + ' ₫'; }
function badgeTrangThai(v) {
  if (v === 'san_sang')  return '<span class="badge badge-green">Sẵn sàng</span>';
  if (v === 'dang_thue') return '<span class="badge badge-orange">Đang thuê</span>';
  return '<span class="badge badge-gray">' + v + '</span>';
}

/* Fill một <select> từ một mảng options [{value, label}] */
function fillSelect(sel, items, placeholder) {
  sel.innerHTML = '<option value="">' + placeholder + '</option>';
  items.forEach(it => {
    const o = document.createElement('option');
    o.value = it.value;
    o.textContent = it.label;
    sel.appendChild(o);
  });
}

/* ===============================================================
   Tab switching
   =============================================================== */
const tabInit = { chinhanh: false, mauxe: false, xemay: false, goithue: false };

function showTab(name) {
  document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  document.getElementById('sec-' + name).classList.add('active');
  event.currentTarget.classList.add('active');

  if (!tabInit[name]) {
    tabInit[name] = true;
    switch (name) {
      case 'chinhanh': loadChiNhanh(); break;
      case 'mauxe':    initMauXeTab(); break;
      case 'xemay':    initXeMayTab(); break;
      case 'goithue':  initGoiThueTab(); break;
    }
  }
}

/* ===============================================================
   CHI NHÁNH
   =============================================================== */
async function loadChiNhanh() {
    const res = await fetch(ctx + '/doitac/chinhanh');
    const doc = parseXml(await res.text());
    
    let rows = '';
    const items = [...doc.querySelectorAll('chiNhanh')];
    
    items.forEach((cn, i) => {
        rows += `<tr>
            <td>\${i+1}</td>
            <td>\${txt(cn, 'tenChiNhanh')}</td>
            <td>\${txt(cn, 'diaDiem')}</td>
        </tr>`;
    });
    
    document.getElementById('tb-chinhanh').innerHTML = 
        rows || '<tr class="empty-row"><td colspan="3">Chưa có chi nhánh nào</td></tr>';
    
    refreshChiNhanhDropdowns(doc);
}

function refreshChiNhanhDropdowns(doc) {
  const items = [...doc.querySelectorAll('chiNhanh')].map(cn => ({
    value: txt(cn, 'maChiNhanh'),
    label: txt(cn, 'tenChiNhanh') + ' – ' + txt(cn, 'diaDiem')
  }));

  const targets = [
    { id: 'dd-mauxe-chinhanh',   ph: '— Chọn chi nhánh —' },
    { id: 'filter-mauxe-cn',     ph: '— Tất cả —' },
    { id: 'dd-xemay-chinhanh',   ph: '— Chọn chi nhánh —' },
    { id: 'filter-xemay-cn',     ph: '— Tất cả —' },
    { id: 'dd-goithue-chinhanh', ph: '— Chọn chi nhánh —' },
  ];
  targets.forEach(t => {
    const el = document.getElementById(t.id);
    if (el) fillSelect(el, items, t.ph);
  });
}

document.getElementById('f-chinhanh').onsubmit = async function(e) {
  e.preventDefault();
  const res = await fetch(ctx + '/doitac/chinhanh', {
    method: 'POST',
    body: new URLSearchParams(new FormData(e.target))
  });
  const txt2 = await res.text();
  setMsg('chinhanh', txt2, res.ok);
  if (res.ok) { e.target.reset(); loadChiNhanh(); }
};

/* ===============================================================
   MẪU XE
   =============================================================== */
async function initMauXeTab() {
  // Đảm bảo dropdown chi nhánh đã được điền (nếu chưa load chinhanh tab)
  await ensureChiNhanhDropdowns();
  await loadMauXe();
}

async function loadMauXe() {
    const maChiNhanh = document.getElementById('filter-mauxe-cn').value;
    const url = ctx + '/doitac/mauxe' + (maChiNhanh ? '?maChiNhanh=' + maChiNhanh : '');
    
    const res = await fetch(url);
    const doc = parseXml(await res.text());
    
    let rows = '';
    [...doc.querySelectorAll('mauXe')].forEach((mx, i) => {
        const img = txt(mx, 'urlHinhAnh');
        rows += `<tr>
            <td>\${i+1}</td>
            <td><strong>\${txt(mx,'hangXe')}</strong></td>
            <td>\${txt(mx,'dongXe')}</td>
            <td>\${txt(mx,'doiXe')}</td>
            <td>\${txt(mx,'dungTich')} cc</td>
            <td>\${img ? '<a href="'+img+'" target="_blank">🖼️ Xem</a>' : '—'}</td>
        </tr>`;
    });
    
    document.getElementById('tb-mauxe').innerHTML = 
        rows || '<tr class="empty-row"><td colspan="6">Chưa có mẫu xe nào</td></tr>';
}

document.getElementById('f-mauxe').onsubmit = async function(e) {
  e.preventDefault();
  const res = await fetch(ctx + '/doitac/mauxe', {
    method: 'POST',
    body: new URLSearchParams(new FormData(e.target))
  });
  const txt2 = await res.text();
  setMsg('mauxe', txt2, res.ok);
  if (res.ok) { e.target.reset(); loadMauXe(); }
};

/* ===============================================================
   XE MÁY
   =============================================================== */
async function initXeMayTab() {
  await ensureChiNhanhDropdowns();
  await loadXeMay();
}

/* Khi chọn chi nhánh trong form thêm xe máy → load mẫu xe dropdown */
async function loadMauXeChoXeMay() {
  const maChiNhanh = document.getElementById('dd-xemay-chinhanh').value;
  const dd = document.getElementById('dd-xemay-mauxe');
  if (!maChiNhanh) {
    fillSelect(dd, [], '— Chọn chi nhánh trước —');
    return;
  }
  const res = await fetch(ctx + '/doitac/mauxe?maChiNhanh=' + maChiNhanh);
  const doc = parseXml(await res.text());
  const items = [...doc.querySelectorAll('mauXe')].map(mx => ({
    value: txt(mx, 'maMauXe'),
    label: txt(mx,'hangXe') + ' ' + txt(mx,'dongXe') + ' (' + txt(mx,'doiXe') + ')'
  }));
  fillSelect(dd, items, items.length ? '— Chọn mẫu xe —' : '— Chi nhánh này chưa có mẫu xe —');
}

async function loadXeMay() {
    const maChiNhanh = document.getElementById('filter-xemay-cn').value;
    const url = ctx + '/doitac/xemay' + (maChiNhanh ? '?maChiNhanh=' + maChiNhanh : '');
    
    const res = await fetch(url);
    const doc = parseXml(await res.text());
    
    let rows = '';
    [...doc.querySelectorAll('xeMay')].forEach((xm, i) => {
        rows += `<tr>
            <td>\${i+1}</td>
            <td><strong>\${txt(xm,'bienSo')}</strong></td>
            <td>\${txt(xm,'maMauXe')}</td>
            <td>\${txt(xm,'maChiNhanh')}</td>
            <td>\${txt(xm,'soKhung')}</td>
            <td>\${txt(xm,'soMay')}</td>
            <td>\${badgeTrangThai(txt(xm,'trangThai'))}</td>
        </tr>`;
    });
    
    document.getElementById('tb-xemay').innerHTML = 
        rows || '<tr class="empty-row"><td colspan="7">Chưa có xe máy nào</td></tr>';
}

document.getElementById('f-xemay').onsubmit = async function(e) {
  e.preventDefault();
  const res = await fetch(ctx + '/doitac/xemay', {
    method: 'POST',
    body: new URLSearchParams(new FormData(e.target))
  });
  const txt2 = await res.text();
  setMsg('xemay', txt2, res.ok);
  if (res.ok) { e.target.reset(); loadXeMay(); }
};

/* ===============================================================
   GÓI THUÊ
   =============================================================== */
async function initGoiThueTab() {
  await ensureChiNhanhDropdowns();
  await loadGoiThue();
}

async function loadMauXeChoGoiThue() {
  const maChiNhanh = document.getElementById('dd-goithue-chinhanh').value;
  const dd = document.getElementById('dd-goithue-mauxe');
  if (!maChiNhanh) {
    fillSelect(dd, [], '— Chọn chi nhánh trước —');
    return;
  }
  const res = await fetch(ctx + '/doitac/mauxe?maChiNhanh=' + maChiNhanh);
  const doc = parseXml(await res.text());
  const items = [...doc.querySelectorAll('mauXe')].map(mx => ({
    value: txt(mx, 'maMauXe'),
    label: txt(mx,'hangXe') + ' ' + txt(mx,'dongXe') + ' (' + txt(mx,'doiXe') + ')'
  }));
  fillSelect(dd, items, items.length ? '— Chọn mẫu xe —' : '— Chi nhánh này chưa có mẫu xe —');
}

async function loadGoiThue() {
  const res = await fetch(ctx + '/goithue/list');
  const doc = parseXml(await res.text());
  const rows = [...doc.querySelectorAll('goiThue')].map((gt, i) =>
    `<tr>
       <td>\${i+1}</td>
       <td><strong>\${txt(gt,'tenGoiThue')}</strong></td>
       <td>\${txt(gt,'maMauXe')}</td>
       <td>\${txt(gt,'maChiNhanh')}</td>
       <td>\${fmt(txt(gt,'giaNgay'))}</td>
       <td>\${fmt(txt(gt,'giaGio'))}</td>
       <td>\${fmt(txt(gt,'phuThu'))}</td>
       <td>\${txt(gt,'giamGia')}%</td>
       <td>\${txt(gt,'phuKien') || '—'}</td>
     </tr>`
  ).join('');
  document.getElementById('tb-goithue').innerHTML =
    rows || '<tr class="empty-row"><td colspan="9">Chưa có gói thuê nào</td></tr>';
}

document.getElementById('f-goithue').onsubmit = async function(e) {
  e.preventDefault();
  const res = await fetch(ctx + '/doitac/goithue', {
    method: 'POST',
    body: new URLSearchParams(new FormData(e.target))
  });
  const txt2 = await res.text();
  setMsg('goithue', txt2, res.ok);
  if (res.ok) { e.target.reset(); loadGoiThue(); }
};

/* ===============================================================
   Đảm bảo dropdown chi nhánh có dữ liệu (lazy load)
   =============================================================== */
let _cnLoaded = false;
async function ensureChiNhanhDropdowns() {
  if (_cnLoaded) return;
  const res = await fetch(ctx + '/doitac/chinhanh');
  if (!res.ok) return;
  refreshChiNhanhDropdowns(parseXml(await res.text()));
  _cnLoaded = true;
}

/* ===============================================================
   Khởi tạo – load tab Chi nhánh ngay khi vào trang
   =============================================================== */
(async () => {
  tabInit.chinhanh = true;
  await loadChiNhanh();
  _cnLoaded = true; // dropdown đã được fill từ loadChiNhanh
})();
</script>
</body>
</html>
