
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Events Dashboard | Digital Purohit Assistant</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/toast.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Anton&family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap" rel="stylesheet">
<style>
html, body{ margin:0; }
body{ font-family:'Inter', system-ui, sans-serif; }
i svg{ width:1em; height:1em; fill:none; stroke:currentColor; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
</style>
<script>
(function () {
  var theme = 'dark';
  try { theme = localStorage.getItem('dpa-theme') || 'dark'; } catch (e) {}
  document.documentElement.setAttribute('data-theme', theme === 'light' ? 'light' : 'dark');
  document.documentElement.classList.add('dpa-js');
})();
</script>
<style>
:root{ --dpa-sidebar-w:240px; --dpa-twilight:#426188; --dpa-link:#2b7fff; }
:root,:root[data-theme="dark"]{ --dpa-bg:#050608; --dpa-surface:#10141c; --dpa-surface-2:#161b26; --dpa-text:#f5f5f5; --dpa-muted:rgba(255,255,255,.58); --dpa-border:rgba(255,255,255,.09); --dpa-sb-bg:#080a0f; --dpa-hover:rgba(255,255,255,.06); --dpa-tile:rgba(255,255,255,.07); color-scheme:dark; }
:root[data-theme="light"]{ --dpa-bg:#f1f4f9; --dpa-surface:#fff; --dpa-surface-2:#f5f5f5; --dpa-text:#1b1b1b; --dpa-muted:#6b7280; --dpa-border:rgba(0,0,0,.09); --dpa-sb-bg:#fff; --dpa-hover:rgba(0,0,0,.045); --dpa-tile:rgba(0,0,0,.05); color-scheme:light; }
@media (max-width:900px){ :root{ --dpa-sidebar-w:0px; } }
body{ background:var(--dpa-bg); color:var(--dpa-text); transition:background-color .35s,color .35s; }
</style>
<style>
/* =====================================================================
   EVENTS DASHBOARD — same design system as Customers / Pending Payments
   Colours come from the shared theme variables (--dpa-*), so the
   dark / light switch restyles this page too.
   ===================================================================== */
.main-content{
	margin-left:var(--dpa-sidebar-w, 260px);
	margin-top:0 !important;
	padding:clamp(8px, 1.1vw, 16px) clamp(14px, 2.4vw, 34px);
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

<!-- Shared sidebar/theme styling copied from the working Customers page -->
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
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />
<%@ include file="../partials/toast.jsp" %>

<div class="main-content">
  <div class="events-page dpa-dash">
    <section class="page-header">
      <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;·&nbsp; Digital Purohit &nbsp;·&nbsp; Digital Purohit &nbsp;·&nbsp;</span>
      <div class="hero-left">
        <div class="hero-icon" aria-hidden="true">
          <svg viewBox="0 0 24 24" role="img" aria-label="Event schedule" style="width:1.15em;height:1.15em;fill:none;stroke:currentColor;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round">
            <rect x="3.5" y="5" width="17" height="15" rx="2.2"></rect><path d="M7.5 3.5v3M16.5 3.5v3M3.5 9h17M8 13h3M8 16h6"></path>
          </svg>
        </div>
        <div><h1>Events</h1><p>Manage all events from one place.</p></div>
      </div>
    </section>

    <section class="event-summary" aria-label="Event summary">
      <a class="summary-card stat-blue reveal" href="${pageContext.request.contextPath}/view-events?filter=all">
        <div class="summary-icon">▦</div><div class="summary-text">
          <h2 data-count="${totalEvents}">${totalEvents}</h2><p>Total Events</p>
        </div>
      </a>
      <a class="summary-card stat-green reveal" href="${pageContext.request.contextPath}/view-events?filter=today">
        <div class="summary-icon">✓</div><div class="summary-text">
          <h2 data-count="${todayEvents}">${todayEvents}</h2><p>Today's Events</p>
        </div>
      </a>
      <a class="summary-card stat-purple reveal" href="${pageContext.request.contextPath}/view-events?filter=upcoming">
        <div class="summary-icon">◷</div><div class="summary-text">
          <h2 data-count="${upcomingEvents}">${upcomingEvents}</h2><p>Upcoming Events</p>
        </div>
      </a>
      <a class="summary-card stat-orange reveal" href="${pageContext.request.contextPath}/view-events?filter=pending">
        <div class="summary-icon">₹</div><div class="summary-text">
          <h2 data-count="${pendingPayments}">${pendingPayments}</h2><p>Pending Payments</p>
        </div>
      </a>
    </section>

    <section class="event-actions" aria-label="Event actions">
      <a href="${pageContext.request.contextPath}/add-event" class="action-card reveal">
        <div class="action-icon">＋</div><div class="action-text"><h3>Add Event</h3><p>Create a new event.</p></div><span class="action-go">→</span>
      </a>
      <a href="${pageContext.request.contextPath}/view-events" class="action-card reveal">
        <div class="action-icon">▤</div><div class="action-text"><h3>View Events</h3><p>Search, edit and manage events.</p></div><span class="action-go">→</span>
      </a>
      <a href="${pageContext.request.contextPath}/event-types" class="action-card reveal">
        <div class="action-icon">◇</div><div class="action-text"><h3>Event Types</h3><p>Manage event categories.</p></div><span class="action-go">→</span>
      </a>
      <a href="${pageContext.request.contextPath}/samagri" class="action-card reveal">
        <div class="action-icon">🪔</div><div class="action-text"><h3>Master Samagri</h3><p>Manage all pooja materials.</p></div><span class="action-go">→</span>
      </a>
    </section>
  </div>
</div>
<script>
(function () {
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var page = document.querySelector('.dpa-dash');
  if (!page) return;
  var formatter = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 });
  function countUp(el) {
    if (el.dataset.counted) return;
    el.dataset.counted = '1';
    var target = Number(el.getAttribute('data-count'));
    if (!Number.isFinite(target) || target < 0) return;
    if (reduce || target === 0) { el.textContent = formatter.format(target); return; }
    var start = null, duration = 900;
    function tick(ts) {
      if (start === null) start = ts;
      var progress = Math.min((ts - start) / duration, 1);
      el.textContent = formatter.format(Math.round(target * (1 - Math.pow(1 - progress, 3))));
      if (progress < 1) requestAnimationFrame(tick);
      else el.textContent = formatter.format(target);
    }
    requestAnimationFrame(tick);
  }
  page.querySelectorAll('.event-summary > *, .event-actions > *').forEach(function (el, i) {
    el.style.setProperty('--d', (i * 90) + 'ms');
  });
  function reveal(el) {
    el.classList.add('in');
    var counter = el.querySelector('[data-count]');
    if (counter) countUp(counter);
  }
  var targets = page.querySelectorAll('.reveal');
  if (!('IntersectionObserver' in window)) targets.forEach(reveal);
  else {
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) { reveal(entry.target); observer.unobserve(entry.target); }
      });
    }, { threshold: 0.1, rootMargin: '0px 0px -30px 0px' });
    targets.forEach(function (el) { observer.observe(el); });
  }
})();
</script>
</body>
</html>
