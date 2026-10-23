<%@ page contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.Samagri"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Master Samagri</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/customer.css">

<style>

table{

width:100%;

border-collapse:collapse;

background:white;

}

th,td{

padding:12px;

border:1px solid #ddd;

text-align:center;

}

th{

background:#2c6bed;

color:white;

}

.btn{

padding:8px 14px;

border-radius:5px;

text-decoration:none;

color:white;

font-weight:bold;

}

.add{

background:#28a745;

}

.edit{

background:#ff9800;

}

.delete{

background:#dc3545;

}

.search-box{

margin-bottom:20px;

}

.search-box input{

padding:10px;

width:300px;

}

.search-box button{

padding:10px 20px;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h2>🪔 Master Samagri</h2>

<br>

<a class="btn add"
href="${pageContext.request.contextPath}/add-samagri">

+ Add Master Samagri

</a>

<br><br>

<form class="search-box"
action="${pageContext.request.contextPath}/samagri"
method="get">

<input
type="text"
name="keyword"
placeholder="Search Samagri">

<button type="submit">

Search

</button>

</form>

<table>

<tr>

<th>ID</th>

<th>Samagri Name</th>

<th>Description</th>

<th>Actions</th>

</tr>

<%

List<Samagri> samagriList =
(List<Samagri>)request.getAttribute("samagriList");

if(samagriList!=null){

for(Samagri samagri : samagriList){

%>

<tr>

<td>

<%=samagri.getSamagriId()%>

</td>

<td>

<%=samagri.getSamagriName()%>

</td>

<td>

<%=samagri.getDescription()%>

</td>

<td>

<a class="btn edit"
href="${pageContext.request.contextPath}/edit-samagri?id=<%=samagri.getSamagriId()%>">

Edit

</a>

<a class="btn delete"
href="${pageContext.request.contextPath}/delete-samagri?id=<%=samagri.getSamagriId()%>"
onclick="return confirm('Delete this Samagri?')">

Delete

</a>

</td>

</tr>

<%

}

}

%>

</table>

</div>

</body>

</html>