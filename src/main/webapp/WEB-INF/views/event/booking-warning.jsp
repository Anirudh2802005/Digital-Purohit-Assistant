<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.digitalpurohit.model.Event"%>
<%!
/* HTML-escape (null -> "") - used for the hidden form values */
private static String h(Object o) {
    if (o == null) return "";
    return String.valueOf(o).replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
}
/* HTML-escape, "-" when empty - used for what is shown on screen */
private static String d(Object o) {
    String s = h(o);
    return s.trim().isEmpty() ? "-" : s;
}
%>
<%
Event newEvent = (Event) request.getAttribute("newEvent");
Event conflictEvent = (Event) request.getAttribute("conflictEvent");
Event duplicateEvent = (Event) request.getAttribute("duplicateEvent");
Event previousEvent = (Event) request.getAttribute("previousEvent");

if (newEvent == null) {
    /* nothing to confirm - go back to the form */
    response.sendRedirect(request.getContextPath() + "/add-event");
    return;
}

int issues = (conflictEvent != null ? 1 : 0) + (duplicateEvent != null ? 1 : 0) + (previousEvent != null ? 1 : 0);
String timeShort = newEvent.getEventTime() == null ? "" : newEvent.getEventTime().toString();
if (timeShort.length() >= 5) timeShort = timeShort.substring(0, 5);
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Booking Warning | Digital Purohit Assistant</title>

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

<style id="bw-theme">
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

<style id="bw-css">
/* =====================================================================
   BOOKING WARNING — same design system as the other pages
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
	--good:#34d399; --pend:#f0a43a; --bad2:#ff6b6b; --info:#4f9dff;
	max-width:96em; margin:0 auto;
	display:flex; flex-direction:column; gap:1.5em;
	font-family:'Inter', ui-sans-serif, system-ui, sans-serif;
	font-size:calc(14px * var(--dk)); font-weight:500; line-height:1.45;
	color:var(--dpa-text);
	-webkit-font-smoothing:antialiased;
}
:root[data-theme="light"] .dpa-dash{ --good:#168a4a; --pend:#b45f06; --bad2:#c93434; --info:#1f6fd1; }
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
@keyframes dpaSpin{ to{ transform:rotate(360deg); } }
@keyframes bwRing{ 0%{ box-shadow:0 0 0 0 color-mix(in srgb, var(--acc) 55%, transparent); } 70%,100%{ box-shadow:0 0 0 12px transparent; } }
@keyframes bwWiggle{ 0%,100%{ rotate:0deg; } 20%{ rotate:-12deg; } 40%{ rotate:10deg; } 60%{ rotate:-6deg; } 80%{ rotate:3deg; } }
@keyframes bwSlide{ 0%{ transform:translateX(-6px); opacity:.4; } 50%{ transform:translateX(6px); opacity:1; } 100%{ transform:translateX(-6px); opacity:.4; } }
@keyframes bwDraw{ from{ transform:scaleY(0); } to{ transform:scaleY(1); } }
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
	background:radial-gradient(circle, rgba(240,164,58,.5), rgba(240,164,58,0) 70%);
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
	--acc:#f0a43a;
	flex-shrink:0; width:2.4em; height:2.4em; font-size:1.5em; border-radius:.7em;
	display:flex; align-items:center; justify-content:center;
	border:1px solid rgba(240,164,58,.8); color:#f0a43a; background:rgba(240,164,58,.1);
	animation:bwRing 2.4s ease-out infinite;
}
.dpa-dash .hero-icon svg{ animation:bwWiggle 2.8s ease-in-out 1s infinite; transform-origin:50% 60%; }
.dpa-dash .page-header h1{
	font-family:'Anton', ui-sans-serif, sans-serif; font-weight:400; text-transform:uppercase;
	font-size:clamp(1.8em, 3.4vw, 3.2em); line-height:1; letter-spacing:.01em; color:#fff; overflow-wrap:anywhere;
}
.dpa-dash .page-header p{ margin-top:.55em; color:rgba(255,255,255,.72); font-weight:400; font-size:1.05em; }
.dpa-dash .hero-chip{
	display:flex; align-items:center; gap:.9em; padding:.85em 1.1em; border-radius:1em;
	border:1px solid rgba(255,255,255,.14); background:rgba(255,255,255,.05); color:#fff;
}
.dpa-dash .hero-chip b{ font-size:1.9em; font-weight:700; line-height:1; color:#f0a43a; }
.dpa-dash .hero-chip small{ display:block; font-size:.88em; color:rgba(255,255,255,.75); font-weight:600; }

/* ---------- check cards ---------- */
.dpa-dash .check-row{ display:grid; grid-template-columns:repeat(3, minmax(0, 1fr)); gap:1.1em; margin:0; }
.dpa-dash .check-card{
	--acc:#2b7fff; --acc-soft:rgba(43,127,255,.16);
	position:relative; overflow:hidden; display:flex; align-items:center; gap:1.1em;
	margin:0; padding:1.4em 1.5em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .t-red{ --acc:#ff6b6b; --acc-soft:rgba(255,107,107,.16); }
.dpa-dash .t-orange{ --acc:#f0a43a; --acc-soft:rgba(240,164,58,.17); }
.dpa-dash .t-blue{ --acc:#4f9dff; --acc-soft:rgba(79,157,255,.16); }
.dpa-dash .check-card::before{
	content:""; position:absolute; left:0; top:0; height:3px; width:100%; background:var(--acc);
	transform:scaleX(0); transform-origin:left; transition:transform .9s cubic-bezier(.2,.8,.2,1) .25s;
}
.dpa-dash .check-card.in::before, html:not(.dpa-js) .dpa-dash .check-card::before{ transform:scaleX(1); }
.dpa-dash .check-ico{
	flex-shrink:0; width:3.2em; height:3.2em; border-radius:1em; font-size:1.15em;
	display:flex; align-items:center; justify-content:center; background:var(--acc-soft); color:var(--acc);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .check-card.clear{ --acc:#34d399; --acc-soft:rgba(52,211,153,.14); }
.dpa-dash .check-card.on .check-ico{ animation:bwRing 2.4s ease-out infinite; }
.dpa-dash .check-text{ min-width:0; }
.dpa-dash .check-label{ font-size:.72em; font-weight:700; letter-spacing:.12em; text-transform:uppercase; color:var(--dpa-muted); }
.dpa-dash .check-state{ margin-top:.35em; font-size:1.25em; font-weight:700; letter-spacing:-.01em; color:var(--acc); }
.dpa-dash .check-sub{ margin-top:.2em; font-size:.85em; color:var(--dpa-muted); }

/* ---------- layout ---------- */
.dpa-dash .bw-grid{ display:grid; grid-template-columns:minmax(0, 1.6fr) minmax(0, 1fr); gap:1.1em; align-items:start; }
.dpa-dash .bw-col{ display:flex; flex-direction:column; gap:1.1em; min-width:0; }
.dpa-dash .bw-side{ position:sticky; top:1.2em; }

/* ---------- warning + section cards ---------- */
.dpa-dash .warn-card, .dpa-dash .section-card{
	--acc:#2b7fff;
	position:relative; margin:0; padding:0; overflow:hidden; min-width:0;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .warn-card{ border-color:color-mix(in srgb, var(--acc) 38%, var(--dpa-border)); }
.dpa-dash .warn-card::before{
	content:""; position:absolute; left:0; top:0; bottom:0; width:4px; background:var(--acc);
	transform-origin:top; transform:scaleY(0); transition:transform .8s cubic-bezier(.2,.8,.2,1) .3s;
}
.dpa-dash .warn-card.in::before, html:not(.dpa-js) .dpa-dash .warn-card::before{ transform:scaleY(1); }
.dpa-dash .warn-top, .dpa-dash .section-top{
	display:flex; align-items:center; justify-content:space-between; gap:1em; flex-wrap:wrap;
	padding:1.15em 1.5em; border-bottom:1px solid var(--dpa-border);
}
.dpa-dash .warn-top{ background:color-mix(in srgb, var(--acc) 7%, var(--dpa-surface)); }
.dpa-dash .st-left{ display:flex; align-items:center; gap:.9em; min-width:0; }
.dpa-dash .st-left > i{
	flex-shrink:0; width:2.6em; height:2.6em; border-radius:.8em;
	display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile);
}
.dpa-dash .warn-card .st-left > i{ background:color-mix(in srgb, var(--acc) 18%, transparent); color:var(--acc); }
.dpa-dash .warn-card.shake .st-left > i svg{ animation:bwWiggle 1.2s ease .8s 1; }
.dpa-dash .warn-top h2, .dpa-dash .section-top h2{ font-size:1.12em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .warn-top p, .dpa-dash .section-top p{ margin-top:.2em; font-size:.85em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .tag{
	padding:.3em .85em; border-radius:999px; font-size:.76em; font-weight:700; letter-spacing:.05em; text-transform:uppercase; white-space:nowrap;
	border:1px solid color-mix(in srgb, var(--acc) 45%, transparent); color:var(--acc); background:color-mix(in srgb, var(--acc) 12%, transparent);
}
.dpa-dash .section-card .tag{ border-color:var(--dpa-border); color:var(--dpa-muted); background:transparent; }

/* detail fields */
.dpa-dash .info-grid{ display:grid; grid-template-columns:repeat(auto-fit, minmax(13em, 1fr)); gap:.8em; padding:1.3em 1.5em 1.5em; }
.dpa-dash .info-item{ padding:.85em 1.05em; border-radius:.85em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2); min-width:0; transition:border-color .2s, transform .2s; }
.dpa-dash .info-item label{ display:block; margin-bottom:.35em; font-size:.78em; font-weight:600; color:var(--dpa-muted); }
.dpa-dash .info-item div{ font-weight:600; overflow-wrap:anywhere; }
.dpa-dash .info-item.wide{ grid-column:1 / -1; }

/* travel route */
.dpa-dash .route{ display:grid; grid-template-columns:minmax(0, 1fr) auto minmax(0, 1fr); gap:1em; align-items:stretch; padding:1.3em 1.5em 0; }
.dpa-dash .route-box{ display:flex; flex-direction:column; gap:.7em; padding:1em; border-radius:1em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2); min-width:0; }
.dpa-dash .route-box h4{ margin:0 0 .1em; font-size:.74em; font-weight:700; letter-spacing:.1em; text-transform:uppercase; color:var(--acc); }
.dpa-dash .route-box .info-item{ background:var(--dpa-surface); }
.dpa-dash .route-arrow{ align-self:center; width:2.6em; height:2.6em; border-radius:50%; display:flex; align-items:center; justify-content:center; background:color-mix(in srgb, var(--acc) 16%, transparent); color:var(--acc); }
.dpa-dash .route-arrow svg{ animation:bwSlide 1.8s ease-in-out infinite; }
.dpa-dash .callout{
	display:flex; align-items:flex-start; gap:.8em; margin:1.2em 1.5em 1.5em; padding:.95em 1.1em; border-radius:.9em;
	background:color-mix(in srgb, var(--acc) 11%, transparent); border:1px solid color-mix(in srgb, var(--acc) 35%, transparent);
	font-weight:700; color:var(--info);
}
.dpa-dash .callout i{ flex-shrink:0; margin-top:.15em; font-size:1.15em; }

/* ---------- actions ---------- */
.dpa-dash .actions{ display:flex; flex-direction:column; gap:.75em; padding:0 1.5em 1.5em; }
.dpa-dash .actions form{ margin:0; display:block; }
.dpa-dash .btn{
	display:flex; align-items:center; justify-content:center; gap:.6em; width:100%; margin:0; padding:.95em 1.4em;
	border-radius:.85em; border:1px solid var(--dpa-border); background:transparent; box-shadow:none; cursor:pointer;
	font-family:inherit; font-size:.97em; font-weight:700; line-height:1.2; color:var(--dpa-text); white-space:nowrap;
	transition:background-color .2s, color .2s, transform .12s, box-shadow .25s, border-color .2s;
}
.dpa-dash .btn.cancel{ border-color:var(--bad2); color:var(--bad2); }
.dpa-dash .btn.save{ background:#f0a43a; border-color:#f0a43a; color:#2a1a00; }
.dpa-dash .btn:active{ transform:scale(.97); }
.dpa-dash .btn.loading{ pointer-events:none; opacity:.85; }
.dpa-dash .btn.loading i{ animation:dpaSpin .8s linear infinite; }
.dpa-dash .btn:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }
.dpa-dash .note{ padding:0 1.5em 1.5em; font-size:.85em; font-weight:400; color:var(--dpa-muted); }

/* ---------- hover (mouse only) ---------- */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .check-card:hover{ transform:translateY(-4px); border-color:var(--acc); }
	.dpa-dash .check-card:hover .check-ico{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .info-item:hover{ border-color:var(--dpa-twilight); transform:translateY(-2px); }
	.dpa-dash .btn.cancel:hover{ background:var(--bad2); color:#fff; box-shadow:0 8px 20px rgba(255,107,107,.3); }
	.dpa-dash .btn.save:hover{ background:#f5b658; border-color:#f5b658; box-shadow:0 8px 20px rgba(240,164,58,.35); }
}

/* ---------- responsive ---------- */
@media (max-width:1100px){ .dpa-dash .bw-grid{ grid-template-columns:minmax(0, 1fr); } .dpa-dash .bw-side{ position:static; } }
@media (max-width:900px){ .main-content{ margin-left:0; width:100%; padding:clamp(14px, 2.4vw, 24px); } }
@media (max-width:800px){ .dpa-dash .check-row{ grid-template-columns:minmax(0, 1fr); gap:.8em; } .dpa-dash .route{ grid-template-columns:minmax(0, 1fr); } .dpa-dash .route-arrow{ transform:rotate(90deg); justify-self:center; } }
@media (max-width:700px){
	.main-content{ padding:14px; }
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .warn-top, .dpa-dash .section-top{ padding:1em 1.1em; }
	.dpa-dash .info-grid, .dpa-dash .route{ padding-left:1.1em; padding-right:1.1em; }
	.dpa-dash .callout{ margin-left:1.1em; margin-right:1.1em; }
	.dpa-dash .actions, .dpa-dash .note{ padding-left:1.1em; padding-right:1.1em; }
}
@media print{
	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1 !important; animation:none !important; }
	.dpa-dash .hero-watermark, .dpa-dash .actions{ display:none !important; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
	.dpa-dash .check-card::before{ transform:scaleX(1); }
	.dpa-dash .warn-card::before{ transform:scaleY(1); }
}
</style>
<style id="shared-sidebar-layout">
    /* Shared Digital Purohit Assistant sidebar */
    :root {
        --dpa-sidebar-w: 260px;
        --dpa-bad: #d64545;
        --dpa-twilight: #426188;
        --dpa-link: #2b7fff;
    }

    :root,
    :root[data-theme="dark"] {
        --dpa-bg: #050608;
        --dpa-surface: #10141c;
        --dpa-surface-2: #161b26;
        --dpa-text: #f5f5f5;
        --dpa-muted: rgba(255, 255, 255, .58);
        --dpa-border: rgba(255, 255, 255, .09);
        --dpa-sb-bg: #080a0f;
        --dpa-hover: rgba(255, 255, 255, .06);
        --dpa-tile: rgba(255, 255, 255, .07);
        --dpa-active-bg: #f5f5f5;
        --dpa-active-text: #1b1b1b;
        --dpa-active-tile: rgba(0, 0, 0, .08);
        --dpa-logo-bg: transparent;
        --dpa-logo-fg: #ffffff;
        --dpa-logo-border: rgba(255, 255, 255, .6);
        --dpa-glow-a: rgba(66, 97, 136, .55);
        --dpa-glow-b: rgba(43, 127, 255, .22);
        --dpa-switch: rgba(255, 255, 255, .2);
        --dpa-scroll: rgba(255, 255, 255, .18);
        color-scheme: dark;
    }

    :root[data-theme="light"] {
        --dpa-bg: #f1f4f9;
        --dpa-surface: #ffffff;
        --dpa-surface-2: #f5f5f5;
        --dpa-text: #1b1b1b;
        --dpa-muted: #6b7280;
        --dpa-border: rgba(0, 0, 0, .09);
        --dpa-sb-bg: #ffffff;
        --dpa-hover: rgba(0, 0, 0, .045);
        --dpa-tile: rgba(0, 0, 0, .05);
        --dpa-active-bg: #1b1b1b;
        --dpa-active-text: #ffffff;
        --dpa-active-tile: rgba(255, 255, 255, .16);
        --dpa-logo-bg: #1b1b1b;
        --dpa-logo-fg: #ffffff;
        --dpa-logo-border: #1b1b1b;
        --dpa-glow-a: rgba(66, 97, 136, .22);
        --dpa-glow-b: rgba(43, 127, 255, .12);
        --dpa-switch: #426188;
        --dpa-scroll: rgba(0, 0, 0, .18);
        color-scheme: light;
    }

    body {
        margin: 0;
        background: var(--dpa-bg);
        color: var(--dpa-text);
        font-family: 'Inter', system-ui, sans-serif;
    }

    /* Sidebar container */
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        bottom: 0;
        width: var(--dpa-sidebar-w);
        height: 100vh;
        height: 100dvh;
        margin: 0;
        padding: 18px 14px 0;
        display: flex;
        flex-direction: column;
        overflow: hidden;
        z-index: 1200;
        box-sizing: border-box;
        background: var(--dpa-sb-bg);
        color: var(--dpa-text);
        border: 0;
        border-right: 1px solid var(--dpa-border);
        font-size: 14px;
        line-height: 1.4;
        font-weight: 500;
    }

    .sidebar *,
    .sidebar *::before,
    .sidebar *::after {
        box-sizing: border-box;
    }

    .sidebar > * {
        position: relative;
        z-index: 1;
    }

    .sidebar .sidebar-header {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 6px 8px 18px;
        margin-bottom: 6px;
        border-bottom: 1px solid var(--dpa-border);
    }

    .sidebar .sidebar-logo {
        width: 44px;
        height: 44px;
        flex-shrink: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 12px;
        color: var(--dpa-logo-fg);
        border: 1px solid var(--dpa-logo-border);
    }

    .sidebar .sidebar-title-container {
        min-width: 0;
    }

    .sidebar .sidebar-title-main {
        color: var(--dpa-text);
        font-size: 16px;
        font-weight: 700;
        line-height: 1.15;
        white-space: nowrap;
    }

    .sidebar .sidebar-subtitle {
        margin-top: 2px;
        color: var(--dpa-twilight);
        font-size: 21px;
        font-style: italic;
    }

    .sidebar .sidebar-nav {
        flex: 1;
        min-height: 0;
        overflow-y: auto;
        overflow-x: hidden;
        padding: 0 2px 12px;
        margin: 0 -4px 0 -2px;
    }

    .sidebar .menu-title {
        display: flex;
        align-items: center;
        gap: 10px;
        margin: 0;
        padding: 20px 10px 8px;
        color: var(--dpa-muted);
        font-size: 11px;
        font-weight: 600;
        letter-spacing: .16em;
        text-transform: uppercase;
    }

    .sidebar .menu-title::after {
        content: "";
        flex: 1;
        height: 1px;
        background: var(--dpa-border);
    }

    .sidebar .sidebar-nav a {
        position: relative;
        display: flex;
        align-items: center;
        gap: 12px;
        width: auto;
        height: auto;
        margin: 2px 0;
        padding: 8px 10px;
        border: 0;
        border-radius: 11px;
        background: transparent;
        color: var(--dpa-muted);
        font-size: 14px;
        font-weight: 500;
        text-decoration: none;
        text-transform: none;
        letter-spacing: 0;
        box-shadow: none;
    }

    .sidebar .sidebar-nav a i {
        width: 34px;
        height: 34px;
        flex-shrink: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin: 0;
        border-radius: 9px;
        color: inherit;
        background: var(--dpa-tile);
    }

    .sidebar .sidebar-nav a span:not(.menu-badge) {
        flex: 1;
        min-width: 0;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
    }

    .sidebar .sidebar-nav a:hover {
        background: var(--dpa-hover);
        color: var(--dpa-text);
    }

    .sidebar .sidebar-nav a.active {
        background: var(--dpa-active-bg);
        color: var(--dpa-active-text);
        font-weight: 600;
    }

    .sidebar .sidebar-nav a.active i {
        background: var(--dpa-active-tile);
        color: var(--dpa-active-text);
    }

    .sidebar .menu-badge {
        margin-left: auto;
        min-width: 22px;
        height: 22px;
        padding: 0 7px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 999px;
        background: var(--dpa-bad);
        color: #fff;
        font-size: 11px;
        font-weight: 700;
    }

    .sidebar .sidebar-footer {
        padding: 12px 0 16px;
        border-top: 1px solid var(--dpa-border);
    }

    .dpa-theme-toggle {
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;
        padding: 10px 12px;
        border: 1px solid var(--dpa-border);
        border-radius: 11px;
        background: var(--dpa-tile);
        color: var(--dpa-text);
        font-family: inherit;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
    }

    /* Page starts immediately to the right of the sidebar */
    .main-content {
        margin: 0 0 0 var(--dpa-sidebar-w) !important;
        padding: 24px 20px !important;
        width: calc(100% - var(--dpa-sidebar-w)) !important;
        min-height: 100vh;
        box-sizing: border-box;
        position: relative;
        background: transparent;
    }

    /* Keep the existing booking warning layout */
    .booking-warning-page {
        width: 100%;
        max-width: 96em;
        margin: 0 auto;
    }

    @media (max-width: 900px) {
        :root {
            --dpa-sidebar-w: 0px;
        }

        .main-content {
            margin-left: 0 !important;
            width: 100% !important;
            padding: 18px !important;
        }
    }

    @media (max-height: 740px) {
        .sidebar {
            padding-top: 12px;
        }

        .sidebar .sidebar-header {
            padding: 2px 6px 12px;
        }

        .sidebar .sidebar-nav a {
            padding: 6px 10px;
        }

        .sidebar .menu-title {
            padding: 14px 10px 6px;
        }
    }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

  <div class="booking-warning-page dpa-dash">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
        <div class="hero-left">
            <div class="hero-icon">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></i>
            </div>
            <div>
                <h1>Smart Booking Warning</h1>
                <p>Please review these before saving the event.</p>
            </div>
        </div>
        <div class="hero-chip">
            <b><%= issues %></b>
            <small><%= issues == 1 ? "warning found" : "warnings found" %></small>
        </div>
    </div>

    <!-- ================= WHAT WAS CHECKED ================= -->
    <div class="check-row">

        <div class="check-card t-red reveal<%= conflictEvent != null ? " on" : " clear" %>">
            <div class="check-ico"><i aria-hidden="true"><% if (conflictEvent != null) { %><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="m4.9 4.9 14.2 14.2"/></svg><% } else { %><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg><% } %></i></div>
            <div class="check-text">
                <div class="check-label">Double Booking</div>
                <div class="check-state"><%= conflictEvent != null ? "Detected" : "Clear" %></div>
                <div class="check-sub"><%= conflictEvent != null ? "Another event is at this time" : "No clash at this time" %></div>
            </div>
        </div>

        <div class="check-card t-orange reveal<%= duplicateEvent != null ? " on" : " clear" %>">
            <div class="check-ico"><i aria-hidden="true"><% if (duplicateEvent != null) { %><svg viewBox="0 0 24 24"><rect width="14" height="14" x="8" y="8" rx="2"/><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"/></svg><% } else { %><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg><% } %></i></div>
            <div class="check-text">
                <div class="check-label">Duplicate Customer</div>
                <div class="check-state"><%= duplicateEvent != null ? "Detected" : "Clear" %></div>
                <div class="check-sub"><%= duplicateEvent != null ? "Same customer already booked" : "No repeat booking" %></div>
            </div>
        </div>

        <div class="check-card t-blue reveal<%= previousEvent != null ? " on" : " clear" %>">
            <div class="check-ico"><i aria-hidden="true"><% if (previousEvent != null) { %><svg viewBox="0 0 24 24"><path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/></svg><% } else { %><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg><% } %></i></div>
            <div class="check-text">
                <div class="check-label">Travel Time</div>
                <div class="check-state"><%= previousEvent != null ? "Check needed" : "Clear" %></div>
                <div class="check-sub"><%= previousEvent != null ? "Event just before this one" : "No tight schedule" %></div>
            </div>
        </div>

    </div>

    <div class="bw-grid">

        <!-- ================= WARNINGS ================= -->
        <div class="bw-col">

            <% if (conflictEvent != null) { %>
            <section class="warn-card t-red shake reveal" aria-labelledby="bwConflict">
                <div class="warn-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="m4.9 4.9 14.2 14.2"/></svg></i>
                        <div><h2 id="bwConflict">Double Booking Detected</h2><p>Another event is already booked at this time</p></div>
                    </div>
                    <span class="tag">Conflict</span>
                </div>
                <div class="info-grid">
                    <div class="info-item wide"><label>Existing Event</label><div><%= d(conflictEvent.getEventTitle()) %></div></div>
                    <div class="info-item"><label>Customer</label><div><%= d(conflictEvent.getCustomerName()) %></div></div>
                    <div class="info-item"><label>Phone</label><div><%= d(conflictEvent.getPhone()) %></div></div>
                    <div class="info-item"><label>Date</label><div><%= d(conflictEvent.getEventDate()) %></div></div>
                    <div class="info-item"><label>Time</label><div><%= d(conflictEvent.getEventTime()) %></div></div>
                    <div class="info-item wide"><label>Location</label><div><%= d(conflictEvent.getLocation()) %></div></div>
                </div>
            </section>
            <% } %>

            <% if (duplicateEvent != null) { %>
            <section class="warn-card t-orange shake reveal" aria-labelledby="bwDuplicate">
                <div class="warn-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="14" height="14" x="8" y="8" rx="2"/><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"/></svg></i>
                        <div><h2 id="bwDuplicate">Duplicate Customer Booking</h2><p>This customer already has an event</p></div>
                    </div>
                    <span class="tag">Duplicate</span>
                </div>
                <div class="info-grid">
                    <div class="info-item"><label>Customer</label><div><%= d(duplicateEvent.getCustomerName()) %></div></div>
                    <div class="info-item"><label>Phone</label><div><%= d(duplicateEvent.getPhone()) %></div></div>
                    <div class="info-item wide"><label>Existing Event</label><div><%= d(duplicateEvent.getEventTitle()) %></div></div>
                    <div class="info-item"><label>Date</label><div><%= d(duplicateEvent.getEventDate()) %></div></div>
                    <div class="info-item"><label>Time</label><div><%= d(duplicateEvent.getEventTime()) %></div></div>
                    <div class="info-item wide"><label>Location</label><div><%= d(duplicateEvent.getLocation()) %></div></div>
                </div>
            </section>
            <% } %>

            <% if (previousEvent != null) { %>
            <section class="warn-card t-blue shake reveal" aria-labelledby="bwTravel">
                <div class="warn-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/></svg></i>
                        <div><h2 id="bwTravel">Travel Time Warning</h2><p>An event is booked right before this one</p></div>
                    </div>
                    <span class="tag">Travel</span>
                </div>

                <div class="route">
                    <div class="route-box">
                        <h4>Before</h4>
                        <div class="info-item"><label>Previous Event</label><div><%= d(previousEvent.getEventTitle()) %></div></div>
                        <div class="info-item"><label>Customer</label><div><%= d(previousEvent.getCustomerName()) %></div></div>
                        <div class="info-item"><label>Location</label><div><%= d(previousEvent.getLocation()) %></div></div>
                        <div class="info-item"><label>Time</label><div><%= d(previousEvent.getEventTime()) %></div></div>
                    </div>
                    <div class="route-arrow" aria-hidden="true"><svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></div>
                    <div class="route-box">
                        <h4>After</h4>
                        <div class="info-item"><label>New Event</label><div><%= d(newEvent.getEventTitle()) %></div></div>
                        <div class="info-item"><label>New Location</label><div><%= d(newEvent.getLocation()) %></div></div>
                        <div class="info-item"><label>New Time</label><div><%= d(newEvent.getEventTime()) %></div></div>
                    </div>
                </div>

                <div class="callout">
                    <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg></i>
                    <span>Please verify that there is enough travel time between these two locations before continuing.</span>
                </div>
            </section>
            <% } %>

        </div>

        <!-- ================= NEW EVENT + ACTIONS ================= -->
        <div class="bw-col bw-side">
            <section class="section-card t-blue reveal" aria-labelledby="bwNew">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg></i>
                        <div><h2 id="bwNew">Event You Are Saving</h2><p>What will be created</p></div>
                    </div>
                    <span class="tag">New</span>
                </div>
                <div class="info-grid">
                    <div class="info-item wide"><label>Title</label><div><%= d(newEvent.getEventTitle()) %></div></div>
                    <div class="info-item"><label>Date</label><div><%= d(newEvent.getEventDate()) %></div></div>
                    <div class="info-item"><label>Time</label><div><%= d(newEvent.getEventTime()) %></div></div>
                    <div class="info-item wide"><label>Location</label><div><%= d(newEvent.getLocation()) %></div></div>
                </div>

                <div class="actions">
                    <a class="btn cancel" href="${pageContext.request.contextPath}/add-event">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i> Cancel
                    </a>

                    <form id="forceForm" action="${pageContext.request.contextPath}/add-event" method="post">

                        <input type="hidden" name="forceSave" value="true">

                        <input type="hidden" name="customerId" value="<%= newEvent.getCustomerId() %>">
                        <input type="hidden" name="typeId" value="<%= newEvent.getTypeId() %>">
                        <input type="hidden" name="eventTitle" value="<%= h(newEvent.getEventTitle()) %>">
                        <input type="hidden" name="eventDate" value="<%= h(newEvent.getEventDate()) %>">
                        <input type="hidden" name="eventTime" value="<%= h(timeShort) %>">
                        <input type="hidden" name="location" value="<%= h(newEvent.getLocation()) %>">
                        <input type="hidden" name="totalAmount" value="<%= Math.round(newEvent.getTotalAmount()) %>">
                        <input type="hidden" name="amountPaid" value="<%= Math.round(newEvent.getAmountPaid()) %>">
                        <input type="hidden" name="notes" value="<%= h(newEvent.getNotes()) %>">

                        <button class="btn save" type="submit" id="saveBtn">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z"/><path d="M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7"/><path d="M7 3v4a1 1 0 0 0 1 1h7"/></svg></i> <span>Save Anyway</span>
                        </button>
                    </form>
                </div>
                <p class="note">Cancel goes back to the event form. Save Anyway creates the event even with the warnings above.</p>
            </section>
        </div>

    </div>

  </div>

</div>

<script id="bw-js">
(function () {
	var page = document.querySelector('.dpa-dash');
	if (!page) return;

	/* ---------- staggered scroll reveal ---------- */
	['.check-row', '.bw-col'].forEach(function (sel) {
		page.querySelectorAll(sel).forEach(function (g) {
			Array.prototype.forEach.call(g.children, function (el, i) { el.style.setProperty('--d', (i * 100) + 'ms'); });
		});
	});
	function reveal(el) { el.classList.add('in'); }
	var targets = page.querySelectorAll('.reveal');
	if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
		}, { threshold: 0.08, rootMargin: '0px 0px -30px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}

	/* ---------- Save Anyway: feedback + no double submit ---------- */
	var form = document.getElementById('forceForm'), btn = document.getElementById('saveBtn'), sending = false;
	if (form && btn) form.addEventListener('submit', function (e) {
		if (sending) { e.preventDefault(); return; }
		sending = true;
		btn.classList.add('loading');
		btn.innerHTML = '<i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg></i> <span>Saving\u2026</span>';
	});
	window.addEventListener('pageshow', function (e) { if (e.persisted) location.reload(); });
})();
</script>

</body>
</html>
