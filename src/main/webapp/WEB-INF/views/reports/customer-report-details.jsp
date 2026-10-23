<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.util.*"%>
<%@ page import="com.digitalpurohit.model.CustomerReportDetails"%>
<%@ page import="com.digitalpurohit.model.Event"%>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>

<%

CustomerReportDetails customer =
(CustomerReportDetails)request.getAttribute("customer");

List<Event> events =
(List<Event>)request.getAttribute("events");

List<BulkEventCustomer> bulkEvents =
(List<BulkEventCustomer>)request.getAttribute("bulkEvents");

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Customer Report Details</title>

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

text-align:center;

box-shadow:0 2px 8px rgba(0,0,0,.1);

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

table{

width:100%;

border-collapse:collapse;

background:white;

box-shadow:0 2px 8px rgba(0,0,0,.1);

margin-bottom:30px;

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

.chart-container{

display:flex;

gap:20px;

flex-wrap:wrap;

margin-top:30px;

}

.chart-card{

flex:1;

min-width:420px;

background:white;

padding:20px;

border-radius:10px;

box-shadow:0 2px 8px rgba(0,0,0,.1);

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

</style>

</head>
<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h1 class="page-title">

👤 Customer Report Details

</h1>

<!-- ===========================================
            SUMMARY CARDS
=========================================== -->

<div class="summary-container">

    <div class="summary-card">

        <h2>

            <%=customer.getTotalEvents()%>

        </h2>

        <p>

            Total Events

        </p>

    </div>

    <div class="summary-card">

        <h2>

            <%=customer.getTotalBulkEvents()%>

        </h2>

        <p>

            Bulk Events

        </p>

    </div>

    <div class="summary-card">

        <h2>

            ₹ <%=String.format("%.2f",
            customer.getTotalAmount())%>

        </h2>

        <p>

            Total Amount

        </p>

    </div>

    <div class="summary-card">

        <h2>

            ₹ <%=String.format("%.2f",
            customer.getReceivedAmount())%>

        </h2>

        <p>

            Received

        </p>

    </div>

    <div class="summary-card">

        <h2>

            ₹ <%=String.format("%.2f",
            customer.getPendingAmount())%>

        </h2>

        <p>

            Pending

        </p>

    </div>

</div>

<!-- ===========================================
            CUSTOMER INFORMATION
=========================================== -->

<div class="info-card">

<h2 style="margin-top:0;color:#2E7D32;">

📋 Customer Information

</h2>

<table style="width:100%;box-shadow:none;">

<tr>

<td style="text-align:left;border:none;">

<b>Customer Name</b>

</td>

<td style="border:none;">

<%=customer.getCustomerName()%>

</td>

<td style="text-align:left;border:none;">

<b>Phone</b>

</td>

<td style="border:none;">

<%=customer.getPhone()%>

</td>

</tr>

<tr>

<td style="text-align:left;border:none;">

<b>Address</b>

</td>

<td style="border:none;">

<%=customer.getAddress()==null?"-":customer.getAddress()%>

</td>

<td style="text-align:left;border:none;">

<b>Gothram</b>

</td>

<td style="border:none;">

<%=customer.getGothram()==null?"-":customer.getGothram()%>

</td>

</tr>

<tr>

<td style="text-align:left;border:none;">

<b>Total Events</b>

</td>

<td style="border:none;">

<%=customer.getTotalEvents()%>

</td>

<td style="text-align:left;border:none;">

<b>Bulk Events</b>

</td>

<td style="border:none;">

<%=customer.getTotalBulkEvents()%>

</td>

</tr>

<tr>

<td style="text-align:left;border:none;">

<b>Total Received</b>

</td>

<td style="border:none;color:#2E7D32;font-weight:bold;">

₹ <%=String.format("%.2f",
customer.getReceivedAmount())%>

</td>

<td style="text-align:left;border:none;">

<b>Pending</b>

</td>

<td style="border:none;color:#C62828;font-weight:bold;">

₹ <%=String.format("%.2f",
customer.getPendingAmount())%>

</td>

</tr>

</table>

</div>
<!-- ===========================================
                EVENT HISTORY
=========================================== -->

<h2 style="margin-bottom:20px;color:#2E7D32;">

📅 Event History

</h2>

<table>

<thead>

<tr>

<th>Event Title</th>

<th>Event Type</th>

<th>Date</th>

<th>Location</th>

<th>Total Amount</th>

<th>Received</th>

<th>Pending</th>

<th>Status</th>

</tr>

</thead>

<tbody>

<%

if(events!=null && !events.isEmpty()){

for(Event event : events){

double pending =
event.getTotalAmount()
-
event.getAmountPaid();

%>

<tr>

<td>

<b>

<%=event.getEventTitle()%>

</b>

</td>

<td>

<%=event.getEventTypeName()%>

</td>

<td>

<%=event.getEventDate()%>

</td>

<td>

<%=event.getLocation()==null?"-":event.getLocation()%>

</td>

<td>

₹ <%=String.format("%.2f",
event.getTotalAmount())%>

</td>

<td style="color:#2E7D32;font-weight:bold;">

₹ <%=String.format("%.2f",
event.getAmountPaid())%>

</td>

<td style="color:#C62828;font-weight:bold;">

₹ <%=String.format("%.2f",
pending)%>

</td>

<td>

<%

if("PAID".equalsIgnoreCase(event.getPaymentStatus())){

%>

<span class="status-paid">

🟢 PAID

</span>

<%

}else if("PARTIAL".equalsIgnoreCase(event.getPaymentStatus())){

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

</tr>

<%

}

}else{

%>

<tr>

<td colspan="8">

No Event History Found.

</td>

</tr>

<%

}

%>

</tbody>

</table>
<!-- ===========================================
                BULK EVENT HISTORY
=========================================== -->

<h2 style="margin-bottom:20px;color:#2E7D32;">

👨‍👩‍👧 Bulk Event History

</h2>

<table>

<thead>

<tr>

<th>Bulk Event</th>

<th>Start Date</th>

<th>End Date</th>

<th>Location</th>

<th>Total Amount</th>

<th>Received</th>

<th>Pending</th>

<th>Status</th>

</tr>

</thead>

<tbody>

<%

if(bulkEvents!=null && !bulkEvents.isEmpty()){

for(BulkEventCustomer bulk : bulkEvents){

double pending =
bulk.getTotalAmount()
-
bulk.getAmountPaid();

%>

<tr>

<td>

<b>

<%=bulk.getBulkEventName()%>

</b>

</td>

<td>

<%=bulk.getStartDate()%>

</td>

<td>

<%=bulk.getEndDate()==null?"-":bulk.getEndDate()%>

</td>

<td>

<%=bulk.getLocation()==null?"-":bulk.getLocation()%>

</td>

<td>

₹ <%=String.format("%.2f",
bulk.getTotalAmount())%>

</td>

<td
style="color:#2E7D32;font-weight:bold;">

₹ <%=String.format("%.2f",
bulk.getAmountPaid())%>

</td>

<td
style="color:#C62828;font-weight:bold;">

₹ <%=String.format("%.2f",
pending)%>

</td>

<td>

<%

if("PAID".equalsIgnoreCase(
bulk.getPaymentStatus())){

%>

<span class="status-paid">

🟢 PAID

</span>

<%

}else if("PARTIAL".equalsIgnoreCase(
bulk.getPaymentStatus())){

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

</tr>

<%

}

}else{

%>

<tr>

<td colspan="8">

No Bulk Event History Found.

</td>

</tr>

<%

}

%>

</tbody>

</table>
<!-- ===========================================
                BUSINESS ANALYTICS
=========================================== -->

<h2 style="margin-top:40px;
           margin-bottom:20px;
           color:#2E7D32;">

📊 Business Analytics

</h2>

<div class="chart-container">

    <div class="chart-card">

        <h3 style="text-align:center;">

            📈 Customer-wise Income

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
        BAR CHART
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

</script>

</div>

</body>

</html>