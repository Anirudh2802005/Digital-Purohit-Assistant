<%@ page contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="com.digitalpurohit.model.Samagri"%>

<%

Samagri samagri =
(Samagri)request.getAttribute("samagri");

boolean editMode =
(samagri != null);

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>

<%= editMode ? "Edit Master Samagri"
             : "Add Master Samagri" %>

</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/customer.css">

<style>

.form-card{

width:700px;

background:white;

padding:25px;

border-radius:10px;

box-shadow:0 2px 8px rgba(0,0,0,.15);

}

input,textarea{

width:100%;

padding:10px;

margin-top:8px;

margin-bottom:20px;

border:1px solid #ccc;

border-radius:5px;

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

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h2>

🪔

<%= editMode ? "Edit Master Samagri"
             : "Add Master Samagri" %>

</h2>

<div class="form-card">

<form action="${pageContext.request.contextPath}/<%= editMode ? "edit-samagri" : "add-samagri" %>"
method="post">

<% if(editMode){ %>

<input
type="hidden"
name="samagriId"
value="<%=samagri.getSamagriId()%>">

<% } %>

<label>

Samagri Name

</label>

<input
type="text"
name="samagriName"
placeholder="Enter Samagri Name"

value="<%=editMode ? samagri.getSamagriName() : ""%>"

required>

<label>

Description

</label>

<textarea
name="description"
rows="4"
placeholder="Optional Description"><%=editMode ? samagri.getDescription() : ""%></textarea>

<button
type="submit">

<%=editMode ? "Update Samagri"
            : "Save Samagri"%>

</button>

</form>

</div>

</div>

</body>

</html>