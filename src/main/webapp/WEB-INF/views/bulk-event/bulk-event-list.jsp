<%@ page contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.BulkEvent"%>

<%
List<BulkEvent> bulkEvents =
(List<BulkEvent>)request.getAttribute("bulkEvents");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Bulk Events</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/bulk-event-list.css">

<link rel="preconnect"
href="https://fonts.googleapis.com">

<link rel="preconnect"
href="https://fonts.gstatic.com"
crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
rel="stylesheet">

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<!-- ================= HEADER ================= -->

<div class="page-header">

    <div>

        <h1 class="page-title">

            🛕 Bulk Events

        </h1>

        <p class="page-subtitle">

            Manage all your Bulk Events.

        </p>

    </div>

    <a href="${pageContext.request.contextPath}/add-bulk-event"
       class="add-btn">

        + Add Bulk Event

    </a>

</div>

<!-- ================= SEARCH ================= -->

<div class="search-bar">

<input
type="text"
placeholder="Search Bulk Event...">

</div>

<!-- ================= SUMMARY ================= -->

<div class="summary-grid">

<div class="summary-card">

<h2>

<%= bulkEvents==null ? 0 : bulkEvents.size() %>

</h2>

<p>Total Events</p>

</div>

<div class="summary-card">

<h2>0</h2>

<p>Today's</p>

</div>

<div class="summary-card">

<h2>₹0</h2>

<p>Income</p>

</div>

<div class="summary-card">

<h2>0</h2>

<p>Pending</p>

</div>

</div>

<h2 class="section-title">

All Bulk Events

</h2>

<div class="card-container">

<%
if (bulkEvents != null && !bulkEvents.isEmpty()) {

    for (BulkEvent bulkEvent : bulkEvents) {
%>

<div class="event-card">

    <!-- Card Header -->

   <div class="event-header">

    <div class="header-top">

        <h3>
            🛕 <%= bulkEvent.getBulkEventName() %>
        </h3>

<%
java.time.LocalDate today = java.time.LocalDate.now();

java.time.LocalDate start =
bulkEvent.getStartDate().toLocalDate();

java.time.LocalDate end =
bulkEvent.getEndDate().toLocalDate();

if(today.isBefore(start)){
%>

<span class="badge upcoming">

Upcoming

</span>

<%
}else if(today.isAfter(end)){
%>

<span class="badge completed">

Completed

</span>

<%
}else{
%>

<span class="badge active">

Active

</span>

<%
}
%>

    </div>

</div>

    <!-- Card Body -->

    <div class="event-body">

        <div class="event-row">

            <span>📅 Start Date</span>

            <strong>

                <%= bulkEvent.getStartDate() %>

            </strong>

        </div>

        <div class="event-row">

            <span>📅 End Date</span>

            <strong>

                <%= bulkEvent.getEndDate() %>

            </strong>

        </div>

        <div class="event-row">

            <span>📍 Location</span>

            <strong>

                <%= bulkEvent.getLocation() %>

            </strong>

        </div>
        
        

<%
if (bulkEvent.getNotes() != null &&
!bulkEvent.getNotes().trim().isEmpty()) {
%>

        <div class="notes">

            <strong>Notes</strong>

            <p>

                <%= bulkEvent.getNotes() %>

            </p>

        </div>

<%
}
%>

    </div>
    
    

    <!-- Footer -->

    <div class="event-footer">

   <a class="btn details"
   href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%=bulkEvent.getYatraId()%>">

    👁 Details

</a>

   

    <a class="btn edit"
       href="${pageContext.request.contextPath}/edit-bulk-event?id=<%=bulkEvent.getYatraId()%>">
        ✏ Edit
    </a>

<a class="btn delete"
   href="${pageContext.request.contextPath}/delete-bulk-event?bulkEventId=<%=bulkEvent.getYatraId()%>"
   onclick="return confirm('Are you sure you want to delete this Bulk Event?')">

    🗑 Delete

</a>

</div>
</div>

<%
    }

} else {
%>

<div class="empty-card">

<h2>

🛕

</h2>

<h3>

No Bulk Events Found

</h3>

<p>

Click "Add Bulk Event" to create your first event.

</p>

</div>

<%
}
%>

</div>

</div>

</body>

</html>