<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.Month" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.digitalpurohit.model.CalendarDay" %>
<%
List<CalendarDay> calendarDays = (List<CalendarDay>) request.getAttribute("calendarDays");
Integer month = (Integer) request.getAttribute("month");
Integer year = (Integer) request.getAttribute("year");
CalendarDay selectedDay = (CalendarDay) request.getAttribute("selectedDay");
LocalDate today = LocalDate.now();
if (month == null) month = today.getMonthValue();
if (year == null) year = today.getYear();
String monthName = Month.of(month).getDisplayName(TextStyle.FULL, Locale.ENGLISH);
String selectedDateText = selectedDay != null && selectedDay.getDate() != null ? String.valueOf(selectedDay.getDate()) : today.toString();
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Telugu Calendar | Digital Purohit Assistant</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Anton&family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap" rel="stylesheet">
<style>
  /* ---- base: icon sizing + notification popup layout ---- */
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
   TELUGU CALENDAR — same design system as dashboard / payments / reports
   Colours come from the shared theme variables (--dpa-*), so the dark /
   light switch restyles this page too. Sizes are in em (scales on big monitors).
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
	max-width:108em; margin:0 auto;
	display:flex; flex-direction:column; gap:1.5em;
	font-family:'Inter', ui-sans-serif, system-ui, sans-serif;
	font-size:calc(14px * var(--dk)); font-weight:500; line-height:1.45;
	color:var(--dpa-text);
	-webkit-font-smoothing:antialiased;
}
:root[data-theme="light"] .dpa-dash{ --good:#168a4a; --pend:#b45f06; --bad2:#c93434; }
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
@keyframes dpaPop{ from{ opacity:0; transform:translateY(10px) scale(.94); } to{ opacity:1; transform:none; } }
@keyframes dpaSwap{ from{ opacity:0; translate:0 8px; } to{ opacity:1; translate:0 0; } }
@keyframes dpaPulse{ 0%{ box-shadow:0 0 0 0 rgba(43,127,255,.55); } 70%,100%{ box-shadow:0 0 0 9px rgba(43,127,255,0); } }
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
	background:radial-gradient(circle, rgba(240,164,58,.34), rgba(240,164,58,0) 70%);
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
.dpa-dash .hero-date{
	display:flex; align-items:center; gap:.9em; padding:.85em 1.15em;
	border-radius:1em; border:1px solid rgba(255,255,255,.16);
	background:rgba(255,255,255,.07); -webkit-backdrop-filter:blur(10px); backdrop-filter:blur(10px); color:#fff;
}
.dpa-dash .hero-date-icon{
	width:2.6em; height:2.6em; border-radius:.8em; flex-shrink:0;
	display:flex; align-items:center; justify-content:center; background:rgba(255,255,255,.12); color:#fff;
}
.dpa-dash .hero-date strong{ display:block; font-size:1.02em; font-weight:600; }
.dpa-dash .hero-date span{ display:block; margin-top:.1em; font-size:.88em; color:rgba(255,255,255,.7); font-variant-numeric:tabular-nums; }

/* =====================================================================
   TOOLBAR + SEARCH
   ===================================================================== */
.dpa-dash .calendar-toolbar, .dpa-dash .search-bar{
	margin:0; padding:1em 1.3em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); transition:background-color .35s, border-color .35s;
}
.dpa-dash .calendar-toolbar{ display:flex; align-items:center; justify-content:space-between; gap:.9em; flex-wrap:wrap; }
.dpa-dash .month-title{
	flex:1; min-width:10em; text-align:center;
	font-size:1.7em; font-weight:700; letter-spacing:-.02em; color:var(--dpa-text);
}
.dpa-dash .month-title span{ font-family:'Caveat', cursive; font-style:italic; font-weight:600; color:var(--dpa-twilight); font-size:1.15em; margin-left:.15em; }
.dpa-dash .nav-btn, .dpa-dash .import-btn, .dpa-dash .search-btn{
	display:inline-flex; align-items:center; justify-content:center; gap:.55em; margin:0; padding:.7em 1.15em;
	border-radius:.8em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2); box-shadow:none;
	font-family:inherit; font-size:.92em; font-weight:600; line-height:1.2; color:var(--dpa-text); white-space:nowrap; cursor:pointer;
	transition:background-color .2s, color .2s, border-color .2s, transform .25s cubic-bezier(.2,.8,.2,1);
}
.dpa-dash .nav-btn i{ display:inline-flex; transition:transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .import-btn{ border-color:var(--good); color:var(--good); background:transparent; }
.dpa-dash .search-btn{ border-color:var(--dpa-twilight); background:var(--dpa-twilight); color:#fff; }
.dpa-dash .nav-btn:active, .dpa-dash .import-btn:active, .dpa-dash .search-btn:active{ transform:scale(.96); }

.dpa-dash .search-bar form{ display:flex; align-items:center; gap:.8em; margin:0; }
.dpa-dash .search-field{
	flex:1; min-width:0; display:flex; align-items:center; gap:.7em; padding:0 1em;
	border-radius:.75em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:border-color .2s, box-shadow .2s;
}
.dpa-dash .search-field:focus-within{ border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.2); }
.dpa-dash .search-field i{ color:var(--dpa-muted); transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .search-field:focus-within i{ color:var(--dpa-link); transform:scale(1.12); }
.dpa-dash .search-field input{
	flex:1; min-width:0; width:100%; margin:0; padding:.85em 0; border:0; outline:0; box-shadow:none; background:transparent;
	font-family:inherit; font-size:1em; font-weight:500; color:var(--dpa-text); color-scheme:inherit;
}

/* =====================================================================
   CALENDAR GRID
   ===================================================================== */
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
	border:1px solid var(--dpa-border); color:var(--dpa-muted); font-variant-numeric:tabular-nums;
}
.dpa-dash .calendar-grid{ display:grid; grid-template-columns:repeat(7, minmax(0, 1fr)); gap:.5em; padding:1em 1.2em 1.3em; }
.dpa-dash .day-header{
	padding:.55em 0; text-align:center;
	font-size:.74em; font-weight:700; letter-spacing:.1em; text-transform:uppercase; color:var(--dpa-muted);
}
.dpa-dash .day-header:first-child{ color:var(--bad2); }

.dpa-dash .day-card{
	position:relative; display:flex; flex-direction:column; align-items:flex-start; gap:.3em; overflow:hidden;
	min-height:7.6em; padding:.7em .75em .8em; border-radius:.9em;
	border:1px solid var(--dpa-border); background:var(--dpa-surface-2); cursor:pointer; outline:0;
	animation:dpaPop .5s cubic-bezier(.2,.8,.2,1) var(--w, 0ms) both;
	transition:transform .25s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .25s, box-shadow .25s;
}
.dpa-dash .day-card.other-month{ opacity:.42; }
.dpa-dash .day-number{
	min-width:1.9em; height:1.9em; padding:0 .3em; display:flex; align-items:center; justify-content:center;
	border-radius:999px; font-size:1.02em; font-weight:700; font-variant-numeric:tabular-nums;
}
.dpa-dash .day-card.today .day-number{ background:var(--dpa-link); color:#fff; animation:dpaPulse 2.4s ease-out infinite; }
.dpa-dash .day-card.today{ border-color:rgba(43,127,255,.55); }
.dpa-dash .day-card.selected{
	border-color:var(--dpa-link); background:rgba(43,127,255,.13); box-shadow:0 0 0 3px rgba(43,127,255,.24);
}
.dpa-dash .day-tithi{
	font-size:.76em; font-weight:500; line-height:1.3; color:var(--dpa-muted);
	display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden;
}
.dpa-dash .day-tithi:empty{ display:none; }
.dpa-dash .day-festival, .dpa-dash .event-badge{
	display:flex; align-items:flex-start; gap:.4em; max-width:100%;
	padding:.25em .55em; border-radius:.6em; font-size:.7em; font-weight:700; line-height:1.25;
}
.dpa-dash .day-festival{ background:rgba(240,164,58,.16); color:var(--pend); }
.dpa-dash .day-festival i{ flex-shrink:0; margin-top:.05em; }
.dpa-dash .event-badge{ align-items:center; background:rgba(52,211,153,.15); color:var(--good); }
.dpa-dash .event-badge::before{ content:""; flex-shrink:0; width:.55em; height:.55em; border-radius:50%; background:currentColor; }

/* =====================================================================
   DETAILS
   ===================================================================== */
.dpa-dash .details-grid{ display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:.9em; padding:1.1em 1.3em 1.3em; }
.dpa-dash .detail-item{
	display:flex; align-items:center; gap:.9em; min-width:0; padding:1em 1.1em;
	border-radius:1em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .detail-item.full-width{ grid-column:1 / -1; }
.dpa-dash .di-icon{
	flex-shrink:0; width:2.7em; height:2.7em; border-radius:.9em; font-size:1.05em;
	display:flex; align-items:center; justify-content:center; background:var(--dpa-tile); color:var(--dpa-text);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .detail-item > div:last-child{ min-width:0; }
.dpa-dash .detail-item span{
	display:block; font-size:.72em; font-weight:700; letter-spacing:.09em; text-transform:uppercase; color:var(--dpa-muted);
}
.dpa-dash .detail-item strong{ display:block; margin-top:.2em; font-size:1em; font-weight:600; overflow-wrap:anywhere; }
.dpa-dash .details-grid.swap .detail-item{ animation:dpaSwap .4s cubic-bezier(.2,.8,.2,1) both; }
.dpa-dash .empty-details{
	display:flex; flex-direction:column; align-items:center; gap:.5em; padding:2.6em 1em; text-align:center; color:var(--dpa-muted);
}
.dpa-dash .empty-details i{ font-size:2.4em; opacity:.6; animation:dpaBob 3.4s ease-in-out infinite; }
.dpa-dash .empty-details p{ font-size:1em; color:var(--dpa-text); opacity:.85; }

.dpa-dash .calendar-footer{ text-align:center; font-size:.86em; font-weight:400; color:var(--dpa-muted); padding:.4em 0 .8em; }

/* =====================================================================
   HOVER — mouse only
   ===================================================================== */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .day-card:hover{ transform:translateY(-4px); border-color:var(--dpa-twilight); background:var(--dpa-hover); }
	.dpa-dash .day-card.selected:hover{ border-color:var(--dpa-link); background:rgba(43,127,255,.18); }
	.dpa-dash .nav-btn:hover{ background:var(--dpa-hover); border-color:var(--dpa-twilight); transform:translateY(-2px); }
	.dpa-dash .nav-btn.prev:hover i{ transform:translateX(-3px); }
	.dpa-dash .nav-btn.next:hover i{ transform:translateX(3px); }
	.dpa-dash .import-btn:hover{ background:var(--good); color:#06140d; transform:translateY(-2px); }
	.dpa-dash .search-btn:hover{ filter:brightness(1.15); transform:translateY(-2px); }
	.dpa-dash .search-field:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .detail-item:hover{ transform:translateY(-3px); border-color:var(--dpa-twilight); }
	.dpa-dash .detail-item:hover .di-icon{ transform:rotate(-8deg) scale(1.1); background:var(--dpa-twilight); color:#fff; }
}
.dpa-dash a:focus-visible, .dpa-dash button:focus-visible, .dpa-dash .day-card:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* =====================================================================
   RESPONSIVE
   ===================================================================== */
@media (max-width:1100px){
	.dpa-dash .details-grid{ grid-template-columns:repeat(2, minmax(0, 1fr)); }
	.dpa-dash .day-card{ min-height:6.4em; }
}
@media (max-width:700px){
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-date{ width:100%; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .calendar-toolbar{ padding:.9em; }
	.dpa-dash .month-title{ order:-1; flex-basis:100%; }
	.dpa-dash .nav-btn{ flex:1; }
	.dpa-dash .import-btn{ flex-basis:100%; }
	.dpa-dash .search-bar form{ flex-wrap:wrap; }
	.dpa-dash .search-btn{ flex:1; }
	.dpa-dash .section-top{ padding:1em 1.1em; }
	.dpa-dash .calendar-grid{ gap:.3em; padding:.8em .6em 1em; }
	.dpa-dash .day-header{ font-size:.66em; letter-spacing:.04em; }
	.dpa-dash .day-card{ min-height:4.4em; padding:.4em .2em; align-items:center; border-radius:.7em; }
	.dpa-dash .day-number{ font-size:.95em; }
	.dpa-dash .day-tithi{ display:none; }
	/* festivals / events shrink to small dots on phones (full text is in the details card) */
	.dpa-dash .day-festival{ width:.6em; height:.6em; padding:0; border-radius:50%; background:var(--pend); }
	.dpa-dash .day-festival i, .dpa-dash .day-festival .fest-text{ display:none; }
	.dpa-dash .event-badge{ padding:.1em .4em; font-size:.66em; }
	.dpa-dash .event-badge .ev-text{ display:none; }
	.dpa-dash .details-grid{ grid-template-columns:minmax(0, 1fr); padding:.9em; }
}

@media print{
	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-dash{ --dpa-text:#000; --dpa-muted:#444; --dpa-surface:#fff; --dpa-surface-2:#fff; --dpa-border:#bbb; --dpa-tile:#eee; }
	.dpa-js .dpa-dash .reveal, .dpa-dash .day-card{ opacity:1 !important; animation:none !important; }
	.dpa-dash .page-header{ background:#fff; color:#000; border-color:#bbb; }
	.dpa-dash .page-header *{ color:#000 !important; }
	.dpa-dash .hero-watermark, .dpa-dash .calendar-toolbar .nav-btn, .dpa-dash .import-btn, .dpa-dash .search-bar{ display:none; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal, .dpa-dash .day-card{ opacity:1; }
}
</style>
<style>
.calendar-empty{grid-column:1/-1;padding:28px;text-align:center;color:var(--dpa-muted, #9ca3af);}
.calendar-tabs{display:flex;flex-wrap:wrap;gap:10px;}
.calendar-tabs .tab-button{border:1px solid var(--dpa-border, #303744);border-radius:10px;padding:10px 14px;background:var(--dpa-card, #11151d);color:var(--dpa-text, #f3f4f6);font:inherit;cursor:pointer;}
.calendar-tabs .tab-button.active{background:var(--dpa-accent, #2b7fff);color:#fff;border-color:transparent;}
.tab-pane{display:none;padding:18px;}
.tab-pane.active{display:block;}
.tab-summary{padding:18px;color:var(--dpa-muted, #9ca3af);}

.day-card{display:block;color:inherit;}
.day-event{display:block;margin-top:5px;font-size:.68em;line-height:1.25;color:var(--dpa-accent, #f0a43a);overflow-wrap:anywhere;}
.search-field input{min-width:0;}
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

<div class="main-content">

  <div class="calendar-page dpa-dash">

    <!-- ================= HEADER ================= -->
    <div class="page-header calendar-header">

        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>

        <div class="hero-left">

            <div class="hero-icon">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i>
            </div>

            <div>
                <h1>Telugu Calendar</h1>
                <p>Digital Purohit Assistant</p>
            </div>

        </div>

        <div class="hero-date today-box">
            <div class="hero-date-icon">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></i>
            </div>
            <div>
                <strong>Today</strong>
                <span><%=today%></span>
            </div>
        </div>

    </div>

    <!-- ================= TOOLBAR ================= -->
    <div class="calendar-toolbar reveal">

        <a class="nav-btn prev"
           href="${pageContext.request.contextPath}/calendar?month=<%=month==1?12:month-1%>&amp;year=<%=month==1?year-1:year%>">
            <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m15 18-6-6 6-6"/></svg></i>
            Previous
        </a>

        <h2 class="month-title"><%=monthName%> <span><%=year%></span></h2>

        <a class="nav-btn next"
           href="${pageContext.request.contextPath}/calendar?month=<%=month==12?1:month+1%>&amp;year=<%=month==12?year+1:year%>">
            Next
            <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m9 18 6-6-6-6"/></svg></i>
        </a>

        <a class="import-btn" href="${pageContext.request.contextPath}/import-panchang">
            <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M12 18v-6"/><path d="m9 15 3-3 3 3"/></svg></i>
            Import Calendar
        </a>

    </div>

    <!-- ================= SEARCH ================= -->
    <div class="search-bar reveal">

        <form action="${pageContext.request.contextPath}/calendar" method="get">

            <label class="search-field">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>
                <input type="date" name="selected" value="<%=selectedDateText%>" required>
            </label>

            <button class="search-btn" type="submit">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>
                Search
            </button>

        </form>

    </div>

    <!-- ================= CALENDAR ================= -->
    <div class="section-card calendar-container reveal">

        <div class="section-top">
            <h2><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg></i> <%=monthName%> <%=year%></h2>
            <span class="tag">Click a date for Panchang details</span>
        </div>

        <div class="calendar-grid">
            <div class="day-header">Sun</div>
            <div class="day-header">Mon</div>
            <div class="day-header">Tue</div>
            <div class="day-header">Wed</div>
            <div class="day-header">Thu</div>
            <div class="day-header">Fri</div>
            <div class="day-header">Sat</div>
            <% if (calendarDays != null && !calendarDays.isEmpty()) {
                 int animationIndex = 0;
                 for (CalendarDay day : calendarDays) {
                   String cssClass = "day-card";
                   if (!day.isCurrentMonth()) cssClass += " other-month";
                   if (day.isToday()) cssClass += " today";
                   if (day.isSelected()) cssClass += " selected";
                   String isoDate = String.format(Locale.ROOT, "%04d-%02d-%02d", day.getYear(), day.getMonth(), day.getDay());
            %>
            <a class="<%=cssClass%>" role="button" style="--w:<%=((animationIndex++ % 12) * 35)%>ms"
               data-date="<%=isoDate%>"
               href="${pageContext.request.contextPath}/calendar?month=<%=month%>&amp;year=<%=year%>&amp;selected=<%=isoDate%>">
                <div class="day-number"><%=day.getDay()%></div>
                <div class="day-tithi"><%=day.getTithi() == null ? "" : day.getTithi()%></div>
                <% if (day.getFestival() != null && !day.getFestival().trim().isEmpty() && !"No Festival".equalsIgnoreCase(day.getFestival())) { %>
                  <span class="day-event"><%=day.getFestival()%></span>
                <% } %>
            </a>
            <% } } else { %>
            <div class="calendar-empty">Calendar data is not available for this month.</div>
            <% } %>
        </div>

    </div>

    <!-- ================= SELECTED DATE DETAILS ================= -->
    <div id="details" class="section-card details-card reveal">

        <div class="section-top">
            <h2><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg></i> Selected Date Details</h2>
            <span class="tag" id="detailsTag"><%=selectedDay != null ? selectedDay.getDate() : "Select a date"%></span>
        </div>
        <div class="details-grid">

            <div class="detail-item">
                <div class="di-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2v8"/><path d="m4.93 10.93 1.41 1.41"/><path d="M2 18h2"/><path d="M20 18h2"/><path d="m19.07 10.93-1.41 1.41"/><path d="M22 22H2"/><path d="m8 6 4-4 4 4"/><path d="M16 18a4 4 0 0 0-8 0"/></svg></i></div>
                <div><span>Sunrise</span><strong><%=selectedDay != null && selectedDay.getSunrise() != null ? selectedDay.getSunrise() : "--"%></strong></div>
            </div>

            <div class="detail-item">
                <div class="di-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 10V2"/><path d="m4.93 10.93 1.41 1.41"/><path d="M2 18h2"/><path d="M20 18h2"/><path d="m19.07 10.93-1.41 1.41"/><path d="M22 22H2"/><path d="m16 6-4 4-4-4"/><path d="M16 18a4 4 0 0 0-8 0"/></svg></i></div>
                <div><span>Sunset</span><strong><%=selectedDay != null && selectedDay.getSunset() != null ? selectedDay.getSunset() : "--"%></strong></div>
            </div>

            <div class="detail-item"><div class="di-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="17" rx="2"/><path d="M8 2v4M16 2v4M3 10h18"/></svg></i></div><div><span>Masa</span><strong><%=selectedDay != null && selectedDay.getMasa() != null ? selectedDay.getMasa() : "--"%></strong></div></div>
            <div class="detail-item"><div class="di-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 2v20M2 12h20"/></svg></i></div><div><span>Paksha</span><strong><%=selectedDay != null && selectedDay.getPaksha() != null ? selectedDay.getPaksha() : "--"%></strong></div></div>
            <div class="detail-item full-width">
                <div class="di-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z"/></svg></i></div>
                <div><span>Festival</span><strong><%=selectedDay != null && selectedDay.getFestival() != null ? selectedDay.getFestival() : "No Festival"%></strong></div>
            </div>


        </div>

    </div>

    <!-- ================= DAILY INFORMATION TABS ================= -->
    <div class="calendar-tabs reveal" role="tablist" aria-label="Calendar information">
        <button class="tab-button active" type="button" data-tab="detailsTab">Selected Date</button>
        <button class="tab-button" type="button" data-tab="eventsTab">Today's Events</button>
        <button class="tab-button" type="button" data-tab="groupsTab">Group Events</button>
        <button class="tab-button" type="button" data-tab="festivalsTab">Festivals</button>
    </div>
    <div class="tab-content reveal">
        <section id="detailsTab" class="tab-pane active section-card">
            <div class="section-top"><h2>Selected Date Summary</h2><span class="tag"><%=selectedDay != null ? selectedDay.getDate() : "--"%></span></div>
            <p class="tab-summary">Review the Panchang details displayed above for the selected date.</p>
        </section>
        <section id="eventsTab" class="tab-pane section-card">
            <div class="section-top"><h2>Today's Events</h2></div>
            <p class="tab-summary">No events are available for this date.</p>
        </section>
        <section id="groupsTab" class="tab-pane section-card">
            <div class="section-top"><h2>Group Events</h2></div>
            <p class="tab-summary">No group events are available for this date.</p>
        </section>
        <section id="festivalsTab" class="tab-pane section-card">
            <div class="section-top"><h2>Festivals</h2></div>
            <p class="tab-summary"><%=selectedDay != null && selectedDay.getFestival() != null ? selectedDay.getFestival() : "No Festival"%></p>
        </section>
    </div>

    <!-- ================= FOOTER ================= -->
    <div class="calendar-footer">
        <p>&copy; <%=year%> Digital Purohit Assistant</p>
    </div>

  </div>

</div>

<!-- page behaviour: scroll reveal, keyboard access, scroll to details, date validation -->
<script>
document.addEventListener("DOMContentLoaded", function () {

    /* ---------- scroll reveal ---------- */
    var page = document.querySelector('.dpa-dash');
    if (page) {
        var targets = page.querySelectorAll('.reveal');
        Array.prototype.forEach.call(targets, function (el, i) { el.style.setProperty('--d', (i * 70) + 'ms'); });
        if (!('IntersectionObserver' in window)) {
            targets.forEach(function (t) { t.classList.add('in'); });
        } else {
            var io = new IntersectionObserver(function (entries) {
                entries.forEach(function (en) { if (en.isIntersecting) { en.target.classList.add('in'); io.unobserve(en.target); } });
            }, { threshold: 0.08, rootMargin: '0px 0px -30px 0px' });
            targets.forEach(function (t) { io.observe(t); });
        }
    }

    /* ---------- day cards: Enter / Space works like a click ---------- */
    document.querySelectorAll('.day-card').forEach(function (c) {
        c.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); c.click(); }
        });
    });

    /* ---------- scroll to details after picking a date, else bring the selected day into view ---------- */
    var details = document.getElementById("details");
    if (window.location.hash === "#details" && details) {
        details.scrollIntoView({ behavior: "smooth", block: "start" });
    } else {
        var selected = document.querySelector(".day-card.selected");
        if (selected) selected.scrollIntoView({ behavior: "smooth", block: "center" });
    }

    /* ---------- date search validation ---------- */
    var searchForm = document.querySelector(".search-bar form");
    if (searchForm) {
        searchForm.addEventListener("submit", function (e) {
            var input = document.querySelector("input[name='selected']");
            if (input.value === "") { e.preventDefault(); alert("Please select a date."); }
        });
    }
});
</script>




<script>
document.addEventListener('DOMContentLoaded', function () {
  var form = document.querySelector('.search-bar form');
  if (form) form.addEventListener('submit', function (e) {
    var input = form.querySelector('input[name="selected"]');
    if (!input || !input.value) { e.preventDefault(); alert('Please select a date.'); }
  });
  var tabs = document.querySelectorAll('.tab-button');
  var panes = document.querySelectorAll('.tab-pane');
  tabs.forEach(function (button) {
    button.addEventListener('click', function () {
      tabs.forEach(function (b) { b.classList.remove('active'); });
      panes.forEach(function (p) { p.classList.remove('active'); });
      button.classList.add('active');
      var pane = document.getElementById(button.getAttribute('data-tab'));
      if (pane) pane.classList.add('active');
    });
  });
  var selected = document.querySelector('.day-card.selected');
  if (selected && window.location.hash === '#details') {
    var details = document.getElementById('details');
    if (details) details.scrollIntoView({behavior:'smooth', block:'start'});
  }
});
</script>
</body>
</html>