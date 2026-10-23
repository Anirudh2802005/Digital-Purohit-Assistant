<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.EventType"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>View Event Types</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/toast.css">

<style>

.page-header{

display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:30px;

}

.page-header h1{

color:#1F3C88;

}

.search-box{

display:flex;
gap:10px;
margin-bottom:30px;

}

.search-box input{

flex:1;
padding:12px;
border:1px solid #ccc;
border-radius:10px;
font-size:15px;

}

.search-box button{

background:#2C6BED;
color:white;
border:none;
padding:12px 20px;
border-radius:10px;
cursor:pointer;

}

.search-box button:hover{

background:#1F3C88;

}

.card-container{

display:grid;
grid-template-columns:repeat(auto-fill,minmax(320px,1fr));
gap:25px;

}

.type-card{

background:white;
padding:25px;
border-radius:18px;
box-shadow:0 6px 18px rgba(0,0,0,.08);
transition:.3s;

}

.type-card:hover{

transform:translateY(-6px);

}

.type-card h2{

color:#1F3C88;
margin-bottom:15px;

}

.type-card p{

margin-bottom:12px;
color:#555;

}

.badge{

display:inline-block;
padding:6px 14px;
border-radius:20px;
font-size:13px;
font-weight:bold;
color:white;

}

.active{

background:#28a745;

}

.inactive{

background:#dc3545;

}

.actions{

margin-top:20px;
display:flex;
justify-content:space-between;
align-items:center;

}

.btn{

text-decoration:none;
background:#2C6BED;
color:white;
padding:10px 16px;
border-radius:8px;

}

.btn:hover{

background:#1F3C88;

}

.empty{

text-align:center;
padding:40px;
font-size:20px;
color:#888;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<%@ include file="../partials/toast.jsp"%>


<div class="main-content">

<div class="page-header">

<div>

<h1>📋 View Event Types</h1>

<p>Browse and manage all event types.</p>

</div>

<a href="${pageContext.request.contextPath}/event-types">

<button style="padding:10px 18px;cursor:pointer;">

🏠 Dashboard

</button>

</a>

</div>

<form class="search-box"
action="${pageContext.request.contextPath}/view-event-types"
method="get">

<input type="text"
name="keyword"
placeholder="Search Event Type..."
value="<%=request.getParameter("keyword")==null?"":request.getParameter("keyword")%>">

<button type="submit">

🔍 Search

</button>

</form>

<div class="card-container">

<%

List<EventType> eventTypes=
(List<EventType>)request.getAttribute("eventTypes");

if(eventTypes!=null && !eventTypes.isEmpty()){

for(EventType eventType:eventTypes){

%>

<div class="type-card">

<h2>

🏷 <%=eventType.getTypeName()%>

</h2>

<p>

<%=eventType.getDescription()==null?"No Description":eventType.getDescription()%>

</p>

<p>

<%

if(eventType.isActive()){

%>

<span class="badge active">

🟢 Active

</span>

<%

}else{

%>

<span class="badge inactive">

🔴 Inactive

</span>

<%

}

%>

</p>

<div class="actions">

<a class="btn"
href="${pageContext.request.contextPath}/event-type-details?id=<%=eventType.getTypeId()%>">

View Details →

</a>

</div>

</div>

<%

}

}else{

%>

<div class="empty">

No Event Types Found

</div>

<%

}

%>

</div>

</div>

</body>

</html>