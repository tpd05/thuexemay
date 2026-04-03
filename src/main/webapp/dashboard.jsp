<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý đối tác</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; font-size: 14px; background: #f5f5f5; }

        /* Header */
        .header { background: #1976d2; color: #fff; padding: 10px 20px; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { font-size: 18px; }
        .header button { background: #fff; color: #1976d2; border: none; padding: 5px 14px; border-radius: 4px; cursor: pointer; }

        /* Tabs */
        .tabs { display: flex; background: #fff; border-bottom: 2px solid #1976d2; padding: 0 20px; }
        .tab { padding: 10px 18px; cursor: pointer; border-bottom: 3px solid transparent; margin-bottom: -2px; }
        .tab.active { border-bottom-color: #1976d2; color: #1976d2; font-weight: bold; }
        .tab:hover { background: #f0f0f0; }

        /* Content */
        .content { padding: 20px; }
        .panel { display: none; }
        .panel.active { display: block; }

        /* Table */
        table { width: 100%; border-collapse: collapse; background: #fff; }
        th, td { border: 1px solid #ddd; padding: 8px 10px; text-align: left; }
        th { background: #f0f0f0; font-weight: bold; }
        tr:hover td { background: #fafafa; }
        .no-data td { text-align: center; color: #888; padding: 20px; }

        /* Form */
        .form-wrap { background: #fff; border: 1px solid #ddd; border-radius: 4px; padding: 20px; max-width: 480px; }
        .form-wrap h3 { margin-bottom: 16px; font-size: 15px; }
        .form-group { margin-bottom: 12px; }
        .form-group label { display: block; margin-bottom: 4px; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 7px 8px; border: 1px solid #ccc; border-radius: 4px;
        }
        .form-row { display: flex; gap: 12px; }
        .form-row .form-group { flex: 1; }
        .btn-submit { background: #1976d2; color: #fff; border: none; padding: 8px 20px; border-radius: 4px; cursor: pointer; width: 100%; font-size: 14px; }
        .btn-submit:hover { background: #1565c0; }
        .btn-submit:disabled { background: #aaa; cursor: not-allowed; }
        .btn-refresh { background: #fff; border: 1px solid #ccc; padding: 5px 14px; border-radius: 4px; cursor: pointer; margin-bottom: 10px; }
        .btn-refresh:hover { background: #f0f0f0; }

        /* Alert */
        #alert { position: fixed; top: 15px; right: 15px; padding: 10px 18px; border-radius: 4px; font-size: 13px; display: none; z-index: 999; }
        #alert.success { background: #e8f5e9; border: 1px solid #a5d6a7; color: #2e7d32; }
        #alert.error   { background: #ffebee; border: 1px solid #ef9a9a; color: #c62828; }

        .layout { display: flex; gap: 24px; align-items: flex-start; }
        .layout table { flex: 1; }
    </style>
</head>
<body>

<div id="alert"></div>

<div class="header">
    <h1>🏍️ Quản lý đối tác — Thuê xe máy</h1>
    <button onclick="dangXuat()">Đăng xuất</button>
</div>

<div class="tabs">
    <div class="tab active" onclick="switchTab('tab-goithue', this)">Gói thuê</div>
    <div class="tab" onclick="switchTab('tab-chinhanh', this)">Chi nhánh</div>
    <div class="tab" onclick="switchTab('tab-mauxe', this)">Mẫu xe</div>
    <div class="tab" onclick="switchTab('tab-xemay', this)">Thêm xe máy</div>
</div>

<div class="content">

    <!-- ====== GÓI THUÊ ====== -->
    <div class="panel active" id="tab-goithue">
        <div class="layout">
            <!-- Danh sách -->
            <div style="flex:1">
                <button class="btn-refresh" onclick="taiGoiThue()">↻ Làm mới</button>
                <table id="tbl-goithue">
                    <thead><tr>
                        <th>Mã</th><th>Tên gói</th><th>Mẫu xe</th><th>Chi nhánh</th>
                        <th>Giá ngày</th><th>Giá giờ</th><th>Phụ thu</th><th>Giảm giá</th><th>Phụ kiện</th>
                    </tr></thead>
                    <tbody id="tbody-goithue"><tr class="no-data"><td colspan="9">Đang tải...</td></tr></tbody>
                </table>
            </div>
            <!-- Form thêm -->
            <div class="form-wrap" style="min-width:320px">
                <h3>Thêm gói thuê</h3>
                <div class="form-group">
                    <label>Mẫu xe *</label>
                    <select id="gt-maMauXe"></select>
                </div>
                <div class="form-group">
                    <label>Chi nhánh *</label>
                    <select id="gt-maChiNhanh"></select>
                </div>
                <div class="form-group">
                    <label>Tên gói thuê *</label>
                    <input type="text" id="gt-ten" placeholder="Vd: Gói ngày thường">
                </div>
                <div class="form-group">
                    <label>Phụ kiện</label>
                    <input type="text" id="gt-phuKien" placeholder="Vd: Mũ bảo hiểm, áo mưa">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Giá ngày (VND) *</label>
                        <input type="number" id="gt-giaNgay" placeholder="150000" min="0">
                    </div>
                    <div class="form-group">
                        <label>Giá giờ (VND) *</label>
                        <input type="number" id="gt-giaGio" placeholder="20000" min="0">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Phụ thu (VND)</label>
                        <input type="number" id="gt-phuThu" value="0" min="0">
                    </div>
                    <div class="form-group">
                        <label>Giảm giá (%)</label>
                        <input type="number" id="gt-giamGia" value="0" min="0" max="100">
                    </div>
                </div>
                <button class="btn-submit" id="btn-gt" onclick="submitGoiThue()">Thêm gói thuê</button>
            </div>
        </div>
    </div>

    <!-- ====== CHI NHÁNH ====== -->
    <div class="panel" id="tab-chinhanh">
        <div class="layout">
            <div style="flex:1">
                <button class="btn-refresh" onclick="taiChiNhanh()">↻ Làm mới</button>
                <table>
                    <thead><tr><th>Mã</th><th>Tên chi nhánh</th><th>Địa điểm</th></tr></thead>
                    <tbody id="tbody-chinhanh"><tr class="no-data"><td colspan="3">Đang tải...</td></tr></tbody>
                </table>
            </div>
            <div class="form-wrap" style="min-width:280px">
                <h3>Thêm chi nhánh</h3>
                <div class="form-group">
                    <label>Tên chi nhánh *</label>
                    <input type="text" id="cn-ten" placeholder="Vd: Chi nhánh Hoàn Kiếm">
                </div>
                <div class="form-group">
                    <label>Địa điểm *</label>
                    <input type="text" id="cn-diaDiem" placeholder="Địa chỉ đầy đủ">
                </div>
                <button class="btn-submit" id="btn-cn" onclick="submitChiNhanh()">Thêm chi nhánh</button>
            </div>
        </div>
    </div>

    <!-- ====== MẪU XE ====== -->
    <div class="panel" id="tab-mauxe">
        <div class="layout">
            <div style="flex:1">
                <button class="btn-refresh" onclick="taiMauXe()">↻ Làm mới</button>
                <table>
                    <thead><tr><th>Mã</th><th>Hãng xe</th><th>Dòng xe</th><th>Đời xe</th><th>Dung tích</th><th>Chi nhánh</th></tr></thead>
                    <tbody id="tbody-mauxe"><tr class="no-data"><td colspan="6">Đang tải...</td></tr></tbody>
                </table>
            </div>
            <div class="form-wrap" style="min-width:280px">
                <h3>Thêm mẫu xe</h3>
                <div class="form-group">
                    <label>Chi nhánh *</label>
                    <select id="mx-maChiNhanh"></select>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Hãng xe *</label>
                        <input type="text" id="mx-hangXe" placeholder="Honda">
                    </div>
                    <div class="form-group">
                        <label>Dòng xe *</label>
                        <input type="text" id="mx-dongXe" placeholder="Wave Alpha">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Đời xe *</label>
                        <input type="number" id="mx-doiXe" placeholder="2022">
                    </div>
                    <div class="form-group">
                        <label>Dung tích (cc) *</label>
                        <input type="number" id="mx-dungTich" placeholder="110" step="0.1">
                    </div>
                </div>
                <div class="form-group">
                    <label>URL hình ảnh</label>
                    <input type="text" id="mx-url" placeholder="https://...">
                </div>
                <button class="btn-submit" id="btn-mx" onclick="submitMauXe()">Thêm mẫu xe</button>
            </div>
        </div>
    </div>

    <!-- ====== XE MÁY ====== -->
    <div class="panel" id="tab-xemay">
        <div class="form-wrap">
            <h3>Thêm xe máy</h3>
            <div class="form-row">
                <div class="form-group">
                    <label>Mẫu xe *</label>
                    <select id="xm-maMauXe"></select>
                </div>
                <div class="form-group">
                    <label>Chi nhánh *</label>
                    <select id="xm-maChiNhanh"></select>
                </div>
            </div>
            <div class="form-group">
                <label>Biển số * (vd: 29A-12345)</label>
                <input type="text" id="xm-bienSo" placeholder="29A-12345" style="text-transform:uppercase">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Số khung *</label>
                    <input type="text" id="xm-soKhung" style="text-transform:uppercase">
                </div>
                <div class="form-group">
                    <label>Số máy *</label>
                    <input type="text" id="xm-soMay" style="text-transform:uppercase">
                </div>
            </div>
            <div class="form-group">
                <label>Trạng thái</label>
                <select id="xm-trangThai">
                    <option value="san_sang">Sẵn sàng</option>
                    <option value="bao_tri">Bảo trì</option>
                </select>
            </div>
            <button class="btn-submit" id="btn-xm" onclick="submitXeMay()">Thêm xe máy</button>
        </div>
    </div>

</div><!-- /content -->

<script>
let allChiNhanh = [], allMauXe = [];

// ── TABS ──
function switchTab(id, btn) {
    document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    btn.classList.add('active');
}

// ── ALERT ──
function showAlert(type, msg) {
    const el = document.getElementById('alert');
    el.className = type; el.textContent = msg; el.style.display = 'block';
    setTimeout(() => el.style.display = 'none', 3500);
}

// ── XML ──
function px(text) { return new DOMParser().parseFromString(text, 'application/xml'); }
function xt(doc, tag) { return doc.getElementsByTagName(tag)[0]?.textContent || ''; }

// ── FORMAT ──
function vnd(n) { return Number(n).toLocaleString('vi-VN') + 'đ'; }

// ── CHI NHÁNH ──
async function taiChiNhanh() {
    try {
        const res = await fetch('/api/doitac/chinhanh', { credentials: 'include' });
        if (res.status === 401 || res.status === 403) { window.location.href = 'dangnhap.jsp'; return; }
        const xml = px(await res.text());
        const items = xml.getElementsByTagName('chiNhanh');
        allChiNhanh = Array.from(items).map(i => ({
            ma: xt(i,'maChiNhanh'), ten: xt(i,'tenChiNhanh'), dia: xt(i,'diaDiem')
        }));
        document.getElementById('tbody-chinhanh').innerHTML = allChiNhanh.length
            ? allChiNhanh.map(c => `<tr><td>${c.ma}</td><td>${c.ten}</td><td>${c.dia}</td></tr>`).join('')
            : '<tr class="no-data"><td colspan="3">Chưa có chi nhánh</td></tr>';
        capNhatSelectCN();
    } catch(e) { showAlert('error','Lỗi tải chi nhánh'); }
}

function capNhatSelectCN() {
    const opts = '<option value="">-- Chọn --</option>' + allChiNhanh.map(c=>`<option value="${c.ma}">${c.ten}</option>`).join('');
    ['gt-maChiNhanh','mx-maChiNhanh','xm-maChiNhanh'].forEach(id => {
        const el = document.getElementById(id); if(el) el.innerHTML = opts;
    });
}

async function submitChiNhanh() {
    const ten = document.getElementById('cn-ten').value.trim();
    const dia = document.getElementById('cn-diaDiem').value.trim();
    if (!ten || !dia) { showAlert('error','Vui lòng điền đủ thông tin'); return; }
    const btn = document.getElementById('btn-cn');
    btn.disabled = true; btn.textContent = 'Đang lưu...';
    try {
        const res = await fetch('/api/doitac/chinhanh', { method:'POST', credentials:'include',
            body: new URLSearchParams({ tenChiNhanh: ten, diaDiem: dia }) });
        const xml = px(await res.text());
        const ok = xt(xml,'status') === 'success';
        showAlert(ok ? 'success' : 'error', xt(xml,'message'));
        if (ok) { document.getElementById('cn-ten').value=''; document.getElementById('cn-diaDiem').value=''; taiChiNhanh(); }
    } catch(e) { showAlert('error','Lỗi kết nối'); }
    finally { btn.disabled=false; btn.textContent='Thêm chi nhánh'; }
}

// ── MẪU XE ──
async function taiMauXe() {
    try {
        const res = await fetch('/api/doitac/mauxe', { credentials:'include' });
        if (res.status===401||res.status===403) { window.location.href='dangnhap.jsp'; return; }
        const xml = px(await res.text());
        const items = xml.getElementsByTagName('mauXe');
        allMauXe = Array.from(items).map(i => ({
            ma: xt(i,'maMauXe'), hang: xt(i,'hangXe'), dong: xt(i,'dongXe'),
            doi: xt(i,'doiXe'), dung: xt(i,'dungTich'), cn: xt(i,'maChiNhanh')
        }));
        document.getElementById('tbody-mauxe').innerHTML = allMauXe.length
            ? allMauXe.map(m=>`<tr><td>${m.ma}</td><td>${m.hang}</td><td>${m.dong}</td><td>${m.doi}</td><td>${m.dung}cc</td><td>${m.cn}</td></tr>`).join('')
            : '<tr class="no-data"><td colspan="6">Chưa có mẫu xe</td></tr>';
        capNhatSelectMX();
    } catch(e) { showAlert('error','Lỗi tải mẫu xe'); }
}

function capNhatSelectMX() {
    const opts = '<option value="">-- Chọn --</option>' + allMauXe.map(m=>`<option value="${m.ma}">${m.hang} ${m.dong} (${m.doi})</option>`).join('');
    ['gt-maMauXe','xm-maMauXe'].forEach(id => {
        const el = document.getElementById(id); if(el) el.innerHTML = opts;
    });
}

async function submitMauXe() {
    const hang=document.getElementById('mx-hangXe').value.trim();
    const dong=document.getElementById('mx-dongXe').value.trim();
    const doi=document.getElementById('mx-doiXe').value.trim();
    const dung=document.getElementById('mx-dungTich').value.trim();
    const cn=document.getElementById('mx-maChiNhanh').value;
    if (!hang||!dong||!doi||!dung||!cn) { showAlert('error','Vui lòng điền đủ thông tin'); return; }
    const btn=document.getElementById('btn-mx'); btn.disabled=true; btn.textContent='Đang lưu...';
    try {
        const res=await fetch('/api/doitac/mauxe',{method:'POST',credentials:'include',
            body:new URLSearchParams({maChiNhanh:cn,hangXe:hang,dongXe:dong,doiXe:doi,dungTich:dung,urlHinhAnh:document.getElementById('mx-url').value})});
        const xml=px(await res.text());
        const ok=xt(xml,'status')==='success';
        showAlert(ok?'success':'error',xt(xml,'message'));
        if(ok){['mx-hangXe','mx-dongXe','mx-doiXe','mx-dungTich','mx-url'].forEach(id=>document.getElementById(id).value='');taiMauXe();}
    }catch(e){showAlert('error','Lỗi kết nối');}
    finally{btn.disabled=false;btn.textContent='Thêm mẫu xe';}
}

// ── GÓI THUÊ ──
async function taiGoiThue() {
    try {
        const res=await fetch('/api/doitac/goithue',{credentials:'include'});
        if(res.status===401||res.status===403){window.location.href='dangnhap.jsp';return;}
        const xml=px(await res.text());
        const items=xml.getElementsByTagName('goiThue');
        const rows=Array.from(items);
        document.getElementById('tbody-goithue').innerHTML=rows.length
            ?rows.map(g=>`<tr>
                <td>${xt(g,'maGoiThue')}</td>
                <td>${xt(g,'tenGoiThue')}</td>
                <td>${xt(g,'maMauXe')}</td>
                <td>${xt(g,'maChiNhanh')}</td>
                <td>${vnd(xt(g,'giaNgay'))}</td>
                <td>${vnd(xt(g,'giaGio'))}</td>
                <td>${xt(g,'phuThu')>0?vnd(xt(g,'phuThu')):'—'}</td>
                <td>${xt(g,'giamGia')>0?xt(g,'giamGia')+'%':'—'}</td>
                <td>${xt(g,'phuKien')||'—'}</td>
            </tr>`).join('')
            :'<tr class="no-data"><td colspan="9">Chưa có gói thuê nào</td></tr>';
    }catch(e){showAlert('error','Lỗi tải gói thuê');}
}

async function submitGoiThue() {
    const mx=document.getElementById('gt-maMauXe').value;
    const cn=document.getElementById('gt-maChiNhanh').value;
    const ten=document.getElementById('gt-ten').value.trim();
    const ngay=document.getElementById('gt-giaNgay').value;
    const gio=document.getElementById('gt-giaGio').value;
    if(!mx||!cn||!ten||!ngay||!gio){showAlert('error','Vui lòng điền đủ thông tin bắt buộc');return;}
    const btn=document.getElementById('btn-gt');btn.disabled=true;btn.textContent='Đang lưu...';
    try{
        const res=await fetch('/api/doitac/goithue',{method:'POST',credentials:'include',
            body:new URLSearchParams({maMauXe:mx,maChiNhanh:cn,tenGoiThue:ten,
                phuKien:document.getElementById('gt-phuKien').value,
                giaNgay:ngay,giaGio:gio,
                phuThu:document.getElementById('gt-phuThu').value||'0',
                giamGia:document.getElementById('gt-giamGia').value||'0'})});
        const xml=px(await res.text());
        const ok=xt(xml,'status')==='success';
        showAlert(ok?'success':'error',xt(xml,'message'));
        if(ok){['gt-ten','gt-phuKien','gt-giaNgay','gt-giaGio','gt-phuThu','gt-giamGia'].forEach(id=>document.getElementById(id).value='');taiGoiThue();}
    }catch(e){showAlert('error','Lỗi kết nối');}
    finally{btn.disabled=false;btn.textContent='Thêm gói thuê';}
}

// ── XE MÁY ──
async function submitXeMay() {
    const mx=document.getElementById('xm-maMauXe').value;
    const cn=document.getElementById('xm-maChiNhanh').value;
    const bs=document.getElementById('xm-bienSo').value.trim().toUpperCase();
    const sk=document.getElementById('xm-soKhung').value.trim().toUpperCase();
    const sm=document.getElementById('xm-soMay').value.trim().toUpperCase();
    if(!mx||!cn||!bs||!sk||!sm){showAlert('error','Vui lòng điền đủ thông tin');return;}
    const btn=document.getElementById('btn-xm');btn.disabled=true;btn.textContent='Đang lưu...';
    try{
        const res=await fetch('/api/doitac/xemay',{method:'POST',credentials:'include',
            body:new URLSearchParams({maMauXe:mx,maChiNhanh:cn,bienSo:bs,soKhung:sk,soMay:sm,
                trangThai:document.getElementById('xm-trangThai').value})});
        const xml=px(await res.text());
        const ok=xt(xml,'status')==='success';
        showAlert(ok?'success':'error',xt(xml,'message'));
        if(ok){['xm-bienSo','xm-soKhung','xm-soMay'].forEach(id=>document.getElementById(id).value='');}
    }catch(e){showAlert('error','Lỗi kết nối');}
    finally{btn.disabled=false;btn.textContent='Thêm xe máy';}
}

// ── ĐĂNG XUẤT ──
function dangXuat() {
    if(confirm('Đăng xuất?')) window.location.href='dangnhap.jsp';
}

// ── INIT ──
(async()=>{ await Promise.all([taiChiNhanh(), taiMauXe()]); await taiGoiThue(); })();
</script>
</body>
</html>
