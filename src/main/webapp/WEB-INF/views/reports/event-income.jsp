<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.IncomeReport"%>

<%
List<IncomeReport> reports =
(List<IncomeReport>)request.getAttribute("reports");

Double todayIncome =
(Double)request.getAttribute("todayIncome");

Double monthlyIncome =
(Double)request.getAttribute("monthlyIncome");

List<Double> graphValues =
(List<Double>)request.getAttribute("graphValues");
Double yearlyIncome =
(Double)request.getAttribute("yearlyIncome");

Double customIncome =
(Double)request.getAttribute("customIncome");

Double receivedAmount =
(Double)request.getAttribute("receivedAmount");

Double pendingAmount =
(Double)request.getAttribute("pendingAmount");
%>
<%
List<String> graphLabels =
(List<String>)request.getAttribute("graphLabels");




Map<String,Integer> paymentStatus =
(Map<String,Integer>) request.getAttribute("paymentStatus");

List<String> eventTypes =
(List<String>) request.getAttribute("eventTypes");

List<Double> eventIncome =
(List<Double>) request.getAttribute("eventIncome");
%>
<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Event Income Reports</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

<script
src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

.page-title{

display:flex;

justify-content:space-between;

align-items:center;

margin-bottom:25px;

}

.summary-container{

display:grid;

grid-template-columns:repeat(3,1fr);

gap:20px;

margin-bottom:30px;

}

.summary-card{

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

font-size:18px;

color:#444;

}

.filter-bar{

display:flex;

flex-wrap:wrap;

gap:12px;

align-items:center;

margin-bottom:25px;

}

.filter-btn{

background:#2E7D32;

color:white;

padding:10px 18px;

border-radius:6px;

text-decoration:none;

font-weight:bold;

}

.filter-btn:hover{

background:#1B5E20;

}

.search-box{

padding:10px;

width:320px;

border:1px solid #ccc;

border-radius:6px;

font-size:15px;

}

.custom-date{

padding:10px;

border:1px solid #ccc;

border-radius:6px;

}

.btn-generate{

background:#1976D2;

color:white;

padding:10px 18px;

border:none;

border-radius:6px;

cursor:pointer;

font-weight:bold;

}

.btn-generate:hover{

background:#125EA8;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<div class="page-title">

<h1>

<i class="fa-solid fa-indian-rupee-sign"></i>

Event Income Reports

</h1>

</div>

<div class="summary-container">

<div class="summary-card">

<h2>

₹ <%=String.format("%.2f",
todayIncome==null?0:todayIncome)%>

</h2>

<p>

Today's Income

</p>

</div>

<div class="summary-card">

<h2>

₹ <%=String.format("%.2f",
monthlyIncome==null?0:monthlyIncome)%>

</h2>

<p>

Monthly Income

</p>

</div>

<div class="summary-card">

<h2>

₹ <%=String.format("%.2f",
yearlyIncome==null?0:yearlyIncome)%>

</h2>

<p>

Annual Income

</p>

</div>

<div class="summary-card">

<h2>

₹ <%=String.format("%.2f",
customIncome==null?0:customIncome)%>

</h2>

<p>

Custom Date Income

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

<div class="filter-bar">

<a class="filter-btn"
href="${pageContext.request.contextPath}/event-income?type=today">

Today

</a>

<a class="filter-btn"
href="${pageContext.request.contextPath}/event-income?type=month">

Monthly

</a>

<a class="filter-btn"
href="${pageContext.request.contextPath}/event-income?type=year">

Annual

</a>

<form
action="${pageContext.request.contextPath}/event-income"
method="get"
style="display:flex;gap:10px;align-items:center;">

<input
type="hidden"
name="type"
value="custom">

<input
type="date"
name="fromDate"
class="custom-date">

<input
type="date"
name="toDate"
class="custom-date">

<button
class="btn-generate"
type="submit">

Generate

</button>

</form>

<input
type="text"
id="searchInput"
class="search-box"
placeholder="Search Customer or Event">

</div>
<style>

.table-container{

background:white;

border-radius:10px;

box-shadow:0 2px 8px rgba(0,0,0,.1);

overflow:hidden;

margin-bottom:40px;

}

table{

width:100%;

border-collapse:collapse;

}

th{

background:#2E7D32;

color:white;

padding:14px;

text-align:center;

}

td{

padding:14px;

text-align:center;

border-bottom:1px solid #e5e5e5;

}

tr:hover{

background:#f8f9fa;

}

.status{

padding:6px 12px;

border-radius:20px;

font-size:13px;

font-weight:bold;

display:inline-block;

}

.paid{

background:#d4edda;

color:#155724;

}

.partial{

background:#fff3cd;

color:#856404;

}

.pending{

background:#f8d7da;

color:#721c24;

}

.status-link{

text-decoration:none;

}

.btn-payment{

background:#2E7D32;

color:white;

padding:8px 14px;

border-radius:6px;

text-decoration:none;

font-size:14px;

font-weight:bold;

display:inline-block;

}

.btn-payment:hover{

background:#1B5E20;

}

.section-title{

margin-bottom:15px;

margin-top:10px;

}

</style>

<h2 class="section-title">

Income Details

</h2>

<div class="table-container">

<table id="incomeTable">

<thead>

<tr>

<th>Date</th>

<th>Customer</th>

<th>Event</th>

<th>Total Amount</th>

<th>Amount Paid</th>

<th>Pending</th>

<th>Status</th>

<th>Action</th>

</tr>

</thead>

<tbody>

<%

if(reports!=null && !reports.isEmpty()){

for(IncomeReport report : reports){

String status = report.getPaymentStatus();

%>

<tr>

<td>

<%=report.getEventDate()%>

</td>

<td>

<%=report.getCustomerName()%>

</td>

<td>

<%=report.getEventTitle()%>

</td>

<td>

₹ <%=String.format("%.2f",
report.getTotalAmount())%>

</td>

<td>

₹ <%=String.format("%.2f",
report.getAmountPaid())%>

</td>

<td>

₹ <%=String.format("%.2f",
report.getPendingAmount())%>

</td>

<td>

<%

if("PAID".equals(status)){

%>

<span class="status paid">

Paid

</span>

<%

}else{

%>

<a
class="status-link"
href="${pageContext.request.contextPath}/event-receive-payment?eventId=<%=report.getEventId()%>&source=income">

<span class="status <%=status.toLowerCase()%>">

<%=status%>

</span>

</a>

<%

}

%>

</td>

<td>

<%

if(!"PAID".equals(status)){

%>

<a
class="btn-payment"
href="${pageContext.request.contextPath}/event-receive-payment?eventId=<%=report.getEventId()%>&source=income">

💰 Receive Payment

</a>

<%

}else{

%>

—

<%

}

%>

</td>

</tr>

<%

}

}else{

%>

<tr>

<td colspan="8"
style="padding:30px;">

No Income Records Found.

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

let rows=document.querySelectorAll(

"#incomeTable tbody tr");

rows.forEach(function(row){

row.style.display=

row.innerText.toLowerCase().includes(value)

? ""

: "none";

});

});

</script>
<!-- ========================= -->
<!-- BUSINESS ANALYTICS -->
<!-- ========================= -->

<style>

.analytics-title{

margin-top:40px;

margin-bottom:20px;

}

.analytics-grid{

display:grid;

grid-template-columns:repeat(2,1fr);

gap:25px;

margin-bottom:30px;

}

.chart-card{

background:white;

padding:20px;

border-radius:10px;

box-shadow:0 2px 8px rgba(0,0,0,.10);

}

.chart-card h3{

margin-bottom:20px;

text-align:center;

color:#2E7D32;

}

.chart-full{

grid-column:1/3;

}

canvas{

width:100%!important;

height:320px!important;

}

</style>

<h2 class="analytics-title">

📊 Business Analytics

</h2>

<div class="analytics-grid">

<div class="chart-card chart-full">

<h3>

Monthly Income Trend

</h3>

<canvas id="incomeTrendChart"></canvas>

</div>

<div class="chart-card">

<h3>

Income by Event Type

</h3>

<canvas id="eventIncomeChart"></canvas>

</div>

<div class="chart-card">

<h3>

Payment Status Distribution

</h3>

<canvas id="paymentStatusChart"></canvas>

</div>

</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>

/* ===========================
   Dynamic Income Trend
=========================== */

const graphLabels = [

<%

if(graphLabels != null){

    for(int i=0;i<graphLabels.size();i++){

%>

"<%=graphLabels.get(i)%>"

<%=i<graphLabels.size()-1?",":""%>

<%

    }

}

%>

];

const graphValues = [

<%

if(graphValues != null){

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

type:"line",

data:{

labels:graphLabels,

datasets:[{

label:"Income",

data:graphValues,

borderColor:"#2E7D32",

backgroundColor:"rgba(46,125,50,.15)",

fill:true,

tension:.4,

borderWidth:3

}]

},

options:{

responsive:true,

plugins:{

legend:{

display:true

}

}

}

}

);


/* ===========================
   Event Type Income
=========================== */

const eventLabels = [

<%

if(eventTypes != null){

for(int i=0;i<eventTypes.size();i++){

%>

"<%=eventTypes.get(i)%>"

<%=i<eventTypes.size()-1?",":""%>

<%

}

}

%>

];

const eventIncome = [

<%

if(eventIncome != null){

for(int i=0;i<eventIncome.size();i++){

%>

<%=eventIncome.get(i)%>

<%=i<eventIncome.size()-1?",":""%>

<%

}

}

%>

];

new Chart(

document.getElementById("eventIncomeChart"),

{

type:"bar",

data:{

labels:eventLabels,

datasets:[{

label:"Income",

data:eventIncome,

backgroundColor:"#1976D2"

}]

},

options:{

responsive:true,

plugins:{

legend:{

display:false

}

}

}

}

);


/* ===========================
   Payment Status Pie Chart
=========================== */

const paymentLabels = [

<%

if(paymentStatus != null){

int c=0;

for(String key : paymentStatus.keySet()){

%>

"<%=key%>"

<%=c<paymentStatus.size()-1?",":""%>

<%

c++;

}

}

%>

];

const paymentValues = [

<%

if(paymentStatus != null){

int c2=0;

for(Integer value : paymentStatus.values()){

%>

<%=value%>

<%=c2<paymentStatus.size()-1?",":""%>

<%

c2++;

}

}

%>

];

new Chart(

document.getElementById("paymentStatusChart"),

{

type:"pie",

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

responsive:true

}

}

);

</script>



</body>

</html>