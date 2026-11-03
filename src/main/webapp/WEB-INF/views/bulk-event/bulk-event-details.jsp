<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.digitalpurohit.model.BulkEvent"%>
<%!
/* HTML-escape, "-" when empty */
private static String d(Object o) {
    if (o == null) return "-";
    String s = String.valueOf(o).replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    return s.trim().isEmpty() ? "-" : s;
}
%>
<%
BulkEvent event = (BulkEvent) request.getAttribute("bulkEvent");
if (event == null) {
    response.sendRedirect(request.getContextPath() + "/bulk-events");
    return;
}

int totalFamilies = event.getTotalFamilies();
int paidFamilies = event.getPaidFamilies();
int pendingFamilies = event.getPendingFamilies();
long collected = Math.round(event.getTotalAmountCollected());
int paidPct = totalFamilies > 0 ? (int) Math.max(0, Math.min(100, Math.round(paidFamilies * 100.0 / totalFamilies))) : 0;

boolean hasNotes = event.getNotes() != null && !event.getNotes().isBlank();
String notesText = hasNotes ? d(event.getNotes()) : "No Notes Available";
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bulk Event Details | Digital Purohit Assistant</title>

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

<style id="bd-theme">
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

<style id="bd-css">/* =====================================================================
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

/* ---------- bulk event details ---------- */
@keyframes dpaSpin{ to{ transform:rotate(360deg); } }
@keyframes bdPop{ from{ opacity:0; transform:translateY(20px) scale(.94); } to{ opacity:1; transform:none; } }
@keyframes bdFade{ from{ opacity:0; } to{ opacity:1; } }
.dpa-dash .page-header h1{ font-size:clamp(1.6em, 3vw, 2.8em); }
.dpa-dash .hero-right{ display:flex; align-items:center; gap:.9em; flex-wrap:wrap; }
.dpa-dash .hero-btn{
	display:inline-flex; align-items:center; gap:.6em; padding:.75em 1.15em; border-radius:.85em;
	border:1px solid rgba(255,255,255,.3); background:rgba(255,255,255,.06); color:#fff; font-weight:600; font-size:.95em; text-decoration:none;
	transition:transform .25s cubic-bezier(.2,.8,.2,1), background-color .25s;
}
.dpa-dash .hero-btn i{ display:inline-flex; font-size:1.1em; }
.dpa-dash .stat-sub b{ color:var(--dpa-text); }
.dpa-dash .c-blue{ --acc:#2b7fff; --acc-soft:rgba(43,127,255,.16); }
.dpa-dash .notes-text{ line-height:1.7; font-weight:500; white-space:pre-wrap; overflow-wrap:anywhere; }
.dpa-dash .notes-text.none{ color:var(--dpa-muted); font-style:italic; font-weight:400; }
.dpa-dash .fm-body{ padding:1.3em 1.5em 1.5em; }

.dpa-dash .act-list{ display:flex; flex-direction:column; gap:.7em; padding:1.2em 1.5em 1.5em; }
.dpa-dash .act-item{
	--c:#2b7fff; position:relative; display:flex; align-items:center; gap:1em; padding:.8em 1em;
	border-radius:.9em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2); color:var(--dpa-text); text-decoration:none;
	transition:transform .25s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .25s;
}
.dpa-dash .act-item.g{ --c:#1fbf6a; } .dpa-dash .act-item.p{ --c:#9b7bff; } .dpa-dash .act-item.o{ --c:#f0a43a; } .dpa-dash .act-item.r{ --c:#ff6b6b; }
.dpa-dash .act-ico{
	flex-shrink:0; width:2.7em; height:2.7em; border-radius:.8em; display:flex; align-items:center; justify-content:center;
	color:var(--c); background:color-mix(in srgb, var(--c) 16%, transparent);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .act-item h3{ flex:1; font-size:1em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .act-go{ flex-shrink:0; color:var(--dpa-muted); transition:transform .3s cubic-bezier(.34,1.56,.64,1), color .25s; }
.dpa-dash .act-item:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

.dpa-dash .fam{ display:flex; flex-direction:column; gap:1em; padding:1.3em 1.5em 1.5em; }
.dpa-dash .fam p{ font-size:.92em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .btn{
	display:inline-flex; align-items:center; justify-content:center; gap:.6em; width:100%; margin:0; padding:.85em 1.4em;
	border-radius:.8em; border:1px solid #1f9d55; background:#1f9d55; color:#fff; text-decoration:none; cursor:pointer;
	font-family:inherit; font-size:.95em; font-weight:700; line-height:1.2; white-space:nowrap;
	transition:background-color .2s, transform .12s, box-shadow .25s;
}
.dpa-dash .btn:active{ transform:scale(.96); }
.dpa-dash .btn:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* delete confirm (outside .dpa-dash) */
.bd-modal{ position:fixed; inset:0; z-index:2200; display:none; align-items:center; justify-content:center; padding:20px; background:rgba(0,0,0,.6); -webkit-backdrop-filter:blur(6px); backdrop-filter:blur(6px); font-family:'Inter', system-ui, sans-serif; }
.bd-modal.show{ display:flex; animation:bdFade .25s ease both; }
.bd-card{ width:100%; max-width:25em; padding:1.8em 1.6em 1.6em; text-align:center; border-radius:18px; border:1px solid var(--dpa-border); background:var(--dpa-surface); color:var(--dpa-text); box-shadow:0 30px 80px rgba(0,0,0,.5); animation:bdPop .4s cubic-bezier(.2,.8,.2,1) both; }
.bd-ico{ width:64px; height:64px; margin:0 auto 14px; border-radius:50%; display:grid; place-items:center; font-size:28px; background:rgba(255,107,107,.15); color:#ff6b6b; }
.bd-card h3{ margin:0; font-size:19px; font-weight:700; }
.bd-card p{ margin:8px 0 20px; font-size:14px; font-weight:400; color:var(--dpa-muted); overflow-wrap:anywhere; }
.bd-row{ display:flex; gap:10px; }
.bd-row button{ flex:1; padding:12px 16px; border-radius:11px; border:1px solid var(--dpa-border); background:transparent; color:var(--dpa-text); font:700 14px 'Inter', sans-serif; cursor:pointer; transition:background-color .2s, transform .12s; }
.bd-row button:active{ transform:scale(.96); }
.bd-row .danger{ background:#e04b4b; border-color:#e04b4b; color:#fff; }
.bd-row button:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }

@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ transform:translateX(-4px); background:rgba(255,255,255,.14); }
	.dpa-dash .act-item:hover{ transform:translateX(5px); border-color:var(--c); background:color-mix(in srgb, var(--c) 7%, var(--dpa-surface-2)); }
	.dpa-dash .act-item:hover .act-ico{ transform:rotate(-8deg) scale(1.1); background:var(--c); color:#fff; }
	.dpa-dash .act-item:hover .act-go{ transform:translateX(4px); color:var(--c); }
	.dpa-dash .btn:hover{ background:#23b062; border-color:#23b062; box-shadow:0 8px 20px rgba(31,157,85,.35); }
	.bd-row button:not(.danger):hover{ background:var(--dpa-hover); }
	.bd-row .danger:hover{ background:#ee5a5a; }
}
@media (prefers-reduced-motion: reduce){ .bd-modal, .bd-card{ animation:none !important; } }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<main class="main-content">

  <div class="bulk-event-details-page dpa-dash">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
        <div class="hero-left">
            <div class="hero-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i></div>
            <div>
                <h1><%= d(event.getBulkEventName()) %></h1>
                <p>Bulk Event Overview</p>
            </div>
        </div>
        <div class="hero-right">
            <div class="hero-chip">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i>
                <div><b><%= d(event.getStartDate()) %></b><small>to <%= d(event.getEndDate()) %></small></div>
            </div>
            <a href="${pageContext.request.contextPath}/bulk-events" class="hero-btn">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="m12 19-7-7 7-7"/><path d="M19 12H5"/></svg></i> Back
            </a>
        </div>
    </div>

    <!-- ================= STATISTICS ================= -->
    <div class="stat-row">
        <div class="stat-card c-blue reveal">
            <div class="stat-body">
                <div class="stat-label">Total Families</div>
                <div class="stat-value" data-count="<%= totalFamilies %>"><%= totalFamilies %></div>
                <div class="stat-sub">Registered</div>
            </div>
            <div class="stat-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i></div>
        </div>
        <div class="stat-card c-green reveal">
            <div class="stat-body">
                <div class="stat-label">Paid Families</div>
                <div class="stat-value" data-count="<%= paidFamilies %>"><%= paidFamilies %></div>
                <div class="stat-sub"><b><%= paidPct %>%</b> of all families</div>
            </div>
            <div class="stat-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i></div>
        </div>
        <div class="stat-card c-orange reveal">
            <div class="stat-body">
                <div class="stat-label">Pending Families</div>
                <div class="stat-value" data-count="<%= pendingFamilies %>"><%= pendingFamilies %></div>
                <div class="stat-sub">Still to pay</div>
            </div>
            <div class="stat-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></i></div>
        </div>
        <div class="stat-card c-purple reveal">
            <div class="stat-body">
                <div class="stat-label">Collected</div>
                <div class="stat-value" data-money="<%= collected %>">&#8377; <%= String.format("%,d", collected) %></div>
                <div class="stat-sub">Total received</div>
            </div>
            <div class="stat-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M6 3h12"/><path d="M6 8h12"/><path d="m6 13 8.5 8"/><path d="M6 13h3"/><path d="M9 13c6.667 0 6.667-10 0-10"/></svg></i></div>
        </div>
    </div>

    <div class="ed-grid">

        <div class="ed-col">

            <!-- ================= EVENT INFORMATION ================= -->
            <section class="section-card reveal" aria-labelledby="bdInfo">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i>
                        <div><h2 id="bdInfo">Event Information</h2><p>Dates and place</p></div>
                    </div>
                </div>
                <div class="info-grid">
                    <div class="info-item"><label>Start Date</label><div><%= d(event.getStartDate()) %></div></div>
                    <div class="info-item"><label>End Date</label><div><%= d(event.getEndDate()) %></div></div>
                    <div class="info-item"><label>Location</label><div><%= d(event.getLocation()) %></div></div>
                    <div class="info-item"><label>Created On</label><div><%= d(event.getCreatedAt()) %></div></div>
                </div>
            </section>

            <!-- ================= NOTES ================= -->
            <section class="section-card reveal" aria-labelledby="bdNotes">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/></svg></i>
                        <div><h2 id="bdNotes">Notes</h2><p>Anything worth remembering</p></div>
                    </div>
                </div>
                <div class="fm-body">
                    <p class="notes-text<%= hasNotes ? "" : " none" %>"><%= notesText %></p>
                </div>
            </section>

        </div>

        <div class="ed-col">

            <!-- ================= QUICK ACTIONS ================= -->
            <section class="section-card reveal" aria-labelledby="bdActions">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M4 14a1 1 0 0 1-.78-1.63l9.9-10.2a.5.5 0 0 1 .86.46l-1.92 6.02A1 1 0 0 0 13 10h7a1 1 0 0 1 .78 1.63l-9.9 10.2a.5.5 0 0 1-.86-.46l1.92-6.02A1 1 0 0 0 11 14z"/></svg></i>
                        <div><h2 id="bdActions">Quick Actions</h2><p>Manage this bulk event</p></div>
                    </div>
                </div>
                <div class="act-list">
              <a class="act-item"
   href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%= event.getYatraId() %>">

    <span class="act-ico">
        <!-- Keep your existing Families icon here -->
    </span>

    <h3>Families</h3>
    <p>View and manage registered families</p>
</a>
                <a class="act-item g" href="${pageContext.request.contextPath}/bulk-event-payments?bulkEventId=<%= event.getYatraId() %>">
                    <span class="act-ico" aria-hidden="true"><i><svg viewBox="0 0 24 24"><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg></i></span>
                    <h3>Payments</h3>
                    <span class="act-go" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></i></span>
                </a>
                <a class="act-item p" href="${pageContext.request.contextPath}/bulk-event-report?bulkEventId=<%= event.getYatraId() %>">
                    <span class="act-ico" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M3 3v16a2 2 0 0 0 2 2h16"/><path d="M18 17V9"/><path d="M13 17V5"/><path d="M8 17v-3"/></svg></i></span>
                    <h3>Report</h3>
                    <span class="act-go" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></i></span>
                </a>
                <a class="act-item o" href="${pageContext.request.contextPath}/edit-bulk-event?id=<%= event.getYatraId() %>">
                    <span class="act-ico" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M12 20h9"/><path d="M16.376 3.622a1 1 0 0 1 3.002 3.002L7.368 18.635a2 2 0 0 1-.855.506l-2.872.838a.5.5 0 0 1-.62-.62l.838-2.872a2 2 0 0 1 .506-.854z"/></svg></i></span>
                    <h3>Edit</h3>
                    <span class="act-go" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></i></span>
                </a>
                <a class="act-item r delete" data-name="<%= d(event.getBulkEventName()) %>" href="${pageContext.request.contextPath}/delete-bulk-event?id=<%= event.getYatraId() %>">
                    <span class="act-ico" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></i></span>
                    <h3>Delete</h3>
                    <span class="act-go" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></i></span>
                </a>
                </div>
            </section>

            <!-- ================= FAMILY PREVIEW ================= -->
            <section class="section-card reveal" aria-labelledby="bdFam">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i>
                        <div><h2 id="bdFam">Recent Families</h2><p>Latest registered families</p></div>
                    </div>
                </div>
                <div class="fam">
                    <p>Latest registered families will appear here.</p>
                    <a class="btn" href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%= event.getYatraId() %>">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i> View All Families
                    </a>
                </div>
            </section>

        </div>

    </div>

  </div>

</main>

<!-- ================= CONFIRM DELETE ================= -->
<div class="bd-modal" id="bdModal" role="dialog" aria-modal="true" aria-labelledby="bdModalTitle">
    <div class="bd-card">
        <div class="bd-ico" aria-hidden="true"><i><svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></i></div>
        <h3 id="bdModalTitle">Delete this bulk event?</h3>
        <p id="bdModalText"></p>
        <div class="bd-row">
            <button type="button" id="bdCancel">Cancel</button>
            <button type="button" class="danger" id="bdConfirm">Delete</button>
        </div>
    </div>
</div>

<script id="bd-js">
(function () {
	var $ = function (id) { return document.getElementById(id); };
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var page = document.querySelector('.dpa-dash');
	var ni = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 });   /* whole rupees, no paise */
	var INT = /^\d+$/;

	/* ---------- numbers: grouping + count-up ---------- */
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
	if (page) {
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
	}

	/* ---------- confirm before deleting ---------- */
	var modal = $('bdModal'), pending = null;
	function closeModal() { modal.classList.remove('show'); document.documentElement.classList.remove('dpa-lock'); pending = null; }
	document.querySelectorAll('a.act-item.delete').forEach(function (a) {
		a.addEventListener('click', function (e) {
			e.preventDefault();
			pending = a;
			$('bdModalText').textContent = (a.getAttribute('data-name') || '') + ' and its details will be removed. This cannot be undone.';
			modal.classList.add('show'); document.documentElement.classList.add('dpa-lock');
			$('bdCancel').focus();
		});
	});
	$('bdCancel').addEventListener('click', closeModal);
	modal.addEventListener('click', function (e) { if (e.target === modal) closeModal(); });
	document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeModal(); });
	$('bdConfirm').addEventListener('click', function () {
		if (!pending) return;
		if (window.bdOnDelete) { window.bdOnDelete(pending); closeModal(); return; }
		$('bdConfirm').disabled = true; $('bdConfirm').textContent = 'Deleting\u2026';
		window.location.href = pending.href;
	});
	window.addEventListener('pageshow', function (e) { if (e.persisted) location.reload(); });
})();
</script>

</body>
</html>
