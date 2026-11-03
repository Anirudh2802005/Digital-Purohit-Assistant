<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Locale" %>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer" %>
<%!
    private String esc(Object value) {
        if (value == null) return "";
        return String.valueOf(value).replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    private String money(double value) {
        return String.format(Locale.US, "%.2f", value);
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bulk Event Report | Digital Purohit Assistant</title>
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
   BULK EVENT REPORT — same design system as dashboard / payments / reports
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
@keyframes dpaRow{ from{ opacity:0; translate:-12px 0; } to{ opacity:1; translate:0 0; } }
@keyframes dpaBlink{ 0%,100%{ opacity:1; } 50%{ opacity:.35; } }
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
	display:inline-flex; align-items:center; gap:.55em; padding:.8em 1.15em; border-radius:1em;
	border:1px solid rgba(255,255,255,.16); background:rgba(255,255,255,.07);
	-webkit-backdrop-filter:blur(10px); backdrop-filter:blur(10px);
	color:#fff; font-size:.95em; font-weight:600;
	transition:background-color .2s, border-color .2s, transform .25s cubic-bezier(.2,.8,.2,1);
}
.dpa-dash .hero-btn i{ display:inline-flex; transition:transform .3s cubic-bezier(.34,1.56,.64,1); }

/* =====================================================================
   SUMMARY CARDS
   ===================================================================== */
.dpa-dash .report-summary{ display:grid; grid-template-columns:repeat(3, minmax(0, 1fr)); gap:1.1em; margin:0; }
.dpa-dash .summary-card{
	--acc:#2b7fff; --acc-soft:rgba(43,127,255,.16);
	position:relative; overflow:hidden; display:flex; align-items:center; gap:1.1em;
	margin:0; padding:1.5em 1.6em; container-type:inline-size;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .stat-blue{ --acc:#2b7fff; --acc-soft:rgba(43,127,255,.16); }
.dpa-dash .stat-green{ --acc:#1fbf6a; --acc-soft:rgba(31,191,106,.16); }
.dpa-dash .stat-purple{ --acc:#9b7bff; --acc-soft:rgba(155,123,255,.17); }
.dpa-dash .summary-card::before{
	content:""; position:absolute; left:0; top:0; height:3px; width:100%; background:var(--acc);
	transform:scaleX(0); transform-origin:left; transition:transform .9s cubic-bezier(.2,.8,.2,1) .25s;
}
.dpa-dash .summary-card.in::before, html:not(.dpa-js) .dpa-dash .summary-card::before{ transform:scaleX(1); }
.dpa-dash .summary-icon{
	flex-shrink:0; width:3.2em; height:3.2em; border-radius:1em; font-size:1.15em;
	display:flex; align-items:center; justify-content:center;
	background:var(--acc-soft); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .summary-text{ min-width:0; }
.dpa-dash .summary-value{
	font-size:2em; font-size:clamp(1.35em, 11cqw, 2.2em); font-weight:700; line-height:1.05; letter-spacing:-.02em;
	font-variant-numeric:tabular-nums; color:var(--dpa-text); overflow-wrap:anywhere;
}
.dpa-dash .summary-label{ margin-top:.35em; font-size:.86em; font-weight:600; letter-spacing:.02em; color:var(--dpa-muted); }
.dpa-dash .summary-sub{ margin-top:.2em; font-size:.8em; font-weight:500; color:var(--dpa-muted); font-variant-numeric:tabular-nums; }
.dpa-dash .summary-sub .p-paid{ color:var(--good); }
.dpa-dash .summary-sub .p-pend{ color:var(--bad2); }

/* =====================================================================
   TOOLBAR (search + actions)
   ===================================================================== */
.dpa-dash .report-toolbar{
	display:flex; align-items:center; justify-content:space-between; gap:.9em; flex-wrap:wrap;
	margin:0; padding:1em 1.3em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); transition:background-color .35s, border-color .35s;
}
.dpa-dash .report-search{ flex:1; min-width:14em; }
.dpa-dash .search-field{
	display:flex; align-items:center; gap:.7em; padding:0 1em;
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
.dpa-dash .report-actions{ display:flex; gap:.6em; flex-wrap:wrap; }
.dpa-dash .action-btn{
	display:inline-flex; align-items:center; justify-content:center; gap:.55em; margin:0; padding:.72em 1.15em;
	border-radius:.8em; border:1px solid var(--acc); background:transparent; box-shadow:none;
	font-family:inherit; font-size:.92em; font-weight:700; line-height:1.2; color:var(--acc); white-space:nowrap; cursor:pointer;
	transition:background-color .2s, color .2s, transform .25s cubic-bezier(.2,.8,.2,1), box-shadow .25s;
}
.dpa-dash .action-btn i{ display:inline-flex; transition:transform .35s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .action-btn:active{ transform:scale(.96); }
.dpa-dash .print-btn{ --acc:#2b7fff; }
.dpa-dash .pdf-btn{ --acc:#ff6b6b; }
.dpa-dash .excel-btn{ --acc:#1fbf6a; }

/* =====================================================================
   TABLE CARD
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
.dpa-dash .count-badge{
	padding:.3em .85em; border-radius:999px; font-size:.82em; font-weight:700;
	background:rgba(155,123,255,.16); color:#9b7bff; font-variant-numeric:tabular-nums;
}
:root[data-theme="light"] .dpa-dash .count-badge{ color:#6d4fe0; }
.dpa-dash .table-wrap{ overflow-x:auto; }
.dpa-dash .report-table{ width:100%; border-collapse:collapse; margin:0; background:transparent; font-size:.95em; }
.dpa-dash .report-table thead th{
	padding:.9em 1.1em; text-align:left; white-space:nowrap; background:transparent; color:var(--dpa-muted);
	font-size:.74em; font-weight:700; letter-spacing:.09em; text-transform:uppercase;
	border:0; border-bottom:1px solid var(--dpa-border); cursor:pointer; user-select:none; transition:color .2s;
}
.dpa-dash .report-table thead th.right{ text-align:right; }
.dpa-dash .report-table thead th::after{ content:"\2195"; margin-left:.45em; opacity:.35; font-size:1.1em; }
.dpa-dash .report-table thead th[aria-sort="ascending"]::after{ content:"\2191"; opacity:1; color:var(--dpa-link); }
.dpa-dash .report-table thead th[aria-sort="descending"]::after{ content:"\2193"; opacity:1; color:var(--dpa-link); }
.dpa-dash .report-table tbody td{
	padding:.95em 1.1em; border:0; border-bottom:1px solid var(--dpa-border); background:transparent; color:var(--dpa-text);
	vertical-align:middle; text-align:left;
}
.dpa-dash .report-table tbody tr:last-child td{ border-bottom:0; }
.dpa-dash .report-table tbody td:first-child{ font-weight:600; }
.dpa-dash .report-table tbody td:nth-child(2){ white-space:nowrap; color:var(--dpa-muted); font-variant-numeric:tabular-nums; }
.dpa-dash .report-table td.money{ text-align:right; font-variant-numeric:tabular-nums; white-space:nowrap; }
.dpa-dash .report-table td.money.paidamt{ color:var(--good); font-weight:600; }
.dpa-dash .report-table td.money.due{ color:var(--bad2); font-weight:700; }
.dpa-dash .rep-row{ transition:background-color .2s; animation:dpaRow .55s cubic-bezier(.2,.8,.2,1) both; animation-delay:calc(var(--i, 0) * 45ms + 250ms); }
.dpa-dash .rep-row[hidden]{ display:none !important; }
.dpa-dash .no-match{ display:none; padding:2em 1em; text-align:center; color:var(--dpa-muted); }
.dpa-dash .no-match.show{ display:block; }

/* status pills */
.dpa-dash .status{
	display:inline-flex; align-items:center; gap:.5em; padding:.3em .9em; border-radius:999px;
	font-size:.76em; font-weight:700; letter-spacing:.06em; text-transform:uppercase; white-space:nowrap;
	transition:transform .25s cubic-bezier(.34,1.56,.64,1), box-shadow .25s;
}
.dpa-dash .status::before{ content:""; width:.5em; height:.5em; border-radius:50%; background:currentColor; }
.dpa-dash .status.pending{ background:rgba(255,107,107,.15); color:var(--bad2); }
.dpa-dash .status.pending::before{ animation:dpaBlink 1.6s ease-in-out infinite; }
.dpa-dash .status.partial{ background:rgba(240,164,58,.16); color:var(--pend); }
.dpa-dash .status.paid{ background:rgba(52,211,153,.15); color:var(--good); }
.dpa-dash .status-link{ display:inline-block; border-radius:999px; }
.dpa-dash .status-link .status::after{ content:"\2192"; margin-left:.15em; transition:transform .25s; }

/* receive payment button */
.dpa-dash .stat-orange{ --acc:#f0a43a; --acc-soft:rgba(240,164,58,.17); }
.dpa-dash .stat-red{ --acc:#ff6b6b; --acc-soft:rgba(255,107,107,.16); }
.dpa-dash .stat-teal{ --acc:#14b8c4; --acc-soft:rgba(20,184,196,.16); }
.dpa-dash .count-badge{ background:rgba(43,127,255,.16); color:var(--dpa-link); }
.dpa-dash .report-table td.act{ text-align:right; white-space:nowrap; }
.dpa-dash .report-table thead th.nosort{ cursor:default; text-align:right; }
.dpa-dash .report-table thead th.nosort::after{ content:none; }
.dpa-dash .dash-none{ color:var(--dpa-muted); }
.dpa-dash .btn-pay{
	display:inline-flex; align-items:center; gap:.5em; padding:.55em 1em; border-radius:.7em;
	border:1px solid var(--good); background:transparent; color:var(--good);
	font-size:.88em; font-weight:700; line-height:1.2; white-space:nowrap;
	transition:background-color .2s, color .2s, transform .25s cubic-bezier(.2,.8,.2,1), box-shadow .25s;
}
.dpa-dash .btn-pay i{ display:inline-flex; transition:transform .35s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .btn-pay:active{ transform:scale(.96); }

/* empty state */
.dpa-dash .empty-box{
	display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center;
	gap:.45em; margin:0; padding:2.8em 1em; color:var(--dpa-muted);
}
.dpa-dash .empty-box i{ font-size:2.6em; opacity:.55; animation:dpaBob 3.4s ease-in-out infinite; }
.dpa-dash .empty-box p{ font-size:1.05em; font-weight:600; color:var(--dpa-text); opacity:.9; }

/* =====================================================================
   HOVER — mouse only
   ===================================================================== */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ background:rgba(255,255,255,.14); border-color:rgba(255,255,255,.35); transform:translateY(-2px); }
	.dpa-dash .hero-btn:hover i{ transform:translateX(-3px); }
	.dpa-dash .summary-card:hover{ transform:translateY(-4px); border-color:var(--acc); }
	.dpa-dash .summary-card:hover .summary-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .search-field:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .action-btn:hover{ background:var(--acc); color:#fff; transform:translateY(-2px); box-shadow:0 8px 20px rgba(0,0,0,.28); }
	.dpa-dash .action-btn:hover i{ transform:rotate(-10deg) scale(1.15); }
	.dpa-dash .rep-row:hover{ background:var(--dpa-hover); }
	.dpa-dash .report-table thead th:hover{ color:var(--dpa-text); }
	.dpa-dash .status-link:hover .status{ transform:translateY(-2px); box-shadow:0 6px 16px rgba(0,0,0,.28); }
	.dpa-dash .btn-pay:hover{ background:var(--good); color:#fff; transform:translateY(-2px); box-shadow:0 8px 20px rgba(31,157,85,.35); }
	.dpa-dash .btn-pay:hover i{ transform:rotate(-12deg) scale(1.15); }
	.dpa-dash .status-link:hover .status::after{ transform:translateX(3px); }
}
.dpa-dash a:focus-visible, .dpa-dash button:focus-visible, .dpa-dash th:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* =====================================================================
   RESPONSIVE
   ===================================================================== */
@media (max-width:1100px){
	.dpa-dash .report-summary{ grid-template-columns:repeat(2, minmax(0, 1fr)); }
}
@media screen and (max-width:1279px){
	/* the table becomes cards before it would need to scroll sideways */
	.dpa-dash .report-table thead{ display:none; }
	.dpa-dash .report-table, .dpa-dash .report-table tbody{ display:block; }
	.dpa-dash .rep-row{ display:grid; grid-template-columns:repeat(3, minmax(0, 1fr)); gap:.2em 1.2em; padding:1em 1.2em; border-bottom:1px solid var(--dpa-border); }
	.dpa-dash .rep-row:last-child{ border-bottom:0; }
	.dpa-dash .report-table tbody td{ display:flex; flex-direction:column; align-items:flex-start; gap:.15em; padding:.45em 0; border:0; text-align:left !important; }
	.dpa-dash .report-table tbody td::before{
		content:attr(data-label); font-size:.72em; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--dpa-muted);
	}
	.dpa-dash .rep-row td:first-child, .dpa-dash .rep-row td.act{ grid-column:1 / -1; }
	.dpa-dash .rep-row td:first-child{ font-size:1.08em; }
	.dpa-dash .rep-row td.act{ text-align:left !important; }
	.dpa-dash .rep-row td.act::before{ display:none; }
	.dpa-dash .rep-row td.act .btn-pay{ width:100%; justify-content:center; padding:.8em 1em; }
	.dpa-dash .report-table tbody td.empty-box{ grid-column:1 / -1; align-items:center; }
	.dpa-dash .report-table tbody td.empty-box::before{ display:none; }
}
@media screen and (max-width:700px){
	.dpa-dash .rep-row{ grid-template-columns:repeat(2, minmax(0, 1fr)); }
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-btn{ width:100%; justify-content:center; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .report-summary{ grid-template-columns:minmax(0, 1fr); gap:.8em; }
	.dpa-dash .summary-card{ padding:1.2em 1.3em; }
	.dpa-dash .section-top{ padding:1em 1.1em; }
	.dpa-dash .report-actions{ width:100%; }
	.dpa-dash .action-btn{ flex:1; }
}

/* ---------- print: clean table only ---------- */
@media print{
	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-dash{ --dpa-text:#000; --dpa-muted:#444; --dpa-surface:#fff; --dpa-surface-2:#fff; --dpa-border:#bbb; --dpa-tile:#eee; --good:#168a4a; --pend:#b45f06; --bad2:#c93434; }
	.dpa-js .dpa-dash .reveal, .dpa-dash .rep-row{ opacity:1 !important; animation:none !important; }
	.dpa-dash .page-header{ background:#fff; color:#000; border-color:#bbb; }
	.dpa-dash .page-header *{ color:#000 !important; }
	.dpa-dash .hero-watermark, .dpa-dash .hero-btn, .dpa-dash .report-toolbar, .dpa-dash th.nosort, .dpa-dash td.act{ display:none; }
	.dpa-dash .rep-row[hidden]{ display:none !important; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal, .dpa-dash .rep-row{ opacity:1; }
	.dpa-dash .summary-card::before{ transform:scaleX(1); }
}
</style>
</head>
<%
    Integer bulkEventIdAttr = (Integer) request.getAttribute("bulkEventId");
    int bulkEventId = bulkEventIdAttr == null ? 0 : bulkEventIdAttr.intValue();
    Integer totalFamiliesAttr = (Integer) request.getAttribute("totalFamilies");
    Integer paidFamiliesAttr = (Integer) request.getAttribute("paidFamilies");
    Integer pendingFamiliesAttr = (Integer) request.getAttribute("pendingFamilies");
    Double totalAmountAttr = (Double) request.getAttribute("totalAmount");
    Double collectedAmountAttr = (Double) request.getAttribute("collectedAmount");
    Double pendingAmountAttr = (Double) request.getAttribute("pendingAmount");
    int totalFamilies = totalFamiliesAttr == null ? 0 : totalFamiliesAttr.intValue();
    int paidFamilies = paidFamiliesAttr == null ? 0 : paidFamiliesAttr.intValue();
    int pendingFamilies = pendingFamiliesAttr == null ? 0 : pendingFamiliesAttr.intValue();
    double totalAmount = totalAmountAttr == null ? 0.0 : totalAmountAttr.doubleValue();
    double collectedAmount = collectedAmountAttr == null ? 0.0 : collectedAmountAttr.doubleValue();
    double pendingAmount = pendingAmountAttr == null ? 0.0 : pendingAmountAttr.doubleValue();
    List<BulkEventCustomer> families = (List<BulkEventCustomer>) request.getAttribute("families");
    if (families == null) families = java.util.Collections.emptyList();
    String ctx = request.getContextPath();
%>
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

  <div class="bulk-report-page dpa-dash">

    <!-- ================= PAGE HEADER ================= -->
    <div class="page-header report-page-header">

        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>

        <div class="hero-left">

            <div class="hero-icon">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 3v16a2 2 0 0 0 2 2h16"/><path d="M18 17V9"/><path d="M13 17V5"/><path d="M8 17v-3"/></svg></i>
            </div>

            <div>
                <h1>Bulk Event Report</h1>
                <p>Family-wise payments and dues for this bulk event.</p>
            </div>

        </div>

        <a class="hero-btn" href="<%= ctx %>/bulk-event-reports">
            <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m12 19-7-7 7-7"/><path d="M19 12H5"/></svg></i>
            Back to Bulk Event Reports
        </a>

    </div>

    <!-- ================= SUMMARY CARDS ================= -->
    <div class="report-summary">

                <div class="summary-card stat-blue reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 21a8 8 0 0 0-16 0"/><circle cx="10" cy="8" r="5"/><path d="M22 20c0-3.37-2-6.5-4-8a5 5 0 0 0-.45-8.3"/></svg></i></div>
            <div class="summary-text">
                <div class="summary-value" data-count="<%= totalFamilies %>"><%= totalFamilies %></div>
                <div class="summary-label">Total Families</div>
            </div>
        </div>

        <div class="summary-card stat-green reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i></div>
            <div class="summary-text">
                <div class="summary-value" data-count="<%= paidFamilies %>"><%= paidFamilies %></div>
                <div class="summary-label">Paid Families</div>
            </div>
        </div>

        <div class="summary-card stat-orange reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></i></div>
            <div class="summary-text">
                <div class="summary-value" data-count="<%= pendingFamilies %>"><%= pendingFamilies %></div>
                <div class="summary-label">Pending Families</div>
            </div>
        </div>

        <div class="summary-card stat-purple reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 3h12"/><path d="M6 8h12"/><path d="m6 13 8.5 8"/><path d="M6 13h3"/><path d="M9 13c6.667 0 6.667-10 0-10"/></svg></i></div>
            <div class="summary-text">
                <div class="summary-value" data-money="<%= money(totalAmount) %>">₹ <%= money(totalAmount) %></div>
                <div class="summary-label">Total Amount</div>
            </div>
        </div>

        <div class="summary-card stat-teal reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg></i></div>
            <div class="summary-text">
                <div class="summary-value" data-money="<%= money(collectedAmount) %>">₹ <%= money(collectedAmount) %></div>
                <div class="summary-label">Collected Amount</div>
            </div>
        </div>

        <div class="summary-card stat-red reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 22h14"/><path d="M5 2h14"/><path d="M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22"/><path d="M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2"/></svg></i></div>
            <div class="summary-text">
                <div class="summary-value" data-money="<%= money(pendingAmount) %>">₹ <%= money(pendingAmount) %></div>
                <div class="summary-label">Pending Amount</div>
            </div>
        </div>

    </div>

    <!-- ================= SEARCH + ACTIONS ================= -->
    <div class="report-toolbar reveal">

        <!-- SEARCH -->
        <div class="report-search">
            <label class="search-field">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>
                <input type="text" id="searchInput" autocomplete="off" placeholder="Search Family Name or Phone...">
            </label>
        </div>

        <!-- ACTION BUTTONS -->
        <div class="report-actions">

            <button type="button" onclick="window.print()" class="action-btn print-btn">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 9V2h12v7"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><path d="M6 14h12v8H6z"/></svg></i>
                Print
            </button>

            <a href="<%= ctx %>/export-bulk-report-pdf?bulkEventId=<%= bulkEventId %>" class="action-btn pdf-btn">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/></svg></i>
                PDF
            </a>

            <a href="<%= ctx %>/export-bulk-report-excel?bulkEventId=<%= bulkEventId %>" class="action-btn excel-btn">
                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M8 13h2"/><path d="M14 13h2"/><path d="M8 17h2"/><path d="M14 17h2"/></svg></i>
                Excel
            </a>

        </div>

    </div>

    <!-- ================= EVENT REPORT TABLE ================= -->
    <div class="section-card table-container reveal">

        <div class="section-top">
            <h2><i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg></i> Families</h2>
            <span class="count-badge" id="countBadge"><%= families.size() %> families</span>
        </div>

        <div class="table-wrap">

        <table class="report-table" id="familyTable">

            <thead>
                <tr>
                    <th data-type="text">Family Name</th>
                    <th data-type="text">Phone</th>
                    <th data-type="num" class="right">Total Amount</th>
                    <th data-type="num" class="right">Amount Paid</th>
                    <th data-type="num" class="right">Pending Amount</th>
                    <th data-type="text">Status</th>
                    <th class="nosort">Action</th>
                </tr>
            </thead>

            <tbody>
            <%
                int rowIndex = 0;
                for (BulkEventCustomer family : families) {
                    String status = family.getPaymentStatus();
                    if (status == null) status = "PENDING";
                    status = status.trim().toUpperCase(Locale.ROOT);
                    double familyTotal = family.getTotalAmount();
                    double familyPaid = family.getAmountPaid();
                    double familyPending = Math.max(0.0, familyTotal - familyPaid);
                    boolean isPaid = "PAID".equals(status) || familyPending <= 0.0001;
                    String statusClass = isPaid ? "paid" : ("PARTIAL".equals(status) || familyPaid > 0 ? "partial" : "pending");
                    String displayStatus = isPaid ? "PAID" : ("partial".equals(statusClass) ? "PARTIAL" : "PENDING");
                    // Use the same ID parameter as the Pending Payments page.
                    String paymentUrl = ctx + "/bulk-receive-payment?id=" + family.getId();
            %>
                <tr class="rep-row" style="--i:<%= rowIndex++ %>">
                    <td data-label="Family Name"><%= esc(family.getCustomerName()) %></td>
                    <td data-label="Phone"><%= esc(family.getPhone()) %></td>
                    <td class="money" data-label="Total Amount" data-raw="<%= money(familyTotal) %>">₹ <%= money(familyTotal) %></td>
                    <td class="money paidamt" data-label="Amount Paid" data-raw="<%= money(familyPaid) %>">₹ <%= money(familyPaid) %></td>
                    <td class="money <%= familyPending > 0 ? "due" : "" %>" data-label="Pending Amount" data-raw="<%= money(familyPending) %>">₹ <%= money(familyPending) %></td>
                    <td data-label="Status">

<% if (isPaid) { %>

    <span class="status paid">PAID</span>

<% } else { %>

    <a class="status-link"
       title="Receive payment"
       href="<%= paymentUrl %>">

        <span class="status <%= statusClass %>">
            <%= displayStatus %>
        </span>

    </a>

<% } %>

</td>
                    <td class="act" data-label="Action">
                        <% if (!isPaid) { %>
                            <a class="btn-pay" href="<%= paymentUrl %>">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24" aria-hidden="true"><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg></i>
                                Receive Payment
                            </a>
                        <% } else { %>
                            <span class="dash-none">-</span>
                        <% } %>
                    </td>
                </tr>
            <% } %>
            </tbody>

        </table>

        <div class="no-match" id="noMatch">No families match your search.</div>

        </div>

    </div>

  </div>

</div>

<!-- page behaviour: reveal, count-up, search, sort -->
<script>
/* search: same function name as before, now also updates the count and shows a "no match" message */
function searchFamilies() {
    var input = document.getElementById("searchInput");
    var filter = input.value.toLowerCase();
    var rows = document.querySelectorAll("#familyTable tbody tr.rep-row");
    var shown = 0;
    rows.forEach(function (r) {
        var ok = !filter || r.innerText.toLowerCase().indexOf(filter) > -1;
        r.hidden = !ok;
        if (ok) shown++;
    });
    var nm = document.getElementById("noMatch");
    if (nm) nm.classList.toggle("show", rows.length > 0 && shown === 0);
    var b = document.getElementById("countBadge");
    if (b && rows.length) b.textContent = (filter ? shown + " of " + rows.length : rows.length) + " families";
}

(function () {
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var page = document.querySelector('.dpa-dash');
	if (!page) return;

	var NUM = /^-?\d+(\.\d+)?$/;
	var nf0 = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 });
	var nf2 = new Intl.NumberFormat('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

	/* ---------- amounts: Indian digit grouping, 2 decimals (raw value stays in data-raw) ---------- */
	page.querySelectorAll('td.money[data-raw]').forEach(function (td) {
		var raw = td.getAttribute('data-raw');
		if (NUM.test(raw)) td.textContent = '\u20B9 ' + nf2.format(parseFloat(raw));
	});

	/* ---------- summary numbers: format + count up ---------- */
	function show(el, money, v) { el.textContent = money ? '\u20B9 ' + nf2.format(v) : nf0.format(v); }
	page.querySelectorAll('[data-money],[data-count]').forEach(function (el) {
		var m = el.hasAttribute('data-money'), raw = el.getAttribute(m ? 'data-money' : 'data-count');
		if (NUM.test(raw)) show(el, m, parseFloat(raw));
	});
	function countUp(el) {
		if (el.dataset.counted) return; el.dataset.counted = '1';
		var m = el.hasAttribute('data-money'), raw = el.getAttribute(m ? 'data-money' : 'data-count');
		if (!NUM.test(raw) || reduce) return;
		var target = parseFloat(raw); if (target === 0) return;
		var start = null, dur = 1100;
		function tick(ts) {
			if (start === null) start = ts;
			var p = Math.min((ts - start) / dur, 1), e = 1 - Math.pow(1 - p, 3);
			show(el, m, target * e);
			if (p < 1) requestAnimationFrame(tick); else show(el, m, target);
		}
		requestAnimationFrame(tick);
	}

	/* ---------- stagger + scroll reveal ---------- */
	page.querySelectorAll('.report-summary').forEach(function (g) {
		Array.prototype.forEach.call(g.children, function (el, i) { el.style.setProperty('--d', (i * 90) + 'ms'); });
	});
	function reveal(el) {
		el.classList.add('in');
		el.querySelectorAll('[data-money],[data-count]').forEach(countUp);
	}
	var targets = page.querySelectorAll('.reveal');
	if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
		}, { threshold: 0.1, rootMargin: '0px 0px -30px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}

	/* ---------- search box ---------- */
	var box = document.getElementById('searchInput');
	if (box) box.addEventListener('input', searchFamilies);

	/* ---------- sort by clicking a heading ---------- */
	var table = document.getElementById('familyTable');
	var tbody = table.tBodies[0];
	var heads = Array.prototype.slice.call(table.tHead.rows[0].cells);
	heads.forEach(function (th, idx) {
		if (th.classList.contains('nosort')) return;
		th.setAttribute('tabindex', '0');
		function sort() {
			var rows = Array.prototype.slice.call(tbody.querySelectorAll('tr.rep-row'));
			var dir = th.getAttribute('aria-sort') === 'ascending' ? 'descending' : 'ascending';
			heads.forEach(function (h) { h.removeAttribute('aria-sort'); });
			th.setAttribute('aria-sort', dir);
			function val(tr) {
				var td = tr.cells[idx];
				if (th.dataset.type === 'num') { var n = parseFloat(td.getAttribute('data-raw') || td.textContent.replace(/[^0-9.\-]/g, '')); return isNaN(n) ? 0 : n; }
				return td.textContent.trim().toLowerCase();
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

<script>
  function openNotifications(){
    var overlay = document.getElementById('notificationOverlay');
    if (overlay) overlay.classList.add('show');
  }
  function closeNotifications(){
    var overlay = document.getElementById('notificationOverlay');
    if (overlay) overlay.classList.remove('show');
  }

  /* highlight "Reports" in the sidebar (Bulk Event Report belongs to the reports section) */
  (function () {
    var links = document.querySelectorAll('.sidebar-nav a[href]');
    var found = null;
    links.forEach(function (a) {
      var u; try { u = new URL(a.href, window.location.origin); } catch (e) { return; }
      var p = u.pathname.replace(/\/$/, '');
      if (p.endsWith('/bulk-event-report') || p.endsWith('/bulk-event-reports') || (!found && p.endsWith('/reports'))) found = a;
    });
    if (found) {
      links.forEach(function (x) { x.classList.remove('active'); });
      found.classList.add('active');
    }
  })();
</script>
</body>
</html>