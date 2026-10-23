<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>

<%
List<BulkEventCustomer> families =
(List<BulkEventCustomer>)request.getAttribute("families");

Integer bulkEventId =
(Integer)request.getAttribute("bulkEventId");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Bulk Event Payments</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

table{

width:100%;
border-collapse:collapse;
background:white;

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

text-align:center;
padding:25px;
font-size:18px;
font-weight:bold;
color:green;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

<h2>Bulk Event Payments</h2>

<table>

<tr>

<th>Family</th>
<th>Phone</th>
<th>Amount Paid</th>
<th>Status</th>
<th>Action</th>

</tr>

<%

if(families==null || families.isEmpty()){

%>

<tr>

<td colspan="5" class="empty">

🎉 No Families Added

</td>

</tr>

<%

}else{

for(BulkEventCustomer family : families){

%>

<tr>

<td><%=family.getCustomerName()%></td>

<td><%=family.getPhone()%></td>

<td>₹ <%=family.getAmountPaid()%></td>

<td>

<%

String bulkStatus =
family.getPaymentStatus();

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

<a class="btn"
href="${pageContext.request.contextPath}/bulk-receive-payment?bulkEventId=<%=bulkEventId%>&customerId=<%=family.getCustomerId()%>"
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