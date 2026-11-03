<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="en" data-theme="dark">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Event Types | Digital Purohit Assistant</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">




<link rel="preconnect" href="https://fonts.googleapis.com">

<link href="https://fonts.googleapis.com/css2?family=Anton&family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css">



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



<style id="ev-theme">

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



<style id="ev-css">

/* =====================================================================

   EVENT TYPES — same design system as the Events dashboard

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



/* ---------- action cards ---------- */

.dpa-dash .event-actions{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:1.1em; margin:0; }

.dpa-dash .action-card{

	position:relative; display:flex; align-items:center; gap:1.2em;

	margin:0; padding:1.5em 1.6em;

	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;

	background:var(--dpa-surface); color:var(--dpa-text);

	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;

}

.dpa-dash .action-icon{

	flex-shrink:0; width:3.4em; height:3.4em; border-radius:1em; font-size:1.2em;

	display:flex; align-items:center; justify-content:center;

	background:var(--dpa-tile); color:var(--dpa-text);

	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;

}

.dpa-dash .action-text{ flex:1; min-width:0; }

.dpa-dash .action-card h3{ font-size:1.12em; font-weight:700; letter-spacing:-.01em; }

.dpa-dash .action-card p{ margin-top:.3em; font-size:.9em; font-weight:400; color:var(--dpa-muted); }

.dpa-dash .action-go{

	flex-shrink:0; width:2.5em; height:2.5em; border-radius:50%;

	display:flex; align-items:center; justify-content:center;

	border:1px solid var(--dpa-border); color:var(--dpa-muted);

	transition:transform .3s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s, border-color .25s;

}



/* ---------- hover (mouse only) ---------- */

@media (hover:hover) and (pointer:fine){

	.dpa-dash .summary-card:hover{ transform:translateY(-4px); border-color:var(--acc); }

	.dpa-dash .summary-card:hover::after{ opacity:1; transform:none; }

	.dpa-dash .summary-card:hover .summary-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }

	.dpa-dash .action-card:hover{ transform:translateY(-4px); border-color:var(--dpa-twilight); background:var(--dpa-hover); }

	.dpa-dash .action-card:hover .action-icon{ transform:rotate(-8deg) scale(1.1); background:var(--dpa-twilight); color:#fff; }

	.dpa-dash .action-card:hover .action-go{ transform:translateX(4px); background:var(--dpa-twilight); border-color:var(--dpa-twilight); color:#fff; }

}

.dpa-dash .summary-card:active, .dpa-dash .action-card:active{ transform:scale(.985); }

.dpa-dash a:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }



/* ---------- responsive ---------- */

@media (max-width:1100px){ .dpa-dash .event-summary{ grid-template-columns:repeat(2, minmax(0, 1fr)); } }

@media (max-width:900px){

	.main-content{ margin-left:0; width:100%; padding:clamp(14px, 2.4vw, 24px); }

}

@media (max-width:700px){

	.main-content{ padding:14px; }

	.dpa-dash{ gap:1.15em; }

	.dpa-dash .page-header{ padding:1.4em 1.3em; }

	.dpa-dash .hero-left{ gap:.9em; }

	.dpa-dash .hero-watermark{ font-size:6.5em; }

	.dpa-dash .event-actions{ grid-template-columns:minmax(0, 1fr); gap:.8em; }

	.dpa-dash .summary-card, .dpa-dash .action-card{ padding:1.2em 1.3em; }

}

@media (max-width:480px){ .dpa-dash .event-summary{ grid-template-columns:minmax(0, 1fr); gap:.8em; } }

@media print{

	.main-content{ margin-left:0; padding:0; }

	body{ background:#fff !important; }

	.dpa-js .dpa-dash .reveal{ opacity:1 !important; animation:none !important; }

	.dpa-dash .hero-watermark{ display:none; }

}

@media (prefers-reduced-motion: reduce){

	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }

	.dpa-js .dpa-dash .reveal{ opacity:1; }

	.dpa-dash .summary-card::before{ transform:scaleX(1); }

}



/* ---------- event types: 3 summary cards, not clickable ---------- */

.dpa-dash .event-summary{ grid-template-columns:repeat(3, minmax(0, 1fr)); }

.dpa-dash .summary-card{ cursor:default; }

.dpa-dash .summary-card::after{ display:none; }

@media (max-width:1100px){ .dpa-dash .event-summary{ grid-template-columns:repeat(3, minmax(0, 1fr)); } }

@media (max-width:800px){ .dpa-dash .event-summary{ grid-template-columns:minmax(0, 1fr); gap:.8em; } }

</style>




<style>

/* =====================================================================
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

/* ---------- action cards ---------- */
.dpa-dash .event-actions{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:1.1em; margin:0; }
.dpa-dash .action-card{
	position:relative; display:flex; align-items:center; gap:1.2em;
	margin:0; padding:1.5em 1.6em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .action-icon{
	flex-shrink:0; width:3.4em; height:3.4em; border-radius:1em; font-size:1.2em;
	display:flex; align-items:center; justify-content:center;
	background:var(--dpa-tile); color:var(--dpa-text);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .action-text{ flex:1; min-width:0; }
.dpa-dash .action-card h3{ font-size:1.12em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .action-card p{ margin-top:.3em; font-size:.9em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .action-go{
	flex-shrink:0; width:2.5em; height:2.5em; border-radius:50%;
	display:flex; align-items:center; justify-content:center;
	border:1px solid var(--dpa-border); color:var(--dpa-muted);
	transition:transform .3s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s, border-color .25s;
}

/* ---------- hover (mouse only) ---------- */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .summary-card:hover{ transform:translateY(-4px); border-color:var(--acc); }
	.dpa-dash .summary-card:hover::after{ opacity:1; transform:none; }
	.dpa-dash .summary-card:hover .summary-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .action-card:hover{ transform:translateY(-4px); border-color:var(--dpa-twilight); background:var(--dpa-hover); }
	.dpa-dash .action-card:hover .action-icon{ transform:rotate(-8deg) scale(1.1); background:var(--dpa-twilight); color:#fff; }
	.dpa-dash .action-card:hover .action-go{ transform:translateX(4px); background:var(--dpa-twilight); border-color:var(--dpa-twilight); color:#fff; }
}
.dpa-dash .summary-card:active, .dpa-dash .action-card:active{ transform:scale(.985); }
.dpa-dash a:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* ---------- responsive ---------- */
@media (max-width:1100px){ .dpa-dash .event-summary{ grid-template-columns:repeat(2, minmax(0, 1fr)); } }
@media (max-width:900px){
	.main-content{ margin-left:0; width:100%; padding:clamp(14px, 2.4vw, 24px); }
}
@media (max-width:700px){
	.main-content{ padding:14px; }
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .event-actions{ grid-template-columns:minmax(0, 1fr); gap:.8em; }
	.dpa-dash .summary-card, .dpa-dash .action-card{ padding:1.2em 1.3em; }
}
@media (max-width:480px){ .dpa-dash .event-summary{ grid-template-columns:minmax(0, 1fr); gap:.8em; } }
@media print{
	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1 !important; animation:none !important; }
	.dpa-dash .hero-watermark{ display:none; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
	.dpa-dash .summary-card::before{ transform:scaleX(1); }
}

</style>
<style>


/* ===== Sidebar theme and styling copied from the supplied reference page ===== */

:root{ --dpa-sidebar-w:260px; --dpa-twilight:#426188; --dpa-link:#2b7fff; }
:root,:root[data-theme="dark"]{ --dpa-bg:#050608; --dpa-surface:#10141c; --dpa-surface-2:#161b26; --dpa-text:#f5f5f5; --dpa-muted:rgba(255,255,255,.58); --dpa-border:rgba(255,255,255,.09); --dpa-sb-bg:#080a0f; --dpa-hover:rgba(255,255,255,.06); --dpa-tile:rgba(255,255,255,.07); color-scheme:dark; }
:root[data-theme="light"]{ --dpa-bg:#f1f4f9; --dpa-surface:#fff; --dpa-surface-2:#f5f5f5; --dpa-text:#1b1b1b; --dpa-muted:#6b7280; --dpa-border:rgba(0,0,0,.09); --dpa-sb-bg:#fff; --dpa-hover:rgba(0,0,0,.045); --dpa-tile:rgba(0,0,0,.05); color-scheme:light; }
body{ background:var(--dpa-bg); color:var(--dpa-text); transition:background-color .35s,color .35s; }


/* =====================================================================
   EVENTS DASHBOARD — same design system as Customers / Pending Payments
   Colours come from the shared theme variables (--dpa-*), so the
   dark / light switch restyles this page too.
   ===================================================================== */
.main-content{
	position:relative;
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

/* ---------- action cards ---------- */
.dpa-dash .event-actions{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:1.1em; margin:0; }
.dpa-dash .action-card{
	position:relative; display:flex; align-items:center; gap:1.2em;
	margin:0; padding:1.5em 1.6em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:transform .28s cubic-bezier(.2,.8,.2,1), border-color .25s, background-color .35s;
}
.dpa-dash .action-icon{
	flex-shrink:0; width:3.4em; height:3.4em; border-radius:1em; font-size:1.2em;
	display:flex; align-items:center; justify-content:center;
	background:var(--dpa-tile); color:var(--dpa-text);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .action-text{ flex:1; min-width:0; }
.dpa-dash .action-card h3{ font-size:1.12em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .action-card p{ margin-top:.3em; font-size:.9em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .action-go{
	flex-shrink:0; width:2.5em; height:2.5em; border-radius:50%;
	display:flex; align-items:center; justify-content:center;
	border:1px solid var(--dpa-border); color:var(--dpa-muted);
	transition:transform .3s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s, border-color .25s;
}

/* ---------- hover (mouse only) ---------- */
@media (hover:hover) and (pointer:fine){
	.dpa-dash .summary-card:hover{ transform:translateY(-4px); border-color:var(--acc); }
	.dpa-dash .summary-card:hover::after{ opacity:1; transform:none; }
	.dpa-dash .summary-card:hover .summary-icon{ transform:rotate(-8deg) scale(1.1); background:var(--acc); color:#fff; }
	.dpa-dash .action-card:hover{ transform:translateY(-4px); border-color:var(--dpa-twilight); background:var(--dpa-hover); }
	.dpa-dash .action-card:hover .action-icon{ transform:rotate(-8deg) scale(1.1); background:var(--dpa-twilight); color:#fff; }
	.dpa-dash .action-card:hover .action-go{ transform:translateX(4px); background:var(--dpa-twilight); border-color:var(--dpa-twilight); color:#fff; }
}
.dpa-dash .summary-card:active, .dpa-dash .action-card:active{ transform:scale(.985); }
.dpa-dash a:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* ---------- responsive ---------- */
@media (max-width:1100px){ .dpa-dash .event-summary{ grid-template-columns:repeat(2, minmax(0, 1fr)); } }
@media (max-width:900px){
	.main-content{ margin-left:0; width:100%; padding:clamp(14px, 2.4vw, 24px); }
}
@media (max-width:700px){
	.main-content{ padding:14px; }
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .event-actions{ grid-template-columns:minmax(0, 1fr); gap:.8em; }
	.dpa-dash .summary-card, .dpa-dash .action-card{ padding:1.2em 1.3em; }
}
@media (max-width:480px){ .dpa-dash .event-summary{ grid-template-columns:minmax(0, 1fr); gap:.8em; } }
@media print{
	.main-content{ margin-left:0; padding:0; }
	body{ background:#fff !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1 !important; animation:none !important; }
	.dpa-dash .hero-watermark{ display:none; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
	.dpa-dash .summary-card::before{ transform:scaleX(1); }
}
/* Layout shell copied from the Customers reference page */
.main-content {
  margin-left: var(--dpa-sidebar-w, 260px);
  width: calc(100% - var(--dpa-sidebar-w, 260px));
  max-width: none;
  min-width: 0;
  padding: clamp(18px, 2.4vw, 34px);
  box-sizing: border-box;
}
@media (max-width: 900px) {
  .main-content {
    margin-left: var(--dpa-sidebar-w, 260px);
    width: calc(100% - var(--dpa-sidebar-w, 260px));
    padding: 20px 16px;
  }
}
@media (max-width: 700px) {
  .main-content { margin-left: 0; width: 100%; padding: 14px; }
}


/* Sidebar colors and active states copied from the Customers reference design.
   These overrides intentionally replace the older blue sidebar theme. */
:root, :root[data-theme="dark"] {
  --dpa-sidebar-w: 260px;
  --dpa-bg: #050608;
  --dpa-surface: #10141c;
  --dpa-surface-2: #161b26;
  --dpa-text: #f5f5f5;
  --dpa-muted: rgba(255,255,255,.58);
  --dpa-border: rgba(255,255,255,.09);
  --dpa-sb-bg: #080a0f;
  --dpa-hover: rgba(255,255,255,.06);
  --dpa-tile: rgba(255,255,255,.07);
  --dpa-active-bg: #f5f5f5;
  --dpa-active-text: #1b1b1b;
  --dpa-active-tile: rgba(0,0,0,.08);
  --dpa-logo-bg: transparent;
  --dpa-logo-fg: #fff;
  --dpa-logo-border: rgba(255,255,255,.6);
  --dpa-scroll: rgba(255,255,255,.18);
}
:root[data-theme="light"] {
  --dpa-sidebar-w: 260px;
  --dpa-bg: #f1f4f9;
  --dpa-surface: #fff;
  --dpa-surface-2: #f5f5f5;
  --dpa-text: #1b1b1b;
  --dpa-muted: #6b7280;
  --dpa-border: rgba(0,0,0,.09);
  --dpa-sb-bg: #fff;
  --dpa-hover: rgba(0,0,0,.045);
  --dpa-tile: rgba(0,0,0,.05);
  --dpa-active-bg: #1b1b1b;
  --dpa-active-text: #fff;
  --dpa-active-tile: rgba(255,255,255,.16);
  --dpa-logo-bg: #1b1b1b;
  --dpa-logo-fg: #fff;
  --dpa-logo-border: #1b1b1b;
  --dpa-scroll: rgba(0,0,0,.18);
}
.sidebar {
  background: var(--dpa-sb-bg) !important;
  color: var(--dpa-text) !important;
  border-right: 1px solid var(--dpa-border) !important;
  box-shadow: none !important;
  font-family: 'Inter', ui-sans-serif, system-ui, sans-serif !important;
}
.sidebar::before, .sidebar::after { background: transparent !important; }
.sidebar .sidebar-header { border-bottom: 1px solid var(--dpa-border) !important; }
.sidebar .sidebar-logo { background: var(--dpa-logo-bg) !important; color: var(--dpa-logo-fg) !important; border: 1px solid var(--dpa-logo-border) !important; }
.sidebar .sidebar-title-main, .sidebar .sidebar-subtitle,
.sidebar .menu-title, .sidebar .sidebar-nav a { color: var(--dpa-text) !important; }
.sidebar .menu-title { opacity: .72; }
.sidebar .menu-title::after { background: var(--dpa-border) !important; }
.sidebar .sidebar-nav a { background: transparent !important; border-color: transparent !important; }
.sidebar .sidebar-nav a i { background: var(--dpa-tile) !important; color: var(--dpa-text) !important; }
.sidebar .sidebar-nav a:hover { background: var(--dpa-hover) !important; color: var(--dpa-text) !important; }
.sidebar .sidebar-nav a.active,
.sidebar .sidebar-nav a[aria-current="page"] {
  background: var(--dpa-active-bg) !important;
  color: var(--dpa-active-text) !important;
  border-radius: 12px !important;
}
.sidebar .sidebar-nav a.active span,
.sidebar .sidebar-nav a[aria-current="page"] span { color: var(--dpa-active-text) !important; }
.sidebar .sidebar-nav a.active i,
.sidebar .sidebar-nav a[aria-current="page"] i {
  background: var(--dpa-active-tile) !important;
  color: var(--dpa-active-text) !important;
}
.sidebar .sidebar-footer { border-top: 1px solid var(--dpa-border) !important; }
.sidebar .dpa-theme-toggle { background: var(--dpa-surface-2) !important; color: var(--dpa-text) !important; border-color: var(--dpa-border) !important; }
.sidebar .sidebar-nav { scrollbar-color: var(--dpa-scroll) transparent; }


</style>
<style>
/* Events page layout aligned with the fixed reference sidebar */
.main-content{
  margin-left:var(--dpa-sidebar-w,260px);
  width:calc(100% - var(--dpa-sidebar-w,260px));
  min-height:100vh;
  padding:clamp(24px,2.5vw,40px);
  box-sizing:border-box;
  background:var(--dpa-bg,#050608);
  color:var(--dpa-text,#f5f5f5);
}
@media(max-width:900px){
  .main-content{margin-left:0;width:100%;padding:18px;}
}
</style>
</head>
<body>



</head>

<body>
<style>body > nav, body > header:not(.page-header), .navbar, .top-navbar, .topbar, #navbar, #topbar { display:none !important; } html,body{margin:0;min-height:100%;} </style>



<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />



<%@ include file="../partials/toast.jsp" %>



<div class="main-content">



  <div class="event-types-page dpa-dash">



    <!-- ================= HERO ================= -->

    <div class="page-header">

        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>

        <div class="hero-left">

            <div class="hero-icon">

                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/><circle cx="7.5" cy="7.5" r=".5" fill="currentColor"/></svg></i>

            </div>

            <div>

                <h1>Event Types</h1>

                <p>Manage all event categories from one place.</p>

            </div>

        </div>

    </div>



    <!-- ================= SUMMARY ================= -->

    <div class="event-summary">



        <div class="summary-card stat-blue reveal">

            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/><circle cx="7.5" cy="7.5" r=".5" fill="currentColor"/></svg></i></div>

            <div class="summary-text">

                <h2 data-count="${totalEventTypes}">${totalEventTypes}</h2>

                <p>Total Event Types</p>

            </div>

        </div>



        <div class="summary-card stat-purple reveal">

            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/><polyline points="16 7 22 7 22 13"/></svg></i></div>

            <div class="summary-text">

                <h2 data-count="${frequentlyUsedTypes}">${frequentlyUsedTypes}</h2>

                <p>Frequently Used</p>

            </div>

        </div>



        <div class="summary-card stat-green reveal">

            <div class="summary-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i></div>

            <div class="summary-text">

                <h2 data-count="${activeEventTypes}">${activeEventTypes}</h2>

                <p>Active Event Types</p>

            </div>

        </div>



    </div>



    <!-- ================= ACTIONS ================= -->

    <div class="event-actions">



        <a href="${pageContext.request.contextPath}/add-event-type" class="action-card reveal">

            <div class="action-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M8 12h8"/><path d="M12 8v8"/></svg></i></div>

            <div class="action-text">

                <h3>Add Event Type</h3>

                <p>Create a new event type.</p>

            </div>

            <span class="action-go" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></i></span>

        </a>



        <a href="${pageContext.request.contextPath}/view-event-types" class="action-card reveal">

            <div class="action-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="8" height="4" x="8" y="2" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><path d="M12 11h4"/><path d="M12 16h4"/><path d="M8 11h.01"/><path d="M8 16h.01"/></svg></i></div>

            <div class="action-text">

                <h3>View Event Types</h3>

                <p>Browse and manage event types.</p>

            </div>

            <span class="action-go" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></i></span>

        </a>



    </div>



  </div>



</div>



<%@ include file="../partials/footer.jsp"%>



<!-- page behaviour: staggered reveal + number count-up -->

<script id="ev-js">

(function () {

	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

	var page = document.querySelector('.dpa-dash');

	if (!page) return;

	var ni = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 });

	var NUM = /^\d+$/;



	function countUp(el) {

		if (el.dataset.counted) return; el.dataset.counted = '1';

		var raw = el.getAttribute('data-count');

		if (!NUM.test(raw)) return;

		var target = parseInt(raw, 10);

		el.textContent = ni.format(target);

		if (reduce || target === 0) return;

		var start = null, dur = 1000;

		function tick(ts) {

			if (start === null) start = ts;

			var p = Math.min((ts - start) / dur, 1), e = 1 - Math.pow(1 - p, 3);

			el.textContent = ni.format(Math.round(target * e));

			if (p < 1) requestAnimationFrame(tick); else el.textContent = ni.format(target);

		}

		requestAnimationFrame(tick);

	}



	['.event-summary', '.event-actions'].forEach(function (sel) {

		page.querySelectorAll(sel).forEach(function (g, gi) {

			Array.prototype.forEach.call(g.children, function (el, i) { el.style.setProperty('--d', (i * 90) + 'ms'); });

		});

	});



	function reveal(el) {

		el.classList.add('in');

		var n = el.querySelector('[data-count]'); if (n) countUp(n);

	}

	var targets = page.querySelectorAll('.reveal');

	if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }

	else {

		var io = new IntersectionObserver(function (entries) {

			entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });

		}, { threshold: 0.1, rootMargin: '0px 0px -30px 0px' });

		targets.forEach(function (t) { io.observe(t); });

	}

})();

</script>



</body>

</html>
