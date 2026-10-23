<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.*" %>
<%@ page import="com.digitalpurohit.model.Customer" %>
<%@ page import="com.digitalpurohit.model.CustomerHistory" %>

<%
Customer customer =
(Customer)request.getAttribute("customer");

List<CustomerHistory> history =
(List<CustomerHistory>)request.getAttribute("history");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Customer History</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/customer-history.css">

</head>

<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

    <div class="page-header">

        <h1>👤 Customer History</h1>

        <p>Complete customer profile and booking history.</p>

    </div>

    <div class="profile-card">

        <div class="profile-grid">

            <div class="profile-item">

                <label>Name</label>

                <span><%=customer.getCustomerName()%></span>

            </div>

            <div class="profile-item">

                <label>Phone</label>

                <span><%=customer.getPhone()%></span>

            </div>

            <div class="profile-item">

                <label>Address</label>

                <span><%=customer.getAddress()%></span>

            </div>

            <div class="profile-item">

                <label>Gothram</label>

                <span><%=customer.getGothram()%></span>

            </div>

        </div>

    </div>

    <div class="summary-cards">

        <div class="summary-card">

            <h2>${totalEvents}</h2>

            <p>Total Events</p>

        </div>

        <div class="summary-card">

            <h2>₹ ${totalAmount}</h2>

            <p>Total Amount</p>

        </div>

        <div class="summary-card">

            <h2>₹ ${amountPaid}</h2>

            <p>Amount Paid</p>

        </div>

        <div class="summary-card">

            <h2>₹ ${pendingAmount}</h2>

            <p>Pending Amount</p>

        </div>

    </div>

    <div class="table-card">

        <table>

            <thead>

                <tr>

                    <th>Event</th>

                    <th>Date</th>

                    <th>Location</th>

                    <th>Payment</th>

                    <th>Amount</th>

                </tr>

            </thead>

            <tbody>

            <%

            for(CustomerHistory h:history){

            %>

            <tr>

                <td><%=h.getEventTitle()%></td>

                <td><%=h.getEventDate()%></td>

                <td><%=h.getLocation()%></td>

                <td><%=h.getPaymentStatus()%></td>

                <td>₹ <%=h.getAmount()%></td>

            </tr>

            <%

            }

            %>

            </tbody>

        </table>

    </div>

</div>

<%@ include file="../partials/footer.jsp"%>

</body>

</html>