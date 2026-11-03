<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.EventType"%>
<%@ page import="com.digitalpurohit.model.Samagri"%>
<%!
/* HTML-escape (null -> "") */
private static String h(Object o) {
    if (o == null) return "";
    return String.valueOf(o).replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
}
%>
<%
EventType eventType = (EventType) request.getAttribute("eventType");
if (eventType == null) {
    response.sendRedirect(request.getContextPath() + "/view-event-types");
    return;
}

List<Samagri> assignedSamagri = (List<Samagri>) request.getAttribute("assignedSamagri");
List<Samagri> availableSamagri = (List<Samagri>) request.getAttribute("availableSamagri");
%>
<%
String success = request.getParameter("success");
String error = request.getParameter("error");

if ("assigned".equals(success)) {
    request.setAttribute("success", "Samagri assigned successfully.");
}

if ("removed".equals(success)) {
    request.setAttribute("success", "Samagri removed successfully.");
}

if ("assign".equals(error)) {
    request.setAttribute("error", "Unable to assign Samagri.");
}

if ("remove".equals(error)) {
    request.setAttribute("error", "Unable to remove Samagri.");
}

String okMsg = (String) request.getAttribute("success");
String errMsg = (String) request.getAttribute("error");
int assignedCount = assignedSamagri == null ? 0 : assignedSamagri.size();
int availableCount = availableSamagri == null ? 0 : availableSamagri.size();
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Samagri | Digital Purohit Assistant</title>

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

<style id="ms-theme">
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

<style id="ms-css">/* =====================================================================
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

/* ---------- manage samagri ---------- */
@keyframes msRow{ from{ opacity:0; translate:-12px 0; } to{ opacity:1; translate:0 0; } }
@keyframes msBob{ 0%,100%{ transform:translateY(0); } 50%{ transform:translateY(-6px); } }
@keyframes dpaSpin{ to{ transform:rotate(360deg); } }
.dpa-dash .hero-btn{
	display:inline-flex; align-items:center; gap:.6em; padding:.75em 1.15em; border-radius:.85em;
	border:1px solid rgba(255,255,255,.3); background:rgba(255,255,255,.06); color:#fff; font-weight:600; font-size:.95em;
	transition:transform .25s cubic-bezier(.2,.8,.2,1), background-color .25s;
}
.dpa-dash .hero-btn i{ display:inline-flex; font-size:1.1em; }

/* type info */
.dpa-dash .info-card{ display:flex; align-items:center; gap:1.2em; flex-wrap:wrap; padding:1.4em 1.6em; }
.dpa-dash .info-icon{
	flex-shrink:0; width:3.4em; height:3.4em; border-radius:1em; font-size:1.15em; display:flex; align-items:center; justify-content:center;
	color:#fff; background:linear-gradient(135deg, #426188, #2b7fff); box-shadow:0 10px 26px rgba(43,127,255,.25);
}
.dpa-dash .info-text{ flex:1; min-width:14em; }
.dpa-dash .info-text h2{ font-size:1.3em; font-weight:700; letter-spacing:-.01em; overflow-wrap:anywhere; }
.dpa-dash .info-text p{ margin-top:.3em; font-size:.92em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .counters{ display:flex; gap:.8em; }
.dpa-dash .counter{ min-width:7.5em; padding:.8em 1.1em; border-radius:.95em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2); text-align:center; }
.dpa-dash .counter b{ display:block; font-size:1.7em; font-weight:700; line-height:1.1; font-variant-numeric:tabular-nums; }
.dpa-dash .counter span{ display:block; margin-top:.25em; font-size:.78em; font-weight:600; letter-spacing:.06em; text-transform:uppercase; color:var(--dpa-muted); }
.dpa-dash .counter.g b{ color:var(--good); } .dpa-dash .counter.o b{ color:var(--pend); }

/* layout + cards */
.dpa-dash .ms-grid{ display:grid; grid-template-columns:minmax(0, 1.7fr) minmax(0, 1fr); gap:1.1em; align-items:start; }
.dpa-dash .section-card{
	margin:0; padding:0; overflow:hidden; min-width:0;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text); transition:background-color .35s, border-color .35s;
}
.dpa-dash .section-top{ display:flex; align-items:center; justify-content:space-between; gap:1em; flex-wrap:wrap; padding:1.15em 1.5em; border-bottom:1px solid var(--dpa-border); }
.dpa-dash .st-left{ display:flex; align-items:center; gap:.9em; min-width:0; }
.dpa-dash .st-left > i{
	flex-shrink:0; width:2.5em; height:2.5em; border-radius:.75em; display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .section-card:hover .st-left > i{ background:var(--dpa-twilight); color:#fff; transform:rotate(-8deg) scale(1.08); }
.dpa-dash .section-top h2{ font-size:1.12em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .section-top p{ margin-top:.2em; font-size:.85em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .tag{ padding:.3em .85em; border-radius:999px; font-size:.78em; font-weight:700; letter-spacing:.04em; border:1px solid var(--dpa-border); color:var(--dpa-muted); white-space:nowrap; }

/* assigned table */
.dpa-dash .table-wrap{ margin:1.1em 1.3em 1.3em; overflow-x:auto; border:1px solid var(--dpa-border); border-radius:.95em; }
.dpa-dash .ms-table{ width:100%; border-collapse:collapse; }
.dpa-dash .ms-table th{
	padding:.9em 1.1em; text-align:left; white-space:nowrap; font-size:.76em; font-weight:700; letter-spacing:.09em; text-transform:uppercase;
	color:var(--dpa-muted); background:var(--dpa-surface-2); border-bottom:1px solid var(--dpa-border);
}
.dpa-dash .ms-table th.right, .dpa-dash .ms-table td.act{ text-align:right; }
.dpa-dash .ms-table td{ padding:.95em 1.1em; border-bottom:1px solid var(--dpa-border); vertical-align:middle; }
.dpa-dash .ms-table tbody tr:last-child td{ border-bottom:0; }
.dpa-dash .ms-row{ transition:background-color .2s, opacity .35s, translate .35s; animation:msRow .5s cubic-bezier(.2,.8,.2,1) calc(var(--i, 0) * 50ms + 150ms) both; }
.dpa-dash .ms-row.gone{ opacity:0; translate:24px 0; }
.dpa-dash .ms-name{ display:flex; align-items:center; gap:.8em; font-weight:700; min-width:0; }
.dpa-dash .ms-name i{ flex-shrink:0; width:2.2em; height:2.2em; border-radius:.65em; display:inline-flex; align-items:center; justify-content:center; background:rgba(240,164,58,.16); color:var(--pend); }
.dpa-dash .ms-desc{ color:var(--dpa-muted); font-weight:400; overflow-wrap:anywhere; }
.dpa-dash .act{ white-space:nowrap; }
.dpa-dash .empty-row td{ padding:2.6em 1em; text-align:center; color:var(--dpa-muted); }
.dpa-dash .empty-row i{ display:block; font-size:2.2em; opacity:.6; margin-bottom:.4em; animation:msBob 3.4s ease-in-out infinite; }
.dpa-dash .empty-row p{ font-weight:600; color:var(--dpa-text); opacity:.9; }

/* buttons */
.dpa-dash .btn{
	display:inline-flex; align-items:center; justify-content:center; gap:.6em; margin:0; padding:.85em 1.4em;
	border-radius:.8em; border:1px solid var(--dpa-border); background:transparent; box-shadow:none; cursor:pointer; text-decoration:none;
	font-family:inherit; font-size:.95em; font-weight:700; line-height:1.2; color:var(--dpa-text); white-space:nowrap;
	transition:background-color .2s, color .2s, transform .12s, box-shadow .25s, border-color .2s;
}
.dpa-dash .btn.primary{ width:100%; background:#1f9d55; border-color:#1f9d55; color:#fff; }
.dpa-dash .btn.rm{ padding:.55em 1em; font-size:.85em; border-color:var(--bad2); color:var(--bad2); }
.dpa-dash .btn:active{ transform:scale(.96); }
.dpa-dash .btn.loading{ pointer-events:none; opacity:.85; }
.dpa-dash .btn.loading i{ animation:dpaSpin .8s linear infinite; }
.dpa-dash .btn[disabled]{ opacity:.45; cursor:not-allowed; pointer-events:none; }
.dpa-dash .btn:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* assign form */
.dpa-dash .assign-form{ display:flex; flex-direction:column; gap:1.1em; padding:1.4em 1.5em 1.5em; }
.dpa-dash .field label{ display:block; margin-bottom:.5em; font-size:.85em; font-weight:600; color:var(--dpa-muted); }
.dpa-dash .field-box{
	position:relative; display:flex; align-items:center; gap:.7em; padding:0 1em;
	border-radius:.75em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2); transition:border-color .2s, box-shadow .2s;
}
.dpa-dash .field-box:focus-within{ border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.2); }
.dpa-dash .field-box > i{ color:var(--dpa-muted); flex-shrink:0; transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .field-box:focus-within > i{ color:var(--dpa-link); transform:scale(1.12); }
.dpa-dash .field-box select{
	flex:1; min-width:0; width:100%; margin:0; padding:.9em 1.6em .9em 0; border:0; outline:0; box-shadow:none; background:transparent;
	font-family:inherit; font-size:1em; font-weight:500; color:var(--dpa-text); appearance:none; -webkit-appearance:none; cursor:pointer;
}
.dpa-dash .field-box select option{ background:var(--dpa-surface); color:var(--dpa-text); }
.dpa-dash .field-box::after{
	content:""; position:absolute; right:1em; top:50%; width:.5em; height:.5em; margin-top:-.4em;
	border-right:2px solid var(--dpa-muted); border-bottom:2px solid var(--dpa-muted); transform:rotate(45deg); pointer-events:none;
}
.dpa-dash .field-box:has(:user-invalid){ border-color:var(--bad2); }
.dpa-dash .note{ font-size:.85em; font-weight:400; color:var(--dpa-muted); }

/* toast + confirm popup (outside .dpa-dash) */
@keyframes toastIn{ from{ opacity:0; transform:translateX(30px); } to{ opacity:1; transform:none; } }
@keyframes toastBar{ from{ width:100%; } to{ width:0; } }
@keyframes popIn{ from{ opacity:0; transform:translateY(20px) scale(.94); } to{ opacity:1; transform:none; } }
@keyframes fadeIn{ from{ opacity:0; } to{ opacity:1; } }
.ms-toast{
	position:fixed; top:20px; right:20px; z-index:2100; display:none; align-items:flex-start; gap:12px; width:min(380px, calc(100vw - 32px));
	padding:14px 16px 16px; overflow:hidden; border-radius:14px; border:1px solid var(--dpa-border); background:var(--dpa-surface); color:var(--dpa-text);
	box-shadow:0 20px 60px rgba(0,0,0,.45); font-family:'Inter', system-ui, sans-serif; font-size:14px;
}
.ms-toast.show{ display:flex; animation:toastIn .45s cubic-bezier(.2,.8,.2,1) both; }
.ms-toast .ti{ flex-shrink:0; width:36px; height:36px; border-radius:10px; display:grid; place-items:center; font-size:17px; }
.ms-toast.ok .ti{ background:rgba(52,211,153,.16); color:#34d399; }
.ms-toast.err .ti{ background:rgba(255,107,107,.16); color:#ff6b6b; }
.ms-toast b{ display:block; font-weight:700; }
.ms-toast span.m{ display:block; margin-top:2px; font-weight:400; color:var(--dpa-muted); }
.ms-toast button{ margin-left:auto; border:0; background:transparent; color:var(--dpa-muted); cursor:pointer; font-size:16px; padding:2px; }
.ms-toast .bar{ position:absolute; left:0; bottom:0; height:3px; background:#34d399; animation:toastBar 4s linear forwards; }
.ms-toast.err .bar{ background:#ff6b6b; }

.ms-modal{ position:fixed; inset:0; z-index:2200; display:none; align-items:center; justify-content:center; padding:20px; background:rgba(0,0,0,.6); -webkit-backdrop-filter:blur(6px); backdrop-filter:blur(6px); font-family:'Inter', system-ui, sans-serif; }
.ms-modal.show{ display:flex; animation:fadeIn .25s ease both; }
.ms-modal-card{ width:100%; max-width:24em; padding:1.8em 1.6em 1.6em; text-align:center; border-radius:18px; border:1px solid var(--dpa-border); background:var(--dpa-surface); color:var(--dpa-text); box-shadow:0 30px 80px rgba(0,0,0,.5); animation:popIn .4s cubic-bezier(.2,.8,.2,1) both; }
.ms-modal-ico{ width:64px; height:64px; margin:0 auto 14px; border-radius:50%; display:grid; place-items:center; font-size:28px; background:rgba(255,107,107,.15); color:#ff6b6b; }
.ms-modal h3{ margin:0; font-size:19px; font-weight:700; }
.ms-modal p{ margin:8px 0 20px; font-size:14px; font-weight:400; color:var(--dpa-muted); overflow-wrap:anywhere; }
.ms-modal .row{ display:flex; gap:10px; }
.ms-modal .row button{ flex:1; padding:12px 16px; border-radius:11px; border:1px solid var(--dpa-border); background:transparent; color:var(--dpa-text); font:700 14px 'Inter', sans-serif; cursor:pointer; transition:background-color .2s, transform .12s; }
.ms-modal .row button:active{ transform:scale(.96); }
.ms-modal .row .danger{ background:#e04b4b; border-color:#e04b4b; color:#fff; }
.ms-modal .row button:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }
html.dpa-lock, html.dpa-lock body{ overflow:hidden; }

@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ transform:translateX(-4px); background:rgba(255,255,255,.14); }
	.dpa-dash .ms-table tbody tr:hover{ background:var(--dpa-hover); }
	.dpa-dash .btn.primary:hover{ background:#23b062; border-color:#23b062; box-shadow:0 8px 20px rgba(31,157,85,.35); }
	.dpa-dash .btn.rm:hover{ background:var(--bad2); color:#fff; }
	.dpa-dash .field-box:hover{ border-color:var(--dpa-twilight); }
	.ms-modal .row button:not(.danger):hover{ background:var(--dpa-hover); }
	.ms-modal .row .danger:hover{ background:#ee5a5a; }
}
@media (max-width:1000px){ .dpa-dash .ms-grid{ grid-template-columns:minmax(0, 1fr); } }
@media (max-width:760px){
	/* table becomes cards */
	.dpa-dash .ms-table thead{ display:none; }
	.dpa-dash .ms-table, .dpa-dash .ms-table tbody{ display:block; }
	.dpa-dash .ms-row{ display:grid; grid-template-columns:1fr; gap:.3em; padding:1em 1.1em; border-bottom:1px solid var(--dpa-border); }
	.dpa-dash .ms-row:last-child{ border-bottom:0; }
	.dpa-dash .ms-table td{ display:block; padding:.2em 0; border:0; text-align:left !important; }
	.dpa-dash .ms-table td.act .btn{ width:100%; margin-top:.4em; }
	.dpa-dash .empty-row{ display:block; }
	.dpa-dash .table-wrap{ margin:1em; }
	.dpa-dash .counters{ width:100%; } .dpa-dash .counter{ flex:1; }
}
@media (prefers-reduced-motion: reduce){ .ms-toast *, .ms-modal *, .ms-toast, .ms-modal-card, .dpa-dash .empty-row i{ animation:none !important; } }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

  <div class="manage-samagri-page dpa-dash">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
        <div class="hero-left">
            <div class="hero-icon">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg></i>
            </div>
            <div>
                <h1>Manage Samagri</h1>
                <p>Assign or remove required Samagri for this Event Type.</p>
            </div>
        </div>
        <a class="hero-btn" href="${pageContext.request.contextPath}/event-type-details?id=<%= eventType.getTypeId() %>">
            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="m12 19-7-7 7-7"/><path d="M19 12H5"/></svg></i> Back
        </a>
    </div>

    <!-- ================= EVENT TYPE ================= -->
    <section class="section-card info-card reveal">
        <div class="info-icon" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/><circle cx="7.5" cy="7.5" r=".5" fill="currentColor"/></svg></i></div>
        <div class="info-text">
            <h2><%= h(eventType.getTypeName()) %></h2>
            <p>Assign or remove required Samagri for this Event Type.</p>
        </div>
        <div class="counters">
            <div class="counter g"><b id="assignedCount"><%= assignedCount %></b><span>Assigned</span></div>
            <div class="counter o"><b><%= availableCount %></b><span>Available</span></div>
        </div>
    </section>

    <div class="ms-grid">

        <!-- ================= ASSIGNED ================= -->
        <section class="section-card reveal" aria-labelledby="msAssigned">
            <div class="section-top">
                <div class="st-left">
                    <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg></i>
                    <div><h2 id="msAssigned">Assigned Samagri</h2><p>Added automatically to events of this type</p></div>
                </div>
                <span class="tag" id="assignedTag"><%= assignedCount %> assigned</span>
            </div>
            <div class="table-wrap">
                <table class="ms-table">
                    <thead><tr><th>Name</th><th>Description</th><th class="right">Action</th></tr></thead>
                    <tbody id="assignedBody">
                    <%-- ROWS-BEGIN --%>
                    <%
                    if (assignedSamagri != null && !assignedSamagri.isEmpty()) {
                        int idx = 0;
                        for (Samagri s : assignedSamagri) {
                            String sd = s.getDescription();
                    %>
                        <tr class="ms-row" style="--i:<%= Math.min(idx++, 14) %>">
                            <td><span class="ms-name"><i aria-hidden="true"><svg viewBox="0 0 24 24" width="16" height="16"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg></i><%= h(s.getSamagriName()) %></span></td>
                            <td class="ms-desc"><%= (sd == null || sd.trim().isEmpty()) ? "-" : h(sd) %></td>
                            <td class="act">
                                <a class="btn rm" data-name="<%= h(s.getSamagriName()) %>"
                                   href="${pageContext.request.contextPath}/remove-eventtype-samagri?typeId=<%= eventType.getTypeId() %>&amp;samagriId=<%= s.getSamagriId() %>"
                                   onclick="return confirm('Remove this Samagri?');">
                                    <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></i> Remove
                                </a>
                            </td>
                        </tr>
                    <%
                        }
                    } else {
                    %>
                        <tr class="empty-row"><td colspan="3">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg></i>
                            <p>No Samagri Assigned</p>
                        </td></tr>
                    <% } %>
                    <%-- ROWS-END --%>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- ================= ASSIGN NEW ================= -->
        <section class="section-card reveal" aria-labelledby="msAssign">
            <div class="section-top">
                <div class="st-left">
                    <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M8 12h8"/><path d="M12 8v8"/></svg></i>
                    <div><h2 id="msAssign">Assign New Samagri</h2><p>Pick one from the master list</p></div>
                </div>
            </div>

            <form id="assignForm" class="assign-form" action="${pageContext.request.contextPath}/manage-eventtype-samagri" method="post">

                <input type="hidden" name="typeId" value="<%= eventType.getTypeId() %>">

                <div class="field">
                    <label for="samagriId">Select Samagri</label>
                    <div class="field-box">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg></i>
                        <select name="samagriId" id="samagriId" required <%= availableCount == 0 ? "disabled" : "" %>>
                            <option value="">Select Samagri</option>
                            <%-- OPTIONS-BEGIN --%>
                            <%
                            if (availableSamagri != null) {
                                for (Samagri s : availableSamagri) {
                            %>
                            <option value="<%= s.getSamagriId() %>"><%= h(s.getSamagriName()) %></option>
                            <%
                                }
                            }
                            %>
                            <%-- OPTIONS-END --%>
                        </select>
                    </div>
                </div>

                <% if (availableCount == 0) { %>
                <p class="note">Every samagri in the master list is already assigned to this event type.</p>
                <% } %>

                <button class="btn primary" type="submit" id="assignBtn" <%= availableCount == 0 ? "disabled" : "" %>>
                    <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M12 5v14"/></svg></i> <span>Assign Samagri</span>
                </button>
            </form>
        </section>

    </div>

  </div>

</div>

<!-- ================= MESSAGE (from ?success= / ?error=) ================= -->
<%-- TOAST-BEGIN --%>
<% if (okMsg != null || errMsg != null) { %>
<div class="ms-toast <%= errMsg != null ? "err" : "ok" %> show" id="msToast" role="status" aria-live="polite">
    <div class="ti" aria-hidden="true"><i>
        <% if (errMsg != null) { %><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg><% } else { %><svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg><% } %>
    </i></div>
    <div><b><%= errMsg != null ? "Something went wrong" : "Done" %></b><span class="m"><%= h(errMsg != null ? errMsg : okMsg) %></span></div>
    <button type="button" id="msToastClose" aria-label="Close message">&times;</button>
    <div class="bar"></div>
</div>
<% } else { %>
<div class="ms-toast ok" id="msToast" role="status" aria-live="polite">
    <div class="ti" aria-hidden="true"></div><div><b></b><span class="m"></span></div>
    <button type="button" id="msToastClose" aria-label="Close message">&times;</button><div class="bar"></div>
</div>
<% } %>
<%-- TOAST-END --%>

<!-- ================= CONFIRM REMOVE ================= -->
<div class="ms-modal" id="msModal" role="dialog" aria-modal="true" aria-labelledby="msModalTitle">
    <div class="ms-modal-card">
        <div class="ms-modal-ico" aria-hidden="true"><i><svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></i></div>
        <h3 id="msModalTitle">Remove this Samagri?</h3>
        <p id="msModalText"></p>
        <div class="row">
            <button type="button" id="msCancel">Cancel</button>
            <button type="button" class="danger" id="msConfirm">Remove</button>
        </div>
    </div>
</div>

<script id="ms-js">
(function () {
	var $ = function (id) { return document.getElementById(id); };
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var page = document.querySelector('.dpa-dash');

	/* ---------- scroll reveal ---------- */
	if (page) {
		var targets = page.querySelectorAll('.reveal');
		targets.forEach(function (el, i) { el.style.setProperty('--d', (i * 90) + 'ms'); });
		function reveal(el) { el.classList.add('in'); }
		if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }
		else {
			var io = new IntersectionObserver(function (entries) {
				entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
			}, { threshold: 0.08, rootMargin: '0px 0px -30px 0px' });
			targets.forEach(function (t) { io.observe(t); });
		}
	}

	/* ---------- message popup (auto closes after 4 seconds) ---------- */
	var toast = $('msToast'), toastTimer = null;
	function hideToast() {
		toast.classList.remove('show'); clearTimeout(toastTimer);
		try {
			var u = new URL(window.location.href); u.searchParams.delete('success'); u.searchParams.delete('error');
			window.history.replaceState({}, '', u.pathname + (u.search || '') + u.hash);
		} catch (e) {}
	}
	window.msToast = function (type, text) {
		toast.className = 'ms-toast ' + (type === 'err' ? 'err' : 'ok');
		toast.querySelector('b').textContent = type === 'err' ? 'Something went wrong' : 'Done';
		toast.querySelector('.m').textContent = text;
		toast.querySelector('.ti').innerHTML = type === 'err'
			? '<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>'
			: '<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg>';
		var bar = toast.querySelector('.bar'); bar.style.animation = 'none'; void bar.offsetWidth; bar.style.animation = '';
		void toast.offsetWidth; toast.classList.add('show');
		clearTimeout(toastTimer); toastTimer = setTimeout(hideToast, 4000);
	};
	$('msToastClose').addEventListener('click', hideToast);
	if (toast.classList.contains('show')) toastTimer = setTimeout(hideToast, 4000);

	/* ---------- confirm before removing ---------- */
	var modal = $('msModal'), pending = null;
	function closeModal() { modal.classList.remove('show'); document.documentElement.classList.remove('dpa-lock'); pending = null; }
	document.querySelectorAll('a.rm').forEach(function (a) {
		a.removeAttribute('onclick');   /* the styled popup below replaces the browser's confirm box */
		a.addEventListener('click', function (e) {
			e.preventDefault();
			pending = a;
			$('msModalText').textContent = a.getAttribute('data-name') || '';
			modal.classList.add('show'); document.documentElement.classList.add('dpa-lock');
			$('msCancel').focus();
		});
	});
	$('msCancel').addEventListener('click', closeModal);
	modal.addEventListener('click', function (e) { if (e.target === modal) closeModal(); });
	document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeModal(); });
	$('msConfirm').addEventListener('click', function () {
		if (!pending) return;
		var link = pending, row = link.closest('tr');
		$('msConfirm').disabled = true; $('msConfirm').textContent = 'Removing\u2026';
		if (row && !reduce) row.classList.add('gone');
		if (window.msOnRemove) { window.msOnRemove(link, row); closeModal(); $('msConfirm').disabled = false; $('msConfirm').textContent = 'Remove'; return; }
		setTimeout(function () { window.location.href = link.href; }, reduce ? 0 : 280);
	});

	/* ---------- assign: feedback + no double submit ---------- */
	var form = $('assignForm'), btn = $('assignBtn'), sending = false;
	form.addEventListener('submit', function (e) {
		if (sending) { e.preventDefault(); return; }
		if (!form.checkValidity()) return;
		sending = true;
		btn.classList.add('loading');
		btn.innerHTML = '<i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg></i> <span>Assigning\u2026</span>';
	});
	window.addEventListener('pageshow', function (e) { if (e.persisted) location.reload(); });
})();
</script>

</body>
</html>
