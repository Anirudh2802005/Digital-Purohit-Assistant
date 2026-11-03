<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.digitalpurohit.model.Event" %>

<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard | Digital Purohit Assistant</title>
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
   DASHBOARD — same design system as login / register / sidebar
   Colours come from the shared theme variables (--dpa-*) defined in
   sidebar.jsp, so the dark / light switch restyles this page too.
   Sizes are in em, so the whole page scales on large monitors.
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
	--pend:#f0a43a;
	--good:#34d399;
	max-width:108em; margin:0 auto;
	display:flex; flex-direction:column; gap:1.5em;
	font-family:'Inter', ui-sans-serif, system-ui, sans-serif;
	font-size:calc(14px * var(--dk)); font-weight:500; line-height:1.45;
	color:var(--dpa-text);
	-webkit-font-smoothing:antialiased;
}
:root[data-theme="light"] .dpa-dash{ --pend:#b45f06; --good:#168a4a; }
.dpa-dash, .dpa-dash *{ box-sizing:border-box; }
.dpa-dash h1, .dpa-dash h2, .dpa-dash h3, .dpa-dash h4, .dpa-dash p{ margin:0; }
.dpa-dash a{ text-decoration:none; }

@media (min-width:1700px){ .dpa-dash{ --dk:1.14; } }
@media (min-width:2400px){ .dpa-dash{ --dk:1.4; } }
@media (min-width:3200px){ .dpa-dash{ --dk:1.78; } }

/* ---------- scroll-reveal (only when JS is running) ---------- */
@keyframes dpaRise{ from{ opacity:0; translate:0 22px; } to{ opacity:1; translate:0 0; } }
@keyframes dpaFloat2{ 0%,100%{ transform:translate(0,0) scale(1); } 50%{ transform:translate(-26px,30px) scale(1.08); } }
@keyframes dpaDrift{ from{ transform:translateX(0); } to{ transform:translateX(-50%); } }
@keyframes dpaRing{ 0%{ box-shadow:0 0 0 0 rgba(255,255,255,.35); } 70%,100%{ box-shadow:0 0 0 14px rgba(255,255,255,0); } }
@keyframes dpaBob{ 0%,100%{ transform:translateY(0); } 50%{ transform:translateY(-6px); } }
.dpa-js .dpa-dash .reveal{ opacity:0; }
.dpa-js .dpa-dash .reveal.in{ animation:dpaRise .75s cubic-bezier(.2,.8,.2,1) var(--d, 0ms) both; }

/* =====================================================================
   HERO
   ===================================================================== */
.dpa-dash .dashboard-hero{
	position:relative; overflow:hidden; isolation:isolate;
	display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:1.3em;
	margin:0; padding:2.1em 2.3em;
	border-radius:1.3em; border:1px solid rgba(255,255,255,.08); box-shadow:none;
	background:#05070b; color:#fff;
	animation:dpaRise .9s cubic-bezier(.2,.8,.2,1) both;
}
.dpa-dash .dashboard-hero::before, .dpa-dash .dashboard-hero::after{
	content:""; position:absolute; z-index:-1; border-radius:50%; filter:blur(46px); pointer-events:none;
}
.dpa-dash .dashboard-hero::before{
	width:26em; height:26em; top:-13em; left:-5em;
	background:radial-gradient(circle, rgba(66,97,136,.9), rgba(66,97,136,0) 70%);
	animation:dpaFloat2 14s ease-in-out infinite;
}
.dpa-dash .dashboard-hero::after{
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
.dpa-dash .hero-left h1{
	font-family:'Anton', ui-sans-serif, sans-serif; font-weight:400; text-transform:uppercase;
	font-size:clamp(1.9em, 3.6vw, 3.5em); line-height:1; letter-spacing:.01em; color:#fff;
	overflow-wrap:anywhere;
}
.dpa-dash .hero-left h1 .hero-name{
	font-family:'Caveat', cursive; font-style:italic; font-weight:600; text-transform:none;
	color:#86a9d8; font-size:1.12em; letter-spacing:0;
}
.dpa-dash .hero-left p{ margin-top:.55em; color:rgba(255,255,255,.72); font-weight:400; font-size:1.05em; }
.dpa-dash .hero-date{
	display:flex; align-items:center; gap:.9em; padding:.85em 1.15em;
	border-radius:1em; border:1px solid rgba(255,255,255,.16);
	background:rgba(255,255,255,.07); -webkit-backdrop-filter:blur(10px); backdrop-filter:blur(10px);
	color:#fff;
}
.dpa-dash .hero-date-icon{
	width:2.6em; height:2.6em; border-radius:.8em; flex-shrink:0;
	display:flex; align-items:center; justify-content:center; background:rgba(255,255,255,.12); color:#fff;
}
.dpa-dash .hero-date strong{ display:block; font-size:1.02em; font-weight:600; }
.dpa-dash .hero-date span{ display:block; margin-top:.1em; font-size:.88em; color:rgba(255,255,255,.7); }

/* =====================================================================
   TOP SUMMARY CARDS
   ===================================================================== */
.dpa-dash .dashboard-top{
	display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:1.1em; margin:0;
}
.dpa-dash .top-stat-card{
	--acc:#2b7fff; --acc-soft:rgba(43,127,255,.15);
	position:relative; overflow:hidden; margin:0; padding:1.4em 1.5em;
	container-type:inline-size;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .stat-green{ --acc:#1fbf6a; --acc-soft:rgba(31,191,106,.16); }
.dpa-dash .stat-blue{ --acc:#2b7fff; --acc-soft:rgba(43,127,255,.16); }
.dpa-dash .stat-orange{ --acc:#f0a43a; --acc-soft:rgba(240,164,58,.17); }
.dpa-dash .stat-purple{ --acc:#9b7bff; --acc-soft:rgba(155,123,255,.17); }
.dpa-dash .top-stat-card::before{
	content:""; position:absolute; left:0; top:0; height:3px; width:100%; background:var(--acc);
	transform:scaleX(0); transform-origin:left; transition:transform .9s cubic-bezier(.2,.8,.2,1) .25s;
}
.dpa-dash .top-stat-card.in::before, html:not(.dpa-js) .dpa-dash .top-stat-card::before{ transform:scaleX(1); }
.dpa-dash .top-stat-content{ display:flex; align-items:flex-start; justify-content:space-between; gap:1em; }
.dpa-dash .top-stat-content > div:first-child{ min-width:0; }
.dpa-dash .stat-label{
	display:block; font-size:.78em; font-weight:600; letter-spacing:.09em; text-transform:uppercase; color:var(--dpa-muted);
}
.dpa-dash .top-stat-card h2{
	margin:.45em 0 .3em; font-size:1.8em; font-size:clamp(1.3em, 9.4cqw, 2.05em); font-weight:700; line-height:1.1; letter-spacing:-.02em;
	font-variant-numeric:tabular-nums; color:var(--dpa-text); overflow-wrap:anywhere;
}
.dpa-dash .top-stat-card small{ display:block; font-size:.86em; font-weight:500; color:var(--dpa-muted); }
.dpa-dash .top-stat-icon{
	flex-shrink:0; width:2.7em; height:2.7em; border-radius:.9em; font-size:1.15em;
	display:flex; align-items:center; justify-content:center;
	background:var(--acc-soft); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}

/* =====================================================================
   SHARED CARD
   ===================================================================== */
.dpa-dash .dashboard-card{
	margin:0; padding:0; overflow:hidden;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .dashboard-card .card-header{
	display:flex; align-items:center; justify-content:space-between; gap:1em; flex-wrap:wrap;
	margin:0; padding:1.15em 1.5em; background:transparent;
	border:0; border-bottom:1px solid var(--dpa-border);
}
.dpa-dash .dashboard-card .card-header h2{
	display:flex; align-items:center; gap:.65em; margin:0;
	font-size:1.15em; font-weight:700; letter-spacing:-.01em; color:var(--dpa-text);
}
.dpa-dash .dashboard-card .card-header h2 i{
	flex-shrink:0; width:2.3em; height:2.3em; font-size:.85em; border-radius:.7em;
	display:inline-flex; align-items:center; justify-content:center;
	background:var(--dpa-tile); color:var(--dpa-text);
}
.dpa-dash .dashboard-card .card-header p{ margin:.25em 0 0 3.2em; font-size:.88em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .dashboard-card .card-header > a{
	display:inline-flex; align-items:center; gap:.4em; padding:.45em .9em; border-radius:999px;
	border:1px solid var(--dpa-border); background:transparent; color:var(--dpa-link);
	font-size:.86em; font-weight:600; white-space:nowrap;
	transition:background-color .2s, border-color .2s;
}
.dpa-dash .dashboard-card .card-header > a::after{ content:"\2192"; display:inline-block; transition:transform .25s; }
.dpa-dash .dashboard-card .card-body{ margin:0; padding:.7em .9em .9em; background:transparent; }

.dpa-dash .dashboard-main-grid{
	display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:1.1em; margin:0;
}
.dpa-dash .dashboard-main-grid > .dashboard-card{ min-width:0; }

/* =====================================================================
   QUICK ACTIONS
   ===================================================================== */
.dpa-dash .quick-actions-card .card-body{ padding:1.1em 1.3em 1.3em; }
.dpa-dash .quick-grid{
	display:grid; grid-template-columns:repeat(6, minmax(0, 1fr)); gap:.9em; margin:0;
}
.dpa-dash .quick-link{
	position:relative; display:flex; flex-direction:column; align-items:flex-start; gap:.2em;
	margin:0; padding:1.1em 1.1em 1.15em; border-radius:1em;
	border:1px solid var(--dpa-border); background:var(--dpa-surface-2); box-shadow:none;
	color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .quick-link::after{
	content:"\2197"; position:absolute; top:.9em; right:1em; font-size:1em; color:var(--dpa-muted);
	opacity:0; transform:translate(-4px, 4px); transition:opacity .25s, transform .25s;
}
.dpa-dash .quick-icon{
	width:2.9em; height:2.9em; margin-bottom:.7em; border-radius:.9em; font-size:1.1em;
	display:flex; align-items:center; justify-content:center;
	background:var(--dpa-tile); color:var(--dpa-text);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .quick-title{ font-size:1em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .quick-subtitle{ font-size:.82em; font-weight:400; color:var(--dpa-muted); line-height:1.35; }

/* =====================================================================
   LIST ROWS (events + payments)
   ===================================================================== */
.dpa-dash .event-item, .dpa-dash .payment-item{
	display:flex; align-items:center; gap:1em; margin:0; padding:.8em .75em; border-radius:.9em;
	background:transparent; border:0; box-shadow:none;
	transition:background-color .2s;
}
.dpa-dash .event-item + .event-item, .dpa-dash .payment-item + .payment-item{ border-top:1px solid var(--dpa-border); border-radius:.9em; }
.dpa-dash .event-time, .dpa-dash .event-date{
	flex-shrink:0; min-width:5.6em; padding:.6em .5em; text-align:center; border-radius:.8em;
	background:var(--dpa-tile); color:var(--dpa-text); font-size:.86em; font-weight:700; line-height:1.3;
}
.dpa-dash .event-time i{ display:block; margin:0 auto .3em; font-size:1.1em; color:var(--dpa-muted); }
.dpa-dash .event-time br{ display:none; }
.dpa-dash .event-info{ min-width:0; flex:1; }
.dpa-dash .event-info h4{
	font-size:1em; font-weight:600; letter-spacing:-.005em; color:var(--dpa-text);
	overflow:hidden; text-overflow:ellipsis; white-space:nowrap;
}
.dpa-dash .event-info p{ margin-top:.2em; font-size:.88em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .event-info p i, .dpa-dash .event-info span i{ width:1.1em; margin-right:.25em; text-align:center; opacity:.85; }
.dpa-dash .event-info span{ display:block; margin-top:.15em; font-size:.82em; color:var(--dpa-muted); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

.dpa-dash .payment-customer{ display:flex; align-items:center; gap:.9em; min-width:0; flex:1; }
.dpa-dash .payment-avatar{
	flex-shrink:0; width:2.9em; height:2.9em; border-radius:50%; font-size:.95em;
	display:flex; align-items:center; justify-content:center;
	background:var(--dpa-tile); color:var(--dpa-text);
}
.dpa-dash .payment-customer > div:last-child{ min-width:0; }
.dpa-dash .payment-customer strong{ display:block; font-size:1em; font-weight:600; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.dpa-dash .payment-customer small{ display:block; margin-top:.1em; font-size:.82em; font-weight:400; color:var(--dpa-muted); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.dpa-dash .payment-customer small i{ margin-right:.3em; }
.dpa-dash .payment-right{ display:flex; flex-direction:column; align-items:flex-end; gap:.35em; flex-shrink:0; }
.dpa-dash .payment-amount{ font-size:1.05em; font-weight:700; color:var(--pend); font-variant-numeric:tabular-nums; }
.dpa-dash .payment-status{
	padding:.2em .7em; border-radius:999px; font-size:.7em; font-weight:700; letter-spacing:.06em; text-transform:uppercase;
	background:rgba(240,164,58,.16); color:var(--pend);
}
:root[data-theme="light"] .dpa-dash .payment-status{ background:rgba(180,95,6,.12); }

/* ---------- empty states ---------- */
.dpa-dash .empty-box{
	display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center;
	gap:.45em; margin:0; padding:2.4em 1em; color:var(--dpa-muted); background:transparent; border:0;
}
.dpa-dash .empty-box i{ font-size:2.6em; opacity:.55; animation:dpaBob 3.4s ease-in-out infinite; }
.dpa-dash .empty-box p{ font-size:.98em; font-weight:500; color:var(--dpa-text); opacity:.85; }
.dpa-dash .empty-box small{ font-size:.85em; font-weight:400; }
.dpa-dash .payment-empty i{ color:var(--good); opacity:.9; }

/* =====================================================================
   BUSINESS OVERVIEW
   ===================================================================== */
.dpa-dash .summary-grid{
	display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:1em; margin:0; padding:1.2em 1.3em 1.35em;
}
.dpa-dash .summary-box{
	--acc:#1fbf6a; --acc-soft:rgba(31,191,106,.16);
	display:flex; align-items:center; gap:1em; margin:0; padding:1.1em 1.2em; border-radius:1em;
	border:1px solid var(--dpa-border); background:var(--dpa-surface-2); box-shadow:none;
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .summary-icon{
	flex-shrink:0; width:3.1em; height:3.1em; border-radius:1em; font-size:1.1em;
	display:flex; align-items:center; justify-content:center;
	background:var(--acc-soft); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1);
}
.dpa-dash .summary-icon.green-icon{ --acc:#1fbf6a; --acc-soft:rgba(31,191,106,.16); }
.dpa-dash .summary-icon.blue-icon{ --acc:#2b7fff; --acc-soft:rgba(43,127,255,.16); }
.dpa-dash .summary-icon.purple-icon{ --acc:#9b7bff; --acc-soft:rgba(155,123,255,.17); }
.dpa-dash .summary-icon.orange-icon{ --acc:#f0a43a; --acc-soft:rgba(240,164,58,.17); }
.dpa-dash .summary-box h3{ font-size:1.5em; font-weight:700; letter-spacing:-.02em; line-height:1.15; font-variant-numeric:tabular-nums; overflow-wrap:anywhere; }
.dpa-dash .summary-box p{ margin-top:.2em; font-size:.86em; font-weight:500; color:var(--dpa-muted); }

/* =====================================================================
   HOVER EFFECTS — mouse only (no sticky hover on touch screens)
   ===================================================================== */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .top-stat-card:hover{ transform:translateY(-4px); border-color:var(--acc); }
	.dpa-dash .top-stat-card:hover .top-stat-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .quick-link:hover{ transform:translateY(-5px); border-color:var(--dpa-twilight); background:var(--dpa-hover); }
	.dpa-dash .quick-link:hover::after{ opacity:1; transform:none; }
	.dpa-dash .quick-link:hover .quick-icon{ transform:rotate(-8deg) scale(1.1); background:var(--dpa-twilight); color:#fff; }
	.dpa-dash .event-item:hover, .dpa-dash .payment-item:hover{ background:var(--dpa-hover); }
	.dpa-dash .dashboard-card .card-header > a:hover{ background:var(--dpa-hover); border-color:var(--dpa-link); }
	.dpa-dash .dashboard-card .card-header > a:hover::after{ transform:translateX(4px); }
	.dpa-dash .summary-box:hover{ transform:translateY(-3px); border-color:var(--acc); }
	.dpa-dash .summary-box:hover .summary-icon{ transform:rotate(-8deg) scale(1.1); }
}
.dpa-dash .quick-link:active, .dpa-dash .top-stat-card:active{ transform:scale(.985); }
.dpa-dash a:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* =====================================================================
   RESPONSIVE
   ===================================================================== */
@media (max-width:1279px){
	.dpa-dash .dashboard-top{ grid-template-columns:repeat(2, minmax(0, 1fr)); }
	.dpa-dash .quick-grid{ grid-template-columns:repeat(3, minmax(0, 1fr)); }
	.dpa-dash .summary-grid{ grid-template-columns:repeat(2, minmax(0, 1fr)); }
}
@media (max-width:1100px){
	.dpa-dash .dashboard-main-grid{ grid-template-columns:minmax(0, 1fr); }
}
@media (max-width:640px){
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .dashboard-hero{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-date{ width:100%; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .dashboard-top{ gap:.8em; }
	.dpa-dash .top-stat-card{ padding:1.1em 1.1em; }
	.dpa-dash .top-stat-content{ flex-direction:column-reverse; gap:.7em; }
	.dpa-dash .top-stat-icon{ width:2.5em; height:2.5em; }
	.dpa-dash .dashboard-card .card-header{ padding:1em 1.1em; }
	.dpa-dash .dashboard-card .card-header p{ margin-left:0; }
	.dpa-dash .quick-actions-card .card-body{ padding:1em; }
	.dpa-dash .quick-grid{ grid-template-columns:repeat(2, minmax(0, 1fr)); }
	.dpa-dash .event-time, .dpa-dash .event-date{ min-width:4.8em; }
	.dpa-dash .summary-grid{ grid-template-columns:repeat(2, minmax(0, 1fr)); padding:1em; gap:.8em; }
	.dpa-dash .summary-box{ flex-direction:column; align-items:flex-start; gap:.7em; padding:1em; }
}
@media (max-width:380px){
	.dpa-dash .dashboard-top{ grid-template-columns:minmax(0, 1fr); }
	.dpa-dash .top-stat-content{ flex-direction:row-reverse; }
	.dpa-dash .summary-grid{ grid-template-columns:minmax(0, 1fr); }
	.dpa-dash .summary-box{ flex-direction:row; align-items:center; }
}

@media print{
	.main-content{ margin-left:0; padding:0; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
	.dpa-dash .dashboard-hero{ background:#fff; color:#000; border-color:#ccc; }
	.dpa-dash .dashboard-hero *{ color:#000 !important; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
	.dpa-dash .top-stat-card::before{ transform:scaleX(1); }
}
</style>
</head>
<body>


	<!-- =====================================================
     NAVBAR
     ===================================================== -->

	


	<!-- =====================================================
     SIDEBAR
     ===================================================== -->

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

<!-- ================= Notification ================= -->
<!-- (duplicate of the sidebar link, kept from the original file but hidden) -->

<div class="dpa-dup-link">
<a href="javascript:void(0);" onclick="openNotifications();">

    <i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg></i>

    <span>Notifications</span>

</a>
</div>

<!-- ================= Notification Overlay ================= -->

<!-- ==========================================================
     NOTIFICATION POPUP
========================================================== -->

<div id="notificationOverlay" class="notification-overlay">

    <div class="notification-popup">

        <!-- Header -->

        <div class="notification-popup-header">

            <div class="notification-header-left">

                <div class="notification-header-icon">

                    <i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg></i>

                </div>

                <div>

                    <h2>Notifications</h2>

                    <p>Stay updated with recent activities</p>

                </div>

            </div>

            <div class="notification-actions">

                <button id="markAllRead">

                    <i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 7 17l-5-5"/><path d="m22 10-7.5 7.5L13 16"/></svg></i>

                    Mark All Read

                </button>

                <button id="deleteAllBtn">

                    <i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg></i>

                    Delete All

                </button>

                <button id="closeNotification">

                    <i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i>

                </button>

            </div>

        </div>

        <!-- Notification Body -->

        <div id="notificationContainer">

        </div>

        <!-- Footer -->

        <div class="notification-footer">

            <div class="notification-total">

                <i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="3" rx="2"/><path d="m9 12 2 2 4-4"/></svg></i>

                Total Notifications :

                <strong id="totalNotifications">

                    0

                </strong>

            </div>

            <a href="javascript:void(0);" class="view-all-link" onclick="closeNotifications(); return false;">

                View All Notifications

                <i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></i>

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

        <i id="toastIcon"
           class=""><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i>

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

        <i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i>

    </button>

</div>





<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>








	<!-- =====================================================
     MAIN CONTENT
     ===================================================== -->

	<div class="main-content">

		<div class="dashboard-content dpa-dash">


			<!-- =====================================================
     WELCOME / RAPIDO STYLE HEADER
     ===================================================== -->

			<div class="dashboard-hero">

				<span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>

				<div class="hero-left">

					<div class="hero-icon">
						<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m12 14 4-4"/><path d="M3.34 19a10 10 0 1 1 17.32 0"/></svg></i>
					</div>

					<div>

						<h1>Welcome, <span class="hero-name"><%= session.getAttribute("adminName") != null ? session.getAttribute("adminName") : "Admin" %></span></h1>

						<p>Here's your business overview for today.</p>

					</div>

				</div>


				<div class="hero-date">

					<div class="hero-date-icon">
						<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg></i>
					</div>

					<div>

						<strong>${currentDate}</strong> <span>${currentTime}</span>

					</div>

				</div>

			</div>


			<!-- =====================================================
     TOP SUMMARY CARDS
     ===================================================== -->

			<div class="dashboard-top">


				<!-- TODAY'S INCOME -->

				<div class="top-stat-card stat-green reveal">

					<div class="top-stat-content">

						<div>

							<span class="stat-label"> Today's Income </span>

							<h2>₹ ${todayIncome}</h2>

							<small> Today's collected amount </small>

						</div>

						<div class="top-stat-icon">

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 3h12"/><path d="M6 8h12"/><path d="m6 13 8.5 8"/><path d="M6 13h3"/><path d="M9 13c6.667 0 6.667-10 0-10"/></svg></i>

						</div>

					</div>

				</div>


				<!-- TODAY'S EVENTS -->

				<div class="top-stat-card stat-blue reveal">

					<div class="top-stat-content">

						<div>

							<span class="stat-label"> Today's Events </span>

							<h2>${todayTotalEvents}</h2>

							<small>${todayEventCount} events + ${todayBulkEventCount} bulk</small>

						</div>

						<div class="top-stat-icon">

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><rect x="7" y="13" width="4" height="4" rx=".5"/></svg></i>

						</div>

					</div>

				</div>


				<!-- PENDING -->

				<div class="top-stat-card stat-orange reveal">

					<div class="top-stat-content">

						<div>

							<span class="stat-label"> Pending Payments </span>

							<h2>₹ ${pendingIncome}</h2>

							<small>${pendingPaymentCount} pending payments</small>

						</div>

						<div class="top-stat-icon">

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></i>

						</div>

					</div>

				</div>


				<!-- MONTHLY INCOME -->

				<div class="top-stat-card stat-purple reveal">

					<div class="top-stat-content">

						<div>

							<span class="stat-label"> Monthly Income </span>

							<h2>₹ ${totalMonthlyIncome}</h2>

							<small> Event + Bulk income </small>

						</div>

						<div class="top-stat-icon">

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 3v16a2 2 0 0 0 2 2h16"/><path d="m19 9-5 5-4-4-3 3"/></svg></i>

						</div>

					</div>

				</div>


			</div>


			<!-- =====================================================
     QUICK ACTIONS
     ===================================================== -->

			<div class="dashboard-card quick-actions-card reveal">

				<div class="card-header">

					<div>

						<h2>

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 14a1 1 0 0 1-.78-1.63l9.9-10.2a.5.5 0 0 1 .86.46l-1.92 6.02A1 1 0 0 0 13 10h7a1 1 0 0 1 .78 1.63l-9.9 10.2a.5.5 0 0 1-.86-.46l1.92-6.02A1 1 0 0 0 11 14z"/></svg></i> Quick Actions

						</h2>

						<p>Frequently used actions</p>

					</div>

				</div>


				<div class="card-body">

					<div class="quick-grid">


						<!-- ADD CUSTOMER -->

						<a href="${pageContext.request.contextPath}/add-customer"
							class="quick-link">

							<div class="quick-icon">

								<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" x2="19" y1="8" y2="14"/><line x1="22" x2="16" y1="11" y2="11"/></svg></i>

							</div>

							<div class="quick-title">Add Customer</div>

							<div class="quick-subtitle">Create new customer</div>

						</a>


						<!-- ADD EVENT -->

						<a href="${pageContext.request.contextPath}/add-event"
							class="quick-link">

							<div class="quick-icon">

								<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><path d="M21 13V6a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h8"/><path d="M3 10h18"/><path d="M16 19h6"/><path d="M19 16v6"/></svg></i>

							</div>

							<div class="quick-title">Add Event</div>

							<div class="quick-subtitle">Schedule an event</div>

						</a>


						<!-- BULK EVENT -->

						<a href="${pageContext.request.contextPath}/bulk-events"
							class="quick-link">

							<div class="quick-icon">

								<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i>

							</div>

							<div class="quick-title">Bulk Event</div>

							<div class="quick-subtitle">Manage group events</div>

						</a>


						<!-- CUSTOMERS -->

						<a href="${pageContext.request.contextPath}/customers"
							class="quick-link">

							<div class="quick-icon">

								<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i>

							</div>

							<div class="quick-title">Customers</div>

							<div class="quick-subtitle">Manage customers</div>

						</a>


						<!-- EVENTS -->

						<a href="${pageContext.request.contextPath}/events"
							class="quick-link">

							<div class="quick-icon">

								<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i>

							</div>

							<div class="quick-title">Events</div>

							<div class="quick-subtitle">View all events</div>

						</a>


						<!-- REPORTS -->

						<a href="${pageContext.request.contextPath}/reports"
							class="quick-link">

							<div class="quick-icon">

								<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 3v16a2 2 0 0 0 2 2h16"/><path d="m19 9-5 5-4-4-3 3"/></svg></i>

							</div>

							<div class="quick-title">Reports</div>

							<div class="quick-subtitle">View business reports</div>

						</a>


					</div>

				</div>

			</div>


			<!-- =====================================================
     TODAY + PENDING PAYMENTS
     ===================================================== -->

			<div class="dashboard-main-grid">


				<!-- =================================================
         TODAY'S EVENTS
         ================================================= -->

				<div class="dashboard-card reveal">

					<div class="card-header">

						<h2>

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><rect x="7" y="13" width="4" height="4" rx=".5"/></svg></i> Today's Events

						</h2>

						<a href="${pageContext.request.contextPath}/events?filter=today">

							View All </a>

					</div>


					<div class="card-body">
<%
    List<com.digitalpurohit.model.Event> todayEvents =
        (List<com.digitalpurohit.model.Event>) request.getAttribute("todayEvents");
    if (todayEvents != null && !todayEvents.isEmpty()) {
        int count = 0;
        for (com.digitalpurohit.model.Event event : todayEvents) {
            if (count++ >= 5) break;
%>
<div class="event-item">
  <div class="event-time"><i class="fa-regular fa-clock"></i><br><%= event.getEventTime() %></div>
  <div class="event-info">
    <h4><%= event.getEventTitle() %></h4>
    <p><i class="fa-solid fa-user"></i> <%= event.getCustomerName() %></p>
    <span><i class="fa-solid fa-location-dot"></i> <%= event.getLocation() != null && !event.getLocation().trim().isEmpty() ? event.getLocation() : "Location not specified" %></span>
  </div>
</div>
<%
        }
    } else {
%>
<div class="empty-box">No events scheduled for today.</div>
<% } %>
					</div>

				</div>



				<!-- =================================================
         RECENT PENDING PAYMENTS
         ================================================= -->

				<div class="dashboard-card reveal">

					<div class="card-header">

						<h2>

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg></i> Recent Pending
							Payments

						</h2>

						<a href="${pageContext.request.contextPath}/events?filter=pending">

							View All </a>

					</div>


					<div class="card-body">
<%
    List<com.digitalpurohit.model.Event> pendingPayments =
        (List<com.digitalpurohit.model.Event>) request.getAttribute("pendingPayments");
    if (pendingPayments != null && !pendingPayments.isEmpty()) {
        int count = 0;
        for (com.digitalpurohit.model.Event event : pendingPayments) {
            if (count++ >= 5) break;
%>
<div class="payment-item">
  <div class="payment-customer">
    <div class="payment-avatar"><i class="fa-solid fa-user"></i></div>
    <div>
      <strong><%= event.getCustomerName() %></strong>
      <small><%= event.getEventTitle() %></small>
      <small><i class="fa-regular fa-calendar"></i> <%= event.getEventDate() %></small>
    </div>
  </div>
  <div class="payment-right">
    <strong class="payment-amount">₹ <%= event.getPendingAmount() %></strong>
    <span class="payment-status"><%= event.getPaymentStatus() %></span>
  </div>
</div>
<%
        }
    } else {
%>
<div class="empty-box">No pending payments.</div>
<% } %>
					</div>

				</div>


			</div>


			<!-- =====================================================
     TOMORROW + UPCOMING
     ===================================================== -->

			<div class="dashboard-main-grid">


				<!-- =================================================
         TOMORROW
         ================================================= -->

				<div class="dashboard-card reveal">

					<div class="card-header">

						<h2>

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><path d="M21 13V6a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h8"/><path d="M3 10h18"/><path d="M16 19h6"/><path d="M19 16v6"/></svg></i> Tomorrow's Schedule

						</h2>

						<a
							href="${pageContext.request.contextPath}/events?filter=tomorrow">

							View All </a>

					</div>


					<div class="card-body">
<%
    List<com.digitalpurohit.model.Event> tomorrowEvents =
        (List<com.digitalpurohit.model.Event>) request.getAttribute("tomorrowEvents");
    if (tomorrowEvents != null && !tomorrowEvents.isEmpty()) {
        int count = 0;
        for (com.digitalpurohit.model.Event event : tomorrowEvents) {
            if (count++ >= 5) break;
%>
<div class="event-item">
  <div class="event-time"><i class="fa-regular fa-clock"></i><br><%= event.getEventTime() %></div>
  <div class="event-info">
    <h4><%= event.getEventTitle() %></h4>
    <p><i class="fa-solid fa-user"></i> <%= event.getCustomerName() %></p>
  </div>
</div>
<%
        }
    } else {
%>
<div class="empty-box">No events scheduled for tomorrow.</div>
<% } %>
					</div>

				</div>



				<!-- =================================================
         UPCOMING EVENTS
         ================================================= -->

				<div class="dashboard-card reveal">

					<div class="card-header">

						<h2>

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg></i> Upcoming Events

						</h2>

						<a href="${pageContext.request.contextPath}/events"> View All

						</a>

					</div>


					<div class="card-body">
<%
    List<com.digitalpurohit.model.Event> upcomingEvents =
        (List<com.digitalpurohit.model.Event>) request.getAttribute("upcomingEvents");
    if (upcomingEvents != null && !upcomingEvents.isEmpty()) {
        int count = 0;
        for (com.digitalpurohit.model.Event event : upcomingEvents) {
            if (count++ >= 5) break;
%>
<div class="event-item">
  <div class="event-date"><%= event.getEventDate() %></div>
  <div class="event-info">
    <h4><%= event.getEventTitle() %></h4>
    <p><i class="fa-solid fa-user"></i> <%= event.getCustomerName() %></p>
  </div>
</div>
<%
        }
    } else {
%>
<div class="empty-box">No upcoming events.</div>
<% } %>
					</div>

				</div>


			</div>


			<!-- =====================================================
     BUSINESS OVERVIEW
     ===================================================== -->

			<div class="dashboard-card business-overview-card reveal">


				<div class="card-header">

					<div>

						<h2>

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 3v16a2 2 0 0 0 2 2h16"/><path d="M18 17V9"/><path d="M13 17V5"/><path d="M8 17v-3"/></svg></i> Business Overview

						</h2>

						<p>Your financial summary</p>

					</div>


					<a href="${pageContext.request.contextPath}/reports"> View
						Reports </a>

				</div>


				<div class="summary-grid">


					<!-- MONTHLY TOTAL -->

					<div class="summary-box">

						<div class="summary-icon green-icon">

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/></svg></i>

						</div>

						<div>

							<h3>₹ ${totalMonthlyIncome}</h3>

							<p>Monthly Income</p>

						</div>

					</div>


					<!-- EVENT INCOME -->

					<div class="summary-box">

						<div class="summary-icon blue-icon">

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg></i>

						</div>

						<div>

							<h3>₹ ${monthlyEventIncome}</h3>

							<p>Event Income</p>

						</div>

					</div>


					<!-- BULK INCOME -->

					<div class="summary-box">

						<div class="summary-icon purple-icon">

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i>

						</div>

						<div>

							<h3>₹ ${monthlyBulkIncome}</h3>

							<p>Bulk Event Income</p>

						</div>

					</div>


					<!-- PENDING -->

					<div class="summary-box">

						<div class="summary-icon orange-icon">

							<i class=""><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 22h14"/><path d="M5 2h14"/><path d="M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22"/><path d="M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2"/></svg></i>

						</div>

						<div>

							<h3>₹ ${pendingIncome}</h3>

							<p>Pending Amount</p>

						</div>

					</div>


				</div>

			</div>


		</div>

	</div>


<!-- =====================================================
     PAGE ANIMATIONS (scroll reveal + number count-up)
     ===================================================== -->
<script>
(function () {
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var dash = document.querySelector('.dpa-dash');
	if (!dash) return;

	/* stagger siblings inside each grid */
	['.dashboard-top', '.quick-grid', '.dashboard-main-grid', '.summary-grid'].forEach(function (sel) {
		dash.querySelectorAll(sel).forEach(function (grid) {
			Array.prototype.forEach.call(grid.children, function (el, i) {
				el.style.setProperty('--d', (i * 90) + 'ms');
				if (sel === '.summary-grid' || sel === '.quick-grid') el.classList.add('reveal');
			});
		});
	});

	/* count a number up, then restore the exact original text */
	function countUp(el) {
		if (reduce || el.dataset.counted) return;
		el.dataset.counted = '1';
		var original = el.textContent;
		var m = original.trim().match(/^(\D*?)(\d[\d,]*(?:\.\d+)?)(\D*)$/);
		if (!m) return;
		var target = parseFloat(m[2].replace(/,/g, ''));
		if (!isFinite(target) || target === 0) return;
		var dec = (m[2].split('.')[1] || '').length;
		var grouped = m[2].indexOf(',') > -1;
		var start = null, dur = 1100;
		function fmt(v) {
			return v.toLocaleString(grouped ? 'en-IN' : 'en-US', { minimumFractionDigits: dec, maximumFractionDigits: dec, useGrouping: grouped });
		}
		function tick(ts) {
			if (start === null) start = ts;
			var p = Math.min((ts - start) / dur, 1);
			var e = 1 - Math.pow(1 - p, 3);
			el.textContent = m[1] + fmt(target * e) + m[3];
			if (p < 1) requestAnimationFrame(tick); else el.textContent = original;
		}
		requestAnimationFrame(tick);
	}

	function reveal(el) {
		el.classList.add('in');
		el.querySelectorAll('.top-stat-card h2, .summary-box h3').forEach(countUp);
		if (el.matches('.summary-box')) { var h = el.querySelector('h3'); if (h) countUp(h); }
	}

	var targets = dash.querySelectorAll('.reveal');
	if (!('IntersectionObserver' in window)) { targets.forEach(reveal); return; }
	var io = new IntersectionObserver(function (entries) {
		entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
	}, { threshold: 0.12, rootMargin: '0px 0px -30px 0px' });
	targets.forEach(function (t) { io.observe(t); });

	/* summary boxes have no .reveal parent of their own count-up trigger: handled above via .reveal on each box */
})();
</script>


<script>
  /* Notification panel placeholder: connect this to the notification backend when available. */
  var overlay = document.getElementById('notificationOverlay');
  function openNotifications(){
    document.getElementById('notificationContainer').innerHTML =
      '<div class="empty-box">No notifications to display.</div>';
    var total = document.getElementById('totalNotifications');
    if (total) total.textContent = '0';
    overlay.classList.add('show');
  }
  function closeNotifications(){
    if (overlay) overlay.classList.remove('show');
  }
  document.getElementById('closeNotification').addEventListener('click', closeNotifications);
  overlay.addEventListener('click', function(e){ if(e.target === overlay) overlay.classList.remove('show'); });
  // Highlight the current section using the real application route.
  (function () {
    var path = window.location.pathname.replace(/\/$/, '');
    document.querySelectorAll('.sidebar-nav a[href]').forEach(function (link) {
      var url;
      try { url = new URL(link.href, window.location.origin); } catch (e) { return; }
      var linkPath = url.pathname.replace(/\/$/, '');
      if (linkPath && linkPath === path) link.classList.add('active');
      if (linkPath.endsWith('/events') && url.searchParams.get('filter') === 'pending'
          && window.location.search.includes('filter=pending')) link.classList.add('active');
    });
  })();
</script>
</body>
</html>