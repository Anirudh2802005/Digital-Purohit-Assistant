<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.digitalpurohit.model.Customer" %>
<%
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    if (customers == null) customers = java.util.Collections.emptyList();
    String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Customers</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap" rel="stylesheet">
<style>
  /* ---- preview-only: icon sizing, stand-ins for your notification css, demo page ---- */
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
  .demo-notif{ background:#fff; border:1px solid rgba(0,0,0,.08); border-radius:10px; padding:12px 14px; font-size:13px; color:#1b1b1b; }
  .demo-notif small{ display:block; color:#6b7280; margin-top:2px; }
  .notification-footer{ display:flex; align-items:center; justify-content:space-between; padding:14px 20px; font-size:13px; }
  .notification-footer a{ text-decoration:none; display:inline-flex; gap:6px; align-items:center; }
  .global-toast{ display:none; }

  .demo{ margin-left:var(--dpa-sidebar-w); padding:40px 44px; transition:margin .3s; }
  .demo h1{ margin:0 0 4px; font-size:28px; letter-spacing:-.01em; }
  .demo .sub{ margin:0 0 26px; color:var(--dpa-muted); font-size:14px; }
  .stats{ display:grid; grid-template-columns:repeat(auto-fit,minmax(190px,1fr)); gap:16px; margin-bottom:22px; }
  .stat{ background:var(--dpa-surface); border:1px solid var(--dpa-border); border-radius:12px; padding:18px 20px; transition:background-color .35s, border-color .35s; }
  .stat .l{ font-size:11px; text-transform:uppercase; letter-spacing:.08em; color:var(--dpa-muted); }
  .stat .v{ font-size:26px; font-weight:700; margin-top:6px; }
  .panel{ background:var(--dpa-surface); border:1px solid var(--dpa-border); border-radius:12px; padding:20px; transition:background-color .35s, border-color .35s; }
  .panel h3{ margin:0 0 12px; font-size:16px; }
  .panel table{ width:100%; border-collapse:collapse; font-size:13px; }
  .panel th{ text-align:left; color:var(--dpa-muted); font-size:11px; text-transform:uppercase; letter-spacing:.06em; padding:8px 10px; border-bottom:1px solid var(--dpa-border); }
  .panel td{ padding:10px; border-bottom:1px solid var(--dpa-border); }
  .panel tr:last-child td{ border-bottom:0; }
  .note{ margin-top:18px; font-size:12.5px; color:var(--dpa-muted); }
  .note code{ background:var(--dpa-surface-2); border:1px solid var(--dpa-border); border-radius:5px; padding:1px 6px; font-size:12px; }
  @media (max-width:900px){ .demo{ padding:24px 18px; } }
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
   VIEW CUSTOMERS — same design system as the dashboard
   Colours come from the shared theme variables (--dpa-*) defined in
   sidebar.jsp, so the dark / light switch restyles this page too.
   Sizes are in em, so the page scales up on large monitors.
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
	--good:#34d399; --pend:#f0a43a;
	max-width:108em; margin:0 auto;
	display:flex; flex-direction:column; gap:1.5em;
	font-family:'Inter', ui-sans-serif, system-ui, sans-serif;
	font-size:calc(14px * var(--dk)); font-weight:500; line-height:1.45;
	color:var(--dpa-text);
	-webkit-font-smoothing:antialiased;
}
:root[data-theme="light"] .dpa-dash{ --good:#168a4a; --pend:#b45f06; }
.dpa-dash, .dpa-dash *{ box-sizing:border-box; }
.dpa-dash h1, .dpa-dash h2, .dpa-dash h3, .dpa-dash p{ margin:0; }
.dpa-dash a{ text-decoration:none; }

@media (min-width:1700px){ .dpa-dash{ --dk:1.14; } }
@media (min-width:2400px){ .dpa-dash{ --dk:1.4; } }
@media (min-width:3200px){ .dpa-dash{ --dk:1.78; } }

/* ---------- animations ---------- */
@keyframes dpaRise{ from{ opacity:0; translate:0 22px; } to{ opacity:1; translate:0 0; } }
@keyframes dpaFloat2{ 0%,100%{ transform:translate(0,0) scale(1); } 50%{ transform:translate(-26px,30px) scale(1.08); } }
@keyframes dpaDrift{ from{ transform:translateX(0); } to{ transform:translateX(-50%); } }
@keyframes dpaRing{ 0%{ box-shadow:0 0 0 0 rgba(255,255,255,.35); } 70%,100%{ box-shadow:0 0 0 14px rgba(255,255,255,0); } }
@keyframes dpaBob{ 0%,100%{ transform:translateY(0); } 50%{ transform:translateY(-6px); } }
@keyframes dpaRow{ from{ opacity:0; translate:-12px 0; } to{ opacity:1; translate:0 0; } }
@keyframes dpaSpin{ to{ transform:rotate(360deg); } }
.dpa-js .dpa-dash .reveal{ opacity:0; }
.dpa-js .dpa-dash .reveal.in{ animation:dpaRise .75s cubic-bezier(.2,.8,.2,1) var(--d, 0ms) both; }

/* =====================================================================
   HERO
   ===================================================================== */
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
.dpa-dash .hero-btn{
	display:inline-flex; align-items:center; gap:.55em; margin:0; padding:.75em 1.2em;
	border-radius:.75em; border:1px solid rgba(255,255,255,.28); background:rgba(255,255,255,.07); color:#fff;
	-webkit-backdrop-filter:blur(8px); backdrop-filter:blur(8px);
	font-family:inherit; font-size:.95em; font-weight:600; line-height:1.2; cursor:pointer;
	transition:background-color .2s, border-color .2s, color .2s, transform .12s;
}
.dpa-dash .hero-btn:active{ transform:scale(.96); }

/* =====================================================================
   SEARCH
   ===================================================================== */
.dpa-dash .search-card{
	margin:0; padding:1.1em 1.3em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .search-card form{ display:flex; align-items:stretch; gap:.7em; margin:0; padding:0; background:transparent; border:0; box-shadow:none; }
.dpa-dash .search-field{
	flex:1; min-width:0; display:flex; align-items:center; gap:.7em; padding:0 1em;
	border-radius:.75em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:border-color .2s, box-shadow .2s;
}
.dpa-dash .search-field:focus-within{ border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.2); }
.dpa-dash .search-field i{ color:var(--dpa-muted); font-size:1em; transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .search-field:focus-within i{ color:var(--dpa-link); transform:scale(1.12); }
.dpa-dash .search-field input{
	flex:1; min-width:0; width:100%; margin:0; padding:.9em 0; border:0; outline:0; box-shadow:none; background:transparent;
	font-family:inherit; font-size:1em; font-weight:500; color:var(--dpa-text);
}
.dpa-dash .search-field input::placeholder{ color:var(--dpa-muted); opacity:.8; font-weight:400; }
.dpa-dash .btn-search, .dpa-dash .btn-reset{
	position:relative; overflow:hidden; display:inline-flex; align-items:center; justify-content:center; gap:.55em;
	margin:0; padding:.85em 1.4em; border-radius:.75em; box-shadow:none;
	font-family:inherit; font-size:1em; font-weight:600; line-height:1.2; cursor:pointer;
	transition:background-color .2s, color .2s, border-color .2s, transform .12s, box-shadow .25s;
}
.dpa-dash .btn-search{ background:var(--dpa-active-bg); color:var(--dpa-active-text); border:1px solid var(--dpa-active-bg); }
.dpa-dash .btn-search::after{
	content:""; position:absolute; top:0; left:-120%; width:60%; height:100%;
	background:linear-gradient(100deg, transparent, rgba(255,255,255,.35), transparent);
	transform:skewX(-20deg); transition:left .6s;
}
.dpa-dash .btn-search.loading{ pointer-events:none; opacity:.85; }
.dpa-dash .btn-search.loading i{ animation:dpaSpin .8s linear infinite; }
.dpa-dash .btn-reset{ background:transparent; color:var(--dpa-text); border:1px solid var(--dpa-border); }

/* =====================================================================
   TABLE
   ===================================================================== */
.dpa-dash .table-card{
	margin:0; padding:0; overflow:hidden;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .table-top{
	display:flex; align-items:center; justify-content:space-between; gap:1em; flex-wrap:wrap;
	padding:1.15em 1.5em; border-bottom:1px solid var(--dpa-border);
}
.dpa-dash .table-top h2{ display:flex; align-items:center; gap:.65em; font-size:1.15em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .table-top h2 i{
	width:2.3em; height:2.3em; font-size:.85em; border-radius:.7em;
	display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile);
}
.dpa-dash .table-top h2 small{ font-size:.75em; font-weight:600; color:var(--dpa-muted); }
.dpa-dash .table-wrap{ overflow-x:auto; }
.dpa-dash .table-card table{ width:100%; border-collapse:collapse; margin:0; background:transparent; font-size:.95em; }
.dpa-dash .table-card thead th{
	padding:.9em 1.2em; text-align:left; white-space:nowrap; background:transparent;
	font-size:.74em; font-weight:700; letter-spacing:.09em; text-transform:uppercase; color:var(--dpa-muted);
	border:0; border-bottom:1px solid var(--dpa-border); cursor:pointer; user-select:none; transition:color .2s;
}
.dpa-dash .table-card thead th.center{ text-align:center; }
.dpa-dash .table-card thead th.right{ text-align:right; cursor:default; }
.dpa-dash .table-card thead th:not(.right)::after{ content:"\2195"; margin-left:.45em; opacity:.35; font-size:1.1em; }
.dpa-dash .table-card thead th[aria-sort="ascending"]::after{ content:"\2191"; opacity:1; color:var(--dpa-link); }
.dpa-dash .table-card thead th[aria-sort="descending"]::after{ content:"\2193"; opacity:1; color:var(--dpa-link); }
.dpa-dash .table-card tbody td{
	padding:.95em 1.2em; border:0; border-bottom:1px solid var(--dpa-border); background:transparent; color:var(--dpa-text);
	vertical-align:middle;
}
.dpa-dash .table-card tbody tr:last-child td{ border-bottom:0; }
.dpa-dash .cust-row{ transition:background-color .2s, opacity .4s, filter .4s; animation:dpaRow .55s cubic-bezier(.2,.8,.2,1) both; animation-delay:calc(var(--i, 0) * 45ms + 250ms); }
.dpa-dash .cust-row.removing{ opacity:.35; filter:grayscale(1); }

.dpa-dash .cust-name{ display:flex; align-items:center; gap:.85em; min-width:0; font-weight:600; }
.dpa-dash .cust-avatar{
	flex-shrink:0; width:2.7em; height:2.7em; border-radius:50%;
	display:flex; align-items:center; justify-content:center;
	font-size:.95em; font-weight:700; background:var(--dpa-active-bg); color:var(--dpa-active-text);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1);
}
.dpa-dash .cust-name span.nm{ overflow-wrap:anywhere; }
.dpa-dash .event-count{
	display:inline-flex; align-items:center; justify-content:center; min-width:2.4em; padding:.25em .75em; border-radius:999px;
	background:rgba(43,127,255,.15); color:var(--dpa-link); font-weight:700; font-variant-numeric:tabular-nums;
}
.dpa-dash .td-events{ text-align:center; }
.dpa-dash .td-actions{ text-align:right; white-space:nowrap; }
.dpa-dash .row-actions{ display:inline-flex; gap:.5em; }
.dpa-dash .btn-view, .dpa-dash .btn-edit, .dpa-dash .btn-delete{
	display:inline-flex; align-items:center; gap:.5em; margin:0; padding:.55em .9em;
	border-radius:.65em; border:1px solid var(--dpa-border); background:transparent; box-shadow:none;
	font-family:inherit; font-size:.88em; font-weight:600; line-height:1.2; color:var(--dpa-text);
	transition:background-color .2s, color .2s, border-color .2s, transform .12s;
}
.dpa-dash .btn-view i{ color:var(--dpa-link); }
.dpa-dash .btn-edit i{ color:var(--pend); }
.dpa-dash .btn-delete i{ color:var(--dpa-bad); }
.dpa-dash .btn-view:active, .dpa-dash .btn-edit:active, .dpa-dash .btn-delete:active{ transform:scale(.95); }

.dpa-dash .empty-box{
	display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center;
	gap:.45em; margin:0; padding:3.2em 1em; color:var(--dpa-muted);
}
.dpa-dash .empty-box i{ font-size:2.8em; opacity:.55; animation:dpaBob 3.4s ease-in-out infinite; }
.dpa-dash .empty-box p{ font-size:1.05em; font-weight:600; color:var(--dpa-text); opacity:.9; }

/* =====================================================================
   HOVER — mouse only
   ===================================================================== */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ background:#fff; color:#1b1b1b; border-color:#fff; }
	.dpa-dash .search-field:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .btn-search:hover{ background:var(--dpa-twilight); border-color:var(--dpa-twilight); color:#fff; box-shadow:0 8px 22px rgba(66,97,136,.4); }
	.dpa-dash .btn-search:hover::after{ left:140%; }
	.dpa-dash .btn-reset:hover{ background:var(--dpa-hover); border-color:var(--dpa-text); }
	.dpa-dash .cust-row:hover{ background:var(--dpa-hover); }
	.dpa-dash .cust-row:hover .cust-avatar{ transform:scale(1.1) rotate(-6deg); }
	.dpa-dash .table-card thead th:not(.right):hover{ color:var(--dpa-text); }
	.dpa-dash .btn-view:hover{ background:rgba(43,127,255,.14); border-color:var(--dpa-link); }
	.dpa-dash .btn-edit:hover{ background:rgba(240,164,58,.15); border-color:var(--pend); }
	.dpa-dash .btn-delete:hover{ background:var(--dpa-bad); border-color:var(--dpa-bad); color:#fff; }
	.dpa-dash .btn-delete:hover i{ color:#fff; }
}
.dpa-dash a:focus-visible, .dpa-dash button:focus-visible, .dpa-dash th:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* =====================================================================
   RESPONSIVE
   ===================================================================== */
@media (max-width:700px){
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .page-header .hero-btn{ width:100%; justify-content:center; }
	.dpa-dash .search-card{ padding:1em; }
	.dpa-dash .search-card form{ flex-wrap:wrap; }
	.dpa-dash .search-field{ flex:1 1 100%; }
	.dpa-dash .btn-search{ flex:1; }
	.dpa-dash .btn-reset{ flex:1; }
	.dpa-dash .table-top{ padding:1em 1.1em; }
	/* the table becomes a list of cards, no sideways scrolling */
	.dpa-dash .table-card thead{ display:none; }
	.dpa-dash .table-card table, .dpa-dash .table-card tbody{ display:block; }
	.dpa-dash .cust-row{ display:block; padding:1em 1.1em; border-bottom:1px solid var(--dpa-border); }
	.dpa-dash .cust-row:last-child{ border-bottom:0; }
	.dpa-dash .table-card tbody td{ display:flex; justify-content:space-between; align-items:center; gap:1em; padding:.4em 0; border:0; text-align:right !important; }
	.dpa-dash .table-card tbody td::before{
		content:attr(data-label); flex-shrink:0; text-align:left;
		font-size:.74em; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--dpa-muted);
	}
	.dpa-dash .table-card tbody td.td-name{ padding-bottom:.7em; }
	.dpa-dash .table-card tbody td.td-name::before, .dpa-dash .table-card tbody td.td-actions::before{ display:none; }
	.dpa-dash .table-card tbody td.td-actions{ padding-top:.8em; }
	.dpa-dash .row-actions{ width:100%; }
	.dpa-dash .row-actions a{ flex:1; justify-content:center; padding:.75em .5em; }
}

@media print{
	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-dash{ --dpa-text:#000; --dpa-muted:#444; --dpa-surface:#fff; --dpa-surface-2:#fff; --dpa-border:#bbb; --dpa-tile:#eee; --dpa-active-bg:#222; --dpa-active-text:#fff; }
	.dpa-js .dpa-dash .reveal, .dpa-dash .cust-row{ opacity:1 !important; animation:none !important; }
	.dpa-dash .page-header{ background:#fff; color:#000; border-color:#bbb; }
	.dpa-dash .page-header *{ color:#000 !important; }
	.dpa-dash .hero-watermark{ display:none; }
	.dpa-dash .page-header .hero-btn, .dpa-dash .search-card, .dpa-dash .td-actions, .dpa-dash th.right{ display:none; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal, .dpa-dash .cust-row{ opacity:1; }
}
</style>
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

  /* GLOBAL PAGE BASE — remove these 4 lines if your pages already handle themes */
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

  /* hidden duplicate of the notifications link (kept from the original markup) */
  .dpa-dup-link{ display:none !important; }

  /* =================================================================
     MOBILE: drawer + top bar
     (phones, small tablets, and phones held sideways)
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
     SHORT SCREENS (laptops 768px tall and under, phones held sideways): tighter spacing
     so the whole menu fits without scrolling wherever possible
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
     LARGE MONITORS: scale the sidebar up so it never looks tiny
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

  /* print (e.g. reports): no sidebar, no gap */
  @media print{
    .sidebar, .dpa-mobile-bar, .dpa-backdrop{ display:none !important; }
    :root{ --dpa-sidebar-w:0px; }
    body{ padding-top:0 !important; }
  }

  /* =================================================================
     NOTIFICATION POPUP — theme only (layout/behaviour stays in your notification css/js)
     Kept as a light card in both modes so your JS-rendered items stay readable.
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

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

  <div class="view-customers-page dpa-dash">

    <!-- Header -->

    <div class="page-header">

        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>

        <div class="hero-left">

            <div class="hero-icon">

                <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 2v2"/><path d="M7 22v-2a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v2"/><path d="M8 2v2"/><circle cx="12" cy="11" r="3"/><rect x="4" y="4" width="16" height="18" rx="2"/></svg></i>

            </div>

            <div>

                <h1>View Customers</h1>

                <p>Search, edit and manage all registered customers.</p>

            </div>

        </div>

        <a href="${pageContext.request.contextPath}/add-customer" class="hero-btn">

            <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" x2="19" y1="8" y2="14"/><line x1="22" x2="16" y1="11" y2="11"/></svg></i> Add Customer

        </a>

    </div>

    <!-- Search -->

    <div class="search-card reveal">

        <form action="${pageContext.request.contextPath}/view-customers" method="get" id="searchForm">

            <label class="search-field">

                <i><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>

                <input
                    type="text"
                    name="keyword"
                    value="${param.keyword}"
                    autocomplete="off"
                    placeholder="Search by Name / Phone / Gothram">

            </label>

            <button type="submit"
                    class="btn-search">

                <i><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>

                <span>Search</span>

            </button>

            <a href="${pageContext.request.contextPath}/view-customers" class="btn-reset">

                <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg></i>

                Reset

            </a>

        </form>

    </div>

    <!-- Table -->

    <div class="table-card reveal">



        <div class="table-top">

            <h2><i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i> Customers <small><%= customers.size() %> found</small></h2>

        </div>

        <div class="table-wrap">

        <table id="custTable">

            <thead>

                <tr>

                    <th data-type="text">Customer Name</th>

                    <th data-type="text">Phone</th>

                    <th data-type="text">Gothram</th>

                    <th data-type="num" class="center">Events</th>

                    <th class="right">Actions</th>

                </tr>

            </thead>

<tbody>
<% if (!customers.isEmpty()) { for (Customer customer : customers) {
   String name = customer.getCustomerName() == null ? "" : customer.getCustomerName();
   String initial = name.trim().isEmpty() ? "C" : name.trim().substring(0, 1).toUpperCase();
   String gothram = customer.getGothram() == null || customer.getGothram().trim().isEmpty() ? "—" : customer.getGothram();
%>
<tr class="cust-row">
  <td class="td-name" data-label="Customer Name"><div class="cust-name">
    <span class="cust-avatar" aria-hidden="true"><%= initial %></span>
    <span class="nm"><%= name %></span>
  </div></td>
  <td data-label="Phone"><%= customer.getPhone() == null ? "—" : customer.getPhone() %></td>
  <td data-label="Gothram"><%= gothram %></td>
  <td class="td-events" data-label="Events"><span class="event-count"><%= customer.getTotalEvents() %></span></td>
  <td class="td-actions" data-label="Actions"><div class="row-actions">
    <a class="btn-view" href="${pageContext.request.contextPath}/customer-history?customerId=<%= customer.getCustomerId() %>">
      <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg></i> View
    </a>
    <a class="btn-edit" href="${pageContext.request.contextPath}/edit-customer?customerId=<%= customer.getCustomerId() %>">
      <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z"/></svg></i> Edit
    </a>
    <a class="btn-delete" href="${pageContext.request.contextPath}/delete-customer?customerId=<%= customer.getCustomerId() %>" onclick="return confirm('Are you sure you want to delete this customer?');">
      <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg></i> Delete
    </a>
  </div></td>
</tr>
<% } } else { %>
<tr><td colspan="5" class="empty-state" style="text-align:center;padding:30px;">No customers found.</td></tr>
<% } %>
</tbody>

        </table>

        </div>



    </div>

  </div>

</div>



<!-- page behaviour: animations, column sorting, delete feedback, search feedback -->
<script>
(function () {
	var page = document.querySelector('.dpa-dash');
	if (!page) return;

	/* ---------- scroll reveal ---------- */
	var targets = page.querySelectorAll('.reveal');
	function show(el) { el.classList.add('in'); }
	if (!('IntersectionObserver' in window)) { targets.forEach(show); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { show(en.target); io.unobserve(en.target); } });
		}, { threshold: 0.08, rootMargin: '0px 0px -20px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}
	var cards = page.querySelectorAll('.search-card, .table-card');
	Array.prototype.forEach.call(cards, function (el, i) { el.style.setProperty('--d', (i * 100) + 'ms'); });

	/* ---------- search button feedback (the form is still submitted normally) ---------- */
	var form = document.getElementById('searchForm');
	if (form) form.addEventListener('submit', function () {
		var btn = form.querySelector('.btn-search');
		btn.classList.add('loading');
		btn.querySelector('span').textContent = 'Searching…';
		btn.querySelector('i').className = 'fa-solid fa-circle-notch';
	});
	window.addEventListener('pageshow', function (e) {
		if (!e.persisted || !form) return;
		var btn = form.querySelector('.btn-search');
		btn.classList.remove('loading');
		btn.querySelector('span').textContent = 'Search';
		btn.querySelector('i').className = 'fa-solid fa-magnifying-glass';
	});

	var table = document.getElementById('custTable');
	if (!table) return;
	var tbody = table.tBodies[0];
	var rows = Array.prototype.slice.call(tbody.querySelectorAll('.cust-row'));
	rows.forEach(function (r, i) { r.style.setProperty('--i', Math.min(i, 14)); });

	/* ---------- delete: your confirm() still runs first; if you confirm, the row greys out while the page navigates ---------- */
	rows.forEach(function (r) {
		var del = r.querySelector('.btn-delete');
		if (del) del.addEventListener('click', function (e) { if (!e.defaultPrevented) r.classList.add('removing'); });
	});
	window.addEventListener('pageshow', function (e) {
		if (e.persisted) rows.forEach(function (r) { r.classList.remove('removing'); });
	});

	/* ---------- sort by clicking a column heading ---------- */
	function num(t) { var n = parseFloat(String(t).replace(/[^0-9.\-]/g, '')); return isNaN(n) ? 0 : n; }
	var heads = Array.prototype.slice.call(table.tHead.rows[0].cells);
	heads.forEach(function (th, idx) {
		if (th.classList.contains('right')) return;
		th.setAttribute('tabindex', '0');
		function sort() {
			var dir = th.getAttribute('aria-sort') === 'ascending' ? 'descending' : 'ascending';
			heads.forEach(function (h) { h.removeAttribute('aria-sort'); });
			th.setAttribute('aria-sort', dir);
			var type = th.dataset.type;
			function val(tr) {
				var t = tr.cells[idx].textContent.trim();
				return type === 'num' ? num(t) : t.toLowerCase();
			}
			rows.sort(function (a, b) {
				var x = val(a), y = val(b);
				return (x < y ? -1 : x > y ? 1 : 0) * (dir === 'ascending' ? 1 : -1);
			});
			rows.forEach(function (r) { tbody.appendChild(r); });
		}
		th.addEventListener('click', sort);
		th.addEventListener('keydown', function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); sort(); } });
	});
})();
</script>



</body>
</html>