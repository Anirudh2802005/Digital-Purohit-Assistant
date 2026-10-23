<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.Event"%>

<%
List<Event> events =
(List<Event>) request.getAttribute("events");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Pending Event Payments</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

table{

width:100%;
border-collapse:collapse;
background:white;
margin-top:20px;

}

th,td{

padding:12px;
border:1px solid #ddd;
text-align:center;

}

th{

background:#4CAF50;
color:white;

}

.btn{

padding:8px 15px;
background:#2196F3;
color:white;
text-decoration:none;
border-radius:5px;
font-weight:bold;

}

.btn:hover{

background:#1976D2;

}

.status{

padding:6px 12px;
border-radius:20px;
color:white;
font-weight:bold;
display:inline-block;
min-width:80px;

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
text-align:center;
font-size:20px;
font-weight:bold;
color:green;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h2>💰 Pending Event Payments</h2>

<%

if(events==null || events.isEmpty()){

%>

<div class="empty">

🎉 No Pending Event Payments

</div>

<%

}else{

%>

<table>

<tr>

<th>Customer</th>

<th>Phone</th>

<th>Event</th>

<th>Date</th>

<th>Total Amount</th>

<th>Amount Paid</th>

<th>Outstanding</th>

<th>Status</th>

<th>Action</th>

</tr>

<%

for(Event event : events){

%>

<tr>

<td>

<%=event.getCustomerName()%>

</td>

<td>

<%=event.getPhone()%>

</td>

<td>

<%=event.getEventTitle()%>

</td>

<td>

<%=event.getEventDate()%>

</td>

<td>

₹ <%=event.getTotalAmount()%>

</td>

<td>

₹ <%=event.getAmountPaid()%>

</td>

<td>

₹ <%=event.getTotalAmount()-event.getAmountPaid()%>

</td>

<td>

<%

String status =
event.getPaymentStatus();

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

<a class="btn"
href="${pageContext.request.contextPath}/event-receive-payment?eventId=<%=event.getEventId()%>">

Receive Payment

</a>

</td>

</tr>

<%

}

%>

</table>

<%

}

%>

</div>

</body>

</html>