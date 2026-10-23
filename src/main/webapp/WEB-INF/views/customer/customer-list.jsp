<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.Customer"%>

<%
List<Customer> customers =
(List<Customer>)request.getAttribute("customers");
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>View Customers</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/customer-list.css">

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

    <!-- Header -->

    <div class="page-header">

        <h1>👥 View Customers</h1>

        <p>Search, edit and manage all registered customers.</p>

    </div>

    <!-- Search -->

    <div class="search-card">

        <form action="${pageContext.request.contextPath}/view-customers"
              method="get">

            <input
                type="text"
                name="keyword"
                placeholder="Search by Name / Phone / Gothram">

            <button type="submit"
                    class="btn-search">

                Search

            </button>

            <a href="${pageContext.request.contextPath}/view-customers"
               class="btn-reset">

                Reset

            </a>

        </form>

    </div>

    <!-- Table -->

    <div class="table-card">

        <table>

            <thead>

                <tr>

                    <th>ID</th>

                    <th>Customer Name</th>

                    <th>Phone</th>

                    <th>Address</th>

                    <th>Gothram</th>

                    <th>Actions</th>

                </tr>

            </thead>

<tbody>

<%

if(customers != null && !customers.isEmpty()){

    for(Customer customer : customers){

%>

<tr>

    <td>

        <%= customer.getCustomerName() %>

    </td>

    <td>

        <%= customer.getPhone() %>

    </td>

    <td>

        <%= customer.getGothram() == null ?
        "-" :
        customer.getGothram() %>

    </td>

    <td style="text-align:center;">

        <span class="event-count">

            <%= customer.getTotalEvents() %>

        </span>

    </td>

    <td>

        <a class="btn-view"
           href="${pageContext.request.contextPath}/customer-history?customerId=<%=customer.getCustomerId()%>">

            👁 View

        </a>

        <a class="btn-edit"
           href="${pageContext.request.contextPath}/edit-customer?customerId=<%=customer.getCustomerId()%>">

            ✏ Edit

        </a>

        <a class="btn-delete"
           href="${pageContext.request.contextPath}/delete-customer?customerId=<%=customer.getCustomerId()%>"
           onclick="return confirm('Are you sure you want to delete this customer?');">

            🗑 Delete

        </a>

    </td>

</tr>

<%

    }

}else{

%>

<tr>

    <td colspan="5"
        style="text-align:center;padding:30px;">

        No Customers Found

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