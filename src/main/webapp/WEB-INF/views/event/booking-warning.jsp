<%@ page contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@ page import="com.digitalpurohit.model.Event"%>

<%
Event newEvent =
(Event)request.getAttribute("newEvent");

Event conflictEvent =
(Event)request.getAttribute("conflictEvent");

Event duplicateEvent =
(Event)request.getAttribute("duplicateEvent");

Event previousEvent =
(Event)request.getAttribute("previousEvent");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>

Booking Warning

</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

.container{

width:850px;

margin:30px auto;

background:white;

padding:25px;

border-radius:10px;

}

.warning{

padding:18px;

margin-bottom:20px;

border-radius:8px;

}

.red{

background:#fdecea;

border-left:6px solid #e53935;

}

.orange{

background:#fff3e0;

border-left:6px solid #fb8c00;

}

.blue{

background:#e3f2fd;

border-left:6px solid #1e88e5;

}

h2{

margin-top:0;

}

table{

width:100%;

border-collapse:collapse;

margin-top:10px;

}

th,td{

padding:10px;

border:1px solid #ddd;

}

.buttons{

margin-top:30px;

text-align:center;

}

.btn{

padding:12px 28px;

text-decoration:none;

border-radius:6px;

font-weight:bold;

margin:10px;

display:inline-block;

}

.cancel{

background:#d32f2f;

color:white;

}

.save{

background:#2e7d32;

color:white;

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<div class="container">

<h2>

⚠ Smart Booking Warning

</h2>
<% if(conflictEvent != null){ %>

<div class="warning red">

<h3>🚫 Double Booking Detected</h3>

<table>

<tr>
<th>Existing Event</th>
<td><%=conflictEvent.getEventTitle()%></td>
</tr>

<tr>
<th>Customer</th>
<td><%=conflictEvent.getCustomerName()%></td>
</tr>

<tr>
<th>Phone</th>
<td><%=conflictEvent.getPhone()%></td>
</tr>

<tr>
<th>Date</th>
<td><%=conflictEvent.getEventDate()%></td>
</tr>

<tr>
<th>Time</th>
<td><%=conflictEvent.getEventTime()%></td>
</tr>

<tr>
<th>Location</th>
<td><%=conflictEvent.getLocation()%></td>
</tr>

</table>

</div>

<% } %>


<% if(duplicateEvent != null){ %>

<div class="warning orange">

<h3>👤 Duplicate Customer Booking</h3>

<table>

<tr>
<th>Customer</th>
<td><%=duplicateEvent.getCustomerName()%></td>
</tr>

<tr>
<th>Phone</th>
<td><%=duplicateEvent.getPhone()%></td>
</tr>

<tr>
<th>Existing Event</th>
<td><%=duplicateEvent.getEventTitle()%></td>
</tr>

<tr>
<th>Date</th>
<td><%=duplicateEvent.getEventDate()%></td>
</tr>

<tr>
<th>Time</th>
<td><%=duplicateEvent.getEventTime()%></td>
</tr>

<tr>
<th>Location</th>
<td><%=duplicateEvent.getLocation()%></td>
</tr>

</table>

</div>

<% } %>


<% if(previousEvent != null){ %>

<div class="warning blue">

<h3>🚗 Travel Time Warning</h3>

<table>

<tr>
<th>Previous Event</th>
<td><%=previousEvent.getEventTitle()%></td>
</tr>

<tr>
<th>Customer</th>
<td><%=previousEvent.getCustomerName()%></td>
</tr>

<tr>
<th>Location</th>
<td><%=previousEvent.getLocation()%></td>
</tr>

<tr>
<th>Time</th>
<td><%=previousEvent.getEventTime()%></td>
</tr>

<tr>
<th>New Event</th>
<td><%=newEvent.getEventTitle()%></td>
</tr>

<tr>
<th>New Location</th>
<td><%=newEvent.getLocation()%></td>
</tr>

<tr>
<th>New Time</th>
<td><%=newEvent.getEventTime()%></td>
</tr>

</table>

<p style="margin-top:15px;font-weight:bold;color:#1565c0;">

⚠ Please verify that there is enough travel time between these two locations before continuing.

</p>

</div>

<% } %>

<div class="buttons">

<a class="btn cancel"
href="${pageContext.request.contextPath}/add-event">

Cancel

</a>

<form action="${pageContext.request.contextPath}/add-event"
method="post"
style="display:inline;">

<input type="hidden" name="forceSave" value="true">

<input type="hidden" name="customerId" value="<%=newEvent.getCustomerId()%>">
<input type="hidden" name="typeId" value="<%=newEvent.getTypeId()%>">
<input type="hidden" name="eventTitle" value="<%=newEvent.getEventTitle()%>">
<input type="hidden" name="eventDate" value="<%=newEvent.getEventDate()%>">
<input type="hidden" name="eventTime" value="<%=newEvent.getEventTime().toString().substring(0,5)%>">
<input type="hidden" name="location" value="<%=newEvent.getLocation()%>">
<input type="hidden" name="totalAmount" value="<%=newEvent.getTotalAmount()%>">
<input type="hidden" name="amountPaid" value="<%=newEvent.getAmountPaid()%>">
<input type="hidden" name="notes" value="<%=newEvent.getNotes()%>">

<button class="btn save"
type="submit">

Save Anyway

</button>

</form>

</div>

</div>

</div>

</body>

</html>