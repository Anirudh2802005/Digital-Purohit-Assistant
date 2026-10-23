<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.util.*"%>
<%@ page import="com.digitalpurohit.model.CustomerReport"%>

<%

List<CustomerReport> reports =
(List<CustomerReport>)request.getAttribute("reports");

Integer totalCustomers =
(Integer)request.getAttribute("totalCustomers");

Integer totalEvents =
(Integer)request.getAttribute("totalEvents");

Integer totalBulkEvents =
(Integer)request.getAttribute("totalBulkEvents");

Double totalReceivedAmount =
(Double)request.getAttribute("totalReceivedAmount");

Double totalPendingAmount =
(Double)request.getAttribute("totalPendingAmount");

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Customer Reports</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

body{

    background:#f5f7fa;

}

.page-title{

    margin-bottom:25px;

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

    font-size:17px;

    font-weight:bold;

}

.info-card{

    background:white;

    padding:20px;

    border-radius:10px;

    margin-bottom:25px;

    box-shadow:0 2px 8px rgba(0,0,0,.1);

}

.chart-container{

    display:flex;

    gap:20px;

    margin-top:30px;

    margin-bottom:25px;

    flex-wrap:wrap;

}

.chart-card{

    flex:1;

    min-width:420px;

    background:white;

    padding:20px;

    border-radius:10px;

    box-shadow:0 2px 8px rgba(0,0,0,.1);

}

.search-box{

    width:320px;

    padding:10px;

    border:1px solid #ccc;

    border-radius:6px;

    margin-bottom:20px;

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

    padding:8px 16px;

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

👥 Customer Reports

</h1>

<!-- ==========================
     SUMMARY CARDS
=========================== -->

<div class="summary-container">

    <div class="summary-card">

        <h2><%=totalCustomers%></h2>

        <p>Total Customers</p>

    </div>

    <div class="summary-card">

        <h2><%=totalEvents%></h2>

        <p>Total Events</p>

    </div>

    <div class="summary-card">

        <h2><%=totalBulkEvents%></h2>

        <p>Bulk Events</p>

    </div>

    <div class="summary-card">

        <h2>

            ₹ <%=String.format("%.2f",
            totalReceivedAmount==null?0:totalReceivedAmount)%>

        </h2>

        <p>Received Amount</p>

    </div>

    <div class="summary-card">

        <h2>

            ₹ <%=String.format("%.2f",
            totalPendingAmount==null?0:totalPendingAmount)%>

        </h2>

        <p>Pending Amount</p>

    </div>

</div>

<!-- ==========================
     CUSTOMER REPORT SUMMARY
=========================== -->

<div class="info-card">

<h2 style="margin-top:0;color:#2E7D32;">

📋 Customer Report Summary

</h2>

<table style="width:100%;box-shadow:none;">

<tr>

<td style="text-align:left;border:none;">

<b>Total Customers</b>

</td>

<td style="border:none;">

<%=totalCustomers%>

</td>

<td style="text-align:left;border:none;">

<b>Total Events</b>

</td>

<td style="border:none;">

<%=totalEvents%>

</td>

</tr>

<tr>

<td style="text-align:left;border:none;">

<b>Bulk Events</b>

</td>

<td style="border:none;">

<%=totalBulkEvents%>

</td>

<td style="text-align:left;border:none;">

<b>Total Received</b>

</td>

<td style="border:none;color:#2E7D32;font-weight:bold;">

₹ <%=String.format("%.2f",
totalReceivedAmount==null?0:totalReceivedAmount)%>

</td>

</tr>

<tr>

<td style="text-align:left;border:none;">

<b>Total Pending</b>

</td>

<td style="border:none;color:#C62828;font-weight:bold;">

₹ <%=String.format("%.2f",
totalPendingAmount==null?0:totalPendingAmount)%>

</td>

<td style="border:none;"></td>

<td style="border:none;"></td>

</tr>

</table>

</div>

<!-- ==========================
     SEARCH BOX
=========================== -->

<input
type="text"
id="searchInput"
class="search-box"
placeholder="🔍 Search Customer...">
<!-- ==========================
     CUSTOMER REPORT TABLE
=========================== -->

<table id="customerTable">

<thead>

<tr>

<th>Customer Name</th>

<th>Phone</th>

<th>Events</th>

<th>Bulk Events</th>

<th>Total Amount</th>

<th>Received</th>

<th>Pending</th>

<th>Status</th>

<th>Action</th>

</tr>

</thead>

<tbody>

<%

if(reports != null && !reports.isEmpty()){

for(CustomerReport report : reports){

%>

<tr>

<td>

<b>

<%=report.getCustomerName()%>

</b>

</td>

<td>

<%=report.getPhone()%>

</td>

<td>

<%=report.getTotalEvents()%>

</td>

<td>

<%=report.getTotalBulkEvents()%>

</td>

<td>

₹ <%=String.format("%.2f",
report.getTotalAmount())%>

</td>

<td
style="color:#2E7D32;font-weight:bold;">

₹ <%=String.format("%.2f",
report.getReceivedAmount())%>

</td>

<td
style="color:#C62828;font-weight:bold;">

₹ <%=String.format("%.2f",
report.getPendingAmount())%>

</td>

<td>

<%

if("PAID".equals(report.getPaymentStatus())){

%>

<span class="status-paid">

🟢 PAID

</span>

<%

}else if("PARTIAL".equals(report.getPaymentStatus())){

%>

<span class="status-partial">

🟡 PARTIAL

</span>

<%

}else{

%>

<span class="status-pending">

🔴 PENDING

</span>

<%

}

%>

</td>

<td>

<a
class="btn-view"

href="${pageContext.request.contextPath}/customer-report-details?customerId=<%=report.getCustomerId()%>">

👁 View

</a>

</td>

</tr>

<%

}

}else{

%>

<tr>

<td colspan="9">

No Customer Report Records Found.

</td>

</tr>

<%

}

%>

</tbody>

</table>

<br><br>
<!-- =====================================================
                    BUSINESS ANALYTICS
====================================================== -->

<h2 style="margin-top:40px;
           margin-bottom:20px;
           color:#2E7D32;">

📊 Business Analytics

</h2>

<div class="chart-container">

    <div class="chart-card">

        <h3 style="text-align:center;">

            📈 Customer-wise Received Amount

        </h3>

        <canvas
            id="customerIncomeChart"
            height="120">

        </canvas>

    </div>

    <div class="chart-card">

        <h3 style="text-align:center;">

            🥧 Payment Status Distribution

        </h3>

        <canvas
            id="paymentStatusChart"
            height="120">

        </canvas>

    </div>

</div>

<script>

/* ===========================================
        CUSTOMER INCOME BAR CHART
=========================================== */

const graphLabels=[

<%

List<String> graphLabels =
(List<String>)request.getAttribute("graphLabels");

if(graphLabels!=null){

for(int i=0;i<graphLabels.size();i++){

%>

"<%=graphLabels.get(i)%>"

<%=i<graphLabels.size()-1?",":""%>

<%

}

}

%>

];

const graphValues=[

<%

List<Double> graphValues =
(List<Double>)request.getAttribute("graphValues");

if(graphValues!=null){

for(int i=0;i<graphValues.size();i++){

%>

<%=graphValues.get(i)%>

<%=i<graphValues.size()-1?",":""%>

<%

}

}

%>

];

new Chart(

document.getElementById("customerIncomeChart"),

{

type:"bar",

data:{

labels:graphLabels,

datasets:[{

label:"Received Amount",

data:graphValues,

backgroundColor:"#2E7D32",

borderRadius:8

}]

},

options:{

responsive:true,

plugins:{

legend:{

display:false

}

},

scales:{

y:{

beginAtZero:true

}

}

}

}

);

/* ===========================================
        PAYMENT STATUS CHART
=========================================== */

const paymentLabels=[

<%

Map<String,Integer> paymentStatus =
(Map<String,Integer>)request.getAttribute("paymentStatus");

if(paymentStatus!=null){

int count=0;

for(String key : paymentStatus.keySet()){

%>

"<%=key%>"

<%=count<paymentStatus.size()-1?",":""%>

<%

count++;

}

}

%>

];

const paymentValues=[

<%

if(paymentStatus!=null){

int count2=0;

for(Integer value : paymentStatus.values()){

%>

<%=value%>

<%=count2<paymentStatus.size()-1?",":""%>

<%

count2++;

}

}

%>

];

new Chart(

document.getElementById("paymentStatusChart"),

{

type:"doughnut",

data:{

labels:paymentLabels,

datasets:[{

data:paymentValues,

backgroundColor:[

"#2E7D32",

"#F9A825",

"#C62828"

]

}]

},

options:{

responsive:true,

plugins:{

legend:{

position:"bottom"

}

}

}

});

/* ===========================================
        SEARCH CUSTOMER
=========================================== */

document.getElementById("searchInput")

.addEventListener("keyup",function(){

let value=this.value.toLowerCase();

let rows=document.querySelectorAll(

"#customerTable tbody tr"

);

rows.forEach(function(row){

row.style.display=

row.innerText

.toLowerCase()

.includes(value)

?

""

:

"none";

});

});

</script>

</div>

</body>

</html>