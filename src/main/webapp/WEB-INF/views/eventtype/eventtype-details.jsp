<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.digitalpurohit.model.EventType"%>

<%
EventType eventType =
(EventType) request.getAttribute("eventType");

Integer eventCount =
(Integer) request.getAttribute("eventCount");

Integer samagriCount =
(Integer) request.getAttribute("samagriCount");
Double totalIncome =
(Double)request.getAttribute("totalIncome");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Event Type Details</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/toast.css">

<style>

.page-header{
display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:25px;
}

.page-header h1{
margin:0;
color:#1F3C88;
}

.hero-card{
background:#fff;
border-radius:18px;
padding:30px;
box-shadow:0 5px 15px rgba(0,0,0,.08);
margin-bottom:25px;
}

.hero-card h2{
margin:0;
color:#1F3C88;
font-size:28px;
}

.hero-card p{
margin-top:15px;
font-size:16px;
color:#555;
line-height:1.6;
}

.badge{
display:inline-block;
padding:8px 18px;
border-radius:25px;
color:#fff;
font-weight:bold;
margin-top:15px;
}

.active{
background:#28a745;
}

.inactive{
background:#dc3545;
}

.stats{
display:grid;
grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
gap:20px;
margin-bottom:25px;
}

.stat-card{
background:#fff;
padding:25px;
border-radius:15px;
box-shadow:0 5px 15px rgba(0,0,0,.08);
text-align:center;
}

.stat-card h2{
margin:0;
color:#2C6BED;
font-size:28px;
}

.stat-card p{
margin-top:10px;
color:#666;
}

.details-layout{
    display:grid;
    grid-template-columns:2fr 1fr;
    gap:25px;
    margin-top:25px;
}

@media(max-width:900px){

    .details-layout{

        grid-template-columns:1fr;

    }

}

.section h2{
margin-top:0;
color:#1F3C88;
margin-bottom:20px;
}

.action-buttons{
display:flex;
flex-wrap:wrap;
gap:15px;
}

.btn{
display:inline-block;
padding:12px 22px;
border-radius:8px;
text-decoration:none;
color:#fff;
font-weight:bold;
transition:.3s;
}

.blue{
background:#2C6BED;
}

.green{
background:#28a745;
}

.orange{
background:#ff9800;
}

.red{
background:#dc3545;
}

.gray{
background:#6c757d;
}

.btn:hover{
opacity:.9;
transform:translateY(-2px);
}

.info-table{
width:100%;
border-collapse:collapse;
}

.info-table td{
padding:12px;
border-bottom:1px solid #eee;
}

.info-table td:first-child{
font-weight:bold;
width:180px;
color:#444;
}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<%@ include file="../partials/toast.jsp"%>

<div class="main-content">

<div class="page-header">

<h1>🏷 Event Type Details</h1>

<a href="${pageContext.request.contextPath}/view-event-types"
class="btn gray">

← Back

</a>

</div>

<div class="hero-card">

<h2>

<%=eventType.getTypeName()%>

</h2>

<p>

<%=eventType.getDescription()==null ?
"No Description Available" :
eventType.getDescription()%>

</p>

<% if(eventType.isActive()){ %>

<span class="badge active">

🟢 Active

</span>

<% } else { %>

<span class="badge inactive">

🔴 Inactive

</span>

<% } %>

</div>

<div class="stats">

<div class="stat-card">

<h2>

<%=eventCount==null?0:eventCount%>

</h2>

<p>

Events Using This Type

</p>

</div>

<div class="stat-card">

<h2>

<%=samagriCount==null?0:samagriCount%>

</h2>

<p>

Assigned Samagri

</p>

</div>

<div class="stat-card">

<h2>

₹ <%=String.format("%.2f",
totalIncome==null?0:totalIncome)%>

</h2>

<p>

Total Income Generated

</p>

</div>
</div>

<div class="section">

<h2>📋 Information</h2>

<table class="info-table">

<tr>

<td>Event Type ID</td>

<td><%=eventType.getTypeId()%></td>

</tr>

<tr>

<td>Name</td>

<td><%=eventType.getTypeName()%></td>

</tr>

<tr>

<td>Description</td>

<td>

<%=eventType.getDescription()==null ?
"-" :
eventType.getDescription()%>

</td>

</tr>

<tr>

<td>Status</td>

<td>

<%=eventType.isActive() ?
"Active" :
"Inactive"%>

</td>

</tr>

<tr>

<td>Created On</td>

<td>

<%=eventType.getCreatedAt()%>

</td>

</tr>

</table>

</div>

<div class="section">

<h2>⚙ Quick Actions</h2>

<div class="action-buttons">

<a class="btn blue"
href="${pageContext.request.contextPath}/edit-event-type?id=<%=eventType.getTypeId()%>">

✏ Edit Event Type

</a>

<a class="btn green"
href="${pageContext.request.contextPath}/manage-eventtype-samagri?id=<%=eventType.getTypeId()%>">

🪔 Manage Samagri

</a>

<a class="btn orange"
href="${pageContext.request.contextPath}/view-events?eventTypeId=<%=eventType.getTypeId()%>">

📅 View Events

</a>

<a class="btn red"
onclick="return confirm('Are you sure you want to delete this Event Type?');"
href="${pageContext.request.contextPath}/delete-event-type?id=<%=eventType.getTypeId()%>">

🗑 Delete

</a>

</div>

</div>

</div>

</body>
</html>