<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Event | Digital Purohit Assistant</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Anton&family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<style>
html, body{ margin:0; }
body{ font-family:'Inter', system-ui, sans-serif; }
i svg{ width:1em; height:1em; fill:none; stroke:currentColor; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
</style>
<script>document.documentElement.classList.add('dpa-js');</script>
<style>
:root{ --dpa-sidebar-w:260px; --dpa-twilight:#426188; --dpa-link:#2b7fff; }
:root,:root[data-theme="dark"]{ --dpa-bg:#050608; --dpa-surface:#10141c; --dpa-surface-2:#161b26; --dpa-text:#f5f5f5; --dpa-muted:rgba(255,255,255,.58); --dpa-border:rgba(255,255,255,.09); --dpa-sb-bg:#080a0f; --dpa-hover:rgba(255,255,255,.06); --dpa-tile:rgba(255,255,255,.07); color-scheme:dark; }
:root[data-theme="light"]{ --dpa-bg:#f1f4f9; --dpa-surface:#fff; --dpa-surface-2:#f5f5f5; --dpa-text:#1b1b1b; --dpa-muted:#6b7280; --dpa-border:rgba(0,0,0,.09); --dpa-sb-bg:#fff; --dpa-hover:rgba(0,0,0,.045); --dpa-tile:rgba(0,0,0,.05); color-scheme:light; }
@media (max-width:900px){ :root{ --dpa-sidebar-w:0px; } }
body{ background:var(--dpa-bg); color:var(--dpa-text); transition:background-color .35s,color .35s; }
</style>
<style>
/* =====================================================================
   ADD / EDIT EVENT — same design system as the Events dashboard
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
	max-width:96em; margin:0 auto;
	display:flex; flex-direction:column; gap:1.5em;
	font-family:'Inter', ui-sans-serif, system-ui, sans-serif;
	font-size:calc(14px * var(--dk)); font-weight:500; line-height:1.45;
	color:var(--dpa-text);
	-webkit-font-smoothing:antialiased;
}
:root[data-theme="light"] .dpa-dash{ --good:#168a4a; --pend:#b45f06; --bad2:#c93434; }
.dpa-dash, .dpa-dash *{ box-sizing:border-box; }
.dpa-dash h1, .dpa-dash h2, .dpa-dash h3, .dpa-dash p{ margin:0; }
@media (min-width:1700px){ .dpa-dash{ --dk:1.14; } }
@media (min-width:2400px){ .dpa-dash{ --dk:1.4; } }
@media (min-width:3200px){ .dpa-dash{ --dk:1.78; } }

/* ---------- animations ---------- */
@keyframes dpaRise{ from{ opacity:0; translate:0 22px; } to{ opacity:1; translate:0 0; } }
@keyframes dpaFloat2{ 0%,100%{ transform:translate(0,0) scale(1); } 50%{ transform:translate(-26px,30px) scale(1.08); } }
@keyframes dpaDrift{ from{ transform:translateX(0); } to{ transform:translateX(-50%); } }
@keyframes dpaRing{ 0%{ box-shadow:0 0 0 0 rgba(255,255,255,.35); } 70%,100%{ box-shadow:0 0 0 14px rgba(255,255,255,0); } }
@keyframes dpaSpin{ to{ transform:rotate(360deg); } }
@keyframes dpaBlink{ 0%,100%{ opacity:1; } 50%{ opacity:.35; } }
@keyframes fmPop{ from{ opacity:0; transform:translateY(8px) scale(.97); } to{ opacity:1; transform:none; } }
@keyframes fmOut{ to{ opacity:0; transform:translateX(18px); } }
@keyframes fmShake{ 20%,60%{ transform:translateX(-4px); } 40%,80%{ transform:translateX(4px); } }
@keyframes fmShimmer{ from{ background-position:-200% 0; } to{ background-position:200% 0; } }
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

/* ---------- layout + section cards ---------- */
.dpa-dash .fm-grid{ display:grid; grid-template-columns:minmax(0, 1.65fr) minmax(0, 1fr); gap:1.1em; align-items:start; }
.dpa-dash .fm-col{ display:flex; flex-direction:column; gap:1.1em; min-width:0; }
.dpa-dash .fm-side{ position:sticky; top:1.2em; }
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
.dpa-dash .st-left{ display:flex; align-items:center; gap:.9em; min-width:0; }
.dpa-dash .st-left > i{
	flex-shrink:0; width:2.5em; height:2.5em; border-radius:.75em;
	display:inline-flex; align-items:center; justify-content:center; background:var(--dpa-tile);
	transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .25s, color .25s;
}
.dpa-dash .section-card:hover .st-left > i{ background:var(--dpa-twilight); color:#fff; transform:rotate(-8deg) scale(1.08); }
.dpa-dash .section-top h2{ font-size:1.12em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .section-top p{ margin-top:.2em; font-size:.85em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .tag{
	padding:.3em .85em; border-radius:999px; font-size:.78em; font-weight:700; letter-spacing:.04em;
	border:1px solid var(--dpa-border); color:var(--dpa-muted); white-space:nowrap;
}
.dpa-dash .fm-body{ padding:1.4em 1.5em 1.5em; }
.dpa-dash .req{ color:var(--bad2); }

/* ---------- fields ---------- */
.dpa-dash .form-grid{ display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:1.1em; }
.dpa-dash .form-grid .full{ grid-column:1 / -1; }
.dpa-dash .field label{ display:block; margin-bottom:.5em; font-size:.85em; font-weight:600; color:var(--dpa-muted); }
.dpa-dash .field-box{
	position:relative; display:flex; align-items:center; gap:.7em; padding:0 1em;
	border-radius:.75em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:border-color .2s, box-shadow .2s;
}
.dpa-dash .field-box.area{ align-items:flex-start; padding-top:.2em; }
.dpa-dash .field-box:focus-within{ border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.2); }
.dpa-dash .field-box:has(:user-invalid){ border-color:var(--bad2); }
.dpa-dash .field-box > i, .dpa-dash .field-box .cur{ color:var(--dpa-muted); font-weight:700; flex-shrink:0; transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .field-box.area > i{ margin-top:.95em; }
.dpa-dash .field-box:focus-within > i, .dpa-dash .field-box:focus-within .cur{ color:var(--dpa-link); transform:scale(1.12); }
.dpa-dash .field-box input, .dpa-dash .field-box select, .dpa-dash .field-box textarea{
	flex:1; min-width:0; width:100%; margin:0; padding:.9em 0; border:0; outline:0; box-shadow:none; background:transparent;
	font-family:inherit; font-size:1em; font-weight:500; color:var(--dpa-text);
}
.dpa-dash .field-box textarea{ min-height:7em; resize:vertical; line-height:1.5; }
.dpa-dash .field-box input::placeholder, .dpa-dash .field-box textarea::placeholder{ color:var(--dpa-muted); opacity:.8; font-weight:400; }
.dpa-dash .field-box input[readonly]{ cursor:default; font-weight:700; }
.dpa-dash .field-box select{ appearance:none; -webkit-appearance:none; cursor:pointer; padding-right:1.6em; }
.dpa-dash .field-box select option{ background:var(--dpa-surface); color:var(--dpa-text); }
.dpa-dash .field-box:has(select)::after{
	content:""; position:absolute; right:1em; top:50%; width:.5em; height:.5em; margin-top:-.4em;
	border-right:2px solid var(--dpa-muted); border-bottom:2px solid var(--dpa-muted); transform:rotate(45deg); pointer-events:none;
}
.dpa-dash .field-box input[type="date"], .dpa-dash .field-box input[type="time"]{ cursor:pointer; }
/* no spinner arrows: the mouse wheel / arrows can never change an amount */
.dpa-dash input[type="number"]{ -moz-appearance:textfield; appearance:textfield; }
.dpa-dash input[type="number"]::-webkit-outer-spin-button, .dpa-dash input[type="number"]::-webkit-inner-spin-button{ -webkit-appearance:none; margin:0; }

/* ---------- customer type switch ---------- */
.dpa-dash .seg{
	position:relative; display:grid; grid-template-columns:1fr 1fr; padding:.3em; margin-bottom:1.2em;
	border-radius:.9em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2);
}
.dpa-dash .seg label{
	position:relative; z-index:1; display:flex; align-items:center; justify-content:center; gap:.55em;
	padding:.7em 1em; border-radius:.65em; cursor:pointer; font-size:.92em; font-weight:600; color:var(--dpa-muted);
	transition:color .25s;
}
.dpa-dash .seg label i{ font-size:1.1em; display:inline-flex; }
.dpa-dash .seg input{ position:absolute; opacity:0; pointer-events:none; }
.dpa-dash .seg-ind{
	position:absolute; top:.3em; bottom:.3em; left:.3em; width:calc(50% - .3em); border-radius:.65em;
	background:var(--dpa-text); transition:transform .4s cubic-bezier(.34,1.3,.64,1);
}
.dpa-dash .seg:has(input[value="new"]:checked) .seg-ind{ transform:translateX(100%); }
.dpa-dash .seg label:has(input:checked){ color:var(--dpa-bg); }
.dpa-dash .seg label:has(input:focus-visible){ outline:2px solid var(--dpa-link); outline-offset:2px; }
.dpa-dash .panel-in{ animation:fmPop .4s cubic-bezier(.2,.8,.2,1) both; }

/* ---------- samagri ---------- */
.dpa-dash .sam-list{ display:grid; grid-template-columns:repeat(auto-fill, minmax(15em, 1fr)); gap:.7em; }
.dpa-dash .sam-item{
	position:relative; display:flex; align-items:center; gap:.85em; padding:.85em 1em; cursor:pointer; user-select:none;
	border-radius:.85em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2);
	transition:border-color .2s, background-color .2s, transform .2s;
	animation:fmPop .45s cubic-bezier(.2,.8,.2,1) calc(var(--i, 0) * 40ms) both;
}
.dpa-dash .sam-item input{ position:absolute; opacity:0; pointer-events:none; }
.dpa-dash .sam-box{
	flex-shrink:0; width:1.5em; height:1.5em; border-radius:.45em; display:grid; place-items:center;
	border:2px solid var(--dpa-muted); color:#fff; transition:background-color .2s, border-color .2s, transform .25s cubic-bezier(.34,1.56,.64,1);
}
.dpa-dash .sam-box svg{ width:1em; height:1em; fill:none; stroke:currentColor; stroke-width:3.2; stroke-linecap:round; stroke-linejoin:round; stroke-dasharray:20; stroke-dashoffset:20; transition:stroke-dashoffset .3s ease .05s; }
.dpa-dash .sam-name{ min-width:0; overflow-wrap:anywhere; font-weight:600; }
.dpa-dash .sam-item input:checked + .sam-box{ background:#1f9d55; border-color:#1f9d55; transform:scale(1.08); }
.dpa-dash .sam-item input:checked + .sam-box svg{ stroke-dashoffset:0; }
.dpa-dash .sam-item:has(input:checked){ border-color:var(--good); background:color-mix(in srgb, var(--good) 9%, var(--dpa-surface-2)); }
.dpa-dash .sam-item input:focus-visible + .sam-box{ outline:2px solid var(--dpa-link); outline-offset:3px; }
.dpa-dash .skel{
	height:3.1em; border-radius:.85em; border:1px solid var(--dpa-border);
	background:linear-gradient(100deg, var(--dpa-surface-2) 30%, var(--dpa-hover) 50%, var(--dpa-surface-2) 70%) 0 0 / 200% 100%;
	animation:fmShimmer 1.3s linear infinite;
}
.dpa-dash .empty-box{
	display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:.4em;
	margin:0; padding:1.8em 1em; border-radius:.9em; border:1.5px dashed var(--dpa-border); color:var(--dpa-muted);
}
.dpa-dash .empty-box i{ font-size:1.8em; opacity:.6; }
.dpa-dash .empty-box p{ font-size:.95em; font-weight:500; }
.dpa-dash .hint{ margin-bottom:1em; font-size:.88em; font-weight:400; color:var(--dpa-muted); }

/* extra samagri */
.dpa-dash .add-row{ display:flex; gap:.7em; }
.dpa-dash .add-row .field-box{ flex:1; }
.dpa-dash .add-row.shake .field-box{ animation:fmShake .4s ease; border-color:var(--bad2); }
.dpa-dash #extraSamagriContainer{ margin-top:1em; display:flex; flex-direction:column; gap:.6em; }
.dpa-dash .extra-item{
	display:flex; align-items:center; justify-content:space-between; gap:1em; padding:.7em .7em .7em 1em;
	border-radius:.8em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2);
	animation:fmPop .35s cubic-bezier(.2,.8,.2,1) both; font-weight:600;
}
.dpa-dash .extra-item.out{ animation:fmOut .25s ease forwards; }
.dpa-dash .extra-item span{ min-width:0; overflow-wrap:anywhere; }
.dpa-dash .remove-btn{
	flex-shrink:0; display:inline-flex; align-items:center; gap:.4em; padding:.45em .8em; border-radius:.6em;
	border:1px solid var(--bad2); background:transparent; color:var(--bad2); cursor:pointer;
	font-family:inherit; font-size:.82em; font-weight:700; transition:background-color .2s, color .2s, transform .12s;
}
.dpa-dash .remove-btn:active{ transform:scale(.94); }

/* ---------- payment summary ---------- */
.dpa-dash .pay-stack{ display:flex; flex-direction:column; gap:1.1em; }
.dpa-dash .pay-bar{ height:.5em; border-radius:999px; background:var(--dpa-tile); overflow:hidden; }
.dpa-dash .pay-bar i{ display:block; height:100%; width:var(--w, 0%); border-radius:inherit; background:var(--good); transition:width .5s cubic-bezier(.2,.8,.2,1); }
.dpa-dash .status{
	display:inline-flex; align-items:center; gap:.5em; padding:.3em .9em; border-radius:999px;
	font-size:.78em; font-weight:700; letter-spacing:.06em; text-transform:uppercase; white-space:nowrap;
}
.dpa-dash .status::before{ content:""; width:.5em; height:.5em; border-radius:50%; background:currentColor; }
.dpa-dash .status.pending{ background:rgba(255,107,107,.15); color:var(--bad2); }
.dpa-dash .status.pending::before{ animation:dpaBlink 1.6s ease-in-out infinite; }
.dpa-dash .status.partial{ background:rgba(240,164,58,.16); color:var(--pend); }
.dpa-dash .status.paid{ background:rgba(52,211,153,.15); color:var(--good); }

/* ---------- buttons ---------- */
.dpa-dash .actions{ display:flex; gap:.8em; padding:0 1.5em 1.5em; }
.dpa-dash .btn{
	display:inline-flex; align-items:center; justify-content:center; gap:.6em; margin:0; padding:.85em 1.4em;
	border-radius:.8em; border:1px solid var(--dpa-border); background:transparent; box-shadow:none; cursor:pointer;
	font-family:inherit; font-size:.95em; font-weight:700; line-height:1.2; color:var(--dpa-text); white-space:nowrap;
	transition:background-color .2s, color .2s, transform .12s, box-shadow .25s, border-color .2s;
}
.dpa-dash .btn.primary{ flex:1; background:#1f9d55; border-color:#1f9d55; color:#fff; }
.dpa-dash .btn.add{ background:var(--dpa-text); border-color:var(--dpa-text); color:var(--dpa-bg); }
.dpa-dash .btn:active{ transform:scale(.96); }
.dpa-dash .btn.loading{ pointer-events:none; opacity:.85; }
.dpa-dash .btn.loading i{ animation:dpaSpin .8s linear infinite; }
.dpa-dash .btn:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

@media (hover:hover) and (pointer:fine){
	.dpa-dash .field-box:hover{ border-color:var(--dpa-twilight); }
	.dpa-dash .sam-item:hover{ border-color:var(--dpa-twilight); transform:translateX(3px); }
	.dpa-dash .seg label:hover{ color:var(--dpa-text); }
	.dpa-dash .seg label:has(input:checked):hover{ color:var(--dpa-bg); }
	.dpa-dash .btn.primary:hover{ background:#23b062; border-color:#23b062; box-shadow:0 8px 20px rgba(31,157,85,.35); }
	.dpa-dash .btn:not(.primary):not(.add):hover{ background:var(--dpa-hover); border-color:var(--dpa-twilight); }
	.dpa-dash .btn.add:hover{ background:var(--dpa-twilight); border-color:var(--dpa-twilight); color:#fff; }
	.dpa-dash .remove-btn:hover{ background:var(--bad2); color:#fff; }
}

/* ---------- responsive ---------- */
@media (max-width:1100px){ .dpa-dash .fm-grid{ grid-template-columns:minmax(0, 1fr); } .dpa-dash .fm-side{ position:static; } }
@media (max-width:900px){ .main-content{ margin-left:0; width:100%; padding:clamp(14px, 2.4vw, 24px); } }
@media (max-width:700px){
	.main-content{ padding:14px; }
	.dpa-dash{ gap:1.15em; }
	.dpa-dash .page-header{ padding:1.4em 1.3em; }
	.dpa-dash .hero-left{ gap:.9em; }
	.dpa-dash .hero-watermark{ font-size:6.5em; }
	.dpa-dash .section-top{ padding:1em 1.1em; }
	.dpa-dash .fm-body{ padding:1.1em; }
	.dpa-dash .form-grid{ grid-template-columns:minmax(0, 1fr); }
	.dpa-dash .actions{ padding:0 1.1em 1.1em; }
	.dpa-dash .add-row{ flex-direction:column; }
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
}
</style>

<style id="add-event-sidebar-reference-fix">
/* Match the shared Digital Purohit Assistant dark sidebar reference */
:root { --dpa-sidebar-w:260px; }
.sidebar {
  position:fixed !important; inset:0 auto 0 0 !important;
  width:260px !important; height:100vh !important; height:100dvh !important;
  margin:0 !important; padding:18px 14px 0 !important;
  display:flex !important; flex-direction:column !important;
  overflow:hidden !important; z-index:1000 !important;
  background:var(--dpa-sb-bg,#080a0f) !important;
  color:var(--dpa-text,#f5f5f5) !important;
  border:0 !important; border-right:1px solid var(--dpa-border,rgba(255,255,255,.09)) !important;
  box-shadow:none !important; font-family:'Inter',system-ui,sans-serif !important;
  font-size:14px !important; line-height:1.4 !important; box-sizing:border-box !important;
}
.sidebar *, .sidebar *::before, .sidebar *::after { box-sizing:border-box; }
.sidebar-header {
  display:flex !important; align-items:center !important; gap:12px !important;
  min-height:54px !important; padding:0 6px 14px !important;
  border-bottom:1px solid var(--dpa-border,rgba(255,255,255,.09)) !important;
  flex-shrink:0 !important;
}
.sidebar-logo {
  width:40px !important; height:40px !important; flex:0 0 40px !important;
  display:grid !important; place-items:center !important; border-radius:12px !important;
  color:var(--dpa-logo-fg,#fff) !important; background:var(--dpa-logo-bg,transparent) !important;
  border:1px solid var(--dpa-logo-border,rgba(255,255,255,.6)) !important; font-size:20px !important;
}
.sidebar-title-container { min-width:0 !important; display:flex !important; flex-direction:column !important; }
.sidebar-title-main { font-size:15px !important; font-weight:700 !important; line-height:1.25 !important; color:var(--dpa-text,#f5f5f5) !important; }
.sidebar-subtitle { font-family:'Caveat',cursive !important; font-size:18px !important; line-height:1.1 !important; color:#789bc9 !important; }
.sidebar-nav {
  display:flex !important; flex-direction:column !important; gap:4px !important;
  overflow-y:auto !important; overflow-x:hidden !important; min-height:0 !important;
  flex:1 1 auto !important; padding:14px 0 12px !important; margin:0 !important;
  scrollbar-width:thin !important; scrollbar-color:var(--dpa-scroll,rgba(255,255,255,.18)) transparent !important;
}
.sidebar-nav .menu-title {
  display:flex !important; align-items:center !important; gap:10px !important;
  margin:3px 8px 8px !important; padding:0 !important;
  color:var(--dpa-muted,rgba(255,255,255,.58)) !important;
  font-size:11px !important; font-weight:800 !important; letter-spacing:1.4px !important;
  text-transform:uppercase !important; white-space:nowrap !important;
}
.sidebar-nav .menu-title:not(:first-child) { margin-top:12px !important; }
.sidebar-nav .menu-title::after { content:""; height:1px; flex:1; background:var(--dpa-border,rgba(255,255,255,.09)); }
.sidebar-nav > a {
  display:flex !important; align-items:center !important; gap:12px !important;
  min-height:40px !important; width:100% !important; padding:6px 10px !important;
  margin:0 !important; border:0 !important; border-radius:11px !important;
  background:transparent !important; color:var(--dpa-muted,rgba(255,255,255,.58)) !important;
  text-decoration:none !important; font-size:14px !important; font-weight:650 !important;
  line-height:1.3 !important; white-space:nowrap !important; transition:background .2s,color .2s !important;
}
.sidebar-nav > a > i {
  display:grid !important; place-items:center !important; flex:0 0 30px !important;
  width:30px !important; height:30px !important; border-radius:9px !important;
  background:var(--dpa-tile,rgba(255,255,255,.07)) !important; color:inherit !important;
  font-size:14px !important;
}
.sidebar-nav > a:hover { background:var(--dpa-hover,rgba(255,255,255,.06)) !important; color:var(--dpa-text,#f5f5f5) !important; }
.sidebar-nav > a.active, .sidebar-nav > a[aria-current="page"] {
  background:var(--dpa-active-bg,#f5f5f5) !important; color:var(--dpa-active-text,#1b1b1b) !important;
}
.sidebar-nav > a.active > i, .sidebar-nav > a[aria-current="page"] > i { background:var(--dpa-active-tile,rgba(0,0,0,.08)) !important; }
.sidebar-nav .menu-badge {
  display:inline-flex !important; align-items:center !important; justify-content:center !important;
  min-width:25px !important; height:24px !important; margin-left:auto !important;
  padding:0 6px !important; border-radius:999px !important; background:#df454b !important;
  color:#fff !important; font-size:11px !important; font-weight:800 !important;
}
.sidebar-footer {
  flex:0 0 auto !important; padding:10px 0 14px !important;
  border-top:1px solid var(--dpa-border,rgba(255,255,255,.09)) !important;
}
.dpa-theme-toggle {
  display:flex !important; align-items:center !important; justify-content:space-between !important;
  width:100% !important; min-height:42px !important; padding:8px 12px !important;
  border:1px solid var(--dpa-border,rgba(255,255,255,.09)) !important; border-radius:12px !important;
  background:var(--dpa-surface-2,#161b26) !important; color:var(--dpa-text,#f5f5f5) !important;
  font:600 13px 'Inter',sans-serif !important; cursor:pointer !important;
}
.dpa-tt-label { display:flex !important; align-items:center !important; gap:8px !important; }
.dpa-tt-icons { display:inline-flex !important; align-items:center !important; }
.dpa-tt-switch { width:40px !important; height:22px !important; padding:3px !important; border-radius:999px !important; background:var(--dpa-switch,rgba(255,255,255,.2)) !important; }
.dpa-tt-knob { display:block !important; width:16px !important; height:16px !important; border-radius:50% !important; background:#fff !important; transition:transform .2s !important; }
:root[data-theme="light"] .dpa-tt-knob { transform:translateX(18px) !important; }
.main-content { margin-left:260px !important; width:calc(100% - 260px) !important; }
@media (max-width:900px) {
  .sidebar { transform:translateX(-100%) !important; }
  .sidebar.open { transform:translateX(0) !important; }
  .main-content { margin-left:0 !important; width:100% !important; }
}
</style>

</head>
<body>
<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />
<div class="main-content">

  <div class="event-form-page dpa-dash">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
        <div class="hero-left">
            <div class="hero-icon">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M8 12h8"/><path d="M12 8v8"/></svg></i>
            </div>
            <div>
                <h1>Add Event</h1>
                <p>Fill in the details to create a new event.</p>
            </div>
        </div>
    </div>

    <form id="eventForm" class="fm-grid" action="${pageContext.request.contextPath}/add-event" method="post">

        

        <!-- ================= LEFT COLUMN ================= -->
        <div class="fm-col">

            <!-- Customer -->
            <section class="section-card reveal" aria-labelledby="fmCustTitle">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i>
                        <div><h2 id="fmCustTitle">Customer Information</h2><p>Who is this event for?</p></div>
                    </div>
                </div>
                <div class="fm-body">

                    <div class="seg" role="radiogroup" aria-label="Customer type">
                        <span class="seg-ind" aria-hidden="true"></span>
                        <label>
                            <input type="radio" name="customerType" value="existing" checked onclick="toggleCustomerType()">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></i> Existing Customer
                        </label>
                        <label>
                            <input type="radio" name="customerType" value="new" onclick="toggleCustomerType()">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" x2="19" y1="8" y2="14"/><line x1="22" x2="16" y1="11" y2="11"/></svg></i> New Customer
                        </label>
                    </div>

                    <div id="existingCustomerDiv" class="field">
                        <label for="customerId">Select Customer</label>
                        <div class="field-box">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i>
                            <select id="customerId" name="customerId" required>
                                <option value="">-- Select Customer --</option>
                                <c:forEach var="customer" items="${customers}">
                                    <option value="${customer.customerId}"><c:out value="${customer.customerName}" /></option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div id="newCustomerDiv" style="display:none;">
                        <div class="form-grid">
                            <div class="field">
                                <label for="newCustomerName">Customer Name</label>
                                <div class="field-box"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i>
                                    <input type="text" id="newCustomerName" name="newCustomerName" placeholder="Full name"></div>
                            </div>
                            <div class="field">
                                <label for="newCustomerPhone">Phone</label>
                                <div class="field-box"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg></i>
                                    <input type="text" id="newCustomerPhone" name="newCustomerPhone" placeholder="Phone number"></div>
                            </div>
                            <div class="field">
                                <label for="newCustomerEmail">Email</label>
                                <div class="field-box"><i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg></i>
                                    <input type="email" id="newCustomerEmail" name="newCustomerEmail" placeholder="name@example.com"></div>
                            </div>
                            <div class="field">
                                <label for="newCustomerAddress">Address</label>
                                <div class="field-box area"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg></i>
                                    <textarea id="newCustomerAddress" name="newCustomerAddress" rows="3" placeholder="Address"></textarea></div>
                            </div>
                        </div>
                    </div>

                </div>
            </section>

            <!-- Event information -->
            <section class="section-card reveal" aria-labelledby="fmEventTitle">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="M8 14h.01"/><path d="M12 14h.01"/><path d="M16 14h.01"/><path d="M8 18h.01"/><path d="M12 18h.01"/><path d="M16 18h.01"/></svg></i>
                        <div><h2 id="fmEventTitle">Event Information</h2><p>Type, title, date and place</p></div>
                    </div>
                </div>
                <div class="fm-body">
                    <div class="form-grid">

                        <div class="field">
                            <label for="typeId">Event Type <span class="req">*</span></label>
                            <div class="field-box">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/><circle cx="7.5" cy="7.5" r=".5" fill="currentColor"/></svg></i>
                                <select id="typeId" name="typeId" required onchange="loadSamagri()">
                                    <option value="">-- Select Event Type --</option>
                                    <c:forEach var="eventType" items="${eventTypes}">
                                        <option value="${eventType.typeId}" data-title="<c:out value='${eventType.typeName}' />"><c:out value="${eventType.typeName}" /></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="field">
                            <label for="eventTitle">Event Title <span class="req">*</span></label>
                            <div class="field-box">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 20h9"/><path d="M16.376 3.622a1 1 0 0 1 3.002 3.002L7.368 18.635a2 2 0 0 1-.855.506l-2.872.838a.5.5 0 0 1-.62-.62l.838-2.872a2 2 0 0 1 .506-.854z"/></svg></i>
                                <input type="text" id="eventTitle" name="eventTitle" placeholder="Filled from the event type, you can change it"
                                       value="" required>
                            </div>
                        </div>

                        <div class="field">
                            <label for="eventDate">Event Date</label>
                            <div class="field-box">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/></svg></i>
                                <input type="date" id="eventDate" name="eventDate" value="" required>
                            </div>
                        </div>

                        <div class="field">
                            <label for="eventTime">Event Time</label>
                            <div class="field-box">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></i>
                                <input type="time" id="eventTime" name="eventTime"
                                       value="" required>
                            </div>
                        </div>

                        <div class="field full">
                            <label for="location">Location</label>
                            <div class="field-box">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg></i>
                                <input type="text" id="location" name="location" placeholder="Where will it take place?" value="">
                            </div>
                        </div>

                    </div>
                </div>
            </section>

            <!-- Required samagri -->
            <section class="section-card reveal" aria-labelledby="fmSamTitle">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg></i>
                        <div><h2 id="fmSamTitle">Required Samagri</h2><p>Loaded from the event type</p></div>
                    </div>
                    <span class="tag" id="samTag">0 selected</span>
                </div>
                <div class="fm-body">
                    <p class="hint">Select an Event Type to automatically load the required samagri.</p>
                    <div id="samagriContainer" class="sam-list">
                        <div class="empty-box" style="grid-column:1 / -1">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/></svg></i>
                            <p>Please select an Event Type.</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Extra samagri -->
            <section class="section-card reveal" aria-labelledby="fmExtraTitle">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M8 12h8"/><path d="M12 8v8"/></svg></i>
                        <div><h2 id="fmExtraTitle">Extra Samagri</h2><p>Anything not in the list above</p></div>
                    </div>
                    <span class="tag" id="extraTag">0 added</span>
                </div>
                <div class="fm-body">
                    <div class="add-row" id="addRow">
                        <div class="field-box">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg></i>
                            <input type="text" id="extraSamagriName" placeholder="Enter Extra Samagri">
                        </div>
                        <button type="button" class="btn add" onclick="addExtraSamagri()">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M5 12h14"/><path d="M12 5v14"/></svg></i> Add
                        </button>
                    </div>
                    <div id="extraSamagriContainer">
                        <div class="empty-box">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg></i>
                            <p>No Extra Samagri Added</p>
                        </div>
                    </div>
                </div>
            </section>

        </div>

        <!-- ================= RIGHT COLUMN ================= -->
        <div class="fm-col fm-side">

            <!-- Payment summary -->
            <section class="section-card reveal" aria-labelledby="fmPayTitle">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/></svg></i>
                        <div><h2 id="fmPayTitle">Payment Summary</h2><p>Whole rupees only</p></div>
                    </div>
                    <span class="status pending" id="payPill">PENDING</span>
                </div>
                <div class="fm-body pay-stack">

                    <div class="field">
                        <label for="totalAmount">Total Amount</label>
                        <div class="field-box"><span class="cur">&#8377;</span>
                            <input type="number" id="totalAmount" name="totalAmount" step="1" min="0" inputmode="numeric" placeholder="0"
                                   value="" required></div>
                    </div>

                    <div class="field">
                        <label for="amountPaid">Advance Paid</label>
                        <div class="field-box"><span class="cur">&#8377;</span>
                            <input type="number" id="amountPaid" name="amountPaid" step="1" min="0" inputmode="numeric" placeholder="0"
                                   value="" required></div>
                    </div>

                    <div class="pay-bar" aria-hidden="true"><i id="payBar"></i></div>

                    <div class="field">
                        <label for="pendingAmount">Pending Amount</label>
                        <div class="field-box"><span class="cur">&#8377;</span>
                            <input type="text" id="pendingAmount" readonly tabindex="-1" value="0"></div>
                    </div>

                    <div class="field">
                        <label for="paymentStatus">Payment Status</label>
                        <div class="field-box">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg></i>
                            <input type="text" id="paymentStatus" readonly tabindex="-1" value="PENDING">
                        </div>
                    </div>

                </div>
            </section>

            <!-- Notes -->
            <section class="section-card reveal" aria-labelledby="fmNotesTitle">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/></svg></i>
                        <div><h2 id="fmNotesTitle">Notes</h2><p>Optional</p></div>
                    </div>
                </div>
                <div class="fm-body">
                    <div class="field-box area">
                        <textarea name="notes" rows="5" placeholder="Anything worth remembering about this event"></textarea>
                    </div>
                </div>
                <div class="actions">
                    <button type="reset" class="btn">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg></i> Reset
                    </button>
                    <button type="submit" class="btn primary" id="saveBtn">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z"/><path d="M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7"/><path d="M7 3v4a1 1 0 0 0 1 1h7"/></svg></i> <span>Save Event</span>
                    </button>
                </div>
            </section>

        </div>

    </form>

  </div>

</div>



<script>
(function () {
	var ctx = "${pageContext.request.contextPath}";
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	var $ = function (id) { return document.getElementById(id); };
	var CHECK = '<svg viewBox="0 0 24 24"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg>';
	var ICON_BOX = '<svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/></svg>';
	var ICON_ALERT = '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/></svg>';
	var nf = new Intl.NumberFormat('en-IN', { maximumFractionDigits: 0 });

	/* ---------- scroll reveal ---------- */
	var page = document.querySelector('.dpa-dash');
	if (page) {
		page.querySelectorAll('.fm-col').forEach(function (col) {
			Array.prototype.forEach.call(col.children, function (el, i) { el.style.setProperty('--d', (i * 90) + 'ms'); });
		});
		var targets = page.querySelectorAll('.reveal');
		function reveal(el) { el.classList.add('in'); }
		if (!('IntersectionObserver' in window)) { targets.forEach(reveal); }
		else {
			var io = new IntersectionObserver(function (entries) {
				entries.forEach(function (en) { if (en.isIntersecting) { reveal(en.target); io.unobserve(en.target); } });
			}, { threshold: 0.08, rootMargin: '0px 0px -30px 0px' });
			targets.forEach(function (t) { io.observe(t); });
		}
	}

	/* ---------- existing / new customer ---------- */
	window.toggleCustomerType = function () {
		var selected = document.querySelector("input[name='customerType']:checked").value;
		var existing = $('existingCustomerDiv'), newer = $('newCustomerDiv'), select = $('customerId');
		select.required = (selected === 'existing');
		var show = selected === 'existing' ? existing : newer;
		var hide = selected === 'existing' ? newer : existing;
		hide.style.display = 'none';
		show.style.display = 'block';
		show.classList.remove('panel-in'); void show.offsetWidth; show.classList.add('panel-in');
	};

	/* ---------- empty / error boxes ---------- */
	function box(icon, text, wide) {
		return '<div class="empty-box"' + (wide ? ' style="grid-column:1 / -1"' : '') + '><i aria-hidden="true">' + icon + '</i><p>' + text + '</p></div>';
	}

	/* ---------- required samagri (from the event type) ---------- */
	var samContainer = $('samagriContainer'), samTag = $('samTag');
	function samCount() {
		var n = samContainer.querySelectorAll('input[name="samagriIds"]:checked').length;
		samTag.textContent = n + ' selected';
	}
	samContainer.addEventListener('change', samCount);

	var loadToken = 0;
	window.loadSamagri = function () {
		var typeSel = $('typeId'), typeId = typeSel.value;

		/* the event title follows the event type until you type your own */
		autoTitle();

		if (typeId === '') {
			samContainer.innerHTML = box(ICON_BOX, 'Please select an Event Type.', true);
			samCount();
			return;
		}

		var token = ++loadToken;
		samContainer.innerHTML = '<div class="skel"></div><div class="skel"></div><div class="skel"></div>';

		fetch(ctx + '/load-event-type-samagri?typeId=' + encodeURIComponent(typeId))
			.then(function (r) { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
			.then(function (list) {
				if (token !== loadToken) return;          /* an newer selection is already loading */
				samContainer.innerHTML = '';
				if (!list || list.length === 0) {
					samContainer.innerHTML = box(ICON_BOX, 'No Samagri found.', true);
					samCount();
					return;
				}
				list.forEach(function (item, i) {
					var label = document.createElement('label');
					label.className = 'sam-item';
					label.style.setProperty('--i', Math.min(i, 14));

					var cb = document.createElement('input');
					cb.type = 'checkbox'; cb.name = 'samagriIds'; cb.value = item.samagriId; cb.checked = true;

					var boxEl = document.createElement('span');
					boxEl.className = 'sam-box'; boxEl.innerHTML = CHECK;

					var name = document.createElement('span');
					name.className = 'sam-name'; name.textContent = item.samagriName;

					label.appendChild(cb); label.appendChild(boxEl); label.appendChild(name);
					samContainer.appendChild(label);
				});
				samCount();
			})
			.catch(function (err) {
				if (token !== loadToken) return;
				samContainer.innerHTML = box(ICON_ALERT, 'Failed to load Samagri', true);
				samCount();
				console.error(err);
			});
	};

	/* ---------- event title follows the event type ---------- */
	var titleInput = $('eventTitle'), titleTouched = titleInput.value.trim() !== '', lastAuto = '';
	titleInput.addEventListener('input', function () {
		titleTouched = titleInput.value.trim() !== '' && titleInput.value !== lastAuto;
	});
	function autoTitle() {
		var sel = $('typeId');
		if (!sel.value || titleTouched) return;
		lastAuto = sel.options[sel.selectedIndex].text.trim();
		titleInput.value = lastAuto;
	}

	/* ---------- extra samagri ---------- */
	var extraBox = $('extraSamagriContainer'), extraTag = $('extraTag');
	function extraCount() {
		var n = extraBox.querySelectorAll('.extra-item:not(.out)').length;
		extraTag.textContent = n + ' added';
		if (n === 0) extraBox.innerHTML = box('<svg viewBox="0 0 24 24"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>', 'No Extra Samagri Added');
	}
	window.addExtraSamagri = function () {
		var input = $('extraSamagriName'), value = input.value.trim(), row = $('addRow');
		function nope() {
			row.classList.remove('shake'); void row.offsetWidth; row.classList.add('shake');
			input.focus();
		}
		if (value === '') { nope(); return; }
		var dup = false;
		extraBox.querySelectorAll('input[name="extraSamagri"]').forEach(function (h) { if (h.value.toLowerCase() === value.toLowerCase()) dup = true; });
		if (dup) { nope(); return; }

		var empty = extraBox.querySelector('.empty-box');
		if (empty) extraBox.innerHTML = '';

		var item = document.createElement('div');
		item.className = 'extra-item';

		var hidden = document.createElement('input');
		hidden.type = 'hidden'; hidden.name = 'extraSamagri'; hidden.value = value;

		var text = document.createElement('span');
		text.textContent = value;

		var remove = document.createElement('button');
		remove.type = 'button'; remove.className = 'remove-btn';
		remove.innerHTML = '<svg viewBox="0 0 24 24" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg> Remove';
		remove.addEventListener('click', function () {
			item.classList.add('out');
			setTimeout(function () { item.remove(); extraCount(); }, reduce ? 0 : 230);
			extraTag.textContent = (extraBox.querySelectorAll('.extra-item:not(.out)').length) + ' added';
		});

		item.appendChild(hidden); item.appendChild(text); item.appendChild(remove);
		extraBox.appendChild(item);
		extraTag.textContent = extraBox.querySelectorAll('.extra-item:not(.out)').length + ' added';
		input.value = ''; input.focus();
	};
	$('extraSamagriName').addEventListener('keydown', function (e) {
		if (e.key === 'Enter') { e.preventDefault(); window.addExtraSamagri(); }   /* Enter adds the item, it does not submit the form */
	});

	/* ---------- payment: whole rupees only ---------- */
	var total = $('totalAmount'), paid = $('amountPaid');
	function whole(el) {
		var v = parseFloat(el.value);
		return isNaN(v) ? 0 : Math.max(0, Math.round(v));
	}
	window.calculatePayment = function () {
		var t = whole(total), p = whole(paid);
		var pending = Math.max(0, t - p);
		$('pendingAmount').value = nf.format(pending);

		var status = 'PENDING';
		if (p === 0) status = 'PENDING';
		else if (p < t) status = 'PARTIAL';
		else status = 'PAID';
		$('paymentStatus').value = status;

		var pill = $('payPill');
		pill.textContent = status;
		pill.className = 'status ' + status.toLowerCase();

		$('payBar').style.setProperty('--w', (t > 0 ? Math.min(100, p * 100 / t) : 0) + '%');
	};
	[total, paid].forEach(function (el) {
		el.addEventListener('input', calculatePayment);
		/* paise are not accepted: no decimal point / exponent / minus, and pasted decimals are rounded */
		el.addEventListener('keydown', function (e) {
			if (e.key === '.' || e.key === ',' || e.key === 'e' || e.key === 'E' || e.key === '+' || e.key === '-') e.preventDefault();
		});
		el.addEventListener('change', function () {
			if (el.value !== '') el.value = whole(el);
			calculatePayment();
		});
	});
	/* the mouse wheel can never change a number field */
	document.addEventListener('wheel', function () {
		var a = document.activeElement;
		if (a && a.type === 'number') a.blur();
	}, { passive: true });

	/* ---------- save feedback (prevents double submit) ---------- */
	var form = $('eventForm'), saveBtn = $('saveBtn'), sending = false;
	form.addEventListener('submit', function (e) {
		if (sending) { e.preventDefault(); return; }
		if (!form.checkValidity()) return;
		sending = true;
		saveBtn.classList.add('loading');
		saveBtn.innerHTML = '<i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg></i> <span>Saving\u2026</span>';
	});
	window.addEventListener('pageshow', function (e) { if (e.persisted) location.reload(); });

	/* ---------- reset ---------- */
	form.addEventListener('reset', function () {
		setTimeout(function () {
			toggleCustomerType();
			extraBox.innerHTML = ''; extraCount();
			titleTouched = titleInput.value.trim() !== ''; lastAuto = '';
			loadSamagri();
			calculatePayment();
		}, 0);
	});

	/* ---------- start ---------- */
	document.addEventListener('DOMContentLoaded', function () {
		toggleCustomerType();
		calculatePayment();
		extraCount();
		if ($('typeId').value !== '') loadSamagri();
	});
})();
</script>
</body>
</html>