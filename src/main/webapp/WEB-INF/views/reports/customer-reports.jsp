<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.digitalpurohit.model.CustomerReport" %>
<%!
    private String reportJsEscape(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\r", "\\r")
                    .replace("\n", "\\n")
                    .replace("</", "<\\/");
    }
%>
<%
    List<CustomerReport> reports = (List<CustomerReport>) request.getAttribute("reports");
    Integer totalCustomers = (Integer) request.getAttribute("totalCustomers");
    Integer totalEvents = (Integer) request.getAttribute("totalEvents");
    Integer totalBulkEvents = (Integer) request.getAttribute("totalBulkEvents");
    Double totalReceivedAmount = (Double) request.getAttribute("totalReceivedAmount");
    Double totalPendingAmount = (Double) request.getAttribute("totalPendingAmount");
    List<String> graphLabels = (List<String>) request.getAttribute("graphLabels");
    List<Double> graphValues = (List<Double>) request.getAttribute("graphValues");
    Map<String, Integer> paymentStatus = (Map<String, Integer>) request.getAttribute("paymentStatus");

    int customersCount = totalCustomers == null ? 0 : totalCustomers;
    int eventsCount = totalEvents == null ? 0 : totalEvents;
    int bulkEventsCount = totalBulkEvents == null ? 0 : totalBulkEvents;
    double receivedTotal = totalReceivedAmount == null ? 0.0 : totalReceivedAmount;
    double pendingTotal = totalPendingAmount == null ? 0.0 : totalPendingAmount;
    double collectionTotal = receivedTotal + pendingTotal;
    double collectionPercent = collectionTotal <= 0 ? 0.0 : (receivedTotal * 100.0 / collectionTotal);
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer Reports | Digital Purohit Assistant</title>
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
   CUSTOMER REPORTS — same design system as the dashboard
   Colours come from the shared theme variables (--dpa-*) defined in
   sidebar.jsp, so the dark / light switch restyles this page and its
   charts too. Sizes are in em, so the page scales up on large monitors.
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
   SUMMARY CARDS
   ===================================================================== */
.dpa-dash .summary-container{
	display:grid; grid-template-columns:repeat(5, minmax(0, 1fr)); gap:1.1em; margin:0;
}
.dpa-dash .summary-card{
	--acc:#2b7fff; --acc-soft:rgba(43,127,255,.16);
	position:relative; overflow:hidden; margin:0; padding:1.4em 1.5em; min-width:0;
	container-type:inline-size; text-align:left;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .stat-blue{ --acc:#2b7fff; --acc-soft:rgba(43,127,255,.16); }
.dpa-dash .stat-purple{ --acc:#9b7bff; --acc-soft:rgba(155,123,255,.17); }
.dpa-dash .stat-teal{ --acc:#22c1c3; --acc-soft:rgba(34,193,195,.16); }
.dpa-dash .stat-green{ --acc:#1fbf6a; --acc-soft:rgba(31,191,106,.16); }
.dpa-dash .stat-orange{ --acc:#f0a43a; --acc-soft:rgba(240,164,58,.17); }
.dpa-dash .summary-card::before{
	content:""; position:absolute; left:0; top:0; height:3px; width:100%; background:var(--acc);
	transform:scaleX(0); transform-origin:left; transition:transform .9s cubic-bezier(.2,.8,.2,1) .25s;
}
.dpa-dash .summary-card.in::before, html:not(.dpa-js) .dpa-dash .summary-card::before{ transform:scaleX(1); }
.dpa-dash .sc-top{ display:flex; align-items:center; justify-content:space-between; gap:.8em; margin-bottom:.9em; }
.dpa-dash .summary-card p{
	font-size:.76em; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--dpa-muted);
}
.dpa-dash .summary-icon{
	flex-shrink:0; width:2.7em; height:2.7em; border-radius:.9em; font-size:1.05em;
	display:flex; align-items:center; justify-content:center;
	background:var(--acc-soft); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .summary-card h2{
	font-size:1.7em; font-size:clamp(1.15em, 9cqw, 1.95em); font-weight:700; line-height:1.1; letter-spacing:-.02em;
	font-variant-numeric:tabular-nums; color:var(--dpa-text); overflow-wrap:anywhere;
}

/* =====================================================================
   CUSTOMER REPORT SUMMARY
   ===================================================================== */
.dpa-dash .info-card{
	margin:0; padding:1.6em 1.8em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .info-card h2{ display:flex; align-items:center; gap:.65em; font-size:1.15em; font-weight:700; letter-spacing:-.01em; margin:0 0 1.2em; }
.dpa-dash .info-card h2 i{
	width:2.3em; height:2.3em; font-size:.85em; border-radius:.7em;
	display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile);
}
.dpa-dash .info-grid{ display:grid; grid-template-columns:repeat(5, minmax(0, 1fr)); gap:.9em; margin:0 0 1.3em; }
.dpa-dash .info-item{
	min-width:0; padding:.9em 1.1em; border-radius:.9em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2);
}
.dpa-dash .info-item b{ display:block; font-size:.74em; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--dpa-muted); margin-bottom:.35em; }
.dpa-dash .info-item span{ display:block; font-size:1.15em; font-weight:700; font-variant-numeric:tabular-nums; overflow-wrap:anywhere; }
.dpa-dash .info-item.good span{ color:var(--good); }
.dpa-dash .info-item.bad span{ color:var(--bad2); }
.dpa-dash .progress-head{ display:flex; justify-content:space-between; align-items:baseline; gap:1em; margin-bottom:.6em; font-size:.9em; font-weight:600; }
.dpa-dash .progress-head span{ color:var(--dpa-muted); font-weight:500; }
.dpa-dash .progress-head strong{ font-size:1.15em; font-variant-numeric:tabular-nums; }
.dpa-dash .progress-track{ height:.7em; border-radius:99px; background:var(--dpa-tile); overflow:hidden; display:flex; }
.dpa-dash .progress-fill{ height:100%; width:0; background:var(--good); transition:width 1.3s cubic-bezier(.2,.8,.2,1) .3s; }
.dpa-dash .progress-rest{ height:100%; flex:1; background:rgba(255,107,107,.35); }

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
	display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:1em;
	padding:1.15em 1.5em; border-bottom:1px solid var(--dpa-border);
}
.dpa-dash .table-top h2{ display:flex; align-items:center; gap:.65em; font-size:1.15em; font-weight:700; letter-spacing:-.01em; }
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
.dpa-dash .search-box i{ color:var(--dpa-muted); font-size:.95em; transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .search-box:focus-within i{ color:var(--dpa-link); transform:scale(1.12); }
.dpa-dash .search-box input{
	flex:1; min-width:0; width:100%; border:0; outline:0; background:transparent; box-shadow:none; margin:0;
	padding:.75em 0; font-family:inherit; font-size:.95em; font-weight:500; color:var(--dpa-text);
}
.dpa-dash .search-box input::placeholder{ color:var(--dpa-muted); opacity:.8; font-weight:400; }

.dpa-dash .table-wrap{ overflow-x:auto; }
.dpa-dash .table-card table{ width:100%; border-collapse:collapse; margin:0; background:transparent; font-size:.93em; box-shadow:none; }
.dpa-dash .table-card thead th{
	padding:.9em 1em; text-align:left; white-space:nowrap; background:transparent; color:var(--dpa-muted);
	font-size:.72em; font-weight:700; letter-spacing:.09em; text-transform:uppercase;
	border:0; border-bottom:1px solid var(--dpa-border); cursor:pointer; user-select:none; transition:color .2s;
}
.dpa-dash .table-card thead th.right{ text-align:right; }
.dpa-dash .table-card thead th.center{ text-align:center; }
.dpa-dash .table-card thead th.nosort{ cursor:default; }
.dpa-dash .table-card thead th:not(.nosort)::after{ content:"\2195"; margin-left:.4em; opacity:.35; font-size:1.1em; }
.dpa-dash .table-card thead th[aria-sort="ascending"]::after{ content:"\2191"; opacity:1; color:var(--dpa-link); }
.dpa-dash .table-card thead th[aria-sort="descending"]::after{ content:"\2193"; opacity:1; color:var(--dpa-link); }
.dpa-dash .table-card tbody td{
	padding:.9em 1em; border:0; border-bottom:1px solid var(--dpa-border); background:transparent; color:var(--dpa-text);
	vertical-align:middle; text-align:left;
}
.dpa-dash .table-card tbody tr:last-child td{ border-bottom:0; }
.dpa-dash .table-card tbody td.name{ font-weight:700; }
.dpa-dash .table-card tbody td[data-label="Phone"]{ white-space:nowrap; }
.dpa-dash .table-card td.center{ text-align:center; font-variant-numeric:tabular-nums; }
.dpa-dash .table-card td.money{ text-align:right; font-variant-numeric:tabular-nums; white-space:nowrap; }
.dpa-dash .table-card td.recv{ color:var(--good); font-weight:700; }
.dpa-dash .table-card td.pend{ color:var(--bad2); font-weight:700; }
.dpa-dash .table-card td.act{ text-align:right; white-space:nowrap; }
.dpa-dash .rep-row{ transition:background-color .2s; animation:dpaRow .55s cubic-bezier(.2,.8,.2,1) both; animation-delay:calc(var(--i, 0) * 45ms + 250ms); }
.dpa-dash .rep-row[hidden]{ display:none !important; }
.dpa-dash .no-match{ display:none; padding:2em 1em; text-align:center; color:var(--dpa-muted); }
.dpa-dash .no-match.show{ display:block; }

.dpa-dash .status-paid, .dpa-dash .status-partial, .dpa-dash .status-pending{
	display:inline-flex; align-items:center; gap:.5em; padding:.3em .85em; border-radius:999px;
	font-size:.76em; font-weight:700; letter-spacing:.06em; text-transform:uppercase; white-space:nowrap;
}
.dpa-dash .status-paid::before, .dpa-dash .status-partial::before, .dpa-dash .status-pending::before{ content:""; width:.5em; height:.5em; border-radius:50%; background:currentColor; }
.dpa-dash .status-paid{ background:rgba(52,211,153,.15); color:var(--good); }
.dpa-dash .status-partial{ background:rgba(240,164,58,.16); color:var(--pend); }
.dpa-dash .status-pending{ background:rgba(255,107,107,.15); color:var(--bad2); }

.dpa-dash .btn-view{
	display:inline-flex; align-items:center; gap:.5em; margin:0; padding:.55em 1em;
	border-radius:.65em; border:1px solid var(--dpa-border); background:transparent; box-shadow:none;
	font-family:inherit; font-size:.88em; font-weight:600; line-height:1.2; color:var(--dpa-text);
	transition:background-color .2s, color .2s, border-color .2s, transform .12s;
}
.dpa-dash .btn-view i{ color:var(--dpa-link); transition:color .2s; }
.dpa-dash .btn-view:active{ transform:scale(.95); }

.dpa-dash .empty-box{
	display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center;
	gap:.45em; margin:0; padding:3em 1em; color:var(--dpa-muted);
}
.dpa-dash .empty-box i{ font-size:2.8em; opacity:.55; animation:dpaBob 3.4s ease-in-out infinite; }
.dpa-dash .empty-box p{ font-size:1.05em; font-weight:600; color:var(--dpa-text); opacity:.9; }

/* =====================================================================
   BUSINESS ANALYTICS
   ===================================================================== */
.dpa-dash .section-title{ display:flex; align-items:center; gap:.7em; font-size:1.35em; font-weight:700; letter-spacing:-.01em; margin:.4em 0 -.4em; }
.dpa-dash .section-title i{
	width:2.1em; height:2.1em; font-size:.8em; border-radius:.7em;
	display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile);
}
.dpa-dash .chart-container{ display:grid; grid-template-columns:minmax(0, 1.5fr) minmax(0, 1fr); gap:1.1em; margin:0; }
.dpa-dash .chart-card{
	min-width:0; margin:0; padding:1.4em 1.5em 1.5em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .chart-card h3{ display:flex; align-items:center; gap:.6em; font-size:1.02em; font-weight:700; margin:0 0 1em; }
.dpa-dash .chart-card h3 i{ color:var(--dpa-muted); }
.dpa-dash .chart-box{ position:relative; height:21em; }
.dpa-dash .chart-box canvas{ max-width:100%; }
.dpa-dash .chart-empty{
	position:absolute; inset:0; display:none; align-items:center; justify-content:center; text-align:center;
	color:var(--dpa-muted); font-weight:500; padding:1em;
}
.dpa-dash .chart-empty.show{ display:flex; }

/* =====================================================================
   HOVER — mouse only
   ===================================================================== */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ background:#fff; color:#1b1b1b; border-color:#fff; }
	.dpa-dash .summary-card:hover{ transform:translateY(-4px); border-color:var(--acc); }
	.dpa-dash .summary-card:hover .summary-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .search-box:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .rep-row:hover{ background:var(--dpa-hover); }
	.dpa-dash .table-card thead th:not(.nosort):hover{ color:var(--dpa-text); }
	.dpa-dash .btn-view:hover{ background:rgba(43,127,255,.14); border-color:var(--dpa-link); }
	.dpa-dash .info-item:hover{ border-color:var(--dpa-twilight); }
}
.dpa-dash a:focus-visible, .dpa-dash button:focus-visible, .dpa-dash th:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* =====================================================================
   RESPONSIVE
   ===================================================================== */
@media (max-width:1499px){
	.dpa-dash .summary-container{ grid-template-columns:repeat(6, minmax(0, 1fr)); }
	.dpa-dash .summary-container .summary-card:nth-child(-n+3){ grid-column:span 2; }
	.dpa-dash .summary-container .summary-card:nth-child(n+4){ grid-column:span 3; }
	.dpa-dash .info-grid{ grid-template-columns:repeat(3, minmax(0, 1fr)); }
}
@media (max-width:1359px){
	/* the 9-column table becomes cards before it would need to scroll sideways */
	.dpa-dash .table-card thead{ display:none; }
	.dpa-dash .table-card table, .dpa-dash .table-card tbody{ display:block; }
	.dpa-dash .rep-row{ display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:.2em 1.2em; padding:1em 1.2em; border-bottom:1px solid var(--dpa-border); }
	.dpa-dash .rep-row:last-child{ border-bottom:0; }
	.dpa-dash .table-card tbody td{ display:flex; flex-direction:column; align-items:flex-start; gap:.15em; padding:.45em 0; border:0; text-align:left !important; }
	.dpa-dash .table-card tbody td::before{
		content:attr(data-label); font-size:.72em; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--dpa-muted);
	}
	.dpa-dash .table-card tbody td.name{ grid-column:1 / -1; font-size:1.08em; }
	.dpa-dash .table-card tbody td.act{ grid-column:1 / -1; }
	.dpa-dash .table-card tbody td.act::before{ display:none; }
	.dpa-dash .table-card tbody td.act .btn-view{ width:100%; justify-content:center; padding:.8em 1em; }
}
@media (max-width:1100px){
	.dpa-dash .chart-container{ grid-template-columns:minmax(0, 1fr); }
}
@media (max-width:700px){
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .hero-tools{ width:100%; }
	.dpa-dash .hero-btn{ flex:1; justify-content:center; }
	.dpa-dash .summary-container{ grid-template-columns:repeat(2, minmax(0, 1fr)); gap:.8em; }
	.dpa-dash .summary-container .summary-card:nth-child(n){ grid-column:auto; }
	.dpa-dash .summary-container .summary-card:nth-child(5){ grid-column:1 / -1; }
	.dpa-dash .summary-card{ padding:1.1em 1.1em; }
	.dpa-dash .info-card{ padding:1.3em 1.2em; }
	.dpa-dash .info-grid{ grid-template-columns:repeat(2, minmax(0, 1fr)); }
	.dpa-dash .table-top{ padding:1em 1.1em; }
	.dpa-dash .search-box{ width:100%; min-width:0; }
	.dpa-dash .rep-row{ grid-template-columns:repeat(2, minmax(0, 1fr)); }
	.dpa-dash .chart-card{ padding:1.1em 1em 1.2em; }
	.dpa-dash .chart-box{ height:18em; }
}
@media (max-width:380px){
	.dpa-dash .summary-container{ grid-template-columns:minmax(0, 1fr); }
	.dpa-dash .summary-container .summary-card:nth-child(5){ grid-column:auto; }
}

@media print{
	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-dash{ --dpa-text:#000; --dpa-muted:#444; --dpa-surface:#fff; --dpa-surface-2:#fff; --dpa-border:#bbb; --dpa-tile:#eee; }
	.dpa-js .dpa-dash .reveal, .dpa-dash .rep-row{ opacity:1 !important; animation:none !important; }
	.dpa-dash .page-header{ background:#fff; color:#000; border-color:#bbb; }
	.dpa-dash .page-header *{ color:#000 !important; }
	.dpa-dash .hero-watermark{ display:none; }
	.dpa-dash .hero-tools, .dpa-dash .search-box, .dpa-dash td.act, .dpa-dash th.nosort{ display:none; }
	.dpa-dash .progress-fill{ width:var(--pct, 0%) !important; transition:none; }
	.dpa-dash .rep-row[hidden]{ display:table-row !important; }
	.dpa-dash .chart-container{ break-inside:avoid; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal, .dpa-dash .rep-row{ opacity:1; }
	.dpa-dash .summary-card::before{ transform:scaleX(1); }
}
</style>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>\n</head>
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

<!-- ================= MOBILE TOP BAR ================= -->
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

  <div class="customer-reports-page dpa-dash">

    <div class="page-header">

        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>

        <div class="hero-left">

            <div class="hero-icon">

                <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M21.21 15.89A10 10 0 1 1 8 2.83"/><path d="M22 12A10 10 0 0 0 12 2v10z"/></svg></i>

            </div>

            <div>

                <h1 class="page-title">Customer Reports</h1>

                <p>Income, events and payment status for every customer.</p>

            </div>

        </div>

        <div class="hero-tools">

            <button type="button" class="hero-btn" id="printBtn">

                <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><path d="M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6"/><rect x="6" y="14" width="12" height="8" rx="1"/></svg></i> Print

            </button>

            <button type="button" class="hero-btn" id="csvBtn">

                <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M8 13h2"/><path d="M14 13h2"/><path d="M8 17h2"/><path d="M14 17h2"/></svg></i> Export CSV

            </button>

        </div>

    </div>

<!-- ==========================
     SUMMARY CARDS
=========================== -->

<div class="summary-container">

    <div class="summary-card stat-blue reveal">

        <div class="sc-top"><p>Total Customers</p><div class="summary-icon"><i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i></div></div>

        <h2 data-count="<%= customersCount %>"><%= customersCount %></h2>

    </div>

    <div class="summary-card stat-purple reveal">

        <div class="sc-top"><p>Total Events</p><div class="summary-icon"><i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg></i></div></div>

        <h2 data-count="<%= eventsCount %>"><%= eventsCount %></h2>

    </div>

    <div class="summary-card stat-teal reveal">

        <div class="sc-top"><p>Bulk Events</p><div class="summary-icon"><i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i></div></div>

        <h2 data-count="<%= bulkEventsCount %>"><%= bulkEventsCount %></h2>

    </div>

    <div class="summary-card stat-green reveal">

        <div class="sc-top"><p>Received Amount</p><div class="summary-icon"><i><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i></div></div>

        <h2 data-money="<%= String.format(Locale.US, "%.2f", receivedTotal) %>">₹ <%= String.format(Locale.US, "%.2f", receivedTotal) %></h2>

    </div>

    <div class="summary-card stat-orange reveal">

        <div class="sc-top"><p>Pending Amount</p><div class="summary-icon"><i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 22h14"/><path d="M5 2h14"/><path d="M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22"/><path d="M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2"/></svg></i></div></div>

        <h2 data-money="<%= String.format(Locale.US, "%.2f", pendingTotal) %>">₹ <%= String.format(Locale.US, "%.2f", pendingTotal) %></h2>

    </div>

</div>

<!-- ==========================
     CUSTOMER REPORT SUMMARY
=========================== -->

<div class="info-card reveal">

<h2>

<i><svg viewBox="0 0 24 24" aria-hidden="true"><rect width="8" height="4" x="8" y="2" rx="1" ry="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><path d="M12 11h4"/><path d="M12 16h4"/><path d="M8 11h.01"/><path d="M8 16h.01"/></svg></i> Customer Report Summary

</h2>

<div class="info-grid">

    <div class="info-item"><b>Total Customers</b><span><%= customersCount %></span></div>

    <div class="info-item"><b>Total Events</b><span><%= eventsCount %></span></div>

    <div class="info-item"><b>Bulk Events</b><span><%= bulkEventsCount %></span></div>

    <div class="info-item good"><b>Total Received</b><span class="money-text" data-raw="<%= String.format(Locale.US, "%.2f", receivedTotal) %>">₹ <%= String.format(Locale.US, "%.2f", receivedTotal) %></span></div>

    <div class="info-item bad"><b>Total Pending</b><span class="money-text" data-raw="<%= String.format(Locale.US, "%.2f", pendingTotal) %>">₹ <%= String.format(Locale.US, "%.2f", pendingTotal) %></span></div>

</div>

<div class="progress-head"><span>Collected so far</span><strong id="collectPct">0%</strong></div>

<div class="progress-track" id="collectTrack" data-received="<%= receivedTotal %>" data-pending="<%= pendingTotal %>"><div class="progress-fill" id="collectFill"></div><div class="progress-rest"></div></div>

</div>

<!-- ==========================
     CUSTOMER REPORT TABLE
=========================== -->

<div class="table-card reveal">



<div class="table-top">

    <h2><i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i> Customers <small id="rowCount">9 records</small></h2>

    <label class="search-box">

        <i><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>

        <input
        type="text"
        id="searchInput"
        class="search-input"
        autocomplete="off"
        placeholder="Search Customer...">

    </label>

</div>

<div class="table-wrap">

<table id="customerTable">

<thead>

<tr>

<th data-type="text">Customer Name</th>

<th data-type="text">Phone</th>

<th data-type="num" class="center">Events</th>

<th data-type="num" class="center">Bulk Events</th>

<th data-type="num" class="right">Total Amount</th>

<th data-type="num" class="right">Received</th>

<th data-type="num" class="right">Pending</th>

<th data-type="text">Status</th>

<th class="nosort right">Action</th>

</tr>

</thead>

<tbody>
<%
    if (reports != null && !reports.isEmpty()) {
        for (CustomerReport report : reports) {
            double totalAmount = report.getTotalAmount();
            double receivedAmount = report.getReceivedAmount();
            double pendingAmount = report.getPendingAmount();
            String status = report.getPaymentStatus();
            if (status == null || status.trim().isEmpty()) {
                status = pendingAmount <= 0.0001 ? "PAID" : (receivedAmount > 0.0001 ? "PARTIAL" : "PENDING");
            } else {
                status = status.trim().toUpperCase(Locale.ROOT);
                if (pendingAmount <= 0.0001) status = "PAID";
                else if (receivedAmount > 0.0001) status = "PARTIAL";
                else status = "PENDING";
            }
            String statusClass = "PAID".equals(status) ? "status-paid" : ("PARTIAL".equals(status) ? "status-partial" : "status-pending");
%>
<tr class="rep-row">
    <td class="name" data-label="Customer Name"><%= report.getCustomerName() == null ? "" : report.getCustomerName() %></td>
    <td data-label="Phone"><%= report.getPhone() == null ? "" : report.getPhone() %></td>
    <td class="center" data-label="Events"><%= report.getTotalEvents() %></td>
    <td class="center" data-label="Bulk Events"><%= report.getTotalBulkEvents() %></td>
    <td class="money" data-label="Total Amount" data-raw="<%= String.format(Locale.US, "%.2f", totalAmount) %>">₹ <%= String.format(Locale.US, "%.2f", totalAmount) %></td>
    <td class="money recv" data-label="Received" data-raw="<%= String.format(Locale.US, "%.2f", receivedAmount) %>">₹ <%= String.format(Locale.US, "%.2f", receivedAmount) %></td>
    <td class="money pend" data-label="Pending" data-raw="<%= String.format(Locale.US, "%.2f", pendingAmount) %>">₹ <%= String.format(Locale.US, "%.2f", pendingAmount) %></td>
    <td data-label="Status"><span class="<%= statusClass %>"><%= status %></span></td>
    <td class="act" data-label="Action">
        <a class="btn-view" href="${pageContext.request.contextPath}/customer-report-details?customerId=<%= report.getCustomerId() %>">
            <i class="fa-solid fa-eye" aria-hidden="true"></i> View
        </a>
    </td>
</tr>
<%
        }
    } else {
%>
<tr class="empty-row"><td colspan="9">No Customer Report Records Found.</td></tr>
<% } %>
</tbody>

</table>

<div class="no-match" id="noMatch">No customers match your search.</div>

</div>



</div>

<!-- =====================================================
                    BUSINESS ANALYTICS
====================================================== -->

<h2 class="section-title">

<i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 3v16a2 2 0 0 0 2 2h16"/><path d="M18 17V9"/><path d="M13 17V5"/><path d="M8 17v-3"/></svg></i> Business Analytics

</h2>

<div class="chart-container">

    <div class="chart-card reveal" data-chart="bar">

        <h3>

            <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 3v16a2 2 0 0 0 2 2h16"/><path d="M18 17V9"/><path d="M13 17V5"/><path d="M8 17v-3"/></svg></i> Customer-wise Received Amount

        </h3>

        <div class="chart-box">

            <canvas
                id="customerIncomeChart"
                height="120">

            </canvas>

            <div class="chart-empty">No received payments to chart yet.</div>

        </div>

    </div>

    <div class="chart-card reveal" data-chart="doughnut">

        <h3>

            <i><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M21.21 15.89A10 10 0 1 1 8 2.83"/><path d="M22 12A10 10 0 0 0 12 2v10z"/></svg></i> Payment Status Distribution

        </h3>

        <div class="chart-box">

            <canvas
                id="paymentStatusChart"
                height="120">

            </canvas>

            <div class="chart-empty">No payment data to chart yet.</div>

        </div>

    </div>

</div>

  </div>

</div>

<script>

/* data for the two charts, from the request attributes */
const graphLabels=[
<%
if (graphLabels != null) {
    for (int i = 0; i < graphLabels.size(); i++) {
%>
"<%= reportJsEscape(graphLabels.get(i)) %>"<%= i < graphLabels.size() - 1 ? "," : "" %>
<%
    }
}
%>
];

const graphValues=[
<%
if (graphValues != null) {
    for (int i = 0; i < graphValues.size(); i++) {
        Double value = graphValues.get(i);
%>
<%= value == null ? 0 : value %><%= i < graphValues.size() - 1 ? "," : "" %>
<%
    }
}
%>
];

const paymentLabels=[
<%
if (paymentStatus != null) {
    int i = 0;
    for (String key : paymentStatus.keySet()) {
%>
"<%= reportJsEscape(key) %>"<%= ++i < paymentStatus.size() ? "," : "" %>
<%
    }
}
%>
];

const paymentValues=[
<%
if (paymentStatus != null) {
    int i = 0;
    for (Integer value : paymentStatus.values()) {
%>
<%= value == null ? 0 : value %><%= ++i < paymentStatus.size() ? "," : "" %>
<%
    }
}
%>
];

</script>

<!-- page behaviour: animations, charts (theme-aware), search, sort, print, CSV export -->
<script>
(function () {
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var page = document.querySelector('.dpa-dash');
	if (!page) return;

	/* ---------- number helpers ---------- */
	function num(t) { var n = parseFloat(String(t).replace(/[^0-9.\-]/g, '')); return isNaN(n) ? 0 : n; }
	var nf2 = new Intl.NumberFormat('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
	var nf0 = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 });
	function money(n) { return '₹ ' + nf2.format(n); }
	function isNum(s) { return /^-?\d+(\.\d+)?$/.test(s); }

	/* amounts with Indian digit grouping (the raw value stays in data-raw) */
	page.querySelectorAll('td.money[data-raw], .money-text[data-raw]').forEach(function (el) {
		var raw = el.getAttribute('data-raw');
		if (isNum(raw)) el.textContent = money(parseFloat(raw));
	});
	page.querySelectorAll('h2[data-money]').forEach(function (h) {
		var raw = h.getAttribute('data-money');
		if (isNum(raw)) h.textContent = money(parseFloat(raw));
	});

	/* ---------- count-up ---------- */
	function countUp(el) {
		if (el.dataset.counted) return; el.dataset.counted = '1';
		var isMoney = el.hasAttribute('data-money');
		var raw = el.getAttribute(isMoney ? 'data-money' : 'data-count');
		if (!isNum(raw)) return;
		var target = parseFloat(raw);
		var fmt = function (v) { return isMoney ? money(v) : nf0.format(Math.round(v)); };
		var finalText = isMoney ? money(target) : el.textContent;
		if (reduce || target === 0) { el.textContent = isMoney ? finalText : String(raw); return; }
		var start = null, dur = 1100;
		function tick(ts) {
			if (start === null) start = ts;
			var p = Math.min((ts - start) / dur, 1), e = 1 - Math.pow(1 - p, 3);
			el.textContent = fmt(target * e);
			if (p < 1) requestAnimationFrame(tick); else el.textContent = finalText;
		}
		requestAnimationFrame(tick);
	}

	/* ---------- collected-so-far bar ---------- */
	var track = document.getElementById('collectTrack'), pct = 0;
	if (track) {
		var r = parseFloat(track.getAttribute('data-received')) || 0, p = parseFloat(track.getAttribute('data-pending')) || 0;
		pct = (r + p) > 0 ? Math.round(r / (r + p) * 100) : 0;
		track.style.setProperty('--pct', pct + '%');
		document.getElementById('collectPct').textContent = pct + '%';
	}

	/* ---------- charts (colours follow the dark / light theme) ---------- */
	var charts = [];
	function themeColors() {
		var cs = getComputedStyle(document.documentElement);
		function v(n, d) { var x = cs.getPropertyValue(n).trim(); return x || d; }
		return { text: v('--dpa-text', '#f5f5f5'), muted: v('--dpa-muted', '#999'), grid: v('--dpa-border', 'rgba(255,255,255,.09)'), surface: v('--dpa-surface', '#10141c') };
	}
	function paint(chart) {
		var c = themeColors(), o = chart.options;
		if (o.scales && o.scales.x) { o.scales.x.ticks.color = c.muted; o.scales.x.grid.color = 'transparent'; o.scales.x.border = { color: c.grid }; }
		if (o.scales && o.scales.y) { o.scales.y.ticks.color = c.muted; o.scales.y.grid.color = c.grid; o.scales.y.border = { display: false }; }
		if (o.plugins && o.plugins.legend && o.plugins.legend.labels) o.plugins.legend.labels.color = c.text;
		if (chart.config.type === 'doughnut') chart.data.datasets[0].borderColor = c.surface;
		chart.update('none');
	}
	var STATUS_COLOR = { PAID: '#34d399', PARTIAL: '#f0a43a', PENDING: '#ff6b6b' };
	var FALLBACK = ['#2b7fff', '#9b7bff', '#22c1c3', '#e879f9', '#facc15'];

	function showEmpty(card, msg) { var e = card.querySelector('.chart-empty'); if (msg) e.textContent = msg; e.classList.add('show'); card.querySelector('canvas').style.display = 'none'; }

	function buildBar(card) {
		var canvas = card.querySelector('canvas');
		if (typeof Chart === 'undefined') return showEmpty(card, 'Charts could not be loaded (check your internet connection).');
		if (!graphLabels.length) return showEmpty(card);
		var c = themeColors();
		var ch = new Chart(canvas, {
			type: 'bar',
			data: { labels: graphLabels, datasets: [{ label: 'Received Amount', data: graphValues, backgroundColor: '#1fbf6a', hoverBackgroundColor: '#34d399', borderRadius: 8, borderSkipped: false, maxBarThickness: 46 }] },
			options: {
				responsive: true, maintainAspectRatio: false,
				animation: reduce ? false : { duration: 1100, easing: 'easeOutQuart' },
				plugins: { legend: { display: false }, tooltip: { callbacks: { label: function (x) { return ' ' + money(x.parsed.y); } } } },
				scales: {
					x: { ticks: { color: c.muted, maxRotation: 40 }, grid: { color: 'transparent' } },
					y: { beginAtZero: true, ticks: { color: c.muted, callback: function (v) { return '₹ ' + nf0.format(v); } }, grid: { color: c.grid } }
				}
			}
		});
		charts.push(ch); paint(ch);
	}
	function buildDoughnut(card) {
		var canvas = card.querySelector('canvas');
		if (typeof Chart === 'undefined') return showEmpty(card, 'Charts could not be loaded (check your internet connection).');
		var total = paymentValues.reduce(function (a, b) { return a + b; }, 0);
		if (!paymentLabels.length || total === 0) return showEmpty(card);
		var colors = paymentLabels.map(function (l, i) { return STATUS_COLOR[String(l).toUpperCase()] || FALLBACK[i % FALLBACK.length]; });
		var c = themeColors();
		var ch = new Chart(canvas, {
			type: 'doughnut',
			data: { labels: paymentLabels, datasets: [{ data: paymentValues, backgroundColor: colors, borderColor: c.surface, borderWidth: 3, hoverOffset: 8 }] },
			options: {
				responsive: true, maintainAspectRatio: false, cutout: '66%',
				animation: reduce ? false : { duration: 1200, animateRotate: true, animateScale: true },
				plugins: { legend: { position: 'bottom', labels: { color: c.text, usePointStyle: true, pointStyle: 'circle', padding: 16 } },
					tooltip: { callbacks: { label: function (x) { var s = x.dataset.data.reduce(function (a, b) { return a + b; }, 0); return ' ' + x.label + ': ' + x.parsed + ' (' + Math.round(x.parsed / s * 100) + '%)'; } } } }
			}
		});
		charts.push(ch); paint(ch);
	}
	window.addEventListener('dpa-theme-change', function () { charts.forEach(paint); });

	/* ---------- reveal on scroll ---------- */
	['.summary-container'].forEach(function (sel) {
		page.querySelectorAll(sel).forEach(function (g) { Array.prototype.forEach.call(g.children, function (el, i) { el.style.setProperty('--d', (i * 80) + 'ms'); }); });
	});
	page.querySelectorAll('.chart-card').forEach(function (el, i) { el.style.setProperty('--d', (i * 120) + 'ms'); });
	function reveal(el) {
		el.classList.add('in');
		el.querySelectorAll('h2[data-count], h2[data-money]').forEach(countUp);
		if (el.matches('h2[data-count], h2[data-money]')) countUp(el);
		if (el.querySelector('#collectFill')) { var f = document.getElementById('collectFill'); requestAnimationFrame(function () { f.style.width = pct + '%'; }); }
		if (el.dataset.chart === 'bar') buildBar(el);
		if (el.dataset.chart === 'doughnut') buildDoughnut(el);
	}
	var targets = page.querySelectorAll('.reveal');
	if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
		}, { threshold: 0.1, rootMargin: '0px 0px -30px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}

	/* ---------- table: search, sort, CSV, print ---------- */
	var table = document.getElementById('customerTable');
	if (table) {
		var tbody = table.tBodies[0];
		var rows = Array.prototype.slice.call(tbody.querySelectorAll('.rep-row'));
		var countEl = document.getElementById('rowCount'), noMatch = document.getElementById('noMatch');
		rows.forEach(function (r, i) { r.style.setProperty('--i', Math.min(i, 14)); });

		var search = document.getElementById('searchInput');
		function applyFilter() {
			var q = search.value.trim().toLowerCase(), shown = 0;
			rows.forEach(function (r) { var ok = !q || r.textContent.toLowerCase().indexOf(q) > -1; r.hidden = !ok; if (ok) shown++; });
			noMatch.classList.toggle('show', shown === 0);
			if (countEl) countEl.textContent = (q ? shown + ' of ' + rows.length : rows.length) + ' records';
		}
		search.addEventListener('input', applyFilter);

		var heads = Array.prototype.slice.call(table.tHead.rows[0].cells);
		heads.forEach(function (th, idx) {
			if (th.classList.contains('nosort')) return;
			th.setAttribute('tabindex', '0');
			function sort() {
				var dir = th.getAttribute('aria-sort') === 'ascending' ? 'descending' : 'ascending';
				heads.forEach(function (h) { h.removeAttribute('aria-sort'); });
				th.setAttribute('aria-sort', dir);
				var type = th.dataset.type;
				function val(tr) { var td = tr.cells[idx]; return type === 'num' ? num(td.getAttribute('data-raw') || td.textContent) : td.textContent.trim().toLowerCase(); }
				rows.sort(function (a, b) { var x = val(a), y = val(b); return (x < y ? -1 : x > y ? 1 : 0) * (dir === 'ascending' ? 1 : -1); });
				rows.forEach(function (r) { tbody.appendChild(r); });
			}
			th.addEventListener('click', sort);
			th.addEventListener('keydown', function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); sort(); } });
		});

		/* export what is currently shown (opens cleanly in Excel, including ₹ and Telugu text) */
		document.getElementById('csvBtn').addEventListener('click', function () {
			function q(s) { return '"' + String(s).replace(/"/g, '""') + '"'; }
			var cols = heads.length - 1;   /* everything except the Action column */
			var lines = [heads.slice(0, cols).map(function (h) { return q(h.textContent.trim()); }).join(',')];
			rows.forEach(function (r) {
				if (r.hidden) return;
				var cells = [];
				for (var i = 0; i < cols; i++) { var td = r.cells[i]; cells.push(q(td.hasAttribute('data-raw') ? td.getAttribute('data-raw') : td.textContent.replace(/\s+/g, ' ').trim())); }
				lines.push(cells.join(','));
			});
			var blob = new Blob([String.fromCharCode(0xFEFF) + lines.join(String.fromCharCode(13, 10))], { type: 'text/csv;charset=utf-8;' });
			var a = document.createElement('a');
			a.href = URL.createObjectURL(blob); a.download = 'customer-report.csv';
			document.body.appendChild(a); a.click(); document.body.removeChild(a);
			setTimeout(function () { URL.revokeObjectURL(a.href); }, 1000);
		});
	} else {
		var csv = document.getElementById('csvBtn'); if (csv) csv.style.display = 'none';
	}
	document.getElementById('printBtn').addEventListener('click', function () { window.print(); });
})();
</script>


</body>
</html>