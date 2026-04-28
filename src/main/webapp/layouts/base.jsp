<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>${param.title}</title>
    
    <!-- 1. Tailwind CSS - Foundation utility framework -->
    <link href="${pageContext.request.contextPath}/dist/tailwind.css" rel="stylesheet">
    
    <!-- 2. Global Design Tokens & Base Styles -->
    <link href="${pageContext.request.contextPath}/css/globals.css" rel="stylesheet">
    
    <!-- 3. Component Library -->
    <link href="${pageContext.request.contextPath}/css/components.css" rel="stylesheet">
    
    <!-- Iconify API - Icon library (light-loaded, no hardcoding) -->
    <script src="https://code.iconify.design/iconify-icon/1.0.8/iconify-icon.min.js"></script>
</head>
<body class="bg-color-bg-primary text-color-text-primary font-body">
    <div class="page-wrapper">
        <!-- Navigation Header -->
        <header class="page-header">
            <jsp:include page="/components/navbar.jsp" />
        </header>

        <!-- Main Content Area -->
        <main class="page-main">
            <jsp:doBody/>
        </main>

        <!-- Footer -->
        <footer class="page-footer">
            <jsp:include page="/components/footer.jsp" />
        </footer>
    </div>

    <!-- ===== SCRIPTS ===== -->
    <!-- UI Utilities (modals, toasts, forms, etc.) -->
    <script src="${pageContext.request.contextPath}/js/ui-utils.js"></script>
    
    <!-- Page-specific utilities -->
    <script src="${pageContext.request.contextPath}/js/feather-icons-init.js"></script>
</body>
</html>
