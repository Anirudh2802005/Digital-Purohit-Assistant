<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.EventType"%>
<%@ page import="com.digitalpurohit.model.Samagri"%>

<%
EventType eventType = (EventType) request.getAttribute("eventType");

List<Samagri> assignedSamagri =
(List<Samagri>) request.getAttribute("assignedSamagri");

List<Samagri> availableSamagri =
(List<Samagri>) request.getAttribute("availableSamagri");
%>
<%
String success = request.getParameter("success");
String error = request.getParameter("error");

if ("assigned".equals(success)) {
    request.setAttribute("success",
            "Samagri assigned successfully.");
}

if ("removed".equals(success)) {
    request.setAttribute("success",
            "Samagri removed successfully.");
}

if ("assign".equals(error)) {
    request.setAttribute("error",
            "Unable to assign Samagri.");
}

if ("remove".equals(error)) {
    request.setAttribute("error",
            "Unable to remove Samagri.");
}
%>
<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Manage Samagri</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

.header{
display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:25px;
}

.card{

background:#fff;
padding:25px;
border-radius:15px;
box-shadow:0 5px 15px rgba(0,0,0,.08);
margin-bottom:25px;

}

table{

width:100%;
border-collapse:collapse;

}

table th{

background:#2C6BED;
color:white;
padding:12px;

}

table td{

padding:12px;
border-bottom:1px solid #eee;

}

.btn{

padding:10px 18px;
border:none;
border-radius:8px;
cursor:pointer;
color:white;
font-weight:bold;
text-decoration:none;

}

.green{

background:#28a745;

}

.red{

background:#dc3545;

}

.gray{

background:#6c757d;

}

select{

width:100%;
padding:12px;
border-radius:8px;
margin-bottom:15px;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<div class="header">

<h1>

🪔 Manage Samagri

</h1>

<a class="btn gray"
href="${pageContext.request.contextPath}/event-type-details?id=<%=eventType.getTypeId()%>">

← Back

</a>

</div>

<div class="card">

<h2>

<%=eventType.getTypeName()%>

</h2>

<p>

Assign or remove required Samagri for this Event Type.

</p>

</div>

<div class="card">

<h2>

Assigned Samagri

</h2>

<table>

<tr>

<th>Name</th>

<th>Description</th>

<th>Action</th>

</tr>

<%

if(assignedSamagri!=null && !assignedSamagri.isEmpty()){

for(Samagri s:assignedSamagri){

%>

<tr>

<td>

<%=s.getSamagriName()%>

</td>

<td>

<%=s.getDescription()==null?"-":s.getDescription()%>

</td>

<td>

<a class="btn red"
href="${pageContext.request.contextPath}/remove-eventtype-samagri?typeId=<%=eventType.getTypeId()%>&samagriId=<%=s.getSamagriId()%>"
onclick="return confirm('Remove this Samagri?');">

Remove

</a>

</td>

</tr>

<%

}

}else{

%>

<tr>

<td colspan="3">

No Samagri Assigned

</td>

</tr>

<%

}

%>

</table>

</div>

<div class="card">

<h2>

Assign New Samagri

</h2>

<form action="${pageContext.request.contextPath}/manage-eventtype-samagri"
method="post">

<input type="hidden"
name="typeId"
value="<%=eventType.getTypeId()%>">

<select name="samagriId" required>

<option value="">

Select Samagri

</option>

<%

if(availableSamagri!=null){

for(Samagri s:availableSamagri){

%>

<option value="<%=s.getSamagriId()%>">

<%=s.getSamagriName()%>

</option>

<%

}

}

%>

</select>

<button class="btn green"
type="submit">

Assign Samagri

</button>

</form>

</div>

</div>

</body>

</html>