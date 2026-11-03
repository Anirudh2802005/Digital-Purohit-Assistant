<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.digitalpurohit.model.Customer" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Customer customer = (Customer) request.getAttribute("customer");
    Boolean editModeAttr = (Boolean) request.getAttribute("editMode");
    boolean editMode = editModeAttr != null ? editModeAttr.booleanValue() : customer != null;
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= editMode ? "Edit Customer" : "Add Customer" %> | Digital Purohit Assistant</title>
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
   CUSTOMER FORM (add / edit) — same design system as the dashboard
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
	max-width:62em; margin:0 auto;
	display:flex; flex-direction:column; gap:1.5em;
	font-family:'Inter', ui-sans-serif, system-ui, sans-serif;
	font-size:calc(14px * var(--dk)); font-weight:500; line-height:1.45;
	color:var(--dpa-text);
	-webkit-font-smoothing:antialiased;
}
.dpa-dash, .dpa-dash *{ box-sizing:border-box; }
.dpa-dash h1, .dpa-dash h2, .dpa-dash p{ margin:0; }
.dpa-dash a{ text-decoration:none; }

@media (min-width:1700px){ .dpa-dash{ --dk:1.14; } }
@media (min-width:2400px){ .dpa-dash{ --dk:1.4; } }
@media (min-width:3200px){ .dpa-dash{ --dk:1.78; } }

/* ---------- animations ---------- */
@keyframes dpaRise{ from{ opacity:0; translate:0 22px; } to{ opacity:1; translate:0 0; } }
@keyframes dpaFloat2{ 0%,100%{ transform:translate(0,0) scale(1); } 50%{ transform:translate(-26px,30px) scale(1.08); } }
@keyframes dpaDrift{ from{ transform:translateX(0); } to{ transform:translateX(-50%); } }
@keyframes dpaRing{ 0%{ box-shadow:0 0 0 0 rgba(255,255,255,.35); } 70%,100%{ box-shadow:0 0 0 14px rgba(255,255,255,0); } }
@keyframes dpaSpin{ to{ transform:rotate(360deg); } }
@keyframes dpaShake{ 10%,90%{ translate:-1px 0; } 20%,80%{ translate:2px 0; } 30%,50%,70%{ translate:-4px 0; } 40%,60%{ translate:4px 0; } }
.dpa-js .dpa-dash .reveal{ opacity:0; }
.dpa-js .dpa-dash .reveal.in{ animation:dpaRise .7s cubic-bezier(.2,.8,.2,1) var(--d, 0ms) both; }

/* =====================================================================
   HERO (page heading)
   ===================================================================== */
.dpa-dash .page-header{
	position:relative; overflow:hidden; isolation:isolate;
	display:flex; align-items:center; gap:1.3em;
	margin:0; padding:2em 2.2em;
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
.dpa-dash .hero-icon{
	flex-shrink:0; width:2.4em; height:2.4em; font-size:1.5em; border-radius:.7em;
	display:flex; align-items:center; justify-content:center;
	border:1px solid rgba(255,255,255,.55); color:#fff; background:rgba(255,255,255,.04);
	animation:dpaRing 3.2s ease-out infinite;
}
.dpa-dash .page-header h1{
	font-family:'Anton', ui-sans-serif, sans-serif; font-weight:400; text-transform:uppercase;
	font-size:clamp(1.8em, 3.2vw, 3em); line-height:1; letter-spacing:.01em; color:#fff; overflow-wrap:anywhere;
}
.dpa-dash .page-header p{ margin-top:.55em; color:rgba(255,255,255,.72); font-weight:400; font-size:1.05em; }

/* =====================================================================
   FORM CARD
   ===================================================================== */
.dpa-dash .form-card{
	margin:0; padding:2em 2.1em 2.1em;
	border-radius:1.15em; border:1px solid var(--dpa-border); box-shadow:none;
	background:var(--dpa-surface); color:var(--dpa-text);
	transition:background-color .35s, border-color .35s;
}
.dpa-dash .form-card form{ margin:0; padding:0; background:transparent; border:0; box-shadow:none; }

.dpa-dash .form-row{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:0 1.3em; margin:0; }
.dpa-dash .form-row > .form-group:only-child{ grid-column:1 / -1; }
.dpa-dash .form-group{ min-width:0; margin:0 0 1.35em; padding:0; background:transparent; border:0; }

.dpa-dash .form-group label{
	display:block; margin:0 0 .55em; padding:0;
	font-size:.8em; font-weight:700; letter-spacing:.07em; text-transform:uppercase; color:var(--dpa-muted);
	transition:color .2s;
}
.dpa-dash .form-group label span{ color:#ff6b6b; margin-left:.2em; }
.dpa-dash .form-group:focus-within label{ color:var(--dpa-text); }

.dpa-dash .input-wrap{
	position:relative; display:flex; align-items:center;
	background:var(--dpa-surface-2); border:1.5px solid var(--dpa-border); border-radius:.75em;
	padding:0 1em;
	transition:border-color .2s, box-shadow .2s, background-color .25s, transform .2s;
}
.dpa-dash .input-wrap.is-area{ align-items:flex-start; }
.dpa-dash .input-wrap > i{
	flex-shrink:0; width:1.2em; text-align:center; font-size:1.05em; color:var(--dpa-muted);
	transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1);
}
.dpa-dash .input-wrap.is-area > i{ margin-top:1.05em; }
.dpa-dash .input-wrap:focus-within{
	border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.2);
}
.dpa-dash .input-wrap:focus-within > i{ color:var(--dpa-link); transform:scale(1.12); }

.dpa-dash .input-wrap input,
.dpa-dash .input-wrap textarea{
	flex:1; min-width:0; width:100%; margin:0; border:0; outline:0; background:transparent; box-shadow:none;
	padding:.95em .8em; border-radius:0; resize:none;
	font-family:inherit; font-size:1em; font-weight:500; line-height:1.5; color:var(--dpa-text);
}
.dpa-dash .input-wrap textarea{ resize:vertical; min-height:7em; }
.dpa-dash .input-wrap input::placeholder,
.dpa-dash .input-wrap textarea::placeholder{ color:var(--dpa-muted); opacity:.75; font-weight:400; }
.dpa-dash .input-wrap:has(:user-invalid){ border-color:var(--dpa-bad); }
.dpa-dash .input-wrap:has(:user-invalid):focus-within{ box-shadow:0 0 0 4px rgba(214,69,69,.2); }

/* ---------- buttons ---------- */
.dpa-dash .form-buttons{
	display:flex; flex-wrap:wrap; align-items:center; gap:.8em;
	margin:.6em 0 0; padding:1.5em 0 0; border-top:1px solid var(--dpa-border);
}
.dpa-dash .form-buttons .btn-primary,
.dpa-dash .form-buttons .btn-secondary,
.dpa-dash .form-buttons .btn-cancel{
	position:relative; overflow:hidden; display:inline-flex; align-items:center; justify-content:center; gap:.6em;
	margin:0; padding:.95em 1.5em; border-radius:.75em; box-shadow:none;
	font-family:inherit; font-size:1em; font-weight:600; letter-spacing:0; line-height:1.2; cursor:pointer;
	transition:background-color .2s, color .2s, border-color .2s, transform .12s, box-shadow .25s;
}
.dpa-dash .form-buttons .btn-primary{
	background:var(--dpa-active-bg); color:var(--dpa-active-text); border:1px solid var(--dpa-active-bg);
}
.dpa-dash .form-buttons .btn-primary::after{
	content:""; position:absolute; top:0; left:-120%; width:60%; height:100%;
	background:linear-gradient(100deg, transparent, rgba(255,255,255,.35), transparent);
	transform:skewX(-20deg); transition:left .6s;
}
.dpa-dash .form-buttons .btn-secondary{ background:transparent; color:var(--dpa-text); border:1px solid var(--dpa-border); }
.dpa-dash .form-buttons .btn-cancel{ background:transparent; color:var(--dpa-muted); border:1px solid transparent; margin-left:auto; }
.dpa-dash .form-buttons .btn-primary.loading{ pointer-events:none; opacity:.85; }
.dpa-dash .form-buttons .btn-primary.loading i{ animation:dpaSpin .8s linear infinite; }
.dpa-dash .form-card.shake{ animation:dpaShake .4s ease; }

@media (hover:hover) and (pointer:fine){
	.dpa-dash .input-wrap:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .form-buttons .btn-primary:hover{ background:var(--dpa-twilight); border-color:var(--dpa-twilight); color:#fff; box-shadow:0 8px 22px rgba(66,97,136,.4); }
	.dpa-dash .form-buttons .btn-primary:hover::after{ left:140%; }
	.dpa-dash .form-buttons .btn-secondary:hover{ background:var(--dpa-hover); border-color:var(--dpa-text); }
	.dpa-dash .form-buttons .btn-cancel:hover{ color:var(--dpa-text); background:var(--dpa-hover); }
}
.dpa-dash .form-buttons .btn-primary:active,
.dpa-dash .form-buttons .btn-secondary:active,
.dpa-dash .form-buttons .btn-cancel:active{ transform:scale(.97); }
.dpa-dash .form-buttons :focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* =====================================================================
   RESPONSIVE
   ===================================================================== */
@media (max-width:700px){
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; gap:.95em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .form-card{ padding:1.4em 1.2em 1.5em; }
	.dpa-dash .form-row{ grid-template-columns:minmax(0, 1fr); }
	.dpa-dash .form-buttons{ flex-direction:column-reverse; align-items:stretch; }
	.dpa-dash .form-buttons .btn-primary,
	.dpa-dash .form-buttons .btn-secondary,
	.dpa-dash .form-buttons .btn-cancel{ width:100%; margin-left:0; padding:1.05em 1.2em; }
}

@media print{
	.main-content{ margin-left:0; padding:0; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
	.dpa-dash .page-header{ background:#fff; color:#000; border-color:#ccc; }
	.dpa-dash .page-header *{ color:#000 !important; }
	.dpa-dash .form-buttons{ display:none; }
}
@media (prefers-reduced-motion: reduce){
	.dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
	.dpa-js .dpa-dash .reveal{ opacity:1; }
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

<!-- ================= MOBILE TOP BAR ================= -->
<div class="dpa-mobile-bar">
    <button type="button" class="dpa-menu-btn" id="dpaMenuOpen" aria-label="Open menu" aria-expanded="false" aria-controls="dpaSidebar">
        <i class="fa-solid fa-bars"><svg viewBox="0 0 24 24" aria-hidden="true"><line x1="4" x2="20" y1="12" y2="12"/><line x1="4" x2="20" y1="6" y2="6"/><line x1="4" x2="20" y1="18" y2="18"/></svg></i>
    </button>
    <div class="dpa-mobile-title">Digital Purohit <em>Assistant</em></div>
</div>
<div class="dpa-backdrop" id="dpaBackdrop"></div>

<div class="sidebar" id="dpaSidebar">

    <!-- ================= HEADER ================= -->

    <div class="sidebar-header">

        <div class="sidebar-logo">

            <i class="fa-solid fa-place-of-worship"><svg viewBox="0 0 24 24" aria-hidden="true"><line x1="3" x2="21" y1="22" y2="22"/><line x1="6" x2="6" y1="18" y2="11"/><line x1="10" x2="10" y1="18" y2="11"/><line x1="14" x2="14" y1="18" y2="11"/><line x1="18" x2="18" y1="18" y2="11"/><polygon points="12 2 20 7 4 7"/></svg></i>

        </div>

        <div class="sidebar-title-container">

            <div class="sidebar-title-main">

                Digital Purohit

            </div>

            <div class="sidebar-subtitle">

                Assistant

            </div>

        </div>

    </div>

    <nav class="sidebar-nav">

    <!-- ================= MAIN MENU ================= -->

    <div class="menu-title">

        MAIN MENU

    </div>

    <!-- Notification -->

<a href="javascript:void(0);"
   class="notif-link"
   onclick="openNotifications();">

    <i class="fa-solid fa-bell"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg></i>

    <span>Notifications</span>

   <span class="menu-badge"><c:out value="${empty unreadCount ? 0 : unreadCount}"/></span>

</a>

    <!-- Dashboard -->

    <a href="<%= contextPath %>/dashboard">

        <i class="fa-solid fa-house"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"/><path d="M3 10a2 2 0 0 1 .709-1.528l7-5.999a2 2 0 0 1 2.582 0l7 5.999A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg></i>

        <span>

            Dashboard

        </span>

    </a>

    <!-- Frequently Used -->

    

    <!-- Reminders -->

    

    <!-- ================= MANAGEMENT ================= -->

    <div class="menu-title">

        MANAGEMENT

    </div>

    <a href="<%= contextPath %>/customers">

        <i class="fa-solid fa-users"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i>

        <span>

            Customers

        </span>

    </a>

    <a href="<%= contextPath %>/events">

        <i class="fa-solid fa-calendar-days"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i>

        <span>

            Events

        </span>

    </a>

    <a href="<%= contextPath %>/bulk-dashboard">

        <i class="fa-solid fa-hands-praying"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z"/></svg></i>

        <span>

            Bulk Events

        </span>

    </a>

    <a href="<%= contextPath %>/pending-payments">

        <i class="fa-solid fa-money-bill-wave"><svg viewBox="0 0 24 24" aria-hidden="true"><rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg></i>

        <span>

            Pending Payments

        </span>

    </a>

    <a href="<%= contextPath %>/calendar">

        <i class="fa-solid fa-calendar-days"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i>

        <span>

            Calendar

        </span>

    </a>

    <a href="<%= contextPath %>/reports">

        <i class="fa-solid fa-chart-line"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 3v16a2 2 0 0 0 2 2h16"/><path d="m19 9-5 5-4-4-3 3"/></svg></i>

        <span>

            Reports

        </span>

    </a>

   

    <!-- ================= ACCOUNT ================= -->

    <div class="menu-title">

        ACCOUNT

    </div>
    
<a href="<%= contextPath %>/profile">

    <i class="fa-solid fa-user"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i>

    <span>

        Profile

    </span>

</a>

    <a href="<%= contextPath %>/logout"
       class="logout-link"
       onclick="return confirm('Logout?');">

        <i class="fa-solid fa-right-from-bracket"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" x2="9" y1="12" y2="12"/></svg></i>

        <span>

            Logout

        </span>

    </a>

    </nav>

    <!-- ================= THEME TOGGLE ================= -->

    <div class="sidebar-footer">
        <button type="button" class="dpa-theme-toggle" id="dpaThemeToggle" aria-pressed="false" aria-label="Switch between dark and light mode">
            <span class="dpa-tt-label">
                <span class="dpa-tt-icons">
                    <i class="fa-solid fa-moon dpa-tt-moon"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/></svg></i>
                    <i class="fa-solid fa-sun dpa-tt-sun"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="4"/><path d="M12 2v2"/><path d="M12 20v2"/><path d="m4.93 4.93 1.41 1.41"/><path d="m17.66 17.66 1.41 1.41"/><path d="M2 12h2"/><path d="M20 12h2"/><path d="m6.34 17.66-1.41 1.41"/><path d="m19.07 4.93-1.41 1.41"/></svg></i>
                </span>
                <span id="dpaThemeLabel">Dark mode</span>
            </span>
            <span class="dpa-tt-switch"><span class="dpa-tt-knob"></span></span>
        </button>
    </div>

</div>
<!-- ================= Notification ================= -->
<!-- (duplicate of the sidebar link, kept from the original file but hidden) -->

<div class="dpa-dup-link">
<a href="javascript:void(0);" onclick="openNotifications();">

    <i class="fa-solid fa-bell"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg></i>

    <span>Notifications</span>

   <span class="menu-badge"><c:out value="${empty unreadCount ? 0 : unreadCount}"/></span>
</a>
</div>

<!-- ================= Notification Overlay ================= -->

<!-- ==========================================================
     NOTIFICATION POPUP
========================================================== -->

<div id="notificationOverlay" class="notification-overlay">

    <div class="notification-popup">

        <!-- Header -->

        <div class="notification-popup-header">

            <div class="notification-header-left">

                <div class="notification-header-icon">

                    <i class="fa-solid fa-bell"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg></i>

                </div>

                <div>

                    <h2>Notifications</h2>

                    <p>Stay updated with recent activities</p>

                </div>

            </div>

            <div class="notification-actions">

                <button id="markAllRead">

                    <i class="fa-solid fa-check-double"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 7 17l-5-5"/><path d="m22 10-7.5 7.5L13 16"/></svg></i>

                    Mark All Read

                </button>

                <button id="deleteAllBtn">

                    <i class="fa-solid fa-trash"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg></i>

                    Delete All

                </button>

                <button id="closeNotification">

                    <i class="fa-solid fa-xmark"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i>

                </button>

            </div>

        </div>

        <!-- Notification Body -->

        <div id="notificationContainer">

        </div>

        <!-- Footer -->

        <div class="notification-footer">

            <div class="notification-total">

                <i class="fa-regular fa-square-check"><svg viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="3" rx="2"/><path d="m9 12 2 2 4-4"/></svg></i>

                Total Notifications :

                <strong id="totalNotifications">

                    0

                </strong>

            </div>

            <a href="javascript:void(0);" class="view-all-link">

                View All Notifications

                <i class="fa-solid fa-arrow-right"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></i>

            </a>

        </div>

    </div>

</div>

<!-- ===========================================
     GLOBAL TOAST
=========================================== -->

<div id="globalToast"
     class="global-toast ">

    <div class="toast-left">

        <i id="toastIcon"
           class="fa-solid fa-circle-check"><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg></i>

    </div>

    <div class="toast-body">

        <div id="toastTitle"
             class="toast-title">

            

        </div>

        <div id="toastMessage"
             class="toast-message">

            

        </div>

    </div>

    <button id="toastClose">

        <i class="fa-solid fa-xmark"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i>

    </button>

</div>





<script>
    const contextPath = "";
</script>

<!-- ================= SIDEBAR + THEME BEHAVIOUR ================= -->
<script>
(function () {
  var root = document.documentElement;
  var KEY = 'dpa-theme';
  var sidebar = document.querySelector('.sidebar');
  if (!sidebar) return;
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* stagger the entrance of menu items */
  var nav = sidebar.querySelector('.sidebar-nav');
  Array.prototype.forEach.call(nav.children, function (el, i) { el.style.setProperty('--i', i); });

  /* highlight the link for the current page */
  (function markActive() {
    var path = location.pathname.replace(/\/+$/, '');
    var best = null, bestLen = -1;
    nav.querySelectorAll('a[href]').forEach(function (a) {
      var h = a.getAttribute('href');
      if (!h || h.charAt(0) === '#' || h.indexOf('javascript') === 0 || a.classList.contains('logout-link')) return;
      var p = new URL(a.href, location.href).pathname.replace(/\/+$/, '');
      if (path === p || path.indexOf(p + '/') === 0) {
        if (p.length > bestLen) { best = a; bestLen = p.length; }
      }
    });
    if (best) best.classList.add('active');
  })();

  /* hide the badge when there is nothing unread */
  document.querySelectorAll('.menu-badge').forEach(function (b) {
    function check() { b.classList.toggle('is-zero', b.textContent.trim() === '0'); }
    check();
    new MutationObserver(check).observe(b, { childList: true, characterData: true, subtree: true });
  });

  /* ---------- theme toggle ---------- */
  var btn = document.getElementById('dpaThemeToggle');
  var label = document.getElementById('dpaThemeLabel');
  function current() { return root.getAttribute('data-theme') === 'light' ? 'light' : 'dark'; }
  function paint() {
    var t = current();
    label.textContent = t === 'dark' ? 'Dark mode' : 'Light mode';
    btn.setAttribute('aria-pressed', t === 'light' ? 'true' : 'false');
  }
  function setTheme(t) {
    root.setAttribute('data-theme', t);
    try { localStorage.setItem(KEY, t); } catch (e) {}
    paint();
    window.dispatchEvent(new CustomEvent('dpa-theme-change', { detail: { theme: t } }));
  }
  paint();

  btn.addEventListener('click', function (e) {
    var next = current() === 'dark' ? 'light' : 'dark';
    if (document.startViewTransition && !reduce) {
      var r = btn.getBoundingClientRect();
      var x = e.detail === 0 ? r.left + r.width / 2 : e.clientX;
      var y = e.detail === 0 ? r.top + r.height / 2 : e.clientY;
      var radius = Math.hypot(Math.max(x, window.innerWidth - x), Math.max(y, window.innerHeight - y));
      var vt = document.startViewTransition(function () { setTheme(next); });
      vt.ready.then(function () {
        root.animate(
          { clipPath: ['circle(0px at ' + x + 'px ' + y + 'px)', 'circle(' + radius + 'px at ' + x + 'px ' + y + 'px)'] },
          { duration: 650, easing: 'ease-in-out', pseudoElement: '::view-transition-new(root)' }
        );
      });
    } else {
      root.classList.add('dpa-theme-anim');
      setTheme(next);
      setTimeout(function () { root.classList.remove('dpa-theme-anim'); }, 450);
    }
  });

  /* keep other open tabs in sync */
  window.addEventListener('storage', function (e) {
    if (e.key === KEY && e.newValue) { root.setAttribute('data-theme', e.newValue === 'light' ? 'light' : 'dark'); paint(); }
  });

  /* ---------- mobile drawer ---------- */
  var openBtn = document.getElementById('dpaMenuOpen');
  var backdrop = document.getElementById('dpaBackdrop');
  var mq = window.matchMedia('(max-width:900px), (max-width:1100px) and (max-height:520px)');
  function isOpen() { return sidebar.classList.contains('open'); }
  function openSb() {
    if (!mq.matches) return;
    sidebar.classList.add('open'); backdrop.classList.add('show');
    root.classList.add('dpa-lock'); openBtn.setAttribute('aria-expanded', 'true');
    var first = sidebar.querySelector('.sidebar-nav a'); if (first) setTimeout(function () { first.focus({ preventScroll: true }); }, 60);
  }
  function closeSb(restoreFocus) {
    var was = isOpen();
    sidebar.classList.remove('open'); backdrop.classList.remove('show');
    root.classList.remove('dpa-lock'); openBtn.setAttribute('aria-expanded', 'false');
    if (was && restoreFocus) openBtn.focus({ preventScroll: true });
  }
  openBtn.addEventListener('click', openSb);
  backdrop.addEventListener('click', function () { closeSb(true); });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape' && isOpen()) closeSb(true); });
  sidebar.querySelectorAll('a').forEach(function (a) {
    a.addEventListener('click', function () { if (mq.matches) closeSb(false); });
  });
  /* leaving mobile layout (rotate / resize) must never leave the drawer or scroll-lock stuck */
  var onMq = function () { if (!mq.matches) closeSb(false); };
  if (mq.addEventListener) mq.addEventListener('change', onMq); else mq.addListener(onMq);

  /* swipe: from the left edge to open, leftwards on the menu to close */
  var sx = 0, sy = 0, tracking = false;
  document.addEventListener('touchstart', function (e) {
    if (!mq.matches || e.touches.length !== 1) return;
    sx = e.touches[0].clientX; sy = e.touches[0].clientY;
    tracking = isOpen() || sx < 22;
  }, { passive: true });
  document.addEventListener('touchend', function (e) {
    if (!tracking) return; tracking = false;
    var dx = e.changedTouches[0].clientX - sx, dy = e.changedTouches[0].clientY - sy;
    if (Math.abs(dy) > 60 || Math.abs(dx) < 60) return;
    if (!isOpen() && dx > 0) openSb();
    else if (isOpen() && dx < 0) closeSb(true);
  }, { passive: true });
})();
</script>





<div class="main-content">

  <div class="customer-form-page dpa-dash">

    <div class="page-header">

        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>

        <div class="hero-icon">

            <i class="fa-solid fa-user-plus"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" x2="19" y1="8" y2="14"/><line x1="22" x2="16" y1="11" y2="11"/></svg></i>

        </div>

        <div>

        <h1><%= editMode ? "Edit Customer" : "Add Customer" %></h1>
        <p><%= editMode ? "Update customer information." : "Register a new customer in the system." %></p>

        </div>

    </div>

    <c:if test="${not empty errorMessage}">
      <div role="alert" style="padding:12px 16px;margin-bottom:14px;border:1px solid #d64545;border-radius:10px;color:#ff8a8a;">
        <c:out value="${errorMessage}"/>
      </div>
    </c:if>
    <c:if test="${not empty successMessage}">
      <div role="status" style="padding:12px 16px;margin-bottom:14px;border:1px solid #2e9d63;border-radius:10px;color:#48c78e;">
        <c:out value="${successMessage}"/>
      </div>
    </c:if>

    <div class="form-card reveal">

        <form action="<%= contextPath %>/<%= editMode ? "edit-customer" : "add-customer" %>"
              method="post" id="customerForm" accept-charset="UTF-8">

            
            <% if (editMode) { %>
            <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>">
            <% } %>

            <div class="form-row">

                <div class="form-group reveal">

                    <label for="customerName">Customer Name <span>*</span></label>

                    <div class="input-wrap">

                        <i class="fa-solid fa-user"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i>

                        <input type="text"
                               id="customerName"
                               name="customerName"
                               placeholder="Enter Customer Name"
                               autocomplete="name"
                               value="<c:out value='${customer.customerName}'/>"
                               maxlength="120"
                               required>

                    </div>

                </div>

                <div class="form-group reveal">

                    <label for="phone">Phone Number <span>*</span></label>

                    <div class="input-wrap">

                        <i class="fa-solid fa-phone"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg></i>

                        <input type="text"
                               id="phone"
                               name="phone"
                               placeholder="Enter Phone Number"
                               autocomplete="tel"
                               inputmode="tel"
                               value="<c:out value='${customer.phone}'/>"
                               maxlength="20"
                               pattern="[0-9+() .-]{7,20}"
                               title="Enter a valid phone number"
                               required>

                    </div>

                </div>

            </div>

            <div class="form-group reveal">

                <label for="address">Address</label>

                <div class="input-wrap is-area">

                    <i class="fa-solid fa-location-dot"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/><circle cx="12" cy="10" r="3"/></svg></i>

                    <textarea name="address"
                              id="address"
                              rows="4"
                              placeholder="Enter Address"><c:out value="${customer.address}"/></textarea>

                </div>

            </div>

            <div class="form-row">

                <div class="form-group reveal">

                    <label for="gothram">Gothram</label>

                    <div class="input-wrap">

                        <i class="fa-solid fa-om"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z"/></svg></i>

                        <input type="text"
                               id="gothram"
                               name="gothram"
                               placeholder="Enter Gothram"
                               value="<c:out value='${customer.gothram}'/>"
                               maxlength="120">

                    </div>

                </div>

            </div>

            <div class="form-group reveal">

                <label for="notes">Notes</label>

                <div class="input-wrap is-area">

                    <i class="fa-solid fa-note-sticky"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V8Z"/><path d="M15 3v5a2 2 0 0 0 2 2h4"/></svg></i>

                    <textarea name="notes"
                              id="notes"
                              rows="4"
                              placeholder="Additional Notes"><c:out value="${customer.notes}"/></textarea>

                </div>

            </div>

            <div class="form-buttons">

                <button type="submit"
                        class="btn-primary">

                    <i class="fa-solid fa-floppy-disk"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z"/><path d="M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7"/><path d="M7 3v4a1 1 0 0 0 1 1h7"/></svg></i>

                    <span><%= editMode ? "Update Customer" : "Save Customer" %></span>

                </button>

                <button type="reset"
                        class="btn-secondary">

                    <i class="fa-solid fa-rotate-left"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg></i>

                    Reset

                </button>

                <a href="<%= contextPath %>/customers"
                   class="btn-cancel">

                    <i class="fa-solid fa-xmark"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></i>

                    Cancel

                </a>

            </div>

        </form>

    </div>

  </div>

</div>



<!-- page animations + submit feedback -->
<script>
(function () {
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var page = document.querySelector('.dpa-dash');
	if (!page) return;

	/* stagger the form fields */
	var i = 0;
	page.querySelectorAll('.form-group.reveal').forEach(function (el) {
		el.style.setProperty('--d', (120 + i * 80) + 'ms'); i++;
	});

	function show(el) { el.classList.add('in'); }
	var targets = page.querySelectorAll('.reveal');
	if (!('IntersectionObserver' in window)) { targets.forEach(show); }
	else {
		var io = new IntersectionObserver(function (entries) {
			entries.forEach(function (en) { if (en.isIntersecting) { show(en.target); io.unobserve(en.target); } });
		}, { threshold: 0.08, rootMargin: '0px 0px -20px 0px' });
		targets.forEach(function (t) { io.observe(t); });
	}

	/* submit feedback: spinner + guard against double clicks. The form is submitted normally. */
	var form = document.getElementById('customerForm');
	var card = page.querySelector('.form-card');
	var sent = false;
	form.addEventListener('submit', function (e) {
		if (sent) { e.preventDefault(); return; }
		sent = true;
		var btn = form.querySelector('.btn-primary');
		btn.classList.add('loading');
		btn.querySelector('span').textContent = 'Saving…';
		var icon = btn.querySelector('i');
		icon.className = 'fa-solid fa-circle-notch';
	});
	/* invalid required field: shake the card once */
	form.addEventListener('invalid', function () {
		if (reduce) return;
		card.classList.remove('shake'); void card.offsetWidth; card.classList.add('shake');
	}, true);
	/* coming back with the browser's back button must not leave the button stuck on "Saving…" */
	window.addEventListener('pageshow', function (e) {
		if (!e.persisted) return;
		sent = false;
		var btn = form.querySelector('.btn-primary');
		btn.classList.remove('loading');
		btn.querySelector('i').className = 'fa-solid fa-floppy-disk';
	});
})();
</script>


<script>
  var overlay = document.getElementById('notificationOverlay');
  function openNotifications(){ overlay.classList.add('show'); }
  document.getElementById('closeNotification').addEventListener('click', function(){ overlay.classList.remove('show'); });
  document.querySelectorAll('.sidebar-nav a.active').forEach(function(x){ x.classList.remove('active'); });
  var c = document.querySelector('.sidebar-nav a[href$="/customers"]');
  if (c) c.classList.add('active');

</script>
</body>
</html>