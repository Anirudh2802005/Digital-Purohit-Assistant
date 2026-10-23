<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/notification.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/notification-popup.css">
<div class="sidebar">

    <!-- ================= HEADER ================= -->

    <div class="sidebar-header">

        <div class="sidebar-logo">

            <i class="fa-solid fa-place-of-worship"></i>

        </div>

        <div class="sidebar-title-container">

            <div class="sidebar-title-main">

                Digital Purohit

            </div>

            <div class="sidebar-subtitle">

                Assistant

            </div>

        </div>

    </div>

    <!-- ================= MAIN MENU ================= -->

    <div class="menu-title">

        MAIN MENU

    </div>

    <!-- Notification -->

<a href="javascript:void(0);"
   onclick="openNotifications();">

    <i class="fa-solid fa-bell"></i>

    <span>Notifications</span>

   <span class="menu-badge">${unreadCount}</span>

</a>

    <!-- Dashboard -->

    <a href="${pageContext.request.contextPath}/dashboard">

        <i class="fa-solid fa-house"></i>

        <span>

            Dashboard

        </span>

    </a>

    <!-- Frequently Used -->

    

    <!-- Reminders -->

    

    <!-- ================= MANAGEMENT ================= -->

    <div class="menu-title">

        MANAGEMENT

    </div>

    <a href="${pageContext.request.contextPath}/customers">

        <i class="fa-solid fa-users"></i>

        <span>

            Customers

        </span>

    </a>

    <a href="${pageContext.request.contextPath}/events">

        <i class="fa-solid fa-calendar-days"></i>

        <span>

            Events

        </span>

    </a>

    <a href="${pageContext.request.contextPath}/bulk-dashboard">

        <i class="fa-solid fa-hands-praying"></i>

        <span>

            Bulk Events

        </span>

    </a>

    <a href="${pageContext.request.contextPath}/pending-payments">

        <i class="fa-solid fa-money-bill-wave"></i>

        <span>

            Pending Payments

        </span>

    </a>

    <a href="${pageContext.request.contextPath}/calendar">

        <i class="fa-solid fa-calendar-days"></i>

        <span>

            Calendar

        </span>

    </a>

    <a href="${pageContext.request.contextPath}/reports">

        <i class="fa-solid fa-chart-line"></i>

        <span>

            Reports

        </span>

    </a>

   

    <!-- ================= ACCOUNT ================= -->

    <div class="menu-title">

        ACCOUNT

    </div>
    
<a href="${pageContext.request.contextPath}/profile">

    <i class="fa-solid fa-user"></i>

    <span>

        Profile

    </span>

</a>

    <a href="${pageContext.request.contextPath}/logout"
       onclick="return confirm('Logout?');">

        <i class="fa-solid fa-right-from-bracket"></i>

        <span>

            Logout

        </span>

    </a>

</div>
<!-- ================= Notification ================= -->

<a href="javascript:void(0);" onclick="openNotifications();">

    <i class="fa-solid fa-bell"></i>

    <span>Notifications</span>

   <span class="menu-badge">${unreadCount}</span>
</a>

<!-- ================= Notification Overlay ================= -->

<!-- ==========================================================
     NOTIFICATION POPUP
========================================================== -->

<div id="notificationOverlay" class="notification-overlay">

    <div class="notification-popup">

        <!-- Header -->

        <div class="notification-popup-header">

            <div class="notification-header-left">

                <div class="notification-header-icon">

                    <i class="fa-solid fa-bell"></i>

                </div>

                <div>

                    <h2>Notifications</h2>

                    <p>Stay updated with recent activities</p>

                </div>

            </div>

            <div class="notification-actions">

                <button id="markAllRead">

                    <i class="fa-solid fa-check-double"></i>

                    Mark All Read

                </button>

                <button id="deleteAllBtn">

                    <i class="fa-solid fa-trash"></i>

                    Delete All

                </button>

                <button id="closeNotification">

                    <i class="fa-solid fa-xmark"></i>

                </button>

            </div>

        </div>

        <!-- Notification Body -->

        <div id="notificationContainer">

        </div>

        <!-- Footer -->

        <div class="notification-footer">

            <div class="notification-total">

                <i class="fa-regular fa-square-check"></i>

                Total Notifications :

                <strong id="totalNotifications">

                    0

                </strong>

            </div>

            <a href="javascript:void(0);" class="view-all-link">

                View All Notifications

                <i class="fa-solid fa-arrow-right"></i>

            </a>

        </div>

    </div>

</div>

<!-- ===========================================
     GLOBAL TOAST
=========================================== -->

<div id="globalToast"
     class="global-toast ${sessionScope.toastType}">

    <div class="toast-left">

        <i id="toastIcon"
           class="fa-solid fa-circle-check"></i>

    </div>

    <div class="toast-body">

        <div id="toastTitle"
             class="toast-title">

            ${sessionScope.toastTitle}

        </div>

        <div id="toastMessage"
             class="toast-message">

            ${sessionScope.toastMessage}

        </div>

    </div>

    <button id="toastClose">

        <i class="fa-solid fa-xmark"></i>

    </button>

</div>



<%
session.removeAttribute("toastType");
session.removeAttribute("toastTitle");
session.removeAttribute("toastMessage");
%>

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/notification.js"></script>
