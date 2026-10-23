<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>

<%@ page import="com.digitalpurohit.dao.NotificationDAO" %>
<%@ page import="com.digitalpurohit.dao.impl.NotificationDAOImpl" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!-- =========================================================
     NAVBAR / POPUP CSS
========================================================= -->

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/notification.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/notification-popup.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/reminder-popup.css">

<%
Integer adminId = (Integer) session.getAttribute("adminId");

int unreadCount = 0;

if (adminId != null) {
    NotificationDAO dao = new NotificationDAOImpl();
    unreadCount = dao.getUnreadCount(adminId);
}
%>

<!-- =========================================================
     NAVBAR
========================================================= -->

<div class="navbar">

    <div class="navbar-left">

        <div class="logo">
            🛕 Digital Purohit
        </div>

        <div class="breadcrumb">
            Dashboard
        </div>

    </div>


    <div class="navbar-right">

        <!-- DATE / TIME -->

        <div class="date-time" id="dateTime"></div>


        <!-- NOTIFICATION -->

        <div class="notification-bell"
             onclick="openNotifications()">

            <i class="fa-solid fa-bell"></i>

            <% if (unreadCount > 0) { %>

                <span class="notification-count">
                    <%= unreadCount %>
                </span>

            <% } %>

        </div>


        <!-- PROFILE -->

        <div class="nav-profile">

            <a href="${pageContext.request.contextPath}/profile">

                <c:choose>

                    <c:when test="${not empty sessionScope.profileImage}">
                        <img
                            src="${pageContext.request.contextPath}/uploads/${sessionScope.profileImage}?v=<%= System.currentTimeMillis() %>"
                            class="nav-avatar"
                            alt="Profile">
                    </c:when>

                    <c:otherwise>
                        <div class="nav-avatar-text">
                            ${sessionScope.adminName.substring(0,2).toUpperCase()}
                        </div>
                    </c:otherwise>

                </c:choose>

            </a>

        </div>

    </div>

</div>


<!-- =========================================================
     DATE TIME
========================================================= -->

<script>

function updateDateTime() {

    const now = new Date();

    const options = {
        weekday: 'short',
        day: '2-digit',
        month: 'short',
        year: 'numeric'
    };

    const date =
        now.toLocaleDateString(
            'en-IN',
            options
        );

    const time =
        now.toLocaleTimeString();

    const element =
        document.getElementById("dateTime");

    if (element) {

        element.innerHTML =
            date +
            "<br>" +
            time;
    }
}

updateDateTime();

setInterval(
    updateDateTime,
    1000
);

</script>


<!-- =========================================================
     REMINDER POPUP
========================================================= -->

<div id="reminderPopupOverlay"
     class="reminder-popup-overlay">

    <div id="reminderPopup"
         class="reminder-popup">

        <div class="reminder-popup-icon"
             id="reminderPopupIcon">

            <i class="fa-solid fa-bell"></i>

        </div>


        <div class="reminder-popup-content">

            <div class="reminder-popup-type"
                 id="reminderPopupType">

                REMINDER

            </div>


            <h2 id="reminderPopupTitle">

                Reminder

            </h2>


            <p id="reminderPopupMessage">

                You have a reminder.

            </p>


            <div class="reminder-popup-time">

                <i class="fa-regular fa-clock"></i>

                <span id="reminderPopupTime">

                    --

                </span>

            </div>

        </div>


        <div class="reminder-popup-actions">

            <button
                type="button"
                class="reminder-view-btn"
                id="reminderViewDetailsBtn">

                <i class="fa-solid fa-eye"></i>

                View Details

            </button>


            <button
                type="button"
                class="reminder-dismiss-btn"
                id="reminderDismissBtn">

                <i class="fa-solid fa-check"></i>

                Dismiss

            </button>

        </div>

    </div>

</div>


<!-- =========================================================
     REMINDER JAVASCRIPT
========================================================= -->

