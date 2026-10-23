<%@ page contentType="text/html;charset=UTF-8" %>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/profile.css">
      <link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">
<div class="main-content">
<%
String success = request.getParameter("success");
if ("1".equals(success)) {
%>

<div class="toast success">
    ✅ Profile Updated Successfully!
</div>

<%
}
%>
    <h2>👤 My Profile</h2>

    <div class="profile-card">

        <form action="${pageContext.request.contextPath}/update-profile"
              method="post"
              enctype="multipart/form-data">

            <!-- IMAGE -->
            <div class="profile-img">
               <c:choose>

    <c:when test="${not empty admin.profileImage}">
        <img src="${pageContext.request.contextPath}/uploads/${admin.profileImage}"
             class="profile-image"
             alt="Profile">
    </c:when>

    <c:otherwise>
        <div class="profile-avatar-text">
            ${admin.name.substring(0,2).toUpperCase()}
        </div>
    </c:otherwise>

</c:choose>
            </div>

            <input type="file" name="image" class="file-input">

            <!-- NAME -->
            <label>Name</label>
            <input type="text" name="name" value="${admin.name}" required>

            <!-- EMAIL -->
            <label>Email</label>
            <input type="email" name="email" value="${admin.email}" required>

            <!-- PHONE -->
            <label>Phone</label>
            <input type="text" name="phone" value="${admin.phone}" required>

            <button type="submit" class="btn-save">
                💾 Update Profile
            </button>

        </form>

    </div>

</div>