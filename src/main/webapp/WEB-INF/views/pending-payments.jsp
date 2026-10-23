<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.Event"%>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>

<%
List<Event> eventPayments =
(List<Event>)request.getAttribute("eventPayments");

List<BulkEventCustomer> bulkPayments =
(List<BulkEventCustomer>)request.getAttribute("bulkPayments");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Pending Payments</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

table{

width:100%;
border-collapse:collapse;
margin-bottom:40px;
background:white;

}

table,th,td{

border:1px solid #ccc;

}

th{

background:#2c6bed;
color:white;
padding:10px;

}

td{

padding:10px;
text-align:center;

}

h1{

margin-bottom:20px;

}

h2{

margin-top:30px;
margin-bottom:15px;

}

.receive{

background:#28a745;
color:white;
padding:8px 14px;
text-decoration:none;
border-radius:5px;
font-weight:bold;

}

.receive:hover{

background:#218838;

}

.status{

display:inline-block;
padding:6px 14px;
border-radius:20px;
color:white;
font-weight:bold;
min-width:90px;

}

.pending{

background:#dc3545;

}

.partial{

background:#ff9800;

}

.paid{

background:#28a745;

}

.empty{

padding:25px;
font-size:18px;
font-weight:bold;
color:green;
text-align:center;

}

</style>

</head>

<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h1>💰 Pending Payments</h1>

<h2>Event Pending Payments</h2>

<table>

<tr>

<th>Customer</th>
<th>Phone</th>
<th>Event</th>
<th>Total</th>
<th>Paid</th>
<th>Due</th>
<th>Status</th>
<th>Action</th>

</tr>

<%

if(eventPayments==null || eventPayments.isEmpty()){

%>

<tr>

<td colspan="8" class="empty">

🎉 No Pending Event Payments

</td>

</tr>

<%

}else{

for(Event event : eventPayments){

%>

<tr>

<td><%=event.getCustomerName()%></td>

<td><%=event.getPhone()%></td>

<td><%=event.getEventTitle()%></td>

<td>₹ <%=event.getTotalAmount()%></td>

<td>₹ <%=event.getAmountPaid()%></td>

<td>₹ <%=event.getTotalAmount()-event.getAmountPaid()%></td>

<td>

<%

String status = event.getPaymentStatus();

if("PENDING".equals(status)){

%>

<span class="status pending">

PENDING

</span>

<%

}else if("PARTIAL".equals(status)){

%>

<span class="status partial">

PARTIAL

</span>

<%

}else{

%>

<span class="status paid">

PAID

</span>

<%

}

%>

</td>

<td>

<a class="receive"
href="${pageContext.request.contextPath}/event-receive-payment?eventId=<%=event.getEventId()%>"
onclick="return confirm('Are you sure you want to update this payment?');">

Receive Payment

</a>

</td>

</tr>

<%

}

}

%>

</table>

<hr>

<h2>Bulk Event Pending Payments</h2>

<table>

<tr>

<th>Family</th>
<th>Phone</th>
<th>Bulk Event</th>
<th>Total</th>
<th>Paid</th>
<th>Due</th>
<th>Status</th>
<th>Action</th>

</tr>

<%

if(bulkPayments==null || bulkPayments.isEmpty()){

%>

<tr>

<td colspan="8" class="empty">

🎉 No Pending Bulk Event Payments

</td>

</tr>

<%

}else{

for(BulkEventCustomer family : bulkPayments){

%>

<tr>

<td><%=family.getCustomerName()%></td>

<td><%=family.getPhone()%></td>

<td><%=family.getBulkEventName()%></td>

<td>₹ <%=family.getTotalAmount()%></td>

<td>₹ <%=family.getAmountPaid()%></td>

<td>₹ <%=family.getTotalAmount()-family.getAmountPaid()%></td>

<td>

<%

String bulkStatus = family.getPaymentStatus();

if("PENDING".equals(bulkStatus)){

%>

<span class="status pending">

PENDING

</span>

<%

}else if("PARTIAL".equals(bulkStatus)){

%>

<span class="status partial">

PARTIAL

</span>

<%

}else{

%>

<span class="status paid">

PAID

</span>

<%

}

%>

</td>

<td>

<a class="receive"
href="${pageContext.request.contextPath}/bulk-receive-payment?bulkEventId=<%=family.getBulkEventId()%>&customerId=<%=family.getCustomerId()%>"
onclick="return confirm('Are you sure you want to update this payment?');">

Receive Payment

</a>

</td>

</tr>

<%

}

}

%>

</table>

</div>

</body>

</html>