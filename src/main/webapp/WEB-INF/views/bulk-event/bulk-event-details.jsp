<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="com.digitalpurohit.model.BulkEvent"%>

<%
BulkEvent event=(BulkEvent)request.getAttribute("bulkEvent");
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Bulk Event Details</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/bulk-event-details.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

</head>

<body>

<jsp:include page="../partials/navbar.jsp"/>

<jsp:include page="../partials/sidebar.jsp"/>

<main class="main-content">

<!-- ================= HEADER ================= -->

<div class="page-header">

<div>

<h1 class="page-title">

🛕 <%=event.getBulkEventName()%>

</h1>

<p>

Bulk Event Overview

</p>

</div>

<a href="${pageContext.request.contextPath}/bulk-events"
class="back-btn">

← Back

</a>

</div>

<!-- ================= EVENT INFO ================= -->

<div class="info-card">

<h2>

Event Information

</h2>

<div class="info-grid">

<div>

<label>Start Date</label>

<p><%=event.getStartDate()%></p>

</div>

<div>

<label>End Date</label>

<p><%=event.getEndDate()%></p>

</div>

<div>

<label>Location</label>

<p><%=event.getLocation()%></p>

</div>

<div>

<label>Created On</label>

<p><%=event.getCreatedAt()%></p>

</div>

</div>

</div>

<!-- ================= STATISTICS ================= -->

<div class="stats-grid">

<div class="stat-card">

<i class="fa-solid fa-users"></i>

<h2><%=event.getTotalFamilies()%></h2>

<p>Total Families</p>

</div>

<div class="stat-card">

<i class="fa-solid fa-circle-check"></i>

<h2><%=event.getPaidFamilies()%></h2>

<p>Paid Families</p>

</div>

<div class="stat-card">

<i class="fa-solid fa-clock"></i>

<h2><%=event.getPendingFamilies()%></h2>

<p>Pending Families</p>

</div>

<div class="stat-card">

<i class="fa-solid fa-indian-rupee-sign"></i>

<h2>₹ <%=String.format("%,.0f",event.getTotalAmountCollected())%></h2>

<p>Collected</p>

</div>

</div>

<!-- ================= NOTES ================= -->

<div class="notes-card">

<h2>

Notes

</h2>

<p>

<%=event.getNotes()==null||event.getNotes().isBlank()
?"No Notes Available":event.getNotes()%>

</p>

</div>

<!-- ================= QUICK ACTIONS ================= -->

<h2 class="section-title">

Quick Actions

</h2>

<div class="action-grid">

<a class="action-card"
href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%=event.getYatraId()%>">

<i class="fa-solid fa-users"></i>

<h3>Families</h3>

</a>

<a class="action-card"
href="${pageContext.request.contextPath}/bulk-event-payments?bulkEventId=<%=event.getYatraId()%>">

<i class="fa-solid fa-money-bill-wave"></i>

<h3>Payments</h3>

</a>

<a class="action-card"
href="${pageContext.request.contextPath}/bulk-event-report?bulkEventId=<%=event.getYatraId()%>">

<i class="fa-solid fa-chart-column"></i>

<h3>Report</h3>

</a>

<a class="action-card"
href="${pageContext.request.contextPath}/edit-bulk-event?id=<%=event.getYatraId()%>">

<i class="fa-solid fa-pen"></i>

<h3>Edit</h3>

</a>

<a class="action-card delete"
href="${pageContext.request.contextPath}/delete-bulk-event?id=<%=event.getYatraId()%>">

<i class="fa-solid fa-trash"></i>

<h3>Delete</h3>

</a>

</div>

<!-- ================= FAMILY PREVIEW ================= -->

<div class="family-preview">

<h2>

Recent Families

</h2>

<p>

Latest registered families will appear here.

</p>

<a class="view-btn"
href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%=event.getYatraId()%>">

View All Families

</a>

</div>

</main>

</body>

</html>