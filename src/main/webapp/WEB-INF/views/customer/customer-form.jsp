<%@ page contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>

<%@ page import="com.digitalpurohit.model.Customer" %>

<%
Customer customer =
(Customer) request.getAttribute("customer");

boolean editMode =
(customer != null);
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>
<%= editMode ? "Edit Customer" : "Add Customer" %>
</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/customer-form.css">
</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

    <div class="page-header">

        <h1>

            <%= editMode ? "✏ Edit Customer" : "👥 Add Customer" %>

        </h1>

        <p>

            <%= editMode ?
            "Update customer information." :
            "Register a new customer in the system." %>

        </p>

    </div>

    <div class="form-card">

        <form action="${pageContext.request.contextPath}/<%= editMode ? "edit-customer" : "add-customer" %>"
              method="post">

            <% if(editMode){ %>

            <input type="hidden"
                   name="customerId"
                   value="<%= customer.getCustomerId() %>">

            <% } %>

            <div class="form-row">

                <div class="form-group">

                    <label>Customer Name <span>*</span></label>

                    <input type="text"
                           name="customerName"
                           placeholder="Enter Customer Name"
                           value="<%= editMode ? customer.getCustomerName() : "" %>"
                           required>

                </div>

                <div class="form-group">

                    <label>Phone Number <span>*</span></label>

                    <input type="text"
                           name="phone"
                           placeholder="Enter Phone Number"
                           value="<%= editMode ? customer.getPhone() : "" %>"
                           required>

                </div>

            </div>

            <div class="form-group">

                <label>Address</label>

                <textarea name="address"
                          rows="4"
                          placeholder="Enter Address"><%= editMode ? customer.getAddress() : "" %></textarea>

            </div>

            <div class="form-row">

                <div class="form-group">

                    <label>Gothram</label>

                    <input type="text"
                           name="gothram"
                           placeholder="Enter Gothram"
                           value="<%= editMode ? customer.getGothram() : "" %>">

                </div>

            </div>

            <div class="form-group">

                <label>Notes</label>

                <textarea name="notes"
                          rows="4"
                          placeholder="Additional Notes"><%= editMode ? customer.getNotes() : "" %></textarea>

            </div>

            <div class="form-buttons">

                <button type="submit"
                        class="btn-primary">

                    <%= editMode ? "Update Customer" : "Save Customer" %>

                </button>

                <button type="reset"
                        class="btn-secondary">

                    Reset

                </button>

                <a href="${pageContext.request.contextPath}/customers"
                   class="btn-cancel">

                    Cancel

                </a>

            </div>

        </form>

    </div>

</div>

<%@ include file="../partials/footer.jsp" %>

</body>

</html>
