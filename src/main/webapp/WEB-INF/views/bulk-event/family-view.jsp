<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>

<%
BulkEventCustomer family =
(BulkEventCustomer)request.getAttribute("family");

double pending =
family.getTotalAmount() - family.getAmountPaid();
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Family Details</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

.page-header{
display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:25px;
}

.hero-card{
background:#fff;
padding:30px;
border-radius:18px;
box-shadow:0 5px 15px rgba(0,0,0,.08);
margin-bottom:25px;
}

.hero-card h2{
margin:0;
color:#1F3C88;
}

.stats{
display:grid;
grid-template-columns:repeat(3,1fr);
gap:20px;
margin-bottom:25px;
}

.stat-card{
background:#fff;
padding:20px;
border-radius:15px;
box-shadow:0 5px 15px rgba(0,0,0,.08);
text-align:center;
}

.stat-card h2{
margin:0;
color:#2C6BED;
}

.section{
background:#fff;
padding:25px;
border-radius:15px;
box-shadow:0 5px 15px rgba(0,0,0,.08);
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
width:220px;
}

.btn{
padding:10px 20px;
background:#6c757d;
color:#fff;
text-decoration:none;
border-radius:8px;
}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<div class="page-header">

<h1>

👨‍👩‍👧 Family Details

</h1>

<a
href="javascript:history.back()"
class="btn">

Back

</a>

</div>

<div class="hero-card">

<h2>

<%=family.getCustomerName()%>

</h2>

<p>

Phone :
<%=family.getPhone()%>

</p>

</div>

<div class="stats">

<div class="stat-card">

<h2>

₹ <%=family.getTotalAmount()%>

</h2>

<p>

Total Amount

</p>

</div>

<div class="stat-card">

<h2>

₹ <%=family.getAmountPaid()%>

</h2>

<p>

Amount Paid

</p>

</div>

<div class="stat-card">

<h2>

₹ <%=pending%>

</h2>

<p>

Pending Amount

</p>

</div>

</div>

<div class="section">

<h2>

Customer Information

</h2>

<table class="info-table">

<tr>

<td>Name</td>

<td><%=family.getCustomerName()%></td>

</tr>

<tr>

<td>Phone</td>

<td><%=family.getPhone()%></td>

</tr>

<tr>

<td>Address</td>

<td><%=family.getAddress()%></td>

</tr>

<tr>

<td>Gothram</td>

<td><%=family.getGothram()%></td>

</tr>

<tr>

<td>Total Amount</td>

<td>₹ <%=family.getTotalAmount()%></td>

</tr>

<tr>

<td>Amount Paid</td>

<td>₹ <%=family.getAmountPaid()%></td>

</tr>

<tr>

<td>Payment Status</td>

<td><%=family.getPaymentStatus()%></td>

</tr>

<tr>

<td>Notes</td>

<td><%=family.getNotes()==null?"-":family.getNotes()%></td>

</tr>

</table>

</div>

</div>

</body>

</html>