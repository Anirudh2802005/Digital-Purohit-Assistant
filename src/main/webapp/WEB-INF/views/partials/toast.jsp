<%
String success = (String) request.getAttribute("success");
String error = (String) request.getAttribute("error");
String warning = (String) request.getAttribute("warning");

if (success == null) success = request.getParameter("success");
if (error == null) error = request.getParameter("error");
if (warning == null) warning = request.getParameter("warning");
%>



<div id="toastContainer">

<% if(success!=null){ %>

<div class="toast success">

✅ <%=success%>

</div>

<% } %>

<% if(error!=null){ %>

<div class="toast error">

❌ <%=error%>

</div>

<% } %>

<% if(warning!=null){ %>

<div class="toast warning">

⚠ <%=warning%>

</div>

<% } %>

</div>

<script>

setTimeout(function(){

const container=document.getElementById("toastContainer");

if(container){

container.style.display="none";

}

},3500);

</script>

