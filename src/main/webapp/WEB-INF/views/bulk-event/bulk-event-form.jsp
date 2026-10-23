<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="com.digitalpurohit.model.BulkEvent"%>

<%
BulkEvent bulkEvent =
(BulkEvent)request.getAttribute("bulkEvent");

boolean editMode =
(bulkEvent != null);
%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>

<%= editMode ? "Edit Bulk Event" : "Create Bulk Event" %>

</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/bulk-event-form.css">

<link rel="preconnect"
href="https://fonts.googleapis.com">

<link rel="preconnect"
href="https://fonts.gstatic.com"
crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
rel="stylesheet">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<!-- ================= HEADER ================= -->

<div class="page-header">

    <div>

        <h1 class="page-title">

            <i class="fa-solid fa-calendar-plus"></i>

            <%= editMode ? "Edit Bulk Event" : "Create Bulk Event" %>

        </h1>

        <p class="page-subtitle">

            <%= editMode ?
            "Update your bulk event information."
            :
            "Create and organize bulk events professionally." %>

        </p>

    </div>

    <a href="${pageContext.request.contextPath}/bulk-events"
       class="back-btn">

        <i class="fa-solid fa-arrow-left"></i>

        Back

    </a>

</div>

<!-- ================= FORM CARD ================= -->

<div class="form-card">

<form
action="${pageContext.request.contextPath}/<%= editMode ? "edit-bulk-event" : "add-bulk-event" %>"
method="post">

<%
if(editMode){
%>

<input
type="hidden"
name="yatraId"
value="<%= bulkEvent.getYatraId() %>">

<%
}
%>

<div class="form-section">

<h2>

<i class="fa-solid fa-scroll"></i>

Event Information

</h2>

<div class="form-group">

<label>

Event Name <span>*</span>

</label>

<input
type="text"
name="bulkEventName"
placeholder="Enter Bulk Event Name"
value="<%= editMode ? bulkEvent.getBulkEventName() : "" %>"
required>

</div>

<div class="date-grid">

<div class="form-group">

<label>

Start Date <span>*</span>

</label>

<input
type="date"
name="startDate"
value="<%= editMode ? bulkEvent.getStartDate() : "" %>"
required>

</div>

<div class="form-group">

<label>

End Date <span>*</span>

</label>

<input
type="date"
name="endDate"
value="<%= editMode ? bulkEvent.getEndDate() : "" %>"
required>

</div>

</div>

<div class="form-group">

<label>

Location

</label>

<input
type="text"
name="location"
placeholder="Enter Event Location"
value="<%= editMode ? bulkEvent.getLocation() : "" %>">

</div>

<div class="form-group">

<label>

Notes

</label>

<textarea
name="notes"
rows="5"
placeholder="Additional notes..."><%= editMode ? bulkEvent.getNotes() : "" %></textarea>

</div>

<div class="button-group">

<a href="${pageContext.request.contextPath}/bulk-events"
   class="btn btn-cancel">

    <i class="fa-solid fa-xmark"></i>

    Cancel

</a>

<button
type="submit"
class="btn btn-save">

    <i class="fa-solid fa-floppy-disk"></i>

    <%= editMode ? "Update Bulk Event" : "Save Bulk Event" %>

</button>

</div>

</div>

</form>

</div>

</div>

</body>

</html>