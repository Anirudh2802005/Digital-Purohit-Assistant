<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.digitalpurohit.model.Event" %>

<%
Event event = (Event) request.getAttribute("event");
%>

<!DOCTYPE html>
<html>

<head>
<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/toast.css">
<meta charset="UTF-8">

<title>Receive Payment</title>

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

}

button{

padding:10px 20px;
background:#28a745;
color:white;
border:none;
cursor:pointer;

}

.info{

background:#f5f5f5;
padding:10px;
margin-bottom:15px;

}

</style>

</head>

<body>


<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />



<%@ include file="../partials/toast.jsp"%>


<div class="main-content">

<div class="form-container">

<h2>Receive Payment</h2>

<%
if ("true".equals(request.getParameter("success"))) {
%>

<div id="successMessage"
     style="background:#d4edda;
            color:#155724;
            border:1px solid #c3e6cb;
            padding:10px;
            border-radius:5px;
            margin-bottom:15px;">

    ✅ Payment Updated Successfully

</div>

<%
}
%>
<div class="info">

<b>Event :</b>
<%= event.getEventTitle() %>

<br><br>

<b>Total Amount :</b>

₹ <%= event.getTotalAmount() %>

<br><br>

<b>Amount Paid :</b>

₹ <%= event.getAmountPaid() %>

<br><br>

<b>Outstanding :</b>

₹ <%= event.getTotalAmount()-event.getAmountPaid() %>

</div>

<form
action="${pageContext.request.contextPath}/event-receive-payment"
method="post">

<input
type="hidden"
name="eventId"
value="<%= event.getEventId() %>">

<input
type="hidden"
name="source"
value="<%= request.getParameter("source") != null ? request.getParameter("source") : "" %>">
<div class="form-group">

<label>Receive Today</label>

<input
type="number"
step="0.01"
name="receiveAmount"
required>

</div>

<div class="form-group">

<label>Notes</label>

<textarea
name="notes"></textarea>

</div>

<button>

Update Payment

</button>

</form>

</div>

</div>

</body>
<script>
setTimeout(function(){

    let msg=document.getElementById("successMessage");

    if(msg){
        msg.style.display="none";
    }

},4000);
</script>

</html>