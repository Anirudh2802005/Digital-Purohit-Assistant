<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.BulkEventReport"%>

<%
List<BulkEventReport> reports =
(List<BulkEventReport>)request.getAttribute("reports");
Integer totalBulkEvents =
(Integer)request.getAttribute("totalBulkEvents");

Integer totalFamilies =
(Integer)request.getAttribute("totalFamilies");

Double totalAmount =
(Double)request.getAttribute("totalAmount");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Bulk Event Reports</title>
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

.page-title{

margin-bottom:20px;

}

.top-bar{

display:flex;

justify-content:space-between;

align-items:center;

margin-bottom:20px;

flex-wrap:wrap;

gap:15px;

}

.search-box{

padding:10px;

width:320px;

border:1px solid #ccc;

border-radius:6px;

font-size:15px;

}
.summary-container{

display:flex;

gap:20px;

margin-bottom:25px;

flex-wrap:wrap;

}

.summary-card{

flex:1;

min-width:220px;

background:white;

padding:20px;

border-radius:10px;

box-shadow:0 2px 8px rgba(0,0,0,.1);

text-align:center;

}

.summary-card h2{

margin:0;

color:#2E7D32;

font-size:30px;

}

.summary-card p{

margin-top:10px;

font-size:18px;

}

table{

width:100%;

border-collapse:collapse;

background:white;

box-shadow:0 2px 8px rgba(0,0,0,.1);

}

th{

background:#2E7D32;

color:white;

padding:14px;

}

td{

padding:14px;

text-align:center;

border-bottom:1px solid #ddd;

}

.btn-report{

background:#1976D2;

color:white;

padding:8px 16px;

border-radius:6px;

text-decoration:none;

font-weight:bold;

}

.btn-report:hover{

background:#125ea8;

}
.btn-action{

background:#2E7D32;

color:white;

padding:10px 18px;

border:none;

border-radius:6px;

text-decoration:none;

cursor:pointer;

font-size:14px;

margin-left:10px;

}

.btn-action:hover{

background:#1B5E20;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h1 class="page-title">

📊 Bulk Event Reports

</h1>
<div class="summary-container">

<div class="summary-card">

<h2>

<%=totalBulkEvents%>

</h2>

<p>

Bulk Events

</p>

</div>

<div class="summary-card">

<h2>

<%=totalFamilies%>

</h2>

<p>

Total Families

</p>

</div>

<div class="summary-card">

<h2>

₹ <%=String.format("%.2f",totalAmount)%>

</h2>

<p>

Total Amount

</p>

</div>

</div>
<div class="top-bar">

<input
type="text"
id="searchInput"
class="search-box"
placeholder="Search Bulk Event...">

<div>

<button
class="btn-action"
onclick="window.print()">

<i class="fa-solid fa-print"></i> Print

</button>

<a
href="${pageContext.request.contextPath}/export-bulk-event-pdf"
class="btn-action">

<i class="fa-solid fa-file-pdf"></i> PDF

</a>
<a
href="${pageContext.request.contextPath}/export-bulk-event-excel"
class="btn-action">

<i class="fa-solid fa-file-excel"></i> Excel

</a>

</div>

</div>



<table id="reportTable">

<thead>

<tr>

<th>Bulk Event</th>

<th>Start Date</th>

<th>End Date</th>

<th>Total Families</th>

<th>Total Amount</th>

<th>Action</th>

</tr>

</thead>

<tbody>

<%

if(reports!=null && !reports.isEmpty()){

for(BulkEventReport report : reports){

%>

<tr>

<td>

<%=report.getBulkEventName()%>

</td>

<td>

<%=report.getStartDate()%>

</td>

<td>

<%=report.getEndDate()%>

</td>

<td>

<%=report.getTotalFamilies()%>

</td>

<td>

₹ <%=String.format("%.2f",
report.getTotalAmount())%>

</td>

<td>

<a
class="btn-report"
href="${pageContext.request.contextPath}/bulk-event-report?bulkEventId=<%=report.getBulkEventId()%>">

📊 View Report

</a>

</td>

</tr>

<%

}

}else{

%>

<tr>

<td colspan="6">

No Bulk Events Found.

</td>

</tr>

<%

}

%>

</tbody>

</table>

</div>

<script>

document.getElementById("searchInput")

.addEventListener("keyup",function(){

let value=this.value.toLowerCase();

let rows=document.querySelectorAll("#reportTable tbody tr");

rows.forEach(function(row){

row.style.display=

row.innerText.toLowerCase().includes(value)

? ""

: "none";

});

});

</script>

</body>

</html>