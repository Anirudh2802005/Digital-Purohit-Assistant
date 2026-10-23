<%@ page contentType="text/html;charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Forgot Password</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/login.css">

</head>

<body>

<div class="login-container">

<div class="login-card">

<h1>Digital Purohit Assistant</h1>

<p class="subtitle">

Reset Password

</p>

<%
String errorMessage =
(String)request.getAttribute("errorMessage");

if(errorMessage != null){
%>

<div class="error-message">

<%=errorMessage%>

</div>

<%
}

String successMessage =
(String)request.getAttribute("successMessage");

if(successMessage != null){
%>

<div class="success-message">

<%=successMessage%>

</div>

<%
}
%>

<form action="${pageContext.request.contextPath}/forgot-password"
method="post">

<div class="form-group">

<label>Username</label>

<input type="text"
name="username"
required>

</div>

<div class="form-group">

<label>Phone Number</label>

<input type="text"
name="phone"
maxlength="10"
required>

</div>

<div class="form-group">

<label>New Password</label>

<input type="password"
name="password"
required>

</div>

<div class="form-group">

<label>Confirm Password</label>

<input type="password"
name="confirmPassword"
required>

</div>

<button type="submit">

Reset Password

</button>

</form>

<div class="login-links">

<a href="${pageContext.request.contextPath}/login">

← Back to Login

</a>

</div>

</div>

</div>

</body>

</html>