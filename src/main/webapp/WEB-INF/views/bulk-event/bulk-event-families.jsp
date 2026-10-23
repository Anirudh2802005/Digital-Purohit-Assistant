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

<title>Bulk Event Families</title>
<div class="toolbar">

    <form action="${pageContext.request.contextPath}/bulk-event-families"
          method="get"
          class="search-form">

        <input type="hidden"
               name="bulkEventId"
               value="${bulkEventId}">

        <input
            type="text"
            name="keyword"
            placeholder="Search by Name, Phone or Gothram"
            value="${param.keyword}">

        <button type="submit">

            🔍 Search

        </button>

    </form>

    <div class="toolbar-buttons">

        <a href="${pageContext.request.contextPath}/add-existing-customer?bulkEventId=${bulkEventId}"
           class="btn btn-primary">

            ➕ Add Existing Customer

        </a>

        <a href="${pageContext.request.contextPath}/add-customer?bulkEventId=${bulkEventId}"
           class="btn btn-success">

            👤 New Customer

        </a>

    </div>

</div>
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

background:#2c6bed;
color:white;

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

.btn{

padding:8px 15px;
border-radius:5px;
background:#28a745;
color:white;
text-decoration:none;
font-weight:bold;

}

.btn:hover{

background:#218838;

}

.back{

display:inline-block;
margin-bottom:20px;
text-decoration:none;
font-weight:bold;

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

<h2>👨‍👩‍👧‍👦 Families</h2>

<a class="back"
href="${pageContext.request.contextPath}/bulk-event-details?id=<%=bulkEventId%>">

← Back to Group Event

</a>

<br><br>

<table>

<tr>

<th>Family</th>
<th>Phone</th>
<th>Address</th>
<th>Gothram</th>
<th>Total</th>
<th>Paid</th>
<th>Due</th>
<th>Status</th>
<th>Action</th>

</tr>

<%

if(families==null || families.isEmpty()){

%>

<tr>

<td colspan="9" class="empty">

🎉 No Families Added Yet

</td>

</tr>

<%

}else{

for(BulkEventCustomer family : families){

double due =
family.getTotalAmount() - family.getAmountPaid();

%>

<tr>

<td><%=family.getCustomerName()%></td>

<td><%=family.getPhone()%></td>

<td><%=family.getAddress()%></td>

<td><%=family.getGothram()%></td>

<td>₹ <%=family.getTotalAmount()%></td>

<td>₹ <%=family.getAmountPaid()%></td>

<td>₹ <%=due%></td>

<td>

<%

String status =
family.getPaymentStatus();

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
href="${pageContext.request.contextPath}/bulk-receive-payment?bulkEventId=<%=family.getBulkEventId()%>&customerId=<%=family.getCustomerId()%>">

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