<%@ page contentType="text/html;charset=UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Income Reports</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

<style>

.cards{

display:flex;

gap:30px;

justify-content:center;

margin-top:60px;

flex-wrap:wrap;

}

.card{

width:320px;

background:white;

border-radius:12px;

padding:35px;

text-align:center;

box-shadow:0 2px 12px rgba(0,0,0,.15);

transition:.3s;

text-decoration:none;

color:#333;

}

.card:hover{

transform:translateY(-8px);

}

.card i{

font-size:55px;

color:#2E7D32;

margin-bottom:20px;

}

.card h2{

margin-bottom:15px;

}

.card p{

color:#666;

line-height:28px;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h1>

<i class="fa-solid fa-indian-rupee-sign"></i>

Income Reports

</h1>

<div class="cards">

<a class="card"
href="${pageContext.request.contextPath}/event-income">

<i class="fa-solid fa-chart-line"></i>

<h2>Event Income</h2>

<p>

Today's Income<br>
Monthly Income<br>
Annual Income<br>
Custom Reports

</p>

</a>

<a class="card"
href="${pageContext.request.contextPath}/bulk-event-income">

<i class="fa-solid fa-chart-pie"></i>

<h2>Bulk Event Income</h2>

<p>

Kasi Yatra<br>
Karthika Masam<br>
All Bulk Events

</p>

</a>
</div>

</div>

</body>

</html>