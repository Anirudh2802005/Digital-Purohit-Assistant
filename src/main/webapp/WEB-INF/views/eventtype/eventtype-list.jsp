<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.EventType"%>
<%!
/* HTML-escape (null -> "") */
private static String h(Object o) {
    if (o == null) return "";
    return String.valueOf(o).replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
}
%>
<%
List<EventType> eventTypes = (List<EventType>) request.getAttribute("eventTypes");
String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");
int total = eventTypes == null ? 0 : eventTypes.size();
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Event Types | Digital Purohit Assistant</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Anton&family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css">

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

<style id="vt-theme">
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

<style id="vt-css">/* =====================================================================
   EVENTS DASHBOARD — same design system as Customers / Pending Payments
   Colours come from the shared theme variables (--dpa-*), so the
   dark / light switch restyles this page too.
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
	max-width:108em; margin:0 auto;
	display:flex; flex-direction:column; gap:1.5em;
	font-family:'Inter', ui-sans-serif, system-ui, sans-serif;
	font-size:calc(14px * var(--dk)); font-weight:500; line-height:1.45;
	color:var(--dpa-text);
	-webkit-font-smoothing:antialiased;
}
.dpa-dash, .dpa-dash *{ box-sizing:border-box; }
.dpa-dash h1, .dpa-dash h2, .dpa-dash h3, .dpa-dash p{ margin:0; }
.dpa-dash a{ text-decoration:none; color:inherit; }
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
.dpa-dash .page-header p{ margin-top:.55em; color:rgba(255,255,255,.72); font-weight:400; font-size:1.05em; }
/* ---------- hover (mouse only) ---------- */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .summary-card:hover{ transform:translateY(-4px); border-color:var(--acc); }
	.dpa-dash .summary-card:hover::after{ opacity:1; transform:none; }
	.dpa-dash .summary-card:hover .summary-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .action-card:hover{ transform:translateY(-4px); border-color:var(--dpa-twilight); background:var(--dpa-hover); }
	.dpa-dash .action-card:hover .action-icon{ transform:rotate(-8deg) scale(1.1); background:var(--dpa-twilight); color:#fff; }
	.dpa-dash .action-card:hover .action-go{ transform:translateX(4px); background:var(--dpa-twilight); border-color:var(--dpa-twilight); color:#fff; }
}
.dpa-dash a:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }
/* ---------- responsive ---------- */
@media (max-width:1100px){ .dpa-dash .event-summary{ grid-template-columns:repeat(2, minmax(0, 1fr)); } }
@media (max-width:900px){	.main-content{ margin-left:0; width:100%; padding:clamp(14px, 2.4vw, 24px); }
}
@media (max-width:700px){	.main-content{ padding:14px; }
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
}
@media print{	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1 !important; animation:none !important; }
	.dpa-dash .hero-watermark{ display:none; }
}
@media (prefers-reduced-motion: reduce){	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
}

/* ---------- view event types ---------- */
@keyframes vtBar{ from{ transform:scaleX(0); } to{ transform:scaleX(1); } }
.dpa-dash .hero-btn{
	display:inline-flex; align-items:center; gap:.6em; padding:.75em 1.15em; border-radius:.85em;
	border:1px solid rgba(255,255,255,.3); background:rgba(255,255,255,.06); color:#fff; font-weight:600; font-size:.95em;
	transition:transform .25s cubic-bezier(.2,.8,.2,1), background-color .25s;
}
.dpa-dash .hero-btn i{ display:inline-flex; font-size:1.1em; }

.dpa-dash .filter-card{
	margin:0; padding:1em 1.3em; border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); transition:background-color .35s, border-color .35s;
}
.dpa-dash .search-form{ display:flex; gap:.7em; align-items:stretch; }
.dpa-dash .search-field{
	flex:1; min-width:0; display:flex; align-items:center; gap:.7em; padding:0 1em;
	border-radius:.75em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:border-color .2s, box-shadow .2s;
}
.dpa-dash .search-field:focus-within{ border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.2); }
.dpa-dash .search-field i{ color:var(--dpa-muted); flex-shrink:0; transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .search-field:focus-within i{ color:var(--dpa-link); transform:scale(1.12); }
.dpa-dash .search-field input{
	flex:1; min-width:0; width:100%; margin:0; padding:.9em 0; border:0; outline:0; box-shadow:none; background:transparent;
	font-family:inherit; font-size:1em; font-weight:500; color:var(--dpa-text);
}
.dpa-dash .search-field input::placeholder{ color:var(--dpa-muted); opacity:.8; font-weight:400; }
.dpa-dash .btn{
	display:inline-flex; align-items:center; justify-content:center; gap:.6em; margin:0; padding:.85em 1.4em;
	border-radius:.8em; border:1px solid var(--dpa-border); background:transparent; box-shadow:none; cursor:pointer;
	font-family:inherit; font-size:.95em; font-weight:700; line-height:1.2; color:var(--dpa-text); white-space:nowrap;
	transition:background-color .2s, color .2s, transform .12s, box-shadow .25s, border-color .2s;
}
.dpa-dash .btn.primary{ background:#1f9d55; border-color:#1f9d55; color:#fff; }
.dpa-dash .btn:active{ transform:scale(.96); }
.dpa-dash .btn:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

.dpa-dash .list-head{ display:flex; align-items:center; justify-content:space-between; gap:1em; flex-wrap:wrap; }
.dpa-dash .list-head h2{ display:flex; align-items:center; gap:.65em; font-size:1.15em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .list-head h2 i{ width:2.3em; height:2.3em; font-size:.85em; border-radius:.7em; display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile); }
.dpa-dash .tag{
	padding:.3em .85em; border-radius:999px; font-size:.78em; font-weight:700; letter-spacing:.04em;
	border:1px solid var(--dpa-border); color:var(--dpa-muted); white-space:nowrap;
}

.dpa-dash .type-grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(20em, 1fr)); gap:1.1em; margin:0; }
.dpa-dash .type-card{
	--acc:#1fbf6a; --acc-soft:rgba(31,191,106,.16);
	position:relative; overflow:hidden; display:flex; flex-direction:column; gap:1em;
	margin:0; padding:1.5em 1.6em 1.3em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .type-card.off{ --acc:#ff6b6b; --acc-soft:rgba(255,107,107,.16); }
.dpa-dash .type-card::before{
	content:""; position:absolute; left:0; top:0; height:3px; width:100%; background:var(--acc);
	transform:scaleX(0); transform-origin:left; transition:transform .9s cubic-bezier(.2,.8,.2,1) .25s;
}
.dpa-dash .type-card.in::before, html:not(.dpa-js) .dpa-dash .type-card::before{ transform:scaleX(1); }
.dpa-dash .tc-top{ display:flex; align-items:flex-start; gap:1em; min-width:0; }
.dpa-dash .tc-icon{
	flex-shrink:0; width:3em; height:3em; border-radius:.95em; font-size:1.1em;
	display:flex; align-items:center; justify-content:center; background:var(--acc-soft); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .tc-name{ font-size:1.15em; font-weight:700; letter-spacing:-.01em; overflow-wrap:anywhere; line-height:1.25; }
.dpa-dash .tc-desc{
	font-size:.92em; font-weight:400; color:var(--dpa-muted); line-height:1.55; min-height:3.1em;
	display:-webkit-box; -webkit-line-clamp:3; -webkit-box-orient:vertical; overflow:hidden; overflow-wrap:anywhere;
}
.dpa-dash .tc-desc.none{ font-style:italic; opacity:.75; }
.dpa-dash .pill{
	display:inline-flex; align-items:center; gap:.5em; padding:.3em .9em; border-radius:999px; width:fit-content;
	font-size:.76em; font-weight:700; letter-spacing:.06em; text-transform:uppercase;
	background:rgba(52,211,153,.15); color:var(--good);
}
.dpa-dash .pill::before{ content:""; width:.5em; height:.5em; border-radius:50%; background:currentColor; }
.dpa-dash .pill.off{ background:rgba(255,107,107,.15); color:var(--bad2); }
.dpa-dash .pill.off::before{ animation:dpaBlink 1.6s ease-in-out infinite; }
@keyframes dpaBlink{ 0%,100%{ opacity:1; } 50%{ opacity:.35; } }
.dpa-dash .tc-foot{ margin-top:auto; padding-top:1em; border-top:1px solid var(--dpa-border); display:flex; align-items:center; justify-content:space-between; gap:1em; }
.dpa-dash .tc-link{ font-weight:700; font-size:.95em; color:var(--dpa-text); }
.dpa-dash .tc-link::after{ content:""; position:absolute; inset:0; }   /* the whole card is clickable */
.dpa-dash .tc-go{
	flex-shrink:0; width:2.3em; height:2.3em; border-radius:50%; display:flex; align-items:center; justify-content:center;
	border:1px solid var(--dpa-border); color:var(--dpa-muted);
	transition:transform .3s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s, border-color .25s;
}
.dpa-dash .empty-box{
	grid-column:1 / -1; display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:.5em;
	margin:0; padding:3em 1em; border-radius:1.15em; border:1.5px dashed var(--dpa-border); color:var(--dpa-muted);
}
.dpa-dash .empty-box i{ font-size:2.6em; opacity:.6; animation:vtBob 3.4s ease-in-out infinite; }
.dpa-dash .empty-box p{ font-size:1.05em; font-weight:600; color:var(--dpa-text); opacity:.9; }
@keyframes vtBob{ 0%,100%{ transform:translateY(0); } 50%{ transform:translateY(-6px); } }

@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ transform:translateX(-4px); background:rgba(255,255,255,.14); }
	.dpa-dash .search-field:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .btn.primary:hover{ background:#23b062; border-color:#23b062; box-shadow:0 8px 20px rgba(31,157,85,.35); }
	.dpa-dash .btn:not(.primary):hover{ background:var(--dpa-hover); border-color:var(--dpa-twilight); }
	.dpa-dash .type-card:hover{ transform:translateY(-5px); border-color:var(--acc); }
	.dpa-dash .type-card:hover .tc-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .type-card:hover .tc-go{ transform:translateX(4px); background:var(--dpa-twilight); border-color:var(--dpa-twilight); color:#fff; }
}
.dpa-dash .type-card:active{ transform:scale(.985); }
.dpa-dash .type-card:focus-within{ border-color:var(--dpa-twilight); }
@media (max-width:700px){
	.dpa-dash .search-form{ flex-wrap:wrap; }
	.dpa-dash .search-form .btn{ flex:1; }
	.dpa-dash .type-grid{ grid-template-columns:minmax(0, 1fr); }
	.dpa-dash .filter-card{ padding:.9em 1em; }
}
@media (prefers-reduced-motion: reduce){ .dpa-dash .empty-box i, .dpa-dash .pill.off::before{ animation:none !important; } }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<%@ include file="../partials/toast.jsp"%>

<div class="main-content">

  <div class="view-event-types-page dpa-dash">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
        <div class="hero-left">
            <div class="hero-icon">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="8" height="4" x="8" y="2" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><path d="M12 11h4"/><path d="M12 16h4"/><path d="M8 11h.01"/><path d="M8 16h.01"/></svg></i>
            </div>
            <div>
                <h1>View Event Types</h1>
                <p>Browse and manage all event types.</p>
            </div>
        </div>
        <a class="hero-btn" href="${pageContext.request.contextPath}/event-types">
            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"/><path d="M3 10a2 2 0 0 1 .709-1.528l7-5.999a2 2 0 0 1 2.582 0l7 5.999A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg></i> Dashboard
        </a>
    </div>

    <!-- ================= SEARCH ================= -->
    <div class="filter-card reveal">
        <form class="search-form" action="${pageContext.request.contextPath}/view-event-types" method="get">
            <label class="search-field">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>
                <input type="text" name="keyword" id="keyword" autocomplete="off" placeholder="Search Event Type..." value="<%= h(keyword) %>">
            </label>
            <% if (!keyword.isEmpty()) { %>
            <a class="btn" href="${pageContext.request.contextPath}/view-event-types">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i> Clear
            </a>
            <% } %>
            <button type="submit" class="btn primary">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i> Search
            </button>
        </form>
    </div>

    <!-- ================= LIST ================= -->
    <div class="list-head reveal">
        <h2><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/><circle cx="7.5" cy="7.5" r=".5" fill="currentColor"/></svg></i> <%= keyword.isEmpty() ? "All Event Types" : "Results for \"" + h(keyword) + "\"" %></h2>
        <span class="tag"><%= total %> <%= total == 1 ? "event type" : "event types" %></span>
    </div>

    <div class="type-grid">
    <%-- LIST-BEGIN --%>
    <%
    if (eventTypes != null && !eventTypes.isEmpty()) {
        for (EventType eventType : eventTypes) {
            boolean active = eventType.isActive();
            String desc = eventType.getDescription();
            boolean noDesc = desc == null || desc.trim().isEmpty();
    %>
        <article class="type-card<%= active ? "" : " off" %> reveal">
            <div class="tc-top">
                <div class="tc-icon" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/><circle cx="7.5" cy="7.5" r=".5" fill="currentColor"/></svg></i></div>
                <h2 class="tc-name"><%= h(eventType.getTypeName()) %></h2>
            </div>

            <p class="tc-desc<%= noDesc ? " none" : "" %>"><%= noDesc ? "No Description" : h(desc) %></p>

            <span class="pill<%= active ? "" : " off" %>"><%= active ? "Active" : "Inactive" %></span>

            <div class="tc-foot">
                <a class="tc-link" href="${pageContext.request.contextPath}/event-type-details?id=<%= eventType.getTypeId() %>">View Details</a>
                <span class="tc-go" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></i></span>
            </div>
        </article>
    <%
        }
    } else {
    %>
        <div class="empty-box reveal">
            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/></svg></i>
            <p>No Event Types Found</p>
        </div>
    <% } %>
    <%-- LIST-END --%>
    </div>

  </div>

</div>

<script id="vt-js">
(function () {
	var page = document.querySelector('.dpa-dash');
	if (!page) return;

	/* ---------- staggered scroll reveal ---------- */
	page.querySelectorAll('.type-grid').forEach(function (g) {
		Array.prototype.forEach.call(g.children, function (el, i) { el.style.setProperty('--d', (Math.min(i, 12) * 70) + 'ms'); });
	});
	function reveal(el) { el.classList.add('in'); }
	var targets = page.querySelectorAll('.reveal');
	if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
		}, { threshold: 0.08, rootMargin: '0px 0px -30px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}
})();
</script>

</body>
</html>
