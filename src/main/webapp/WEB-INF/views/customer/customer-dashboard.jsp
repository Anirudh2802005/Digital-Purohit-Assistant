<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Customers | Digital Purohit Assistant</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/customer-dashboard.css">

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

    <!-- Page Heading -->

    <div class="page-header">

        <h1>👥 Customers</h1>

        <p>Manage all customer information from one place.</p>

    </div>

    <!-- Statistics -->

    <div class="customer-summary">

        <div class="summary-card">

            <h2>${totalCustomers}</h2>

            <p>Total Customers</p>

        </div>

        <div class="summary-card">

            <h2>${newCustomers}</h2>

            <p>New This Month</p>

        </div>

        <a href="${pageContext.request.contextPath}/frequent-customers"
   class="summary-card">

    <h2>${frequentCustomers}</h2>

    <p>Frequent Customers</p>

</a>

    </div>

    <!-- Action Cards -->

    <div class="customer-actions">

        <a href="${pageContext.request.contextPath}/add-customer"
           class="action-card">

            <div class="action-icon">

                ➕

            </div>

            <h3>Add Customer</h3>

            <p>Create a new customer.</p>

        </a>

        <a href="${pageContext.request.contextPath}/view-customers"
           class="action-card">

            <div class="action-icon">

                📋

            </div>

            <h3>View Customers</h3>

            <p>Search, edit and delete customers.</p>

        </a>

    </div>

</div>

<%@ include file="../partials/footer.jsp"%>

</body>

</html>