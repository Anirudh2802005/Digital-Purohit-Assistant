<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>



<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Bulk Events Dashboard</title>

<!-- Font Awesome -->
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<!-- CSS -->
<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/bulk-dashboard.css">
</head>

<body>

    <!-- ================= NAVBAR ================= -->

    <jsp:include page="../partials/navbar.jsp"/>

    <!-- ================= SIDEBAR ================= -->

    <jsp:include page="../partials/sidebar.jsp"/>

    <!-- ================= MAIN CONTENT ================= -->

    <main class="main-content">

        <div class="page-header">

            <div>

                <h1 class="page-title">Bulk Events Dashboard</h1>

                <p>Manage all bulk events, families and payments.</p>

            </div>

        </div>

        <!-- ================= Statistics ================= -->

        <section class="dashboard-stats">

            <div class="stat-card">

                <i class="fa-solid fa-calendar-days"></i>

                <h3>Total Bulk Events</h3>

                <h2>${totalBulkEvents}</h2>

            </div>

            <div class="stat-card">

                <i class="fa-solid fa-calendar-check"></i>

                <h3>Today's Events</h3>

                <h2>${todayBulkEvents}</h2>

            </div>

            <div class="stat-card">

                <i class="fa-solid fa-indian-rupee-sign"></i>

                <h3>Monthly Income</h3>

                <h2>₹ ${monthlyIncome}</h2>

            </div>

            <div class="stat-card">

                <i class="fa-solid fa-money-bill-wave"></i>

                <h3>Pending Payments</h3>

                <h2>${pendingPayments}</h2>

            </div>

        </section>

        <!-- ================= Quick Actions ================= -->

        <h2 class="section-title mt-30">Quick Actions</h2>

        <section class="quick-actions">

            <a href="${pageContext.request.contextPath}/add-bulk-event"
               class="action-card">

                <i class="fa-solid fa-plus"></i>

                <h3>Add Bulk Event</h3>

                <p>Create New Bulk Event</p>

            </a>

          <a href="${pageContext.request.contextPath}/bulk-events"
   class="action-card">

    <i class="fa-solid fa-list"></i>

    <h3>View Bulk Events</h3>

    <p>Manage Existing Events</p>

</a>

           <a href="${pageContext.request.contextPath}/bulk-event-income"
   class="action-card">

    <i class="fa-solid fa-money-check-dollar"></i>

    <h3>Receive Payments</h3>

    <p>Collect Pending Payments</p>

</a>
            <a href="${pageContext.request.contextPath}/bulk-event-reports"
   class="action-card">

    <i class="fa-solid fa-chart-column"></i>

    <h3>Reports</h3>

    <p>Income & Analytics</p>

</a>

      
    </main>

</body>

</html>