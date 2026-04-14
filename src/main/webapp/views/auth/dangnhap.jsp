<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - ThueXeMay</title>
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
            <div class="card" style="width: 100%; max-width: 450px; animation: slideUp 0.3s ease;">
                <!-- Branding Section -->
                <div style="background: linear-gradient(135deg, var(--color-primary) 0%, #047857 100%); padding: var(--spacing-lg); text-align: center; border-radius: var(--radius-lg) var(--radius-lg) 0 0; color: white;">
                    <h1 style="font-size: var(--text-lg); font-weight: 700; margin: 0;">Đăng Nhập</h1>
                    <p style="font-size: var(--text-sm); margin: var(--spacing-xs) 0 0 0; opacity: 0.9;">Truy cập tài khoản của bạn ngay</p>
                </div>

                <!-- Form Section -->
                <div class="card-body">
                    <form id="loginForm" class="form-container" style="display: flex; flex-direction: column; gap: var(--spacing-md);">
                        <!-- Username Field -->
                        <div class="form-group">
                            <label for="username" class="form-label">
                                <iconify-icon icon="mdi:account" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                Tên Đăng Nhập
                                <span style="color: var(--color-danger);">*</span>
                            </label>
                            <input id="username" 
                                   name="username" 
                                   type="text" 
                                   required
                                   class="form-input" 
                                   placeholder="Nhập tên đăng nhập"
                                   style="width: 100%; padding: var(--spacing-sm) var(--spacing-md); border: 1px solid var(--color-border-light); border-radius: var(--radius-md); font-size: var(--text-base); transition: all var(--transition-normal); box-sizing: border-box;"
                                   onfocus="this.style.borderColor='var(--color-primary)'; this.style.boxShadow='0 0 0 3px rgba(16, 185, 129, 0.1)'"
                                   onblur="this.style.borderColor='var(--color-border-light)'; this.style.boxShadow='none'">
                            <div class="form-error" style="color: var(--color-danger); font-size: var(--text-xs); margin-top: 4px;"></div>
                        </div>

                        <!-- Password Field -->
                        <div class="form-group">
                            <label for="password" class="form-label">
                                <iconify-icon icon="mdi:lock" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                                Mật Khẩu
                                <span style="color: var(--color-danger);">*</span>
                            </label>
                            <div style="position: relative; display: flex; align-items: center;">
                                <input id="password" 
                                       name="password" 
                                       type="password" 
                                       required
                                       class="form-input" 
                                       placeholder="Nhập mật khẩu"
                                       style="width: 100%; padding: var(--spacing-sm) var(--spacing-md); padding-right: 40px; border: 1px solid var(--color-border-light); border-radius: var(--radius-md); font-size: var(--text-base); transition: all var(--transition-normal); box-sizing: border-box;"
                                       onfocus="this.style.borderColor='var(--color-primary)'; this.style.boxShadow='0 0 0 3px rgba(16, 185, 129, 0.1)'"
                                       onblur="this.style.borderColor='var(--color-border-light)'; this.style.boxShadow='none'">
                                <button type="button" 
                                        id="togglePassword" 
                                        style="position: absolute; right: 10px; background: none; border: none; cursor: pointer; color: var(--color-text-secondary); padding: 4px; display: flex; align-items: center; justify-content: center; transition: color var(--transition-normal);"
                                        onmouseover="this.style.color='var(--color-primary)'"
                                        onmouseout="this.style.color='var(--color-text-secondary)'">
                                    <iconify-icon icon="mdi:eye" style="width: 20px; height: 20px;"></iconify-icon>
                                </button>
                            </div>
                            <div class="form-error" style="color: var(--color-danger); font-size: var(--text-xs); margin-top: 4px;"></div>
                        </div>

                        <!-- Remember & Forgot Password -->
                        <div style="display: flex; justify-content: space-between; align-items: center; font-size: var(--text-sm);">
                            <div style="display: flex; align-items: center; gap: var(--spacing-xs);">
                                <input id="remember" name="remember" type="checkbox"
                                       style="width: 18px; height: 18px; accent-color: var(--color-primary); cursor: pointer;">
                                <label for="remember" style="cursor: pointer; color: var(--color-text-secondary);">Ghi nhớ đăng nhập</label>
                            </div>
                            <a href="${pageContext.request.contextPath}/views/auth/forgotpassword.jsp" 
                               style="color: var(--color-primary); text-decoration: none; font-weight: 500; transition: color var(--transition-normal);"
                               onmouseover="this.style.color='#047857'"
                               onmouseout="this.style.color='var(--color-primary)'">
                                Quên mật khẩu?
                            </a>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" 
                                class="btn btn-primary" 
                                style="width: 100%; padding: var(--spacing-md); font-weight: 600; margin-top: var(--spacing-md);">
                            <iconify-icon icon="mdi:login" style="width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>
                            Đăng Nhập
                        </button>
                    </form>

                    <!-- Divider -->
                    <div style="display: flex; align-items: center; gap: var(--spacing-md); margin: var(--spacing-lg) 0; color: var(--color-text-tertiary); font-size: var(--text-sm);">
                        <div style="flex: 1; height: 1px; background-color: var(--color-border-light);"></div>
                        <span>Hoặc</span>
                        <div style="flex: 1; height: 1px; background-color: var(--color-border-light);"></div>
                    </div>

                    <!-- Sign Up Link -->
                    <div style="text-align: center; font-size: var(--text-sm); color: var(--color-text-secondary);">
                        <span>Chưa có tài khoản?</span>
                        <a href="${pageContext.request.contextPath}/dangky" 
                           style="color: var(--color-primary); text-decoration: none; font-weight: 600; margin-left: 4px; transition: color var(--transition-normal);"
                           onmouseover="this.style.color='#047857'"
                           onmouseout="this.style.color='var(--color-primary)'">
                            Đăng ký ngay
                        </a>
                    </div>
                </div>
            </div>
        </main>

        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>

    <script src="${pageContext.request.contextPath}/js/ui-utils.js"></script>
    <script>
        const ctx = '${pageContext.request.contextPath}';
        
        // Toggle password visibility
        document.getElementById('togglePassword').addEventListener('click', function(e) {
            e.preventDefault();
            const passwordInput = document.getElementById('password');
            const icon = this.querySelector('iconify-icon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.setAttribute('icon', 'mdi:eye-off');
            } else {
                passwordInput.type = 'password';
                icon.setAttribute('icon', 'mdi:eye');
            }
        });
        
        document.getElementById('loginForm').onsubmit = async function(e) {
            e.preventDefault();
            
            // Validate form
            if (!UI.validateForm('loginForm')) {
                UI.toast('Vui lòng điền đầy đủ các trường bắt buộc', 'warning', 3000);
                return;
            }
            
            const btn = e.target.querySelector('button[type="submit"]');
            const originalText = btn.innerHTML;
            btn.disabled = true;
            btn.innerHTML = '<iconify-icon icon="mdi:loading" style="animation: spin 1s linear infinite; width: 18px; height: 18px; vertical-align: middle; margin-right: 6px;"></iconify-icon>Đang xử lý...';

            try {
                const res = await fetch(ctx + '/dangnhap', {
                    method: 'POST',
                    body: new URLSearchParams(new FormData(e.target))
                });

                const xmlText = await res.text();
                const parser = new DOMParser();
                const xml = parser.parseFromString(xmlText, 'application/xml');
                
                const statusNode = xml.querySelector('status');
                const messageNode = xml.querySelector('message');

                if (!statusNode || !messageNode) {
                    UI.toast('Phản hồi từ server không hợp lệ', 'error');
                    btn.disabled = false;
                    btn.innerHTML = originalText;
                    return;
                }

                const status = statusNode.textContent;
                const message = messageNode.textContent;

                if (status === 'success') {
                    const role = xml.querySelector('role').textContent;
                    UI.toast(message, 'success', 2000);
                    
                    setTimeout(() => {
                        if (role === 'KHACH_HANG') {
                            location.href = ctx + '/khachhang/dashboard';
                        } else if (role === 'DOI_TAC') {
                            location.href = ctx + '/doitac/dashboard';
                        } else if (role === 'ADMIN') {
                            location.href = ctx + '/admin/dashboard';
                        } else {
                            location.href = ctx + '/';
                        }
                    }, 2000);
                } else {
                    UI.toast(message, 'error');
                    btn.disabled = false;
                    btn.innerHTML = originalText;
                }
            } catch (error) {
                console.error('Login error:', error);
                UI.toast('Lỗi hệ thống! Vui lòng thử lại.', 'error');
                btn.disabled = false;
                btn.innerHTML = originalText;
            }
        };
    </script>
</body>
</html>
