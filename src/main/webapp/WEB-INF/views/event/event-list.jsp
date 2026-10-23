<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.digitalpurohit.model.Event"%>

<%
List<Event> events = (List<Event>) request.getAttribute("events");

String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");
String filter = request.getParameter("filter") == null ? "all" : request.getParameter("filter");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>View Events</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/toast.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:'Segoe UI',sans-serif;
}

body{
background:#f5f7fb;
}

.page-header{
display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:25px;
}

.page-title h1{
font-size:32px;
color:#1F3C88;
}

.page-title p{
color:#666;
margin-top:5px;
}

.header-buttons{
display:flex;
gap:10px;
}

.btn{
padding:11px 18px;
border-radius:8px;
text-decoration:none;
font-weight:600;
color:white;
transition:.3s;
}

.btn:hover{
transform:translateY(-2px);
}

.green{
background:#16a34a;
}

.gray{
background:#64748b;
}

.blue{
background:#2563eb;
}

.search-card{
background:#fff;
padding:20px;
border-radius:15px;
box-shadow:0 8px 20px rgba(0,0,0,.08);
margin-bottom:25px;
}

.search-form{
display:flex;
gap:10px;
}

.search-form input{
flex:1;
padding:13px;
border:1px solid #ddd;
border-radius:8px;
font-size:15px;
}

.filters{
display:flex;
gap:10px;
margin-top:15px;
flex-wrap:wrap;
}

.filter{
padding:8px 18px;
background:#eef2ff;
border-radius:30px;
text-decoration:none;
font-weight:600;
color:#1F3C88;
}

.filter.active{
background:#2563eb;
color:white;
}

.events-grid{
display:grid;
grid-template-columns:repeat(auto-fill,minmax(420px,1fr));
gap:25px;
}

.event-card{
background:#fff;
border-radius:18px;
padding:22px;
box-shadow:0 8px 20px rgba(0,0,0,.08);
transition:.3s;
position:relative;
}

.event-card:hover{
transform:translateY(-6px);
box-shadow:0 18px 30px rgba(0,0,0,.15);
}

.event-header{
display:flex;
justify-content:space-between;
align-items:center;
margin-bottom:18px;
padding-bottom:15px;
border-bottom:1px solid #eee;
}

.event-title{
font-size:22px;
font-weight:bold;
color:#1F3C88;
}

.status{
padding:8px 15px;
border-radius:30px;
font-size:12px;
font-weight:bold;
color:white;
}

.paid{
background:#22c55e;
border-left:6px solid #22c55e;
}

.partial{
background:#f59e0b;
border-left:6px solid #f59e0b;
}

.pending{
background:#ef4444;
border-left:6px solid #ef4444;
}

.info{
display:flex;
align-items:center;
gap:10px;
margin:12px 0;
font-size:15px;
color:#444;
}

.info i{
width:22px;
color:#2563eb;
}

.actions{
margin-top:20px;
padding-top:18px;
border-top:1px solid #eee;
display:flex;
flex-wrap:wrap;
gap:10px;
}

.action-btn{
flex:1;
text-align:center;
padding:10px;
border-radius:8px;
text-decoration:none;
font-weight:600;
color:white;
transition:.3s;
}

.action-btn:hover{
opacity:.9;
transform:translateY(-2px);
}

.view{
background:#2563eb;
}

.edit{
background:#f59e0b;
}

.payment{
background:#16a34a;
}

.delete{
background:#dc2626;
}

@media(max-width:768px){

.events-grid{
grid-template-columns:1fr;
}

.page-header{
flex-direction:column;
align-items:flex-start;
gap:15px;
}

.search-form{
flex-direction:column;
}

.actions{
flex-direction:column;
}

}

</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<%@ include file="../partials/toast.jsp"%>

<div class="main-content">

<div class="page-header">

<div class="page-title">

<h1>📅 View Events</h1>

<p>Manage all your customer events.</p>

</div>

<div class="header-buttons">

<a href="${pageContext.request.contextPath}/add-event"
class="btn green">

<i class="fa-solid fa-plus"></i>

Add Event

</a>

<a href="${pageContext.request.contextPath}/events"
class="btn gray">

<i class="fa-solid fa-house"></i>

Dashboard

</a>

</div>

</div>

<div class="search-card">

<form class="search-form"
method="get"
action="${pageContext.request.contextPath}/view-events">

<input
type="text"
name="keyword"
placeholder="Search customer, event or phone..."
value="<%=keyword%>">

<button class="btn blue">

<i class="fa-solid fa-search"></i>

Search

</button>

</form>

<div class="filters">

<a class="filter <%=filter.equals("all")?"active":""%>"
href="${pageContext.request.contextPath}/view-events">
All
</a>

<a class="filter <%=filter.equals("today")?"active":""%>"
href="${pageContext.request.contextPath}/view-events?filter=today">
Today's
</a>

<a class="filter <%=filter.equals("upcoming")?"active":""%>"
href="${pageContext.request.contextPath}/view-events?filter=upcoming">
Upcoming
</a>

<a class="filter <%=filter.equals("pending")?"active":""%>"
href="${pageContext.request.contextPath}/view-events?filter=pending">
Pending Payments
</a>

</div>

</div>

<div class="events-grid">


<%
if(events != null && !events.isEmpty()){

    for(Event event : events){

        String status = event.getPaymentStatus();

        if(status == null){
            status = "PENDING";
        }

        String cardClass = "pending";

        if(status.equalsIgnoreCase("PAID")){
            cardClass = "paid";
        }else if(status.equalsIgnoreCase("PARTIAL")){
            cardClass = "partial";
        }
%>

<div class="event-card" style="border-left:6px solid
<%=cardClass.equals("paid")?"#22c55e":
cardClass.equals("partial")?"#f59e0b":"#ef4444"%>;">

    <!-- Header -->

    <div class="event-header">

        <div>

            <div class="event-title">

                <i class="fa-solid fa-calendar-days"></i>

                <%=event.getEventTitle()%>

            </div>

        </div>

        <div>

            <span class="status <%=cardClass%>">

                <%=status.toUpperCase()%>

            </span>

        </div>

    </div>

    <!-- Customer -->

    <div class="info">

        <i class="fa-solid fa-user"></i>

        <strong>Customer :</strong>

        <span><%=event.getCustomerName()%></span>

    </div>

    <!-- Phone -->

    <div class="info">

        <i class="fa-solid fa-phone"></i>

        <strong>Phone :</strong>

        <span><%=event.getPhone()%></span>

    </div>

    <!-- Date -->

    <div class="info">

        <i class="fa-solid fa-calendar"></i>

        <strong>Date :</strong>

        <span><%=event.getEventDate()%></span>

    </div>

    <!-- Time -->

    <div class="info">

        <i class="fa-solid fa-clock"></i>

        <strong>Time :</strong>

        <span><%=event.getEventTime()%></span>

    </div>

    <!-- Location -->

    <div class="info">

        <i class="fa-solid fa-location-dot"></i>

        <strong>Location :</strong>

        <span><%=event.getLocation()%></span>

    </div>

    <!-- Action Buttons -->

    <div class="actions">

        <a class="action-btn view"
           href="${pageContext.request.contextPath}/view-event?id=<%=event.getEventId()%>">

            <i class="fa-solid fa-eye"></i>

            View

        </a>

        <a class="action-btn edit"
           href="${pageContext.request.contextPath}/edit-event?id=<%=event.getEventId()%>">

            <i class="fa-solid fa-pen"></i>

            Edit

        </a>

<%
        if(!"PAID".equalsIgnoreCase(status)){
%>

       <a class="action-btn payment"
   href="${pageContext.request.contextPath}/event-receive-payment?eventId=<%=event.getEventId()%>">
    <i class="fa-solid fa-money-bill-wave"></i>
    Payment
</a>
<%
        }
%>

        <a class="action-btn delete"
           href="${pageContext.request.contextPath}/delete-event?id=<%=event.getEventId()%>"
           onclick="return confirm('Are you sure you want to delete this event?');">

            <i class="fa-solid fa-trash"></i>

            Delete

        </a>

    </div>

</div>

<%
    }

}else{
%>

<div class="event-card">

    <div style="text-align:center;padding:50px;">

        <i class="fa-solid fa-calendar-xmark"
           style="font-size:70px;color:#d1d5db;"></i>

        <h2 style="margin-top:20px;color:#1F3C88;">

            No Events Found

        </h2>

        <p style="margin-top:10px;color:#666;">

            There are no events matching your search.

        </p>

        <br>

        <a href="${pageContext.request.contextPath}/add-event"
           class="btn green">

            <i class="fa-solid fa-plus"></i>

            Add First Event

        </a>

    </div>

</div>

<%
}
%>


</div>

<div style="margin-top:30px;
display:flex;
justify-content:space-between;
align-items:center;
flex-wrap:wrap;
gap:15px;">

    <div>

        <h3 style="color:#1F3C88;">

            <i class="fa-solid fa-calendar-days"></i>

            Total Events :
            <%=events!=null?events.size():0%>

        </h3>

    </div>

    <div>

        <a href="${pageContext.request.contextPath}/events"
           class="btn gray">

            <i class="fa-solid fa-house"></i>

            Dashboard

        </a>

        <a href="${pageContext.request.contextPath}/add-event"
           class="btn green">

            <i class="fa-solid fa-plus"></i>

            Add Event

        </a>

    </div>

</div>

</div>

<!-- Scroll To Top -->

<button id="scrollBtn">

    <i class="fa-solid fa-arrow-up"></i>

</button>

<style>

#scrollBtn{

position:fixed;

bottom:25px;

right:25px;

width:55px;

height:55px;

border:none;

border-radius:50%;

background:#2563eb;

color:white;

font-size:20px;

cursor:pointer;

display:none;

box-shadow:0 8px 20px rgba(0,0,0,.25);

transition:.3s;

z-index:999;

}

#scrollBtn:hover{

transform:translateY(-5px);

background:#1d4ed8;

}

</style>

<script>

const btn=document.getElementById("scrollBtn");

window.addEventListener("scroll",function(){

if(window.scrollY>250){

btn.style.display="block";

}else{

btn.style.display="none";

}

});

btn.onclick=function(){

window.scrollTo({

top:0,

behavior:"smooth"

});

};

// Fade animation

document.querySelectorAll(".event-card").forEach(function(card,index){

card.style.opacity="0";

card.style.transform="translateY(30px)";

setTimeout(function(){

card.style.transition=".5s";

card.style.opacity="1";

card.style.transform="translateY(0)";

},index*120);

});

// Auto Focus Search

const search=document.querySelector("input[name='keyword']");

if(search){

search.focus();

}

</script>

</body>

</html>