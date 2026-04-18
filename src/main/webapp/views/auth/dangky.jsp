<%@ page contentType="text/html;charset=UTF-8"%>
<%
String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký ThueXeMay</title>
    <link href="${pageContext.request.contextPath}/dist/tailwind.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/globals.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/components.css" rel="stylesheet">
    <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
</head>
<body class="bg-color-bg-primary text-color-text-primary font-body" style="min-height: 100vh; display: flex; flex-direction: column;">
    <div class="page-wrapper" style="display: flex; flex-direction: column;">
        <header class="page-header">
            <jsp:include page="/components/navbar.jsp" />
        </header>

        <main class="page-main" style="flex: 1; display: flex; align-items: center; justify-content: center; padding: var(--spacing-lg);">
            <div class="card" style="width: 100%; max-width: 600px; animation: slideUp 0.3s ease;">
                <!-- Branding -->
                <div style="background: linear-gradient(135deg, var(--color-primary) 0%, #047857 100%); padding: var(--spacing-lg); text-align: center; border-radius: var(--radius-lg) var(--radius-lg) 0 0; color: white;">
                    <h1 style="font-size: var(--text-lg); font-weight: 700; margin: 0;">Đăng Ký ThueXeMay</h1>
                    <p style="font-size: var(--text-sm); margin: var(--spacing-xs) 0 0 0; opacity: 0.9;">Tạo tài khoản miễn phí ngay hôm nay</p>
                </div>

                <div class="card-body">
                    <form id="f" style="display: flex; flex-direction: column; gap: var(--spacing-md);">
                        
                        <!-- Role Selection -->
                        <div class="form-group">
                            <label for="roleSelect" class="form-label">
                                <iconify-icon icon="mdi:briefcase" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                Chọn Loại Tài Khoản
                                <span style="color: var(--color-danger);">*</span>
                            </label>
                            <select name="role" id="roleSelect"
                                    style="width: 100%; padding: var(--spacing-sm) var(--spacing-md); border: 1px solid var(--color-border-light); border-radius: var(--radius-md); font-size: var(--text-base); background-color: white; cursor: pointer; transition: all var(--transition-normal);"
                                    onfocus="this.style.borderColor='var(--color-primary)'"
                                    onblur="this.style.borderColor='var(--color-border-light)'">
                                <option value="KHACH_HANG" selected>👤 Khách Hàng</option>
                                <option value="DOI_TAC">🏢 Đối Tác (Chủ Cửa Hàng)</option>
                            </select>
                        </div>

                        <!-- Basic Info -->
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md);">
                            <div class="form-group">
                                <label for="username" class="form-label">
                                    <iconify-icon icon="mdi:account" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                    Tên Đăng Nhập
                                    <span style="color: var(--color-danger);">*</span>
                                </label>
                                <input name="username" required class="form-input" 
                                       style="width: 100%; padding: var(--spacing-sm) var(--spacing-md); border: 1px solid var(--color-border-light); border-radius: var(--radius-md); font-size: var(--text-base); transition: all var(--transition-normal); box-sizing: border-box;"
                                       placeholder="Tên đăng nhập"
                                       onfocus="this.style.borderColor='var(--color-primary)'; this.style.boxShadow='0 0 0 3px rgba(16, 185, 129, 0.1)'"
                                       onblur="this.style.borderColor='var(--color-border-light)'; this.style.boxShadow='none'">
                                <div class="form-error" style="color: var(--color-danger); font-size: var(--text-xs); margin-top: 4px;"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="password" class="form-label">
                                    <iconify-icon icon="mdi:lock" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                    Mật Khẩu
                                    <span style="color: var(--color-danger);">*</span>
                                </label>
                                <div style="position: relative; display: flex; align-items: center;">
                                    <input id="password" name="password" type="password" required class="form-input"
                                           style="width: 100%; padding: var(--spacing-sm) var(--spacing-md); padding-right: 40px; border: 1px solid var(--color-border-light); border-radius: var(--radius-md); font-size: var(--text-base); transition: all var(--transition-normal); box-sizing: border-box;"
                                           placeholder="Mật khẩu"
                                           onfocus="this.style.borderColor='var(--color-primary)'; this.style.boxShadow='0 0 0 3px rgba(16, 185, 129, 0.1)'"
                                           onblur="this.style.borderColor='var(--color-border-light)'; this.style.boxShadow='none'">
                                    <button type="button" 
                                            class="togglePassword" 
                                            style="position: absolute; right: 10px; background: none; border: none; cursor: pointer; color: var(--color-text-secondary); padding: 4px; display: flex; align-items: center; justify-content: center; transition: color var(--transition-normal);"
                                            onmouseover="this.style.color='var(--color-primary)'"
                                            onmouseout="this.style.color='var(--color-text-secondary)'">
                                        <iconify-icon icon="mdi:eye" style="width: 20px; height: 20px;"></iconify-icon>
                                    </button>
                                </div>
                                <div class="form-error" style="color: var(--color-danger); font-size: var(--text-xs); margin-top: 4px;"></div>
                            </div>
                        </div>

                        <!-- Contact Info -->
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md);">
                            <div class="form-group">
                                <label class="form-label">
                                    <iconify-icon icon="mdi:person" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                    Họ Tên
                                    <span style="color: var(--color-danger);">*</span>
                                </label>
                                <input name="hoTen" required class="form-input"
                                       style="width: 100%; padding: var(--spacing-sm) var(--spacing-md); border: 1px solid var(--color-border-light); border-radius: var(--radius-md); font-size: var(--text-base); transition: all var(--transition-normal); box-sizing: border-box;"
                                       placeholder="Họ và tên"
                                       onfocus="this.style.borderColor='var(--color-primary)'; this.style.boxShadow='0 0 0 3px rgba(16, 185, 129, 0.1)'"
                                       onblur="this.style.borderColor='var(--color-border-light)'; this.style.boxShadow='none'">
                                <div class="form-error" style="color: var(--color-danger); font-size: var(--text-xs); margin-top: 4px;"></div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <iconify-icon icon="mdi:phone" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                    Số Điện Thoại
                                    <span style="color: var(--color-danger);">*</span>
                                </label>
                                <input name="soDienThoai" required class="form-input"
                                       style="width: 100%; padding: var(--spacing-sm) var(--spacing-md); border: 1px solid var(--color-border-light); border-radius: var(--radius-md); font-size: var(--text-base); transition: all var(--transition-normal); box-sizing: border-box;"
                                       placeholder="0912345678"
                                       onfocus="this.style.borderColor='var(--color-primary)'; this.style.boxShadow='0 0 0 3px rgba(16, 185, 129, 0.1)'"
                                       onblur="this.style.borderColor='var(--color-border-light)'; this.style.boxShadow='none'">
                                <div class="form-error" style="color: var(--color-danger); font-size: var(--text-xs); margin-top: 4px;"></div>
                            </div>
                        </div>

                        <!-- Email & ID -->
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--spacing-md);">
                            <div class="form-group">
                                <label class="form-label">
                                    <iconify-icon icon="mdi:email" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                    Email
                                    <span style="color: var(--color-danger);">*</span>
                                </label>
                                <input name="email" type="email" required class="form-input"
                                       style="width: 100%; padding: var(--spacing-sm) var(--spacing-md); border: 1px solid var(--color-border-light); border-radius: var(--radius-md); font-size: var(--text-base); transition: all var(--transition-normal); box-sizing: border-box;"
                                       placeholder="email@example.com"
                                       onfocus="this.style.borderColor='var(--color-primary)'; this.style.boxShadow='0 0 0 3px rgba(16, 185, 129, 0.1)'"
                                       onblur="this.style.borderColor='var(--color-border-light)'; this.style.boxShadow='none'">
                                <div class="form-error" style="color: var(--color-danger); font-size: var(--text-xs); margin-top: 4px;"></div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <iconify-icon icon="mdi:card-account-details" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                    Số CCCD
                                    <span style="color: var(--color-danger);">*</span>
                                </label>
                                <input name="soCCCD" required class="form-input"
                                       style="width: 100%; padding: var(--spacing-sm) var(--spacing-md); border: 1px solid var(--color-border-light); border-radius: var(--radius-md); font-size: var(--text-base); transition: all var(--transition-normal); box-sizing: border-box;"
                                       placeholder="123456789"
                                       onfocus="this.style.borderColor='var(--color-primary)'; this.style.boxShadow='0 0 0 3px rgba(16, 185, 129, 0.1)'"
                                       onblur="this.style.borderColor='var(--color-border-light)'; this.style.boxShadow='none'">
                                <div class="form-error" style="color: var(--color-danger); font-size: var(--text-xs); margin-top: 4px;"></div>
                            </div>
                        </div>

                        <!-- Message -->
                        <p id="msg" style="text-align: center; font-weight: 600; margin: 0; padding: var(--spacing-md); border-radius: var(--radius-md); display: none;"></p>

                        <!-- Submit -->
                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: var(--spacing-md); font-weight: 600; margin-top: var(--spacing-md);">
                            <iconify-icon icon="mdi:account-plus" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                            Tạo Tài Khoản
                        </button>

                        <!-- Sign In Link -->
                        <div style="text-align: center; font-size: var(--text-sm); color: var(--color-text-secondary);">
                            <span>Đã có tài khoản?</span>
                            <a href="<%=ctxPath%>/dangnhap" 
                               style="color: var(--color-primary); text-decoration: none; font-weight: 600; margin-left: 4px; transition: color var(--transition-normal);"
                               onmouseover="this.style.color='#047857'"
                               onmouseout="this.style.color='var(--color-primary)'">
                                Đăng nhập
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>

    <script src="${pageContext.request.contextPath}/js/ui-utils.js"></script>
    <script>
        const ctx = '<%=ctxPath%>';

        // Toggle password visibility
        document.querySelectorAll('.togglePassword').forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                const passwordInput = this.closest('div').querySelector('input[type="password"], input[type="text"]');
                const icon = this.querySelector('iconify-icon');
                
                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    icon.setAttribute('icon', 'mdi:eye-off');
                } else {
                    passwordInput.type = 'password';
                    icon.setAttribute('icon', 'mdi:eye');
                }
            });
        });

        document.getElementById('f').onsubmit = async function(e) {
            e.preventDefault();

            if (!UI.validateForm('f')) {
                UI.toast('Vui lòng điền đầy đủ các trường bắt buộc', 'warning');
                return;
            }

            const btn = e.target.querySelector('button[type="submit"]');
            const originalHTML = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<iconify-icon icon="mdi:loading" style="animation: spin 1s linear infinite; width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>Đang xử lý...';

            try {
                const res = await fetch(ctx + '/dangky', {
                    method: 'POST',
                    body: new URLSearchParams(new FormData(e.target))
                });

                const xml = new DOMParser().parseFromString(await res.text(), 'application/xml');
                const status = xml.querySelector('status').textContent;
                const msg = xml.querySelector('message').textContent;

                const msgEl = document.getElementById('msg');
                msgEl.textContent = msg;
                msgEl.style.display = 'block';

                if (status === 'success') {
                    msgEl.style.backgroundColor = 'rgba(16, 185, 129, 0.1)';
                    msgEl.style.color = 'var(--color-success)';
                    UI.toast(msg, 'success', 2000);
                    setTimeout(() => location.href = ctx + '/dangnhap', 2000);
                } else {
                    msgEl.style.backgroundColor = 'rgba(239, 68, 68, 0.1)';
                    msgEl.style.color = 'var(--color-danger)';
                    UI.toast(msg, 'error');
                    btn.disabled = false;
                    btn.innerHTML = originalHTML;
                }
            } catch (err) {
                UI.toast('Lỗi hệ thống, vui lòng thử lại', 'error');
                btn.disabled = false;
                btn.innerHTML = originalHTML;
            }
        };
    </script>
</body>
</html>
