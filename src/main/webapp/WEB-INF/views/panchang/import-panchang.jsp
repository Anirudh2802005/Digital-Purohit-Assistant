<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Import Panchang | Digital Purohit Assistant</title>

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/calendar.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

<style>

.import-card{

    max-width:700px;

    margin:40px auto;

    background:#fff;

    padding:30px;

    border-radius:15px;

    box-shadow:0 5px 15px rgba(0,0,0,.1);

}

.import-card h2{

    color:#1565c0;

    margin-bottom:25px;

}

.file-box{

    border:2px dashed #1565c0;

    padding:40px;

    border-radius:10px;

    text-align:center;

    margin-bottom:20px;

}

.file-box input{

    margin-top:15px;

}

.import-btn{

    width:100%;

    padding:14px;

    background:#1565c0;

    color:white;

    border:none;

    border-radius:8px;

    font-size:16px;

    cursor:pointer;

}

.import-btn:hover{

    background:#0d47a1;

}

.success{

    background:#d4edda;

    color:#155724;

    padding:12px;

    border-radius:8px;

    margin-bottom:15px;

}

.error{

    background:#f8d7da;

    color:#721c24;

    padding:12px;

    border-radius:8px;

    margin-bottom:15px;

}

.instructions{

    margin-top:25px;

    background:#f8f9fa;

    padding:20px;

    border-radius:10px;

}

.instructions ul{

    margin-left:20px;

    margin-top:10px;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="dashboard-container">



<div class="main-content">

<div class="import-card">

<h2>

📥 Import Panchang Excel

</h2>

<%
String success=(String)request.getAttribute("success");

String error=(String)request.getAttribute("error");
%>

<% if(success!=null){ %>

<div class="success">

<%=success%>

</div>

<% } %>

<% if(error!=null){ %>

<div class="error">

<%=error%>

</div>

<% } %>

<form
action="${pageContext.request.contextPath}/import-panchang"
method="post"
enctype="multipart/form-data">

<div class="file-box">

<i class="fa-solid fa-file-excel fa-3x"
style="color:green;"></i>

<br><br>

Choose Panchang Excel File

<br><br>

<input
type="file"
name="excelFile"
accept=".xlsx,.xls"
required>

</div>

<button
type="submit"
class="import-btn">

<i class="fa-solid fa-upload"></i>

Import Panchang

</button>

</form>

<div class="instructions">

<h3>

Instructions

</h3>

<ul>

<li>Upload only Excel (.xlsx or .xls)</li>

<li>First row must contain column names.</li>

<li>Date format: YYYY-MM-DD</li>

<li>Time format: HH:mm:ss</li>

<li>Duplicate dates will be updated automatically.</li>

</ul>

</div>

</div>

</div>

</div>

</body>

</html>