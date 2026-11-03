<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.digitalpurohit.model.Event" %>
<%
    List<Event> events = (List<Event>) request.getAttribute("events");
    String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");
    String filter = request.getParameter("filter") == null ? "all" : request.getParameter("filter");
    int eventCount = events == null ? 0 : events.size();
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Events | Digital Purohit Assistant</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
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
   VIEW EVENTS — same design system as the dashboard / Events / sidebar
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
@keyframes dpaPulse{ 0%,100%{ opacity:1; } 50%{ opacity:.35; } }

/* ---------- hero buttons ---------- */
.dpa-dash .hero-actions{ display:flex; gap:.7em; flex-wrap:wrap; }
.dpa-dash .hero-btn{
	display:inline-flex; align-items:center; gap:.55em; padding:.8em 1.15em; border-radius:1em;
	border:1px solid rgba(255,255,255,.16); background:rgba(255,255,255,.07);
	-webkit-backdrop-filter:blur(10px); backdrop-filter:blur(10px);
	color:#fff; font-size:.95em; font-weight:600;
	transition:background-color .2s, border-color .2s, transform .25s cubic-bezier(.2,.8,.2,1);
}
.dpa-dash .hero-btn.green{ background:rgba(52,211,153,.18); border-color:rgba(52,211,153,.5); }
.dpa-dash .hero-btn i{ display:inline-flex; transition:transform .3s cubic-bezier(.34,1.56,.64,1); }

/* ---------- search + filters ---------- */
.dpa-dash .search-card{
	display:grid; gap:1em; margin:0; padding:1.1em 1.3em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); transition:background-color .35s, border-color .35s;
}
.dpa-dash .search-form{ display:flex; align-items:center; gap:.8em; margin:0; }
.dpa-dash .search-field{
	flex:1; min-width:0; display:flex; align-items:center; gap:.7em; padding:0 1em;
	border-radius:.75em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:border-color .2s, box-shadow .2s;
}
.dpa-dash .search-field:focus-within{ border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.2); }
.dpa-dash .search-field i{ color:var(--dpa-muted); transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .search-field:focus-within i{ color:var(--dpa-link); transform:scale(1.12); }
.dpa-dash .search-field input{
	flex:1; min-width:0; width:100%; margin:0; padding:.9em 0; border:0; outline:0; box-shadow:none; background:transparent;
	font-family:inherit; font-size:1em; font-weight:500; color:var(--dpa-text);
}
.dpa-dash .search-field input::placeholder{ color:var(--dpa-muted); opacity:.8; font-weight:400; }
.dpa-dash .btn-search{
	display:inline-flex; align-items:center; gap:.55em; margin:0; padding:.85em 1.3em; border-radius:.8em;
	border:1px solid var(--dpa-twilight); background:var(--dpa-twilight); box-shadow:none;
	font-family:inherit; font-size:.95em; font-weight:700; line-height:1.2; color:#fff; cursor:pointer;
	transition:filter .2s, transform .25s cubic-bezier(.2,.8,.2,1), box-shadow .25s;
}
.dpa-dash .btn-search i{ display:inline-flex; transition:transform .35s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .btn-search:active{ transform:scale(.96); }
.dpa-dash .filters{ display:flex; flex-wrap:wrap; align-items:center; gap:.5em; }
.dpa-dash .filter{
	display:inline-flex; align-items:center; gap:.55em; padding:.62em 1.1em; border-radius:999px;
	border:1px solid var(--dpa-border); background:var(--dpa-surface-2); color:var(--dpa-text);
	font-size:.92em; font-weight:600; line-height:1.2; white-space:nowrap;
	transition:background-color .2s, color .2s, border-color .2s, transform .25s cubic-bezier(.2,.8,.2,1);
}
.dpa-dash .filter i{ display:inline-flex; transition:transform .35s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .filter.active{ background:var(--dpa-active-bg); color:var(--dpa-active-text); border-color:var(--dpa-active-bg); }
.dpa-dash .filter:active{ transform:scale(.96); }
.dpa-dash .result-count{ margin-left:auto; font-size:.86em; font-weight:600; color:var(--dpa-muted); font-variant-numeric:tabular-nums; }

/* ---------- event cards ---------- */
.dpa-dash .events-grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(min(100%, 27em), 1fr)); gap:1.1em; margin:0; }
.dpa-dash .event-card{
	--acc:#ff6b6b;
	position:relative; overflow:hidden; display:flex; flex-direction:column; gap:1.1em; min-width:0;
	margin:0; padding:1.4em 1.5em 1.3em 1.75em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s, box-shadow .3s;
}
.dpa-dash .event-card.s-paid{ --acc:#34d399; }
.dpa-dash .event-card.s-partial{ --acc:#f0a43a; }
.dpa-dash .event-card.s-pending{ --acc:#ff6b6b; }
.dpa-dash .event-card::before{
	content:""; position:absolute; left:0; top:0; bottom:0; width:.38em; background:var(--acc);
	transform:scaleY(0); transform-origin:top; transition:transform .9s cubic-bezier(.2,.8,.2,1) .3s;
}
.dpa-dash .event-card.in::before, html:not(.dpa-js) .dpa-dash .event-card::before{ transform:scaleY(1); }
.dpa-dash .event-header{
	display:flex; align-items:flex-start; justify-content:space-between; gap:1em;
	padding-bottom:1em; border-bottom:1px solid var(--dpa-border);
}
.dpa-dash .event-title{ display:flex; align-items:center; gap:.7em; min-width:0; font-size:1.15em; font-weight:700; letter-spacing:-.01em; line-height:1.25; }
.dpa-dash .event-title i{
	flex-shrink:0; width:2.2em; height:2.2em; font-size:.9em; border-radius:.7em;
	display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile); color:var(--dpa-text);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .event-title span{ overflow-wrap:anywhere; }
.dpa-dash .status{
	flex-shrink:0; display:inline-flex; align-items:center; gap:.5em; padding:.3em .9em; border-radius:999px;
	font-size:.74em; font-weight:700; letter-spacing:.06em; text-transform:uppercase; white-space:nowrap;
}
.dpa-dash .status::before{ content:""; width:.5em; height:.5em; border-radius:50%; background:currentColor; }
.dpa-dash .status.pending{ background:rgba(255,107,107,.15); color:var(--bad2); }
.dpa-dash .status.pending::before{ animation:dpaPulse 1.6s ease-in-out infinite; }
.dpa-dash .status.partial{ background:rgba(240,164,58,.16); color:var(--pend); }
.dpa-dash .status.paid{ background:rgba(52,211,153,.15); color:var(--good); }

.dpa-dash .info-grid{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:.9em 1em; }
.dpa-dash .info{ display:flex; align-items:center; gap:.75em; min-width:0; }
.dpa-dash .info.full{ grid-column:1 / -1; }
.dpa-dash .info > i{
	flex-shrink:0; width:2.4em; height:2.4em; font-size:.92em; border-radius:.75em;
	display:flex; align-items:center; justify-content:center; background:var(--dpa-tile); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .info > div{ min-width:0; }
.dpa-dash .info .l{ display:block; font-size:.68em; font-weight:700; letter-spacing:.09em; text-transform:uppercase; color:var(--dpa-muted); }
.dpa-dash .info strong{ display:block; margin-top:.1em; font-size:.95em; font-weight:600; overflow-wrap:anywhere; }

.dpa-dash .actions{ display:flex; flex-wrap:wrap; gap:.55em; margin-top:auto; padding-top:1em; border-top:1px solid var(--dpa-border); }
.dpa-dash .action-btn{
	--abc:#2b7fff;
	flex:1 1 auto; display:inline-flex; align-items:center; justify-content:center; gap:.5em;
	margin:0; padding:.62em .9em; border-radius:.75em; border:1px solid var(--abc); background:transparent;
	font-family:inherit; font-size:.88em; font-weight:700; line-height:1.2; color:var(--abc); white-space:nowrap;
	transition:background-color .2s, color .2s, transform .25s cubic-bezier(.2,.8,.2,1), box-shadow .25s;
}
.dpa-dash .action-btn i{ display:inline-flex; transition:transform .35s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .action-btn.view{ --abc:#2b7fff; }
.dpa-dash .action-btn.edit{ --abc:#f0a43a; }
.dpa-dash .action-btn.payment{ --abc:#1fbf6a; }
.dpa-dash .action-btn.delete{ --abc:#ff6b6b; }
.dpa-dash .action-btn:active{ transform:scale(.96); }

.dpa-dash .empty-card{
	grid-column:1 / -1; display:flex; flex-direction:column; align-items:center; gap:.5em; text-align:center;
	padding:3em 1em; border-radius:1.15em; border:1px solid var(--dpa-border); background:var(--dpa-surface);
}
.dpa-dash .empty-card > i{ font-size:3.6em; color:var(--dpa-muted); opacity:.55; animation:dpaBob 3.4s ease-in-out infinite; }
.dpa-dash .empty-card h2{ margin-top:.3em; font-size:1.4em; font-weight:700; }
.dpa-dash .empty-card p{ font-size:1em; font-weight:400; color:var(--dpa-muted); }
@keyframes dpaBob{ 0%,100%{ transform:translateY(0); } 50%{ transform:translateY(-8px); } }

.dpa-dash .events-footer{
	display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:1em;
	margin:0; padding:1.1em 1.4em; border-radius:1.15em; border:1px solid var(--dpa-border); background:var(--dpa-surface);
}
.dpa-dash .events-footer h3{ display:flex; align-items:center; gap:.65em; font-size:1.05em; font-weight:700; }
.dpa-dash .events-footer h3 i{ width:2.2em; height:2.2em; font-size:.9em; border-radius:.7em; display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile); }
.dpa-dash .events-footer h3 b{ color:var(--dpa-link); font-variant-numeric:tabular-nums; }
.dpa-dash .footer-actions{ display:flex; gap:.6em; flex-wrap:wrap; }
.dpa-dash .btn-plain{
	display:inline-flex; align-items:center; gap:.55em; padding:.7em 1.15em; border-radius:.8em;
	border:1px solid var(--dpa-border); background:var(--dpa-surface-2); color:var(--dpa-text); font-size:.92em; font-weight:600;
	transition:background-color .2s, color .2s, border-color .2s, transform .25s cubic-bezier(.2,.8,.2,1);
}
.dpa-dash .btn-plain.green{ border-color:var(--good); color:var(--good); background:transparent; }
.dpa-dash .btn-plain i{ display:inline-flex; transition:transform .35s cubic-bezier(.34,1.56,.64,1); }

/* ---------- scroll to top ---------- */
#scrollBtn{
	position:fixed; right:calc(22px + env(safe-area-inset-right, 0px)); bottom:calc(22px + env(safe-area-inset-bottom, 0px));
	width:3.2em; height:3.2em; border-radius:50%; border:1px solid var(--dpa-border); z-index:900;
	background:var(--dpa-twilight); color:#fff; font-size:17px; cursor:pointer;
	display:flex; align-items:center; justify-content:center;
	box-shadow:0 10px 26px rgba(0,0,0,.35);
	opacity:0; pointer-events:none; transform:translateY(14px) scale(.9);
	transition:opacity .3s, transform .3s cubic-bezier(.34,1.56,.64,1), background-color .2s;
}
#scrollBtn.show{ opacity:1; pointer-events:auto; transform:none; }
#scrollBtn:active{ transform:scale(.92); }

/* ---------- hover (mouse only) ---------- */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ background:rgba(255,255,255,.14); border-color:rgba(255,255,255,.35); transform:translateY(-2px); }
	.dpa-dash .hero-btn.green:hover{ background:rgba(52,211,153,.32); }
	.dpa-dash .hero-btn:hover i{ transform:rotate(-10deg) scale(1.15); }
	.dpa-dash .search-field:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .btn-search:hover{ filter:brightness(1.18); transform:translateY(-2px); box-shadow:0 8px 20px rgba(66,97,136,.4); }
	.dpa-dash .btn-search:hover i{ transform:rotate(-12deg) scale(1.15); }
	.dpa-dash .filter:hover{ background:var(--dpa-hover); border-color:var(--dpa-twilight); transform:translateY(-2px); }
	.dpa-dash .filter.active:hover{ background:var(--dpa-active-bg); }
	.dpa-dash .filter:hover i{ transform:rotate(-10deg) scale(1.15); }
	.dpa-dash .event-card:hover{ transform:translateY(-6px); border-color:var(--acc); box-shadow:0 18px 40px rgba(0,0,0,.3); }
	.dpa-dash .event-card:hover .event-title i{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .event-card:hover .info > i{ background:var(--acc); color:#fff; }
	.dpa-dash .action-btn:hover{ background:var(--abc); color:#fff; transform:translateY(-2px); box-shadow:0 8px 18px rgba(0,0,0,.3); }
	.dpa-dash .action-btn:hover i{ transform:rotate(-12deg) scale(1.15); }
	.dpa-dash .btn-plain:hover{ background:var(--dpa-hover); border-color:var(--dpa-twilight); transform:translateY(-2px); }
	.dpa-dash .btn-plain.green:hover{ background:var(--good); color:#fff; border-color:var(--good); }
	.dpa-dash .btn-plain:hover i{ transform:rotate(-10deg) scale(1.15); }
	#scrollBtn:hover{ background:var(--dpa-link); transform:translateY(-4px); }
}
.dpa-dash a:focus-visible, .dpa-dash button:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* ---------- responsive ---------- */
@media (max-width:700px){
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-actions, .dpa-dash .hero-btn{ width:100%; justify-content:center; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .search-form{ flex-wrap:wrap; }
	.dpa-dash .btn-search{ flex:1; justify-content:center; }
	.dpa-dash .filter{ flex:1 1 auto; justify-content:center; }
	.dpa-dash .result-count{ width:100%; margin-left:0; text-align:center; }
	.dpa-dash .event-card{ padding:1.2em 1.2em 1.1em 1.5em; }
	.dpa-dash .info-grid{ grid-template-columns:minmax(0, 1fr); }
	.dpa-dash .action-btn{ flex:1 1 40%; }
	.dpa-dash .events-footer{ flex-direction:column; align-items:stretch; text-align:center; }
	.dpa-dash .events-footer h3, .dpa-dash .footer-actions{ justify-content:center; }
}
@media print{
	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1 !important; animation:none !important; }
	.dpa-dash .hero-watermark, .dpa-dash .hero-actions, .dpa-dash .search-card, .dpa-dash .actions, .dpa-dash .events-footer, #scrollBtn{ display:none; }
	.dpa-dash{ --dpa-text:#000; --dpa-muted:#444; --dpa-surface:#fff; --dpa-surface-2:#fff; --dpa-border:#bbb; --dpa-tile:#eee; }
	.dpa-dash .page-header{ background:#fff; color:#000; border-color:#bbb; }
	.dpa-dash .page-header *{ color:#000 !important; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
	.dpa-dash .event-card::before{ transform:scaleY(1); }
	#scrollBtn{ transition:none; }
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



<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />
<%@ include file="../partials/toast.jsp" %>

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

<script>
    const contextPath = "";
</script>

<div class="main-content">

  <div class="view-events-page dpa-dash">

    <!-- ================= PAGE HEADER ================= -->
    <div class="page-header">

        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>

        <div class="hero-left">

            <div class="hero-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg></i></div>

            <div>
                <h1>View Events</h1>
                <p>Manage all your customer events.</p>
            </div>

        </div>

        <div class="hero-actions">

            <a href="${pageContext.request.contextPath}/add-event" class="hero-btn green">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14"/><path d="M12 5v14"/></svg></i>
                Add Event
            </a>

            <a href="${pageContext.request.contextPath}/events" class="hero-btn">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"/><path d="M3 10a2 2 0 0 1 .709-1.528l7-5.999a2 2 0 0 1 2.582 0l7 5.999A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg></i>
                Dashboard
            </a>

        </div>

    </div>

    <!-- ================= SEARCH + FILTERS ================= -->
    <div class="search-card reveal">

        <form class="search-form" method="get" action="${pageContext.request.contextPath}/view-events">

            <label class="search-field">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>
                <input type="text" name="keyword" id="keywordInput" autocomplete="off"
                       placeholder="Search customer, event or phone..."
                       value="<%= keyword.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>">
            </label>

            <button class="btn-search" type="submit">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>
                Search
            </button>

        </form>

        <div class="filters">

            <a class="filter <%= "all".equals(filter) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/view-events?filter=all">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 12h.01"/><path d="M3 18h.01"/><path d="M3 6h.01"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M8 6h13"/></svg></i>
                All
            </a>

            <a class="filter <%= "today".equals(filter) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/view-events?filter=today">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg></i>
                Today's
            </a>

            <a class="filter <%= "upcoming".equals(filter) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/view-events?filter=upcoming">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></i>
                Upcoming
            </a>

            <a class="filter <%= "pending".equals(filter) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/view-events?filter=pending">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 22h14"/><path d="M5 2h14"/><path d="M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22"/><path d="M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2"/></svg></i>
                Pending Payments
            </a>

            <span class="result-count"><%= eventCount %> event<%= eventCount == 1 ? "" : "s" %></span>

        </div>

    </div>

    <!-- ================= DYNAMIC EVENTS ================= -->
    <div class="events-grid">
    <%
        if (events != null && !events.isEmpty()) {
            for (Event event : events) {
                String status = event.getPaymentStatus();
                if (status == null || status.trim().isEmpty()) status = "PENDING";
                status = status.trim().toUpperCase();
                String statusClass = "PENDING".equals(status) ? "pending" : ("PARTIAL".equals(status) ? "partial" : ("PAID".equals(status) ? "paid" : "pending"));
                String title = event.getEventTitle() == null ? "Event" : event.getEventTitle();
                String customer = event.getCustomerName() == null ? "—" : event.getCustomerName();
                String phone = event.getPhone() == null ? "—" : event.getPhone();
                String date = event.getEventDate() == null ? "—" : String.valueOf(event.getEventDate());
                String time = event.getEventTime() == null ? "—" : String.valueOf(event.getEventTime());
                String location = event.getLocation() == null ? "—" : event.getLocation();
    %>
      <article class="event-card s-<%= statusClass %> reveal">
        <div class="event-header">
          <div class="event-title"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg></i><span><%= title %></span></div>
          <span class="status <%= statusClass %>"><%= status %></span>
        </div>
        <div class="info-grid">
          <div class="info"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i><div><span class="l">Customer</span><strong><%= customer %></strong></div></div>
          <div class="info"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg></i><div><span class="l">Phone</span><strong><%= phone %></strong></div></div>
          <div class="info"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg></i><div><span class="l">Date</span><strong><%= date %></strong></div></div>
          <div class="info"><i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></i><div><span class="l">Time</span><strong><%= time %></strong></div></div>
          <div class="info full"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg></i><div><span class="l">Location</span><strong><%= location %></strong></div></div>
        </div>
        <div class="actions">
          <a class="action-btn view" href="${pageContext.request.contextPath}/view-event?id=<%= event.getEventId() %>"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/><circle cx="12" cy="12" r="3"/></svg></i> View</a>
          <a class="action-btn edit" href="${pageContext.request.contextPath}/edit-event?id=<%= event.getEventId() %>"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/><path d="m15 5 4 4"/></svg></i> Edit</a>
          <% if (!"PAID".equals(status)) { %><a class="action-btn payment" href="${pageContext.request.contextPath}/event-pending-payments"><i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg></i> Payment</a><% } %>
          <form method="post" action="${pageContext.request.contextPath}/delete-event" onsubmit="return confirm('Are you sure you want to delete this event?');" style="display:contents"><input type="hidden" name="eventId" value="<%= event.getEventId() %>"><button class="action-btn delete" type="submit"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg></i> Delete</button></form>
        </div>
      </article>
    <% } } else { %>
      <div class="empty-card reveal"><i class="fa-regular fa-calendar-xmark" aria-hidden="true"></i><h2>No Events Found</h2><p>There are no events matching your search.</p><a class="btn-plain green" href="${pageContext.request.contextPath}/add-event"><i class="fa-solid fa-plus"></i> Add Event</a></div>
    <% } %>
    </div>

    <div class="events-footer reveal">

        <h3>
            <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg></i>
            <span>Total Events : <b><%= eventCount %></b></span>
        </h3>

        <div class="footer-actions">

            <a href="${pageContext.request.contextPath}/events" class="btn-plain">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"/><path d="M3 10a2 2 0 0 1 .709-1.528l7-5.999a2 2 0 0 1 2.582 0l7 5.999A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg></i>
                Dashboard
            </a>

            <a href="${pageContext.request.contextPath}/add-event" class="btn-plain green">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14"/><path d="M12 5v14"/></svg></i>
                Add Event
            </a>

        </div>

    </div>

  </div>

</div>

<!-- Scroll To Top -->
<button id="scrollBtn" type="button" aria-label="Scroll to top"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m5 12 7-7 7 7"/><path d="M12 19V5"/></svg></i></button>

<!-- page behaviour: card reveal, scroll-to-top, search focus -->
<script>
(function () {
	var page = document.querySelector('.dpa-dash');
	if (!page) return;

	/* stagger: header blocks first, then the cards one after another */
	var cards = page.querySelectorAll('.event-card, .empty-card');
	Array.prototype.forEach.call(cards, function (el, i) { el.style.setProperty('--d', (Math.min(i, 9) * 80) + 'ms'); });

	var targets = page.querySelectorAll('.reveal');
	if (!('IntersectionObserver' in window)) { targets.forEach(function (t) { t.classList.add('in'); }); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { en.target.classList.add('in'); io.unobserve(en.target); } });
		}, { threshold: 0.08, rootMargin: '0px 0px -30px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}

	/* scroll to top button */
	var btn = document.getElementById('scrollBtn');
	function toggle() { btn.classList.toggle('show', window.scrollY > 250); }
	window.addEventListener('scroll', toggle, { passive: true }); toggle();
	btn.addEventListener('click', function () { window.scrollTo({ top: 0, behavior: 'smooth' }); });

	/* auto focus the search box (desktop only, so phones do not pop the keyboard) */
	var search = document.getElementById('keywordInput');
	if (search && window.matchMedia('(hover:hover) and (pointer:fine)').matches) search.focus({ preventScroll: true });
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
  // View Events belongs to the "Events" section of the sidebar.
  if (!any) {
    document.querySelectorAll('.sidebar-nav a[href]').forEach(function (link) {
      try {
        if (new URL(link.getAttribute('href'), window.location.href).pathname.replace(/\/+$/, '').endsWith('/events')) link.classList.add('active');
      } catch (e) {}
    });
  }
})();
</script>
<script>
/* preview-only: opens the notification popup (the real page uses assets/js/notification.js) */
function openNotifications(){ document.getElementById('notificationContainer').innerHTML='<div style="color:#6b7280;text-align:center;padding:20px">No notifications to display.</div>'; document.getElementById('notificationOverlay').classList.add('show'); }

</script>
</body>
</html>