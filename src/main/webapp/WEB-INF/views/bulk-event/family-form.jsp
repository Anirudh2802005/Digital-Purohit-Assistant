<%@ page contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.Customer"%>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>

<%

BulkEventCustomer family =
(BulkEventCustomer)request.getAttribute("family");

boolean editMode =
(family!=null);

Integer bulkEventId =
(Integer)request.getAttribute("bulkEventId");

List<Customer> customers =
(List<Customer>)request.getAttribute("customers");

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>

<%=editMode ? "Edit Family" : "Add Family"%>

</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/family-form.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<div class="page-header">

<div>

<h1 class="page-title">

<i class="fa-solid fa-users"></i>

<%=editMode ? "Edit Family" : "Add New Family"%>

</h1>

<p class="page-subtitle">

Manage families participating in this Bulk Event.

</p>

</div>

<a
href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%=bulkEventId%>"
class="back-btn">

<i class="fa-solid fa-arrow-left"></i>

Back

</a>

</div>

<form
id="familyForm"
action="${pageContext.request.contextPath}/<%=editMode?"edit-bulk-family":"add-bulk-family"%>"
method="post">

<% if(editMode){ %>

<input
type="hidden"
name="id"
value="<%=family.getId()%>">

<% } %>

<input
type="hidden"
name="bulkEventId"
value="<%=bulkEventId%>">

<div class="form-grid">
<!-- ================= CUSTOMER CARD ================= -->

<div class="form-card">

<h2>

<i class="fa-solid fa-user"></i>

Customer Information

</h2>

<% if(editMode){ %>

<!-- ================= EDIT MODE ================= -->

<input
type="hidden"
name="customerId"
value="<%=family.getCustomerId()%>">

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

Phone Number

</label>

<input
type="text"
name="phone"
value="<%=family.getPhone()%>"
required>

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

Address

</label>

<textarea
name="address"
rows="4"><%=family.getAddress()%></textarea>

</div>

<% } else { %>

<!-- ================= ADD MODE ================= -->

<div class="form-group">

<label>

Customer Type

</label>

<div class="customer-type">

<label>

<input
type="radio"
name="customerType"
value="existing"
checked>

Existing Customer

</label>

<label>

<input
type="radio"
name="customerType"
value="new">

New Customer

</label>

</div>

</div>

<div id="existingCustomerSection">

<div class="form-group">

<label>

Select Existing Customer

</label>

<select
id="customerId"
name="customerId">

<option value="">-- Select Customer --</option>

<%
if(customers != null){

for(Customer c : customers){
%>

<option
value="<%=c.getCustomerId()%>"
data-name="<%=c.getCustomerName()%>"
data-phone="<%=c.getPhone()%>"
data-address="<%=c.getAddress()%>"
data-gothram="<%=c.getGothram()%>">

<%=c.getCustomerName()%> (<%=c.getPhone()%>)

</option>

<%
}
}
%>

</select>

</div>

</div>

<div
id="newCustomerSection"
style="display:none;">

<div class="form-group">

<label>

Customer Name

</label>

<input
type="text"
id="customerName"
name="customerName">

</div>

<div class="form-group">

<label>

Phone Number

</label>

<input
type="text"
id="phone"
name="phone">

</div>

<div class="form-group">

<label>

Gothram

</label>

<input
type="text"
id="gothram"
name="gothram">

</div>

<div class="form-group">

<label>

Address

</label>

<textarea
id="address"
name="address"
rows="4"></textarea>

</div>

</div>

<% } %>

</div>
<!-- ================= PAYMENT CARD ================= -->

<div class="form-card">

<h2>

<i class="fa-solid fa-wallet"></i>

Payment Details

</h2>

<div class="form-group">

<label>

Total Amount <span>*</span>

</label>

<input
type="number"
id="totalAmount"
name="totalAmount"
placeholder="Enter Total Amount"
value="<%=editMode ? family.getTotalAmount() : ""%>"
required>

</div>

<div class="form-group">

<label>

Amount Paid

</label>

<input
type="number"
id="amountPaid"
name="amountPaid"
placeholder="Enter Amount Paid"
value="<%=editMode ? family.getAmountPaid() : "0"%>">

</div>

<div class="payment-summary">

<div class="summary-card">

<span>

Total Amount

</span>

<h3 id="totalDisplay">

₹0

</h3>

</div>

<div class="summary-card">

<span>

Amount Paid

</span>

<h3 id="paidDisplay">

₹0

</h3>

</div>

<div class="summary-card">

<span>

Remaining Amount

</span>

<h3 id="remainingDisplay">

₹0

</h3>

</div>

<div class="summary-card">

<span>

Payment Status

</span>

<h3
id="statusDisplay"
class="pending">

Pending

</h3>

</div>

</div>

</div>

</div>

<!-- ================= NOTES ================= -->

<div class="form-card notes-card">

<h2>

<i class="fa-solid fa-note-sticky"></i>

Additional Notes

</h2>

<div class="form-group">

<textarea
name="notes"
rows="5"
placeholder="Write any notes..."><%=editMode ? family.getNotes() : ""%></textarea>

</div>

</div>

<!-- ================= BUTTONS ================= -->

<div class="button-group">

<a
href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%=bulkEventId%>"
class="btn btn-cancel">

<i class="fa-solid fa-xmark"></i>

Cancel

</a>

<button
type="submit"
class="btn btn-save">

<i class="fa-solid fa-floppy-disk"></i>

<%=editMode ? "Update Family" : "Save Family"%>

</button>

</div>

</form>

</div>
<script>

// ==========================================
// Customer Type Toggle
// ==========================================

const existingSection =
document.getElementById("existingCustomerSection");

const newSection =
document.getElementById("newCustomerSection");

const customerType =
document.getElementsByName("customerType");

if(customerType.length>0){

customerType.forEach(function(radio){

radio.addEventListener("change",function(){

if(this.value==="existing"){

existingSection.style.display="block";

newSection.style.display="none";

}
else{

existingSection.style.display="none";

newSection.style.display="block";

}

});

});

}

// ==========================================
// Existing Customer Auto Fill
// ==========================================

const customerDropdown =
document.getElementById("customerId");

if(customerDropdown){

customerDropdown.addEventListener("change",function(){

let option =
this.options[this.selectedIndex];

document.getElementById("customerName").value =
option.dataset.name || "";

document.getElementById("phone").value =
option.dataset.phone || "";

document.getElementById("address").value =
option.dataset.address || "";

document.getElementById("gothram").value =
option.dataset.gothram || "";

});

}

// ==========================================
// Payment Calculation
// ==========================================

const total =
document.getElementById("totalAmount");

const paid =
document.getElementById("amountPaid");

const totalDisplay =
document.getElementById("totalDisplay");

const paidDisplay =
document.getElementById("paidDisplay");

const remainingDisplay =
document.getElementById("remainingDisplay");

const statusDisplay =
document.getElementById("statusDisplay");

function updateSummary(){

let totalValue =
parseFloat(total.value)||0;

let paidValue =
parseFloat(paid.value)||0;

let remaining =
Math.max(0,totalValue-paidValue);

totalDisplay.innerHTML =
"₹"+totalValue.toLocaleString();

paidDisplay.innerHTML =
"₹"+paidValue.toLocaleString();

remainingDisplay.innerHTML =
"₹"+remaining.toLocaleString();

if(totalValue==0){

statusDisplay.innerHTML="Pending";

statusDisplay.className="pending";

}
else if(paidValue>=totalValue){

statusDisplay.innerHTML="Paid";

statusDisplay.className="paid";

}
else if(paidValue==0){

statusDisplay.innerHTML="Pending";

statusDisplay.className="pending";

}
else{

statusDisplay.innerHTML="Partial";

statusDisplay.className="partial";

}

}

if(total){

total.addEventListener("input",updateSummary);

}

if(paid){

paid.addEventListener("input",updateSummary);

}

updateSummary();

</script>
