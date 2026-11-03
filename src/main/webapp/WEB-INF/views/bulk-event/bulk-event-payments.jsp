<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.digitalpurohit.model.BulkEventCustomer"%>
<%!
/* HTML-escape, "-" when empty */
private static String d(Object o) {
    if (o == null) return "-";
    String s = String.valueOf(o).replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
    return s.trim().isEmpty() ? "-" : s;
}
%>
<%
List<BulkEventCustomer> families = (List<BulkEventCustomer>) request.getAttribute("families");
Integer bulkEventId = (Integer) request.getAttribute("bulkEventId");

int totalFamilies = families == null ? 0 : families.size();
int paidFamilies = 0, openFamilies = 0;
long collected = 0;
if (families != null) {
    for (BulkEventCustomer f : families) {
        collected += Math.round(f.getAmountPaid());
        String s = f.getPaymentStatus();
        if ("PENDING".equals(s) || "PARTIAL".equals(s)) openFamilies++; else paidFamilies++;
    }
}
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bulk Event Payments | Digital Purohit Assistant</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Anton&family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap" rel="stylesheet">

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

<style id="bp-theme">
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

<style id="bp-css">/* =====================================================================
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
/* ---------- summary cards (clickable) ---------- */
.dpa-dash .event-summary{ display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:1.1em; margin:0; }
.dpa-dash .summary-card{
	--acc:#2b7fff; --acc-soft:rgba(43,127,255,.16);
	position:relative; overflow:hidden; display:flex; align-items:center; gap:1.1em;
	margin:0; padding:1.5em 1.6em; container-type:inline-size; cursor:pointer;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .stat-blue{ --acc:#2b7fff; --acc-soft:rgba(43,127,255,.16); }
.dpa-dash .stat-green{ --acc:#1fbf6a; --acc-soft:rgba(31,191,106,.16); }
.dpa-dash .stat-purple{ --acc:#9b7bff; --acc-soft:rgba(155,123,255,.17); }
.dpa-dash .stat-orange{ --acc:#f0a43a; --acc-soft:rgba(240,164,58,.17); }
.dpa-dash .summary-card::before{
	content:""; position:absolute; left:0; top:0; height:3px; width:100%; background:var(--acc);
	transform:scaleX(0); transform-origin:left; transition:transform .9s cubic-bezier(.2,.8,.2,1) .25s;
}
.dpa-dash .summary-card.in::before, html:not(.dpa-js) .dpa-dash .summary-card::before{ transform:scaleX(1); }
.dpa-dash .summary-card::after{
	content:"\2197"; position:absolute; top:.85em; right:1em; font-size:1em; color:var(--dpa-muted);
	opacity:0; transform:translate(-4px, 4px); transition:opacity .25s, transform .25s;
}
.dpa-dash .summary-icon{
	flex-shrink:0; width:3.2em; height:3.2em; border-radius:1em; font-size:1.15em;
	display:flex; align-items:center; justify-content:center;
	background:var(--acc-soft); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .summary-text{ min-width:0; }
.dpa-dash .summary-card h2{
	font-size:clamp(1.5em, 13cqw, 2.4em); font-weight:700; line-height:1.05; letter-spacing:-.02em;
	font-variant-numeric:tabular-nums; color:var(--dpa-text); overflow-wrap:anywhere;
}
.dpa-dash .summary-card p{ margin-top:.35em; font-size:.86em; font-weight:600; letter-spacing:.02em; color:var(--dpa-muted); }
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
@media (max-width:480px){ .dpa-dash .event-summary{ grid-template-columns:minmax(0, 1fr); gap:.8em; }
}
@media print{	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1 !important; animation:none !important; }
	.dpa-dash .hero-watermark{ display:none; }
}
@media (prefers-reduced-motion: reduce){	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
	.dpa-dash .summary-card::before{ transform:scaleX(1); }
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
.dpa-dash .empty-box{
	grid-column:1 / -1; display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:.5em;
	margin:0; padding:3em 1em; border-radius:1.15em; border:1.5px dashed var(--dpa-border); color:var(--dpa-muted);
}
.dpa-dash .empty-box i{ font-size:2.6em; opacity:.6; animation:vtBob 3.4s ease-in-out infinite; }
.dpa-dash .empty-box p{ font-size:1.05em; font-weight:600; color:var(--dpa-text); opacity:.9; }
@keyframes vtBob{ 0%,100%{ transform:translateY(0); } 50%{ transform:translateY(-6px); } }

/* ---------- bulk event payments ---------- */
@keyframes bpRow{ from{ opacity:0; translate:-12px 0; } to{ opacity:1; translate:0 0; } }
@keyframes bpPop{ from{ opacity:0; transform:translateY(20px) scale(.94); } to{ opacity:1; transform:none; } }
@keyframes bpFade{ from{ opacity:0; } to{ opacity:1; } }
@keyframes dpaBlink{ 0%,100%{ opacity:1; } 50%{ opacity:.35; } }
.dpa-dash .summary-card{ cursor:default; }
.dpa-dash .summary-card::after{ display:none; }
.dpa-dash .section-card{
	margin:0; padding:0; overflow:hidden; border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text); transition:background-color .35s, border-color .35s;
}
.dpa-dash .section-top{ display:flex; align-items:center; justify-content:space-between; gap:1em; flex-wrap:wrap; padding:1.15em 1.5em; border-bottom:1px solid var(--dpa-border); }
.dpa-dash .section-top h2{ display:flex; align-items:center; gap:.65em; font-size:1.15em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .section-top h2 i{ width:2.3em; height:2.3em; font-size:.85em; border-radius:.7em; display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile); }
.dpa-dash .table-wrap{ overflow-x:auto; }
.dpa-dash .pay-table{ width:100%; border-collapse:collapse; margin:0; background:transparent; font-size:.95em; }
.dpa-dash .pay-table thead th{
	padding:.9em 1.1em; text-align:left; white-space:nowrap; background:transparent; color:var(--dpa-muted);
	font-size:.74em; font-weight:700; letter-spacing:.09em; text-transform:uppercase;
	border:0; border-bottom:1px solid var(--dpa-border); cursor:pointer; user-select:none; transition:color .2s;
}
.dpa-dash .pay-table thead th.right{ text-align:right; }
.dpa-dash .pay-table thead th.nosort{ cursor:default; }
.dpa-dash .pay-table thead th:not(.nosort)::after{ content:"\2195"; margin-left:.45em; opacity:.35; font-size:1.1em; }
.dpa-dash .pay-table thead th[aria-sort="ascending"]::after{ content:"\2191"; opacity:1; color:var(--dpa-link); }
.dpa-dash .pay-table thead th[aria-sort="descending"]::after{ content:"\2193"; opacity:1; color:var(--dpa-link); }
.dpa-dash .pay-table tbody td{ padding:.95em 1.1em; border:0; border-bottom:1px solid var(--dpa-border); background:transparent; color:var(--dpa-text); vertical-align:middle; text-align:left; }
.dpa-dash .pay-table tbody tr:last-child td{ border-bottom:0; }
.dpa-dash .pay-table tbody td:first-child{ font-weight:600; }
.dpa-dash .pay-table td.money{ text-align:right; font-variant-numeric:tabular-nums; white-space:nowrap; font-weight:600; }
.dpa-dash .pay-table td.act{ text-align:right; white-space:nowrap; }
.dpa-dash .pay-row{ transition:background-color .2s; animation:bpRow .55s cubic-bezier(.2,.8,.2,1) both; animation-delay:calc(var(--i, 0) * 45ms + 250ms); }
.dpa-dash .pay-row[hidden]{ display:none !important; }
.dpa-dash .no-match{ display:none; padding:2em 1em; text-align:center; color:var(--dpa-muted); }
.dpa-dash .no-match.show{ display:block; }
.dpa-dash .status{
	display:inline-flex; align-items:center; gap:.5em; padding:.3em .9em; border-radius:999px;
	font-size:.76em; font-weight:700; letter-spacing:.06em; text-transform:uppercase; white-space:nowrap;
}
.dpa-dash .status::before{ content:""; width:.5em; height:.5em; border-radius:50%; background:currentColor; }
.dpa-dash .status.pending{ background:rgba(255,107,107,.15); color:var(--bad2); }
.dpa-dash .status.pending::before{ animation:dpaBlink 1.6s ease-in-out infinite; }
.dpa-dash .status.partial{ background:rgba(240,164,58,.16); color:var(--pend); }
.dpa-dash .status.paid{ background:rgba(52,211,153,.15); color:var(--good); }
.dpa-dash .receive{
	display:inline-flex; align-items:center; gap:.55em; margin:0; padding:.6em 1.05em; border-radius:.7em;
	border:1px solid var(--good); background:transparent; box-shadow:none; text-decoration:none; cursor:pointer;
	font-family:inherit; font-size:.88em; font-weight:700; line-height:1.2; color:var(--good); white-space:nowrap;
	transition:background-color .2s, color .2s, transform .12s, box-shadow .25s;
}
.dpa-dash .receive:active{ transform:scale(.95); }
.dpa-dash .receive:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }
.dpa-dash .empty-box{ margin:1.2em; }
.dpa-dash .empty-box[hidden]{ display:none; }

/* confirm popup (outside .dpa-dash) */
.bp-modal{ position:fixed; inset:0; z-index:2200; display:none; align-items:center; justify-content:center; padding:20px; background:rgba(0,0,0,.6); -webkit-backdrop-filter:blur(6px); backdrop-filter:blur(6px); font-family:'Inter', system-ui, sans-serif; }
.bp-modal.show{ display:flex; animation:bpFade .25s ease both; }
.bp-card{ width:100%; max-width:25em; padding:1.8em 1.6em 1.6em; text-align:center; border-radius:18px; border:1px solid var(--dpa-border); background:var(--dpa-surface); color:var(--dpa-text); box-shadow:0 30px 80px rgba(0,0,0,.5); animation:bpPop .4s cubic-bezier(.2,.8,.2,1) both; }
.bp-ico{ width:64px; height:64px; margin:0 auto 14px; border-radius:50%; display:grid; place-items:center; font-size:28px; background:rgba(52,211,153,.15); color:#34d399; }
.bp-card h3{ margin:0; font-size:19px; font-weight:700; line-height:1.3; }
.bp-card p{ margin:8px 0 20px; font-size:14px; font-weight:400; color:var(--dpa-muted); overflow-wrap:anywhere; }
.bp-row{ display:flex; gap:10px; }
.bp-row button{ flex:1; padding:12px 16px; border-radius:11px; border:1px solid var(--dpa-border); background:transparent; color:var(--dpa-text); font:700 14px 'Inter', sans-serif; cursor:pointer; transition:background-color .2s, transform .12s; }
.bp-row button:active{ transform:scale(.96); }
.bp-row .ok{ background:#1f9d55; border-color:#1f9d55; color:#fff; }
.bp-row button:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }
html.dpa-lock, html.dpa-lock body{ overflow:hidden; }

@media (hover:hover) and (pointer:fine){
	.dpa-dash .search-field:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .pay-row:hover{ background:var(--dpa-hover); }
	.dpa-dash .pay-table thead th:not(.nosort):hover{ color:var(--dpa-text); }
	.dpa-dash .receive:hover{ background:var(--good); color:#fff; box-shadow:0 8px 20px rgba(31,157,85,.35); }
	.bp-row button:not(.ok):hover{ background:var(--dpa-hover); }
	.bp-row .ok:hover{ background:#23b062; }
}
@media (max-width:1100px){ .dpa-dash .event-summary{ grid-template-columns:repeat(2, minmax(0, 1fr)); } }
@media (max-width:760px){
	/* table becomes cards */
	.dpa-dash .pay-table thead{ display:none; }
	.dpa-dash .pay-table, .dpa-dash .pay-table tbody{ display:block; }
	.dpa-dash .pay-row{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:.2em 1.2em; padding:1em 1.2em; border-bottom:1px solid var(--dpa-border); }
	.dpa-dash .pay-row:last-child{ border-bottom:0; }
	.dpa-dash .pay-table tbody td{ display:flex; flex-direction:column; align-items:flex-start; gap:.15em; padding:.45em 0; border:0; text-align:left !important; }
	.dpa-dash .pay-table tbody td::before{ content:attr(data-label); font-size:.72em; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--dpa-muted); }
	.dpa-dash .pay-table tbody td:first-child, .dpa-dash .pay-table tbody td.act{ grid-column:1 / -1; }
	.dpa-dash .pay-table tbody td.act::before{ display:none; }
	.dpa-dash .pay-table tbody td.act .receive{ width:100%; justify-content:center; padding:.8em 1em; }
}
@media (max-width:480px){ .dpa-dash .event-summary{ grid-template-columns:minmax(0, 1fr); gap:.8em; } }
@media print{ .dpa-dash .filter-card, .dpa-dash .receive, .dpa-dash th.nosort, .dpa-dash td.act{ display:none !important; } }
@media (prefers-reduced-motion: reduce){ .bp-modal, .bp-card, .dpa-dash .pay-row, .dpa-dash .status::before{ animation:none !important; } .dpa-dash .pay-row{ opacity:1; } }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

  <div class="bulk-payments-page dpa-dash">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
        <div class="hero-left">
            <div class="hero-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg></i></div>
            <div>
                <h1>Bulk Event Payments</h1>
                <p>Track what each family has paid and receive more.</p>
            </div>
        </div>
    </div>

    <!-- ================= SUMMARY ================= -->
    <div class="event-summary">
        <div class="summary-card stat-blue reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i></div>
            <div class="summary-text">
                <h2 data-count="<%= totalFamilies %>"><%= totalFamilies %></h2>
                <p>Total Families</p>
            </div>
        </div>
        <div class="summary-card stat-purple reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M6 3h12"/><path d="M6 8h12"/><path d="m6 13 8.5 8"/><path d="M6 13h3"/><path d="M9 13c6.667 0 6.667-10 0-10"/></svg></i></div>
            <div class="summary-text">
                <h2 data-money="<%= collected %>">&#8377; <%= String.format("%,d", collected) %></h2>
                <p>Amount Collected</p>
            </div>
        </div>
        <div class="summary-card stat-green reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i></div>
            <div class="summary-text">
                <h2 data-count="<%= paidFamilies %>"><%= paidFamilies %></h2>
                <p>Paid Families</p>
            </div>
        </div>
        <div class="summary-card stat-orange reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M5 22h14"/><path d="M5 2h14"/><path d="M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22"/><path d="M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2"/></svg></i></div>
            <div class="summary-text">
                <h2 data-count="<%= openFamilies %>"><%= openFamilies %></h2>
                <p>Pending Families</p>
            </div>
        </div>
    </div>

    <!-- ================= FILTER ================= -->
    <div class="filter-card reveal">
        <label class="search-field">
            <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>
            <input type="search" id="payFilter" autocomplete="off" placeholder="Filter by family or phone&hellip;">
        </label>
    </div>

    <!-- ================= TABLE ================= -->
    <section class="section-card reveal" aria-labelledby="bpTitle">
        <div class="section-top">
            <h2 id="bpTitle"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i> Families</h2>
            <span class="tag" id="countTag"><%= totalFamilies %> <%= totalFamilies == 1 ? "family" : "families" %></span>
        </div>

        <% if (families == null || families.isEmpty()) { %>
        <div class="empty-box">
            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i>
            <p>&#127881; No Families Added</p>
        </div>
        <% } else { %>
        <div class="table-wrap">
            <table class="pay-table">
                <thead>
                    <tr>
                        <th data-type="text">Family</th>
                        <th data-type="text">Phone</th>
                        <th data-type="num" class="right">Amount Paid</th>
                        <th data-type="text">Status</th>
                        <th class="nosort right">Action</th>
                    </tr>
                </thead>
                <tbody>
                <%-- ROWS-BEGIN --%>
                <%
                int idx = 0;
                for (BulkEventCustomer family : families) {
                    String bulkStatus = family.getPaymentStatus();
                    String cls = "PENDING".equals(bulkStatus) ? "pending" : ("PARTIAL".equals(bulkStatus) ? "partial" : "paid");
                    String label = "PENDING".equals(bulkStatus) ? "PENDING" : ("PARTIAL".equals(bulkStatus) ? "PARTIAL" : "PAID");
                    long paidAmt = Math.round(family.getAmountPaid());
                %>
                    <tr class="pay-row" style="--i:<%= Math.min(idx++, 14) %>">
                        <td data-label="Family"><%= d(family.getCustomerName()) %></td>
                        <td data-label="Phone"><%= d(family.getPhone()) %></td>
                        <td class="money" data-label="Amount Paid" data-raw="<%= paidAmt %>">&#8377; <%= String.format("%,d", paidAmt) %></td>
                        <td data-label="Status"><span class="status <%= cls %>"><%= label %></span></td>
                        <td class="act" data-label="Action">
                            <a class="receive" data-name="<%= d(family.getCustomerName()) %>"
                               href="${pageContext.request.contextPath}/bulk-receive-payment?bulkEventId=<%= bulkEventId == null ? "" : bulkEventId %>&amp;customerId=<%= family.getCustomerId() %>"
                               onclick="return confirm('Are you sure you want to update this payment?');">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg></i> Receive Payment
                            </a>
                        </td>
                    </tr>
                <% } %>
                <%-- ROWS-END --%>
                </tbody>
            </table>
            <div class="no-match" id="noMatch">No families match your filter.</div>
        </div>
        <% } %>
    </section>

  </div>

</div>

<!-- ================= CONFIRM RECEIVE ================= -->
<div class="bp-modal" id="bpModal" role="dialog" aria-modal="true" aria-labelledby="bpModalTitle">
    <div class="bp-card">
        <div class="bp-ico" aria-hidden="true"><i><svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg></i></div>
        <h3 id="bpModalTitle">Are you sure you want to update this payment?</h3>
        <p id="bpModalText"></p>
        <div class="bp-row">
            <button type="button" id="bpCancel">Cancel</button>
            <button type="button" class="ok" id="bpConfirm">Continue</button>
        </div>
    </div>
</div>

<script id="bp-js">
(function () {
	var $ = function (id) { return document.getElementById(id); };
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var page = document.querySelector('.dpa-dash');
	if (!page) return;
	var ni = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 });   /* whole rupees, no paise */
	var INT = /^\d+$/;

	/* ---------- amounts: grouping + count-up ---------- */
	function read(el) {
		var money = el.hasAttribute('data-money');
		var raw = (el.getAttribute(money ? 'data-money' : 'data-count') || '').trim();
		return { money: money, ok: INT.test(raw), val: parseInt(raw, 10) };
	}
	function show(el, d, v) { el.textContent = (d.money ? '\u20B9 ' : '') + ni.format(v); }
	function countUp(el) {
		if (el.dataset.counted) return; el.dataset.counted = '1';
		var d = read(el);
		if (!d.ok) return;
		show(el, d, d.val);
		if (reduce || d.val === 0) return;
		var start = null, dur = 1000;
		function tick(ts) {
			if (start === null) start = ts;
			var p = Math.min((ts - start) / dur, 1), e = 1 - Math.pow(1 - p, 3);
			show(el, d, Math.round(d.val * e));
			if (p < 1) requestAnimationFrame(tick); else show(el, d, d.val);
		}
		requestAnimationFrame(tick);
	}
	page.querySelectorAll('td.money[data-raw]').forEach(function (td) {
		if (INT.test(td.getAttribute('data-raw'))) td.textContent = '\u20B9 ' + ni.format(parseInt(td.getAttribute('data-raw'), 10));
	});

	/* ---------- staggered scroll reveal ---------- */
	page.querySelectorAll('.event-summary').forEach(function (g) {
		Array.prototype.forEach.call(g.children, function (el, i) { el.style.setProperty('--d', (i * 90) + 'ms'); });
	});
	function reveal(el) {
		el.classList.add('in');
		el.querySelectorAll('[data-count],[data-money]').forEach(countUp);
	}
	var targets = page.querySelectorAll('.reveal');
	if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
		}, { threshold: 0.08, rootMargin: '0px 0px -30px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}

	/* ---------- sort + filter ---------- */
	var table = page.querySelector('.pay-table');
	if (table) {
		var tbody = table.tBodies[0];
		var rows = Array.prototype.slice.call(tbody.querySelectorAll('.pay-row'));
		var heads = Array.prototype.slice.call(table.tHead.rows[0].cells);
		heads.forEach(function (th, idx) {
			if (th.classList.contains('nosort')) return;
			th.setAttribute('tabindex', '0');
			function sort() {
				var dir = th.getAttribute('aria-sort') === 'ascending' ? 'descending' : 'ascending';
				heads.forEach(function (h) { h.removeAttribute('aria-sort'); });
				th.setAttribute('aria-sort', dir);
				var type = th.dataset.type;
				function val(tr) {
					var td = tr.cells[idx];
					if (type === 'num') { var n = parseFloat(td.getAttribute('data-raw') || td.textContent.replace(/[^0-9.\-]/g, '')); return isNaN(n) ? 0 : n; }
					return td.textContent.trim().toLowerCase();
				}
				rows.sort(function (a, b) { var x = val(a), y = val(b); return (x < y ? -1 : x > y ? 1 : 0) * (dir === 'ascending' ? 1 : -1); });
				rows.forEach(function (r) { tbody.appendChild(r); });
			}
			th.addEventListener('click', sort);
			th.addEventListener('keydown', function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); sort(); } });
		});
		var filter = $('payFilter'), tag = $('countTag'), noMatch = $('noMatch');
		filter.addEventListener('input', function () {
			var q = filter.value.trim().toLowerCase(), shown = 0;
			rows.forEach(function (r) {
				var ok = !q || r.textContent.toLowerCase().indexOf(q) > -1;
				r.hidden = !ok; if (ok) shown++;
			});
			noMatch.classList.toggle('show', shown === 0);
			tag.textContent = (q ? shown + ' of ' + rows.length : rows.length) + (rows.length === 1 ? ' family' : ' families');
		});
	}

	/* ---------- confirm before receiving a payment ---------- */
	var modal = $('bpModal'), pending = null;
	function closeModal() { modal.classList.remove('show'); document.documentElement.classList.remove('dpa-lock'); pending = null; }
	page.querySelectorAll('a.receive').forEach(function (a) {
		a.removeAttribute('onclick');   /* the styled popup replaces the browser's confirm box */
		a.addEventListener('click', function (e) {
			e.preventDefault();
			pending = a;
			$('bpModalText').textContent = a.getAttribute('data-name') || '';
			modal.classList.add('show'); document.documentElement.classList.add('dpa-lock');
			$('bpCancel').focus();
		});
	});
	$('bpCancel').addEventListener('click', closeModal);
	modal.addEventListener('click', function (e) { if (e.target === modal) closeModal(); });
	document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeModal(); });
	$('bpConfirm').addEventListener('click', function () {
		if (!pending) return;
		if (window.bpOnConfirm) { window.bpOnConfirm(pending); closeModal(); return; }
		$('bpConfirm').disabled = true; $('bpConfirm').textContent = 'Opening\u2026';
		window.location.href = pending.href;
	});
	window.addEventListener('pageshow', function (e) { if (e.persisted) location.reload(); });
})();
</script>

</body>
</html>
