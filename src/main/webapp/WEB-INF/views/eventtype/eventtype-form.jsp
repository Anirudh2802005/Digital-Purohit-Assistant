<%@ page contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="com.digitalpurohit.model.EventType"%>
<%@ page import="com.digitalpurohit.model.Samagri"%>

<%

EventType eventType =
(EventType)request.getAttribute("eventType");

boolean editMode =
(eventType != null);

List<Samagri> samagriList =
(List<Samagri>)request.getAttribute("samagriList");

List<Integer> selectedSamagriIds =
(List<Integer>)request.getAttribute("selectedSamagriIds");

Set<Integer> selectedIds =
new HashSet<Integer>();

if(selectedSamagriIds != null){

    selectedIds.addAll(selectedSamagriIds);

}

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>

<%= editMode ? "Edit Event Type" : "Add Event Type" %>

</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/customer.css">

<style>

.form-card{

width:900px;

background:white;

padding:25px;

border-radius:10px;

box-shadow:0 2px 10px rgba(0,0,0,.15);

}

input[type=text],
textarea{

width:100%;

padding:10px;

margin-top:8px;

margin-bottom:18px;

border:1px solid #ccc;

border-radius:5px;

}

.checkbox-grid{

display:grid;

grid-template-columns:repeat(3,1fr);

gap:12px;

margin-top:15px;

margin-bottom:20px;

padding:15px;

border:1px solid #ddd;

border-radius:8px;

background:#fafafa;

}

.checkbox-item{

display:flex;

align-items:center;

gap:8px;

padding:6px;

}

button{

padding:10px 25px;

background:#2c6bed;

color:white;

border:none;

border-radius:5px;

cursor:pointer;

font-size:16px;

}

button:hover{

background:#174ea6;

}

.section-title{

margin-top:20px;

margin-bottom:10px;

color:#2c6bed;

}

</style>

</head>

<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h2>

<%= editMode ? "✏ Edit Event Type"
             : "➕ Add Event Type" %>

</h2>

<div class="form-card">

<form action="${pageContext.request.contextPath}/<%= editMode ? "edit-event-type" : "add-event-type" %>"
method="post">

<% if(editMode){ %>

<input
type="hidden"
name="typeId"
value="<%=eventType.getTypeId()%>">

<% } %>

<label>

Event Type Name

</label>

<input
type="text"
name="typeName"
placeholder="Enter Event Type Name"
value="<%=editMode ? eventType.getTypeName() : ""%>"
required>

<label>

Description

</label>

<textarea
name="description"
rows="4"
placeholder="Description"><%=editMode ? eventType.getDescription() : ""%></textarea>

<label>

<input
type="checkbox"
name="active"
<%= (editMode && eventType.isActive()) || !editMode ? "checked" : "" %>>

Active

</label>

<h3 class="section-title">

🪔 Required Master Samagri

</h3>

<div class="checkbox-grid">

<%

if(samagriList != null){

    for(Samagri samagri : samagriList){

%>

<label class="checkbox-item">

<input
type="checkbox"
name="samagriIds"
value="<%=samagri.getSamagriId()%>"

<%= selectedIds.contains(samagri.getSamagriId()) ? "checked" : "" %>>

<%=samagri.getSamagriName()%>

</label>

<%

    }

}

%>

</div>

<br>

<button type="submit">

<%= editMode ? "Update Event Type"
             : "Save Event Type" %>

</button>

</form>

</div>

</div>

</body>

</html>