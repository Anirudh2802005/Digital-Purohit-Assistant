<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>

<%
BulkEventCustomer family =
(BulkEventCustomer) request.getAttribute("family");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Receive Bulk Event Payment</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

.form-container{

    width:500px;
    margin:auto;
    background:white;
    padding:25px;
    border-radius:10px;
    box-shadow:0 0 10px lightgray;

}

.form-group{

    margin-bottom:15px;

}

input,textarea{

    width:100%;
    padding:10px;
    box-sizing:border-box;

}

button{

    padding:10px 20px;
    background:#28a745;
    color:white;
    border:none;
    cursor:pointer;
    border-radius:5px;

}

button:hover{

    background:#218838;

}

.info{

    background:#f5f5f5;
    padding:15px;
    border-radius:5px;
    margin-bottom:20px;

}

.info p{

    margin:8px 0;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<div class="form-container">

<h2>Receive Bulk Event Payment</h2>

<div class="info">

<p><b>Family Name :</b> <%= family.getCustomerName() %></p>

<p><b>Phone :</b> <%= family.getPhone() %></p>

<p><b>Total Amount :</b> ₹ <%= family.getTotalAmount() %></p>

<p><b>Amount Paid :</b> ₹ <%= family.getAmountPaid() %></p>

<p><b>Outstanding :</b> ₹ <%= family.getTotalAmount() - family.getAmountPaid() %></p>

</div>

<form
action="${pageContext.request.contextPath}/update-bulk-payment"
method="post">

<input
type="hidden"
name="bulkEventId"
value="<%= family.getBulkEventId() %>">

<input
type="hidden"
name="customerId"
value="<%= family.getCustomerId() %>">

<input
type="hidden"
name="source"
value="<%= request.getParameter("source") != null ? request.getParameter("source") : "" %>">
<div class="form-group">

<label>Receive Today</label>

<input
type="number"
step="0.01"
name="amountPaid"
placeholder="Enter today's received amount"
required>

</div>

<div class="form-group">

<label>Notes</label>

<textarea
name="notes"
rows="4"><%= family.getNotes()==null ? "" : family.getNotes() %></textarea>

</div>

<button type="submit">

Update Payment

</button>

</form>

</div>

</div>

</body>

</html>