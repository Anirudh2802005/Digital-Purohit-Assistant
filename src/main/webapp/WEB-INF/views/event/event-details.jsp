<%@ page contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.Event"%>
<%@ page import="com.digitalpurohit.model.Customer"%>
<%@ page import="com.digitalpurohit.model.Samagri"%>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<%@ include file="../partials/toast.jsp"%>


<%

Event event =
(Event)request.getAttribute("event");

Customer customer =
(Customer)request.getAttribute("customer");

List<Samagri> samagriList =
(List<Samagri>)request.getAttribute("samagriList");

double pending =
event.getTotalAmount() -
event.getAmountPaid();

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>

Event Details

</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

.card{

background:white;

padding:20px;

margin-bottom:20px;

border-radius:10px;

box-shadow:0 2px 8px rgba(0,0,0,.15);

}

table{

width:100%;

border-collapse:collapse;

}

td{

padding:10px;

border-bottom:1px solid #ddd;

}

.section-title{

color:#2c6bed;

margin-bottom:15px;

}

.checklist{

display:flex;

flex-direction:column;

gap:12px;

font-size:18px;

}

button{

padding:10px 25px;

background:#2c6bed;

color:white;

border:none;

border-radius:6px;

cursor:pointer;

font-size:16px;

}

button:hover{

background:#184fa8;

}

</style>

</head>
<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/toast.css">
<body>



<%@ include file="../partials/sidebar.jsp"%>

<div class="main-content">

<%
if ("true".equals(request.getParameter("checklistSaved"))) {
%>

<div id="checklistSuccess"
     style="
        background:#d4edda;
        color:#155724;
        border:1px solid #c3e6cb;
        padding:12px 16px;
        border-radius:8px;
        margin-bottom:20px;
        font-weight:bold;
        font-size:15px;">

    ✅ Checklist Saved Successfully

</div>

<%
}
%>
<h2>

📅 Event Details

</h2>

<div class="card">

<h3 class="section-title">

👤 Customer Details

</h3>

<table>

<tr>

<td><b>Name</b></td>

<td><%=customer.getCustomerName()%></td>

</tr>

<tr>

<td><b>Phone</b></td>

<td><%=customer.getPhone()%></td>

</tr>

<tr>

<td><b>Address</b></td>

<td><%=customer.getAddress()%></td>

</tr>

<tr>

<td><b>Gothram</b></td>

<td><%=customer.getGothram()%></td>

</tr>

</table>

</div>

<div class="card">

<h3 class="section-title">

📅 Event Details

</h3>

<table>

<tr>

<td><b>Title</b></td>

<td><%=event.getEventTitle()%></td>

</tr>

<tr>

<td><b>Date</b></td>

<td><%=event.getEventDate()%></td>

</tr>

<tr>

<td><b>Time</b></td>

<td><%=event.getEventTime()%></td>

</tr>

<tr>

<td><b>Location</b></td>

<td><%=event.getLocation()%></td>

</tr>

</table>

</div>

<div class="card">

<h3 class="section-title">

💰 Payment Details

</h3>

<table>

<tr>

<td><b>Total Amount</b></td>

<td>₹ <%=event.getTotalAmount()%></td>

</tr>

<tr>

<td><b>Paid</b></td>

<td>₹ <%=event.getAmountPaid()%></td>

</tr>

<tr>

<td><b>Pending</b></td>

<td>₹ <%=pending%></td>

</tr>

<tr>

<td><b>Status</b></td>

<td><%=event.getPaymentStatus()%></td>

</tr>

</table>

</div>

<div class="card">

<h3 class="section-title">

🪔 Required Samagri

</h3>

<form action="${pageContext.request.contextPath}/update-event-samagri"
method="post">

<input
type="hidden"
name="eventId"
value="<%=event.getEventId()%>">

<div class="checklist">

<%

if(samagriList!=null){

for(Samagri samagri:samagriList){

%>

<label>

<input
type="checkbox"
name="completedSamagri"
value="<%=samagri.getSamagriId()%>"

<%=samagri.isCompleted() ? "checked" : "" %>>

<%=samagri.getSamagriName()%>

</label>

<%

}

}

%>

</div>

<br>

<button type="submit">

💾 Save Checklist

</button>

</form>

</div>

</div>
<script>
setTimeout(function () {
    const msg = document.getElementById("checklistSuccess");
    if (msg) {
        msg.style.display = "none";
    }
}, 4000);
</script>
</body>

</html>