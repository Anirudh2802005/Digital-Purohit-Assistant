<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.BulkEvent"%>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>

<%
BulkEvent event = (BulkEvent) request.getAttribute("event");

List<BulkEventCustomer> families =
(List<BulkEventCustomer>) request.getAttribute("families");

String keyword = request.getAttribute("keyword") != null
? request.getAttribute("keyword").toString()
: "";
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Bulk Event Families</title>

<link rel="stylesheet"
href="<%=request.getContextPath()%>/assets/css/bulk-event-family.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

</head>

<body>

<body>

<jsp:include page="../partials/navbar.jsp"/>

<jsp:include page="../partials/sidebar.jsp"/>

<div class="main-content">


<div class="container">

    <!-- ================= HEADER ================= -->

    <div class="page-header">

        <div class="header-left">

            <h1>

                <i class="fa-solid fa-users"></i>

                <%=event.getBulkEventName()%>

            </h1>

            <p>

                <i class="fa-solid fa-location-dot"></i>

                <%=event.getLocation()%>

                &nbsp;&nbsp;&nbsp;

                <i class="fa-solid fa-calendar-days"></i>

                <%=event.getStartDate()%>

                -

                <%=event.getEndDate()%>

            </p>

        </div>

        <div class="header-right">
<a href="<%=request.getContextPath()%>/bulk-events"
    class="btn secondary">

    <i class="fa-solid fa-arrow-left"></i>

    Back

</a>x

        </div>

    </div>
<!-- ================= EVENT ACTIONS ================= -->

<div class="event-actions">

    <a href="<%=request.getContextPath()%>/edit-bulk-event?id=<%=event.getYatraId()%>"
   class="btn edit-event">

    <i class="fa-solid fa-pen-to-square"></i>

    Edit Event

</a>

    <a href="<%=request.getContextPath()%>/bulk-event-payments?bulkEventId=<%=event.getYatraId()%>"
       class="btn payment-event">

        <i class="fa-solid fa-money-bill-wave"></i>

        Payments

    </a>

    <a href="<%=request.getContextPath()%>/bulk-event-report?bulkEventId=<%=event.getYatraId()%>"
       class="btn report-event">

        <i class="fa-solid fa-chart-column"></i>

        Reports

    </a>

    <a href="<%=request.getContextPath()%>/delete-bulk-event?bulkEventId=<%=event.getYatraId()%>"
       class="btn delete-event"
       onclick="return confirm('Delete this Bulk Event?');">

        <i class="fa-solid fa-trash"></i>

        Delete Event

    </a>

</div>
    <!-- ================= TOOLBAR ================= -->

    <div class="toolbar">

        <form action="<%=request.getContextPath()%>/bulk-event-families"
              method="get"
              class="search-form">

            <input
                type="hidden"
                name="bulkEventId"
                value="<%=event.getYatraId()%>">

            <input
                type="text"
                name="keyword"
                value="<%=keyword%>"
                placeholder="Search by Name, Phone or Gothram">

            <button type="submit">

                <i class="fa-solid fa-magnifying-glass"></i>

                Search

            </button>

        </form>

        <div class="toolbar-buttons">

           

<a href="${pageContext.request.contextPath}/add-bulk-family?bulkEventId=<%=event.getYatraId()%>"
   class="btn success">
    <i class="fa-solid fa-circle-plus"></i>
    Add Family
</a>
            <a href="<%=request.getContextPath()%>/bulk-event-families?bulkEventId=<%=event.getYatraId()%>"
               class="btn warning">

                <i class="fa-solid fa-rotate"></i>

                Refresh

            </a>

        </div>

    </div>

    <!-- ================= DASHBOARD ================= -->

    <div class="dashboard">

        <div class="card">

            <div class="icon blue">

                <i class="fa-solid fa-users"></i>

            </div>

            <div class="content">

                <h3>Total Families</h3>

                <h2>

                    <%=event.getTotalFamilies()%>

                </h2>

            </div>

        </div>

        <div class="card">

            <div class="icon green">

                <i class="fa-solid fa-circle-check"></i>

            </div>

            <div class="content">

                <h3>Paid Families</h3>

                <h2>

                    <%=event.getPaidFamilies()%>

                </h2>

            </div>

        </div>

        <div class="card">

            <div class="icon orange">

                <i class="fa-solid fa-clock"></i>

            </div>

            <div class="content">

                <h3>Pending Families</h3>

                <h2>

                    <%=event.getPendingFamilies()%>

                </h2>

            </div>

        </div>

        <div class="card">

            <div class="icon purple">

                <i class="fa-solid fa-indian-rupee-sign"></i>

            </div>

            <div class="content">

                <h3>Total Collection</h3>

                <h2>

                    ₹<%=String.format("%,.0f",
                    event.getTotalAmountCollected())%>

                </h2>

            </div>

        </div>

    </div>

    <!-- ================= FAMILY TABLE START ================= -->

    <div class="table-card">

        <div class="table-header">

            <h2>

                <i class="fa-solid fa-users"></i>

                Family List

            </h2>

        </div>

        <table>

            <thead>

                <tr>

                    <th>#</th>

                    <th>Name</th>

                    <th>Phone</th>

                    <th>Address</th>

                    <th>Gothram</th>

                    <th>Total Amount</th>

                    <th>Paid</th>

                    <th>Due</th>

                    <th>Status</th>

                    <th>Actions</th>

                </tr>

            </thead>

            <tbody>
            
            <%
if (families != null && !families.isEmpty()) {

    int count = 1;

    for (BulkEventCustomer family : families) {

        double due =
                family.getTotalAmount() -
                family.getAmountPaid();
%>

<tr>

    <td><%=count++%></td>

    <td>

        <strong>

            <%=family.getCustomerName()%>

        </strong>

    </td>

    <td>

        <%=family.getPhone()%>

    </td>

    <td>

        <%=family.getAddress()%>

    </td>

    <td>

        <%=family.getGothram()%>

    </td>

    <td>

        ₹<%=String.format("%,.0f",
                family.getTotalAmount())%>

    </td>

    <td>

        ₹<%=String.format("%,.0f",
                family.getAmountPaid())%>

    </td>

    <td>

        ₹<%=String.format("%,.0f",
                due)%>

    </td>

    <td>

<%
String status = family.getPaymentStatus();

if(status == null){
    status = "Pending";
}

if(status.equalsIgnoreCase("Paid")){
%>

<span class="badge paid">

<i class="fa-solid fa-circle-check"></i>

Paid

</span>

<%
}else if(status.equalsIgnoreCase("Partial")){
%>

<span class="badge partial">

<i class="fa-solid fa-hourglass-half"></i>

Partial

</span>

<%
}else{
%>

<span class="badge pending">

<i class="fa-solid fa-clock"></i>

Pending

</span>

<%
}
%>

    </td>

    <td>

        <div class="action-buttons">

            <!-- View -->
<a href="<%=request.getContextPath()%>/customer-history?customerId=<%=family.getCustomerId()%>"
   class="action view"
   title="View">

    <i class="fa-solid fa-eye"></i>

</a>
            <!-- Edit -->

            <a href="<%=request.getContextPath()%>/edit-bulk-family?id=<%=family.getId()%>"
   class="action edit"
   title="Edit">

    <i class="fa-solid fa-pen"></i>

</a>

            <!-- Payment -->

        <a href="<%=request.getContextPath()%>/bulk-receive-payment?id=<%=family.getId()%>"
   class="action payment"
   title="Receive Payment">

    <i class="fa-solid fa-indian-rupee-sign"></i>

</a>

            <!-- Remove -->

           <a href="<%=request.getContextPath()%>/delete-bulk-family?id=<%=family.getId()%>"
   class="action delete"
   title="Delete"
   onclick="return confirm('Remove this family from the bulk event?');">

    <i class="fa-solid fa-trash"></i>

</a>

        </div>

    </td>

</tr>

<%
    }

}else{
%>

<tr>

<td colspan="10">

<div class="empty-state">

<i class="fa-solid fa-users-slash"></i>

<h3>

No Families Found

</h3>

<p>

No families have been added to this bulk event yet.

</p>

<a href="#"
   class="btn primary">

<i class="fa-solid fa-user-plus"></i>

Add First Family

</a>

</div>

</td>

</tr>

<%
}
%>

            </tbody>

        </table>

    </div>

</div>
</div>


</body>

</html>