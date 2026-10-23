<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*"%>
<%@ page import="com.digitalpurohit.model.FrequentCustomer"%>

<%
List<FrequentCustomer> customers =
(List<FrequentCustomer>)request.getAttribute("frequentCustomers");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Frequent Customers</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/frequent-customers.css">

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

    <div class="page-header">

        <h1>⭐ Frequent Customers</h1>

        <p>Customers with the highest number of bookings.</p>

    </div>

    <div class="table-card">

        <table>

            <thead>

                <tr>

                    <th>Rank</th>

                    <th>Customer</th>

                    <th>Phone</th>

                    <th>Gothram</th>

                    <th>Total Events</th>

                    <th>Action</th>

                </tr>

            </thead>

            <tbody>

            <%

            if(customers!=null && !customers.isEmpty()){

                int rank=1;

                for(FrequentCustomer c:customers){

            %>

            <tr>

                <td><%=rank++%></td>

                <td><%=c.getCustomerName()%></td>

                <td><%=c.getPhone()%></td>

                <td><%=c.getGothram()%></td>

                <td>

                    <span class="event-count">

                        <%=c.getTotalEvents()%>

                    </span>

                </td>

                <td>

                    <a class="btn-history"
href="${pageContext.request.contextPath}/customer-history?customerId=<%=c.getCustomerId()%>">

    View History

</a>>

                </td>

            </tr>

            <%

                }

            }

            else{

            %>

            <tr>

                <td colspan="6"

                    style="text-align:center;padding:40px;">

                    No frequent customers found.

                </td>

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