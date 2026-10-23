<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.Event"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Dashboard | Digital Purohit</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/dashboard.css">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

</head>

<body>

	<!-- =====================================================
     NAVBAR
     ===================================================== -->

	<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />


	<!-- =====================================================
     SIDEBAR
     ===================================================== -->

	<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


	<!-- =====================================================
     MAIN CONTENT
     ===================================================== -->

	<div class="main-content">

		<div class="dashboard-content">


			<!-- =====================================================
     WELCOME / RAPIDO STYLE HEADER
     ===================================================== -->

			<div class="dashboard-hero">

				<div class="hero-left">

					<div class="hero-icon">
						<i class="fa-solid fa-gauge-high"></i>
					</div>

					<div>

						<h1>Good Morning, ${sessionScope.adminName}</h1>

						<p>Here's your business overview for today.</p>

					</div>

				</div>


				<div class="hero-date">

					<div class="hero-date-icon">
						<i class="fa-regular fa-calendar"></i>
					</div>

					<div>

						<strong>${currentDate}</strong> <span>${currentTime}</span>

					</div>

				</div>

			</div>


			<!-- =====================================================
     TOP SUMMARY CARDS
     ===================================================== -->

			<div class="dashboard-top">


				<!-- TODAY'S INCOME -->

				<div class="top-stat-card stat-green">

					<div class="top-stat-content">

						<div>

							<span class="stat-label"> Today's Income </span>

							<h2>₹ ${todayIncome}</h2>

							<small> Today's collected amount </small>

						</div>

						<div class="top-stat-icon">

							<i class="fa-solid fa-indian-rupee-sign"></i>

						</div>

					</div>

				</div>


				<!-- TODAY'S EVENTS -->

				<div class="top-stat-card stat-blue">

					<div class="top-stat-content">

						<div>

							<span class="stat-label"> Today's Events </span>

							<h2>${todayTotalEvents}</h2>

							<small> ${todayEventCount} events +
								${todayBulkEventCount} bulk </small>

						</div>

						<div class="top-stat-icon">

							<i class="fa-solid fa-calendar-day"></i>

						</div>

					</div>

				</div>


				<!-- PENDING -->

				<div class="top-stat-card stat-orange">

					<div class="top-stat-content">

						<div>

							<span class="stat-label"> Pending Payments </span>

							<h2>₹ ${pendingIncome}</h2>

							<small> ${pendingPaymentCount} pending payments </small>

						</div>

						<div class="top-stat-icon">

							<i class="fa-solid fa-clock"></i>

						</div>

					</div>

				</div>


				<!-- MONTHLY INCOME -->

				<div class="top-stat-card stat-purple">

					<div class="top-stat-content">

						<div>

							<span class="stat-label"> Monthly Income </span>

							<h2>₹ ${totalMonthlyIncome}</h2>

							<small> Event + Bulk income </small>

						</div>

						<div class="top-stat-icon">

							<i class="fa-solid fa-chart-line"></i>

						</div>

					</div>

				</div>


			</div>


			<!-- =====================================================
     QUICK ACTIONS
     ===================================================== -->

			<div class="dashboard-card quick-actions-card">

				<div class="card-header">

					<div>

						<h2>

							<i class="fa-solid fa-bolt"></i> Quick Actions

						</h2>

						<p>Frequently used actions</p>

					</div>

				</div>


				<div class="card-body">

					<div class="quick-grid">


						<!-- ADD CUSTOMER -->

						<a href="${pageContext.request.contextPath}/add-customer"
							class="quick-link">

							<div class="quick-icon">

								<i class="fa-solid fa-user-plus"></i>

							</div>

							<div class="quick-title">Add Customer</div>

							<div class="quick-subtitle">Create new customer</div>

						</a>


						<!-- ADD EVENT -->

						<a href="${pageContext.request.contextPath}/add-event"
							class="quick-link">

							<div class="quick-icon">

								<i class="fa-solid fa-calendar-plus"></i>

							</div>

							<div class="quick-title">Add Event</div>

							<div class="quick-subtitle">Schedule an event</div>

						</a>


						<!-- BULK EVENT -->

						<a href="${pageContext.request.contextPath}/bulk-events"
							class="quick-link">

							<div class="quick-icon">

								<i class="fa-solid fa-people-group"></i>

							</div>

							<div class="quick-title">Bulk Event</div>

							<div class="quick-subtitle">Manage group events</div>

						</a>


						<!-- CUSTOMERS -->

						<a href="${pageContext.request.contextPath}/customers"
							class="quick-link">

							<div class="quick-icon">

								<i class="fa-solid fa-users"></i>

							</div>

							<div class="quick-title">Customers</div>

							<div class="quick-subtitle">Manage customers</div>

						</a>


						<!-- EVENTS -->

						<a href="${pageContext.request.contextPath}/events"
							class="quick-link">

							<div class="quick-icon">

								<i class="fa-solid fa-calendar-days"></i>

							</div>

							<div class="quick-title">Events</div>

							<div class="quick-subtitle">View all events</div>

						</a>


						<!-- REPORTS -->

						<a href="${pageContext.request.contextPath}/reports"
							class="quick-link">

							<div class="quick-icon">

								<i class="fa-solid fa-chart-line"></i>

							</div>

							<div class="quick-title">Reports</div>

							<div class="quick-subtitle">View business reports</div>

						</a>


					</div>

				</div>

			</div>


			<!-- =====================================================
     TODAY + PENDING PAYMENTS
     ===================================================== -->

			<div class="dashboard-main-grid">


				<!-- =================================================
         TODAY'S EVENTS
         ================================================= -->

				<div class="dashboard-card">

					<div class="card-header">

						<h2>

							<i class="fa-solid fa-calendar-day"></i> Today's Events

						</h2>

						<a href="${pageContext.request.contextPath}/events?filter=today">

							View All </a>

					</div>


					<div class="card-body">

						<%
						List<Event> todayEvents = (List<Event>) request.getAttribute("todayEvents");

						if (todayEvents != null && !todayEvents.isEmpty()) {

							int count = 0;

							for (Event event : todayEvents) {

								if (count >= 5) {
							break;
								}
						%>


						<div class="event-item">


							<div class="event-time">

								<i class="fa-regular fa-clock"></i> <br>

								<%=event.getEventTime()%>

							</div>


							<div class="event-info">

								<h4>
									<%=event.getEventTitle()%>
								</h4>

								<p>

									<i class="fa-solid fa-user"></i>

									<%=event.getCustomerName()%>

								</p>

								<span> <i class="fa-solid fa-location-dot"></i> <%=event.getLocation() != null ? event.getLocation() : "Location not specified"%>

								</span>

							</div>


						</div>


						<%
						count++;
						}

						} else {
						%>


						<div class="empty-box">

							<i class="fa-regular fa-calendar-xmark"></i>

							<p>No events scheduled for today.</p>

						</div>


						<%
						}
						%>

					</div>

				</div>



				<!-- =================================================
         RECENT PENDING PAYMENTS
         ================================================= -->

				<div class="dashboard-card">

					<div class="card-header">

						<h2>

							<i class="fa-solid fa-money-bill-wave"></i> Recent Pending
							Payments

						</h2>

						<a href="${pageContext.request.contextPath}/events?filter=pending">

							View All </a>

					</div>


					<div class="card-body">

						<%
						List<Event> pendingPayments = (List<Event>) request.getAttribute("pendingPayments");

						if (pendingPayments != null && !pendingPayments.isEmpty()) {

							int count = 0;

							for (Event event : pendingPayments) {

								if (count >= 5) {
							break;
								}
						%>


						<div class="payment-item">


							<div class="payment-customer">

								<div class="payment-avatar">

									<i class="fa-solid fa-user"></i>

								</div>


								<div>

									<strong> <%=event.getCustomerName()%>
									</strong> <small> <%=event.getEventTitle()%>
									</small> <small> <i class="fa-regular fa-calendar"></i> <%=event.getEventDate()%>

									</small>

								</div>

							</div>


							<div class="payment-right">

								<strong class="payment-amount"> ₹ <%=event.getPendingAmount()%>

								</strong> <span class="payment-status"> <%=event.getPaymentStatus()%>

								</span>

							</div>


						</div>


						<%
						count++;
						}

						} else {
						%>


						<div class="empty-box payment-empty">

							<i class="fa-solid fa-circle-check"></i>

							<p>No pending payments</p>

							<small> All payments are up to date. </small>

						</div>


						<%
						}
						%>

					</div>

				</div>


			</div>


			<!-- =====================================================
     TOMORROW + UPCOMING
     ===================================================== -->

			<div class="dashboard-main-grid">


				<!-- =================================================
         TOMORROW
         ================================================= -->

				<div class="dashboard-card">

					<div class="card-header">

						<h2>

							<i class="fa-solid fa-calendar-plus"></i> Tomorrow's Schedule

						</h2>

						<a
							href="${pageContext.request.contextPath}/events?filter=tomorrow">

							View All </a>

					</div>


					<div class="card-body">

						<%
						List<Event> tomorrowEvents = (List<Event>) request.getAttribute("tomorrowEvents");

						if (tomorrowEvents != null && !tomorrowEvents.isEmpty()) {

							int count = 0;

							for (Event event : tomorrowEvents) {

								if (count >= 5) {
							break;
								}
						%>


						<div class="event-item">

							<div class="event-time">

								<i class="fa-regular fa-clock"></i> <br>

								<%=event.getEventTime()%>

							</div>


							<div class="event-info">

								<h4>
									<%=event.getEventTitle()%>
								</h4>

								<p>

									<i class="fa-solid fa-user"></i>

									<%=event.getCustomerName()%>

								</p>

							</div>

						</div>


						<%
						count++;
						}

						} else {
						%>


						<div class="empty-box">

							<i class="fa-regular fa-calendar"></i>

							<p>No events scheduled for tomorrow.</p>

						</div>


						<%
						}
						%>

					</div>

				</div>



				<!-- =================================================
         UPCOMING EVENTS
         ================================================= -->

				<div class="dashboard-card">

					<div class="card-header">

						<h2>

							<i class="fa-solid fa-calendar-check"></i> Upcoming Events

						</h2>

						<a href="${pageContext.request.contextPath}/events"> View All

						</a>

					</div>


					<div class="card-body">

						<%
						List<Event> upcomingEvents = (List<Event>) request.getAttribute("upcomingEvents");

						if (upcomingEvents != null && !upcomingEvents.isEmpty()) {

							int count = 0;

							for (Event event : upcomingEvents) {

								if (count >= 5) {
							break;
								}
						%>


						<div class="event-item">

							<div class="event-date">

								<%=event.getEventDate()%>

							</div>


							<div class="event-info">

								<h4>
									<%=event.getEventTitle()%>
								</h4>

								<p>

									<i class="fa-solid fa-user"></i>

									<%=event.getCustomerName()%>

								</p>

							</div>

						</div>


						<%
						count++;
						}

						} else {
						%>


						<div class="empty-box">

							<i class="fa-regular fa-calendar-xmark"></i>

							<p>No upcoming events.</p>

						</div>


						<%
						}
						%>

					</div>

				</div>


			</div>


			<!-- =====================================================
     BUSINESS OVERVIEW
     ===================================================== -->

			<div class="dashboard-card business-overview-card">


				<div class="card-header">

					<div>

						<h2>

							<i class="fa-solid fa-chart-column"></i> Business Overview

						</h2>

						<p>Your financial summary</p>

					</div>


					<a href="${pageContext.request.contextPath}/reports"> View
						Reports </a>

				</div>


				<div class="summary-grid">


					<!-- MONTHLY TOTAL -->

					<div class="summary-box">

						<div class="summary-icon green-icon">

							<i class="fa-solid fa-wallet"></i>

						</div>

						<div>

							<h3>₹ ${totalMonthlyIncome}</h3>

							<p>Monthly Income</p>

						</div>

					</div>


					<!-- EVENT INCOME -->

					<div class="summary-box">

						<div class="summary-icon blue-icon">

							<i class="fa-solid fa-calendar-check"></i>

						</div>

						<div>

							<h3>₹ ${monthlyEventIncome}</h3>

							<p>Event Income</p>

						</div>

					</div>


					<!-- BULK INCOME -->

					<div class="summary-box">

						<div class="summary-icon purple-icon">

							<i class="fa-solid fa-people-group"></i>

						</div>

						<div>

							<h3>₹ ${monthlyBulkIncome}</h3>

							<p>Bulk Event Income</p>

						</div>

					</div>


					<!-- PENDING -->

					<div class="summary-box">

						<div class="summary-icon orange-icon">

							<i class="fa-solid fa-hourglass-half"></i>

						</div>

						<div>

							<h3>₹ ${pendingIncome}</h3>

							<p>Pending Amount</p>

						</div>

					</div>


				</div>

			</div>


		</div>

	</div>


</body>

</html>