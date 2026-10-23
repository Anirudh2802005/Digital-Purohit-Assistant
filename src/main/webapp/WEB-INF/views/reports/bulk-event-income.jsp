<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.BulkEventIncomeReport"%>

<%

List<BulkEventIncomeReport> reports =
(List<BulkEventIncomeReport>)request.getAttribute("reports");

Integer totalBulkEvents =
(Integer)request.getAttribute("totalBulkEvents");

Integer totalFamilies =
(Integer)request.getAttribute("totalFamilies");

Double totalAmount =
(Double)request.getAttribute("totalAmount");

Double receivedAmount =
(Double)request.getAttribute("receivedAmount");

Double pendingAmount =
(Double)request.getAttribute("pendingAmount");

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Bulk Event Income Reports</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

.page-title{

margin-bottom:20px;

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

.status-paid{

color:#2E7D32;

font-weight:bold;

}

.status-partial{

color:#F9A825;

font-weight:bold;

}

.status-pending{

color:#C62828;

font-weight:bold;

}

.btn-view{

background:#1976D2;

color:white;

padding:8px 15px;

border-radius:6px;

text-decoration:none;

font-weight:bold;

}

.btn-view:hover{

background:#0D47A1;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h1 class="page-title">

💰 Bulk Event Income Reports

</h1>
<div class="summary-container">

    <div class="summary-card">

        <h2>

            <%=totalBulkEvents%>

        </h2>

        <p>

            Total Bulk Events

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

            ₹ <%=String.format("%.2f",
            totalAmount==null?0:totalAmount)%>

        </h2>

        <p>

            Total Amount

        </p>

    </div>

    <div class="summary-card">

        <h2>

            ₹ <%=String.format("%.2f",
            receivedAmount==null?0:receivedAmount)%>

        </h2>

        <p>

            Received Amount

        </p>

    </div>

    <div class="summary-card">

        <h2>

            ₹ <%=String.format("%.2f",
            pendingAmount==null?0:pendingAmount)%>

        </h2>

        <p>

            Pending Amount

        </p>

    </div>

</div>

<div class="top-bar">

    <input
    type="text"
    id="searchInput"
    class="search-box"
    placeholder="Search Bulk Event...">

</div>
<table id="incomeTable">

<thead>

<tr>

<th>Bulk Event</th>

<th>Total Families</th>

<th>Total Amount</th>

<th>Received</th>

<th>Pending</th>

<th>Status</th>

<th>Action</th>

</tr>

</thead>

<tbody>

<%

if(reports!=null && !reports.isEmpty()){

for(BulkEventIncomeReport report : reports){

%>

<tr>

<td>

<b><%=report.getBulkEventName()%></b>

</td>

<td>

<%=report.getTotalFamilies()%>

</td>

<td>

₹ <%=String.format("%.2f",
report.getTotalAmount())%>

</td>

<td>

₹ <%=String.format("%.2f",
report.getReceivedAmount())%>

</td>

<td>

₹ <%=String.format("%.2f",
report.getPendingAmount())%>

</td>

<td>

<%

if("PAID".equals(report.getPaymentStatus())){

%>

<span class="status-paid">

PAID

</span>

<%

}else if("PARTIAL".equals(report.getPaymentStatus())){

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

</td>

<td>

<a
class="btn-view"
href="${pageContext.request.contextPath}/bulk-event-income-details?bulkEventId=<%=report.getBulkEventId()%>">

💰 View Income

</a>

</td>

</tr>

<%

}

}else{

%>

<tr>

<td colspan="7">

No Bulk Event Income Records Found.

</td>

</tr>

<%

}

%>

</tbody>

</table>
<script>

document.getElementById("searchInput")

.addEventListener("keyup",function(){

    let value =
    this.value.toLowerCase();

    let rows =
    document.querySelectorAll(
    "#incomeTable tbody tr");

    rows.forEach(function(row){

        row.style.display=

        row.innerText
        .toLowerCase()
        .includes(value)

        ? ""

        : "none";

    });

});

</script>

</div>

</body>

</html>
