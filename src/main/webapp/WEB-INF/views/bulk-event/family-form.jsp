<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.digitalpurohit.model.Customer" %>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer" %>
<%@ page import="jakarta.servlet.ServletException" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%!
  /* safe text inside an HTML attribute / textarea ("" when null) */
  static String h(Object o){
    if (o == null) return "";
    return String.valueOf(o).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
  }
%>
<%
BulkEventCustomer family = (BulkEventCustomer) request.getAttribute("family");

boolean editMode = (family != null);


Object bulkEventIdObj = request.getAttribute("bulkEventId");

Integer bulkEventId = null;

if (bulkEventIdObj != null) {
    if (bulkEventIdObj instanceof Integer) {
        bulkEventId = (Integer) bulkEventIdObj;
    } else if (bulkEventIdObj instanceof String) {
        String idValue = ((String) bulkEventIdObj).trim();

        if (!idValue.isEmpty()) {
            try {
                bulkEventId = Integer.valueOf(idValue);
            } catch (NumberFormatException e) {
                throw new ServletException(
                    "Invalid bulkEventId: " + idValue, e
                );
            }
        }
    }
}

List<Customer> customers = (List<Customer>) request.getAttribute("customers");

String bid = bulkEventId == null ? "" : String.valueOf(bulkEventId);
String pageTitle = editMode ? "Edit Family" : "Add New Family";
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= editMode ? "Edit Family" : "Add Family" %> | Digital Purohit Assistant</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Anton&family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap" rel="stylesheet">
<style>
  /* Notification popup layout and shared page styles. */
  html, body{ margin:0; }
  body{ font-family:'Inter', system-ui, sans-serif; }
  i svg{ width:1em; height:1em; fill:none; stroke:currentColor; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
  .notification-overlay{ display:none; position:fixed; inset:0; z-index:2000; align-items:center; justify-content:center; padding:20px; }
  .notification-overlay.show{ display:flex; }
  .notification-popup{ width:100%; max-width:520px; max-height:86vh; display:flex; flex-direction:column; overflow:hidden; }
  .notification-popup-header{ display:flex; align-items:center; justify-content:space-between; gap:12px; flex-wrap:wrap; padding:18px 20px; }
  .notification-header-left{ display:flex; align-items:center; gap:12px; }
  .notification-header-icon{ width:40px; height:40px; display:flex; align-items:center; justify-content:center; }
  .notification-popup-header h2{ margin:0; font-size:18px; }
  .notification-popup-header p{ margin:2px 0 0; font-size:12px; }
  .notification-actions{ display:flex; gap:8px; }
  .notification-actions button{ padding:7px 11px; font-size:12px; display:inline-flex; align-items:center; gap:6px; }
  #notificationContainer{ padding:14px 20px; overflow:auto; flex:1; display:grid; gap:10px; }
  .notification-footer{ display:flex; align-items:center; justify-content:space-between; padding:14px 20px; font-size:13px; }
  .notification-footer a{ text-decoration:none; display:inline-flex; gap:6px; align-items:center; }
  .global-toast{ display:none; }
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
<style>
/* =====================================================================
   BULK EVENT FAMILY FORM — same design system as the dashboard / Events / sidebar
   Colours come from the shared theme variables (--dpa-*) defined in the
   sidebar block below, so the dark / light switch restyles this page too.
   Sizes are in em, so the page scales up on large monitors.
   ===================================================================== */

/* ---------- page frame (sits to the right of the sidebar) ---------- */
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

@media (min-width:1700px){ .dpa-dash{ --dk:1.14; } }
@media (min-width:2400px){ .dpa-dash{ --dk:1.4; } }
@media (min-width:3200px){ .dpa-dash{ --dk:1.78; } }

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


.dpa-dash{ --good:#34d399; --pend:#f0a43a; --bad2:#ff6b6b; }
:root[data-theme="light"] .dpa-dash{ --good:#168a4a; --pend:#b45f06; --bad2:#c93434; }
@keyframes dpaSpin{ to{ transform:rotate(360deg); } }
@keyframes dpaShake{ 0%,100%{ transform:translateX(0); } 20%,60%{ transform:translateX(-6px); } 40%,80%{ transform:translateX(6px); } }
@keyframes dpaAlert{ from{ opacity:0; transform:translateY(-6px); } to{ opacity:1; transform:none; } }
@keyframes dpaSwap{ from{ opacity:0; transform:translateY(8px); } to{ opacity:1; transform:none; } }
@keyframes dpaPop{ 0%{ transform:scale(.92); } 60%{ transform:scale(1.06); } 100%{ transform:scale(1); } }

/* ---------- hero extras ---------- */
.dpa-dash .hero-actions{ display:flex; align-items:center; gap:.8em; flex-wrap:wrap; }
.dpa-dash .hero-btn{
	display:inline-flex; align-items:center; gap:.55em; padding:.8em 1.15em; border-radius:1em;
	border:1px solid rgba(255,255,255,.16); background:rgba(255,255,255,.07);
	-webkit-backdrop-filter:blur(10px); backdrop-filter:blur(10px);
	color:#fff; font-size:.95em; font-weight:600;
	transition:background-color .2s, border-color .2s, transform .25s cubic-bezier(.2,.8,.2,1);
}
.dpa-dash .hero-btn i{ display:inline-flex; transition:transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .mode-pill{
	display:inline-flex; align-items:center; padding:.35em .95em; border-radius:999px;
	font-size:.76em; font-weight:700; letter-spacing:.08em; text-transform:uppercase;
	background:rgba(31,191,106,.2); color:#4ee0a8; border:1px solid rgba(31,191,106,.5);
}
.dpa-dash .mode-pill.edit{ background:rgba(240,164,58,.2); color:#f5b85c; border-color:rgba(240,164,58,.5); }

/* ---------- layout + cards ---------- */
.dpa-dash .form-grid{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:1.1em; margin:0; align-items:start; }
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
.dpa-dash .section-top h2{ display:flex; align-items:center; gap:.65em; font-size:1.15em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .section-top h2 i{
	width:2.3em; height:2.3em; font-size:.85em; border-radius:.7em;
	display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile);
}
.dpa-dash .tag{
	padding:.3em .85em; border-radius:999px; font-size:.78em; font-weight:700; letter-spacing:.04em;
	border:1px solid var(--dpa-border); color:var(--dpa-muted);
}
.dpa-dash .card-body{ display:grid; gap:1.2em; padding:1.3em 1.5em 1.5em; }

/* Amounts must change by typing, not by mouse-wheel scrolling. */
.dpa-dash input[type="number"]{
    -moz-appearance:textfield;
    appearance:textfield;
}
.dpa-dash input[type="number"]::-webkit-inner-spin-button,
.dpa-dash input[type="number"]::-webkit-outer-spin-button{
    -webkit-appearance:none;
    margin:0;
}

/* ---------- fields ---------- */
.dpa-dash .field{ display:grid; gap:.55em; min-width:0; }
.dpa-dash .field-head{ display:flex; align-items:center; justify-content:space-between; gap:1em; }
.dpa-dash .field label.lbl{ font-size:.82em; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--dpa-muted); }
.dpa-dash .field label.lbl em{ font-style:normal; color:var(--bad2); margin-left:.25em; }
.dpa-dash .field .opt{ font-size:.74em; font-weight:600; color:var(--dpa-muted); opacity:.8; }
.dpa-dash .input-wrap{
	position:relative; display:flex; align-items:flex-start; gap:.8em; padding:0 1em;
	border-radius:.85em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:border-color .2s, box-shadow .2s, background-color .35s;
}
.dpa-dash .input-wrap > i{ margin-top:1.05em; flex-shrink:0; color:var(--dpa-muted); transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .input-wrap.center > i{ margin-top:0; align-self:center; }
.dpa-dash .input-wrap:focus-within{ border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.22); }
.dpa-dash .input-wrap:focus-within > i{ color:var(--dpa-link); transform:scale(1.15); }
.dpa-dash .input-wrap input, .dpa-dash .input-wrap textarea, .dpa-dash .input-wrap select{
	flex:1; min-width:0; width:100%; margin:0; padding:.95em 0; border:0; outline:0; box-shadow:none; background:transparent; resize:vertical;
	font-family:inherit; font-size:1em; font-weight:500; line-height:1.5; color:var(--dpa-text); color-scheme:inherit;
}
.dpa-dash .input-wrap select{ -webkit-appearance:none; appearance:none; cursor:pointer; padding-right:1.8em; }

/* Keep the native customer dropdown readable in both themes.
   Native option menus may ignore inherited colors, so set them explicitly. */
.dpa-dash .input-wrap select option,
.dpa-dash .input-wrap select optgroup {
    background-color: #161b26;
    color: #f5f5f5;
}

:root[data-theme="dark"] .dpa-dash .input-wrap select,
:root[data-theme="dark"] .dpa-dash .input-wrap select option,
:root[data-theme="dark"] .dpa-dash .input-wrap select optgroup {
    color-scheme: dark;
    background-color: #161b26;
    color: #f5f5f5;
}

:root[data-theme="light"] .dpa-dash .input-wrap select option,
:root[data-theme="light"] .dpa-dash .input-wrap select optgroup {
    color-scheme: light;
    background-color: #ffffff;
    color: #1b1b1b;
}
.dpa-dash .input-wrap .chev{ position:absolute; right:1em; top:50%; translate:0 -50%; pointer-events:none; color:var(--dpa-muted); }
.dpa-dash #newCustomerSection{ display:grid; gap:1.2em; }
.dpa-dash .input-wrap textarea{ min-height:7em; }
.dpa-dash .input-wrap input::placeholder, .dpa-dash .input-wrap textarea::placeholder{ color:var(--dpa-muted); opacity:.8; font-weight:400; }
.dpa-dash .input-wrap.invalid{ border-color:var(--bad2); box-shadow:0 0 0 4px rgba(255,107,107,.16); animation:dpaShake .4s; }
.dpa-dash .field-error{ display:none; align-items:center; gap:.5em; font-size:.85em; font-weight:600; color:var(--bad2); animation:dpaAlert .3s both; }
.dpa-dash .field-error.show{ display:flex; }
.dpa-dash .field-note{ display:none; align-items:center; gap:.5em; font-size:.85em; font-weight:600; color:var(--pend); animation:dpaAlert .3s both; }
.dpa-dash .field-note.show{ display:flex; }

/* customer type switch */
.dpa-dash .seg{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:.4em; padding:.35em; border-radius:.95em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2); }
.dpa-dash .seg label{
	position:relative; display:flex; align-items:center; justify-content:center; gap:.55em; padding:.75em .8em; border-radius:.7em;
	font-size:.93em; font-weight:700; color:var(--dpa-muted); cursor:pointer; user-select:none;
	transition:background-color .25s, color .25s, transform .2s;
}
.dpa-dash .seg input{ position:absolute; opacity:0; width:1px; height:1px; pointer-events:none; }
.dpa-dash .seg label:has(input:checked){ background:var(--dpa-active-bg); color:var(--dpa-active-text); animation:dpaPop .35s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .seg label:has(input:focus-visible){ outline:2px solid var(--dpa-link); outline-offset:2px; }
.dpa-dash .swap-in{ animation:dpaSwap .4s cubic-bezier(.2,.8,.2,1) both; }

/* selected customer card */
.dpa-dash .picked{
	display:none; gap:.7em; padding:1em 1.1em; border-radius:1em; border:1px dashed rgba(52,211,153,.55); background:rgba(52,211,153,.07);
	animation:dpaSwap .35s cubic-bezier(.2,.8,.2,1) both;
}
.dpa-dash .picked.show{ display:grid; }
.dpa-dash .picked .pn{ display:flex; align-items:center; gap:.6em; font-weight:700; font-size:1.02em; }
.dpa-dash .picked .pn i{ color:var(--good); }
.dpa-dash .picked .pl{ display:flex; align-items:flex-start; gap:.6em; font-size:.9em; color:var(--dpa-muted); font-weight:500; overflow-wrap:anywhere; }
.dpa-dash .picked .pl i{ margin-top:.12em; flex-shrink:0; color:var(--dpa-link); }

/* ---------- payment summary ---------- */
.dpa-dash .pay-summary{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:.8em; }
.dpa-dash .pay-mini{
	--acc:#2b7fff; position:relative; overflow:hidden; padding:1em 1.1em; border-radius:1em;
	border:1px solid var(--dpa-border); background:var(--dpa-surface-2);
}
.dpa-dash .pay-mini::before{ content:""; position:absolute; left:0; top:0; bottom:0; width:.28em; background:var(--acc); }
.dpa-dash .pay-mini.paid{ --acc:#1fbf6a; } .dpa-dash .pay-mini.rem{ --acc:#ff6b6b; } .dpa-dash .pay-mini.tot{ --acc:#9b7bff; } .dpa-dash .pay-mini.st{ --acc:#f0a43a; }
.dpa-dash .pay-mini span{ display:block; font-size:.7em; font-weight:700; letter-spacing:.09em; text-transform:uppercase; color:var(--dpa-muted); }
.dpa-dash .pay-mini h3{ margin-top:.3em; font-size:1.35em; font-weight:700; letter-spacing:-.02em; font-variant-numeric:tabular-nums; overflow-wrap:anywhere; }
.dpa-dash .pay-mini h3.bump{ animation:dpaPop .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash #statusDisplay{ display:inline-flex; align-items:center; gap:.5em; font-size:1.05em; }
.dpa-dash #statusDisplay::before{ content:""; width:.55em; height:.55em; border-radius:50%; background:currentColor; }
.dpa-dash #statusDisplay.pending{ color:var(--bad2); }
.dpa-dash #statusDisplay.partial{ color:var(--pend); }
.dpa-dash #statusDisplay.paid{ color:var(--good); }
.dpa-dash .pay-bar{ height:.6em; border-radius:999px; background:var(--dpa-tile); overflow:hidden; }
.dpa-dash .pay-bar span{ display:block; height:100%; width:0; border-radius:inherit; background:linear-gradient(90deg, #1fbf6a, #34d399); transition:width .5s cubic-bezier(.2,.8,.2,1); }

/* ---------- actions ---------- */
.dpa-dash .form-actions{ display:flex; align-items:center; justify-content:flex-end; gap:.8em; flex-wrap:wrap; margin:0; }
.dpa-dash .btn-cancel{
	display:inline-flex; align-items:center; justify-content:center; gap:.55em; padding:.95em 1.3em; border-radius:.85em;
	border:1px solid var(--dpa-border); background:var(--dpa-surface-2); color:var(--dpa-text); font-size:1em; font-weight:600;
	transition:background-color .2s, border-color .2s, transform .25s cubic-bezier(.2,.8,.2,1);
}
.dpa-dash .btn-cancel i{ display:inline-flex; transition:transform .35s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .btn-submit{
	display:inline-flex; align-items:center; justify-content:center; gap:.6em; margin:0; padding:.95em 1.6em; border-radius:.85em;
	border:1px solid var(--dpa-twilight); background:var(--dpa-twilight); box-shadow:none;
	font-family:inherit; font-size:1em; font-weight:700; line-height:1.2; color:#fff; cursor:pointer;
	transition:filter .2s, transform .25s cubic-bezier(.2,.8,.2,1), box-shadow .25s;
}
.dpa-dash .btn-submit i{ display:inline-flex; transition:transform .35s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .btn-submit:active{ transform:scale(.97); }
.dpa-dash .btn-submit.loading{ pointer-events:none; opacity:.85; }
.dpa-dash .btn-submit.loading i{ animation:dpaSpin .8s linear infinite; }
.dpa-dash form{ display:grid; gap:1.1em; margin:0; }
.dpa-dash .full{ grid-column:1 / -1; }

/* ---------- hover (mouse only) ---------- */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ background:rgba(255,255,255,.14); border-color:rgba(255,255,255,.35); transform:translateY(-2px); }
	.dpa-dash .hero-btn:hover i{ transform:translateX(-3px); }
	.dpa-dash .input-wrap:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .seg label:not(:has(input:checked)):hover{ background:var(--dpa-hover); color:var(--dpa-text); }
	.dpa-dash .btn-submit:hover{ filter:brightness(1.18); transform:translateY(-2px); box-shadow:0 10px 26px rgba(66,97,136,.45); }
	.dpa-dash .btn-submit:hover i{ transform:rotate(-10deg) scale(1.15); }
	.dpa-dash .btn-cancel:hover{ background:var(--dpa-hover); border-color:var(--bad2); transform:translateY(-2px); }
	.dpa-dash .btn-cancel:hover i{ transform:rotate(90deg); }
}
.dpa-dash a:focus-visible, .dpa-dash button:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* ---------- responsive ---------- */
@media (max-width:1100px){ .dpa-dash .form-grid{ grid-template-columns:minmax(0, 1fr); } }
@media (max-width:700px){
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-actions, .dpa-dash .hero-btn{ width:100%; justify-content:center; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .section-top{ padding:1em 1.1em; }
	.dpa-dash .card-body{ padding:1.1em; }
	.dpa-dash .btn-submit, .dpa-dash .btn-cancel{ flex:1 1 100%; }
}
@media print{
	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1 !important; animation:none !important; }
	.dpa-dash .hero-watermark, .dpa-dash .hero-actions, .dpa-dash .form-actions{ display:none; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
}
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/notification.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/notification-popup.css">
<script src="${pageContext.request.contextPath}/assets/js/notification.js" defer></script>
</head>
<body>

	<!-- theme init (runs immediately; default = dark) -->
<script>
  (function () {
    var t = 'dark';
    try { t = localStorage.getItem('dpa-theme') || 'dark'; } catch (e) {}
    document.documentElement.setAttribute('data-theme', t === 'light' ? 'light' : 'dark');
    /* safety net: without a viewport tag phones render the page zoomed-out and nothing below is responsive */
    if (!document.querySelector('meta[name="viewport"]')) {
      var m = document.createElement('meta');
      m.name = 'viewport'; m.content = 'width=device-width, initial-scale=1, viewport-fit=cover';
      document.head.appendChild(m);
    }
  })();
</script>

<style>
  /* =================================================================
     THEME VARIABLES  — use these in every page's CSS to follow the toggle
     ================================================================= */
  :root{
    --dpa-sidebar-w:260px;
    --dpa-bad:#d64545;
    --dpa-twilight:#426188;
    --dpa-link:#2b7fff;
  }
  :root, :root[data-theme="dark"]{
    --dpa-bg:#050608;
    --dpa-surface:#10141c;
    --dpa-surface-2:#161b26;
    --dpa-text:#f5f5f5;
    --dpa-muted:rgba(255,255,255,.58);
    --dpa-border:rgba(255,255,255,.09);
    --dpa-sb-bg:#080a0f;
    --dpa-hover:rgba(255,255,255,.06);
    --dpa-tile:rgba(255,255,255,.07);
    --dpa-active-bg:#f5f5f5;
    --dpa-active-text:#1b1b1b;
    --dpa-active-tile:rgba(0,0,0,.08);
    --dpa-logo-bg:transparent;
    --dpa-logo-fg:#ffffff;
    --dpa-logo-border:rgba(255,255,255,.6);
    --dpa-glow-a:rgba(66,97,136,.55);
    --dpa-glow-b:rgba(43,127,255,.22);
    --dpa-switch:rgba(255,255,255,.2);
    --dpa-scroll:rgba(255,255,255,.18);
    --dpa-mobile-bar:rgba(8,10,15,.8);
    color-scheme:dark;
  }
  :root[data-theme="light"]{
    --dpa-bg:#f1f4f9;
    --dpa-surface:#ffffff;
    --dpa-surface-2:#f5f5f5;
    --dpa-text:#1b1b1b;
    --dpa-muted:#6b7280;
    --dpa-border:rgba(0,0,0,.09);
    --dpa-sb-bg:#ffffff;
    --dpa-hover:rgba(0,0,0,.045);
    --dpa-tile:rgba(0,0,0,.05);
    --dpa-active-bg:#1b1b1b;
    --dpa-active-text:#ffffff;
    --dpa-active-tile:rgba(255,255,255,.16);
    --dpa-logo-bg:#1b1b1b;
    --dpa-logo-fg:#ffffff;
    --dpa-logo-border:#1b1b1b;
    --dpa-glow-a:rgba(66,97,136,.22);
    --dpa-glow-b:rgba(43,127,255,.12);
    --dpa-switch:#426188;
    --dpa-scroll:rgba(0,0,0,.18);
    --dpa-mobile-bar:rgba(255,255,255,.85);
    color-scheme:light;
  }
  @media (max-width:900px), (max-width:1100px) and (max-height:520px){ :root{ --dpa-sidebar-w:0px; } }

  /* GLOBAL PAGE BASE */
  body{
    background:var(--dpa-bg); color:var(--dpa-text);
    transition:background-color .35s ease, color .35s ease;
  }

  /* smooth fallback when the browser has no View Transitions */
  html.dpa-theme-anim *, html.dpa-theme-anim *::before, html.dpa-theme-anim *::after{
    transition:background-color .35s, color .35s, border-color .35s, fill .35s, stroke .35s !important;
  }
  /* circular reveal when switching theme */
  ::view-transition-old(root), ::view-transition-new(root){ animation:none; mix-blend-mode:normal; }
  ::view-transition-old(root){ z-index:1; }
  ::view-transition-new(root){ z-index:2; }

  /* =================================================================
     SIDEBAR SHELL
     ================================================================= */
  .sidebar{
    position:fixed; top:0; left:0; bottom:0;
    width:var(--dpa-sidebar-w, 260px); min-width:0; max-width:none;
    height:100vh; height:100dvh; margin:0; padding:18px 14px 0;
    display:flex; flex-direction:column; overflow:hidden; z-index:1000;
    background:var(--dpa-sb-bg); color:var(--dpa-text);
    border:0; border-right:1px solid var(--dpa-border); box-shadow:none;
    font-family:'Inter', ui-sans-serif, system-ui, sans-serif; font-weight:500; font-size:14px; line-height:1.4;
    -webkit-font-smoothing:antialiased; box-sizing:border-box;
    transition:background-color .35s ease, border-color .35s ease, transform .38s cubic-bezier(.2,.8,.2,1);
  }
  .sidebar *{ box-sizing:border-box; }
  .sidebar::before, .sidebar::after{
    content:""; position:absolute; border-radius:50%; filter:blur(46px); pointer-events:none; z-index:0;
  }
  .sidebar::before{
    width:280px; height:280px; top:-120px; left:-100px;
    background:radial-gradient(circle, var(--dpa-glow-a), transparent 70%);
    animation:dpaFloat 14s ease-in-out infinite;
  }
  .sidebar::after{
    width:260px; height:260px; bottom:-110px; right:-110px;
    background:radial-gradient(circle, var(--dpa-glow-b), transparent 70%);
    animation:dpaFloat 17s ease-in-out infinite reverse;
  }
  .sidebar > *{ position:relative; z-index:1; }
  @keyframes dpaFloat{ 0%,100%{ transform:translate(0,0) scale(1); } 50%{ transform:translate(14px,20px) scale(1.08); } }

  /* ---------- header ---------- */
  .sidebar .sidebar-header{
    display:flex; align-items:center; gap:12px; padding:6px 8px 18px; margin:0 0 6px;
    border-bottom:1px solid var(--dpa-border);
    animation:dpaFade .6s ease both;
  }
  .sidebar .sidebar-logo{
    width:44px; height:44px; flex-shrink:0; border-radius:12px;
    display:flex; align-items:center; justify-content:center; font-size:19px;
    background:var(--dpa-logo-bg); color:var(--dpa-logo-fg); border:1px solid var(--dpa-logo-border);
    animation:dpaLogoPulse 3.4s ease-in-out infinite;
  }
  @keyframes dpaLogoPulse{
    0%{ box-shadow:0 0 0 0 rgba(66,97,136,.55); }
    70%,100%{ box-shadow:0 0 0 12px rgba(66,97,136,0); }
  }
  .sidebar .sidebar-title-container{ min-width:0; }
  .sidebar .sidebar-title-main{
    font-size:16px; font-weight:700; letter-spacing:-.01em; line-height:1.15; color:var(--dpa-text);
    white-space:nowrap;
  }
  .sidebar .sidebar-subtitle{
    font-family:'Caveat', cursive; font-style:italic; font-weight:600; font-size:21px; line-height:1;
    color:var(--dpa-twilight); margin-top:2px;
  }

  /* ---------- scrolling nav ---------- */
  .sidebar .sidebar-nav{
    flex:1; min-height:0; overflow-y:auto; overflow-x:hidden; padding:0 2px 12px; margin:0 -4px 0 -2px;
    scrollbar-width:thin; scrollbar-color:var(--dpa-scroll) transparent;
  }
  .sidebar .sidebar-nav::-webkit-scrollbar{ width:6px; }
  .sidebar .sidebar-nav::-webkit-scrollbar-thumb{ background:var(--dpa-scroll); border-radius:6px; }

  .sidebar .menu-title{
    display:flex; align-items:center; gap:10px; margin:0; padding:20px 10px 8px;
    font-size:11px; font-weight:600; letter-spacing:.16em; text-transform:uppercase; color:var(--dpa-muted);
    opacity:0; animation:dpaFade .5s ease forwards; animation-delay:calc(var(--i, 0) * 45ms + 120ms);
  }
  .sidebar .menu-title::after{ content:""; flex:1; height:1px; background:var(--dpa-border); }

  /* ---------- links ---------- */
  .sidebar .sidebar-nav a{
    position:relative; display:flex; align-items:center; gap:12px;
    width:auto; height:auto; margin:2px 0; padding:8px 10px; border:0; box-shadow:none;
    border-radius:11px; background:transparent; color:var(--dpa-muted);
    font-size:14px; font-weight:500; letter-spacing:0; text-transform:none; text-decoration:none;
    opacity:0; translate:-14px 0;
    animation:dpaNavIn .55s cubic-bezier(.2,.8,.2,1) forwards;
    animation-delay:calc(var(--i, 0) * 45ms + 120ms);
    transition:background-color .2s ease, color .2s ease, transform .22s ease;
  }
  @keyframes dpaNavIn{ to{ opacity:1; translate:0 0; } }
  @keyframes dpaFade{ from{ opacity:0; } to{ opacity:1; } }

  .sidebar .sidebar-nav a i{
    width:34px; height:34px; flex-shrink:0; margin:0; border-radius:9px;
    display:inline-flex; align-items:center; justify-content:center;
    font-size:14px; color:inherit; background:var(--dpa-tile);
    transition:background-color .2s ease, color .2s ease, transform .3s cubic-bezier(.34,1.56,.64,1);
  }
  .sidebar .sidebar-nav a span:not(.menu-badge){ flex:1; min-width:0; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }

  @media (hover:hover) and (pointer:fine){
    .sidebar .sidebar-nav a:hover{
      background:var(--dpa-hover); color:var(--dpa-text); transform:translateX(4px);
    }
    .sidebar .sidebar-nav a:hover i{
      background:var(--dpa-twilight); color:#fff; transform:rotate(-8deg) scale(1.1);
    }
    .sidebar .sidebar-nav a.logout-link:hover{ background:rgba(214,69,69,.12); color:#ff6b6b; }
    .sidebar .sidebar-nav a.logout-link:hover i{ background:var(--dpa-bad); color:#fff; }
  }
  /* touch feedback */
  .sidebar .sidebar-nav a:active{ background:var(--dpa-hover); transform:scale(.98); }

  .sidebar .sidebar-nav a.active{
    background:var(--dpa-active-bg); color:var(--dpa-active-text); font-weight:600;
  }
  .sidebar .sidebar-nav a.active i{ background:var(--dpa-active-tile); color:var(--dpa-active-text); }
  .sidebar .sidebar-nav a.active::before{
    content:""; position:absolute; left:-12px; top:22%; bottom:22%; width:4px; border-radius:0 4px 4px 0;
    background:var(--dpa-twilight);
  }

  .sidebar .notif-link:hover i{ animation:dpaBell .8s ease; }
  @keyframes dpaBell{
    0%,100%{ transform:rotate(0) scale(1.1); } 20%{ transform:rotate(-18deg) scale(1.1); }
    40%{ transform:rotate(14deg) scale(1.1); } 60%{ transform:rotate(-9deg) scale(1.1); } 80%{ transform:rotate(5deg) scale(1.1); }
  }

  /* ---------- notification badge ---------- */
  .sidebar .menu-badge{
    margin-left:auto; flex:0 0 auto !important;
    min-width:22px; height:22px; padding:0 7px; border-radius:999px;
    display:inline-flex; align-items:center; justify-content:center;
    background:var(--dpa-bad); color:#fff; font-size:11px; font-weight:700; line-height:1;
    animation:dpaBadge 2.2s ease-out infinite;
  }
  .sidebar .menu-badge:empty, .sidebar .menu-badge.is-zero{ display:none; }
  @keyframes dpaBadge{
    0%{ box-shadow:0 0 0 0 rgba(214,69,69,.6); }
    70%,100%{ box-shadow:0 0 0 9px rgba(214,69,69,0); }
  }

  /* ---------- footer: theme toggle ---------- */
  .sidebar .sidebar-footer{ padding:12px 0 calc(16px + env(safe-area-inset-bottom, 0px)); border-top:1px solid var(--dpa-border); animation:dpaFade .6s .5s ease both; }
  .dpa-theme-toggle{
    width:100%; display:flex; align-items:center; justify-content:space-between; gap:10px;
    padding:10px 12px; background:var(--dpa-tile); color:var(--dpa-text);
    border:1px solid var(--dpa-border); border-radius:11px; cursor:pointer;
    font-family:inherit; font-size:13px; font-weight:600;
    transition:background-color .2s, transform .12s, border-color .2s;
  }
  .dpa-theme-toggle:hover{ background:var(--dpa-hover); border-color:var(--dpa-twilight); }
  .dpa-theme-toggle:active{ transform:scale(.98); }
  .dpa-theme-toggle:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }
  .dpa-tt-label{ display:flex; align-items:center; gap:10px; }
  .dpa-tt-icons{ position:relative; width:18px; height:18px; display:inline-block; }
  .dpa-tt-icons i{
    position:absolute; inset:0; display:flex; align-items:center; justify-content:center; font-size:15px;
    transition:transform .5s cubic-bezier(.34,1.56,.64,1), opacity .3s;
  }
  :root[data-theme="dark"]  .dpa-tt-sun{ opacity:0; transform:rotate(-90deg) scale(.3); }
  :root[data-theme="dark"]  .dpa-tt-moon{ opacity:1; transform:none; color:#c7d6ee; }
  :root[data-theme="light"] .dpa-tt-moon{ opacity:0; transform:rotate(90deg) scale(.3); }
  :root[data-theme="light"] .dpa-tt-sun{ opacity:1; transform:none; color:#e0a100; }
  .dpa-tt-switch{
    width:40px; height:22px; border-radius:999px; position:relative; flex-shrink:0;
    background:var(--dpa-switch); transition:background-color .3s;
  }
  .dpa-tt-knob{
    position:absolute; top:3px; left:3px; width:16px; height:16px; border-radius:50%; background:#fff;
    transition:transform .4s cubic-bezier(.34,1.56,.64,1);
  }
  :root[data-theme="light"] .dpa-tt-knob{ transform:translateX(18px); }

  /* hidden duplicate of the notifications link */
  .dpa-dup-link{ display:none !important; }

  /* =================================================================
     MOBILE: drawer + top bar
     ================================================================= */
  .dpa-mobile-bar{
    display:none; position:fixed; top:0; left:0; right:0; z-index:998;
    height:calc(56px + env(safe-area-inset-top, 0px));
    padding:env(safe-area-inset-top, 0px) 14px 0 calc(14px + env(safe-area-inset-left, 0px));
    align-items:center; gap:12px;
    background:var(--dpa-mobile-bar); -webkit-backdrop-filter:blur(12px); backdrop-filter:blur(12px);
    border-bottom:1px solid var(--dpa-border); color:var(--dpa-text);
    font-family:'Inter', system-ui, sans-serif;
  }
  .dpa-menu-btn{
    width:44px; height:44px; flex-shrink:0; border-radius:11px; border:1px solid var(--dpa-border);
    background:var(--dpa-tile); color:var(--dpa-text); cursor:pointer; font-size:17px;
    display:flex; align-items:center; justify-content:center; transition:transform .12s;
  }
  .dpa-menu-btn:active{ transform:scale(.94); }
  .dpa-menu-btn:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }
  .dpa-mobile-title{ min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; font-weight:700; font-size:15px; letter-spacing:-.01em; }
  .dpa-mobile-title em{ font-family:'Caveat', cursive; font-style:italic; font-weight:600; font-size:20px; color:var(--dpa-twilight); }
  .dpa-backdrop{
    position:fixed; inset:0; z-index:999; background:rgba(0,0,0,.55);
    -webkit-backdrop-filter:blur(3px); backdrop-filter:blur(3px);
    opacity:0; pointer-events:none; transition:opacity .3s;
  }
  .dpa-backdrop.show{ opacity:1; pointer-events:auto; }
  html.dpa-lock, html.dpa-lock body{ overflow:hidden; }

  @media (max-width:900px), (max-width:1100px) and (max-height:520px){
    .dpa-mobile-bar{ display:flex; }
    .sidebar{
      width:min(300px, 86vw); transform:translateX(-104%); visibility:hidden;
      padding-top:calc(18px + env(safe-area-inset-top, 0px));
      padding-left:calc(14px + env(safe-area-inset-left, 0px));
      transition:transform .38s cubic-bezier(.2,.8,.2,1), visibility 0s linear .38s, background-color .35s ease, border-color .35s ease;
    }
    .sidebar.open{
      transform:none; visibility:visible; box-shadow:0 0 70px rgba(0,0,0,.55);
      transition:transform .38s cubic-bezier(.2,.8,.2,1), visibility 0s, background-color .35s ease, border-color .35s ease;
    }
    body{ padding-top:calc(56px + env(safe-area-inset-top, 0px)); }   /* room for the top bar */
  }

  /* =================================================================
     SHORT SCREENS: tighter spacing
     ================================================================= */
  @media (max-height:820px){
    .sidebar .menu-title{ padding:14px 10px 6px; }
    .sidebar .sidebar-nav a{ padding:6px 10px; margin:1px 0; }
    .sidebar .sidebar-header{ padding-bottom:14px; }
  }
  @media (max-height:740px){
    .sidebar{ padding-top:12px; }
    .sidebar .sidebar-header{ padding:2px 6px 12px; }
    .sidebar .sidebar-logo{ width:38px; height:38px; font-size:16px; border-radius:10px; }
    .sidebar .sidebar-title-main{ font-size:15px; }
    .sidebar .sidebar-subtitle{ font-size:19px; }
    .sidebar .menu-title{ padding:12px 10px 6px; }
    .sidebar .sidebar-nav a{ padding:5px 10px; margin:1px 0; }
    .sidebar .sidebar-nav a i{ width:30px; height:30px; font-size:13px; }
    .sidebar .sidebar-footer{ padding-top:8px; padding-bottom:calc(10px + env(safe-area-inset-bottom, 0px)); }
    .dpa-theme-toggle{ padding:7px 12px; }
  }

  /* =================================================================
     LARGE MONITORS
     ================================================================= */
  @media (min-width:1700px){
    :root{ --dpa-sidebar-w:296px; }
    .sidebar{ padding:22px 16px 0; font-size:15px; }
    .sidebar .sidebar-logo{ width:50px; height:50px; font-size:22px; }
    .sidebar .sidebar-title-main{ font-size:18px; }
    .sidebar .sidebar-subtitle{ font-size:24px; }
    .sidebar .menu-title{ font-size:12px; }
    .sidebar .sidebar-nav a{ font-size:15.5px; padding:9px 12px; gap:14px; }
    .sidebar .sidebar-nav a i{ width:38px; height:38px; font-size:16px; }
    .sidebar .menu-badge{ min-width:24px; height:24px; font-size:12px; }
    .dpa-theme-toggle{ font-size:14px; padding:12px 14px; }
  }
  @media (min-width:2400px){
    :root{ --dpa-sidebar-w:360px; }
    .sidebar{ padding:28px 20px 0; font-size:18px; }
    .sidebar .sidebar-logo{ width:62px; height:62px; font-size:27px; border-radius:15px; }
    .sidebar .sidebar-title-main{ font-size:22px; }
    .sidebar .sidebar-subtitle{ font-size:30px; }
    .sidebar .menu-title{ font-size:14px; padding:26px 12px 10px; }
    .sidebar .sidebar-nav a{ font-size:19px; padding:11px 14px; gap:16px; margin:3px 0; border-radius:14px; }
    .sidebar .sidebar-nav a i{ width:46px; height:46px; font-size:19px; border-radius:12px; }
    .sidebar .menu-badge{ min-width:28px; height:28px; font-size:14px; }
    .dpa-theme-toggle{ font-size:17px; padding:15px 17px; border-radius:14px; }
    .dpa-tt-switch{ width:50px; height:27px; }
    .dpa-tt-knob{ width:21px; height:21px; top:3px; left:3px; }
    :root[data-theme="light"] .dpa-tt-knob{ transform:translateX(23px); }
  }
  @media (min-width:3200px){
    :root{ --dpa-sidebar-w:460px; }
    .sidebar{ padding:36px 26px 0; font-size:23px; }
    .sidebar .sidebar-logo{ width:80px; height:80px; font-size:35px; border-radius:19px; }
    .sidebar .sidebar-title-main{ font-size:28px; }
    .sidebar .sidebar-subtitle{ font-size:38px; }
    .sidebar .menu-title{ font-size:17px; padding:34px 14px 12px; }
    .sidebar .sidebar-nav a{ font-size:24px; padding:14px 18px; gap:20px; margin:4px 0; border-radius:17px; }
    .sidebar .sidebar-nav a i{ width:58px; height:58px; font-size:24px; border-radius:15px; }
    .sidebar .menu-badge{ min-width:34px; height:34px; font-size:17px; }
    .dpa-theme-toggle{ font-size:21px; padding:19px 22px; border-radius:17px; }
    .dpa-tt-icons{ width:24px; height:24px; }
    .dpa-tt-icons i{ font-size:20px; }
    .dpa-tt-switch{ width:64px; height:34px; }
    .dpa-tt-knob{ width:28px; height:28px; top:3px; left:3px; }
    :root[data-theme="light"] .dpa-tt-knob{ transform:translateX(30px); }
  }

  /* print: no sidebar, no gap */
  @media print{
    .sidebar, .dpa-mobile-bar, .dpa-backdrop{ display:none !important; }
    :root{ --dpa-sidebar-w:0px; }
    body{ padding-top:0 !important; }
  }

  /* =================================================================
     NOTIFICATION POPUP — theme
     ================================================================= */
  .notification-overlay{ -webkit-backdrop-filter:blur(6px); backdrop-filter:blur(6px); background:rgba(0,0,0,.55); }
  .notification-popup{
    background:#f5f5f5; color:#1b1b1b; border:1px solid rgba(0,0,0,.08); border-radius:14px;
    box-shadow:0 30px 80px rgba(0,0,0,.5); font-family:'Inter', system-ui, sans-serif;
    animation:dpaPopIn .38s cubic-bezier(.2,.8,.2,1) both;
  }
  @keyframes dpaPopIn{ from{ opacity:0; transform:translateY(18px) scale(.97); } to{ opacity:1; transform:none; } }
  .notification-popup-header{ background:#ffffff; border-bottom:1px solid rgba(0,0,0,.08); }
  .notification-popup-header h2{ color:#1b1b1b; font-weight:700; letter-spacing:-.01em; }
  .notification-popup-header p{ color:#6b7280; }
  .notification-header-icon{ background:#1b1b1b; color:#fff; border-radius:11px; }
  .notification-actions button{
    background:transparent; color:#1b1b1b; border:1px solid #1b1b1b; border-radius:8px;
    font-family:inherit; font-weight:600; cursor:pointer; transition:background-color .2s, color .2s, transform .12s;
  }
  .notification-actions button:hover{ background:#1b1b1b; color:#fff; }
  .notification-actions button:active{ transform:scale(.96); }
  .notification-footer{ background:#ffffff; border-top:1px solid rgba(0,0,0,.08); color:#444; }
  .notification-footer .view-all-link{ color:var(--dpa-link); font-weight:600; }

  @media (max-width:600px){
    .notification-overlay{ padding:12px; }
    .notification-popup{ width:100%; max-width:100%; max-height:calc(100vh - 24px); max-height:calc(100dvh - 24px); }
    .notification-popup-header{ flex-wrap:wrap; gap:10px; }
    .notification-actions{ flex-wrap:wrap; }
    .notification-footer{ flex-wrap:wrap; gap:8px; }
  }

  /* =================================================================
     REDUCED MOTION
     ================================================================= */
  @media (prefers-reduced-motion: reduce){
    .sidebar::before, .sidebar::after, .sidebar .sidebar-logo, .sidebar .menu-badge,
    .notification-popup{ animation:none !important; }
    .sidebar .sidebar-nav a, .sidebar .menu-title, .sidebar .sidebar-header, .sidebar .sidebar-footer{
      animation:none !important; opacity:1 !important; translate:0 0 !important;
    }
  }
</style>



<!-- Shared sidebar: keep navigation markup in one place -->
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="dpa-dup-link">
<a href="javascript:void(0);" onclick="openNotifications();">

    <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg></i>

    <span>Notifications</span>

   <span class="menu-badge"><c:out value="${empty unreadCount ? 0 : unreadCount}"/></span>
</a>
</div>

<!-- ================= Notification Overlay ================= -->

<div id="notificationOverlay" class="notification-overlay">

    <div class="notification-popup">

        <!-- Header -->

        <div class="notification-popup-header">

            <div class="notification-header-left">

                <div class="notification-header-icon">

                    <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg></i>

                </div>

                <div>

                    <h2>Notifications</h2>

                    <p>Stay updated with recent activities</p>

                </div>

            </div>

            <div class="notification-actions">

                <button id="markAllRead">

                    <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 7 17l-5-5"/><path d="m22 10-7.5 7.5L13 16"/></svg></i>

                    Mark All Read

                </button>

                <button id="deleteAllBtn">

                    <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg></i>

                    Delete All

                </button>

                <button id="closeNotification">

                    <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i>

                </button>

            </div>

        </div>

        <!-- Notification Body -->

        <div id="notificationContainer">

        </div>

        <!-- Footer -->

        <div class="notification-footer">

            <div class="notification-total">

                <i><svg viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="3" rx="2"/><path d="m9 12 2 2 4-4"/></svg></i>

                Total Notifications :

                <strong id="totalNotifications">

                    0

                </strong>

            </div>

            <a href="javascript:void(0);" class="view-all-link">

                View All Notifications

                <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></i>

            </a>

        </div>

    </div>

</div>

<!-- ===========================================
     GLOBAL TOAST
=========================================== -->

<div id="globalToast"
     class="global-toast ">

    <div class="toast-left">

        <i id="toastIcon"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i>

    </div>

    <div class="toast-body">

        <div id="toastTitle"
             class="toast-title">

            

        </div>

        <div id="toastMessage"
             class="toast-message">

            

        </div>

    </div>

    <button id="toastClose">

        <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i>

    </button>

</div>

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>

<div class="main-content">

  <div class="family-form-page dpa-dash">

    <!-- ================= PAGE HEADER ================= -->
    <div class="page-header">

        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>

        <div class="hero-left">

            <div class="hero-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i></div>

            <div>
                <h1><%= pageTitle %></h1>
                <p>Manage families participating in this Bulk Event.</p>
            </div>

        </div>

        <div class="hero-actions">
            <span class="mode-pill<%= editMode ? " edit" : "" %>"><%= editMode ? "Edit mode" : "New family" %></span>
            <a class="hero-btn" href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%= bid %>">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m12 19-7-7 7-7"/><path d="M19 12H5"/></svg></i>
                Back
            </a>
        </div>

    </div>

    <form id="familyForm" action="${pageContext.request.contextPath}/<%= editMode ? "edit-bulk-family" : "add-bulk-family" %>" method="post" novalidate>
<% if (editMode) { %>
        <input type="hidden" name="id" value="<%= family.getId() %>">
<% } %>
        <input type="hidden" name="bulkEventId" value="<%= bid %>">

        <div class="form-grid">

            <!-- ================= CUSTOMER CARD ================= -->
            <div class="section-card reveal">

                <div class="section-top">
                    <h2><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i> Customer Information</h2>
                    <span class="tag"><%= editMode ? "Editing" : "Existing or new" %></span>
                </div>

                <div class="card-body">

<% if (editMode) { %>
<%-- EDIT_START --%>
                    <input type="hidden" name="customerId" value="<%= family.getCustomerId() %>">
<%-- EDIT_END --%>
<% } else { %>
<%-- ADD_START --%>
                    <div class="field">
                        <div class="field-head"><label class="lbl">Customer Type</label></div>
                        <div class="seg">
                            <label>
                                <input type="radio" name="customerType" value="existing" checked>
                                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i> Existing Customer
                            </label>
                            <label>
                                <input type="radio" name="customerType" value="new">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" x2="19" y1="8" y2="14"/><line x1="22" x2="16" y1="11" y2="11"/></svg></i> New Customer
                            </label>
                        </div>
                    </div>

                    <div id="existingCustomerSection" class="field">
                        <div class="field-head"><label class="lbl" for="customerId">Select Existing Customer</label></div>
                        <div class="input-wrap center" id="custWrap">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i>
                            <select id="customerId" name="customerId">
                                <option value="">-- Select Customer --</option>
<%-- OPT_START --%>
<%
if (customers != null && !customers.isEmpty()) {
    for (Customer c : customers) {
        if (c == null) continue;
%>
                                <option value="<%= c.getCustomerId() %>"
                                        data-name="<%= h(c.getCustomerName()) %>"
                                        data-phone="<%= h(c.getPhone()) %>"
                                        data-address="<%= h(c.getAddress()) %>"
                                        data-gothram="<%= h(c.getGothram()) %>"><%= h(c.getCustomerName()) %><%= (c.getPhone() == null || c.getPhone().trim().isEmpty()) ? "" : " (" + h(c.getPhone()) + ")" %></option>
<%
    }
} else {
%>
                                <option value="" disabled>No existing customers found for this account</option>
<%
}
%>
<%-- OPT_END --%>
                            </select>
                            <span class="chev"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m6 9 6 6 6-6"/></svg></i></span>
                        </div>
                        <div class="field-error" id="custError"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg></i> Please select a customer.</div>

                        <div class="picked" id="picked">
                            <div class="pn"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i> <span id="pkName"></span></div>
                            <div class="pl"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg></i> <span id="pkPhone"></span></div>
                            <div class="pl"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z"/></svg></i> <span id="pkGothram"></span></div>
                            <div class="pl"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg></i> <span id="pkAddress"></span></div>
                        </div>
                    </div>
<%-- ADD_END --%>
<% } %>
                    <div id="newCustomerSection" style="<%= editMode ? "" : "display:none;" %>">

                        <div class="field">
                            <div class="field-head"><label class="lbl" for="customerName">Customer Name<em>*</em></label></div>
                            <div class="input-wrap center" id="nameWrap">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i>
                                <input type="text" id="customerName" name="customerName" autocomplete="off" value="<%= editMode ? h(family.getCustomerName()) : "" %>"<%= editMode ? " required" : "" %>>
                            </div>
                            <div class="field-error" id="nameError"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg></i> Please enter the customer name.</div>
                        </div>

                        <div class="field">
                            <div class="field-head"><label class="lbl" for="phone">Phone Number<em>*</em></label></div>
                            <div class="input-wrap center" id="phoneWrap">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg></i>
                                <input type="text" id="phone" name="phone" autocomplete="off" inputmode="tel" value="<%= editMode ? h(family.getPhone()) : "" %>"<%= editMode ? " required" : "" %>>
                            </div>
                            <div class="field-error" id="phoneError"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg></i> Please enter the phone number.</div>
                        </div>

                        <div class="field">
                            <div class="field-head"><label class="lbl" for="gothram">Gothram</label><span class="opt">Optional</span></div>
                            <div class="input-wrap center">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z"/></svg></i>
                                <input type="text" id="gothram" name="gothram" autocomplete="off" value="<%= editMode ? h(family.getGothram()) : "" %>">
                            </div>
                        </div>

                        <div class="field">
                            <div class="field-head"><label class="lbl" for="address">Address</label><span class="opt">Optional</span></div>
                            <div class="input-wrap">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg></i>
                                <textarea id="address" name="address" rows="4"><%= editMode ? h(family.getAddress()) : "" %></textarea>
                            </div>
                        </div>

                    </div>

                </div>

            </div>

            <!-- ================= PAYMENT CARD ================= -->
            <div class="section-card reveal">

                <div class="section-top">
                    <h2><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg></i> Payment Details</h2>
                    <span class="tag">Updates as you type</span>
                </div>

                <div class="card-body">

                    <div class="field">
                        <div class="field-head"><label class="lbl" for="totalAmount">Total Amount<em>*</em></label></div>
                        <div class="input-wrap center" id="totalWrap">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 3h12"/><path d="M6 8h12"/><path d="m6 13 8.5 8"/><path d="M6 13h3"/><path d="M9 13c6.667 0 6.667-10 0-10"/></svg></i>
                            <input type="number" id="totalAmount" name="totalAmount" min="0" step="any" inputmode="decimal"
                                   placeholder="Enter Total Amount" value="<%= editMode ? family.getTotalAmount() : "" %>" required>
                        </div>
                        <div class="field-error" id="totalError"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg></i> Please enter the total amount.</div>
                    </div>

                    <div class="field">
                        <div class="field-head"><label class="lbl" for="amountPaid">Amount Paid</label></div>
                        <div class="input-wrap center">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i>
                            <input type="number" id="amountPaid" name="amountPaid" min="0" step="any" inputmode="decimal"
                                   placeholder="Enter Amount Paid" value="<%= editMode ? family.getAmountPaid() : "0" %>">
                        </div>
                        <div class="field-note" id="paidNote"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg></i> Amount paid is more than the total amount.</div>
                    </div>

                    <div class="pay-bar"><span id="payBar"></span></div>

                    <div class="payment-summary pay-summary">
                        <div class="summary-card pay-mini tot"><span>Total Amount</span><h3 id="totalDisplay">₹0</h3></div>
                        <div class="summary-card pay-mini paid"><span>Amount Paid</span><h3 id="paidDisplay">₹0</h3></div>
                        <div class="summary-card pay-mini rem"><span>Remaining Amount</span><h3 id="remainingDisplay">₹0</h3></div>
                        <div class="summary-card pay-mini st"><span>Payment Status</span><h3 id="statusDisplay" class="pending">Pending</h3></div>
                    </div>

                </div>

            </div>

            <!-- ================= NOTES ================= -->
            <div class="section-card notes-card full reveal">

                <div class="section-top">
                    <h2><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/></svg></i> Additional Notes</h2>
                    <span class="tag">Optional</span>
                </div>

                <div class="card-body">
                    <div class="input-wrap">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/></svg></i>
                        <textarea name="notes" rows="5" placeholder="Write any notes..."><%= editMode ? h(family.getNotes()) : "" %></textarea>
                    </div>
                </div>

            </div>

        </div>

        <!-- ================= BUTTONS ================= -->
        <div class="form-actions button-group">

            <a href="${pageContext.request.contextPath}/bulk-event-families?bulkEventId=<%= bid %>" class="btn-cancel">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i>
                Cancel
            </a>

            <button type="submit" class="btn-submit" id="submitBtn">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z"/><path d="M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7"/><path d="M7 3v4a1 1 0 0 0 1 1h7"/></svg></i>
                <span><%= editMode ? "Update Family" : "Save Family" %></span>
            </button>

        </div>

    </form>

  </div>

</div>

<!-- page behaviour: reveal, customer type, auto fill, payment summary, validation -->
<script>
(function () {
	var EDIT = <%= editMode %>;
	var page = document.querySelector('.dpa-dash');
	if (!page) return;
	function $(id) { return document.getElementById(id); }

	/* stagger + scroll reveal */
	var targets = page.querySelectorAll('.reveal');
	Array.prototype.forEach.call(targets, function (el, i) { el.style.setProperty('--d', (i * 100) + 'ms'); });
	if (!('IntersectionObserver' in window)) { targets.forEach(function (t) { t.classList.add('in'); }); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { en.target.classList.add('in'); io.unobserve(en.target); } });
		}, { threshold: 0.06, rootMargin: '0px 0px -30px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}

	var existingSection = $('existingCustomerSection'), newSection = $('newCustomerSection');
	var radios = document.getElementsByName('customerType');
	var dropdown = $('customerId');
	var fName = $('customerName'), fPhone = $('phone'), fGothram = $('gothram'), fAddress = $('address');

	/* ---- customer type toggle (same behaviour as before; switching to "new" clears the selected customer) ---- */
	function mode() { for (var i = 0; i < radios.length; i++) if (radios[i].checked) return radios[i].value; return 'existing'; }
	function applyMode() {
		if (EDIT) return;
		var m = mode();
		existingSection.style.display = (m === 'existing') ? 'grid' : 'none';
		newSection.style.display = (m === 'existing') ? 'none' : 'grid';
		var shown = (m === 'existing') ? existingSection : newSection;
		shown.classList.remove('swap-in'); void shown.offsetWidth; shown.classList.add('swap-in');
		if (m === 'new') { dropdown.value = ''; $('picked').classList.remove('show'); fName.value = fPhone.value = fGothram.value = fAddress.value = ''; }
	}
	Array.prototype.forEach.call(radios, function (r) { r.addEventListener('change', applyMode); });
	if (!EDIT) { newSection.style.display = 'none'; existingSection.style.display = 'grid'; }
	else { newSection.style.display = 'grid'; }

	/* ---- existing customer auto fill ---- */
	if (dropdown) dropdown.addEventListener('change', function () {
		var o = this.options[this.selectedIndex];
		fName.value = o.dataset.name || ''; fPhone.value = o.dataset.phone || '';
		fAddress.value = o.dataset.address || ''; fGothram.value = o.dataset.gothram || '';
		var p = $('picked');
		if (this.value) {
			$('pkName').textContent = fName.value || '-'; $('pkPhone').textContent = fPhone.value || '-';
			$('pkGothram').textContent = fGothram.value || '-'; $('pkAddress').textContent = fAddress.value || '-';
			p.classList.remove('show'); void p.offsetWidth; p.classList.add('show');
			$('custWrap').classList.remove('invalid'); $('custError').classList.remove('show');
		} else p.classList.remove('show');
	});

	/* ---- payment calculation (same rules as before) ---- */
	var total = $('totalAmount'), paid = $('amountPaid');
    /* Prevent mouse-wheel changes while an amount field is focused. */
    [total, paid].forEach(function (field) {
        if (!field) return;
        field.addEventListener('wheel', function (event) {
            // Prevent accidental changes caused by scrolling while focused.
            event.preventDefault();
        }, { passive: false });
        field.addEventListener('keydown', function (event) {
            // Prevent arrow keys from incrementing/decrementing number inputs.
            if (event.key === 'ArrowUp' || event.key === 'ArrowDown') {
                event.preventDefault();
            }
        });
    });
	var nf = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 2 });
	function setText(el, txt) { if (el.textContent !== txt) { el.textContent = txt; el.classList.remove('bump'); void el.offsetWidth; el.classList.add('bump'); } }
	function updateSummary() {
		var t = parseFloat(total.value) || 0, p = parseFloat(paid.value) || 0, rem = Math.max(0, t - p);
		setText($('totalDisplay'), '\u20B9' + nf.format(t)); setText($('paidDisplay'), '\u20B9' + nf.format(p)); setText($('remainingDisplay'), '\u20B9' + nf.format(rem));
		var st = $('statusDisplay'), label, cls;
		if (t == 0) { label = 'Pending'; cls = 'pending'; }
		else if (p >= t) { label = 'Paid'; cls = 'paid'; }
		else if (p == 0) { label = 'Pending'; cls = 'pending'; }
		else { label = 'Partial'; cls = 'partial'; }
		st.textContent = label; st.className = cls;
		$('payBar').style.width = (t > 0 ? Math.min(100, p / t * 100) : 0) + '%';
		$('paidNote').classList.toggle('show', t > 0 && p > t);
		if (t > 0) { $('totalWrap').classList.remove('invalid'); $('totalError').classList.remove('show'); }
	}
	total.addEventListener('input', updateSummary); paid.addEventListener('input', updateSummary); updateSummary();

	/* ---- validation + submit feedback ---- */
	function bad(wrapId, errId) { var w = $(wrapId); w.classList.remove('invalid'); void w.offsetWidth; w.classList.add('invalid'); $(errId).classList.add('show'); }
	fName.addEventListener('input', function () { if (fName.value.trim()) { $('nameWrap').classList.remove('invalid'); $('nameError').classList.remove('show'); } });
	fPhone.addEventListener('input', function () { if (fPhone.value.trim()) { $('phoneWrap').classList.remove('invalid'); $('phoneError').classList.remove('show'); } });

	var form = $('familyForm'), btn = $('submitBtn'), label = btn.querySelector('span'), original = label.textContent, sending = false;
	form.addEventListener('submit', function (e) {
		if (sending) { e.preventDefault(); return; }
		var first = null, m = EDIT ? 'edit' : mode();
		if (m === 'existing' && !dropdown.value) { bad('custWrap', 'custError'); first = first || dropdown; }
		if (m !== 'existing') {
			if (!fName.value.trim()) { bad('nameWrap', 'nameError'); first = first || fName; }
			if (!fPhone.value.trim()) { bad('phoneWrap', 'phoneError'); first = first || fPhone; }
		}
		if (total.value === '') { bad('totalWrap', 'totalError'); first = first || total; }
		if (first) { e.preventDefault(); first.focus(); return; }
		sending = true; btn.classList.add('loading'); label.textContent = 'Saving\u2026';
	});
	window.addEventListener('pageshow', function (e) {
		if (!e.persisted) return;
		sending = false; btn.classList.remove('loading'); label.textContent = original;
	});
})();
</script>

<script>
(function () {
  var overlay = document.getElementById('notificationOverlay');
  var closeButton = document.getElementById('closeNotification');

  // The notification list and actions are handled by assets/js/notification.js.
  if (closeButton && overlay) {
    closeButton.addEventListener('click', function () {
      overlay.classList.remove('show');
    });
    overlay.addEventListener('click', function (event) {
      if (event.target === overlay) overlay.classList.remove('show');
    });
  }

  // Mark the current sidebar route active, ignoring links without a real route.
  var path = window.location.pathname.replace(/\/+$/, '');
  var any = false;
  document.querySelectorAll('.sidebar-nav a[href]').forEach(function (link) {
    var href = link.getAttribute('href');
    if (!href || href.indexOf('javascript:') === 0 || link.classList.contains('logout-link')) return;
    try {
      var target = new URL(href, window.location.href).pathname.replace(/\/+$/, '');
      if (target === path || (target && path.indexOf(target + '/') === 0)) { link.classList.add('active'); any = true; }
    } catch (e) { /* Ignore invalid or external links. */ }
  });
  // Family forms belong to the "Bulk Events" section of the sidebar.
  if (!any) {
    document.querySelectorAll('.sidebar-nav a[href]').forEach(function (link) {
      try {
        if (new URL(link.getAttribute('href'), window.location.href).pathname.replace(/\/+$/, '').endsWith('/bulk-events')) link.classList.add('active');
      } catch (e) {}
    });
  }
})();
</script>
</body>
</html>
