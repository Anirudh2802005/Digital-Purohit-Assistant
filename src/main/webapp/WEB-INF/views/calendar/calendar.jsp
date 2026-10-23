<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.time.*"%>
<%@ page import="java.time.format.TextStyle"%>
<%@ page import="com.digitalpurohit.model.CalendarDay"%>

<%
List<CalendarDay> calendarDays =
        (List<CalendarDay>) request.getAttribute("calendarDays");

CalendarDay selectedDay =
        (CalendarDay) request.getAttribute("selectedDay");

Integer month =
        (Integer) request.getAttribute("month");

Integer year =
        (Integer) request.getAttribute("year");

if(month==null){
    month=LocalDate.now().getMonthValue();
}

if(year==null){
    year=LocalDate.now().getYear();
}

String monthName =
        Month.of(month)
        .getDisplayName(TextStyle.FULL, Locale.ENGLISH);
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Telugu Calendar</title>

<meta name="viewport"
content="width=device-width,initial-scale=1">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/calendar.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

</head>

<body>

<div class="dashboard-container">

    <jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />
    

    <div class="main-content">

        <!-- HEADER -->

        <div class="calendar-header">

            <div>

                <h2>

                    🛕 Telugu Calendar

                </h2>

                <p>

                    Digital Purohit Assistant

                </p>

            </div>

            <div class="today-box">

                <strong>Today</strong>

                <br>

                <%=LocalDate.now()%>

            </div>

        </div>

        <!-- TOOLBAR -->

        <div class="calendar-toolbar">

            <a class="nav-btn"

               href="calendar?month=<%=month==1?12:month-1%>&year=<%=month==1?year-1:year%>">

                <i class="fa-solid fa-angle-left"></i>

                Previous

            </a>

            <h2 class="month-title">

                <%=monthName%> <%=year%>

            </h2>

            <a class="nav-btn"

               href="calendar?month=<%=month==12?1:month+1%>&year=<%=month==12?year+1:year%>">

                Next

                <i class="fa-solid fa-angle-right"></i>

            </a>
             <a class="import-btn"
       href="${pageContext.request.contextPath}/import-panchang">

        <i class="fa-solid fa-file-import"></i>

        Import Calendar

    </a>
            

        </div>

        <!-- SEARCH -->

       <div class="search-bar">

    <form action="calendar" method="get">

        <input
            type="date"
            name="selected"
            required>

        <button class="search-btn" type="submit">

            <i class="fa-solid fa-magnifying-glass"></i>

            Search

        </button>

    </form>

</div>

        <!-- CALENDAR -->

        <div class="calendar-container">

            <div class="calendar-grid">

                <div class="day-header">Sun</div>
                <div class="day-header">Mon</div>
                <div class="day-header">Tue</div>
                <div class="day-header">Wed</div>
                <div class="day-header">Thu</div>
                <div class="day-header">Fri</div>
                <div class="day-header">Sat</div>

<%
if(calendarDays!=null){

for(CalendarDay day : calendarDays){

String css="day-card";

if(!day.isCurrentMonth()){

    css+=" other-month";

}

if(day.isToday()){

    css+=" today";

}

if(day.isSelected()){

    css+=" selected";

}
%>

<div class="<%=css%>"
     onclick="window.location='calendar?month=<%=month%>&year=<%=year%>&selected=<%=day.getDate()%>#details'">

    <div class="day-number">

        <%=day.getDay()%>

    </div>
    
        <div class="day-tithi">

        <%
        if(day.getTithi()!=null &&
           !day.getTithi().trim().isEmpty()){
        %>

            <%=day.getTithi()%>

        <%
        }
        %>

    </div>

    <%
    if(day.getFestival()!=null &&
       !day.getFestival().trim().isEmpty()){
    %>

        
        <%
String festival = day.getFestival();

if(festival != null && !festival.trim().isEmpty()){
%>

<div class="day-festival">

    🎉 <%=festival%>

</div>

<%
}

if(day.getEventCount() > 0){
%>

<div class="event-badge">

    🟢 <%=day.getEventCount()%>
    Event<%=day.getEventCount() > 1 ? "s" : ""%>

</div>

<%
}
%>
        

    <%
    }
    %>

</div>

<%
}
}
%>

</div>

</div>

<!-- ===========================
     SELECTED DATE DETAILS
=========================== -->

<div

id="details"

class="details-card">

<h2>

📅 Selected Date Details

</h2>

<%

if(selectedDay!=null){

%>

<div class="details-grid">

    <div class="detail-item">
        <span>📅 Date</span>
        <strong><%=selectedDay.getDate()%></strong>
    </div>

    <div class="detail-item">
        <span>📆 Weekday</span>
        <strong><%=selectedDay.getWeekday()%></strong>
    </div>

    <div class="detail-item">
        <span>🕉 Tithi</span>
        <strong><%=selectedDay.getTithi()%></strong>
    </div>

    <div class="detail-item">
        <span>⏰ Tithi Ends</span>
        <strong><%=selectedDay.getTithiEndTime()%></strong>
    </div>

    <div class="detail-item">
        <span>⭐ Nakshatra</span>
        <strong><%=selectedDay.getNakshatra()%></strong>
    </div>

    <div class="detail-item">
        <span>⏰ Nakshatra Ends</span>
        <strong><%=selectedDay.getNakshatraEndTime()%></strong>
    </div>

    <div class="detail-item">
        <span>🌅 Sunrise</span>
        <strong><%=selectedDay.getSunrise()%></strong>
    </div>

    <div class="detail-item">
        <span>🌇 Sunset</span>
        <strong><%=selectedDay.getSunset()%></strong>
    </div>

    <div class="detail-item full-width">
        <span>🎉 Festival</span>
        <strong>
            <%=selectedDay.getFestival()==null || selectedDay.getFestival().isBlank()
                ? "No Festival"
                : selectedDay.getFestival()%>
        </strong>
    </div>

    <div class="detail-item full-width">
        <span>📝 Notes</span>
        <strong>
            <%=selectedDay.getNotes()==null || selectedDay.getNotes().isBlank()
                ? "--"
                : selectedDay.getNotes()%>
        </strong>
    </div>

</div>

<%

}else{

%>

<div class="empty-details">

Select any date to view Panchang details.

</div>

<%

}

%>

</div>

<!-- ===========================
     FOOTER
=========================== -->

<div class="calendar-footer">

    <p>

        © <%=LocalDate.now().getYear()%> Digital Purohit Assistant

    </p>

</div>

</div>
<!-- End Main Content -->

</div>
<!-- End Dashboard Container -->

<script>

document.addEventListener("DOMContentLoaded", function () {

    /* ------------------------------
       Scroll to Details
    ------------------------------ */

    if (window.location.hash === "#details") {

        const details = document.getElementById("details");

        if (details) {

            details.scrollIntoView({

                behavior: "smooth",
                block: "start"

            });

        }

    }

    /* ------------------------------
       Date Search Validation
    ------------------------------ */

    const searchForm = document.querySelector(".search-container form");

    if (searchForm) {

        searchForm.addEventListener("submit", function (e) {

            const input = document.querySelector("input[name='selected']");

            if (input.value === "") {

                e.preventDefault();

                alert("Please select a date.");

            }

        });

    }

    /* ------------------------------
       Highlight Selected Card
    ------------------------------ */

    const selected = document.querySelector(".day-card.selected");

    if (selected) {

        selected.scrollIntoView({

            behavior: "smooth",
            block: "center"

        });

    }

});

</script>

<script src="${pageContext.request.contextPath}/assets/js/calendar.js"></script>

</body>

</html>