<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ page import="com.digitalpurohit.model.DashboardReport"%>

<%
DashboardReport report =
(DashboardReport) request.getAttribute("report");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Reports Dashboard</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/reports.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<div class="page-header">

<h1>

<i class="fa-solid fa-chart-line"></i>

Reports Dashboard

</h1>

<p>

Analytics & Business Reports

</p>

</div>

<!-- ================= SUMMARY ================= -->

<div class="summary-grid">

<div class="summary-card blue">

<i class="fa-solid fa-calendar-days"></i>

<h2><%=report.getTotalEvents()%></h2>

<p>Total Events</p>

</div>

<div class="summary-card green">

<i class="fa-solid fa-users"></i>

<h2><%=report.getTotalCustomers()%></h2>

<p>Customers</p>

</div>

<div class="summary-card orange">

<i class="fa-solid fa-people-group"></i>

<h2><%=report.getTotalBulkEvents()%></h2>

<p>Bulk Events</p>

</div>

<div class="summary-card purple">

<i class="fa-solid fa-wallet"></i>

<h2>₹ <%=report.getTotalIncome()%></h2>

<p>Total Income</p>

</div>

<div class="summary-card teal">

<i class="fa-solid fa-circle-check"></i>

<h2>₹ <%=report.getTotalPaid()%></h2>

<p>Amount Paid</p>

</div>

<div class="summary-card red">

<i class="fa-solid fa-clock"></i>

<h2>₹ <%=report.getTotalPending()%></h2>

<p>Pending Amount</p>

</div>

</div>

<!-- ================= CHART PLACE HOLDERS ================= -->




<!-- ================= REPORTS ================= -->

<div class="report-grid">

<a href="${pageContext.request.contextPath}/event-reports"
class="report-card">

<i class="fa-solid fa-calendar-check"></i>

<h3>

Event Reports

</h3>

<p>

View Daily Event Reports

</p>

</a>

<a href="${pageContext.request.contextPath}/bulk-event-reports"
   class="report-card">

    <i class="fa-solid fa-people-group"></i>

    <h3>Bulk Event Reports</h3>

    <p>View All Bulk Event Reports</p>

</a>
<a class="report-card"
href="${pageContext.request.contextPath}/income-reports">

    <div class="icon">

        <i class="fa-solid fa-indian-rupee-sign"></i>

    </div>

    <h3>Income Reports</h3>

    <p>Monthly & Annual Income</p>

</a>
<a href="${pageContext.request.contextPath}/customer-reports"
   class="report-card">

    <i class="fa-solid fa-users"></i>

    <h3>

        Customer Reports

    </h3>

    <p>

        Customer History & Statistics

    </p>

</a>

</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>

const months=[
"Jan","Feb","Mar","Apr","May","Jun",
"Jul","Aug","Sep","Oct","Nov","Dec"
];

// Monthly Income

new Chart(document.getElementById("monthlyIncomeChart"),{

    type:"line",

    data:{

        labels:months,

        datasets:[{

            label:"Monthly Income",

            data:[
            	<%=report.getMonthlyIncome()[0]%>,
            	<%=report.getMonthlyIncome()[1]%>,
            	<%=report.getMonthlyIncome()[2]%>,
            	<%=report.getMonthlyIncome()[3]%>,
            	<%=report.getMonthlyIncome()[4]%>,
            	<%=report.getMonthlyIncome()[5]%>,
            	<%=report.getMonthlyIncome()[6]%>,
            	<%=report.getMonthlyIncome()[7]%>,
            	<%=report.getMonthlyIncome()[8]%>,
            	<%=report.getMonthlyIncome()[9]%>,
            	<%=report.getMonthlyIncome()[10]%>,
            	<%=report.getMonthlyIncome()[11]%>
            	],
            borderWidth:3,

            tension:.4,

            fill:false

        }]

    },

    options:{
        responsive:true,
        maintainAspectRatio:false
    }

});

// Monthly Events

new Chart(document.getElementById("monthlyEventsChart"),{

    type:"bar",

    data:{

        labels:months,

        datasets:[{

            label:"Monthly Events",

            data:[
            	<%=report.getMonthlyEvents()[0]%>,
            	<%=report.getMonthlyEvents()[1]%>,
            	<%=report.getMonthlyEvents()[2]%>,
            	<%=report.getMonthlyEvents()[3]%>,
            	<%=report.getMonthlyEvents()[4]%>,
            	<%=report.getMonthlyEvents()[5]%>,
            	<%=report.getMonthlyEvents()[6]%>,
            	<%=report.getMonthlyEvents()[7]%>,
            	<%=report.getMonthlyEvents()[8]%>,
            	<%=report.getMonthlyEvents()[9]%>,
            	<%=report.getMonthlyEvents()[10]%>,
            	<%=report.getMonthlyEvents()[11]%>
            	]
        }]

    },

    options:{
        responsive:true,
        maintainAspectRatio:false
    }

});

// Annual Income

new Chart(document.getElementById("annualIncomeChart"),{

    type:"bar",

    data:{

        labels:[
            "<%=report.getYears()[0]%>",
            "<%=report.getYears()[1]%>",
            "<%=report.getYears()[2]%>",
            "<%=report.getYears()[3]%>",
            "<%=report.getYears()[4]%>"
        ],

        datasets:[{

            label:"Annual Income",

            data:[
                <%=report.getYearlyIncome()[0]%>,
                <%=report.getYearlyIncome()[1]%>,
                <%=report.getYearlyIncome()[2]%>,
                <%=report.getYearlyIncome()[3]%>,
                <%=report.getYearlyIncome()[4]%>
            ],

            borderWidth:1

        }]

    },

    options:{

        responsive:true,

        maintainAspectRatio:false

    }

});
// Payment Status

new Chart(document.getElementById("paymentChart"),{

    type:"doughnut",

    data:{

        labels:["Paid","Pending","Partial"],

        datasets:[{

            data:[
                <%=report.getPaidCount()%>,
                <%=report.getPendingCount()%>,
                <%=report.getPartialCount()%>
            ],

            backgroundColor:[
                "#28a745",
                "#dc3545",
                "#ffc107"
            ]

        }]
    },

    options:{
        responsive:true,
        maintainAspectRatio:false
    }

});

</script>
</body>

</html>