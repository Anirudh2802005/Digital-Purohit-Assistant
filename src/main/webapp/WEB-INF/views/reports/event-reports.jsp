<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.digitalpurohit.model.EventReport" %>

<%

List<EventReport> reports =
    (List<EventReport>) request.getAttribute("reports");

int totalEvents =
    request.getAttribute("totalEvents") == null ? 0 :
    (Integer) request.getAttribute("totalEvents");

double totalIncome =
    request.getAttribute("totalIncome") == null ? 0 :
    (Double) request.getAttribute("totalIncome");

double totalPaid =
    request.getAttribute("totalPaid") == null ? 0 :
    (Double) request.getAttribute("totalPaid");

double totalPending =
    request.getAttribute("totalPending") == null ? 0 :
    (Double) request.getAttribute("totalPending");


/*
 * Calculate unique customers
 */
Set<String> uniqueCustomers = new HashSet<>();

if (reports != null) {

    for (EventReport report : reports) {

        if (report.getCustomerName() != null) {

            uniqueCustomers.add(
                report.getCustomerName().trim()
            );

        }

    }

}

int totalCustomers = uniqueCustomers.size();

%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Event Reports</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/layout.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/reports.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">

</head>


<body>


<!-- ================= NAVBAR ================= -->

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />


<!-- ================= SIDEBAR ================= -->

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<!-- ================= MAIN CONTENT ================= -->

<div class="main-content">


    <!-- ================= PAGE HEADER ================= -->

    <div class="report-page-header">

        <h1>

            <i class="fa-solid fa-chart-column"></i>

            Event Reports

        </h1>

    </div>


    <!-- ================= SUMMARY CARDS ================= -->

    <div class="report-summary">


        <!-- TOTAL EVENTS -->

        <div class="summary-card">

            <div class="summary-icon">

                <i class="fa-solid fa-calendar-days"></i>

            </div>

            <div class="summary-value">

                <%= totalEvents %>

            </div>

            <div class="summary-label">

                Total Events

            </div>

        </div>


        <!-- TOTAL CUSTOMERS -->

        <div class="summary-card">

            <div class="summary-icon">

                <i class="fa-solid fa-users"></i>

            </div>

            <div class="summary-value">

                <%= totalCustomers %>

            </div>

            <div class="summary-label">

                Total Customers

            </div>

        </div>


        <!-- TOTAL AMOUNT -->

        <div class="summary-card">

            <div class="summary-icon">

                <i class="fa-solid fa-indian-rupee-sign"></i>

            </div>

            <div class="summary-value">

                ₹ <%= String.format("%.2f", totalIncome) %>

            </div>

            <div class="summary-label">

                Total Amount

            </div>

        </div>


    </div>


    <!-- ================= SEARCH + ACTIONS ================= -->

    <div class="report-toolbar">


        <!-- SEARCH -->

        <div class="report-search">

            <input
                type="text"
                id="eventReportSearch"
                placeholder="Search Event..."
                onkeyup="searchEventReports()">

        </div>


        <!-- ACTION BUTTONS -->

        <div class="report-actions">


            <button
                onclick="window.print()"
                class="action-btn print-btn">

                <i class="fa-solid fa-print"></i>

                Print

            </button>


            <a
                href="${pageContext.request.contextPath}/export-event-pdf"
                class="action-btn pdf-btn">

                <i class="fa-solid fa-file-pdf"></i>

                PDF

            </a>


            <a
                href="${pageContext.request.contextPath}/export-event-excel"
                class="action-btn excel-btn">

                <i class="fa-solid fa-file-excel"></i>

                Excel

            </a>


        </div>

    </div>



    <!-- ================= EVENT REPORT TABLE ================= -->

    <div class="table-container">

        <table class="report-table" id="eventReportTable">


            <thead>

                <tr>

                    <th>Date</th>

                    <th>Customer</th>

                    <th>Event</th>

                    <th>Total Amount</th>

                    <th>Paid</th>

                    <th>Pending</th>

                    <th>Status</th>

                </tr>

            </thead>


            <tbody>


            <%

            if (reports != null && !reports.isEmpty()) {

                for (EventReport report : reports) {

            %>


                <tr>


                    <!-- DATE -->

                    <td>

                        <%= report.getEventDate() %>

                    </td>


                    <!-- CUSTOMER -->

                    <td>

                        <%= report.getCustomerName() %>

                    </td>


                    <!-- EVENT -->

                    <td>

                        <%= report.getEventTitle() %>

                    </td>


                    <!-- TOTAL -->

                    <td>

                        ₹ <%= String.format(
                            "%.2f",
                            report.getTotalAmount()
                        ) %>

                    </td>


                    <!-- PAID -->

                    <td>

                        ₹ <%= String.format(
                            "%.2f",
                            report.getAmountPaid()
                        ) %>

                    </td>


                    <!-- PENDING -->

                    <td>

                        ₹ <%= String.format(
                            "%.2f",
                            report.getPendingAmount()
                        ) %>

                    </td>


                    <!-- STATUS -->

                    <td>


                    <%

                    String status =
                        report.getPaymentStatus();


                    if ("PAID".equals(status)) {

                    %>


                        <span class="status paid">

                            PAID

                        </span>


                    <%

                    } else {

                    %>


                        <a
                            href="${pageContext.request.contextPath}/event-receive-payment?eventId=<%= report.getEventId() %>&source=reports"
                            class="status-link">


                            <span class="status <%= status.toLowerCase() %>">

                                <%= status %>

                            </span>


                        </a>


                    <%

                    }

                    %>


                    </td>


                </tr>


            <%

                }

            } else {

            %>


                <tr>

                    <td
                        colspan="7"
                        style="text-align:center;padding:30px;">

                        No Event Reports Available.

                    </td>

                </tr>


            <%

            }

            %>


            </tbody>


        </table>

    </div>


</div>



<!-- ================= SEARCH SCRIPT ================= -->

<script>

function searchEventReports() {

    const input =
        document.getElementById("eventReportSearch");

    const filter =
        input.value.toLowerCase();

    const table =
        document.getElementById("eventReportTable");

    const rows =
        table.getElementsByTagName("tbody")[0]
             .getElementsByTagName("tr");


    for (let i = 0; i < rows.length; i++) {

        const rowText =
            rows[i].innerText.toLowerCase();


        if (rowText.includes(filter)) {

            rows[i].style.display = "";

        } else {

            rows[i].style.display = "none";

        }

    }

}

</script>


</body>

</html>