<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.Customer"%>
<%@ page import="com.digitalpurohit.model.EventType"%>
<%@ page import="com.digitalpurohit.model.Event"%>

<%
Event event=(Event)request.getAttribute("event");
boolean editMode=(event!=null);

List<Customer> customers=
(List<Customer>)request.getAttribute("customers");

List<EventType> eventTypes=
(List<EventType>)request.getAttribute("eventTypes");
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>

<%=editMode ? "Edit Event" : "Add Event"%>

</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/layout.css">

<style>

*{
box-sizing:border-box;
margin:0;
padding:0;
font-family:Poppins,sans-serif;
}

.main-content{

padding:30px;

}

.page-title{

margin-bottom:25px;
font-size:28px;
font-weight:600;
color:#1e3a8a;

}

.form-card{

background:#fff;
border-radius:12px;
padding:30px;
box-shadow:0 5px 18px rgba(0,0,0,.08);

}

.section{

margin-bottom:30px;
padding:22px;
border:1px solid #e5e7eb;
border-radius:10px;
background:#fafafa;

}

.section h3{

margin-bottom:20px;
color:#2563eb;

}

.form-grid{

display:grid;
grid-template-columns:repeat(2,1fr);
gap:20px;

}

.full{

grid-column:1/-1;

}

label{

display:block;
margin-bottom:6px;
font-weight:600;

}

input,
select,
textarea{

width:100%;
padding:11px;
border:1px solid #d1d5db;
border-radius:6px;

}

textarea{

resize:vertical;

}

.radio-group{

display:flex;
gap:30px;
margin-top:10px;

}

.radio-group label{

display:flex;
align-items:center;
gap:8px;
font-weight:500;

}

button{

padding:12px 28px;
border:none;
border-radius:6px;
cursor:pointer;
font-size:15px;

}

.primary{

background:#2563eb;
color:white;

}

.secondary{

background:#6b7280;
color:white;

}

.actions{

display:flex;
justify-content:space-between;
margin-top:20px;

}

/* ============================= */
/* Samagri Grid */
/* ============================= */

.samagri-grid{

display:grid;
grid-template-columns:repeat(auto-fill,minmax(230px,1fr));
gap:15px;
margin-top:10px;

}

.samagri-card{

display:flex;
align-items:center;
justify-content:flex-start;
gap:12px;

padding:14px;

border:1px solid #dbeafe;
border-radius:10px;
background:#fff;

cursor:pointer;

}

.samagri-card input[type="checkbox"]{

width:18px;
height:18px;
flex-shrink:0;

}

.samagri-name{

display:inline-block;
color:#222;
font-size:15px;
font-weight:500;
white-space:normal;

}

.samagri-card:hover{

background:#eff6ff;
border-color:#3b82f6;

}

.samagri-card input{

width:18px;
height:18px;

}

.samagri-name{

font-size:15px;
font-weight:500;

}

.empty-box{

padding:18px;
border:2px dashed #cbd5e1;
border-radius:10px;
text-align:center;
color:#6b7280;
background:#f8fafc;

}
.extra-item{

display:flex;
justify-content:space-between;
align-items:center;
padding:10px;
margin-bottom:10px;
background:#f9fafb;
border:1px solid #e5e7eb;
border-radius:8px;

}

.remove-btn{

background:#ef4444;
color:white;
border:none;
padding:6px 12px;
border-radius:5px;
cursor:pointer;

}

.remove-btn:hover{

background:#dc2626;

}
.samagri-text{

    display:flex;

    align-items:center;

    color:#222;

    font-size:16px;

    font-weight:600;

    flex:1;

    white-space:normal;

    overflow:visible;

}
</style>

</head>

<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />


<div class="main-content">

<h2 class="page-title">

<%=editMode ? "✏ Edit Event" : "➕ Add Event"%>

</h2>

<div class="form-card">

<form
action="${pageContext.request.contextPath}/<%=editMode?"edit-event":"add-event"%>"
method="post">

<% if(editMode){ %>

<input
type="hidden"
name="eventId"
value="<%=event.getEventId()%>">

<% } %>

<!-- Customer Section -->

<div class="section">

<h3>👤 Customer Information</h3>

<div class="radio-group">

<label>

<input
type="radio"
name="customerType"
value="existing"
checked
onclick="toggleCustomerType()">

Existing Customer

</label>

<label>

<input
type="radio"
name="customerType"
value="new"
onclick="toggleCustomerType()">

New Customer

</label>

</div>

<br>

<div id="existingCustomerDiv">

<label>Select Customer</label>

<select
id="customerId"
name="customerId">

<%
for(Customer c:customers){
%>

<option
value="<%=c.getCustomerId()%>"
<%=editMode && c.getCustomerId()==event.getCustomerId()?"selected":""%>>

<%=c.getCustomerName()%>

</option>

<%
}
%>

</select>

</div>

<div
id="newCustomerDiv"
style="display:none;">

<div class="form-grid">

<div>

<label>Customer Name</label>

<input
type="text"
name="newCustomerName">

</div>

<div>

<label>Phone</label>

<input
type="text"
name="newCustomerPhone">

</div>

<div>

<label>Email</label>

<input
type="email"
name="newCustomerEmail">

</div>

<div>

<label>Address</label>

<textarea
name="newCustomerAddress"
rows="3"></textarea>

</div>

</div>

</div>

</div>

<!-- ========================================= -->
<!-- Event Information -->
<!-- ========================================= -->

<div class="section">

    <h3>📅 Event Information</h3>

    <div class="form-grid">

        <div>

            <label>Event Type <span style="color:red">*</span></label>

            <select
                id="typeId"
                name="typeId"
                required
                onchange="loadSamagri()">

                <option value="">-- Select Event Type --</option>

                <% for(EventType type : eventTypes){ %>

                <option
                    value="<%=type.getTypeId()%>"
                    <%=editMode && type.getTypeId()==event.getTypeId() ? "selected" : ""%>>

                    <%=type.getTypeName()%>

                </option>

                <% } %>

            </select>

        </div>

        <div>

            <label>Event Title <span style="color:red">*</span></label>

            <input
                type="text"
                name="eventTitle"
                value="<%=editMode ? event.getEventTitle() : ""%>"
                required>

        </div>

        <div>

            <label>Event Date</label>

            <input
                type="date"
                name="eventDate"
                value="<%=editMode ? event.getEventDate() : ""%>"
                required>

        </div>

        <div>

            <label>Event Time</label>

            <input
                type="time"
                name="eventTime"
                value="<%=editMode ? event.getEventTime().toString().substring(0,5) : ""%>"
                required>

        </div>

        <div class="full">

            <label>Location</label>

            <input
                type="text"
                name="location"
                value="<%=editMode ? event.getLocation() : ""%>">

        </div>

    </div>

</div>
<!-- ========================================= -->
<!-- Required Samagri -->
<!-- ========================================= -->

<div class="section">

    <h3>🪔 Required Samagri</h3>

    <p style="color:#666;margin-bottom:15px;">
        Select an Event Type to automatically load the required samagri.
    </p>

    <div id="samagriContainer" class="samagri-grid">

        <div class="empty-box">

            Please select an Event Type.

        </div>

    </div>

</div>

<!-- ========================================= -->
<!-- Extra Samagri -->
<!-- ========================================= -->

<div class="section">

    <h3>➕ Extra Samagri</h3>

    <div style="display:flex;gap:10px;align-items:center;">

        <input
            type="text"
            id="extraSamagriName"
            placeholder="Enter Extra Samagri"
            style="flex:1;">

        <button
            type="button"
            class="primary"
            onclick="addExtraSamagri()">

            Add

        </button>

    </div>

    <br>

    <div id="extraSamagriContainer">

        <div class="empty-box">

            No Extra Samagri Added

        </div>

    </div>

</div>

<!-- ========================================= -->
<!-- Payment Summary -->
<!-- ========================================= -->

<div class="section">

<h3>💰 Payment Summary</h3>

<div class="form-grid">

<div>

<label>Total Amount</label>

<input
type="number"
step="0.01"
name="totalAmount"
value="<%=editMode ? event.getTotalAmount() : ""%>"
required>
</div>

<div>

<label>Advance Paid</label>

<input
type="number"
step="0.01"
name="amountPaid"
value="<%=editMode ? event.getAmountPaid() : ""%>"
required>

</div>

<div>

<label>Pending Amount</label>

<input
type="number"
id="pendingAmount"
readonly>

</div>

<div>

<label>Payment Status</label>

<input
type="text"
id="paymentStatus"
readonly>

</div>

</div>

</div>


<!-- ========================================= -->
<!-- Notes -->
<!-- ========================================= -->

<div class="section">

<h3>📝 Notes</h3>

<textarea
name="notes"
rows="5"><%=editMode ? event.getNotes() : ""%></textarea>

</div>

<div class="actions">

<button
type="reset"
class="secondary">

Reset

</button>

<button
type="submit"
class="primary">

<%=editMode ? "Update Event" : "Save Event"%>

</button>

</div>

</form>

</div>

</div>
<script>

// ===========================================
// Initialize Page
// ===========================================

document.addEventListener("DOMContentLoaded", function () {

    toggleCustomerType();

    calculatePayment();

    const type = document.getElementById("typeId");

    if(type){

        type.addEventListener("change", loadSamagri);

        if(type.value !== ""){

            loadSamagri();

        }

    }

    const total = document.querySelector("input[name='totalAmount']");
    const paid = document.querySelector("input[name='amountPaid']");

    if(total) total.addEventListener("input", calculatePayment);
    if(paid) paid.addEventListener("input", calculatePayment);

});


// ===========================================
// Existing / New Customer
// ===========================================

function toggleCustomerType(){

    const selected =
        document.querySelector("input[name='customerType']:checked").value;

    const existing =
        document.getElementById("existingCustomerDiv");

    const newer =
        document.getElementById("newCustomerDiv");
    const customerSelect =
    	document.getElementById("customerId");

    	if(selected==="existing"){

    	    customerSelect.required=true;

    	}else{

    	    customerSelect.required=false;

    	}

    if(selected==="existing"){

        existing.style.display="block";
        newer.style.display="none";

    }
    else{

        existing.style.display="none";
        newer.style.display="block";

    }

}



// ===========================================
// Load Required Samagri
// ===========================================

function loadSamagri(){

    const typeId =
        document.getElementById("typeId").value;

    const container =
        document.getElementById("samagriContainer");

    if(typeId===""){

        container.innerHTML=`
        <div class="empty-box">

            Please select an Event Type.

        </div>`;

        return;

    }

    fetch("${pageContext.request.contextPath}/load-event-type-samagri?typeId="+typeId)

    .then(response=>response.json())

    .then(list=>{
    	console.log(list);
        let html="";

        if(list.length===0){

            html=`
            <div class="empty-box">

                No Samagri found.

            </div>`;

        }

        list.forEach(function(item){

            html +=
                '<div class="samagri-card">' +

                    '<input ' +
                        'type="checkbox" ' +
                        'name="samagriIds" ' +
                        'value="' + item.samagriId + '" ' +
                        'checked>' +

                    '<span class="samagri-name">' +
                        item.samagriName +
                    '</span>' +

                '</div>';

        });
        container.innerHTML=html;

    })

    .catch(error=>{

        container.innerHTML=`
        <div class="empty-box">

            Failed to load Samagri

        </div>`;

        console.error(error);

    });

}



// ===========================================
// Extra Samagri
// ===========================================

function addExtraSamagri(){

    const input =
        document.getElementById("extraSamagriName");

    const value =
        input.value.trim();

    if(value===""){

        alert("Enter Samagri Name");

        return;

    }

    const container =
        document.getElementById("extraSamagriContainer");

    if(container.querySelector(".empty-box")){

        container.innerHTML="";

    }

    container.innerHTML +=

        '<div class="extra-item">' +

            '<input ' +
                'type="hidden" ' +
                'name="extraSamagri" ' +
                'value="' + value + '">' +

            '<span>' +
                value +
            '</span>' +

            '<button ' +
                'type="button" ' +
                'class="remove-btn" ' +
                'onclick="this.parentElement.remove()">' +

                'Remove' +

            '</button>' +

        '</div>';

    input.value="";

}

// ===========================================
// Payment Calculation
// ===========================================

function calculatePayment(){

    const total =
        parseFloat(document.querySelector("input[name='totalAmount']").value)||0;

    const paid =
        parseFloat(document.querySelector("input[name='amountPaid']").value)||0;

    let pending =
        total-paid;

    if(pending<0){

        pending=0;

    }

    document.getElementById("pendingAmount").value=pending;

    let status="PENDING";

    if(paid===0){

        status="PENDING";

    }
    else if(paid<total){

        status="PARTIAL";

    }
    else{

        status="PAID";

    }

    document.getElementById("paymentStatus").value=status;

}

</script>

</body>
</html>
