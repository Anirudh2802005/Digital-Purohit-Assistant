<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.util.*"%>

<%
List<String> monthlyLabels =
(List<String>) request.getAttribute("monthlyLabels");

List<Double> monthlyIncome =
(List<Double>) request.getAttribute("monthlyIncome");

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

<title>Business Analytics</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

.page-title{

margin-bottom:30px;

}

.chart-container{

display:grid;

grid-template-columns:repeat(auto-fit,minmax(500px,1fr));

gap:25px;

}

.chart-card{

background:white;

padding:20px;

border-radius:12px;

box-shadow:0 2px 10px rgba(0,0,0,.12);

}

.chart-card h2{

margin-bottom:20px;

text-align:center;

color:#2E7D32;

}

canvas{

width:100%!important;

height:350px!important;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h1 class="page-title">

<i class="fa-solid fa-chart-line"></i>

Business Analytics

</h1>

<div class="chart-container">

<div class="chart-card">

<h2>

Monthly Income Trend

</h2>

<canvas id="incomeChart"></canvas>

</div>

<div class="chart-card">

<h2>

Payment Status Distribution

</h2>

<canvas id="statusChart"></canvas>

</div>

<div class="chart-card">

<h2>

Income By Event Type

</h2>

<canvas id="eventChart"></canvas>

</div>

</div>

</div>

<script>

const monthlyLabels=[

<%

for(int i=0;i<monthlyLabels.size();i++){

%>

"<%=monthlyLabels.get(i)%>"

<%=i<monthlyLabels.size()-1?",":""%>

<%

}

%>

];

const monthlyIncome=[

<%

for(int i=0;i<monthlyIncome.size();i++){

%>

<%=monthlyIncome.get(i)%>

<%=i<monthlyIncome.size()-1?",":""%>

<%

}

%>

];

new Chart(

document.getElementById("incomeChart"),

{

type:"line",

data:{

labels:monthlyLabels,

datasets:[{

label:"Monthly Income",

data:monthlyIncome,

borderColor:"green",

backgroundColor:"rgba(46,125,50,.2)",

fill:true,

tension:.4

}]

},

options:{

responsive:true

}

}

);

const statusLabels=[

<%

int count=0;

for(String key:paymentStatus.keySet()){

%>

"<%=key%>"

<%=count<paymentStatus.size()-1?",":""%>

<%

count++;

}

%>

];

const statusValues=[

<%

count=0;

for(Integer value:paymentStatus.values()){

%>

<%=value%>

<%=count<paymentStatus.size()-1?",":""%>

<%

count++;

}

%>

];

new Chart(

document.getElementById("statusChart"),

{

type:"pie",

data:{

labels:statusLabels,

datasets:[{

data:statusValues,

backgroundColor:[

"#2E7D32",

"#F9A825",

"#C62828"

]

}]

}

}

);

const eventLabels=[

<%

for(int i=0;i<eventTypes.size();i++){

%>

"<%=eventTypes.get(i)%>"

<%=i<eventTypes.size()-1?",":""%>

<%

}

%>

];

const eventIncome=[

<%

for(int i=0;i<eventIncome.size();i++){

%>

<%=eventIncome.get(i)%>

<%=i<eventIncome.size()-1?",":""%>

<%

}

%>

];

new Chart(

document.getElementById("eventChart"),

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

</script>

</body>

</html>