<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>
<%!
/* HTML-escape, "-" when empty */
private static String d(Object o) {
    if (o == null) return "-";
    String s = String.valueOf(o).replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    return s.trim().isEmpty() ? "-" : s;
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
long pending = Math.max(0, total - paid);
int paidPct = total > 0 ? (int) Math.max(0, Math.min(100, Math.round(paid * 100.0 / total))) : 0;

String status = family.getPaymentStatus();
String statusLabel = status == null ? "PENDING" : status;
String statusClass = "PAID".equalsIgnoreCase(status) ? "paid" : ("PARTIAL".equalsIgnoreCase(status) ? "partial" : "pending");

boolean hasNotes = family.getNotes() != null && !family.getNotes().trim().isEmpty();
String notesText = hasNotes ? d(family.getNotes()) : "-";
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Family Details | Digital Purohit Assistant</title>

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

<style id="fd-theme">
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

<style id="fd-css">/* =====================================================================
   EVENT DETAILS — same design system as the dashboard
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
@keyframes dpaBlink{ 0%,100%{ opacity:1; } 50%{ opacity:.35; } }
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
.dpa-dash .page-header p{ display:flex; align-items:center; flex-wrap:wrap; gap:.6em; margin-top:.55em; color:rgba(255,255,255,.72); font-weight:400; font-size:1.05em; }
.dpa-dash .hero-chip{
	display:flex; align-items:center; gap:.9em; padding:.85em 1.1em; border-radius:1em;
	border:1px solid rgba(255,255,255,.14); background:rgba(255,255,255,.05); color:#fff;
}
.dpa-dash .hero-chip i{ width:2.4em; height:2.4em; border-radius:.7em; display:flex; align-items:center; justify-content:center; background:rgba(255,255,255,.1); }
.dpa-dash .hero-chip b{ display:block; font-size:1.05em; font-weight:700; }
.dpa-dash .hero-chip small{ display:block; font-size:.85em; color:rgba(255,255,255,.7); font-weight:500; }
/* ---------- stat cards ---------- */
.dpa-dash .stat-row{ display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:1.1em; margin:0; }
.dpa-dash .stat-card{
	--acc:#2b7fff; --acc-soft:rgba(43,127,255,.16);
	position:relative; overflow:hidden; display:flex; align-items:flex-start; justify-content:space-between; gap:1em;
	margin:0; padding:1.4em 1.5em 1.5em; container-type:inline-size;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .c-orange{ --acc:#f0a43a; --acc-soft:rgba(240,164,58,.17); }
.dpa-dash .c-green{ --acc:#1fbf6a; --acc-soft:rgba(31,191,106,.16); }
.dpa-dash .c-red{ --acc:#ff6b6b; --acc-soft:rgba(255,107,107,.16); }
.dpa-dash .c-purple{ --acc:#9b7bff; --acc-soft:rgba(155,123,255,.17); }
.dpa-dash .stat-card::before{
	content:""; position:absolute; left:0; top:0; height:3px; width:100%; background:var(--acc);
	transform:scaleX(0); transform-origin:left; transition:transform .9s cubic-bezier(.2,.8,.2,1) .25s;
}
.dpa-dash .stat-card.in::before, html:not(.dpa-js) .dpa-dash .stat-card::before{ transform:scaleX(1); }
.dpa-dash .stat-body{ min-width:0; }
.dpa-dash .stat-label{ font-size:.72em; font-weight:700; letter-spacing:.12em; text-transform:uppercase; color:var(--dpa-muted); }
.dpa-dash .stat-value{
	margin-top:.65em; font-size:clamp(1.3em, 10cqw, 2em); font-weight:700; line-height:1.1; letter-spacing:-.02em;
	font-variant-numeric:tabular-nums; overflow-wrap:anywhere;
}
.dpa-dash .stat-sub{ margin-top:.5em; font-size:.86em; font-weight:500; color:var(--dpa-muted); }
.dpa-dash .stat-icon{
	flex-shrink:0; width:3.2em; height:3.2em; border-radius:1em; font-size:1.05em;
	display:flex; align-items:center; justify-content:center; background:var(--acc-soft); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
/* status pill */
.dpa-dash .status{
	display:inline-flex; align-items:center; gap:.5em; padding:.3em .9em; border-radius:999px;
	font-size:.78em; font-weight:700; letter-spacing:.06em; text-transform:uppercase; white-space:nowrap;
}
.dpa-dash .status::before{ content:""; width:.5em; height:.5em; border-radius:50%; background:currentColor; }
.dpa-dash .status.pending{ background:rgba(255,107,107,.15); color:var(--bad2); }
.dpa-dash .status.pending::before{ animation:dpaBlink 1.6s ease-in-out infinite; }
.dpa-dash .status.partial{ background:rgba(240,164,58,.16); color:var(--pend); }
.dpa-dash .status.paid{ background:rgba(52,211,153,.15); color:var(--good); }
/* ---------- layout + section cards ---------- */
.dpa-dash .ed-grid{ display:grid; grid-template-columns:minmax(0, 1fr) minmax(0, 1.1fr); gap:1.1em; align-items:start; }
.dpa-dash .ed-col{ display:flex; flex-direction:column; gap:1.1em; min-width:0; }
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
}
.dpa-dash .section-top h2{ font-size:1.12em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .section-top p{ margin-top:.2em; font-size:.85em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .tag{
	padding:.3em .85em; border-radius:999px; font-size:.78em; font-weight:700; letter-spacing:.04em;
	border:1px solid var(--dpa-border); color:var(--dpa-muted); white-space:nowrap;
}
/* detail fields */
.dpa-dash .info-grid{ display:grid; grid-template-columns:repeat(auto-fit, minmax(12em, 1fr)); gap:.8em; padding:1.3em 1.5em 1.5em; }
.dpa-dash .info-item{ padding:.85em 1.05em; border-radius:.85em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2); min-width:0; }
.dpa-dash .info-item label{ display:block; margin-bottom:.35em; font-size:.78em; font-weight:600; color:var(--dpa-muted); }
.dpa-dash .info-item div{ font-weight:600; overflow-wrap:anywhere; }
.dpa-dash .info-item.wide{ grid-column:1 / -1; }
/* ---------- hover (mouse only) ---------- */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .stat-card:hover{ transform:translateY(-4px); border-color:var(--acc); }
	.dpa-dash .stat-card:hover .stat-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .sam-item:hover{ border-color:var(--dpa-twilight); transform:translateX(3px); }
	.dpa-dash .receive:hover{ background:#23b062; box-shadow:0 8px 20px rgba(31,157,85,.35); }
}
html.dpa-lock, html.dpa-lock body{ overflow:hidden; }
/* ---------- responsive ---------- */
@media (max-width:1100px){ .dpa-dash .stat-row{ grid-template-columns:repeat(2, minmax(0, 1fr)); } }
@media (max-width:1000px){ .dpa-dash .ed-grid{ grid-template-columns:minmax(0, 1fr); }
}
@media (max-width:900px){ .main-content{ margin-left:0; width:100%; padding:clamp(14px, 2.4vw, 24px); }
}
@media (max-width:700px){	.main-content{ padding:14px; }
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .section-top{ padding:1em 1.1em; }
}
@media (max-width:480px){ .dpa-dash .stat-row{ grid-template-columns:minmax(0, 1fr); gap:.8em; }
}
@media print{	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1 !important; animation:none !important; }
}
@media (prefers-reduced-motion: reduce){	.dpa-js .dpa-dash .reveal{ opacity:1; }
	.dpa-dash .stat-card::before{ transform:scaleX(1); }
}

/* ---------- family details ---------- */
@property --p{ syntax:'<number>'; inherits:false; initial-value:0; }
@keyframes fdFill{ from{ --p:0; } to{ --p:var(--tp); } }
.dpa-dash .hero-right{ display:flex; align-items:center; gap:.9em; flex-wrap:wrap; }
.dpa-dash .hero-btn{
	display:inline-flex; align-items:center; gap:.6em; padding:.75em 1.15em; border-radius:.85em;
	border:1px solid rgba(255,255,255,.3); background:rgba(255,255,255,.06); color:#fff; font-weight:600; font-size:.95em; text-decoration:none;
	transition:transform .25s cubic-bezier(.2,.8,.2,1), background-color .25s;
}
.dpa-dash .hero-btn i{ display:inline-flex; font-size:1.1em; }
.dpa-dash .c-blue{ --acc:#2b7fff; --acc-soft:rgba(43,127,255,.16); }
.dpa-dash .fm-body{ padding:1.3em 1.5em 1.5em; }
.dpa-dash .notes-text{ line-height:1.7; font-weight:500; white-space:pre-wrap; overflow-wrap:anywhere; }
.dpa-dash .notes-text.none{ color:var(--dpa-muted); font-style:italic; font-weight:400; }

.dpa-dash .prog{ display:flex; flex-direction:column; align-items:center; gap:.6em; padding:1.5em 1.5em .2em; text-align:center; }
.dpa-dash .ring{
	--tp:0; --p:var(--tp);
	position:relative; width:9.5em; height:9.5em; border-radius:50%; display:grid; place-items:center;
	background:conic-gradient(var(--good) calc(var(--p) * 1%), var(--dpa-tile) 0);
	animation:fdFill 1.4s cubic-bezier(.2,.8,.2,1) .35s both;
}
.dpa-dash .ring::before{ content:""; position:absolute; inset:.7em; border-radius:50%; background:var(--dpa-surface); }
.dpa-dash .ring div{ position:relative; font-size:1.9em; font-weight:700; letter-spacing:-.02em; line-height:1; }
.dpa-dash .ring small{ display:block; margin-top:.3em; font-size:.38em; font-weight:600; letter-spacing:.04em; color:var(--dpa-muted); }
.dpa-dash .prog-note{ font-size:.88em; color:var(--dpa-muted); }
.dpa-dash .prog-note b{ color:var(--bad2); font-variant-numeric:tabular-nums; }
.dpa-dash .info-item .pos{ color:var(--good); } .dpa-dash .info-item .neg{ color:var(--bad2); }

/* equal-height columns: both sides end on the same line */
.dpa-dash .ed-grid{ align-items:stretch; }
.dpa-dash .ed-col > .section-card:last-child{ flex:1; }

@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ transform:translateX(-4px); background:rgba(255,255,255,.14); }
}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

  <div class="family-details-page dpa-dash">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
        <div class="hero-left">
            <div class="hero-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i></div>
            <div>
                <h1>Family Details</h1>
                <p><%= d(family.getCustomerName()) %></p>
            </div>
        </div>
        <div class="hero-right">
            <div class="hero-chip">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg></i>
                <div><b><%= d(family.getPhone()) %></b><small>Phone</small></div>
            </div>
            <a href="javascript:history.back()" class="hero-btn">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="m12 19-7-7 7-7"/><path d="M19 12H5"/></svg></i> Back
            </a>
        </div>
    </div>

    <!-- ================= PAYMENT SUMMARY ================= -->
    <div class="stat-row">
        <div class="stat-card c-orange reveal">
            <div class="stat-body">
                <div class="stat-label">Total Amount</div>
                <div class="stat-value" data-money="<%= total %>">&#8377; <%= String.format("%,d", total) %></div>
                <div class="stat-sub">Agreed amount</div>
            </div>
            <div class="stat-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/></svg></i></div>
        </div>
        <div class="stat-card c-green reveal">
            <div class="stat-body">
                <div class="stat-label">Amount Paid</div>
                <div class="stat-value" data-money="<%= paid %>">&#8377; <%= String.format("%,d", paid) %></div>
                <div class="stat-sub"><%= paidPct %>% collected</div>
            </div>
            <div class="stat-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i></div>
        </div>
        <div class="stat-card c-red reveal">
            <div class="stat-body">
                <div class="stat-label">Pending Amount</div>
                <div class="stat-value" data-money="<%= pending %>">&#8377; <%= String.format("%,d", pending) %></div>
                <div class="stat-sub">Still to receive</div>
            </div>
            <div class="stat-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M5 22h14"/><path d="M5 2h14"/><path d="M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22"/><path d="M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2"/></svg></i></div>
        </div>
        <div class="stat-card c-purple reveal">
            <div class="stat-body">
                <div class="stat-label">Payment Status</div>
                <div class="stat-value"><span class="status <%= statusClass %>"><%= d(statusLabel) %></span></div>
                <div class="stat-sub">Current status</div>
            </div>
            <div class="stat-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg></i></div>
        </div>
    </div>

    <div class="ed-grid">

        <div class="ed-col">

            <!-- ================= CUSTOMER INFORMATION ================= -->
            <section class="section-card reveal" aria-labelledby="fdInfo">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i>
                        <div><h2 id="fdInfo">Customer Information</h2><p>Who this family is</p></div>
                    </div>
                </div>
                <div class="info-grid">
                    <div class="info-item"><label>Name</label><div><%= d(family.getCustomerName()) %></div></div>
                    <div class="info-item"><label>Phone</label><div><%= d(family.getPhone()) %></div></div>
                    <div class="info-item wide"><label>Address</label><div><%= d(family.getAddress()) %></div></div>
                    <div class="info-item"><label>Gothram</label><div><%= d(family.getGothram()) %></div></div>
                </div>
            </section>

            <!-- ================= NOTES ================= -->
            <section class="section-card reveal" aria-labelledby="fdNotes">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/></svg></i>
                        <div><h2 id="fdNotes">Notes</h2><p>Anything worth remembering</p></div>
                    </div>
                </div>
                <div class="fm-body">
                    <p class="notes-text<%= hasNotes ? "" : " none" %>"><%= notesText %></p>
                </div>
            </section>

        </div>

        <div class="ed-col">

            <!-- ================= PAYMENT DETAILS ================= -->
            <section class="section-card reveal" aria-labelledby="fdPay">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/></svg></i>
                        <div><h2 id="fdPay">Payment Details</h2><p>Amounts in whole rupees</p></div>
                    </div>
                    <span class="status <%= statusClass %>"><%= d(statusLabel) %></span>
                </div>
                <div class="prog">
                    <div class="ring" style="--tp:<%= paidPct %>"><div><span data-count="<%= paidPct %>"><%= paidPct %></span>%<small>PAID</small></div></div>
                    <p class="prog-note">Pending <b>&#8377; <%= String.format("%,d", pending) %></b></p>
                </div>
                <div class="info-grid">
                    <div class="info-item"><label>Total Amount</label><div>&#8377; <%= String.format("%,d", total) %></div></div>
                    <div class="info-item"><label>Amount Paid</label><div class="pos">&#8377; <%= String.format("%,d", paid) %></div></div>
                    <div class="info-item"><label>Pending Amount</label><div class="neg">&#8377; <%= String.format("%,d", pending) %></div></div>
                    <div class="info-item"><label>Payment Status</label><div><span class="status <%= statusClass %>"><%= d(statusLabel) %></span></div></div>
                </div>
            </section>

        </div>

    </div>

  </div>

</div>

<script id="fd-js">
(function () {
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var page = document.querySelector('.dpa-dash');
	if (!page) return;
	var ni = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 });   /* whole rupees, no paise */
	var INT = /^\d+$/;

	function read(el) {
		var money = el.hasAttribute('data-money');
		var raw = (el.getAttribute(money ? 'data-money' : 'data-count') || '').trim();
		return { money: money, ok: INT.test(raw), val: parseInt(raw, 10) };
	}
	function show(el, d, v) { el.textContent = (d.money ? '\u20B9 ' : '') + ni.format(v); }
	function countUp(el) {
		if (el.dataset.counted) return; el.dataset.counted = '1';
		var d = read(el);
		if (!d.ok) return;
		show(el, d, d.val);
		if (reduce || d.val === 0) return;
		var start = null, dur = 1000;
		function tick(ts) {
			if (start === null) start = ts;
			var p = Math.min((ts - start) / dur, 1), e = 1 - Math.pow(1 - p, 3);
			show(el, d, Math.round(d.val * e));
			if (p < 1) requestAnimationFrame(tick); else show(el, d, d.val);
		}
		requestAnimationFrame(tick);
	}

	['.stat-row', '.ed-col'].forEach(function (sel) {
		page.querySelectorAll(sel).forEach(function (g) {
			Array.prototype.forEach.call(g.children, function (el, i) { el.style.setProperty('--d', (i * 90) + 'ms'); });
		});
	});
	function reveal(el) {
		el.classList.add('in');
		el.querySelectorAll('[data-count],[data-money]').forEach(countUp);
	}
	var targets = page.querySelectorAll('.reveal');
	if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
		}, { threshold: 0.1, rootMargin: '0px 0px -30px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}
})();
</script>

</body>
</html>
