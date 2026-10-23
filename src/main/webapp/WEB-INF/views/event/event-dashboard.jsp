<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Events | Digital Purohit Assistant</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">
<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/toast.css">
<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/event-dashboard.css">

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />



<%@ include file="../partials/toast.jsp"%>



<div class="main-content">

    <div class="page-header">

        <h1>📅 Events</h1>

        <p>Manage all events from one place.</p>

    </div>

<div>

<div class="event-summary">

    <div class="summary-card"
         onclick="window.location.href='${pageContext.request.contextPath}/view-events?filter=all';"
         style="cursor:pointer;">

        <h2>${totalEvents}</h2>

        <p>Total Events</p>

    </div>

    <div class="summary-card"
         onclick="window.location.href='${pageContext.request.contextPath}/view-events?filter=today';"
         style="cursor:pointer;">

        <h2>${todayEvents}</h2>

        <p>Today's Events</p>

    </div>

    <div class="summary-card"
         onclick="window.location.href='${pageContext.request.contextPath}/view-events?filter=upcoming';"
         style="cursor:pointer;">

        <h2>${upcomingEvents}</h2>

        <p>Upcoming Events</p>

    </div>

    <div class="summary-card"
         onclick="window.location.href='${pageContext.request.contextPath}/view-events?filter=pending';"
         style="cursor:pointer;">

        <h2>${pendingPayments}</h2>

        <p>Pending Payments</p>

    </div>

</div>

    </div>

    <div class="event-actions">

        <a href="${pageContext.request.contextPath}/add-event"
           class="action-card">

            <div class="action-icon">➕</div>

            <h3>Add Event</h3>

            <p>Create a new event.</p>

        </a>

       <a href="${pageContext.request.contextPath}/view-events"
   class="action-card">

            <div class="action-icon">📋</div>

            <h3>View Events</h3>

            <p>Search, edit and manage events.</p>

        </a>

        <a href="${pageContext.request.contextPath}/event-types"
           class="action-card">

            <div class="action-icon">🏷</div>

            <h3>Event Types</h3>

            <p>Manage event categories.</p>

        </a>

        <a href="${pageContext.request.contextPath}/samagri"
           class="action-card">

            <div class="action-icon">🪔</div>

            <h3>Master Samagri</h3>

            <p>Manage all pooja materials.</p>

        </a>

    </div>

</div>

<%@ include file="../partials/footer.jsp"%>

</body>

</html>