<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>

<%

BulkEventCustomer family =
(BulkEventCustomer)request.getAttribute("family");

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Edit Family</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/customer.css">

<style>

.form-card{

background:white;

padding:25px;

border-radius:10px;

width:900px;

margin:auto;

}

.form-grid{

display:grid;

grid-template-columns:1fr 1fr;

gap:20px;

}

.form-group{

display:flex;

flex-direction:column;

}

label{

font-weight:bold;

margin-bottom:6px;

}

input,textarea{

padding:10px;

border:1px solid #ccc;

border-radius:6px;

font-size:15px;

}

textarea{

height:120px;

resize:none;

}

button{

background:#28a745;

color:white;

padding:12px 30px;

border:none;

border-radius:6px;

font-size:16px;

cursor:pointer;

}

button:hover{

background:#218838;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h2>

✏ Edit Family

</h2>

<div class="form-card">

<form

action="${pageContext.request.contextPath}/edit-bulk-family"

method="post">

<input

type="hidden"

name="id"

value="<%=family.getId()%>">

<input

type="hidden"

name="bulkEventId"

value="<%=family.getBulkEventId()%>">

<input

type="hidden"

name="customerId"

value="<%=family.getCustomerId()%>">

<div class="form-grid">

<div class="form-group">

<label>

Customer Name

</label>

<input

type="text"

name="customerName"

value="<%=family.getCustomerName()%>"

required>

</div>

<div class="form-group">

<label>

Phone

</label>

<input

type="text"

name="phone"

value="<%=family.getPhone()%>"

required>

</div>

<div class="form-group">

<label>

Address

</label>

<input

type="text"

name="address"

value="<%=family.getAddress()%>">

</div>

<div class="form-group">

<label>

Gothram

</label>

<input

type="text"

name="gothram"

value="<%=family.getGothram()%>">

</div>

<div class="form-group">

<label>

Total Amount

</label>

<input

type="number"

step="0.01"

name="totalAmount"

value="<%=family.getTotalAmount()%>"

required>

</div>

<div class="form-group">

<label>

Amount Paid

</label>

<input

type="number"

step="0.01"

name="amountPaid"

value="<%=family.getAmountPaid()%>"

required>

</div>
<div class="form-group"
style="grid-column:1/3;">

<label>

Notes

</label>

<textarea

name="notes"><%=family.getNotes()==null ? "" : family.getNotes()%></textarea>

</div>

</div>

<br>

<div style="background:#e8f5e9;
padding:15px;
border-radius:8px;
margin-bottom:20px;">

<b>Payment Status :</b>

<%

double total = family.getTotalAmount();
double paid = family.getAmountPaid();

if(paid==0){

%>

<span style="color:red;font-weight:bold;">

🟥 PENDING

</span>

<%

}else if(paid<total){

%>

<span style="color:#ff9800;font-weight:bold;">

🟧 PARTIAL

</span>

<%

}else{

%>

<span style="color:green;font-weight:bold;">

🟩 PAID

</span>

<%

}

%>

<br><br>

<%

double due = total-paid;

%>

<b>Outstanding Amount :</b>

₹ <%=due%>

</div>

<div style="text-align:center;">

<button
type="submit"
onclick="return confirm('Update this family details?');">

💾 Update Family

</button>

&nbsp;&nbsp;

<a
href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%=family.getBulkEventId()%>"
style="padding:12px 25px;
background:#6c757d;
color:white;
text-decoration:none;
border-radius:6px;">

Cancel

</a>

</div>

</form>

</div>

</div>

</body>

</html>