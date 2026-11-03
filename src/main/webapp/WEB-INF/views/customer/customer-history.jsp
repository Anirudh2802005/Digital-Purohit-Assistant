<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.digitalpurohit.model.Customer" %>
<%@ page import="com.digitalpurohit.model.CustomerHistory" %>
<%
    Customer customer = (Customer) request.getAttribute("customer");
    List<CustomerHistory> history = (List<CustomerHistory>) request.getAttribute("history");
    if (history == null) history = Collections.emptyList();

    String customerName = customer != null && customer.getCustomerName() != null
            ? customer.getCustomerName() : "—";
    String avatarLetter = !customerName.trim().isEmpty() && !"—".equals(customerName)
            ? customerName.trim().substring(0, 1).toUpperCase() : "C";
    Object totalEventsValue = request.getAttribute("totalEvents");
    Object totalAmountValue = request.getAttribute("totalAmount");
    Object amountPaidValue = request.getAttribute("amountPaid");
    Object pendingAmountValue = request.getAttribute("pendingAmount");
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer History</title>
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
   CUSTOMER HISTORY — same design system as the dashboard
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
	--good:#34d399; --pend:#f0a43a; --part:#6aa6ff;
	max-width:108em; margin:0 auto;
	display:flex; flex-direction:column; gap:1.5em;
	font-family:'Inter', ui-sans-serif, system-ui, sans-serif;
	font-size:calc(14px * var(--dk)); font-weight:500; line-height:1.45;
	color:var(--dpa-text);
	-webkit-font-smoothing:antialiased;
}
:root[data-theme="light"] .dpa-dash{ --good:#168a4a; --pend:#b45f06; --part:#1f63d6; }
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

.dpa-dash .hero-tools{ display:flex; flex-wrap:wrap; gap:.7em; }
.dpa-dash .hero-btn{
	display:inline-flex; align-items:center; gap:.55em; margin:0; padding:.7em 1.1em;
	border-radius:.75em; border:1px solid rgba(255,255,255,.28); background:rgba(255,255,255,.07); color:#fff;
	-webkit-backdrop-filter:blur(8px); backdrop-filter:blur(8px);
	font-family:inherit; font-size:.92em; font-weight:600; line-height:1.2; cursor:pointer;
	transition:background-color .2s, border-color .2s, color .2s, transform .12s;
}
.dpa-dash .hero-btn:active{ transform:scale(.96); }

/* =====================================================================
   PROFILE
   ===================================================================== */
.dpa-dash .profile-card{
	display:flex; align-items:center; gap:1.8em;
	margin:0; padding:1.7em 1.9em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .profile-avatar{
	flex-shrink:0; width:2.3em; height:2.3em; border-radius:50%;
	display:flex; align-items:center; justify-content:center;
	font-family:'Anton', ui-sans-serif, sans-serif; font-size:2.6em; line-height:1;
	background:var(--dpa-active-bg); color:var(--dpa-active-text);
	box-shadow:0 0 0 .1em var(--dpa-tile);
	animation:dpaPulseAv 3.6s ease-in-out infinite;
}
@keyframes dpaPulseAv{ 0%,100%{ box-shadow:0 0 0 .08em var(--dpa-tile); } 50%{ box-shadow:0 0 0 .2em var(--dpa-tile); } }
.dpa-dash .profile-grid{
	flex:1; min-width:0; margin:0; padding:0;
	display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:.9em 1.3em;
}
.dpa-dash .profile-item{
	display:flex; align-items:center; gap:.95em; min-width:0; margin:0; padding:.85em 1em;
	border-radius:.9em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:border-color .2s, background-color .35s;
}
.dpa-dash .profile-item .pi-icon{
	flex-shrink:0; width:2.6em; height:2.6em; border-radius:.8em; font-size:1em;
	display:flex; align-items:center; justify-content:center;
	background:var(--dpa-tile); color:var(--dpa-text);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .profile-item .pi-text{ min-width:0; }
.dpa-dash .profile-item label{
	display:block; margin:0 0 .15em; padding:0;
	font-size:.72em; font-weight:700; letter-spacing:.09em; text-transform:uppercase; color:var(--dpa-muted);
}
.dpa-dash .profile-item span.pi-value{
	display:block; font-size:1.02em; font-weight:600; color:var(--dpa-text);
	overflow-wrap:anywhere; white-space:pre-line;
}

/* =====================================================================
   SUMMARY CARDS
   ===================================================================== */
.dpa-dash .summary-cards{
	display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:1.1em; margin:0;
}
.dpa-dash .summary-card{
	--acc:#2b7fff; --acc-soft:rgba(43,127,255,.16);
	position:relative; overflow:hidden; display:flex; align-items:center; gap:1em;
	margin:0; padding:1.4em 1.5em; container-type:inline-size;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .stat-blue{ --acc:#2b7fff; --acc-soft:rgba(43,127,255,.16); }
.dpa-dash .stat-purple{ --acc:#9b7bff; --acc-soft:rgba(155,123,255,.17); }
.dpa-dash .stat-green{ --acc:#1fbf6a; --acc-soft:rgba(31,191,106,.16); }
.dpa-dash .stat-orange{ --acc:#f0a43a; --acc-soft:rgba(240,164,58,.17); }
.dpa-dash .summary-card::before{
	content:""; position:absolute; left:0; top:0; height:3px; width:100%; background:var(--acc);
	transform:scaleX(0); transform-origin:left; transition:transform .9s cubic-bezier(.2,.8,.2,1) .25s;
}
.dpa-dash .summary-card.in::before, html:not(.dpa-js) .dpa-dash .summary-card::before{ transform:scaleX(1); }
.dpa-dash .summary-icon{
	flex-shrink:0; width:3em; height:3em; border-radius:.95em; font-size:1.1em;
	display:flex; align-items:center; justify-content:center;
	background:var(--acc-soft); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .summary-text{ min-width:0; }
.dpa-dash .summary-card h2{
	font-size:1.7em; font-size:clamp(1.25em, 9cqw, 1.95em); font-weight:700; line-height:1.1; letter-spacing:-.02em;
	font-variant-numeric:tabular-nums; color:var(--dpa-text); overflow-wrap:anywhere;
}
.dpa-dash .summary-card p{ margin-top:.3em; font-size:.84em; font-weight:600; letter-spacing:.02em; color:var(--dpa-muted); }

/* payment progress */
.dpa-dash .progress-card{
	margin:0; padding:1.2em 1.5em; border-radius:1.15em;
	border:1px solid var(--dpa-border); background:var(--dpa-surface); box-shadow:none;
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .progress-card[hidden]{ display:none; }
.dpa-dash .progress-head{ display:flex; justify-content:space-between; align-items:baseline; gap:1em; margin-bottom:.7em; font-size:.9em; font-weight:600; }
.dpa-dash .progress-head span{ color:var(--dpa-muted); font-weight:500; }
.dpa-dash .progress-head strong{ font-size:1.15em; font-variant-numeric:tabular-nums; }
.dpa-dash .progress-track{ height:.7em; border-radius:99px; background:var(--dpa-tile); overflow:hidden; }
.dpa-dash .progress-fill{
	height:100%; width:0; border-radius:99px; background:var(--good);
	transition:width 1.3s cubic-bezier(.2,.8,.2,1) .3s;
}

/* =====================================================================
   HISTORY TABLE
   ===================================================================== */
.dpa-dash .table-card{
	margin:0; padding:0; overflow:hidden;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .table-top{
	display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:1em;
	padding:1.15em 1.5em; border-bottom:1px solid var(--dpa-border);
}
.dpa-dash .table-top h2{
	display:flex; align-items:center; gap:.65em; font-size:1.15em; font-weight:700; letter-spacing:-.01em;
}
.dpa-dash .table-top h2 i{
	width:2.3em; height:2.3em; font-size:.85em; border-radius:.7em;
	display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile);
}
.dpa-dash .table-top h2 small{ font-size:.75em; font-weight:600; color:var(--dpa-muted); }
.dpa-dash .search-box{
	display:flex; align-items:center; gap:.6em; min-width:19em; padding:0 .9em;
	border-radius:.75em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:border-color .2s, box-shadow .2s;
}
.dpa-dash .search-box:focus-within{ border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.2); }
.dpa-dash .search-box i{ color:var(--dpa-muted); font-size:.95em; }
.dpa-dash .search-box input{
	flex:1; min-width:0; border:0; outline:0; background:transparent; box-shadow:none; margin:0;
	padding:.7em 0; font-family:inherit; font-size:.95em; font-weight:500; color:var(--dpa-text);
}
.dpa-dash .search-box input::placeholder{ color:var(--dpa-muted); opacity:.8; }

.dpa-dash .table-wrap{ overflow-x:auto; }
.dpa-dash .table-card table{ width:100%; border-collapse:collapse; margin:0; background:transparent; font-size:.95em; }
.dpa-dash .table-card thead th{
	padding:.9em 1.2em; text-align:left; white-space:nowrap; background:transparent;
	font-size:.74em; font-weight:700; letter-spacing:.09em; text-transform:uppercase; color:var(--dpa-muted);
	border:0; border-bottom:1px solid var(--dpa-border); cursor:pointer; user-select:none;
	transition:color .2s;
}
.dpa-dash .table-card thead th:last-child{ text-align:right; }
.dpa-dash .table-card thead th::after{ content:"\2195"; margin-left:.45em; opacity:.35; font-size:1.1em; }
.dpa-dash .table-card thead th[aria-sort="ascending"]::after{ content:"\2191"; opacity:1; color:var(--dpa-link); }
.dpa-dash .table-card thead th[aria-sort="descending"]::after{ content:"\2193"; opacity:1; color:var(--dpa-link); }
.dpa-dash .table-card tbody td{
	padding:1em 1.2em; border:0; border-bottom:1px solid var(--dpa-border); background:transparent; color:var(--dpa-text);
	vertical-align:middle;
}
.dpa-dash .table-card tbody tr:last-child td{ border-bottom:0; }
.dpa-dash .table-card tbody td:first-child{ font-weight:600; }
.dpa-dash .table-card tbody td:last-child{ text-align:right; font-weight:700; font-variant-numeric:tabular-nums; white-space:nowrap; }
.dpa-dash .hist-row{ transition:background-color .2s; animation:dpaRow .55s cubic-bezier(.2,.8,.2,1) both; animation-delay:calc(var(--i, 0) * 45ms + 250ms); }
.dpa-dash .hist-row[hidden]{ display:none !important; }
.dpa-dash .pay-pill{
	display:inline-block; padding:.25em .8em; border-radius:999px;
	font-size:.76em; font-weight:700; letter-spacing:.05em; text-transform:uppercase;
	background:var(--dpa-tile); color:var(--dpa-muted);
}
.dpa-dash .pay-pill.pay-paid{ background:rgba(52,211,153,.15); color:var(--good); }
.dpa-dash .pay-pill.pay-pending{ background:rgba(240,164,58,.16); color:var(--pend); }
.dpa-dash .pay-pill.pay-partial{ background:rgba(106,166,255,.16); color:var(--part); }
.dpa-dash .no-match{ display:none; padding:2em 1em; text-align:center; color:var(--dpa-muted); }
.dpa-dash .no-match.show{ display:block; }

/* empty states */
.dpa-dash .empty-box{
	display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center;
	gap:.45em; margin:0; padding:3em 1em; color:var(--dpa-muted);
}
.dpa-dash .empty-box i{ font-size:2.8em; opacity:.55; animation:dpaBob 3.4s ease-in-out infinite; }
.dpa-dash .empty-box p{ font-size:1em; font-weight:500; color:var(--dpa-text); opacity:.85; }
.dpa-dash .empty-box a{ margin-top:.6em; color:var(--dpa-link); font-weight:600; }

/* =====================================================================
   HOVER — mouse only
   ===================================================================== */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ background:#fff; color:#1b1b1b; border-color:#fff; }
	.dpa-dash .summary-card:hover{ transform:translateY(-4px); border-color:var(--acc); }
	.dpa-dash .summary-card:hover .summary-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .profile-item:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .profile-item:hover .pi-icon{ transform:rotate(-8deg) scale(1.1); background:var(--dpa-twilight); color:#fff; }
	.dpa-dash .hist-row:hover{ background:var(--dpa-hover); }
	.dpa-dash .table-card thead th:hover{ color:var(--dpa-text); }
}
.dpa-dash a:focus-visible, .dpa-dash button:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* =====================================================================
   RESPONSIVE
   ===================================================================== */
@media (max-width:1279px){
	.dpa-dash .summary-cards{ grid-template-columns:repeat(2, minmax(0, 1fr)); }
}
@media (max-width:900px){
	.dpa-dash .profile-card{ flex-direction:column; align-items:flex-start; gap:1.2em; }
}
@media (max-width:700px){
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .hero-tools{ width:100%; }
	.dpa-dash .hero-btn{ flex:1; justify-content:center; }
	.dpa-dash .profile-card{ padding:1.3em 1.2em; }
	.dpa-dash .profile-grid{ grid-template-columns:minmax(0, 1fr); width:100%; }
	.dpa-dash .summary-cards{ gap:.8em; }
	.dpa-dash .summary-card{ padding:1.1em 1.1em; flex-direction:column; align-items:flex-start; gap:.7em; }
	.dpa-dash .table-top{ padding:1em 1.1em; }
	.dpa-dash .search-box{ width:100%; min-width:0; }
	/* table becomes a list of cards, no sideways scrolling */
	.dpa-dash .table-card thead{ display:none; }
	.dpa-dash .table-card table, .dpa-dash .table-card tbody{ display:block; }
	.dpa-dash .hist-row{ display:block; padding:.8em 1.1em; border-bottom:1px solid var(--dpa-border); }
	.dpa-dash .hist-row:last-child{ border-bottom:0; }
	.dpa-dash .table-card tbody td{ display:flex; justify-content:space-between; align-items:center; gap:1em; padding:.45em 0; border:0; text-align:right !important; }
	.dpa-dash .table-card tbody td::before{
		content:attr(data-label); flex-shrink:0; text-align:left;
		font-size:.74em; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--dpa-muted);
	}
	.dpa-dash .table-card tbody td:first-child{ font-size:1.05em; }
}
@media (max-width:380px){
	.dpa-dash .summary-cards{ grid-template-columns:minmax(0, 1fr); }
	.dpa-dash .summary-card{ flex-direction:row; align-items:center; }
}

/* printing the history: clean black-on-white */
@media print{
	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-dash{ --dpa-text:#000; --dpa-muted:#444; --dpa-surface:#fff; --dpa-surface-2:#fff; --dpa-border:#bbb; --dpa-tile:#eee; --dpa-active-bg:#222; --dpa-active-text:#fff; }
	.dpa-js .dpa-dash .reveal, .dpa-dash .hist-row{ opacity:1 !important; animation:none !important; }
	.dpa-dash .page-header{ background:#fff; color:#000; border-color:#bbb; }
	.dpa-dash .page-header *{ color:#000 !important; }
	.dpa-dash .hero-watermark{ display:none; }
	.dpa-dash .hero-tools, .dpa-dash .search-box{ display:none; }
	.dpa-dash .progress-fill{ width:var(--pct, 0%) !important; transition:none; }
	.dpa-dash .hist-row[hidden]{ display:table-row !important; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal, .dpa-dash .hist-row{ opacity:1; }
	.dpa-dash .summary-card::before{ transform:scaleX(1); }
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

  <div class="customer-history-page dpa-dash">

    <div class="page-header">

        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>

        <div class="hero-left">

            <div class="hero-icon">

                <i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/><path d="M12 7v5l4 2"/></svg></i>

            </div>

            <div>

                <h1>Customer History</h1>

                <p>Complete customer profile and booking history.</p>

            </div>

        </div>

        <div class="hero-tools">

            <a href="${pageContext.request.contextPath}/customers" class="hero-btn">

                <i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m12 19-7-7 7-7"/><path d="M19 12H5"/></svg></i> Back

            </a>

            <button type="button" class="hero-btn" id="printBtn">

                <i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><path d="M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6"/><rect x="6" y="14" width="12" height="8" rx="1"/></svg></i> Print

            </button>

            <button type="button" class="hero-btn" id="csvBtn">

                <i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M8 13h2"/><path d="M14 13h2"/><path d="M8 17h2"/><path d="M14 17h2"/></svg></i> Export CSV

            </button>

        </div>

    </div>

    

    <div class="profile-card reveal">

        <div class="profile-avatar" aria-hidden="true"><%= avatarLetter %></div>

        <div class="profile-grid">

            <div class="profile-item">

                <div class="pi-icon"><i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i></div>

                <div class="pi-text">

                    <label>Name</label>

                    <span class="pi-value"><%= customerName %></span>

                </div>

            </div>

            <div class="profile-item">

                <div class="pi-icon"><i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg></i></div>

                <div class="pi-text">

                    <label>Phone</label>

                    <span class="pi-value"><%= customer != null && customer.getPhone() != null ? customer.getPhone() : "—" %></span>

                </div>

            </div>

            <div class="profile-item">

                <div class="pi-icon"><i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/><circle cx="12" cy="10" r="3"/></svg></i></div>

                <div class="pi-text">

                    <label>Address</label>

                    <span class="pi-value"><%= customer != null && customer.getAddress() != null && !customer.getAddress().trim().isEmpty() ? customer.getAddress() : "—" %></span>

                </div>

            </div>

            <div class="profile-item">

                <div class="pi-icon"><i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z"/></svg></i></div>

                <div class="pi-text">

                    <label>Gothram</label>

                    <span class="pi-value"><%= customer != null && customer.getGothram() != null && !customer.getGothram().trim().isEmpty() ? customer.getGothram() : "—" %></span>

                </div>

            </div>

        </div>

    </div>

    

    <div class="summary-cards">

        <div class="summary-card stat-blue reveal" data-metric="events">

            <div class="summary-icon"><i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg></i></div>

            <div class="summary-text">

                <h2>8</h2>

                <p>Total Events</p>

            </div>

        </div>

        <div class="summary-card stat-purple reveal" data-metric="total">

            <div class="summary-icon"><i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/></svg></i></div>

            <div class="summary-text">

                <h2>₹ <%= totalAmountValue != null ? totalAmountValue : "0" %></h2>

                <p>Total Amount</p>

            </div>

        </div>

        <div class="summary-card stat-green reveal" data-metric="paid">

            <div class="summary-icon"><i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i></div>

            <div class="summary-text">

                <h2>₹ <%= amountPaidValue != null ? amountPaidValue : "0" %></h2>

                <p>Amount Paid</p>

            </div>

        </div>

        <div class="summary-card stat-orange reveal" data-metric="pending">

            <div class="summary-icon"><i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 22h14"/><path d="M5 2h14"/><path d="M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22"/><path d="M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2"/></svg></i></div>

            <div class="summary-text">

                <h2>₹ <%= pendingAmountValue != null ? pendingAmountValue : "0" %></h2>

                <p>Pending Amount</p>

            </div>

        </div>

    </div>

    <div class="progress-card reveal" id="payProgress" hidden>

        <div class="progress-head"><span>Payment collected</span><strong id="payPct">0%</strong></div>

        <div class="progress-track"><div class="progress-fill" id="payFill"></div></div>

    </div>

    <div class="table-card reveal">

        

        <div class="table-top">

            <h2><i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i> Booking History <small id="rowCount"><%= history.size() %> bookings</small></h2>

            <label class="search-box">

                <i class="dpa-inline-icon"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>

                <input type="search" id="histSearch" placeholder="Search events, location, payment&hellip;" autocomplete="off">

            </label>

        </div>

        <div class="table-wrap">

        <table id="histTable">

            <thead>

                <tr>

                    <th data-type="text">Event</th>

                    <th data-type="date">Date</th>

                    <th data-type="text">Location</th>

                    <th data-type="text">Payment</th>

                    <th data-type="num">Amount</th>

                </tr>

            </thead>

            <tbody>
<% if (history.isEmpty()) { %>
    <tr class="hist-row">
        <td colspan="5" style="text-align:center;">No booking history found for this customer.</td>
    </tr>
<% } else { for (CustomerHistory h : history) { %>
    <tr class="hist-row">
        <td data-label="Event"><%= h.getEventTitle() != null ? h.getEventTitle() : "—" %></td>
        <td data-label="Date"><%= h.getEventDate() != null ? h.getEventDate() : "—" %></td>
        <td data-label="Location"><%= h.getLocation() != null && !h.getLocation().trim().isEmpty() ? h.getLocation() : "—" %></td>
        <td data-label="Payment"><span class="pay-pill"><%= h.getPaymentStatus() != null && !h.getPaymentStatus().trim().isEmpty() ? h.getPaymentStatus() : "Unknown" %></span></td>
        <td data-label="Amount">₹ <%= h.getAmount() %></td>
    </tr>
<% } } %>
</tbody>

        </table>

        <div class="no-match" id="noMatch">No bookings match your search.</div>

        </div>

        

    </div>

  </div>

</div>



<!-- page behaviour: animations, search, sort, print, CSV export (all in the browser; no extra requests) -->
<script>
(function () {
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var page = document.querySelector('.dpa-dash');
	if (!page) return;

	/* ---------- helpers ---------- */
	function num(t) { var n = parseFloat(String(t).replace(/[^0-9.\-]/g, '')); return isNaN(n) ? 0 : n; }

	/* ---------- stagger + scroll reveal ---------- */
	page.querySelectorAll('.summary-cards').forEach(function (g) {
		Array.prototype.forEach.call(g.children, function (el, i) { el.style.setProperty('--d', (i * 90) + 'ms'); });
	});

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

	/* ---------- payment progress (paid / total, read from the summary cards) ---------- */
	var totalEl = page.querySelector('[data-metric="total"] h2');
	var paidEl  = page.querySelector('[data-metric="paid"] h2');
	var progress = document.getElementById('payProgress');
	var pct = 0;
	if (totalEl && paidEl && progress) {
		var total = num(totalEl.textContent), paid = num(paidEl.textContent);
		if (total > 0) {
			pct = Math.max(0, Math.min(100, Math.round(paid / total * 100)));
			progress.hidden = false;
			progress.style.setProperty('--pct', pct + '%');
			document.getElementById('payPct').textContent = pct + '%';
		}
	}

	function reveal(el) {
		el.classList.add('in');
		el.querySelectorAll('.summary-card h2').forEach(countUp);
		if (el.matches('.summary-card')) { var h = el.querySelector('h2'); if (h) countUp(h); }
		if (el.id === 'payProgress') {
			var f = document.getElementById('payFill');
			if (f) requestAnimationFrame(function () { f.style.width = pct + '%'; });
		}
	}
	var targets = page.querySelectorAll('.reveal');
	if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
		}, { threshold: 0.1, rootMargin: '0px 0px -30px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}

	/* ---------- history table ---------- */
	var table = document.getElementById('histTable');
	if (table) {
		var tbody = table.tBodies[0];
		var rows = Array.prototype.slice.call(tbody.querySelectorAll('.hist-row'));
		var countEl = document.getElementById('rowCount');
		var noMatch = document.getElementById('noMatch');

		rows.forEach(function (r, i) {
			r.style.setProperty('--i', Math.min(i, 14));
			/* colour the payment pill from its text */
			var pill = r.querySelector('.pay-pill');
			if (pill) {
				var t = pill.textContent.trim().toLowerCase();
				if (/partial/.test(t)) pill.classList.add('pay-partial');
				else if (/pend|unpaid|due|not/.test(t)) pill.classList.add('pay-pending');
				else if (/paid|complete|success|received/.test(t)) pill.classList.add('pay-paid');
			}
		});

		/* search */
		var search = document.getElementById('histSearch');
		function applyFilter() {
			var q = search.value.trim().toLowerCase(), shown = 0;
			rows.forEach(function (r) {
				var ok = !q || r.textContent.toLowerCase().indexOf(q) > -1;
				r.hidden = !ok; if (ok) shown++;
			});
			noMatch.classList.toggle('show', shown === 0);
			if (countEl) countEl.textContent = (q ? shown + ' of ' + rows.length : rows.length) + ' bookings';
		}
		search.addEventListener('input', applyFilter);

		/* sort by clicking a column heading */
		var heads = Array.prototype.slice.call(table.tHead.rows[0].cells);
		heads.forEach(function (th, idx) {
			th.setAttribute('tabindex', '0');
			function sort() {
				var dir = th.getAttribute('aria-sort') === 'ascending' ? 'descending' : 'ascending';
				heads.forEach(function (h) { h.removeAttribute('aria-sort'); });
				th.setAttribute('aria-sort', dir);
				var type = th.dataset.type;
				function val(tr) {
					var t = tr.cells[idx].textContent.trim();
					if (type === 'num') return num(t);
					if (type === 'date') { var d = Date.parse(t); return isNaN(d) ? t.toLowerCase() : d; }
					return t.toLowerCase();
				}
				rows.sort(function (a, b) {
					var x = val(a), y = val(b);
					if (typeof x !== typeof y) { x = String(x); y = String(y); }
					return (x < y ? -1 : x > y ? 1 : 0) * (dir === 'ascending' ? 1 : -1);
				});
				rows.forEach(function (r) { tbody.appendChild(r); });
			}
			th.addEventListener('click', sort);
			th.addEventListener('keydown', function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); sort(); } });
		});

		/* export what is currently shown as CSV (opens cleanly in Excel, including ₹ and Telugu text) */
		document.getElementById('csvBtn').addEventListener('click', function () {
			var lines = [];
			var head = heads.map(function (h) { return h.textContent.trim(); });
			lines.push(head.map(q).join(','));
			rows.forEach(function (r) {
				if (r.hidden) return;
				lines.push(Array.prototype.map.call(r.cells, function (c) { return q(c.textContent.replace(/\s+/g, ' ').trim()); }).join(','));
			});
			function q(s) { return '"' + String(s).replace(/"/g, '""') + '"'; }
			var blob = new Blob([String.fromCharCode(0xFEFF) + lines.join(String.fromCharCode(13, 10))], { type: 'text/csv;charset=utf-8;' });
			var a = document.createElement('a');
			a.href = URL.createObjectURL(blob); a.download = 'customer-history.csv';
			document.body.appendChild(a); a.click(); document.body.removeChild(a);
			setTimeout(function () { URL.revokeObjectURL(a.href); }, 1000);
		});
	} else {
		/* no history: nothing to export */
		var csv = document.getElementById('csvBtn'); if (csv) csv.style.display = 'none';
	}

	document.getElementById('printBtn').addEventListener('click', function () { window.print(); });
})();
</script>


</body>
</html>