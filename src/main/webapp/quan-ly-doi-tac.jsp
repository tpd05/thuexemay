<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đối Tác — Thuê Xe Máy</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Mono:wght@400;500&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:       #0d0e10;
            --surface:  #15171a;
            --surface2: #1c1f23;
            --border:   #2a2d32;
            --accent:   #f5a623;
            --accent2:  #e8561a;
            --text:     #edeef0;
            --muted:    #6b7280;
            --success:  #22c55e;
            --error:    #ef4444;
            --warn:     #f59e0b;
            --radius:   10px;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ── NOISE OVERLAY ── */
        body::before {
            content: '';
            position: fixed; inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.04'/%3E%3C/svg%3E");
            pointer-events: none; z-index: 0; opacity: .6;
        }

        /* ── HEADER ── */
        header {
            position: relative; z-index: 10;
            display: flex; align-items: center; justify-content: space-between;
            padding: 18px 36px;
            border-bottom: 1px solid var(--border);
            background: rgba(13,14,16,.9);
            backdrop-filter: blur(12px);
        }
        .logo {
            font-family: 'Syne', sans-serif;
            font-weight: 800; font-size: 1.25rem;
            letter-spacing: -.02em;
            display: flex; align-items: center; gap: 10px;
        }
        .logo span { color: var(--accent); }
        .logo-badge {
            background: var(--accent2);
            color: #fff; font-size: .65rem;
            font-family: 'DM Mono', monospace;
            padding: 2px 8px; border-radius: 20px;
            letter-spacing: .08em;
        }
        .header-right {
            display: flex; align-items: center; gap: 14px;
        }
        .user-chip {
            display: flex; align-items: center; gap: 8px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 30px; padding: 6px 14px;
            font-size: .8rem;
        }
        .user-dot { width: 8px; height: 8px; border-radius: 50%; background: var(--success); }

        /* ── LAYOUT ── */
        .wrapper {
            position: relative; z-index: 1;
            max-width: 1280px; margin: 0 auto;
            padding: 32px 24px;
        }

        /* ── PAGE TITLE ── */
        .page-title {
            font-family: 'Syne', sans-serif;
            font-size: 2rem; font-weight: 800;
            letter-spacing: -.04em;
            margin-bottom: 6px;
        }
        .page-title em { font-style: normal; color: var(--accent); }
        .page-sub {
            font-size: .85rem; color: var(--muted);
            margin-bottom: 32px;
            font-family: 'DM Mono', monospace;
        }

        /* ── TABS ── */
        .tabs {
            display: flex; gap: 4px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 5px;
            margin-bottom: 28px;
            overflow-x: auto;
        }
        .tab-btn {
            flex: 1; min-width: 120px;
            padding: 9px 16px;
            background: none; border: none;
            color: var(--muted);
            font-family: 'DM Sans', sans-serif;
            font-size: .82rem; font-weight: 500;
            border-radius: 7px;
            cursor: pointer;
            transition: all .2s;
            white-space: nowrap;
            display: flex; align-items: center; gap: 7px; justify-content: center;
        }
        .tab-btn .tab-icon { font-size: 1rem; }
        .tab-btn:hover { color: var(--text); background: var(--surface2); }
        .tab-btn.active {
            background: var(--accent);
            color: #0d0e10;
            font-weight: 700;
        }
        .tab-btn .badge {
            background: rgba(0,0,0,.2);
            font-size: .68rem;
            font-family: 'DM Mono', monospace;
            padding: 1px 7px; border-radius: 20px;
            min-width: 20px; text-align: center;
        }
        .tab-btn.active .badge { background: rgba(0,0,0,.25); }

        /* ── TAB PANELS ── */
        .tab-panel { display: none; }
        .tab-panel.active { display: block; animation: fadeUp .25s ease; }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── SECTION LAYOUT ── */
        .panel-grid {
            display: grid; grid-template-columns: 1fr 380px; gap: 24px;
        }
        @media (max-width: 900px) { .panel-grid { grid-template-columns: 1fr; } }

        /* ── CARD ── */
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            overflow: hidden;
        }
        .card-header {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
        }
        .card-title {
            font-family: 'Syne', sans-serif;
            font-size: .95rem; font-weight: 700;
            letter-spacing: -.02em;
        }
        .card-count {
            font-family: 'DM Mono', monospace;
            font-size: .75rem; color: var(--muted);
        }
        .card-body { padding: 20px; }

        /* ── TABLE ── */
        .data-table {
            width: 100%; border-collapse: collapse;
            font-size: .82rem;
        }
        .data-table th {
            font-family: 'DM Mono', monospace;
            font-size: .68rem; font-weight: 500;
            letter-spacing: .08em; text-transform: uppercase;
            color: var(--muted);
            padding: 8px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }
        .data-table td {
            padding: 10px 12px;
            border-bottom: 1px solid rgba(255,255,255,.04);
            vertical-align: middle;
        }
        .data-table tr:last-child td { border-bottom: none; }
        .data-table tr:hover td { background: rgba(255,255,255,.02); }
        .data-table td.mono { font-family: 'DM Mono', monospace; font-size: .78rem; color: var(--muted); }
        .data-table td.price { font-family: 'DM Mono', monospace; color: var(--accent); font-weight: 500; }

        /* ── PILL / BADGE ── */
        .pill {
            display: inline-block;
            padding: 2px 10px; border-radius: 20px;
            font-size: .7rem; font-weight: 600;
            font-family: 'DM Mono', monospace;
        }
        .pill-green  { background: rgba(34,197,94,.12);  color: #22c55e; }
        .pill-orange { background: rgba(245,166,35,.12); color: #f5a623; }
        .pill-blue   { background: rgba(96,165,250,.12); color: #60a5fa; }
        .pill-red    { background: rgba(239,68,68,.12);  color: #ef4444; }

        /* ── EMPTY STATE ── */
        .empty-state {
            text-align: center; padding: 48px 20px;
        }
        .empty-icon { font-size: 2.5rem; margin-bottom: 10px; opacity: .5; }
        .empty-text { font-size: .85rem; color: var(--muted); }

        /* ── FORM ── */
        .form-group { margin-bottom: 16px; }
        .form-label {
            display: block;
            font-size: .75rem; font-weight: 600;
            font-family: 'DM Mono', monospace;
            letter-spacing: .06em; text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 6px;
        }
        .form-label .req { color: var(--accent2); }
        .form-control {
            width: 100%;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 7px;
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: .875rem;
            padding: 9px 13px;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
        }
        .form-control:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(245,166,35,.12);
        }
        .form-control::placeholder { color: var(--muted); opacity: .7; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .form-hint { font-size: .72rem; color: var(--muted); margin-top: 4px; }

        /* ── BUTTON ── */
        .btn {
            display: inline-flex; align-items: center; justify-content: center;
            gap: 7px;
            padding: 10px 20px;
            border: none; border-radius: 7px;
            font-family: 'DM Sans', sans-serif;
            font-size: .875rem; font-weight: 600;
            cursor: pointer;
            transition: all .2s;
        }
        .btn-primary {
            background: var(--accent);
            color: #0d0e10;
            width: 100%;
        }
        .btn-primary:hover { background: #f0b840; transform: translateY(-1px); box-shadow: 0 4px 16px rgba(245,166,35,.3); }
        .btn-primary:active { transform: translateY(0); }
        .btn-primary:disabled { opacity: .5; cursor: not-allowed; transform: none; box-shadow: none; }
        .btn-sm {
            padding: 5px 12px; font-size: .75rem;
            background: var(--surface2);
            border: 1px solid var(--border);
            color: var(--text);
        }
        .btn-sm:hover { border-color: var(--accent); color: var(--accent); }
        .btn-refresh {
            background: none; border: 1px solid var(--border);
            color: var(--muted);
            padding: 7px 14px; border-radius: 7px;
            font-size: .8rem; cursor: pointer;
            transition: all .2s;
            display: flex; align-items: center; gap: 6px;
        }
        .btn-refresh:hover { border-color: var(--accent); color: var(--accent); }

        /* ── TOAST ── */
        #toast-container {
            position: fixed; top: 20px; right: 20px;
            z-index: 9999;
            display: flex; flex-direction: column; gap: 10px;
        }
        .toast {
            min-width: 260px; max-width: 380px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 13px 16px;
            display: flex; align-items: flex-start; gap: 10px;
            box-shadow: 0 8px 32px rgba(0,0,0,.5);
            animation: slideIn .3s ease;
            cursor: pointer;
        }
        .toast.success { border-left: 3px solid var(--success); }
        .toast.error   { border-left: 3px solid var(--error); }
        .toast.warn    { border-left: 3px solid var(--warn); }
        .toast-icon { font-size: 1.1rem; margin-top: 1px; }
        .toast-text { font-size: .82rem; line-height: 1.5; }
        .toast-title { font-weight: 700; margin-bottom: 2px; font-size: .85rem; }
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(30px); }
            to   { opacity: 1; transform: translateX(0); }
        }
        @keyframes slideOut {
            from { opacity: 1; transform: translateX(0); }
            to   { opacity: 0; transform: translateX(30px); }
        }

        /* ── LOADING ── */
        .loading-row td {
            text-align: center;
            padding: 32px !important;
            color: var(--muted);
            font-size: .82rem;
        }
        .spinner {
            display: inline-block;
            width: 16px; height: 16px;
            border: 2px solid var(--border);
            border-top-color: var(--accent);
            border-radius: 50%;
            animation: spin .7s linear infinite;
            vertical-align: middle; margin-right: 8px;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        /* ── DIVIDER ── */
        .section-label {
            font-family: 'DM Mono', monospace;
            font-size: .68rem; letter-spacing: .12em;
            text-transform: uppercase; color: var(--muted);
            padding: 0 0 12px;
            border-bottom: 1px solid var(--border);
            margin-bottom: 16px;
        }

        /* ── STATS ROW ── */
        .stats-row {
            display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px;
            margin-bottom: 28px;
        }
        @media (max-width: 700px) { .stats-row { grid-template-columns: repeat(2, 1fr); } }
        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 16px 18px;
        }
        .stat-label {
            font-family: 'DM Mono', monospace;
            font-size: .68rem; letter-spacing: .08em;
            text-transform: uppercase; color: var(--muted);
            margin-bottom: 8px;
        }
        .stat-value {
            font-family: 'Syne', sans-serif;
            font-size: 1.6rem; font-weight: 800;
            letter-spacing: -.04em;
        }
        .stat-value.orange { color: var(--accent); }

        /* ── SCROLLABLE TABLE WRAPPER ── */
        .table-scroll { overflow-x: auto; }

        /* ── SEARCH BAR ── */
        .search-row {
            display: flex; gap: 10px; align-items: center;
            margin-bottom: 14px;
        }
        .search-input {
            flex: 1;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 7px;
            color: var(--text);
            font-family: 'DM Sans', sans-serif;
            font-size: .82rem;
            padding: 7px 12px;
            outline: none;
            transition: border-color .2s;
        }
        .search-input:focus { border-color: var(--accent); }
        .search-input::placeholder { color: var(--muted); opacity: .7; }
    </style>
</head>
<body>

<div id="toast-container"></div>

<!-- HEADER -->
<header>
    <div class="logo">
        🏍️ <span>XeThue</span>Pro
        <span class="logo-badge">ĐỐI TÁC</span>
    </div>
    <div class="header-right">
        <div class="user-chip">
            <div class="user-dot"></div>
            <span id="username-display">Đối tác</span>
        </div>
        <button class="btn btn-sm" onclick="dangXuat()">Đăng xuất</button>
    </div>
</header>

<div class="wrapper">
    <h1 class="page-title">Quản lý <em>đối tác</em></h1>
    <p class="page-sub">// dashboard · gói thuê · chi nhánh · mẫu xe · xe máy</p>

    <!-- STATS -->
    <div class="stats-row" id="stats-row">
        <div class="stat-card">
            <div class="stat-label">Gói Thuê</div>
            <div class="stat-value orange" id="stat-goithue">—</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Chi Nhánh</div>
            <div class="stat-value" id="stat-chinhanh">—</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Mẫu Xe</div>
            <div class="stat-value" id="stat-mauxe">—</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Xe Máy</div>
            <div class="stat-value" id="stat-xemay">—</div>
        </div>
    </div>

    <!-- TABS -->
    <div class="tabs">
        <button class="tab-btn active" onclick="switchTab('tab-goithue', this)">
            <span class="tab-icon">📋</span> Gói Thuê
            <span class="badge" id="badge-goithue">0</span>
        </button>
        <button class="tab-btn" onclick="switchTab('tab-them-goithue', this)">
            <span class="tab-icon">➕</span> Thêm Gói Thuê
        </button>
        <button class="tab-btn" onclick="switchTab('tab-chinhanh', this)">
            <span class="tab-icon">🏪</span> Chi Nhánh
            <span class="badge" id="badge-chinhanh">0</span>
        </button>
        <button class="tab-btn" onclick="switchTab('tab-mauxe', this)">
            <span class="tab-icon">🛵</span> Mẫu Xe
        </button>
        <button class="tab-btn" onclick="switchTab('tab-xemay', this)">
            <span class="tab-icon">🔑</span> Thêm Xe Máy
        </button>
    </div>

    <!-- ═══ TAB: DANH SÁCH GÓI THUÊ ═══ -->
    <div class="tab-panel active" id="tab-goithue">
        <div class="card">
            <div class="card-header">
                <span class="card-title">Danh sách gói thuê</span>
                <button class="btn-refresh" onclick="taiGoiThue()">
                    <span id="refresh-icon-goithue">↻</span> Làm mới
                </button>
            </div>
            <div class="card-body" style="padding:0">
                <div style="padding:16px 20px 0">
                    <div class="search-row">
                        <input type="text" class="search-input" id="search-goithue"
                               placeholder="Tìm theo tên, phụ kiện, hãng xe..." oninput="locGoiThue()">
                    </div>
                </div>
                <div class="table-scroll">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Tên gói</th>
                            <th>Mẫu xe</th>
                            <th>Chi nhánh</th>
                            <th>Giá ngày</th>
                            <th>Giá giờ</th>
                            <th>Phụ thu</th>
                            <th>Giảm giá</th>
                            <th>Phụ kiện</th>
                        </tr>
                        </thead>
                        <tbody id="tbody-goithue">
                        <tr class="loading-row">
                            <td colspan="9"><span class="spinner"></span> Đang tải...</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══ TAB: THÊM GÓI THUÊ ═══ -->
    <div class="tab-panel" id="tab-them-goithue">
        <div class="panel-grid">
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Tạo gói thuê mới</span>
                </div>
                <div class="card-body">
                    <div class="section-label">Thông tin cơ bản</div>
                    <form id="form-goithue" onsubmit="submitGoiThue(event)">
                        <div class="form-group">
                            <label class="form-label">Mẫu xe <span class="req">*</span></label>
                            <select class="form-control" id="gt-maMauXe" required>
                                <option value="">— Chọn mẫu xe —</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Chi nhánh <span class="req">*</span></label>
                            <select class="form-control" id="gt-maChiNhanh" required>
                                <option value="">— Chọn chi nhánh —</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Tên gói thuê <span class="req">*</span></label>
                            <input type="text" class="form-control" id="gt-tenGoiThue"
                                   placeholder="Vd: Gói thuê theo ngày Premium" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Phụ kiện</label>
                            <input type="text" class="form-control" id="gt-phuKien"
                                   placeholder="Vd: Mũ bảo hiểm, áo mưa, khóa xe...">
                        </div>
                        <div class="section-label" style="margin-top:20px">Giá &amp; ưu đãi</div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Giá ngày (VND) <span class="req">*</span></label>
                                <input type="number" class="form-control" id="gt-giaNgay"
                                       placeholder="Vd: 150000" min="0" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Giá giờ (VND) <span class="req">*</span></label>
                                <input type="number" class="form-control" id="gt-giaGio"
                                       placeholder="Vd: 20000" min="0" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Phụ thu (VND)</label>
                                <input type="number" class="form-control" id="gt-phuThu"
                                       placeholder="0" min="0" value="0">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Giảm giá (%)</label>
                                <input type="number" class="form-control" id="gt-giamGia"
                                       placeholder="0–100" min="0" max="100" value="0">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary" id="btn-submit-gt">
                            ✦ Tạo gói thuê
                        </button>
                    </form>
                </div>
            </div>

            <!-- RIGHT: hướng dẫn -->
            <div>
                <div class="card">
                    <div class="card-header"><span class="card-title">💡 Hướng dẫn</span></div>
                    <div class="card-body" style="font-size:.82rem; color:var(--muted); line-height:1.7">
                        <p>Để tạo gói thuê, bạn cần:</p>
                        <br>
                        <p>① Đã có <strong style="color:var(--text)">chi nhánh</strong> (tab Chi Nhánh)</p>
                        <br>
                        <p>② Đã thêm <strong style="color:var(--text)">mẫu xe</strong> vào chi nhánh đó (tab Mẫu Xe)</p>
                        <br>
                        <p>③ Điền đầy đủ thông tin và giá</p>
                        <br>
                        <p>④ Sau khi có gói thuê, bạn có thể thêm xe máy vật lý vào (tab Thêm Xe Máy)</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══ TAB: CHI NHÁNH ═══ -->
    <div class="tab-panel" id="tab-chinhanh">
        <div class="panel-grid">
            <!-- DANH SÁCH -->
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Chi nhánh của bạn</span>
                    <button class="btn-refresh" onclick="taiChiNhanh()">↻ Làm mới</button>
                </div>
                <div class="card-body" style="padding:0">
                    <div class="table-scroll">
                        <table class="data-table">
                            <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Tên chi nhánh</th>
                                <th>Địa điểm</th>
                            </tr>
                            </thead>
                            <tbody id="tbody-chinhanh">
                            <tr class="loading-row">
                                <td colspan="3"><span class="spinner"></span> Đang tải...</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- FORM THÊM -->
            <div class="card">
                <div class="card-header"><span class="card-title">Thêm chi nhánh mới</span></div>
                <div class="card-body">
                    <form id="form-chinhanh" onsubmit="submitChiNhanh(event)">
                        <div class="form-group">
                            <label class="form-label">Tên chi nhánh <span class="req">*</span></label>
                            <input type="text" class="form-control" id="cn-ten"
                                   placeholder="Vd: Chi nhánh Cầu Giấy" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Địa điểm <span class="req">*</span></label>
                            <input type="text" class="form-control" id="cn-diaDiem"
                                   placeholder="Vd: 123 Xuân Thủy, Cầu Giấy, Hà Nội" required>
                            <p class="form-hint">Địa chỉ đầy đủ để khách hàng dễ tìm</p>
                        </div>
                        <button type="submit" class="btn btn-primary" id="btn-submit-cn">
                            ✦ Thêm chi nhánh
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══ TAB: MẪU XE ═══ -->
    <div class="tab-panel" id="tab-mauxe">
        <div class="panel-grid">
            <!-- DANH SÁCH MẪU XE -->
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Tất cả mẫu xe</span>
                    <button class="btn-refresh" onclick="taiMauXe()">↻ Làm mới</button>
                </div>
                <div class="card-body" style="padding:0">
                    <div class="table-scroll">
                        <table class="data-table">
                            <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Hãng xe</th>
                                <th>Dòng xe</th>
                                <th>Đời xe</th>
                                <th>Dung tích</th>
                                <th>Chi nhánh</th>
                            </tr>
                            </thead>
                            <tbody id="tbody-mauxe">
                            <tr class="loading-row">
                                <td colspan="6"><span class="spinner"></span> Đang tải...</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- FORM THÊM MẪU XE -->
            <div class="card">
                <div class="card-header"><span class="card-title">Thêm mẫu xe</span></div>
                <div class="card-body">
                    <form id="form-mauxe" onsubmit="submitMauXe(event)">
                        <div class="form-group">
                            <label class="form-label">Chi nhánh <span class="req">*</span></label>
                            <select class="form-control" id="mx-maChiNhanh" required>
                                <option value="">— Chọn chi nhánh —</option>
                            </select>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Hãng xe <span class="req">*</span></label>
                                <input type="text" class="form-control" id="mx-hangXe"
                                       placeholder="Vd: Honda" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Dòng xe <span class="req">*</span></label>
                                <input type="text" class="form-control" id="mx-dongXe"
                                       placeholder="Vd: Wave Alpha" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Đời xe <span class="req">*</span></label>
                                <input type="number" class="form-control" id="mx-doiXe"
                                       placeholder="Vd: 2022" min="1900" max="2100" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Dung tích (cc) <span class="req">*</span></label>
                                <input type="number" class="form-control" id="mx-dungTich"
                                       placeholder="Vd: 110" min="0" step="0.1" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">URL hình ảnh</label>
                            <input type="url" class="form-control" id="mx-urlHinhAnh"
                                   placeholder="https://...">
                        </div>
                        <button type="submit" class="btn btn-primary" id="btn-submit-mx">
                            ✦ Thêm mẫu xe
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══ TAB: THÊM XE MÁY ═══ -->
    <div class="tab-panel" id="tab-xemay">
        <div class="panel-grid">
            <div class="card">
                <div class="card-header"><span class="card-title">Đăng ký xe máy vật lý</span></div>
                <div class="card-body">
                    <div class="section-label">Thông tin xe</div>
                    <form id="form-xemay" onsubmit="submitXeMay(event)">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Mẫu xe <span class="req">*</span></label>
                                <select class="form-control" id="xm-maMauXe" required>
                                    <option value="">— Chọn mẫu xe —</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Chi nhánh <span class="req">*</span></label>
                                <select class="form-control" id="xm-maChiNhanh" required>
                                    <option value="">— Chọn chi nhánh —</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Biển số <span class="req">*</span></label>
                            <input type="text" class="form-control" id="xm-bienSo"
                                   placeholder="Vd: 29A-12345" style="text-transform:uppercase" required>
                            <p class="form-hint">Định dạng: [2 số][1 chữ]-[4-5 số]. VD: 29A-12345</p>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Số khung <span class="req">*</span></label>
                                <input type="text" class="form-control" id="xm-soKhung"
                                       placeholder="Số khung xe" style="text-transform:uppercase" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Số máy <span class="req">*</span></label>
                                <input type="text" class="form-control" id="xm-soMay"
                                       placeholder="Số máy xe" style="text-transform:uppercase" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-control" id="xm-trangThai">
                                <option value="san_sang">Sẵn sàng</option>
                                <option value="dang_thue">Đang thuê</option>
                                <option value="bao_tri">Bảo trì</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary" id="btn-submit-xm">
                            ✦ Thêm xe máy
                        </button>
                    </form>
                </div>
            </div>

            <div>
                <div class="card">
                    <div class="card-header"><span class="card-title">📌 Lưu ý</span></div>
                    <div class="card-body" style="font-size:.82rem; color:var(--muted); line-height:1.8">
                        <p>• Biển số, số khung và số máy <strong style="color:var(--text)">phải là duy nhất</strong> trong hệ thống.</p>
                        <br>
                        <p>• Biển số định dạng Việt Nam: <code style="color:var(--accent); font-family:'DM Mono',monospace">29A-12345</code></p>
                        <br>
                        <p>• Trạng thái mặc định là <span class="pill pill-green">sẵn sàng</span> — xe có thể được đặt thuê ngay.</p>
                        <br>
                        <p>• Xe phải thuộc một <strong style="color:var(--text)">mẫu xe</strong> và <strong style="color:var(--text)">chi nhánh</strong> đã được đăng ký.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div><!-- /wrapper -->

<script>
// ═══════════════════════════════════════════
//  STATE
// ═══════════════════════════════════════════
let allGoiThue  = [];
let allChiNhanh = [];
let allMauXe    = [];

// ═══════════════════════════════════════════
//  TABS
// ═══════════════════════════════════════════
function switchTab(id, btn) {
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    btn.classList.add('active');
}

// ═══════════════════════════════════════════
//  TOAST
// ═══════════════════════════════════════════
function toast(type, title, msg) {
    const icon = { success: '✅', error: '❌', warn: '⚠️' }[type] || 'ℹ️';
    const el = document.createElement('div');
    el.className = 'toast ' + type;
    el.innerHTML = '<span class="toast-icon">' + icon + '</span>'
        + '<div class="toast-text"><div class="toast-title">' + title + '</div>'
        + (msg ? '<div>' + msg + '</div>' : '') + '</div>';
    el.onclick = () => el.remove();
    document.getElementById('toast-container').appendChild(el);
    setTimeout(() => {
        el.style.animation = 'slideOut .3s ease forwards';
        setTimeout(() => el.remove(), 300);
    }, 3500);
}

// ═══════════════════════════════════════════
//  XML HELPER
// ═══════════════════════════════════════════
function parseXml(text) {
    return new DOMParser().parseFromString(text, 'application/xml');
}
function xmlText(doc, tag) {
    const el = doc.getElementsByTagName(tag)[0];
    return el ? el.textContent : '';
}

// ═══════════════════════════════════════════
//  API CALLS
// ═══════════════════════════════════════════

// ---------- GÓI THUÊ ----------
async function taiGoiThue() {
    const icon = document.getElementById('refresh-icon-goithue');
    if (icon) icon.style.animation = 'spin .7s linear infinite';
    try {
        // Gọi search endpoint không có từ khóa hoặc dùng endpoint riêng
        // Hiện GoiThueDAO có timkiemGoiThue, dùng khoảng trắng để lấy tất cả
        const res = await fetch('/api/doitac/goithue', { credentials: 'include' });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const text = await res.text();
        const xml  = parseXml(text);
        const items = xml.getElementsByTagName('goiThue');
        allGoiThue = [];
        for (const item of items) {
            allGoiThue.push({
                maGoiThue : xmlText(item, 'maGoiThue'),
                tenGoiThue: xmlText(item, 'tenGoiThue'),
                maMauXe   : xmlText(item, 'maMauXe'),
                maChiNhanh: xmlText(item, 'maChiNhanh'),
                giaNgay   : xmlText(item, 'giaNgay'),
                giaGio    : xmlText(item, 'giaGio'),
                phuThu    : xmlText(item, 'phuThu'),
                giamGia   : xmlText(item, 'giamGia'),
                phuKien   : xmlText(item, 'phuKien'),
            });
        }
        renderGoiThue(allGoiThue);
        document.getElementById('stat-goithue').textContent = allGoiThue.length;
        document.getElementById('badge-goithue').textContent = allGoiThue.length;
    } catch (e) {
        renderEmptyGoiThue('Không thể tải dữ liệu: ' + e.message);
    } finally {
        if (icon) icon.style.animation = '';
    }
}

function renderGoiThue(list) {
    const tbody = document.getElementById('tbody-goithue');
    if (!list.length) {
        tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;padding:40px;color:var(--muted)">Chưa có gói thuê nào</td></tr>';
        return;
    }
    tbody.innerHTML = list.map(g => `
        <tr>
            <td class="mono">#${g.maGoiThue}</td>
            <td><strong>${g.tenGoiThue}</strong></td>
            <td class="mono">${g.maMauXe}</td>
            <td class="mono">${g.maChiNhanh}</td>
            <td class="price">${formatVND(g.giaNgay)}</td>
            <td class="price">${formatVND(g.giaGio)}</td>
            <td class="mono">${g.phuThu > 0 ? formatVND(g.phuThu) : '—'}</td>
            <td>${g.giamGia > 0 ? '<span class="pill pill-green">-' + g.giamGia + '%</span>' : '—'}</td>
            <td style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:var(--muted);font-size:.75rem">${g.phuKien || '—'}</td>
        </tr>`).join('');
}

function renderEmptyGoiThue(msg) {
    document.getElementById('tbody-goithue').innerHTML =
        '<tr><td colspan="9" style="text-align:center;padding:40px;color:var(--muted)">' + msg + '</td></tr>';
}

function locGoiThue() {
    const q = document.getElementById('search-goithue').value.toLowerCase();
    if (!q) { renderGoiThue(allGoiThue); return; }
    renderGoiThue(allGoiThue.filter(g =>
        g.tenGoiThue.toLowerCase().includes(q) ||
        (g.phuKien || '').toLowerCase().includes(q)
    ));
}

// ---------- CHI NHÁNH ----------
async function taiChiNhanh() {
    try {
        const res = await fetch('/api/doitac/chinhanh', { credentials: 'include' });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const text = await res.text();
        const xml  = parseXml(text);
        const items = xml.getElementsByTagName('chiNhanh');
        allChiNhanh = [];
        for (const item of items) {
            allChiNhanh.push({
                maChiNhanh : xmlText(item, 'maChiNhanh'),
                tenChiNhanh: xmlText(item, 'tenChiNhanh'),
                diaDiem    : xmlText(item, 'diaDiem'),
            });
        }
        renderChiNhanh();
        capNhatSelectChiNhanh();
        document.getElementById('stat-chinhanh').textContent = allChiNhanh.length;
        document.getElementById('badge-chinhanh').textContent = allChiNhanh.length;
    } catch (e) {
        document.getElementById('tbody-chinhanh').innerHTML =
            '<tr><td colspan="3" style="text-align:center;padding:32px;color:var(--muted)">Lỗi: ' + e.message + '</td></tr>';
    }
}

function renderChiNhanh() {
    const tbody = document.getElementById('tbody-chinhanh');
    if (!allChiNhanh.length) {
        tbody.innerHTML = '<tr><td colspan="3" style="text-align:center;padding:40px;color:var(--muted)">Chưa có chi nhánh nào</td></tr>';
        return;
    }
    tbody.innerHTML = allChiNhanh.map(cn => `
        <tr>
            <td class="mono">#${cn.maChiNhanh}</td>
            <td><strong>${cn.tenChiNhanh}</strong></td>
            <td style="color:var(--muted)">${cn.diaDiem}</td>
        </tr>`).join('');
}

function capNhatSelectChiNhanh() {
    const selects = ['gt-maChiNhanh', 'mx-maChiNhanh', 'xm-maChiNhanh'];
    selects.forEach(id => {
        const el = document.getElementById(id);
        if (!el) return;
        const val = el.value;
        el.innerHTML = '<option value="">— Chọn chi nhánh —</option>'
            + allChiNhanh.map(cn => `<option value="${cn.maChiNhanh}">${cn.tenChiNhanh}</option>`).join('');
        el.value = val;
    });
}

// ---------- MẪU XE ----------
async function taiMauXe() {
    try {
        const res = await fetch('/api/doitac/mauxe', { credentials: 'include' });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const text = await res.text();
        const xml  = parseXml(text);
        const items = xml.getElementsByTagName('mauXe');
        allMauXe = [];
        for (const item of items) {
            allMauXe.push({
                maMauXe   : xmlText(item, 'maMauXe'),
                hangXe    : xmlText(item, 'hangXe'),
                dongXe    : xmlText(item, 'dongXe'),
                doiXe     : xmlText(item, 'doiXe'),
                dungTich  : xmlText(item, 'dungTich'),
                maChiNhanh: xmlText(item, 'maChiNhanh'),
                urlHinhAnh: xmlText(item, 'urlHinhAnh'),
            });
        }
        renderMauXe();
        capNhatSelectMauXe();
        document.getElementById('stat-mauxe').textContent = allMauXe.length;
    } catch (e) {
        document.getElementById('tbody-mauxe').innerHTML =
            '<tr><td colspan="6" style="text-align:center;padding:32px;color:var(--muted)">Lỗi: ' + e.message + '</td></tr>';
    }
}

function renderMauXe() {
    const tbody = document.getElementById('tbody-mauxe');
    if (!allMauXe.length) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;padding:40px;color:var(--muted)">Chưa có mẫu xe nào</td></tr>';
        return;
    }
    tbody.innerHTML = allMauXe.map(mx => `
        <tr>
            <td class="mono">#${mx.maMauXe}</td>
            <td><strong>${mx.hangXe}</strong></td>
            <td>${mx.dongXe}</td>
            <td class="mono">${mx.doiXe}</td>
            <td class="mono">${mx.dungTich}cc</td>
            <td class="mono">#${mx.maChiNhanh}</td>
        </tr>`).join('');
}

function capNhatSelectMauXe() {
    const selects = ['gt-maMauXe', 'xm-maMauXe'];
    selects.forEach(id => {
        const el = document.getElementById(id);
        if (!el) return;
        const val = el.value;
        el.innerHTML = '<option value="">— Chọn mẫu xe —</option>'
            + allMauXe.map(mx => `<option value="${mx.maMauXe}">${mx.hangXe} ${mx.dongXe} (${mx.doiXe})</option>`).join('');
        el.value = val;
    });
}

// ═══════════════════════════════════════════
//  SUBMIT FORMS
// ═══════════════════════════════════════════

async function submitChiNhanh(e) {
    e.preventDefault();
    const btn = document.getElementById('btn-submit-cn');
    btn.disabled = true; btn.textContent = 'Đang lưu...';
    const params = new URLSearchParams({
        tenChiNhanh: document.getElementById('cn-ten').value,
        diaDiem    : document.getElementById('cn-diaDiem').value,
    });
    try {
        const res  = await fetch('/api/doitac/chinhanh', { method: 'POST', credentials: 'include', body: params });
        const text = await res.text();
        const xml  = parseXml(text);
        const msg  = xmlText(xml, 'message');
        if (res.ok && xmlText(xml, 'status') === 'success') {
            toast('success', 'Thêm thành công!', msg);
            document.getElementById('form-chinhanh').reset();
            await taiChiNhanh();
        } else {
            toast('error', 'Lỗi', msg || 'Không thể thêm chi nhánh');
        }
    } catch (err) {
        toast('error', 'Lỗi kết nối', err.message);
    } finally {
        btn.disabled = false; btn.textContent = '✦ Thêm chi nhánh';
    }
}

async function submitMauXe(e) {
    e.preventDefault();
    const btn = document.getElementById('btn-submit-mx');
    btn.disabled = true; btn.textContent = 'Đang lưu...';
    const params = new URLSearchParams({
        maChiNhanh: document.getElementById('mx-maChiNhanh').value,
        hangXe    : document.getElementById('mx-hangXe').value,
        dongXe    : document.getElementById('mx-dongXe').value,
        doiXe     : document.getElementById('mx-doiXe').value,
        dungTich  : document.getElementById('mx-dungTich').value,
        urlHinhAnh: document.getElementById('mx-urlHinhAnh').value,
    });
    try {
        const res  = await fetch('/api/doitac/mauxe', { method: 'POST', credentials: 'include', body: params });
        const text = await res.text();
        const xml  = parseXml(text);
        const msg  = xmlText(xml, 'message');
        if (res.ok && xmlText(xml, 'status') === 'success') {
            toast('success', 'Thêm thành công!', msg);
            document.getElementById('form-mauxe').reset();
            await taiMauXe();
        } else {
            toast('error', 'Lỗi', msg || 'Không thể thêm mẫu xe');
        }
    } catch (err) {
        toast('error', 'Lỗi kết nối', err.message);
    } finally {
        btn.disabled = false; btn.textContent = '✦ Thêm mẫu xe';
    }
}

async function submitGoiThue(e) {
    e.preventDefault();
    const btn = document.getElementById('btn-submit-gt');
    btn.disabled = true; btn.textContent = 'Đang lưu...';
    const params = new URLSearchParams({
        maMauXe   : document.getElementById('gt-maMauXe').value,
        maChiNhanh: document.getElementById('gt-maChiNhanh').value,
        tenGoiThue: document.getElementById('gt-tenGoiThue').value,
        phuKien   : document.getElementById('gt-phuKien').value,
        giaNgay   : document.getElementById('gt-giaNgay').value,
        giaGio    : document.getElementById('gt-giaGio').value,
        phuThu    : document.getElementById('gt-phuThu').value,
        giamGia   : document.getElementById('gt-giamGia').value,
    });
    try {
        const res  = await fetch('/api/doitac/goithue', { method: 'POST', credentials: 'include', body: params });
        const text = await res.text();
        const xml  = parseXml(text);
        const msg  = xmlText(xml, 'message');
        if (res.ok && xmlText(xml, 'status') === 'success') {
            toast('success', 'Tạo thành công!', msg);
            document.getElementById('form-goithue').reset();
            await taiGoiThue();
        } else {
            toast('error', 'Lỗi', msg || 'Không thể tạo gói thuê');
        }
    } catch (err) {
        toast('error', 'Lỗi kết nối', err.message);
    } finally {
        btn.disabled = false; btn.textContent = '✦ Tạo gói thuê';
    }
}

async function submitXeMay(e) {
    e.preventDefault();
    const btn = document.getElementById('btn-submit-xm');
    btn.disabled = true; btn.textContent = 'Đang lưu...';
    const bienSo = document.getElementById('xm-bienSo').value.toUpperCase();
    const params = new URLSearchParams({
        maMauXe   : document.getElementById('xm-maMauXe').value,
        maChiNhanh: document.getElementById('xm-maChiNhanh').value,
        bienSo    : bienSo,
        soKhung   : document.getElementById('xm-soKhung').value.toUpperCase(),
        soMay     : document.getElementById('xm-soMay').value.toUpperCase(),
        trangThai : document.getElementById('xm-trangThai').value,
    });
    try {
        const res  = await fetch('/api/doitac/xemay', { method: 'POST', credentials: 'include', body: params });
        const text = await res.text();
        const xml  = parseXml(text);
        const msg  = xmlText(xml, 'message');
        if (res.ok && xmlText(xml, 'status') === 'success') {
            toast('success', 'Thêm xe thành công!', msg);
            document.getElementById('form-xemay').reset();
            document.getElementById('stat-xemay').textContent =
                (parseInt(document.getElementById('stat-xemay').textContent || '0') + 1) + '';
        } else {
            toast('error', 'Lỗi', msg || 'Không thể thêm xe máy');
        }
    } catch (err) {
        toast('error', 'Lỗi kết nối', err.message);
    } finally {
        btn.disabled = false; btn.textContent = '✦ Thêm xe máy';
    }
}

// ═══════════════════════════════════════════
//  HELPERS
// ═══════════════════════════════════════════
function formatVND(num) {
    const n = parseFloat(num);
    if (isNaN(n)) return '—';
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(n);
}

function dangXuat() {
    if (confirm('Bạn có chắc muốn đăng xuất?')) {
        window.location.href = '/api/xacthuc/dangnhap';
    }
}

// ═══════════════════════════════════════════
//  INIT
// ═══════════════════════════════════════════
(async function init() {
    await Promise.all([taiChiNhanh(), taiMauXe()]);
    await taiGoiThue();

    // Thêm GET endpoint cho gói thuê nếu backend chưa có,
    // fallback: hiển thị bảng trống với hướng dẫn
})();
</script>

</body>
</html>
