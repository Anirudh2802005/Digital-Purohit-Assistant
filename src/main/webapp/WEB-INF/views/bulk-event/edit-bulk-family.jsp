<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>
<%!
/* HTML-escape (null -> "") */
private static String h(Object o) {
    if (o == null) return "";
    return String.valueOf(o).replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
}
%>
<%
BulkEventCustomer family = (BulkEventCustomer) request.getAttribute("family");
if (family == null) {
    response.sendRedirect(request.getContextPath() + "/bulk-events");
    return;
}

/* amounts are whole rupees - no paise */
long total = Math.round(family.getTotalAmount());
long paid = Math.round(family.getAmountPaid());
long due = total - paid;
if (due < 0) due = 0;

String statusLabel = paid == 0 ? "PENDING" : (paid < total ? "PARTIAL" : "PAID");
String statusClass = statusLabel.toLowerCase();
int paidPct = total > 0 ? (int) Math.max(0, Math.min(100, Math.round(paid * 100.0 / total))) : 0;
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Family | Digital Purohit Assistant</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Anton&family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap" rel="stylesheet">

<style>
  html, body{ margin:0; }
  body{ font-family:'Inter', system-ui, sans-serif; }
  i svg{ width:1em; height:1em; fill:none; stroke:currentColor; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
</style>
<!-- theme init: applies the saved dark/light choice before the page paints (no flash) -->
<script>
	(function () {
		var t = 'dark';
		try { t = localStorage.getItem('dpa-theme') || 'dark'; } catch (e) {}
		document.documentElement.setAttribute('data-theme', t === 'light' ? 'light' : 'dark');
		document.documentElement.classList.add('dpa-js');
	})();
</script>

<style id="ef-theme">
/* Theme variables — same values the sidebar partial uses (a harmless duplicate if it already defines them) */
:root{ --dpa-sidebar-w:260px; --dpa-twilight:#426188; --dpa-link:#2b7fff; }
:root, :root[data-theme="dark"]{
	--dpa-bg:#050608; --dpa-surface:#10141c; --dpa-surface-2:#161b26; --dpa-text:#f5f5f5;
	--dpa-muted:rgba(255,255,255,.58); --dpa-border:rgba(255,255,255,.09);
	--dpa-hover:rgba(255,255,255,.06); --dpa-tile:rgba(255,255,255,.07); color-scheme:dark;
}
:root[data-theme="light"]{
	--dpa-bg:#f1f4f9; --dpa-surface:#ffffff; --dpa-surface-2:#f5f5f5; --dpa-text:#1b1b1b;
	--dpa-muted:#6b7280; --dpa-border:rgba(0,0,0,.09);
	--dpa-hover:rgba(0,0,0,.045); --dpa-tile:rgba(0,0,0,.05); color-scheme:light;
}
@media (max-width:900px), (max-width:1100px) and (max-height:520px){ :root{ --dpa-sidebar-w:0px; } }
@media (min-width:1700px){ :root{ --dpa-sidebar-w:296px; } }
@media (min-width:2400px){ :root{ --dpa-sidebar-w:360px; } }
@media (min-width:3200px){ :root{ --dpa-sidebar-w:460px; } }
body{ background:var(--dpa-bg); color:var(--dpa-text); transition:background-color .35s ease, color .35s ease; }
</style>

<style id="ef-css">/* =====================================================================
   ADD / EDIT EVENT — same design system as the Events dashboard
   ===================================================================== */
.main-content{
	margin-left:var(--dpa-sidebar-w, 260px);
	padding:clamp(14px, 2.4vw, 34px);
	width:auto; max-width:none; min-width:0; box-sizing:border-box;
	background:transparent;
	transition:margin-left .3s ease;
}
.dpa-dash{
	--dk:1;
	--good:#34d399; --pend:#f0a43a; --bad2:#ff6b6b;
	max-width:96em; margin:0 auto;
	display:flex; flex-direction:column; gap:1.5em;
	font-family:'Inter', ui-sans-serif, system-ui, sans-serif;
	font-size:calc(14px * var(--dk)); font-weight:500; line-height:1.45;
	color:var(--dpa-text);
	-webkit-font-smoothing:antialiased;
}
:root[data-theme="light"] .dpa-dash{ --good:#168a4a; --pend:#b45f06; --bad2:#c93434; }
.dpa-dash, .dpa-dash *{ box-sizing:border-box; }
.dpa-dash h1, .dpa-dash h2, .dpa-dash h3, .dpa-dash p{ margin:0; }
@media (min-width:1700px){ .dpa-dash{ --dk:1.14; }
}
@media (min-width:2400px){ .dpa-dash{ --dk:1.4; }
}
@media (min-width:3200px){ .dpa-dash{ --dk:1.78; }
}
/* ---------- animations ---------- */
@keyframes dpaRise{ from{ opacity:0; translate:0 22px; } to{ opacity:1; translate:0 0; } }
@keyframes dpaFloat2{ 0%,100%{ transform:translate(0,0) scale(1); } 50%{ transform:translate(-26px,30px) scale(1.08); } }
@keyframes dpaDrift{ from{ transform:translateX(0); } to{ transform:translateX(-50%); } }
@keyframes dpaRing{ 0%{ box-shadow:0 0 0 0 rgba(255,255,255,.35); } 70%,100%{ box-shadow:0 0 0 14px rgba(255,255,255,0); } }
@keyframes dpaSpin{ to{ transform:rotate(360deg); } }
@keyframes dpaBlink{ 0%,100%{ opacity:1; } 50%{ opacity:.35; } }
@keyframes fmPop{ from{ opacity:0; transform:translateY(8px) scale(.97); } to{ opacity:1; transform:none; } }
.dpa-js .dpa-dash .reveal{ opacity:0; }
.dpa-js .dpa-dash .reveal.in{ animation:dpaRise .75s cubic-bezier(.2,.8,.2,1) var(--d, 0ms) both; }
/* ---------- hero ---------- */
.dpa-dash .page-header{
	position:relative; overflow:hidden; isolation:isolate;
	display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:1.3em;
	margin:0; padding:2.1em 2.3em;
	border-radius:1.3em; border:1px solid rgba(255,255,255,.08); box-shadow:none;
	background:#05070b; color:#fff;
	animation:dpaRise .9s cubic-bezier(.2,.8,.2,1) both;
}
.dpa-dash .page-header::before, .dpa-dash .page-header::after{
	content:""; position:absolute; z-index:-1; border-radius:50%; filter:blur(46px); pointer-events:none;
}
.dpa-dash .page-header::before{
	width:26em; height:26em; top:-13em; left:-5em;
	background:radial-gradient(circle, rgba(66,97,136,.9), rgba(66,97,136,0) 70%);
	animation:dpaFloat2 14s ease-in-out infinite;
}
.dpa-dash .page-header::after{
	width:30em; height:30em; bottom:-17em; right:-4em;
	background:radial-gradient(circle, rgba(43,127,255,.38), rgba(43,127,255,0) 70%);
	animation:dpaFloat2 17s ease-in-out infinite reverse;
}
.dpa-dash .hero-watermark{
	position:absolute; z-index:-1; left:0; top:50%; margin-top:-.46em; white-space:nowrap; pointer-events:none; user-select:none;
	font-family:'Anton', sans-serif; text-transform:uppercase; font-size:9em; line-height:1;
	color:transparent; -webkit-text-stroke:1px rgba(255,255,255,.07);
	animation:dpaDrift 46s linear infinite;
}
.dpa-dash .hero-left{ display:flex; align-items:center; gap:1.3em; min-width:0; }
.dpa-dash .hero-icon{
	flex-shrink:0; width:2.4em; height:2.4em; font-size:1.5em; border-radius:.7em;
	display:flex; align-items:center; justify-content:center;
	border:1px solid rgba(255,255,255,.55); color:#fff; background:rgba(255,255,255,.04);
	animation:dpaRing 3.2s ease-out infinite;
}
.dpa-dash .page-header h1{
	font-family:'Anton', ui-sans-serif, sans-serif; font-weight:400; text-transform:uppercase;
	font-size:clamp(1.8em, 3.4vw, 3.2em); line-height:1; letter-spacing:.01em; color:#fff; overflow-wrap:anywhere;
}
.dpa-dash .page-header p{ margin-top:.55em; color:rgba(255,255,255,.72); font-weight:400; font-size:1.05em; }
/* ---------- layout + section cards ---------- */
.dpa-dash .fm-grid{ display:grid; grid-template-columns:minmax(0, 1.65fr) minmax(0, 1fr); gap:1.1em; align-items:start; }
.dpa-dash .fm-col{ display:flex; flex-direction:column; gap:1.1em; min-width:0; }
.dpa-dash .fm-side{ position:sticky; top:1.2em; }
.dpa-dash .section-card{
	margin:0; padding:0; overflow:hidden; min-width:0;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .section-top{
	display:flex; align-items:center; justify-content:space-between; gap:1em; flex-wrap:wrap;
	padding:1.15em 1.5em; border-bottom:1px solid var(--dpa-border);
}
.dpa-dash .st-left{ display:flex; align-items:center; gap:.9em; min-width:0; }
.dpa-dash .st-left > i{
	flex-shrink:0; width:2.5em; height:2.5em; border-radius:.75em;
	display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .section-card:hover .st-left > i{ background:var(--dpa-twilight); color:#fff; transform:rotate(-8deg) scale(1.08); }
.dpa-dash .section-top h2{ font-size:1.12em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .section-top p{ margin-top:.2em; font-size:.85em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .tag{
	padding:.3em .85em; border-radius:999px; font-size:.78em; font-weight:700; letter-spacing:.04em;
	border:1px solid var(--dpa-border); color:var(--dpa-muted); white-space:nowrap;
}
.dpa-dash .fm-body{ padding:1.4em 1.5em 1.5em; }
.dpa-dash .req{ color:var(--bad2); }
/* ---------- fields ---------- */
.dpa-dash .form-grid{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:1.1em; }
.dpa-dash .form-grid .full{ grid-column:1 / -1; }
.dpa-dash .field label{ display:block; margin-bottom:.5em; font-size:.85em; font-weight:600; color:var(--dpa-muted); }
.dpa-dash .field-box{
	position:relative; display:flex; align-items:center; gap:.7em; padding:0 1em;
	border-radius:.75em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:border-color .2s, box-shadow .2s;
}
.dpa-dash .field-box.area{ align-items:flex-start; padding-top:.2em; }
.dpa-dash .field-box:focus-within{ border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.2); }
.dpa-dash .field-box:has(:user-invalid){ border-color:var(--bad2); }
.dpa-dash .field-box > i, .dpa-dash .field-box .cur{ color:var(--dpa-muted); font-weight:700; flex-shrink:0; transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .field-box.area > i{ margin-top:.95em; }
.dpa-dash .field-box:focus-within > i, .dpa-dash .field-box:focus-within .cur{ color:var(--dpa-link); transform:scale(1.12); }
.dpa-dash .field-box input, .dpa-dash .field-box select, .dpa-dash .field-box textarea{
	flex:1; min-width:0; width:100%; margin:0; padding:.9em 0; border:0; outline:0; box-shadow:none; background:transparent;
	font-family:inherit; font-size:1em; font-weight:500; color:var(--dpa-text);
}
.dpa-dash .field-box textarea{ min-height:7em; resize:vertical; line-height:1.5; }
.dpa-dash .field-box input::placeholder, .dpa-dash .field-box textarea::placeholder{ color:var(--dpa-muted); opacity:.8; font-weight:400; }
.dpa-dash .field-box input[readonly]{ cursor:default; font-weight:700; }
.dpa-dash .field-box select{ appearance:none; -webkit-appearance:none; cursor:pointer; padding-right:1.6em; }
.dpa-dash .field-box select option{ background:var(--dpa-surface); color:var(--dpa-text); }
.dpa-dash .field-box:has(select)::after{
	content:""; position:absolute; right:1em; top:50%; width:.5em; height:.5em; margin-top:-.4em;
	border-right:2px solid var(--dpa-muted); border-bottom:2px solid var(--dpa-muted); transform:rotate(45deg); pointer-events:none;
}
.dpa-dash .field-box input[type="date"], .dpa-dash .field-box input[type="time"]{ cursor:pointer; }
/* no spinner arrows: the mouse wheel / arrows can never change an amount */
.dpa-dash input[type="number"]{ -moz-appearance:textfield; appearance:textfield; }
.dpa-dash input[type="number"]::-webkit-outer-spin-button, .dpa-dash input[type="number"]::-webkit-inner-spin-button{ -webkit-appearance:none; margin:0; }
.dpa-dash .empty-box{
	display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:.4em;
	margin:0; padding:1.8em 1em; border-radius:.9em; border:1.5px dashed var(--dpa-border); color:var(--dpa-muted);
}
.dpa-dash .empty-box i{ font-size:1.8em; opacity:.6; }
.dpa-dash .empty-box p{ font-size:.95em; font-weight:500; }
/* ---------- payment summary ---------- */
.dpa-dash .pay-stack{ display:flex; flex-direction:column; gap:1.1em; }
.dpa-dash .pay-bar{ height:.5em; border-radius:999px; background:var(--dpa-tile); overflow:hidden; }
.dpa-dash .pay-bar i{ display:block; height:100%; width:var(--w, 0%); border-radius:inherit; background:var(--good); transition:width .5s cubic-bezier(.2,.8,.2,1); }
.dpa-dash .status{
	display:inline-flex; align-items:center; gap:.5em; padding:.3em .9em; border-radius:999px;
	font-size:.78em; font-weight:700; letter-spacing:.06em; text-transform:uppercase; white-space:nowrap;
}
.dpa-dash .status::before{ content:""; width:.5em; height:.5em; border-radius:50%; background:currentColor; }
.dpa-dash .status.pending{ background:rgba(255,107,107,.15); color:var(--bad2); }
.dpa-dash .status.pending::before{ animation:dpaBlink 1.6s ease-in-out infinite; }
.dpa-dash .status.partial{ background:rgba(240,164,58,.16); color:var(--pend); }
.dpa-dash .status.paid{ background:rgba(52,211,153,.15); color:var(--good); }
/* ---------- buttons ---------- */
.dpa-dash .actions{ display:flex; gap:.8em; padding:0 1.5em 1.5em; }
.dpa-dash .btn{
	display:inline-flex; align-items:center; justify-content:center; gap:.6em; margin:0; padding:.85em 1.4em;
	border-radius:.8em; border:1px solid var(--dpa-border); background:transparent; box-shadow:none; cursor:pointer;
	font-family:inherit; font-size:.95em; font-weight:700; line-height:1.2; color:var(--dpa-text); white-space:nowrap;
	transition:background-color .2s, color .2s, transform .12s, box-shadow .25s, border-color .2s;
}
.dpa-dash .btn.primary{ flex:1; background:#1f9d55; border-color:#1f9d55; color:#fff; }
.dpa-dash .btn:active{ transform:scale(.96); }
.dpa-dash .btn.loading{ pointer-events:none; opacity:.85; }
.dpa-dash .btn.loading i{ animation:dpaSpin .8s linear infinite; }
.dpa-dash .btn:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }
@media (hover:hover) and (pointer:fine){	.dpa-dash .field-box:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .btn.primary:hover{ background:#23b062; border-color:#23b062; box-shadow:0 8px 20px rgba(31,157,85,.35); }
	.dpa-dash .btn:not(.primary):not(.add):hover{ background:var(--dpa-hover); border-color:var(--dpa-twilight); }
}
/* ---------- responsive ---------- */
@media (max-width:1100px){ .dpa-dash .fm-grid{ grid-template-columns:minmax(0, 1fr); } .dpa-dash .fm-side{ position:static; } }
@media (max-width:900px){ .main-content{ margin-left:0; width:100%; padding:clamp(14px, 2.4vw, 24px); }
}
@media (max-width:700px){	.main-content{ padding:14px; }
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .section-top{ padding:1em 1.1em; }
	.dpa-dash .fm-body{ padding:1.1em; }
	.dpa-dash .form-grid{ grid-template-columns:minmax(0, 1fr); }
	.dpa-dash .actions{ padding:0 1.1em 1.1em; }
}
@media print{	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1 !important; animation:none !important; }
	.dpa-dash .hero-watermark, .dpa-dash .actions{ display:none !important; }
}
@media (prefers-reduced-motion: reduce){	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
}

/* ---------- edit family ---------- */
@keyframes efPop{ from{ opacity:0; transform:translateY(20px) scale(.94); } to{ opacity:1; transform:none; } }
@keyframes efFade{ from{ opacity:0; } to{ opacity:1; } }
.dpa-dash .fm-grid{ align-items:stretch; }
.dpa-dash .fm-side{ position:static; }
.dpa-dash .fm-col > .section-card:last-child{ flex:1; display:flex; flex-direction:column; }
.dpa-dash .fm-col > .section-card:last-child .fm-body{ flex:1; }
.dpa-dash .fm-col > .section-card:last-child .actions{ margin-top:auto; }
.dpa-dash a.btn{ text-decoration:none; }
.dpa-dash .out-box{
	display:flex; align-items:center; justify-content:space-between; gap:1em; padding:1em 1.1em; border-radius:.9em;
	border:1px solid var(--dpa-border); background:var(--dpa-surface-2);
}
.dpa-dash .out-box label{ margin:0; font-size:.8em; font-weight:600; color:var(--dpa-muted); }
.dpa-dash .out-box b{ display:block; margin-top:.2em; font-size:1.6em; font-weight:700; font-variant-numeric:tabular-nums; color:var(--bad2); transition:color .3s; }
.dpa-dash .out-box.clear b{ color:var(--good); }
.dpa-dash .field-box textarea{ min-height:9em; }

/* update confirm (outside .dpa-dash) */
.ef-modal{ position:fixed; inset:0; z-index:2200; display:none; align-items:center; justify-content:center; padding:20px; background:rgba(0,0,0,.6); -webkit-backdrop-filter:blur(6px); backdrop-filter:blur(6px); font-family:'Inter', system-ui, sans-serif; }
.ef-modal.show{ display:flex; animation:efFade .25s ease both; }
.ef-card{ width:100%; max-width:25em; padding:1.8em 1.6em 1.6em; text-align:center; border-radius:18px; border:1px solid var(--dpa-border); background:var(--dpa-surface); color:var(--dpa-text); box-shadow:0 30px 80px rgba(0,0,0,.5); animation:efPop .4s cubic-bezier(.2,.8,.2,1) both; }
.ef-ico{ width:64px; height:64px; margin:0 auto 14px; border-radius:50%; display:grid; place-items:center; font-size:28px; background:rgba(52,211,153,.15); color:#34d399; }
.ef-card h3{ margin:0; font-size:19px; font-weight:700; }
.ef-card p{ margin:8px 0 20px; font-size:14px; font-weight:400; color:var(--dpa-muted); overflow-wrap:anywhere; }
.ef-row{ display:flex; gap:10px; }
.ef-row button{ flex:1; padding:12px 16px; border-radius:11px; border:1px solid var(--dpa-border); background:transparent; color:var(--dpa-text); font:700 14px 'Inter', sans-serif; cursor:pointer; transition:background-color .2s, transform .12s; }
.ef-row button:active{ transform:scale(.96); }
.ef-row .ok{ background:#1f9d55; border-color:#1f9d55; color:#fff; }
.ef-row button:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }
html.dpa-lock, html.dpa-lock body{ overflow:hidden; }
@media (hover:hover) and (pointer:fine){
	.ef-row button:not(.ok):hover{ background:var(--dpa-hover); }
	.ef-row .ok:hover{ background:#23b062; }
}
@media (prefers-reduced-motion: reduce){ .ef-modal, .ef-card{ animation:none !important; } }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

  <div class="edit-family-page dpa-dash">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
        <div class="hero-left">
            <div class="hero-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 20h9"/><path d="M16.376 3.622a1 1 0 0 1 3.002 3.002L7.368 18.635a2 2 0 0 1-.855.506l-2.872.838a.5.5 0 0 1-.62-.62l.838-2.872a2 2 0 0 1 .506-.854z"/></svg></i></div>
            <div>
                <h1>Edit Family</h1>
                <p>Update this family&rsquo;s details and payment.</p>
            </div>
        </div>
    </div>

    <form id="familyForm" class="fm-grid" action="${pageContext.request.contextPath}/edit-bulk-family" method="post">

        <input type="hidden" name="id" value="<%= family.getId() %>">
        <input type="hidden" name="bulkEventId" value="<%= family.getBulkEventId() %>">
        <input type="hidden" name="customerId" value="<%= family.getCustomerId() %>">

        <!-- ================= LEFT COLUMN ================= -->
        <div class="fm-col">

            <section class="section-card reveal" aria-labelledby="efDetails">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i>
                        <div><h2 id="efDetails">Family Details</h2><p>Who is this family?</p></div>
                    </div>
                </div>
                <div class="fm-body">
                    <div class="form-grid">
                        <div class="field">
                            <label for="customerName">Customer Name</label>
                            <div class="field-box"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i>
                                <input type="text" id="customerName" name="customerName" placeholder="Full name" value="<%= h(family.getCustomerName()) %>" required></div>
                        </div>
                        <div class="field">
                            <label for="phone">Phone</label>
                            <div class="field-box"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg></i>
                                <input type="text" id="phone" name="phone" placeholder="Phone number" value="<%= h(family.getPhone()) %>" required></div>
                        </div>
                        <div class="field">
                            <label for="address">Address</label>
                            <div class="field-box"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg></i>
                                <input type="text" id="address" name="address" placeholder="Address" value="<%= h(family.getAddress()) %>"></div>
                        </div>
                        <div class="field">
                            <label for="gothram">Gothram</label>
                            <div class="field-box"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20"/></svg></i>
                                <input type="text" id="gothram" name="gothram" placeholder="Gothram" value="<%= h(family.getGothram()) %>"></div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="section-card reveal" aria-labelledby="efNotes">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/></svg></i>
                        <div><h2 id="efNotes">Notes</h2><p>Optional</p></div>
                    </div>
                </div>
                <div class="fm-body">
                    <div class="field-box area">
                        <textarea id="notes" name="notes" placeholder="Anything worth remembering about this family"><%= h(family.getNotes()) %></textarea>
                    </div>
                </div>
            </section>

        </div>

        <!-- ================= RIGHT COLUMN ================= -->
        <div class="fm-col fm-side">

            <section class="section-card reveal" aria-labelledby="efPay">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/></svg></i>
                        <div><h2 id="efPay">Payment</h2><p>Whole rupees only</p></div>
                    </div>
                    <span class="status <%= statusClass %>" id="payPill"><%= statusLabel %></span>
                </div>
                <div class="fm-body pay-stack">

                    <div class="field">
                        <label for="totalAmount">Total Amount</label>
                        <div class="field-box"><span class="cur">&#8377;</span>
                            <input type="number" id="totalAmount" name="totalAmount" step="1" min="0" inputmode="numeric" placeholder="0" value="<%= total %>" required></div>
                    </div>

                    <div class="field">
                        <label for="amountPaid">Amount Paid</label>
                        <div class="field-box"><span class="cur">&#8377;</span>
                            <input type="number" id="amountPaid" name="amountPaid" step="1" min="0" inputmode="numeric" placeholder="0" value="<%= paid %>" required></div>
                    </div>

                    <div class="pay-bar" aria-hidden="true"><i id="payBar" style="--w:<%= paidPct %>%"></i></div>

                    <div class="out-box<%= due == 0 ? " clear" : "" %>" id="outBox">
                        <div><label>Outstanding Amount</label><b id="outAmount">&#8377; <%= String.format("%,d", due) %></b></div>
                        <span class="status <%= statusClass %>" id="payPill2"><%= statusLabel %></span>
                    </div>

                </div>

                <div class="actions">
                    <a class="btn" href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%= family.getBulkEventId() %>">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i> Cancel
                    </a>
                    <button type="submit" class="btn primary" id="saveBtn">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z"/><path d="M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7"/><path d="M7 3v4a1 1 0 0 0 1 1h7"/></svg></i> <span>Update Family</span>
                    </button>
                </div>
            </section>

        </div>

    </form>

  </div>

</div>

<!-- ================= CONFIRM UPDATE ================= -->
<div class="ef-modal" id="efModal" role="dialog" aria-modal="true" aria-labelledby="efModalTitle">
    <div class="ef-card">
        <div class="ef-ico" aria-hidden="true"><i><svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i></div>
        <h3 id="efModalTitle">Update this family details?</h3>
        <p id="efModalText"></p>
        <div class="ef-row">
            <button type="button" id="efCancel">Cancel</button>
            <button type="button" class="ok" id="efConfirm">Update</button>
        </div>
    </div>
</div>

<script id="ef-js">
(function () {
	var $ = function (id) { return document.getElementById(id); };
	var nf = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 });

	/* ---------- scroll reveal ---------- */
	var page = document.querySelector('.dpa-dash');
	if (page) {
		page.querySelectorAll('.fm-col').forEach(function (col) {
			Array.prototype.forEach.call(col.children, function (el, i) { el.style.setProperty('--d', (i * 90) + 'ms'); });
		});
		var targets = page.querySelectorAll('.reveal');
		function reveal(el) { el.classList.add('in'); }
		if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }
		else {
			var io = new IntersectionObserver(function (entries) {
				entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
			}, { threshold: 0.08, rootMargin: '0px 0px -30px 0px' });
			targets.forEach(function (t) { io.observe(t); });
		}
	}

	/* ---------- payment: whole rupees only, live outstanding + status ---------- */
	var total = $('totalAmount'), paid = $('amountPaid');
	function whole(el) { var v = parseFloat(el.value); return isNaN(v) ? 0 : Math.max(0, Math.round(v)); }
	function calc() {
		var t = whole(total), p = whole(paid), due = Math.max(0, t - p);
		$('outAmount').textContent = '\u20B9 ' + nf.format(due);
		$('outBox').classList.toggle('clear', due === 0);
		var s = p === 0 ? 'PENDING' : (p < t ? 'PARTIAL' : 'PAID');
		['payPill', 'payPill2'].forEach(function (id) { var e = $(id); e.textContent = s; e.className = 'status ' + s.toLowerCase(); });
		$('payBar').style.setProperty('--w', (t > 0 ? Math.min(100, p * 100 / t) : 0) + '%');
	}
	[total, paid].forEach(function (el) {
		el.addEventListener('input', calc);
		el.addEventListener('keydown', function (e) {   /* no decimal point, exponent or minus: no paise */
			if (e.key === '.' || e.key === ',' || e.key === 'e' || e.key === 'E' || e.key === '+' || e.key === '-') e.preventDefault();
		});
		el.addEventListener('change', function () { if (el.value !== '') el.value = whole(el); calc(); });
	});
	/* the mouse wheel can never change a number field */
	document.addEventListener('wheel', function () { var a = document.activeElement; if (a && a.type === 'number') a.blur(); }, { passive: true });

	/* ---------- confirm, then save ---------- */
	var form = $('familyForm'), btn = $('saveBtn'), modal = $('efModal'), sending = false;
	function closeModal() { modal.classList.remove('show'); document.documentElement.classList.remove('dpa-lock'); }
	form.addEventListener('submit', function (e) {
		if (sending) { e.preventDefault(); return; }
		if (modal.dataset.ok === '1') return;   /* already confirmed */
		e.preventDefault();
		if (!form.checkValidity()) { form.reportValidity(); return; }
		$('efModalText').textContent = ($('customerName').value.trim() || 'This family') + ' will be updated.';
		modal.classList.add('show'); document.documentElement.classList.add('dpa-lock');
		$('efCancel').focus();
	});
	$('efCancel').addEventListener('click', closeModal);
	modal.addEventListener('click', function (e) { if (e.target === modal) closeModal(); });
	document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeModal(); });
	$('efConfirm').addEventListener('click', function () {
		modal.dataset.ok = '1'; sending = true; closeModal();
		btn.classList.add('loading');
		btn.innerHTML = '<i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg></i> <span>Saving\u2026</span>';
		if (window.efOnSubmit) { window.efOnSubmit(); return; }
		form.submit();
	});
	window.addEventListener('pageshow', function (e) { if (e.persisted) location.reload(); });
})();
</script>

</body>
</html>
