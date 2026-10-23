<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.util.*"%>
<%@ page import="com.digitalpurohit.model.BulkEventIncomeReport"%>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>

<%
BulkEventIncomeReport summary =
(BulkEventIncomeReport)request.getAttribute("summary");

List<BulkEventCustomer> families =
(List<BulkEventCustomer>)request.getAttribute("families");

Double totalAmount =
(Double)request.getAttribute("totalAmount");

Double receivedAmount =
(Double)request.getAttribute("receivedAmount");

Double pendingAmount =
(Double)request.getAttribute("pendingAmount");

Double collectionPercentage =
(Double)request.getAttribute("collectionPercentage");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Bulk Event Income Details</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

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

font-size:30px;

color:#2E7D32;

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

.btn-payment{

background:#1976D2;

color:white;

padding:8px 16px;

border-radius:6px;

text-decoration:none;

font-weight:bold;

}

.btn-payment:hover{

background:#0D47A1;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h1 class="page-title">

💰 <%=summary.getBulkEventName()%> Income Report

</h1>
<div class="summary-container">

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

    <div class="summary-card">

        <h2>

            <%=String.format("%.1f",
            collectionPercentage==null?0:collectionPercentage)%>%

        </h2>

        <p>

            Collection %

        </p>

    </div>

</div>
<div class="info-card">

<h2 style="margin-top:0;color:#2E7D32;">

📋 Bulk Event Information

</h2>

<table style="width:100%;box-shadow:none;">

<tr>

<td style="text-align:left;border:none;">

<b>Bulk Event</b>

</td>

<td style="border:none;">

<%=summary.getBulkEventName()%>

</td>

<td style="text-align:left;border:none;">

<b>Total Families</b>

</td>

<td style="border:none;">

<%=summary.getTotalFamilies()%>

</td>

</tr>

<tr>

<td style="text-align:left;border:none;">

<b>Total Amount</b>

</td>

<td style="border:none;">

₹ <%=String.format("%.2f",
totalAmount)%>

</td>

<td style="text-align:left;border:none;">

<b>Collection</b>

</td>

<td style="border:none;">

<%=String.format("%.1f",
collectionPercentage)%>%

</td>

</tr>

<tr>

<td style="text-align:left;border:none;">

<b>Received</b>

</td>

<td style="border:none;color:#2E7D32;font-weight:bold;">

₹ <%=String.format("%.2f",
receivedAmount)%>

</td>

<td style="text-align:left;border:none;">

<b>Pending</b>

</td>

<td style="border:none;color:#C62828;font-weight:bold;">

₹ <%=String.format("%.2f",
pendingAmount)%>

</td>

</tr>

</table>

</div>


<input
type="text"
id="searchInput"
class="search-box"
placeholder="🔍 Search Family...">
<table id="familyTable">

<thead>

<tr>

<th>Family Name</th>

<th>Phone</th>

<th>Total Amount</th>

<th>Received</th>

<th>Pending</th>

<th>Status</th>

<th>Action</th>

</tr>

</thead>

<tbody>

<%

if(families != null && !families.isEmpty()){

for(BulkEventCustomer family : families){

double pending =
family.getTotalAmount()
-
family.getAmountPaid();

%>

<tr>

<td>

<b><%=family.getCustomerName()%></b>

</td>

<td>

<%=family.getPhone()%>

</td>

<td>

₹ <%=String.format("%.2f",
family.getTotalAmount())%>

</td>

<td>

₹ <%=String.format("%.2f",
family.getAmountPaid())%>

</td>

<td style="color:#C62828;font-weight:bold;">

₹ <%=String.format("%.2f",
pending)%>

</td>

<td>

<%

if("PAID".equalsIgnoreCase(family.getPaymentStatus())){

%>

<span class="status-paid">

🟢 PAID

</span>

<%

}else if("PARTIAL".equalsIgnoreCase(family.getPaymentStatus())){

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
        class="btn-payment"
        href="${pageContext.request.contextPath}/bulk-receive-payment?bulkEventId=<%=family.getBulkEventId()%>&customerId=<%=family.getCustomerId()%>&source=bulkIncome">

        💰 Receive Payment

    </a>

</td>

</tr>

<%

}

}else{

%>

<tr>

<td colspan="7">

No Family Records Found.

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
"#familyTable tbody tr");

rows.forEach(function(row){

row.style.display =

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

<h2 style="margin-bottom:20px;color:#2E7D32;">

📊 Business Analytics

</h2>

<div class="chart-container">

    <div class="chart-card">

        <h3 style="text-align:center;">

            📈 Family-wise Income

        </h3>

        <canvas id="incomeTrendChart"
                height="120"></canvas>

    </div>

    <div class="chart-card">

        <h3 style="text-align:center;">

            🥧 Payment Status

        </h3>

        <canvas id="paymentStatusChart"
                height="120"></canvas>

    </div>


</div>
<script>

/* ==========================
   Family Income Graph
========================== */

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

document.getElementById("incomeTrendChart"),

{

type:"bar",

data:{

labels:graphLabels,

datasets:[{

label:"Amount Paid",

data:graphValues,

backgroundColor:"#2E7D32",

borderRadius:6

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



/* ==========================
   Payment Status Graph
========================== */

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

</script>
</body>

</html>
