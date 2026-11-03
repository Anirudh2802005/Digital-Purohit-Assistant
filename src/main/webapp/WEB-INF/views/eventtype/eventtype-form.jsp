<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="com.digitalpurohit.model.EventType"%>
<%@ page import="com.digitalpurohit.model.Samagri"%>
<%!
/* HTML-escape (null -> "") */
private static String h(Object o) {
    if (o == null) return "";
    return String.valueOf(o).replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
}
%>
<%
EventType eventType = (EventType) request.getAttribute("eventType");
boolean editMode = (eventType != null);

List<Samagri> samagriList = (List<Samagri>) request.getAttribute("samagriList");
List<Integer> selectedSamagriIds = (List<Integer>) request.getAttribute("selectedSamagriIds");

Set<Integer> selectedIds = new HashSet<Integer>();
if (selectedSamagriIds != null) {
    selectedIds.addAll(selectedSamagriIds);
}

String pageTitle  = editMode ? "Edit Event Type" : "Add Event Type";
String heroSub    = editMode ? "Update this event category and its samagri." : "Create a new event category and pick its samagri.";
String formAction = editMode ? "edit-event-type" : "add-event-type";
String submitText = editMode ? "Update Event Type" : "Save Event Type";
boolean isActive  = (editMode && eventType.isActive()) || !editMode;
int totalSamagri  = samagriList == null ? 0 : samagriList.size();
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= pageTitle %> | Digital Purohit Assistant</title>

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

<style id="et-theme">
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

<style id="et-css">
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

/* ---------- event type specific ---------- */
.dpa-dash .switch-row{
	display:flex; align-items:center; justify-content:space-between; gap:1em; padding:.9em 1.05em;
	border-radius:.85em; border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2); cursor:pointer; user-select:none;
	transition:border-color .2s, background-color .2s;
}
.dpa-dash .switch-row b{ display:block; font-size:1em; font-weight:700; }
.dpa-dash .switch-row small{ display:block; margin-top:.15em; font-size:.85em; font-weight:400; color:var(--dpa-muted); }
.dpa-dash .switch-row input{ position:absolute; opacity:0; pointer-events:none; }
.dpa-dash .switch{
	position:relative; flex-shrink:0; width:3.2em; height:1.8em; border-radius:999px; background:var(--dpa-tile);
	border:1px solid var(--dpa-border); transition:background-color .3s, border-color .3s;
}
.dpa-dash .switch::after{
	content:""; position:absolute; top:.2em; left:.2em; width:1.3em; height:1.3em; border-radius:50%; background:#fff;
	box-shadow:0 2px 6px rgba(0,0,0,.35); transition:transform .4s cubic-bezier(.34,1.56,.64,1);
}
.dpa-dash .switch-row:has(input:checked){ border-color:var(--good); background:color-mix(in srgb, var(--good) 8%, var(--dpa-surface-2)); }
.dpa-dash .switch-row:has(input:checked) .switch{ background:#1f9d55; border-color:#1f9d55; }
.dpa-dash .switch-row:has(input:checked) .switch::after{ transform:translateX(1.4em); }
.dpa-dash .switch-row:has(input:focus-visible){ outline:2px solid var(--dpa-link); outline-offset:3px; }

.dpa-dash .tools{ display:flex; gap:.7em; flex-wrap:wrap; margin-bottom:1em; }
.dpa-dash .tools .field-box{ flex:1; min-width:12em; }
.dpa-dash .btn.small{ padding:.7em 1em; font-size:.88em; }
.dpa-dash .no-match{ display:none; padding:1.6em 1em; text-align:center; color:var(--dpa-muted); }
.dpa-dash .no-match.show{ display:block; }
.dpa-dash .sam-item[hidden]{ display:none !important; }

.dpa-dash .sum{ display:flex; flex-direction:column; align-items:center; gap:1em; padding:1.5em; text-align:center; }
.dpa-dash .sum-icon{
	width:4.2em; height:4.2em; border-radius:1.2em; font-size:1.2em; display:flex; align-items:center; justify-content:center;
	color:#fff; background:linear-gradient(135deg, #426188, #2b7fff); box-shadow:0 10px 28px rgba(43,127,255,.25);
	animation:bobIcon 4s ease-in-out infinite;
}
@keyframes bobIcon{ 0%,100%{ transform:translateY(0); } 50%{ transform:translateY(-5px); } }
.dpa-dash .sum-name{ font-size:1.25em; font-weight:700; letter-spacing:-.01em; overflow-wrap:anywhere; }
.dpa-dash .sum-name.placeholder{ color:var(--dpa-muted); font-weight:600; }
.dpa-dash .pill{
	display:inline-flex; align-items:center; gap:.5em; padding:.3em .9em; border-radius:999px;
	font-size:.78em; font-weight:700; letter-spacing:.06em; text-transform:uppercase;
	background:rgba(52,211,153,.15); color:var(--good); transition:background-color .3s, color .3s;
}
.dpa-dash .pill::before{ content:""; width:.5em; height:.5em; border-radius:50%; background:currentColor; }
.dpa-dash .pill.off{ background:rgba(255,107,107,.15); color:var(--bad2); }
.dpa-dash .sum-count{ width:100%; padding:1em; border-radius:.9em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2); text-align:left; }
.dpa-dash .sum-count label{ display:block; font-size:.78em; font-weight:600; color:var(--dpa-muted); }
.dpa-dash .sum-count b{ font-size:1.6em; font-weight:700; font-variant-numeric:tabular-nums; }
.dpa-dash .sum-count span{ color:var(--dpa-muted); font-size:.9em; font-weight:600; }
.dpa-dash .sel-bar{ height:.5em; margin-top:.7em; border-radius:999px; background:var(--dpa-tile); overflow:hidden; }
.dpa-dash .sel-bar i{ display:block; height:100%; width:var(--w, 0%); border-radius:inherit; background:var(--good); transition:width .45s cubic-bezier(.2,.8,.2,1); }
.dpa-dash .actions{ padding-top:0; }
.dpa-dash .actions a.btn{ text-decoration:none; }
.dpa-dash .actions .btn.primary{ order:2; }
@media (prefers-reduced-motion: reduce){ .dpa-dash .sum-icon{ animation:none !important; } }

/* ---------- fixes: switch layout, equal-height columns ---------- */
.dpa-dash .field .switch-row{ position:relative; display:flex; margin:0; font-size:1em; font-weight:500; color:var(--dpa-text); }
.dpa-dash .switch{ display:block; }
.dpa-dash .fm-grid{ align-items:stretch; }
.dpa-dash .fm-side{ position:static; }
.dpa-dash .fm-side > .section-card{ flex:1; display:flex; flex-direction:column; }
.dpa-dash .fm-side .sum{ flex:1; justify-content:center; }
.dpa-dash .fm-side .actions{ margin-top:auto; }
.dpa-dash .fm-col:not(.fm-side) > .section-card:last-child{ flex:1; }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">

  <div class="event-type-form-page dpa-dash">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
        <div class="hero-left">
            <div class="hero-icon">
                <i aria-hidden="true"><% if (editMode) { %><svg viewBox="0 0 24 24"><path d="M12 20h9"/><path d="M16.376 3.622a1 1 0 0 1 3.002 3.002L7.368 18.635a2 2 0 0 1-.855.506l-2.872.838a.5.5 0 0 1-.62-.62l.838-2.872a2 2 0 0 1 .506-.854z"/></svg><% } else { %><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M8 12h8"/><path d="M12 8v8"/></svg><% } %></i>
            </div>
            <div>
                <h1><%= pageTitle %></h1>
                <p><%= heroSub %></p>
            </div>
        </div>
    </div>

    <form id="typeForm" class="fm-grid" action="${pageContext.request.contextPath}/<%= formAction %>" method="post">

        <% if (editMode) { %>
        <input type="hidden" name="typeId" value="<%= eventType.getTypeId() %>">
        <% } %>

        <!-- ================= LEFT COLUMN ================= -->
        <div class="fm-col">

            <!-- Details -->
            <section class="section-card reveal" aria-labelledby="etDetails">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/><circle cx="7.5" cy="7.5" r=".5" fill="currentColor"/></svg></i>
                        <div><h2 id="etDetails">Event Type Details</h2><p>Name, description and status</p></div>
                    </div>
                </div>
                <div class="fm-body">
                    <div class="form-grid">

                        <div class="field" style="grid-column:1 / -1">
                            <label for="typeName">Event Type Name</label>
                            <div class="field-box">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M12 20h9"/><path d="M16.376 3.622a1 1 0 0 1 3.002 3.002L7.368 18.635a2 2 0 0 1-.855.506l-2.872.838a.5.5 0 0 1-.62-.62l.838-2.872a2 2 0 0 1 .506-.854z"/></svg></i>
                                <input type="text" id="typeName" name="typeName" placeholder="Enter Event Type Name"
                                       value="<%= editMode ? h(eventType.getTypeName()) : "" %>" required>
                            </div>
                        </div>

                        <div class="field" style="grid-column:1 / -1">
                            <label for="description">Description</label>
                            <div class="field-box area">
                                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/></svg></i>
                                <textarea id="description" name="description" rows="4" placeholder="Description"><%= editMode ? h(eventType.getDescription()) : "" %></textarea>
                            </div>
                        </div>

                        <div class="field" style="grid-column:1 / -1">
                            <label class="switch-row" for="active">
                                <span><b>Active</b><small id="activeHint"><%= isActive ? "This event type can be used for new events" : "This event type is switched off" %></small></span>
                                <input type="checkbox" id="active" name="active" <%= isActive ? "checked" : "" %>>
                                <span class="switch" aria-hidden="true"></span>
                            </label>
                        </div>

                    </div>
                </div>
            </section>

            <!-- Samagri -->
            <section class="section-card reveal" aria-labelledby="etSam">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg></i>
                        <div><h2 id="etSam">Required Master Samagri</h2><p>Added automatically to events of this type</p></div>
                    </div>
                    <span class="tag" id="samTag">0 of <%= totalSamagri %> selected</span>
                </div>
                <div class="fm-body">

                    <% if (totalSamagri > 0) { %>
                    <div class="tools">
                        <div class="field-box">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></i>
                            <input type="search" id="samSearch" placeholder="Search samagri" autocomplete="off">
                        </div>
                        <button type="button" class="btn small" id="selAll">Select all</button>
                        <button type="button" class="btn small" id="selNone">Clear</button>
                    </div>
                    <% } %>

                    <div class="sam-list" id="samList">
                    <%-- SAM-LIST-BEGIN --%>
                    <%
                    if (samagriList != null && !samagriList.isEmpty()) {
                        int idx = 0;
                        for (Samagri samagri : samagriList) {
                    %>
                        <label class="sam-item" style="--i:<%= Math.min(idx++, 14) %>">
                            <input type="checkbox" name="samagriIds" value="<%= samagri.getSamagriId() %>" <%= selectedIds.contains(samagri.getSamagriId()) ? "checked" : "" %>>
                            <span class="sam-box"><svg viewBox="0 0 24 24"><path d="M5 12.5l4.5 4.5L19 7.5"/></svg></span>
                            <span class="sam-name"><%= h(samagri.getSamagriName()) %></span>
                        </label>
                    <%
                        }
                    } else {
                    %>
                        <div class="empty-box" style="grid-column:1 / -1">
                            <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg></i>
                            <p>No master samagri found. Add samagri first.</p>
                        </div>
                    <% } %>
                    <%-- SAM-LIST-END --%>
                    </div>
                    <div class="no-match" id="noMatch">No samagri matches your search.</div>

                </div>
            </section>

        </div>

        <!-- ================= RIGHT COLUMN ================= -->
        <div class="fm-col fm-side">
            <section class="section-card reveal" aria-labelledby="etSum">
                <div class="section-top">
                    <div class="st-left">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg></i>
                        <div><h2 id="etSum">Summary</h2><p>How it will look</p></div>
                    </div>
                </div>
                <div class="sum">
                    <div class="sum-icon" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/><circle cx="7.5" cy="7.5" r=".5" fill="currentColor"/></svg></i></div>
                    <div class="sum-name placeholder" id="sumName">Event type name</div>
                    <span class="pill" id="sumPill">Active</span>
                    <div class="sum-count">
                        <label>Samagri selected</label>
                        <b id="sumCount">0</b> <span>of <%= totalSamagri %></span>
                        <div class="sel-bar" aria-hidden="true"><i id="selBar"></i></div>
                    </div>
                </div>
                <div class="actions">
                    <button type="submit" class="btn primary" id="saveBtn">
                        <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z"/><path d="M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7"/><path d="M7 3v4a1 1 0 0 0 1 1h7"/></svg></i> <span><%= submitText %></span>
                    </button>
                </div>
            </section>
        </div>

    </form>

  </div>

</div>

<script id="et-js">
(function () {
	var $ = function (id) { return document.getElementById(id); };
	var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

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

	/* ---------- live summary: name + status ---------- */
	var nameInput = $('typeName'), sumName = $('sumName');
	function paintName() {
		var v = nameInput.value.trim();
		sumName.textContent = v || 'Event type name';
		sumName.classList.toggle('placeholder', !v);
	}
	nameInput.addEventListener('input', paintName);

	var active = $('active'), pill = $('sumPill'), hint = $('activeHint');
	function paintActive() {
		pill.textContent = active.checked ? 'Active' : 'Inactive';
		pill.classList.toggle('off', !active.checked);
		hint.textContent = active.checked ? 'This event type can be used for new events' : 'This event type is switched off';
	}
	active.addEventListener('change', paintActive);

	/* ---------- samagri: count, search, select all / clear ---------- */
	var list = $('samList');
	var items = Array.prototype.slice.call(list.querySelectorAll('.sam-item'));
	var tag = $('samTag'), sumCount = $('sumCount'), bar = $('selBar'), noMatch = $('noMatch');
	function boxes() { return list.querySelectorAll('input[name="samagriIds"]'); }
	function count() {
		var all = boxes(), n = 0;
		all.forEach(function (b) { if (b.checked) n++; });
		tag.textContent = n + ' of ' + all.length + ' selected';
		sumCount.textContent = n;
		bar.style.setProperty('--w', (all.length ? n * 100 / all.length : 0) + '%');
	}
	list.addEventListener('change', count);

	var search = $('samSearch');
	if (search) search.addEventListener('input', function () {
		var q = search.value.trim().toLowerCase(), shown = 0;
		items.forEach(function (el) {
			var ok = !q || el.textContent.toLowerCase().indexOf(q) > -1;
			el.hidden = !ok; if (ok) shown++;
		});
		noMatch.classList.toggle('show', items.length > 0 && shown === 0);
	});
	function setVisible(state) {
		items.forEach(function (el) { if (!el.hidden) el.querySelector('input').checked = state; });
		count();
	}
	if ($('selAll')) $('selAll').addEventListener('click', function () { setVisible(true); });
	if ($('selNone')) $('selNone').addEventListener('click', function () { setVisible(false); });

	/* ---------- save feedback (prevents double submit) ---------- */
	var form = $('typeForm'), btn = $('saveBtn'), sending = false;
	form.addEventListener('submit', function (e) {
		if (sending) { e.preventDefault(); return; }
		if (!form.checkValidity()) return;
		sending = true;
		btn.classList.add('loading');
		btn.innerHTML = '<i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg></i> <span>Saving\u2026</span>';
	});
	window.addEventListener('pageshow', function (e) { if (e.persisted) location.reload(); });

	paintName(); paintActive(); count();
})();
</script>

</body>
</html>
