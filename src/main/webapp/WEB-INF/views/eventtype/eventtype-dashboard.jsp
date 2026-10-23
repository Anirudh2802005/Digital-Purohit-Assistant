<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Event Types | Digital Purohit Assistant</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/event-dashboard.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/toast.css">

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<%@ include file="../partials/toast.jsp"%>



<div class="main-content">

    <div class="page-header">

        <h1>🏷 Event Types</h1>

        <p>Manage all event categories from one place.</p>

    </div>

    <div class="event-summary">

        <div class="summary-card">

            <h2>${totalEventTypes}</h2>

            <p>Total Event Types</p>

        </div>

        <div class="summary-card">

            <h2>${frequentlyUsedTypes}</h2>

            <p>Frequently Used</p>

        </div>

        <div class="summary-card">

            <h2>${activeEventTypes}</h2>

            <p>Active Event Types</p>

        </div>

    </div>

    <div class="event-actions">

        <a href="${pageContext.request.contextPath}/add-event-type"
           class="action-card">

            <div class="action-icon">➕</div>

            <h3>Add Event Type</h3>

            <p>Create a new event type.</p>

        </a>

        <a href="${pageContext.request.contextPath}/view-event-types"
           class="action-card">

            <div class="action-icon">📋</div>

            <h3>View Event Types</h3>

            <p>Browse and manage event types.</p>

        </a>

    </div>

</div>

<%@ include file="../partials/footer.jsp"%>

</body>

</html>