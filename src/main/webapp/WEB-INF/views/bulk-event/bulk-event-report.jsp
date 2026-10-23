<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>

<%
Integer bulkEventId = (Integer) request.getAttribute("bulkEventId");

Integer totalFamilies = (Integer) request.getAttribute("totalFamilies");

Integer paidFamilies = (Integer) request.getAttribute("paidFamilies");

Integer pendingFamilies = (Integer) request.getAttribute("pendingFamilies");

Double totalAmount =
(Double) request.getAttribute("totalAmount");

Double collectedAmount =
(Double) request.getAttribute("collectedAmount");

Double pendingAmount =
(Double) request.getAttribute("pendingAmount");

List<BulkEventCustomer> families =
(List<BulkEventCustomer>) request.getAttribute("families");
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Bulk Event Report</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
<style>
.page-header{

display:flex;

justify-content:space-between;

align-items:center;

margin-bottom:25px;

flex-wrap:wrap;

}

.action-buttons{

display:flex;

gap:10px;

}

.btn-print,
.btn-pdf,
.btn-excel{

padding:10px 18px;

border-radius:6px;

text-decoration:none;

color:white;

font-weight:bold;

}

.btn-print{

background:#455A64;

border:none;

cursor:pointer;

}

.btn-pdf{

background:#E53935;

}

.btn-excel{

background:#2E7D32;

}

.btn-print:hover{

background:#37474F;

}

.btn-pdf:hover{

background:#C62828;

}

.btn-excel:hover{

background:#1B5E20;

}
.summary-container{

display:flex;
gap:20px;
margin-bottom:30px;
flex-wrap:wrap;

}

.summary-card{

flex:1;
min-width:220px;

background:white;

padding:20px;

border-radius:10px;

box-shadow:0 2px 6px rgba(0,0,0,0.1);

text-align:center;

}

.summary-card h2{

margin:0;
font-size:30px;
color:#2E7D32;

}

.summary-card p{

margin-top:10px;
font-size:18px;

}

table{

width:100%;

border-collapse:collapse;

background:white;

}

th{

background:#2E7D32;

color:white;

padding:12px;

}

td{

padding:12px;

border-bottom:1px solid #ddd;

text-align:center;

}

.status-paid{

color:green;

font-weight:bold;

}

.status-partial{

color:orange;

font-weight:bold;

}

.status-pending{

color:red;

font-weight:bold;

}
.status-link{

text-decoration:none;

}

.btn-pay{

background:#2E7D32;

color:white;

padding:8px 14px;

border-radius:6px;

text-decoration:none;

font-size:14px;

font-weight:bold;

display:inline-block;

}

.btn-pay:hover{

background:#1B5E20;

}

</style>

</head>

<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<div class="page-header">

<h1>

<i class="fa-solid fa-chart-column"></i>

Bulk Event Report

</h1>

<div class="action-buttons">

<button
class="btn-print"
onclick="window.print()">

<i class="fa-solid fa-print"></i>

Print

</button>

<a
href="${pageContext.request.contextPath}/export-bulk-report-pdf?bulkEventId=<%=bulkEventId%>"
class="btn-pdf">

<i class="fa-solid fa-file-pdf"></i>

PDF

</a>

<a
href="${pageContext.request.contextPath}/export-bulk-report-excel?bulkEventId=<%=bulkEventId%>"
class="btn-excel">

<i class="fa-solid fa-file-excel"></i>

Excel

</a>

</div>

</div>

<div class="summary-container">

<div class="summary-card">

<h2><%= totalFamilies %></h2>

<p>Total Families</p>

</div>

<div class="summary-card">

<h2><%= paidFamilies %></h2>

<p>Paid Families</p>

</div>

<div class="summary-card">

<h2><%= pendingFamilies %></h2>

<p>Pending Families</p>

</div>

<div class="summary-card">

<h2>

₹ <%=String.format("%.2f", totalAmount)%>

</h2>

<p>Total Amount</p>

</div>

<div class="summary-card">

<h2>

₹ <%=String.format("%.2f", collectedAmount)%>

</h2>

<p>Collected Amount</p>

</div>

<div class="summary-card">

<h2>

₹ <%=String.format("%.2f", pendingAmount)%>

</h2>

<p>Pending Amount</p>

</div>

</div>
<div style="margin-bottom:20px;">

<input
type="text"
id="searchInput"
placeholder="🔍 Search Family Name or Phone..."
style="width:350px;
padding:10px;
border:1px solid #ccc;
border-radius:6px;
font-size:15px;">

</div>
<table id="familyTable">

<tr>

<th>Family Name</th>

<th>Phone</th>

<th>Total Amount</th>

<th>Amount Paid</th>

<th>Pending Amount</th>

<th>Status</th>

<th>Action</th>

</tr>

<%

for(BulkEventCustomer family : families){

String status = family.getPaymentStatus();

double pending =
family.getTotalAmount()-family.getAmountPaid();

%>

<tr>

<td><%=family.getCustomerName()%></td>

<td><%=family.getPhone()%></td>

<td>₹ <%=String.format("%.2f",family.getTotalAmount())%></td>

<td>₹ <%=String.format("%.2f",family.getAmountPaid())%></td>

<td>₹ <%=String.format("%.2f",pending)%></td>

<td>

<%

if("PAID".equals(status)){

%>

<span class="status-paid">

PAID

</span>

<%

}else{

%>

<a href="${pageContext.request.contextPath}/bulk-receive-payment?bulkEventId=<%=family.getBulkEventId()%>&customerId=<%=family.getCustomerId()%>&source=bulk-report"
   class="status-link">

<%

if("PARTIAL".equals(status)){

%>

<span class="status-partial">

PARTIAL

</span>

<%

}else{

%>

<span class="status-pending">

PENDING

</span>

<%

}

%>

</a>

<%

}

%>

</td>
<td>

<%

if(!"PAID".equals(status)){

%>

<a href="${pageContext.request.contextPath}/bulk-receive-payment?bulkEventId=<%=family.getBulkEventId()%>&customerId=<%=family.getCustomerId()%>&source=bulk-report"
class="btn-pay">

💰 Receive Payment

</a>

<%

}else{

%>

-

<%

}

%>

</td>
</tr>

<%

}

%>

</table>
</div>
<script>

document.getElementById("searchInput")
.addEventListener("keyup", function () {

    let value =
    this.value.toLowerCase();

    let rows =
    document.querySelectorAll(
    "#familyTable tr");

    for(let i=1;i<rows.length;i++){

        let text =
        rows[i].innerText.toLowerCase();

        if(text.indexOf(value)>-1){

            rows[i].style.display="";

        }else{

            rows[i].style.display="none";

        }

    }

});

</script>
</body>

</html>