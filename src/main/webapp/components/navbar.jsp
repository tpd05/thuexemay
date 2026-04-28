<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    @media (max-width: 767px) {
        .navbar-menu-desktop { display: none !important; }
        #mobileMenuToggle { display: flex !important; }
    }
    @media (min-width: 768px) {
        .navbar-menu-desktop { display: flex !important; }
        #mobileMenuToggle { display: none !important; }
        #mobileMenu { display: none !important; }
    }
</style>

<nav class="navbar" style="background-color: var(--color-bg-primary); border-bottom: 2px solid var(--color-primary); box-shadow: var(--shadow-md); position: sticky; top: 0; z-index: 100;">
    <div class="app-container" style="display: flex; align-items: center; justify-content: space-between; padding: var(--spacing-md);">
        
        <!-- Logo/Brand -->
        <div class="navbar-brand" style="font-weight: 600; font-size: var(--text-lg);">
            <a href="${pageContext.request.contextPath}/" 
               style="color: var(--color-primary); text-decoration: none; display: flex; align-items: center; gap: var(--spacing-xs);">
                <span>MOTOBOOK</span>
            </a>
        </div>

        <!-- Desktop Navigation -->
        <div class="navbar-menu navbar-menu-desktop" style="display: none; flex-direction: row; gap: var(--spacing-lg); align-items: center;">
            
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <!-- Guest Links -->
                    <a href="${pageContext.request.contextPath}/" 
                       class="nav-link"
                       style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer;">
                        <iconify-icon icon="mdi:home" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                        Trang Chủ
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/khachhang/danhsachgoithue" 
                       class="nav-link"
                       style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer;">
                        <iconify-icon icon="mdi:package-variant" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                        Gói Thuê
                    </a>
                </c:when>
            </c:choose>

            <!-- Conditional Links by Role -->
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <c:choose>
                        <c:when test="${sessionScope.role == 'KHACH_HANG'}">
                            <div style="display: flex; align-items: center; min-width: 250px; background-color: var(--color-bg-secondary); border-radius: var(--radius-md); padding: var(--spacing-xs) var(--spacing-md); opacity: 0.6; cursor: not-allowed;" title="Tính năng đang phát triển">
                                <iconify-icon icon="mdi:magnify" style="width: 20px; height: 20px; margin-right: 8px; color: #999;"></iconify-icon>
                                <input type="text" 
                                       placeholder="Tìm kiếm xe..."
                                       disabled
                                       style="flex: 1; background: none; border: none; outline: none; color: #999; font-size: var(--text-base); padding: var(--spacing-xs) 0;" />
                            </div>

                            <a href="${pageContext.request.contextPath}/khachhang/dashboard" 
                               class="nav-link"
                               style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer;">
                                <iconify-icon icon="mdi:home" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                                Trang Chủ
                            </a>

                            <a href="${pageContext.request.contextPath}/khachhang/giohang" 
                               class="nav-link"
                               style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer;">
                                <iconify-icon icon="mdi:shopping-cart" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                                Giỏ hàng
                            </a>

                            <!-- Lịch sử thuê xe with submenu -->
                            <div style="position: relative; display: flex; align-items: center;">
                                <button class="nav-link" 
                                        style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer; background: none; border: none; gap: 4px;"
                                        onmouseover="document.getElementById('lichsuSubmenu').style.display = 'block'"
                                        onmouseout="document.getElementById('lichsuSubmenu').style.display = 'none'">
                                    <iconify-icon icon="mdi:history" style="width: 20px; height: 20px;"></iconify-icon>
                                    Lịch sử thuê xe
                                    <iconify-icon icon="mdi:chevron-down" style="width: 16px; height: 16px;"></iconify-icon>
                                </button>
                                
                                <div id="lichsuSubmenu" 
                                     style="display: none; position: absolute; top: 100%; left: 0; background-color: var(--color-bg-primary); border: 1px solid var(--color-border-light); border-radius: var(--radius-md); box-shadow: var(--shadow-md); min-width: 250px; z-index: 1000;"
                                     onmouseover="this.style.display = 'block'"
                                     onmouseout="this.style.display = 'none'">
                                    <a href="${pageContext.request.contextPath}/khachhang/lichsuthuexe/xedathue"
                                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light); transition: all var(--transition-normal);"
                                       onmouseover="this.style.backgroundColor='var(--color-bg-secondary)'; this.style.color='var(--color-primary)'"
                                       onmouseout="this.style.backgroundColor='transparent'; this.style.color='var(--color-text-secondary)'">
                                        <iconify-icon icon="mdi:check-circle" style="width: 18px; height: 18px; margin-right: 8px;"></iconify-icon>
                                        Xe đã thuê
                                    </a>
                                    <a href="${pageContext.request.contextPath}/khachhang/lichsuthuexe/xedangthue"
                                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light); transition: all var(--transition-normal);"
                                       onmouseover="this.style.backgroundColor='var(--color-bg-secondary)'; this.style.color='var(--color-primary)'"
                                       onmouseout="this.style.backgroundColor='transparent'; this.style.color='var(--color-text-secondary)'">
                                        <iconify-icon icon="mdi:motorcycle" style="width: 18px; height: 18px; margin-right: 8px;"></iconify-icon>
                                        Xe đang thuê
                                    </a>
                                    <a href="#"
                                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; cursor: not-allowed; opacity: 0.6;"
                                       title="Tính năng đang phát triển">
                                        <iconify-icon icon="mdi:star" style="width: 18px; height: 18px; margin-right: 8px;"></iconify-icon>
                                        Đánh giá trải nghiệm
                                    </a>
                                </div>
                            </div>

                            <a href="#" 
                               class="nav-link"
                               disabled
                               style="display: flex; align-items: center; color: #999; text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: not-allowed; opacity: 0.6;"
                               title="Tính năng đang phát triển">
                                <iconify-icon icon="mdi:file-document" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                                Hồ sơ
                            </a>


                        </c:when>

                        <c:when test="${sessionScope.role == 'DOI_TAC'}">
                            <a href="${pageContext.request.contextPath}/doitac/dashboard" 
                               class="nav-link"
                               style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer;">
                                <iconify-icon icon="mdi:home" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                                Trang Chủ
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/doitac/quanlychinhanh" 
                               class="nav-link"
                               style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer;">
                                <iconify-icon icon="mdi:store" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                                Quản lý chi nhánh
                            </a>
                            
                            <!-- Quản lý xe máy with submenu -->
                            <div style="display: flex; align-items: center; gap: 8px;">
    
    <!-- Nút Quản lý mẫu xe -->
    <a href="${pageContext.request.contextPath}/doitac/quanlymauxe"
       class="nav-link"
       style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); gap: 4px;">
        <iconify-icon icon="mdi:format-list-bulleted" style="width: 20px; height: 20px;"></iconify-icon>
        Quản lý mẫu xe
    </a>

    <!-- Nút Quản lý xe máy -->
    <a href="${pageContext.request.contextPath}/doitac/quanlyxemay"
       class="nav-link"
       style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); gap: 4px;">
        <iconify-icon icon="mdi:motorcycle" style="width: 20px; height: 20px;"></iconify-icon>
        Quản lý xe máy
    </a>

</div>
                            
                            <a href="${pageContext.request.contextPath}/doitac/quanlygoithue" 
                               class="nav-link"
                               style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer;">
                                <iconify-icon icon="mdi:package-variant" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                                Quản lý gói thuê
                            </a>

                            <div style="position: relative; display: flex; align-items: center;">
                                <button class="nav-link" 
                                        style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer; background: none; border: none;"
                                        onmouseover="document.getElementById('doitacDropdown').style.display = 'block'"
                                        onmouseout="document.getElementById('doitacDropdown').style.display = 'none'">
                                    <iconify-icon icon="mdi:menu" style="width: 20px; height: 20px;"></iconify-icon>
                                </button>
                                
                                <div id="doitacDropdown" 
                                     style="display: none; position: absolute; top: 100%; right: 0; background-color: var(--color-bg-primary); border: 1px solid var(--color-border-light); border-radius: var(--radius-md); box-shadow: var(--shadow-md); min-width: 250px; z-index: 1000;"
                                     onmouseover="this.style.display = 'block'"
                                     onmouseout="this.style.display = 'none'">
                                    <div style="display: flex; align-items: center; padding: var(--spacing-md); color: #999; border-bottom: 1px solid var(--color-border-light); opacity: 0.6; cursor: not-allowed;" title="Tính năng đang phát triển">
                                        <iconify-icon icon="mdi:file-document" style="width: 18px; height: 18px; margin-right: 8px;"></iconify-icon>
                                        Hồ sơ
                                    </div>
                                    <a href="#"
                                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light); transition: all var(--transition-normal); cursor: not-allowed; opacity: 0.6;"
                                       title="Tính năng đang phát triển">
                                        <iconify-icon icon="mdi:briefcase" style="width: 18px; height: 18px; margin-right: 8px;"></iconify-icon>
                                        Quản lý đơn thuê
                                    </a>
                                    <button onclick="confirmLogout()"
                                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; transition: all var(--transition-normal); background: none; border: none; cursor: pointer; width: 100%; text-align: left;"
                                       onmouseover="this.style.backgroundColor='var(--color-bg-secondary)'; this.style.color='var(--color-primary)'"
                                       onmouseout="this.style.backgroundColor='transparent'; this.style.color='var(--color-text-secondary)'">
                                        <iconify-icon icon="mdi:logout" style="width: 18px; height: 18px; margin-right: 8px;"></iconify-icon>
                                        Đăng Xuất
                                    </button>
                                </div>
                            </div>
                        </c:when>

                        <c:when test="${sessionScope.role == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" 
                               class="nav-link"
                               style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer;">
                                <iconify-icon icon="mdi:shield-admin" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                                Dashboard Admin
                            </a>
                        </c:when>
                    </c:choose>
                    
                    <!-- Logout Button -->
                    <c:if test="${sessionScope.role != 'DOI_TAC'}">
                        <div style="display: flex; align-items: center; gap: var(--spacing-lg);">
                            <button onclick="confirmLogout()" 
                               style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer; background: none; border: none;"
                               onmouseover="this.style.color='var(--color-primary)'"
                               onmouseout="this.style.color='var(--color-text-secondary)'">
                                <iconify-icon icon="mdi:logout" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                                Đăng Xuất
                            </button>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <!-- Guest User - Auth Links -->
                    <a href="${pageContext.request.contextPath}/dangnhap" 
                       class="nav-link"
                       style="display: flex; align-items: center; color: var(--color-text-secondary); text-decoration: none; padding: var(--spacing-sm) var(--spacing-md); border-radius: var(--radius-md); transition: all var(--transition-normal); cursor: pointer;">
                        <iconify-icon icon="mdi:login" style="width: 20px; height: 20px; margin-right: 4px;"></iconify-icon>
                        Đăng Nhập
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/dangky" 
                       class="btn btn-primary" 
                       style="display: inline-flex; align-items: center; gap: var(--spacing-xs);">
                        <iconify-icon icon="mdi:account-plus" style="width: 18px; height: 18px;"></iconify-icon>
                        Đăng Ký
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Mobile Menu Toggle Button -->
        <button id="mobileMenuToggle" 
                class="btn btn-ghost" 
                style="display: none; align-items: center; gap: var(--spacing-xs); padding: var(--spacing-xs) var(--spacing-sm);">
            <iconify-icon icon="mdi:menu" style="width: 24px; height: 24px;"></iconify-icon>
        </button>
    </div>

    <!-- Mobile Dropdown Menu -->
    <div id="mobileMenu" 
         class="navbar-mobile-menu" 
         style="display: none; padding: var(--spacing-md); border-top: 1px solid var(--color-border-light); max-height: 0; overflow: hidden; transition: all var(--transition-normal);">
        
        <c:choose>
            <c:when test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/" 
                   class="mobile-nav-link"
                   style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                    <iconify-icon icon="mdi:home" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                    Trang Chủ
                </a>
                
                <a href="${pageContext.request.contextPath}/khachhang/danhsachgoithue" 
                   class="mobile-nav-link"
                   style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                    <iconify-icon icon="mdi:package-variant" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                    Gói Thuê
                </a>
            </c:when>
        </c:choose>

        <!-- Mobile Conditional Links -->
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <!-- Mobile KHACH_HANG Menu -->
                <c:if test="${sessionScope.role == 'KHACH_HANG'}">
                    <div style="display: flex; align-items: center; padding: var(--spacing-md); border-bottom: 1px solid var(--color-border-light); background-color: var(--color-bg-secondary); opacity: 0.6; cursor: not-allowed;" title="Tính năng đang phát triển">
                        <iconify-icon icon="mdi:magnify" style="width: 20px; height: 20px; margin-right: 8px; color: #999;"></iconify-icon>
                        <input type="text" 
                               placeholder="Tìm kiếm xe..."
                               disabled
                               style="flex: 1; background: none; border: none; outline: none; color: #999; font-size: var(--text-base);" />
                    </div>

                    <a href="${pageContext.request.contextPath}/khachhang/dashboard" 
                       class="mobile-nav-link"
                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                        <iconify-icon icon="mdi:home" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Trang Chủ
                    </a>

                    <div style="display: flex; align-items: center; border-bottom: 1px solid var(--color-border-light);">
                        <button id="mobileSubmenuToggle" 
                                style="display: flex; align-items: center; width: 100%; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; background: none; border: none; cursor: pointer; gap: 8px; transition: all var(--transition-normal);"
                                onmouseover="this.style.color='var(--color-primary)'"
                                onmouseout="this.style.color='var(--color-text-secondary)'">
                            <iconify-icon icon="mdi:history" style="width: 20px; height: 20px;"></iconify-icon>
                            Lịch sử thuê xe
                            <iconify-icon id="submenuChevron" icon="mdi:chevron-down" style="width: 16px; height: 16px; margin-left: auto;"></iconify-icon>
                        </button>
                    </div>

                    <div id="mobileSubmenu" 
                         style="display: none; padding-left: var(--spacing-lg);">
                        <a href="${pageContext.request.contextPath}/khachhang/lichsuthuexe/xedathue"
                           class="mobile-nav-link"
                           style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                            <iconify-icon icon="mdi:check-circle" style="width: 18px; height: 18px; margin-right: 8px;"></iconify-icon>
                            Xe đã thuê
                        </a>
                        <a href="${pageContext.request.contextPath}/khachhang/lichsuthuexe/xedangthue"
                           class="mobile-nav-link"
                           style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                            <iconify-icon icon="mdi:motorcycle" style="width: 18px; height: 18px; margin-right: 8px;"></iconify-icon>
                            Xe đang thuê
                        </a>
                        <div style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); opacity: 0.6; cursor: not-allowed;">
                            <iconify-icon icon="mdi:star" style="width: 18px; height: 18px; margin-right: 8px;"></iconify-icon>
                            Đánh giá trải nghiệm
                        </div>
                    </div>

                    <div style="display: flex; align-items: center; padding: var(--spacing-md); color: #999; border-bottom: 1px solid var(--color-border-light); opacity: 0.6; cursor: not-allowed;" title="Tính năng đang phát triển">
                        <iconify-icon icon="mdi:file-document" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Hồ sơ
                    </div>

                    <a href="${pageContext.request.contextPath}/khachhang/giohang" 
                       class="mobile-nav-link"
                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                        <iconify-icon icon="mdi:shopping-cart" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Giỏ hàng
                    </a>
                </c:if>

                <!-- Mobile DOI_TAC Menu -->
                <c:if test="${sessionScope.role == 'DOI_TAC'}">
                    <a href="${pageContext.request.contextPath}/doitac/dashboard" 
                       class="mobile-nav-link"
                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                        <iconify-icon icon="mdi:home" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Trang Chủ
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/doitac/quanlychinhanh" 
                       class="mobile-nav-link"
                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                        <iconify-icon icon="mdi:store" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Quản lý chi nhánh
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/doitac/quanlymauxe" 
                       class="mobile-nav-link"
                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                        <iconify-icon icon="mdi:format-list-bulleted" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Quản lý mẫu xe
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/doitac/quanlyxemay" 
                       class="mobile-nav-link"
                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                        <iconify-icon icon="mdi:motorcycle" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Quản lý xe máy
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/doitac/quanlygoithue" 
                       class="mobile-nav-link"
                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                        <iconify-icon icon="mdi:package-variant" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Quản lý gói thuê
                    </a>

                    <div style="display: flex; align-items: center; padding: var(--spacing-md); color: #999; border-bottom: 1px solid var(--color-border-light); opacity: 0.6; cursor: not-allowed;" title="Tính năng đang phát triển">
                        <iconify-icon icon="mdi:file-document" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Hồ sơ
                    </div>
                    
                    <div style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); opacity: 0.6; cursor: not-allowed; border-bottom: 1px solid var(--color-border-light);">
                        <iconify-icon icon="mdi:briefcase" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Quản lý đơn thuê
                    </div>
                </c:if>

                <!-- Mobile ADMIN Menu -->
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" 
                       class="mobile-nav-link"
                       style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                        <iconify-icon icon="mdi:shield-admin" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                        Dashboard Admin
                    </a>
                </c:if>
                
                <button onclick="confirmLogout()" 
                   class="mobile-nav-link"
                   style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; background: none; border: none; cursor: pointer; width: 100%; text-align: left;">
                    <iconify-icon icon="mdi:logout" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                    Đăng Xuất
                </button>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/dangnhap" 
                   class="mobile-nav-link"
                   style="display: flex; align-items: center; padding: var(--spacing-md); color: var(--color-text-secondary); text-decoration: none; border-bottom: 1px solid var(--color-border-light);">
                    <iconify-icon icon="mdi:login" style="width: 20px; height: 20px; margin-right: 8px;"></iconify-icon>
                    Đăng Nhập
                </a>
                
                <a href="${pageContext.request.contextPath}/dangky" 
                   class="btn btn-primary" 
                   style="display: block; width: 100%; text-align: center; padding: var(--spacing-md); margin-top: var(--spacing-md);">
                    <iconify-icon icon="mdi:account-plus"></iconify-icon>
                    Đăng Ký
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- Mobile Menu Toggle Script -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const toggleBtn = document.getElementById('mobileMenuToggle');
    const mobileMenu = document.getElementById('mobileMenu');
    const navLinks = mobileMenu.querySelectorAll('a');
    const submenuToggle = document.getElementById('mobileSubmenuToggle');
    const mobileSubmenu = document.getElementById('mobileSubmenu');
    const submenuChevron = document.getElementById('submenuChevron');
    
    if (toggleBtn && mobileMenu) {
        toggleBtn.addEventListener('click', function() {
            const isOpen = mobileMenu.style.display === 'block';
            mobileMenu.style.display = isOpen ? 'none' : 'block';
            mobileMenu.style.maxHeight = isOpen ? '0' : '500px';
        });
        
        // Close menu when a link is clicked
        navLinks.forEach(link => {
            link.addEventListener('click', function() {
                mobileMenu.style.display = 'none';
                mobileMenu.style.maxHeight = '0';
            });
        });
    }

    // Mobile submenu toggle for Lịch sử thuê xe
    if (submenuToggle && mobileSubmenu) {
        submenuToggle.addEventListener('click', function() {
            const isOpen = mobileSubmenu.style.display === 'block';
            mobileSubmenu.style.display = isOpen ? 'none' : 'block';
            if (submenuChevron) {
                submenuChevron.style.transform = isOpen ? 'rotate(0deg)' : 'rotate(180deg)';
            }
        });
    }
});

/**
 * Confirm logout before redirecting
 * Shows confirmation dialog with 2 buttons: Xác Nhận (logout) and Hủy (cancel)
 */
function confirmLogout() {
    const ctx = '${pageContext.request.contextPath}';
    if (window.UI && window.UI.confirm) {
        UI.confirm(
            'Đăng Xuất',
            'Bạn có chắc muốn đăng xuất khỏi hệ thống?',
            function() {
                // User clicked Xác Nhận (Confirm)
                window.location.href = ctx + '/logout';
            }
            // No callback for Cancel - just closes the dialog
        );
    } else {
        // Fallback to browser confirm if UI utility not available
        if (confirm('Bạn có chắc muốn đăng xuất khỏi hệ thống?')) {
            window.location.href = ctx + '/logout';
        }
    }
}
</script>
