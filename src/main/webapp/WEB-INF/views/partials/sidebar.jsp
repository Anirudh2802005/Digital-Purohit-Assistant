<%-- Digital Purohit Assistant: reusable sidebar + notification popup include --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/notification.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/notification-popup.css">
<script>
  var contextPath = '${pageContext.request.contextPath}';
  window.contextPath = contextPath;
</script>
<script>
  (function () {
    var t = 'dark';
    try { t = localStorage.getItem('dpa-theme') || 'dark'; } catch (e) {}
    document.documentElement.setAttribute('data-theme', t === 'light' ? 'light' : 'dark');
  })();
</script>

<style>
  /* ============ THEME VARIABLES (shared by every page) ============ */
  :root{ --dpa-sidebar-w:260px; --dpa-bad:#d64545; --dpa-twilight:#426188; --dpa-link:#2b7fff; --dpa-good:#22a06b; --dpa-warn:#e0a100; }
  :root, :root[data-theme="dark"]{
    --dpa-bg:#050608; --dpa-surface:#10141c; --dpa-surface-2:#161b26;
    --dpa-text:#f5f5f5; --dpa-muted:rgba(255,255,255,.58); --dpa-border:rgba(255,255,255,.09);
    --dpa-sb-bg:#080a0f; --dpa-hover:rgba(255,255,255,.06); --dpa-tile:rgba(255,255,255,.07);
    --dpa-active-bg:#f5f5f5; --dpa-active-text:#1b1b1b; --dpa-active-tile:rgba(0,0,0,.08);
    --dpa-logo-bg:transparent; --dpa-logo-fg:#fff; --dpa-logo-border:rgba(255,255,255,.6);
    --dpa-glow-a:rgba(66,97,136,.55); --dpa-glow-b:rgba(43,127,255,.22);
    --dpa-switch:rgba(255,255,255,.2); --dpa-scroll:rgba(255,255,255,.18);
    --dpa-mobile-bar:rgba(8,10,15,.8);
    /* notification popup — dark */
    --np-bg:rgba(16,20,28,.94); --np-head:linear-gradient(180deg, rgba(255,255,255,.05), rgba(255,255,255,0));
    --np-item:rgba(255,255,255,.04); --np-item-hover:rgba(255,255,255,.08);
    --np-unread:rgba(43,127,255,.12); --np-shadow:0 40px 100px rgba(0,0,0,.65), 0 0 0 1px rgba(255,255,255,.04);
    --np-overlay:radial-gradient(circle at 50% 30%, rgba(66,97,136,.28), rgba(0,0,0,.62) 70%);
    --np-icon:rgba(43,127,255,.16); --np-ok:#34d399; --np-info:#4f9dff; --np-warn:#f0a43a; --np-err:#ff6b6b;
    color-scheme:dark;
  }
  :root[data-theme="light"]{
    --dpa-bg:#f1f4f9; --dpa-surface:#fff; --dpa-surface-2:#f5f5f5;
    --dpa-text:#1b1b1b; --dpa-muted:#6b7280; --dpa-border:rgba(0,0,0,.09);
    --dpa-sb-bg:#fff; --dpa-hover:rgba(0,0,0,.045); --dpa-tile:rgba(0,0,0,.05);
    --dpa-active-bg:#1b1b1b; --dpa-active-text:#fff; --dpa-active-tile:rgba(255,255,255,.16);
    --dpa-logo-bg:#1b1b1b; --dpa-logo-fg:#fff; --dpa-logo-border:#1b1b1b;
    --dpa-glow-a:rgba(66,97,136,.22); --dpa-glow-b:rgba(43,127,255,.12);
    --dpa-switch:#426188; --dpa-scroll:rgba(0,0,0,.18);
    --dpa-mobile-bar:rgba(255,255,255,.85);
    /* notification popup — light */
    --np-bg:rgba(255,255,255,.97); --np-head:linear-gradient(180deg, rgba(66,97,136,.08), rgba(66,97,136,0));
    --np-item:rgba(0,0,0,.03); --np-item-hover:rgba(0,0,0,.06);
    --np-unread:rgba(43,127,255,.09); --np-shadow:0 40px 100px rgba(20,30,50,.28), 0 0 0 1px rgba(0,0,0,.04);
    --np-overlay:radial-gradient(circle at 50% 30%, rgba(66,97,136,.16), rgba(18,28,48,.42) 70%);
    --np-icon:rgba(43,127,255,.12); --np-ok:#168a4a; --np-info:#1f6fd1; --np-warn:#b45f06; --np-err:#c93434;
    color-scheme:light;
  }
  @media (max-width:900px), (max-width:1100px) and (max-height:520px){ :root{ --dpa-sidebar-w:0px; } }

  body{ background:var(--dpa-bg); color:var(--dpa-text); transition:background-color .35s ease, color .35s ease; }
  .dpa-sb i svg, .dpa-mobile-bar i svg{ width:1em; height:1em; fill:currentColor; stroke:none; }
  .dpa-sb i, .dpa-mobile-bar i{ font-style:normal; }

  /* ============ SIDEBAR SHELL ============ */
  .dpa-sb{
    position:fixed; top:0; left:0; bottom:0; width:var(--dpa-sidebar-w, 260px);
    height:100vh; height:100dvh; margin:0; padding:18px 14px 0;
    display:flex; flex-direction:column; overflow:hidden; z-index:1000;
    background:var(--dpa-sb-bg); color:var(--dpa-text);
    border-right:1px solid var(--dpa-border);
    font-family:'Inter', ui-sans-serif, system-ui, sans-serif; font-weight:500; font-size:14px; line-height:1.4;
    -webkit-font-smoothing:antialiased; box-sizing:border-box;
    transition:background-color .35s ease, border-color .35s ease, transform .38s cubic-bezier(.2,.8,.2,1);
  }
  .dpa-sb *{ box-sizing:border-box; }
  .dpa-sb::before, .dpa-sb::after{ content:""; position:absolute; border-radius:50%; filter:blur(46px); pointer-events:none; z-index:0; }
  .dpa-sb::before{ width:280px; height:280px; top:-120px; left:-100px; background:radial-gradient(circle, var(--dpa-glow-a), transparent 70%); animation:dpaFloat 14s ease-in-out infinite; }
  .dpa-sb::after{ width:260px; height:260px; bottom:-110px; right:-110px; background:radial-gradient(circle, var(--dpa-glow-b), transparent 70%); animation:dpaFloat 17s ease-in-out infinite reverse; }
  .dpa-sb > *{ position:relative; z-index:1; }
  @keyframes dpaFloat{ 0%,100%{ transform:translate(0,0) scale(1); } 50%{ transform:translate(14px,20px) scale(1.08); } }
  @keyframes dpaFade{ from{ opacity:0; } to{ opacity:1; } }
  @keyframes dpaNavIn{ to{ opacity:1; translate:0 0; } }

  /* ---- header ---- */
  .dpa-sb .dpa-sb-header{ display:flex; align-items:center; gap:12px; padding:6px 8px 18px; margin:0 0 6px; border-bottom:1px solid var(--dpa-border); animation:dpaFade .6s ease both; }
  .dpa-sb .dpa-sb-logo{
    width:44px; height:44px; flex-shrink:0; border-radius:12px; font-size:19px;
    display:flex; align-items:center; justify-content:center;
    background:var(--dpa-logo-bg); color:var(--dpa-logo-fg); border:1px solid var(--dpa-logo-border);
    animation:dpaLogoPulse 3.4s ease-in-out infinite;
  }
  @keyframes dpaLogoPulse{ 0%{ box-shadow:0 0 0 0 rgba(66,97,136,.55); } 70%,100%{ box-shadow:0 0 0 12px rgba(66,97,136,0); } }
  .dpa-sb .dpa-sb-title-container{ min-width:0; }
  .dpa-sb .dpa-sb-title-main{ font-size:16px; font-weight:700; letter-spacing:-.01em; line-height:1.15; white-space:nowrap; }
  .dpa-sb .dpa-sb-subtitle{ font-family:'Caveat', cursive; font-style:italic; font-weight:600; font-size:21px; line-height:1; color:var(--dpa-twilight); margin-top:2px; }

  /* ---- nav ---- */
  .dpa-sb .dpa-sb-nav{ flex:1; min-height:0; overflow-y:auto; overflow-x:hidden; padding:0 2px 12px; margin:0 -4px 0 -2px; scrollbar-width:thin; scrollbar-color:var(--dpa-scroll) transparent; }
  .dpa-sb .dpa-sb-nav::-webkit-scrollbar{ width:6px; }
  .dpa-sb .dpa-sb-nav::-webkit-scrollbar-thumb{ background:var(--dpa-scroll); border-radius:6px; }
  .dpa-sb .dpa-sb-title{
    display:flex; align-items:center; gap:10px; margin:0; padding:20px 10px 8px;
    font-size:11px; font-weight:600; letter-spacing:.16em; text-transform:uppercase; color:var(--dpa-muted);
    opacity:0; animation:dpaFade .5s ease forwards; animation-delay:calc(var(--i, 0) * 45ms + 120ms);
  }
  .dpa-sb .dpa-sb-title::after{ content:""; flex:1; height:1px; background:var(--dpa-border); }
  .dpa-sb .dpa-sb-nav a{
    position:relative; display:flex; align-items:center; gap:12px; margin:2px 0; padding:8px 10px;
    border-radius:11px; background:transparent; color:var(--dpa-muted);
    font-size:14px; font-weight:500; text-decoration:none;
    opacity:0; translate:-14px 0; animation:dpaNavIn .55s cubic-bezier(.2,.8,.2,1) forwards;
    animation-delay:calc(var(--i, 0) * 45ms + 120ms);
    transition:background-color .2s ease, color .2s ease, transform .22s ease;
  }
  .dpa-sb .dpa-sb-nav a i{
    width:34px; height:34px; flex-shrink:0; border-radius:9px; font-size:14px;
    display:inline-flex; align-items:center; justify-content:center;
    background:var(--dpa-tile); color:inherit;
    transition:background-color .2s ease, color .2s ease, transform .3s cubic-bezier(.34,1.56,.64,1);
  }
  .dpa-sb .dpa-sb-nav a span:not(.dpa-sb-badge){ flex:1; min-width:0; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  @media (hover:hover) and (pointer:fine){
    .dpa-sb .dpa-sb-nav a:hover{ background:var(--dpa-hover); color:var(--dpa-text); transform:translateX(4px); }
    .dpa-sb .dpa-sb-nav a:hover i{ background:var(--dpa-twilight); color:#fff; transform:rotate(-8deg) scale(1.1); }
    .dpa-sb .dpa-sb-nav a.dpa-sb-logout:hover{ background:rgba(214,69,69,.12); color:#ff6b6b; }
    .dpa-sb .dpa-sb-nav a.dpa-sb-logout:hover i{ background:var(--dpa-bad); color:#fff; }
  }
  .dpa-sb .dpa-sb-nav a:active{ background:var(--dpa-hover); transform:scale(.98); }
  .dpa-sb .dpa-sb-nav a.is-current{ background:var(--dpa-active-bg); color:var(--dpa-active-text); font-weight:600; }
  .dpa-sb .dpa-sb-nav a.is-current i{ background:var(--dpa-active-tile); color:var(--dpa-active-text); }
  .dpa-sb .dpa-sb-nav a.is-current::before{ content:""; position:absolute; left:-12px; top:22%; bottom:22%; width:4px; border-radius:0 4px 4px 0; background:var(--dpa-twilight); }

  /* ---- notification nav item ---- */
  .dpa-sb .dpa-sb-nav a.dpa-sb-notif i{
    background:linear-gradient(135deg, rgba(66,97,136,.35), rgba(43,127,255,.18));
    color:var(--dpa-text); border:1px solid var(--dpa-border);
  }
  .dpa-sb .dpa-sb-nav a.dpa-sb-notif i svg{ fill:none; stroke:currentColor; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
  .dpa-sb .dpa-sb-nav a.dpa-sb-notif.has-unread i{ border-color:rgba(214,69,69,.45); }
  .dpa-sb .dpa-sb-notif:hover i{ animation:dpaBell .8s ease; }
  @keyframes dpaBell{
    0%,100%{ transform:rotate(0) scale(1.1); } 20%{ transform:rotate(-18deg) scale(1.1); }
    40%{ transform:rotate(14deg) scale(1.1); } 60%{ transform:rotate(-9deg) scale(1.1); } 80%{ transform:rotate(5deg) scale(1.1); }
  }

  /* ---- notification badge ---- */
  .dpa-sb .dpa-sb-badge{
    margin-left:auto; flex:0 0 auto !important; min-width:22px; height:22px; padding:0 7px; border-radius:999px;
    display:inline-flex; align-items:center; justify-content:center;
    background:linear-gradient(135deg, #ff6b6b, var(--dpa-bad)); color:#fff;
    font-size:11px; font-weight:700; line-height:1; letter-spacing:.02em;
    box-shadow:0 4px 12px rgba(214,69,69,.4);
    animation:dpaBadge 2.2s ease-out infinite;
  }
  .dpa-sb .dpa-sb-badge:empty, .dpa-sb .dpa-sb-badge.is-zero{ display:none; }
  @keyframes dpaBadge{ 0%{ box-shadow:0 0 0 0 rgba(214,69,69,.6); } 70%,100%{ box-shadow:0 0 0 9px rgba(214,69,69,0); } }

  /* ---- footer: dark / light toggle ---- */
  .dpa-sb .dpa-sb-footer{ padding:12px 0 calc(16px + env(safe-area-inset-bottom, 0px)); border-top:1px solid var(--dpa-border); animation:dpaFade .6s .5s ease both; }
  .dpa-theme-toggle{
    width:100%; display:flex; align-items:center; justify-content:space-between; gap:10px;
    padding:10px 12px; background:var(--dpa-tile); color:var(--dpa-text);
    border:1px solid var(--dpa-border); border-radius:11px; cursor:pointer;
    font-family:inherit; font-size:13px; font-weight:600;
    transition:background-color .2s, transform .12s, border-color .2s;
  }
  .dpa-theme-toggle:hover{ background:var(--dpa-hover); border-color:var(--dpa-twilight); }
  .dpa-theme-toggle:active{ transform:scale(.98); }
  .dpa-theme-toggle:focus-visible, .dpa-menu-btn:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }
  .dpa-tt-label{ display:flex; align-items:center; gap:10px; }
  .dpa-tt-icons{ position:relative; width:18px; height:18px; display:inline-block; }
  .dpa-tt-icons i{ position:absolute; inset:0; display:flex; align-items:center; justify-content:center; font-size:15px; transition:transform .5s cubic-bezier(.34,1.56,.64,1), opacity .3s; }
  :root[data-theme="dark"]  .dpa-tt-sun{ opacity:0; transform:rotate(-90deg) scale(.3); }
  :root[data-theme="dark"]  .dpa-tt-moon{ opacity:1; transform:none; color:#c7d6ee; }
  :root[data-theme="light"] .dpa-tt-moon{ opacity:0; transform:rotate(90deg) scale(.3); }
  :root[data-theme="light"] .dpa-tt-sun{ opacity:1; transform:none; color:#e0a100; }
  .dpa-tt-switch{ width:40px; height:22px; border-radius:999px; position:relative; flex-shrink:0; background:var(--dpa-switch); transition:background-color .3s; }
  .dpa-tt-knob{ position:absolute; top:3px; left:3px; width:16px; height:16px; border-radius:50%; background:#fff; transition:transform .4s cubic-bezier(.34,1.56,.64,1); }
  :root[data-theme="light"] .dpa-tt-knob{ transform:translateX(18px); }

  /* ============ MOBILE: top bar + drawer ============ */
  .dpa-mobile-bar{
    display:none; position:fixed; top:0; left:0; right:0; z-index:998;
    height:calc(56px + env(safe-area-inset-top, 0px));
    padding:env(safe-area-inset-top, 0px) 14px 0 calc(14px + env(safe-area-inset-left, 0px));
    align-items:center; gap:12px; background:var(--dpa-mobile-bar);
    -webkit-backdrop-filter:blur(12px); backdrop-filter:blur(12px);
    border-bottom:1px solid var(--dpa-border); color:var(--dpa-text); font-family:'Inter', system-ui, sans-serif;
  }
  .dpa-menu-btn{ width:44px; height:44px; flex-shrink:0; border-radius:11px; border:1px solid var(--dpa-border); background:var(--dpa-tile); color:var(--dpa-text); cursor:pointer; font-size:17px; display:flex; align-items:center; justify-content:center; }
  .dpa-mobile-title{ min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; font-weight:700; font-size:15px; }
  .dpa-mobile-title em{ font-family:'Caveat', cursive; font-style:italic; font-weight:600; font-size:20px; color:var(--dpa-twilight); }
  .dpa-backdrop{ position:fixed; inset:0; z-index:999; background:rgba(0,0,0,.55); -webkit-backdrop-filter:blur(3px); backdrop-filter:blur(3px); opacity:0; pointer-events:none; transition:opacity .3s; }
  .dpa-backdrop.show{ opacity:1; pointer-events:auto; }
  html.dpa-lock, html.dpa-lock body{ overflow:hidden; }
  @media (max-width:900px), (max-width:1100px) and (max-height:520px){
    .dpa-mobile-bar{ display:flex; }
    .dpa-sb{
      width:min(300px, 86vw); transform:translateX(-104%); visibility:hidden;
      padding-top:calc(18px + env(safe-area-inset-top, 0px));
      transition:transform .38s cubic-bezier(.2,.8,.2,1), visibility 0s linear .38s, background-color .35s ease;
    }
    .dpa-sb.open{ transform:none; visibility:visible; box-shadow:0 0 70px rgba(0,0,0,.55); transition:transform .38s cubic-bezier(.2,.8,.2,1), visibility 0s; }
    body{ padding-top:calc(56px + env(safe-area-inset-top, 0px)); }
  }

  /* short laptop screens */
  @media (max-height:820px){
    .dpa-sb .dpa-sb-title{ padding:14px 10px 6px; }
    .dpa-sb .dpa-sb-nav a{ padding:6px 10px; margin:1px 0; }
    .dpa-sb .dpa-sb-header{ padding-bottom:14px; }
  }
  /* large monitors */
  @media (min-width:1700px){
    :root{ --dpa-sidebar-w:296px; }
    .dpa-sb{ padding:22px 16px 0; font-size:15px; }
    .dpa-sb .dpa-sb-logo{ width:50px; height:50px; font-size:22px; }
    .dpa-sb .dpa-sb-title-main{ font-size:18px; }
    .dpa-sb .dpa-sb-subtitle{ font-size:24px; }
    .dpa-sb .dpa-sb-nav a{ font-size:15.5px; padding:9px 12px; gap:14px; }
    .dpa-sb .dpa-sb-nav a i{ width:38px; height:38px; font-size:16px; }
  }
  @media print{ .dpa-sb, .dpa-mobile-bar, .dpa-backdrop{ display:none !important; } :root{ --dpa-sidebar-w:0px; } body{ padding-top:0 !important; } }

  /* =================================================================
     NOTIFICATION POPUP — dark theme = dark card, light theme = light card
     Layout / open-close behaviour stays in notification.css / notification.js
     ================================================================= */
  .notification-overlay{
    -webkit-backdrop-filter:blur(10px) saturate(120%); backdrop-filter:blur(10px) saturate(120%);
    background:var(--np-overlay);
  }
  .notification-popup{
    position:relative; overflow:hidden;
    background:var(--np-bg); color:var(--dpa-text);
    border:1px solid var(--dpa-border); border-radius:22px;
    box-shadow:var(--np-shadow);
    -webkit-backdrop-filter:blur(18px); backdrop-filter:blur(18px);
    font-family:'Inter', system-ui, sans-serif;
    animation:npPopIn .45s cubic-bezier(.2,.8,.2,1) both;
    transition:background-color .35s ease, border-color .35s ease, color .35s ease;
  }
  .notification-popup::before{            /* glowing top edge */
    content:""; position:absolute; top:0; left:10%; right:10%; height:1px; pointer-events:none;
    background:linear-gradient(90deg, transparent, var(--dpa-link), transparent); opacity:.8;
  }
  .notification-popup::after{             /* soft corner glow */
    content:""; position:absolute; top:-90px; right:-70px; width:220px; height:220px; border-radius:50%; pointer-events:none;
    background:radial-gradient(circle, var(--np-icon), transparent 70%); filter:blur(8px); opacity:.9;
  }
  .notification-popup > *{ position:relative; z-index:1; }
  @keyframes npPopIn{ from{ opacity:0; transform:translateY(26px) scale(.95); } to{ opacity:1; transform:none; } }
  @keyframes npItemIn{ from{ opacity:0; transform:translateY(12px) scale(.98); } to{ opacity:1; transform:none; } }
  @keyframes npSpin{ to{ transform:rotate(360deg); } }
  @keyframes npSway{ 0%,86%,100%{ transform:rotate(0); } 90%{ transform:rotate(-14deg); } 94%{ transform:rotate(11deg); } 97%{ transform:rotate(-6deg); } }
  @keyframes npBob{ 0%,100%{ transform:translateY(0); } 50%{ transform:translateY(-5px); } }

  .np-ico{ display:inline-flex; align-items:center; justify-content:center; }
  .np-ico svg{ width:1em; height:1em; fill:none; stroke:currentColor; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }

  /* header */
  .notification-popup-header{
    background:var(--np-head); border-bottom:1px solid var(--dpa-border);
    padding:18px 20px;
  }
  .notification-header-left{ display:flex; align-items:center; gap:14px; min-width:0; }
  .notification-header-icon{
    width:48px; height:48px; flex-shrink:0; border-radius:15px; font-size:20px;
    display:flex; align-items:center; justify-content:center;
    background:linear-gradient(135deg, var(--dpa-twilight), var(--dpa-link)); color:#fff;
    box-shadow:0 10px 24px rgba(43,127,255,.38);
    animation:npSway 4.5s ease-in-out infinite; transform-origin:50% 10%;
  }
  .notification-popup-header h2{ margin:0; color:var(--dpa-text); font-size:18px; font-weight:700; letter-spacing:-.015em; }
  .notification-popup-header p{ margin:3px 0 0; color:var(--dpa-muted); font-size:12.5px; font-weight:500; }

  /* action buttons */
  .notification-actions{ display:flex; align-items:center; gap:8px; }
  .notification-actions button{
    display:inline-flex; align-items:center; gap:7px;
    background:var(--dpa-tile); color:var(--dpa-text);
    border:1px solid var(--dpa-border); border-radius:999px; padding:8px 14px;
    font-family:inherit; font-size:12.5px; font-weight:600; cursor:pointer; line-height:1;
    transition:background-color .2s, color .2s, border-color .2s, transform .12s, box-shadow .2s;
  }
  .notification-actions button .np-ico{ font-size:14px; }
  .notification-actions button:hover{ background:var(--np-icon); border-color:var(--dpa-link); color:var(--dpa-link); box-shadow:0 6px 16px rgba(43,127,255,.18); }
  .notification-actions button:active{ transform:scale(.95); }
  .notification-actions button:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:2px; }
  .notification-actions #deleteAllBtn:hover{ border-color:var(--np-err); color:var(--np-err); background:color-mix(in srgb, var(--np-err) 12%, transparent); box-shadow:0 6px 16px rgba(214,69,69,.18); }
  .notification-actions #closeNotification{ width:36px; height:36px; padding:0; justify-content:center; border-radius:50%; font-size:16px; }
  .notification-actions #closeNotification:hover{ background:var(--dpa-bad); border-color:var(--dpa-bad); color:#fff; transform:rotate(90deg); box-shadow:0 6px 16px rgba(214,69,69,.35); }

  /* list */
  .notification-popup #notificationContainer{
    padding:14px; overflow-y:auto; scrollbar-width:thin; scrollbar-color:var(--dpa-scroll) transparent;
  }
  .notification-popup #notificationContainer::-webkit-scrollbar{ width:6px; }
  .notification-popup #notificationContainer::-webkit-scrollbar-thumb{ background:var(--dpa-scroll); border-radius:6px; }

  .notification-popup #notificationContainer .notification-item,
  .notification-popup #notificationContainer .notification-card{
    --nc:var(--np-info);
    position:relative; display:flex; align-items:flex-start; gap:13px;
    margin:0 0 10px; padding:14px 16px; border-radius:16px;
    background:var(--np-item); border:1px solid var(--dpa-border); color:var(--dpa-text);
    transition:background-color .2s, transform .22s cubic-bezier(.2,.8,.2,1), border-color .2s, box-shadow .2s;
    animation:npItemIn .45s cubic-bezier(.2,.8,.2,1) both;
  }
  .notification-popup #notificationContainer > :nth-child(1){ animation-delay:.04s; }
  .notification-popup #notificationContainer > :nth-child(2){ animation-delay:.09s; }
  .notification-popup #notificationContainer > :nth-child(3){ animation-delay:.14s; }
  .notification-popup #notificationContainer > :nth-child(4){ animation-delay:.19s; }
  .notification-popup #notificationContainer > :nth-child(5){ animation-delay:.24s; }
  .notification-popup #notificationContainer > :nth-child(n+6){ animation-delay:.28s; }
  .notification-popup #notificationContainer .notification-item:hover,
  .notification-popup #notificationContainer .notification-card:hover{
    background:var(--np-item-hover); transform:translateY(-2px);
    border-color:color-mix(in srgb, var(--nc) 45%, var(--dpa-border));
    box-shadow:0 12px 28px rgba(0,0,0,.18);
  }
  /* colour by type (works with class names or data-type) */
  .notification-popup #notificationContainer .success, .notification-popup #notificationContainer [data-type="success"]{ --nc:var(--np-ok); }
  .notification-popup #notificationContainer .warning, .notification-popup #notificationContainer [data-type="warning"]{ --nc:var(--np-warn); }
  .notification-popup #notificationContainer .error, .notification-popup #notificationContainer .danger, .notification-popup #notificationContainer [data-type="error"]{ --nc:var(--np-err); }

  .notification-popup #notificationContainer .unread,
  .notification-popup #notificationContainer .is-unread{ background:var(--np-unread); border-color:color-mix(in srgb, var(--dpa-link) 35%, var(--dpa-border)); }
  .notification-popup #notificationContainer .unread::before,
  .notification-popup #notificationContainer .is-unread::before{
    content:""; position:absolute; top:16px; right:14px; width:9px; height:9px; border-radius:50%;
    background:var(--dpa-link); box-shadow:0 0 0 4px color-mix(in srgb, var(--dpa-link) 22%, transparent);
  }
  .notification-popup #notificationContainer .notification-item > i:first-child,
  .notification-popup #notificationContainer .notification-icon{
    width:40px; height:40px; flex-shrink:0; border-radius:12px; font-size:16px;
    display:inline-flex; align-items:center; justify-content:center;
    background:color-mix(in srgb, var(--nc) 16%, transparent); color:var(--nc);
    transition:transform .3s cubic-bezier(.34,1.56,.64,1), background-color .2s, color .2s;
  }
  .notification-popup #notificationContainer .notification-item:hover > i:first-child,
  .notification-popup #notificationContainer .notification-item:hover .notification-icon{ transform:rotate(-8deg) scale(1.08); background:var(--nc); color:#fff; }
  .notification-popup #notificationContainer h4,
  .notification-popup #notificationContainer .notification-title{ margin:0 0 3px; font-size:14px; font-weight:650; color:var(--dpa-text); padding-right:18px; }
  .notification-popup #notificationContainer .notification-item p,
  .notification-popup #notificationContainer .notification-message{ margin:0; font-size:13px; line-height:1.5; color:var(--dpa-muted); }
  .notification-popup #notificationContainer .notification-time,
  .notification-popup #notificationContainer .notification-item small{ display:block; margin-top:7px; font-size:11.5px; font-weight:600; color:var(--dpa-muted); opacity:.85; }
  .notification-popup #notificationContainer .notification-item button{
    background:transparent; border:1px solid var(--dpa-border); color:var(--dpa-muted); border-radius:9px;
    padding:5px 9px; font:600 11.5px 'Inter', sans-serif; cursor:pointer; transition:background-color .2s, color .2s, border-color .2s;
  }
  .notification-popup #notificationContainer .notification-item button:hover{ background:var(--np-icon); color:var(--dpa-link); border-color:var(--dpa-link); }

  /* empty / loading */
  .notification-empty{
    display:flex; flex-direction:column; align-items:center; justify-content:center; gap:12px;
    padding:52px 20px; text-align:center; color:var(--dpa-muted);
  }
  .notification-empty i{ font-size:36px; color:var(--dpa-twilight); opacity:.9; animation:npBob 3.4s ease-in-out infinite; }
  .notification-empty p{ margin:0; font-size:13.5px; font-weight:600; }
  .np-spinner{ width:30px; height:30px; border-radius:50%; border:3px solid var(--dpa-border); border-top-color:var(--dpa-link); animation:npSpin .8s linear infinite; }

  /* footer */
  .notification-footer{
    background:var(--np-head); border-top:1px solid var(--dpa-border); color:var(--dpa-muted);
    padding:14px 20px; font-size:12.5px; font-weight:500;
  }
  .notification-footer strong{ color:var(--dpa-text); font-weight:700; padding:1px 8px; border-radius:999px; background:var(--np-icon); }
  .notification-footer .view-all-link{
    display:inline-flex; align-items:center; gap:7px; color:var(--dpa-link); font-weight:600; text-decoration:none;
    transition:opacity .2s, transform .2s;
  }
  .notification-footer .view-all-link .np-ico{ transition:transform .5s ease; }
  .notification-footer .view-all-link:hover{ opacity:.85; transform:translateX(3px); }
  .notification-footer .view-all-link:hover .np-ico{ transform:rotate(180deg); }

  /* =================================================================
     GLOBAL TOAST — same theme rules
     ================================================================= */
  .global-toast{
    background:var(--np-bg); color:var(--dpa-text);
    border:1px solid var(--dpa-border); border-left:4px solid var(--dpa-link);
    border-radius:16px; box-shadow:var(--np-shadow);
    -webkit-backdrop-filter:blur(14px); backdrop-filter:blur(14px);
    font-family:'Inter', system-ui, sans-serif;
  }
  .global-toast .toast-left{ color:var(--dpa-link); font-size:20px; }
  .global-toast .toast-title{ font-size:14px; font-weight:700; color:var(--dpa-text); }
  .global-toast .toast-message{ font-size:12.5px; color:var(--dpa-muted); }
  .global-toast.success{ border-left-color:var(--dpa-good); } .global-toast.success .toast-left{ color:var(--dpa-good); }
  .global-toast.error{ border-left-color:var(--dpa-bad); }   .global-toast.error .toast-left{ color:var(--dpa-bad); }
  .global-toast.warning{ border-left-color:var(--dpa-warn); } .global-toast.warning .toast-left{ color:var(--dpa-warn); }
  .global-toast #toastClose{
    background:transparent; border:0; color:var(--dpa-muted); cursor:pointer;
    width:30px; height:30px; border-radius:50%; display:inline-flex; align-items:center; justify-content:center; font-size:14px;
    transition:background-color .2s, color .2s, transform .2s;
  }
  .global-toast #toastClose:hover{ background:var(--dpa-hover); color:var(--dpa-text); transform:rotate(90deg); }

  /* ---- mobile popup ---- */
  @media (max-width:600px){
    .notification-overlay{ padding:12px; }
    .notification-popup{ width:100%; max-width:100%; max-height:calc(100vh - 24px); max-height:calc(100dvh - 24px); border-radius:18px; }
    .notification-popup-header{ flex-wrap:wrap; gap:12px; padding:16px; }
    .notification-actions{ flex-wrap:wrap; }
    .notification-footer{ flex-wrap:wrap; gap:8px; padding:12px 16px; }
  }

  /* =================================================================
     REDUCED MOTION
     ================================================================= */
  @media (prefers-reduced-motion: reduce){
    .dpa-sb::before, .dpa-sb::after, .dpa-sb .dpa-sb-logo, .dpa-sb .dpa-sb-badge,
    .notification-popup, .notification-header-icon, .notification-empty i, .np-spinner,
    .notification-popup #notificationContainer > *{ animation:none !important; }
    .dpa-sb .dpa-sb-nav a, .dpa-sb .dpa-sb-title, .dpa-sb .dpa-sb-header, .dpa-sb .dpa-sb-footer{
      animation:none !important; opacity:1 !important; translate:0 0 !important;
    }
  }
</style>

<!-- ============ MOBILE TOP BAR ============ -->
<div class="dpa-mobile-bar">
  <button type="button" class="dpa-menu-btn" id="dpaMenuBtn" aria-label="Open menu" aria-expanded="false">
    <i><svg viewBox="0 0 448 512" aria-hidden="true"><path d="M0 96C0 78.3 14.3 64 32 64l384 0c17.7 0 32 14.3 32 32s-14.3 32-32 32L32 128C14.3 128 0 113.7 0 96zM0 256c0-17.7 14.3-32 32-32l384 0c17.7 0 32 14.3 32 32s-14.3 32-32 32L32 288c-17.7 0-32-14.3-32-32zM448 416c0 17.7-14.3 32-32 32L32 448c-17.7 0-32-14.3-32-32s14.3-32 32-32l384 0c17.7 0 32 14.3 32 32z"/></svg></i>
  </button>
  <div class="dpa-mobile-title">Digital Purohit <em>Assistant</em></div>
</div>
<div class="dpa-backdrop" id="dpaBackdrop"></div>

<!-- ============ SIDEBAR ============ -->
<aside class="dpa-sb" id="dpaSidebar">

  <div class="dpa-sb-header">
    <div class="dpa-sb-logo">
      <i><svg viewBox="0 0 512 512" aria-hidden="true"><path d="M160 79l0 81-44.8 33.6C103.1 202.7 96 216.9 96 232l0 40-60.6 30.3C13.7 313.2 0 335.3 0 359.6L0 448c0 35.3 28.7 64 64 64 74.7 0 85.4 0 320 0l64 0c35.3 0 64-28.7 64-64l0-88.4c0-24.2-13.7-46.4-35.4-57.2L416 272 416 232c0-15.1-7.1-29.3-19.2-38.4L352 160 352 79c0-9.5-4.2-18.5-11.5-24.6L271.4-3.2c-8.9-7.4-21.8-7.4-30.7 0L171.5 54.4C164.2 60.5 160 69.5 160 79zm96 241c35.3 0 64 28.7 64 64l0 80-128 0 0-80c0-35.3 28.7-64 64-64z"/></svg></i>
    </div>
    <div class="dpa-sb-title-container">
      <div class="dpa-sb-title-main">Digital Purohit</div>
      <div class="dpa-sb-subtitle">Assistant</div>
    </div>
  </div>

  <nav class="dpa-sb-nav">

    <div class="dpa-sb-title" style="--i:0">Main Menu</div>

    <!-- Notifications -->
    <a href="javascript:void(0);"
       class="dpa-sb-notif"
       style="--i:1"
       onclick="openNotifications(); return false;"
       aria-label="Open notifications">

      <i>
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/>
          <path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/>
        </svg>
      </i>

      <span>Notifications</span>

      <span class="dpa-sb-badge" id="notificationCount">${empty unreadCount ? 0 : unreadCount}</span>
    </a>

    <a href="${pageContext.request.contextPath}/dashboard" style="--i:2">
      <i><svg viewBox="0 0 512 512" aria-hidden="true"><path d="M277.8 8.6c-12.3-11.4-31.3-11.4-43.5 0l-224 208c-9.6 9-12.8 22.9-8 35.1S18.8 272 32 272l16 0 0 176c0 35.3 28.7 64 64 64l288 0c35.3 0 64-28.7 64-64l0-176 16 0c13.2 0 25-8.1 29.8-20.3s1.6-26.2-8-35.1l-224-208zM240 320l32 0c26.5 0 48 21.5 48 48l0 96-128 0 0-96c0-26.5 21.5-48 48-48z"/></svg></i>
      <span>Dashboard</span>
    </a>

    <div class="dpa-sb-title" style="--i:3">Management</div>

    <a href="${pageContext.request.contextPath}/customers" style="--i:4">
      <i><svg viewBox="0 0 640 512" aria-hidden="true"><path d="M320 16a104 104 0 1 1 0 208 104 104 0 1 1 0-208zM96 88a72 72 0 1 1 0 144 72 72 0 1 1 0-144zM0 416c0-70.7 57.3-128 128-128 12.8 0 25.2 1.9 36.9 5.4-32.9 36.8-52.9 85.4-52.9 138.6l0 16c0 11.4 2.4 22.2 6.7 32L32 480c-17.7 0-32-14.3-32-32l0-32zm521.3 64c4.3-9.8 6.7-20.6 6.7-32l0-16c0-53.2-20-101.8-52.9-138.6 11.7-3.5 24.1-5.4 36.9-5.4 70.7 0 128 57.3 128 128l0 32c0 17.7-14.3 32-32 32l-86.7 0zM472 160a72 72 0 1 1 144 0 72 72 0 1 1 -144 0zM160 432c0-88.4 71.6-160 160-160s160 71.6 160 160l0 16c0 17.7-14.3 32-32 32l-256 0c-17.7 0-32-14.3-32-32l0-16z"/></svg></i>
      <span>Customers</span>
    </a>

    <a href="${pageContext.request.contextPath}/events" style="--i:5">
      <i><svg viewBox="0 0 448 512" aria-hidden="true"><path d="M128 0c17.7 0 32 14.3 32 32l0 32 128 0 0-32c0-17.7 14.3-32 32-32s32 14.3 32 32l0 32 32 0c35.3 0 64 28.7 64 64l0 288c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 128C0 92.7 28.7 64 64 64l32 0 0-32c0-17.7 14.3-32 32-32zM64 240l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16zm128 0l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16zm144-16c-8.8 0-16 7.2-16 16l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0zM64 368l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16zm144-16c-8.8 0-16 7.2-16 16l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0zm112 16l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16z"/></svg></i>
      <span>Events</span>
    </a>

    <a href="${pageContext.request.contextPath}/bulk-dashboard" style="--i:6">
      <i><svg viewBox="0 0 576 512" aria-hidden="true"><path d="M302.3-12.6c-9-4.5-19.6-4.5-28.6 0l-256 128C1.9 123.3-4.5 142.5 3.4 158.3s27.1 22.2 42.9 14.3L288 51.8 529.7 172.6c15.8 7.9 35 1.5 42.9-14.3s1.5-35-14.3-42.9l-256-128zM288 272a56 56 0 1 0 0-112 56 56 0 1 0 0 112zm0 48c-53 0-96 43-96 96l0 32c0 17.7 14.3 32 32 32l128 0c17.7 0 32-14.3 32-32l0-32c0-53-43-96-96-96zM160 256a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zm352 0a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zM112 336c-44.2 0-80 35.8-80 80l0 33.1c0 17 13.8 30.9 30.9 30.9l87.8 0c-4.3-9.8-6.7-20.6-6.7-32l0-48c0-18.4 3.5-36 9.8-52.2-12.2-7.5-26.5-11.8-41.8-11.8zM425.4 480l87.8 0c17 0 30.9-13.8 30.9-30.9l0-33.1c0-44.2-35.8-80-80-80-15.3 0-29.6 4.3-41.8 11.8 6.3 16.2 9.8 33.8 9.8 52.2l0 48c0 11.4-2.4 22.2-6.7 32z"/></svg></i>
      <span>Bulk Events</span>
    </a>

    <a href="${pageContext.request.contextPath}/pending-payments" style="--i:7">
      <i><svg viewBox="0 0 512 512" aria-hidden="true"><path d="M0 419.6L0 109.5c0-23.2 24.1-38.6 46.3-32 87.7 26.2 149.7 5.5 212.1-15.3 64.5-21.5 129.4-43.1 223.3-13.1 18.5 5.9 30.3 23.8 30.3 43.3l0 310.1c0 23.2-24.1 38.6-46.2 32-87.7-26.2-149.8-5.5-212.1 15.3-64.5 21.5-129.4 43.1-223.3 13.1-18.5-5.9-30.3-23.8-30.3-43.3zM336 256c0-53-35.8-96-80-96s-80 43-80 96 35.8 96 80 96 80-43 80-96zM120 413.6c4.4 0 7.9-3.8 7.2-8.1-4.6-27.8-27-49.5-55.2-53-4.4-.5-8 3.1-8 7.5l0 39.9c0 3.6 2.4 6.8 6 7.7 17.9 4.2 34.3 6.1 50 6.1zm318.5-51.1c5 .8 9.5-3 9.5-8l0-42.6c0-4.4-3.6-8.1-8-7.5-25.2 3.1-45.9 20.9-53.2 44.6-1.4 4.7 2.3 9.1 7.2 9.2 14.2 .4 29 1.7 44.4 4.3zM448 152l0-39.9c0-3.6-2.5-6.8-6-7.7-17.9-4.2-34.3-6.1-50-6.1-4.4 0-7.9 3.8-7.2 8.1 4.6 27.8 27 49.5 55.2 53 4.4 .5 8-3.1 8-7.5zM125.2 162.9c1.4-4.7-2.3-9.1-7.2-9.2-14.2-.4-29-1.7-44.4-4.3-5-.8-9.5 3-9.5 8L64 200c0 4.4 3.6 8.1 8 7.5 25.2-3.1 45.9-20.9 53.2-44.6z"/></svg></i>
      <span>Pending Payments</span>
    </a>

    <a href="${pageContext.request.contextPath}/calendar" style="--i:8">
      <i><svg viewBox="0 0 448 512" aria-hidden="true"><path d="M128 0c17.7 0 32 14.3 32 32l0 32 128 0 0-32c0-17.7 14.3-32 32-32s32 14.3 32 32l0 32 32 0c35.3 0 64 28.7 64 64l0 288c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 128C0 92.7 28.7 64 64 64l32 0 0-32c0-17.7 14.3-32 32-32zM64 240l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16zm128 0l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16zm144-16c-8.8 0-16 7.2-16 16l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0zM64 368l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16zm144-16c-8.8 0-16 7.2-16 16l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0zm112 16l0 32c0 8.8 7.2 16 16 16l32 0c8.8 0 16-7.2 16-16l0-32c0-8.8-7.2-16-16-16l-32 0c-8.8 0-16 7.2-16 16z"/></svg></i>
      <span>Calendar</span>
    </a>

    <a href="${pageContext.request.contextPath}/reports" style="--i:9">
      <i><svg viewBox="0 0 512 512" aria-hidden="true"><path d="M64 64c0-17.7-14.3-32-32-32S0 46.3 0 64L0 400c0 44.2 35.8 80 80 80l400 0c17.7 0 32-14.3 32-32s-14.3-32-32-32L80 416c-8.8 0-16-7.2-16-16L64 64zm406.6 86.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L320 210.7 262.6 153.4c-12.5-12.5-32.8-12.5-45.3 0l-96 96c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0l73.4-73.4 57.4 57.4c12.5 12.5 32.8 12.5 45.3 0l128-128z"/></svg></i>
      <span>Reports</span>
    </a>

    <div class="dpa-sb-title" style="--i:10">Account</div>

    <a href="${pageContext.request.contextPath}/profile" style="--i:11">
      <i><svg viewBox="0 0 448 512" aria-hidden="true"><path d="M224 248a120 120 0 1 0 0-240 120 120 0 1 0 0 240zm-29.7 56C95.8 304 16 383.8 16 482.3 16 498.7 29.3 512 45.7 512l356.6 0c16.4 0 29.7-13.3 29.7-29.7 0-98.5-79.8-178.3-178.3-178.3l-59.4 0z"/></svg></i>
      <span>Profile</span>
    </a>

    <a href="${pageContext.request.contextPath}/logout" class="dpa-sb-logout" style="--i:12">
      <i><svg viewBox="0 0 512 512" aria-hidden="true"><path d="M505 273c9.4-9.4 9.4-24.6 0-33.9L361 95c-6.9-6.9-17.2-8.9-26.2-5.2S320 102.3 320 112l0 80-112 0c-26.5 0-48 21.5-48 48l0 32c0 26.5 21.5 48 48 48l112 0 0 80c0 9.7 5.8 18.5 14.8 22.2s19.3 1.7 26.2-5.2L505 273zM160 96c17.7 0 32-14.3 32-32s-14.3-32-32-32L96 32C43 32 0 75 0 128L0 384c0 53 43 96 96 96l64 0c17.7 0 32-14.3 32-32s-14.3-32-32-32l-64 0c-17.7 0-32-14.3-32-32l0-256c0-17.7 14.3-32 32-32l64 0z"/></svg></i>
      <span>Logout</span>
    </a>

  </nav>

  <div class="dpa-sb-footer">
    <button type="button" class="dpa-theme-toggle" id="dpaThemeToggle" aria-label="Toggle dark / light mode">
      <span class="dpa-tt-label">
        <span class="dpa-tt-icons">
          <i class="dpa-tt-moon"><svg viewBox="0 0 512 512" aria-hidden="true"><path d="M256 0C114.6 0 0 114.6 0 256S114.6 512 256 512c68.8 0 131.3-27.2 177.3-71.4 7.3-7 9.4-17.9 5.3-27.1s-13.7-14.9-23.8-14.1c-4.9 .4-9.8 .6-14.8 .6-101.6 0-184-82.4-184-184 0-72.1 41.5-134.6 102.1-164.8 9.1-4.5 14.3-14.3 13.1-24.4S322.6 8.5 312.7 6.3C294.4 2.2 275.4 0 256 0z"/></svg></i>
          <i class="dpa-tt-sun"><svg viewBox="0 0 576 512" aria-hidden="true"><path d="M288-32c8.4 0 16.3 4.4 20.6 11.7L364.1 72.3 468.9 46c8.2-2 16.9 .4 22.8 6.3S500 67 498 75.1l-26.3 104.7 92.7 55.5c7.2 4.3 11.7 12.2 11.7 20.6s-4.4 16.3-11.7 20.6L471.7 332.1 498 436.8c2 8.2-.4 16.9-6.3 22.8S477 468 468.9 466l-104.7-26.3-55.5 92.7c-4.3 7.2-12.2 11.7-20.6 11.7s-16.3-4.4-20.6-11.7L211.9 439.7 107.2 466c-8.2 2-16.8-.4-22.8-6.3S76 445 78 436.8l26.2-104.7-92.6-55.5C4.4 272.2 0 264.4 0 256s4.4-16.3 11.7-20.6L104.3 179.9 78 75.1c-2-8.2 .3-16.8 6.3-22.8S99 44 107.2 46l104.7 26.2 55.5-92.6 1.8-2.6c4.5-5.7 11.4-9.1 18.8-9.1zm0 144a144 144 0 1 0 0 288 144 144 0 1 0 0-288zm0 240a96 96 0 1 1 0-192 96 96 0 1 1 0 192z"/></svg></i>
        </span>
        <span id="dpaThemeLabel">Dark mode</span>
      </span>
      <span class="dpa-tt-switch"><span class="dpa-tt-knob"></span></span>
    </button>
  </div>

</aside>

<!-- Shared notification popup: available on every page importing sidebar.jsp -->
<div id="notificationOverlay" class="notification-overlay" aria-hidden="true">
  <section class="notification-popup" role="dialog" aria-modal="true"
           aria-labelledby="notificationPopupTitle">
    <header class="notification-popup-header">
      <div class="notification-header-left">
        <div class="notification-header-icon" aria-hidden="true">
          <span class="np-ico"><svg viewBox="0 0 24 24"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg></span>
        </div>
        <div>
          <h2 id="notificationPopupTitle">Notifications</h2>
          <p>Stay updated with recent activities</p>
        </div>
      </div>
      <div class="notification-actions">
        <button type="button" id="markAllRead">
          <span class="np-ico" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M18 6 7 17l-5-5"/><path d="m22 10-7.5 7.5L13 16"/></svg></span> Mark All Read
        </button>
        <button type="button" id="deleteAllBtn">
          <span class="np-ico" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg></span> Delete All
        </button>
        <button type="button" id="closeNotification" aria-label="Close notifications">
          <span class="np-ico" aria-hidden="true"><svg viewBox="0 0 24 24" style="stroke-width:2.4"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></span>
        </button>
      </div>
    </header>

    <div id="notificationContainer" aria-live="polite">
      <div class="notification-empty">
        <div class="np-spinner" aria-hidden="true"></div>
        <p>Loading notifications...</p>
      </div>
    </div>

    <footer class="notification-footer">
      <div class="notification-total">
        Total Notifications: <strong id="totalNotifications">0</strong>
      </div>
      <a href="javascript:void(0);" class="view-all-link"
         onclick="loadNotifications(); return false;">
        <span class="np-ico" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/><path d="M21 3v5h-5"/><path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"/><path d="M8 16H3v5"/></svg></span>
        Refresh Notifications
      </a>
    </footer>
  </section>
</div>

<div id="globalToast" class="global-toast" role="status" aria-live="polite">
  <div class="toast-left"><i id="toastIcon"></i></div>
  <div class="toast-body">
    <div id="toastTitle" class="toast-title"></div>
    <div id="toastMessage" class="toast-message"></div>
  </div>
  <button type="button" id="toastClose" aria-label="Close message"><span class="np-ico" aria-hidden="true"><svg viewBox="0 0 24 24" style="stroke-width:2.4"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></span></button>
</div>
<script>
(function () {

    // Detect when browser restores a page from history cache
    window.addEventListener("pageshow", function (event) {

        if (event.persisted) {

            // Force a fresh request to the server
            window.location.reload();

        }

    });

})();
</script>

<script>
(function () {
  var root = document.documentElement;
  var sidebar = document.getElementById('dpaSidebar');
  var backdrop = document.getElementById('dpaBackdrop');
  var menuBtn = document.getElementById('dpaMenuBtn');
  var toggle = document.getElementById('dpaThemeToggle');
  var label = document.getElementById('dpaThemeLabel');
  var notifLink = document.querySelector('#dpaSidebar .dpa-sb-notif');

  /* ---- dark / light toggle ---- */
  function syncLabel() { label.textContent = root.getAttribute('data-theme') === 'light' ? 'Light mode' : 'Dark mode'; }
  function setTheme(t) {
    root.setAttribute('data-theme', t);
    try { localStorage.setItem('dpa-theme', t); } catch (e) {}
    syncLabel();
  }
  syncLabel();
  toggle.addEventListener('click', function () {
    setTheme(root.getAttribute('data-theme') === 'light' ? 'dark' : 'light');
  });

  /* ---- mobile drawer ---- */
  function setDrawer(open) {
    sidebar.classList.toggle('open', open);
    backdrop.classList.toggle('show', open);
    root.classList.toggle('dpa-lock', open);
    menuBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
  }
  menuBtn.addEventListener('click', function () { setDrawer(!sidebar.classList.contains('open')); });
  backdrop.addEventListener('click', function () { setDrawer(false); });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') setDrawer(false); });

  /* ---- notification badge: call window.setNotifBadge(n) from your notification code ---- */
  window.setNotifBadge = function (n) {
    var b = document.getElementById('notificationCount');
    if (!b) return;
    n = parseInt(n, 10) || 0;
    b.textContent = n > 0 ? (n > 99 ? '99+' : n) : '';
    b.classList.toggle('is-zero', !(n > 0));
    if (notifLink) notifLink.classList.toggle('has-unread', n > 0);
  };

  /* initial badge state from server-rendered count */
  (function () {
    var b = document.getElementById('notificationCount');
    if (!b) return;
    var n = parseInt((b.textContent || '').trim(), 10) || 0;
    window.setNotifBadge(n);
  })();

  /* ---- highlight the current page ---- */
  var path = location.pathname.replace(/\/$/, '');
  document.querySelectorAll('#dpaSidebar .dpa-sb-nav a[href]').forEach(function (a) {
    var p;
    if (a.getAttribute('href').indexOf('javascript') === 0) return;
    try { p = new URL(a.href, location.origin).pathname.replace(/\/$/, ''); } catch (e) { return; }
    if (p && p === path) a.classList.add('is-current');
  });
})();
</script>

<!-- Notification behaviour is shared across all pages that include this sidebar. -->
<script src="${pageContext.request.contextPath}/assets/js/notification.js" defer></script>
