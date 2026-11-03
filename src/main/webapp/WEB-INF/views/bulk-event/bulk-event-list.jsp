<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="com.digitalpurohit.model.BulkEvent"%>
<%!
/* HTML-escape (null -> "") */
private static String h(Object o) {
    if (o == null) return "";
    return String.valueOf(o).replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
}
/* "-" when empty */
private static String d(Object o) {
    String s = h(o);
    return s.trim().isEmpty() ? "-" : s;
}
/* upcoming / active / completed, from the start and end dates */
private static String statusOf(BulkEvent b, LocalDate today) {
    if (b.getStartDate() == null || b.getEndDate() == null) return "active";
    LocalDate start = b.getStartDate().toLocalDate();
    LocalDate end = b.getEndDate().toLocalDate();
    if (today.isBefore(start)) return "upcoming";
    if (today.isAfter(end)) return "completed";
    return "active";
}
%>
<%
List<BulkEvent> bulkEvents = (List<BulkEvent>) request.getAttribute("bulkEvents");
LocalDate today = LocalDate.now();

int total = bulkEvents == null ? 0 : bulkEvents.size();
int upcomingCount = 0, activeCount = 0, completedCount = 0, pendingFamilies = 0;
long income = 0;
if (bulkEvents != null) {
    for (BulkEvent b : bulkEvents) {
        String st = statusOf(b, today);
        if ("upcoming".equals(st)) upcomingCount++;
        else if ("completed".equals(st)) completedCount++;
        else activeCount++;
        income += Math.round(b.getTotalAmountCollected());
        pendingFamilies += b.getPendingFamilies();
    }
}
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bulk Events | Digital Purohit Assistant</title>

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

<style id="bl-theme">
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

<style id="bl-css">/* =====================================================================
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

/* ---------- bulk events list ---------- */
@keyframes blPop{ from{ opacity:0; transform:translateY(20px) scale(.94); } to{ opacity:1; transform:none; } }
@keyframes blFade{ from{ opacity:0; } to{ opacity:1; } }
@keyframes dpaBlink{ 0%,100%{ opacity:1; } 50%{ opacity:.35; } }
.dpa-dash .summary-card{ cursor:default; }
.dpa-dash .summary-card::after{ display:none; }
.dpa-dash .hero-btn.add{ background:#1f9d55; border-color:#1f9d55; }
.dpa-dash .search-form{ display:flex; gap:.7em; align-items:stretch; flex-wrap:wrap; }
.dpa-dash .chips{ display:flex; gap:.5em; flex-wrap:wrap; margin-top:.9em; }
.dpa-dash .chip{
	display:inline-flex; align-items:center; gap:.5em; padding:.5em 1em; border-radius:999px; cursor:pointer;
	border:1px solid var(--dpa-border); background:transparent; color:var(--dpa-muted); font:600 .88em 'Inter', sans-serif;
	transition:background-color .2s, color .2s, border-color .2s, transform .12s;
}
.dpa-dash .chip b{ font-weight:700; padding:.05em .55em; border-radius:999px; background:var(--dpa-tile); font-size:.9em; }
.dpa-dash .chip.on{ background:var(--dpa-text); border-color:var(--dpa-text); color:var(--dpa-bg); }
.dpa-dash .chip.on b{ background:rgba(0,0,0,.12); }
.dpa-dash .chip:active{ transform:scale(.95); }
.dpa-dash .chip:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }

.dpa-dash .event-grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(22em, 1fr)); gap:1.1em; margin:0; }
.dpa-dash .event-card{
	--acc:#1fbf6a;
	position:relative; overflow:hidden; display:flex; flex-direction:column; gap:1em;
	margin:0; padding:1.5em 1.6em 1.3em; border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .event-card.upcoming{ --acc:#4f9dff; }
.dpa-dash .event-card.completed{ --acc:#9b7bff; }
.dpa-dash .event-card::before{
	content:""; position:absolute; left:0; top:0; height:3px; width:100%; background:var(--acc);
	transform:scaleX(0); transform-origin:left; transition:transform .9s cubic-bezier(.2,.8,.2,1) .25s;
}
.dpa-dash .event-card.in::before, html:not(.dpa-js) .dpa-dash .event-card::before{ transform:scaleX(1); }
.dpa-dash .event-card[hidden]{ display:none !important; }
.dpa-dash .ec-top{ display:flex; align-items:flex-start; gap:1em; min-width:0; }
.dpa-dash .ec-icon{
	flex-shrink:0; width:3em; height:3em; border-radius:.95em; font-size:1.1em; display:flex; align-items:center; justify-content:center;
	background:color-mix(in srgb, var(--acc) 16%, transparent); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .ec-name{ flex:1; min-width:0; font-size:1.15em; font-weight:700; letter-spacing:-.01em; line-height:1.25; overflow-wrap:anywhere; }
.dpa-dash .pill{
	flex-shrink:0; display:inline-flex; align-items:center; gap:.5em; padding:.3em .85em; border-radius:999px;
	font-size:.74em; font-weight:700; letter-spacing:.06em; text-transform:uppercase; white-space:nowrap;
	background:color-mix(in srgb, var(--acc) 15%, transparent); color:var(--acc);
}
.dpa-dash .pill::before{ content:""; width:.5em; height:.5em; border-radius:50%; background:currentColor; }
.dpa-dash .event-card:not(.upcoming):not(.completed) .pill::before{ animation:dpaBlink 1.8s ease-in-out infinite; }
.dpa-dash .ec-rows{ display:flex; flex-direction:column; gap:.55em; }
.dpa-dash .ec-row{ display:flex; align-items:center; justify-content:space-between; gap:1em; padding:.6em .85em; border-radius:.7em; background:var(--dpa-surface-2); border:1px solid var(--dpa-border); }
.dpa-dash .ec-row span{ display:flex; align-items:center; gap:.6em; font-size:.88em; font-weight:500; color:var(--dpa-muted); white-space:nowrap; }
.dpa-dash .ec-row strong{ font-weight:600; text-align:right; overflow-wrap:anywhere; min-width:0; }
.dpa-dash .ec-notes{ padding:.8em .95em; border-radius:.8em; border:1px dashed var(--dpa-border); }
.dpa-dash .ec-notes strong{ display:block; margin-bottom:.3em; font-size:.78em; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--dpa-muted); }
.dpa-dash .ec-notes p{ font-size:.92em; font-weight:400; line-height:1.55; overflow-wrap:anywhere;
	display:-webkit-box; -webkit-line-clamp:3; -webkit-box-orient:vertical; overflow:hidden; }
.dpa-dash .ec-foot{ margin-top:auto; padding-top:1em; border-top:1px solid var(--dpa-border); display:flex; gap:.6em; }
.dpa-dash .abtn{
	flex:1; display:inline-flex; align-items:center; justify-content:center; gap:.5em; padding:.65em .6em; border-radius:.75em;
	border:1px solid var(--c); color:var(--c); background:transparent; text-decoration:none; cursor:pointer;
	font-family:inherit; font-size:.88em; font-weight:700; line-height:1.2; white-space:nowrap;
	transition:background-color .2s, color .2s, transform .12s, box-shadow .25s;
}
.dpa-dash .abtn.details{ --c:#34d399; } .dpa-dash .abtn.edit{ --c:#f0a43a; } .dpa-dash .abtn.delete{ --c:#ff6b6b; }
.dpa-dash .abtn:active{ transform:scale(.95); }
.dpa-dash .abtn:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }
:root[data-theme="light"] .dpa-dash .abtn.details{ --c:#168a4a; } :root[data-theme="light"] .dpa-dash .abtn.edit{ --c:#b45f06; } :root[data-theme="light"] .dpa-dash .abtn.delete{ --c:#c93434; }
.dpa-dash .empty-box .btn{ margin-top:.6em; }
.dpa-dash .empty-box[hidden]{ display:none; }
.dpa-dash .empty-box span{ font-size:.92em; font-weight:400; }

/* delete confirm (outside .dpa-dash) */
.bl-modal{ position:fixed; inset:0; z-index:2200; display:none; align-items:center; justify-content:center; padding:20px; background:rgba(0,0,0,.6); -webkit-backdrop-filter:blur(6px); backdrop-filter:blur(6px); font-family:'Inter', system-ui, sans-serif; }
.bl-modal.show{ display:flex; animation:blFade .25s ease both; }
.bl-card{ width:100%; max-width:25em; padding:1.8em 1.6em 1.6em; text-align:center; border-radius:18px; border:1px solid var(--dpa-border); background:var(--dpa-surface); color:var(--dpa-text); box-shadow:0 30px 80px rgba(0,0,0,.5); animation:blPop .4s cubic-bezier(.2,.8,.2,1) both; }
.bl-ico{ width:64px; height:64px; margin:0 auto 14px; border-radius:50%; display:grid; place-items:center; font-size:28px; background:rgba(255,107,107,.15); color:#ff6b6b; }
.bl-card h3{ margin:0; font-size:19px; font-weight:700; }
.bl-card p{ margin:8px 0 20px; font-size:14px; font-weight:400; color:var(--dpa-muted); overflow-wrap:anywhere; }
.bl-row{ display:flex; gap:10px; }
.bl-row button{ flex:1; padding:12px 16px; border-radius:11px; border:1px solid var(--dpa-border); background:transparent; color:var(--dpa-text); font:700 14px 'Inter', sans-serif; cursor:pointer; transition:background-color .2s, transform .12s; }
.bl-row button:active{ transform:scale(.96); }
.bl-row .danger{ background:#e04b4b; border-color:#e04b4b; color:#fff; }
.bl-row button:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }
html.dpa-lock, html.dpa-lock body{ overflow:hidden; }

@media (hover:hover) and (pointer:fine){
	.dpa-dash .hero-btn:hover{ transform:translateX(-4px); background:rgba(255,255,255,.14); }
	.dpa-dash .hero-btn.add:hover{ background:#23b062; }
	.dpa-dash .chip:not(.on):hover{ background:var(--dpa-hover); color:var(--dpa-text); }
	.dpa-dash .event-card:hover{ transform:translateY(-5px); border-color:var(--acc); }
	.dpa-dash .event-card:hover .ec-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .abtn:hover{ background:var(--c); color:#fff; box-shadow:0 8px 18px color-mix(in srgb, var(--c) 35%, transparent); }
	.bl-row button:not(.danger):hover{ background:var(--dpa-hover); }
	.bl-row .danger:hover{ background:#ee5a5a; }
}
@media (max-width:1100px){ .dpa-dash .event-summary{ grid-template-columns:repeat(2, minmax(0, 1fr)); } }
@media (max-width:700px){
	.dpa-dash .search-form{ flex-wrap:wrap; }
	.dpa-dash .event-grid{ grid-template-columns:minmax(0, 1fr); }
	.dpa-dash .ec-foot{ flex-wrap:wrap; }
	.dpa-dash .abtn{ flex:1 1 30%; }
}
@media (max-width:480px){ .dpa-dash .event-summary{ grid-template-columns:minmax(0, 1fr); gap:.8em; } }
@media (prefers-reduced-motion: reduce){ .bl-modal, .bl-card, .dpa-dash .pill::before{ animation:none !important; } }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

  <div class="bulk-events-page dpa-dash">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
        <div class="hero-left">
            <div class="hero-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i></div>
            <div>
                <h1>Bulk Events</h1>
                <p>Manage all your Bulk Events.</p>
            </div>
        </div>
        <a class="hero-btn add" href="${pageContext.request.contextPath}/add-bulk-event">
            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M12 5v14"/></svg></i> Add Bulk Event
        </a>
    </div>

    <!-- ================= SUMMARY ================= -->
    <div class="event-summary">
        <div class="summary-card stat-blue reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i></div>
            <div class="summary-text">
                <h2 data-count="<%= total %>"><%= total %></h2>
                <p>Total Events</p>
            </div>
        </div>
        <div class="summary-card stat-green reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg></i></div>
            <div class="summary-text">
                <h2 data-count="<%= activeCount %>"><%= activeCount %></h2>
                <p>Today's</p>
            </div>
        </div>
        <div class="summary-card stat-purple reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M6 3h12"/><path d="M6 8h12"/><path d="m6 13 8.5 8"/><path d="M6 13h3"/><path d="M9 13c6.667 0 6.667-10 0-10"/></svg></i></div>
            <div class="summary-text">
                <h2 data-money="<%= income %>">&#8377; <%= String.format("%,d", income) %></h2>
                <p>Income</p>
            </div>
        </div>
        <div class="summary-card stat-orange reveal">
            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M5 22h14"/><path d="M5 2h14"/><path d="M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22"/><path d="M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2"/></svg></i></div>
            <div class="summary-text">
                <h2 data-count="<%= pendingFamilies %>"><%= pendingFamilies %></h2>
                <p>Pending</p>
            </div>
        </div>
    </div>

    <!-- ================= SEARCH ================= -->
    <div class="filter-card reveal">
        <div class="search-form">
            <label class="search-field">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>
                <input type="text" id="searchBox" autocomplete="off" placeholder="Search Bulk Event...">
            </label>
        </div>
        <div class="chips" role="group" aria-label="Filter by status">
            <button type="button" class="chip on" data-filter="all">All <b><%= total %></b></button>
            <button type="button" class="chip" data-filter="active">Active <b><%= activeCount %></b></button>
            <button type="button" class="chip" data-filter="upcoming">Upcoming <b><%= upcomingCount %></b></button>
            <button type="button" class="chip" data-filter="completed">Completed <b><%= completedCount %></b></button>
        </div>
    </div>

    <!-- ================= LIST ================= -->
    <div class="list-head reveal">
        <h2><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i> All Bulk Events</h2>
        <span class="tag" id="countTag"><%= total %> <%= total == 1 ? "event" : "events" %></span>
    </div>

    <div class="event-grid" id="eventGrid">
    <%-- LIST-BEGIN --%>
    <%
    if (bulkEvents != null && !bulkEvents.isEmpty()) {
        for (BulkEvent bulkEvent : bulkEvents) {
            String st = statusOf(bulkEvent, today);
            String stLabel = "upcoming".equals(st) ? "Upcoming" : ("completed".equals(st) ? "Completed" : "Active");
            boolean hasNotes = bulkEvent.getNotes() != null && !bulkEvent.getNotes().trim().isEmpty();
    %>
        <article class="event-card <%= st %> reveal" data-status="<%= st %>">
            <div class="ec-top">
                <div class="ec-icon" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i></div>
                <h3 class="ec-name"><%= h(bulkEvent.getBulkEventName()) %></h3>
                <span class="pill"><%= stLabel %></span>
            </div>

            <div class="ec-rows">
                <div class="ec-row"><span><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i> Start Date</span><strong><%= d(bulkEvent.getStartDate()) %></strong></div>
                <div class="ec-row"><span><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i> End Date</span><strong><%= d(bulkEvent.getEndDate()) %></strong></div>
                <div class="ec-row"><span><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg></i> Location</span><strong><%= d(bulkEvent.getLocation()) %></strong></div>
            </div>

            <% if (hasNotes) { %>
            <div class="ec-notes">
                <strong>Notes</strong>
                <p><%= h(bulkEvent.getNotes()) %></p>
            </div>
            <% } %>

            <div class="ec-foot">
               <a class="abtn details"
   href="${pageContext.request.contextPath}/bulk-event-details?id=<%= bulkEvent.getYatraId() %>">

    <i aria-hidden="true">
        <svg viewBox="0 0 24 24">
            <path d="M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0"/>
            <circle cx="12" cy="12" r="3"/>
        </svg>
    </i>

    Details
</a>
                <a class="abtn edit" href="${pageContext.request.contextPath}/edit-bulk-event?id=<%= bulkEvent.getYatraId() %>">
                    <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 20h9"/><path d="M16.376 3.622a1 1 0 0 1 3.002 3.002L7.368 18.635a2 2 0 0 1-.855.506l-2.872.838a.5.5 0 0 1-.62-.62l.838-2.872a2 2 0 0 1 .506-.854z"/></svg></i> Edit
                </a>
                <a class="abtn delete" data-name="<%= h(bulkEvent.getBulkEventName()) %>"
                   href="${pageContext.request.contextPath}/delete-bulk-event?bulkEventId=<%= bulkEvent.getYatraId() %>"
                   onclick="return confirm('Are you sure you want to delete this Bulk Event?')">
                    <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></i> Delete
                </a>
            </div>
        </article>
    <%
        }
    } else {
    %>
        <div class="empty-box reveal">
            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i>
            <p>No Bulk Events Found</p>
            <span>Click "Add Bulk Event" to create your first event.</span>
            <a class="btn primary" href="${pageContext.request.contextPath}/add-bulk-event"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M12 5v14"/></svg></i> Add Bulk Event</a>
        </div>
    <% } %>
    <%-- LIST-END --%>
        <div class="empty-box" id="noMatch" hidden>
            <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>
            <p>No bulk events match your search.</p>
        </div>
    </div>

  </div>

</div>

<!-- ================= CONFIRM DELETE ================= -->
<div class="bl-modal" id="blModal" role="dialog" aria-modal="true" aria-labelledby="blModalTitle">
    <div class="bl-card">
        <div class="bl-ico" aria-hidden="true"><i><svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></i></div>
        <h3 id="blModalTitle">Delete this Bulk Event?</h3>
        <p id="blModalText"></p>
        <div class="bl-row">
            <button type="button" id="blCancel">Cancel</button>
            <button type="button" class="danger" id="blConfirm">Delete</button>
        </div>
    </div>
</div>

<script id="bl-js">
(function () {
	var $ = function (id) { return document.getElementById(id); };
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var page = document.querySelector('.dpa-dash');
	if (!page) return;
	var ni = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 });   /* whole rupees, no paise */
	var INT = /^\d+$/;

	/* ---------- numbers: grouping + count-up ---------- */
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

	/* ---------- staggered scroll reveal ---------- */
	['.event-summary', '.event-grid'].forEach(function (sel) {
		page.querySelectorAll(sel).forEach(function (g) {
			Array.prototype.forEach.call(g.children, function (el, i) { el.style.setProperty('--d', (Math.min(i, 12) * 80) + 'ms'); });
		});
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

	/* ---------- search + status filter ---------- */
	var cards = Array.prototype.slice.call(page.querySelectorAll('.event-card'));
	var search = $('searchBox'), tag = $('countTag'), noMatch = $('noMatch'), status = 'all';
	function apply() {
		var q = search.value.trim().toLowerCase(), shown = 0;
		cards.forEach(function (c) {
			var ok = (status === 'all' || c.getAttribute('data-status') === status) && (!q || c.textContent.toLowerCase().indexOf(q) > -1);
			c.hidden = !ok; if (ok) { shown++; c.classList.add('in'); }
		});
		tag.textContent = shown + (shown === 1 ? ' event' : ' events');
		noMatch.hidden = !(cards.length > 0 && shown === 0);
		if (!noMatch.hidden) noMatch.classList.add('in');
	}
	search.addEventListener('input', apply);
	page.querySelectorAll('.chip').forEach(function (chip) {
		chip.addEventListener('click', function () {
			page.querySelectorAll('.chip.on').forEach(function (x) { x.classList.remove('on'); });
			chip.classList.add('on'); status = chip.getAttribute('data-filter'); apply();
		});
	});

	/* ---------- confirm before deleting ---------- */
	var modal = $('blModal'), pending = null;
	function closeModal() { modal.classList.remove('show'); document.documentElement.classList.remove('dpa-lock'); pending = null; }
	page.querySelectorAll('a.abtn.delete').forEach(function (a) {
		a.removeAttribute('onclick');   /* the styled popup replaces the browser's confirm box */
		a.addEventListener('click', function (e) {
			e.preventDefault();
			pending = a;
			$('blModalText').textContent = (a.getAttribute('data-name') || '') + ' will be removed. Are you sure you want to delete this Bulk Event?';
			modal.classList.add('show'); document.documentElement.classList.add('dpa-lock');
			$('blCancel').focus();
		});
	});
	$('blCancel').addEventListener('click', closeModal);
	modal.addEventListener('click', function (e) { if (e.target === modal) closeModal(); });
	document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeModal(); });
	$('blConfirm').addEventListener('click', function () {
		if (!pending) return;
		if (window.blOnDelete) { window.blOnDelete(pending); closeModal(); return; }
		$('blConfirm').disabled = true; $('blConfirm').textContent = 'Deleting\u2026';
		window.location.href = pending.href;
	});
	window.addEventListener('pageshow', function (e) { if (e.persisted) location.reload(); });
})();
</script>

</body>
</html>
