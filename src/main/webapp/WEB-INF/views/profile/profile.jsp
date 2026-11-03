<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String adminName = "";
    if (request.getAttribute("admin") != null) {
        com.digitalpurohit.model.Admin profileAdmin =
            (com.digitalpurohit.model.Admin) request.getAttribute("admin");
        adminName = profileAdmin.getName() == null ? "" : profileAdmin.getName().trim();
    }
    String initials = "AD";
    if (!adminName.isEmpty()) {
        String[] parts = adminName.split("\\s+");
        initials = parts[0].substring(0, 1).toUpperCase();
        if (parts.length > 1 && !parts[1].isEmpty()) {
            initials += parts[1].substring(0, 1).toUpperCase();
        } else if (parts[0].length() > 1) {
            initials = parts[0].substring(0, 2).toUpperCase();
        }
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile | Digital Purohit Assistant</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Anton&family=Caveat:wght@500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
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
   MY PROFILE — same design system as Pending Payments / dashboard
   Colours come from the shared --dpa-* variables defined in sidebar.jsp.
   ===================================================================== */
:root{
  --dpa-sidebar-w:260px; --dpa-twilight:#426188; --dpa-link:#2b7fff; --dpa-bad:#d64545;
}
:root, :root[data-theme="dark"]{
  --dpa-bg:#050608; --dpa-surface:#10141c; --dpa-surface-2:#161b26; --dpa-text:#f5f5f5;
  --dpa-muted:rgba(255,255,255,.58); --dpa-border:rgba(255,255,255,.09);
  --dpa-hover:rgba(255,255,255,.06); --dpa-tile:rgba(255,255,255,.07);
}
:root[data-theme="light"]{
  --dpa-bg:#f1f4f9; --dpa-surface:#fff; --dpa-surface-2:#f5f5f5; --dpa-text:#1b1b1b;
  --dpa-muted:#6b7280; --dpa-border:rgba(0,0,0,.09); --dpa-hover:rgba(0,0,0,.045); --dpa-tile:rgba(0,0,0,.05);
}
@media (max-width:900px), (max-width:1100px) and (max-height:520px){ :root{ --dpa-sidebar-w:0px; } }
@media (min-width:1700px){ :root{ --dpa-sidebar-w:296px; } }
@media (min-width:2400px){ :root{ --dpa-sidebar-w:360px; } }
@media (min-width:3200px){ :root{ --dpa-sidebar-w:460px; } }

html, body{ margin:0; min-height:100%; }
body{ font-family:'Inter', system-ui, sans-serif; background:var(--dpa-bg); color:var(--dpa-text); transition:background-color .35s, color .35s; }
i svg{ width:1em; height:1em; fill:none; stroke:currentColor; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }

.main-content{
  margin-left:var(--dpa-sidebar-w, 260px);
  padding:clamp(14px, 2.4vw, 34px);
  width:auto; max-width:none; min-width:0; box-sizing:border-box; background:transparent;
  transition:margin-left .3s ease;
}
.dpa-dash{
  --dk:1; --good:#34d399; --bad2:#ff6b6b;
  max-width:108em; margin:0 auto; display:flex; flex-direction:column; gap:1.5em;
  font-size:calc(14px * var(--dk)); font-weight:500; line-height:1.45; color:var(--dpa-text);
  -webkit-font-smoothing:antialiased;
}
:root[data-theme="light"] .dpa-dash{ --good:#168a4a; --bad2:#c93434; }
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
@keyframes dpaPop{ 0%{ transform:scale(.6); opacity:0; } 60%{ transform:scale(1.08); } 100%{ transform:scale(1); opacity:1; } }
@keyframes dpaToast{ from{ opacity:0; translate:0 -14px; } to{ opacity:1; translate:0 0; } }
.dpa-js .dpa-dash .reveal{ opacity:0; }
.dpa-js .dpa-dash .reveal.in{ animation:dpaRise .75s cubic-bezier(.2,.8,.2,1) var(--d, 0ms) both; }

/* ---------- hero (same as Pending Payments) ---------- */
.dpa-dash .page-header{
  position:relative; overflow:hidden; isolation:isolate;
  display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:1.3em;
  padding:2.1em 2.3em; border-radius:1.3em; border:1px solid rgba(255,255,255,.08);
  background:#05070b; color:#fff; animation:dpaRise .9s cubic-bezier(.2,.8,.2,1) both;
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
  color:transparent; -webkit-text-stroke:1px rgba(255,255,255,.07); animation:dpaDrift 46s linear infinite;
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
  font-size:clamp(1.8em, 3.4vw, 3.2em); line-height:1; letter-spacing:.01em; color:#fff;
}
.dpa-dash .page-header p{ margin-top:.55em; color:rgba(255,255,255,.72); font-weight:400; font-size:1.05em; }

/* ---------- toast ---------- */
.dpa-dash .toast{
  display:flex; align-items:center; gap:.7em; padding:.9em 1.2em; border-radius:.9em; font-weight:700; font-size:.95em;
  animation:dpaToast .5s cubic-bezier(.2,.8,.2,1) both; transition:opacity .5s, translate .5s;
}
.dpa-dash .toast.ok{ border:1px solid rgba(52,211,153,.35); background:rgba(52,211,153,.12); color:var(--good); }
.dpa-dash .toast.err{ border:1px solid rgba(255,107,107,.35); background:rgba(255,107,107,.12); color:var(--bad2); }
.dpa-dash .toast.hide{ opacity:0; translate:0 -10px; }
.dpa-dash .toast i{ font-size:1.2em; display:flex; }

/* ---------- layout ---------- */
.dpa-dash .profile-grid{ display:grid; grid-template-columns:minmax(0, .8fr) minmax(0, 1.5fr); gap:1.1em; align-items:stretch; }
.dpa-dash .card{
  position:relative; overflow:hidden; min-width:0; border-radius:1.15em;
  border:1px solid var(--dpa-border); background:var(--dpa-surface); color:var(--dpa-text);
  transition:border-color .25s, background-color .35s;
}
.dpa-dash .card::before{
  content:""; position:absolute; left:0; top:0; height:3px; width:100%; background:var(--acc, #2b7fff);
  transform:scaleX(0); transform-origin:left; transition:transform .9s cubic-bezier(.2,.8,.2,1) .25s; z-index:2;
}
.dpa-dash .card.in::before, html:not(.dpa-js) .dpa-dash .card::before{ transform:scaleX(1); }
.dpa-dash .card.photo{ --acc:#9b7bff; }
.dpa-dash .card.details{ --acc:#2b7fff; }
.dpa-dash .card-top{
  display:flex; align-items:center; gap:.65em; flex-wrap:wrap;
  padding:1.15em 1.5em; border-bottom:1px solid var(--dpa-border);
}
.dpa-dash .card-top h2{ display:flex; align-items:center; gap:.65em; font-size:1.15em; font-weight:700; letter-spacing:-.01em; }
.dpa-dash .card-top h2 i{
  width:2.3em; height:2.3em; font-size:.85em; border-radius:.7em; display:inline-flex; align-items:center; justify-content:center;
  background:var(--dpa-tile);
}
.dpa-dash .pill{
  margin-left:auto; padding:.3em .85em; border-radius:999px; font-size:.78em; font-weight:700;
  background:rgba(240,164,58,.16); color:#f0a43a;
}
:root[data-theme="light"] .dpa-dash .pill{ color:#b45f06; }
.dpa-dash .pill.blue{ background:rgba(155,123,255,.17); color:#9b7bff; }

/* ---------- photo card ---------- */
.dpa-dash .photo-body{ display:flex; flex-direction:column; align-items:center; text-align:center; gap:.2em; padding:1.8em 1.5em 1.9em; }
.dpa-dash .avatar-wrap{ position:relative; width:11em; height:11em; margin-bottom:1.1em; cursor:pointer; border-radius:50%; }
.dpa-dash .avatar-ring{
  position:absolute; inset:0; border-radius:50%; padding:5px;
  background:conic-gradient(#367dff, #9b7bff, #34d399, #367dff);
  animation:dpaSpin 9s linear infinite;
  -webkit-mask:linear-gradient(#000 0 0) content-box exclude, linear-gradient(#000 0 0);
  mask:linear-gradient(#000 0 0) content-box exclude, linear-gradient(#000 0 0);
  padding:5px;
}
.dpa-dash .avatar-inner{
  position:absolute; inset:9px; border-radius:50%; overflow:hidden; display:grid; place-items:center;
  background:linear-gradient(145deg, #426fc0, #2877d0); color:#fff;
  font-family:'Anton', sans-serif; font-size:3.2em; letter-spacing:.02em;
  transition:transform .4s cubic-bezier(.34,1.56,.64,1);
}
.dpa-dash .avatar-inner img{ width:100%; height:100%; object-fit:cover; display:block; animation:dpaPop .5s cubic-bezier(.2,.8,.2,1) both; }
.dpa-dash .avatar-cover{
  position:absolute; inset:9px; border-radius:50%; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:.3em;
  background:rgba(5,7,11,.62); color:#fff; font-size:.8em; font-weight:700; opacity:0; transition:opacity .25s; pointer-events:none;
}
.dpa-dash .avatar-cover i{ font-size:1.8em; display:flex; }
.dpa-dash .avatar-wrap.drag{ transform:scale(1.04); }
.dpa-dash .avatar-wrap.drag .avatar-cover, .dpa-dash .avatar-wrap.busy .avatar-cover{ opacity:1; }
.dpa-dash .avatar-wrap.busy .avatar-cover i{ animation:dpaSpin .8s linear infinite; }
.dpa-dash .camera-badge{
  position:absolute; right:.15em; bottom:.35em; width:2.9em; height:2.9em; border-radius:50%; z-index:3;
  display:flex; align-items:center; justify-content:center; font-size:1em;
  background:var(--dpa-twilight); color:#fff; border:3px solid var(--dpa-surface);
  transition:transform .35s cubic-bezier(.34,1.56,.64,1), background-color .2s;
}
.dpa-dash .upload-btn{
  display:inline-flex; align-items:center; justify-content:center; gap:.6em; margin:.2em 0 0; padding:.7em 1.2em;
  border-radius:.75em; border:1px solid var(--dpa-border); background:var(--dpa-surface-2); color:var(--dpa-text);
  font-family:inherit; font-size:.92em; font-weight:700; cursor:pointer;
  transition:border-color .2s, background-color .2s, transform .12s;
}
.dpa-dash .upload-btn:active{ transform:scale(.96); }
.dpa-dash .file-input{ position:absolute; width:1px; height:1px; opacity:0; overflow:hidden; pointer-events:none; }
.dpa-dash .photo-note{ max-width:17em; margin:.8em 0 1.2em; font-size:.82em; line-height:1.6; color:var(--dpa-muted); font-weight:400; }
.dpa-dash .photo-note.err{ color:var(--bad2); font-weight:600; }
.dpa-dash .who{ width:100%; padding-top:1.1em; border-top:1px solid var(--dpa-border); }
.dpa-dash .who h3{ font-size:1.25em; font-weight:700; letter-spacing:-.01em; overflow-wrap:anywhere; }
.dpa-dash .who p{ margin-top:.3em; font-size:.88em; color:var(--dpa-muted); overflow-wrap:anywhere; font-weight:500; }

/* ---------- form ---------- */
.dpa-dash .details-form{ display:flex; flex-direction:column; gap:1.25em; padding:1.5em; }
.dpa-dash .field label{
  display:block; margin-bottom:.55em; font-size:.74em; font-weight:700; letter-spacing:.09em; text-transform:uppercase; color:var(--dpa-muted);
}
.dpa-dash .field label b{ color:var(--bad2); }
.dpa-dash .input-wrap{
  display:flex; align-items:center; gap:.7em; padding:0 1em; border-radius:.75em;
  border:1.5px solid var(--dpa-border); background:var(--dpa-surface-2); transition:border-color .2s, box-shadow .2s;
}
.dpa-dash .input-wrap:focus-within{ border-color:var(--dpa-twilight); box-shadow:0 0 0 4px rgba(66,97,136,.2); }
.dpa-dash .input-wrap i{ display:flex; color:var(--dpa-muted); transition:color .2s, transform .3s cubic-bezier(.34,1.56,.64,1); }
.dpa-dash .input-wrap:focus-within i{ color:var(--dpa-link); transform:scale(1.15); }
.dpa-dash .input-wrap input{
  flex:1; min-width:0; width:100%; margin:0; padding:.95em 0; border:0; outline:0; box-shadow:none; background:transparent;
  font-family:inherit; font-size:1em; font-weight:500; color:var(--dpa-text);
}
.dpa-dash .input-wrap input::placeholder{ color:var(--dpa-muted); opacity:.8; font-weight:400; }
.dpa-dash .input-wrap:has(input:user-invalid){ border-color:var(--bad2); }
.dpa-dash .actions{ display:flex; justify-content:flex-end; padding-top:.3em; }
.dpa-dash .btn-update{
  position:relative; overflow:hidden; min-width:13em; display:inline-flex; align-items:center; justify-content:center; gap:.6em;
  padding:.95em 1.5em; border:1px solid var(--good); border-radius:.75em; background:transparent; color:var(--good);
  font-family:inherit; font-size:.95em; font-weight:700; cursor:pointer;
  transition:background-color .2s, color .2s, transform .12s, box-shadow .25s;
}
.dpa-dash .btn-update:active{ transform:scale(.96); }
.dpa-dash .btn-update.loading{ pointer-events:none; opacity:.85; }
.dpa-dash .btn-update.loading i{ animation:dpaSpin .8s linear infinite; }

/* ---------- hover: mouse only ---------- */
@media (hover:hover) and (pointer:fine){
  .dpa-dash .card:hover{ border-color:var(--acc); }
  .dpa-dash .avatar-wrap:hover .avatar-cover{ opacity:1; }
  .dpa-dash .avatar-wrap:hover .avatar-inner{ transform:scale(1.04); }
  .dpa-dash .avatar-wrap:hover .camera-badge{ transform:rotate(-10deg) scale(1.12); background:var(--dpa-link); }
  .dpa-dash .upload-btn:hover{ border-color:var(--dpa-twilight); background:var(--dpa-hover); }
  .dpa-dash .input-wrap:hover{ border-color:var(--dpa-twilight); }
  .dpa-dash .btn-update:hover{ background:var(--good); color:#fff; box-shadow:0 8px 20px rgba(31,157,85,.35); }
}
.dpa-dash .upload-btn:focus-visible, .dpa-dash .btn-update:focus-visible,
.dpa-dash .avatar-wrap:focus-visible{ outline:2px solid var(--dpa-link); outline-offset:3px; }

/* ---------- responsive ---------- */
@media (max-width:900px){ .dpa-dash .profile-grid{ grid-template-columns:minmax(0, 1fr); } }
@media (max-width:700px){
  .dpa-dash{ gap:1.15em; }
  .dpa-dash .page-header{ padding:1.4em 1.3em; }
  .dpa-dash .hero-left{ gap:.9em; }
  .dpa-dash .hero-watermark{ font-size:6.5em; }
  .dpa-dash .card-top{ padding:1em 1.1em; }
  .dpa-dash .details-form{ padding:1.2em 1.1em; }
  .dpa-dash .actions{ justify-content:stretch; }
  .dpa-dash .btn-update{ width:100%; }
}
@media print{ .main-content{ margin-left:0; padding:0; } .dpa-dash .actions, .dpa-dash .upload-btn{ display:none; } }
@media (prefers-reduced-motion: reduce){
  .dpa-dash *, .dpa-dash *::before, .dpa-dash *::after{ animation:none !important; transition:none !important; }
  .dpa-js .dpa-dash .reveal{ opacity:1; }
  .dpa-dash .card::before{ transform:scaleX(1); }
}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

<div class="main-content">
  <div class="dpa-dash">

    <% if ("1".equals(success)) { %>
      <div class="toast ok" id="toast" role="status"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg></i> Profile updated successfully!</div>
    <% } else if (error != null) { %>
      <div class="toast err" id="toast" role="alert"><i aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg></i> Could not update your profile. Please try again.</div>
    <% } %>

    <!-- HERO -->
    <div class="page-header">
      <span class="hero-watermark" aria-hidden="true">Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp; Digital Purohit &nbsp;&middot;&nbsp;</span>
      <div class="hero-left">
        <div class="hero-icon"><i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i></div>
        <div>
          <h1>My Profile</h1>
          <p>Update your personal details and profile photo.</p>
        </div>
      </div>
    </div>

    <form action="${pageContext.request.contextPath}/update-profile" method="post" enctype="multipart/form-data" id="profileForm">
      <div class="profile-grid">

        <!-- PHOTO -->
        <section class="card photo reveal">
          <div class="card-top">
            <h2><i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="18" height="18" x="3" y="3" rx="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-3.1-3.1a2 2 0 0 0-2.8 0L6 21"/></svg></i> Profile Photo</h2>
            <span class="pill blue">JPG, PNG or WebP</span>
          </div>
          <div class="photo-body">
            <div class="avatar-wrap" id="avatarWrap" tabindex="0" role="button" aria-label="Change profile photo">
              <span class="avatar-ring" aria-hidden="true"></span>
              <div class="avatar-inner" id="avatarPreview">
                <c:choose>
                  <c:when test="${not empty admin.profileImage}">
                    <img src="${pageContext.request.contextPath}/uploads/${admin.profileImage}" alt="Profile photo">
                  </c:when>
                  <c:otherwise><%= initials %></c:otherwise>
                </c:choose>
              </div>
              <span class="avatar-cover" aria-hidden="true">
                <i><svg viewBox="0 0 24 24" id="coverIcon"><path d="M12 3v12M7 8l5-5 5 5M5 21h14"/></svg></i>
                <span id="coverText">Click to upload</span>
              </span>
              <span class="camera-badge" aria-hidden="true"><i><svg viewBox="0 0 24 24"><path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3z"/><circle cx="12" cy="13" r="3"/></svg></i></span>
            </div>

            <button type="button" class="upload-btn" id="uploadBtn">
              <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><path d="m17 8-5-5-5 5"/><path d="M12 3v12"/></svg></i> Upload Photo
            </button>
            <input class="file-input" type="file" id="profileImageInput" name="image"
                   accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp" tabindex="-1">
            <p class="photo-note" id="photoNote">Pick a photo (max 5 MB) and it uploads right away. You can also drop an image on the circle.</p>

            <div class="who">
              <h3><c:out value="${admin.name}"/></h3>
              <p><c:out value="${admin.email}"/></p>
            </div>
          </div>
        </section>

        <!-- DETAILS -->
        <section class="card details reveal" style="--d:90ms">
          <div class="card-top">
            <h2><i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="18" height="18" x="3" y="3" rx="2"/><path d="M7 8h10M7 12h10M7 16h6"/></svg></i> Personal Details</h2>
            <span class="pill">All fields are required</span>
          </div>
          <div class="details-form">
            <div class="field">
              <label for="profileName">Name <b>*</b></label>
              <div class="input-wrap">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></i>
                <input type="text" id="profileName" name="name" value="<c:out value='${admin.name}'/>" placeholder="Enter your name" required maxlength="100" autocomplete="name">
              </div>
            </div>
            <div class="field">
              <label for="profileEmail">Email <b>*</b></label>
              <div class="input-wrap">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg></i>
                <input type="email" id="profileEmail" name="email" value="<c:out value='${admin.email}'/>" placeholder="Enter your email" required maxlength="150" autocomplete="email">
              </div>
            </div>
            <div class="field">
              <label for="profilePhone">Phone <b>*</b></label>
              <div class="input-wrap">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.8 19.8 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.8 19.8 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.36 1.9.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.9.34 1.85.57 2.81.7A2 2 0 0 1 22 16.92z"/></svg></i>
                <input type="tel" id="profilePhone" name="phone" value="<c:out value='${admin.phone}'/>" placeholder="Enter your phone number" required maxlength="20" autocomplete="tel">
              </div>
            </div>
            <div class="actions">
              <button type="submit" class="btn-update" id="saveBtn">
                <i aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><path d="M17 21v-8H7v8M7 3v5h8"/></svg></i> Update Profile
              </button>
            </div>
          </div>
        </section>

      </div>
    </form>
  </div>
</div>

<script>
(function () {
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var MAX = 5 * 1024 * 1024;

  /* ---------- scroll reveal ---------- */
  var targets = document.querySelectorAll('.dpa-dash .reveal');
  if (!('IntersectionObserver' in window)) {
    targets.forEach(function (t) { t.classList.add('in'); });
  } else {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (en) {
        if (en.isIntersecting) { en.target.classList.add('in'); io.unobserve(en.target); }
      });
    }, { threshold: 0.1, rootMargin: '0px 0px -30px 0px' });
    targets.forEach(function (t) { io.observe(t); });
  }

  /* ---------- toast auto-hide ---------- */
  var toast = document.getElementById('toast');
  if (toast) {
    setTimeout(function () {
      toast.classList.add('hide');
      setTimeout(function () { toast.style.display = 'none'; }, 500);
    }, 4500);
    try { // keep ?success=1 from re-showing on refresh
      var u = new URL(window.location.href);
      if (u.searchParams.has('success') || u.searchParams.has('error')) {
        u.searchParams.delete('success'); u.searchParams.delete('error');
        history.replaceState(null, '', u.pathname + (u.search || ''));
      }
    } catch (e) {}
  }

  /* ---------- photo upload ---------- */
  var form    = document.getElementById('profileForm');
  var input   = document.getElementById('profileImageInput');
  var preview = document.getElementById('avatarPreview');
  var wrap    = document.getElementById('avatarWrap');
  var btn     = document.getElementById('uploadBtn');
  var note    = document.getElementById('photoNote');
  var cover   = document.getElementById('coverText');
  var saveBtn = document.getElementById('saveBtn');
  var defaultNote = note.textContent;
  var submitting = false;

  function fail(msg) {
    note.textContent = msg; note.classList.add('err');
    input.value = '';
  }

  function submitForm() {
    if (submitting) return;
    submitting = true;
    wrap.classList.add('busy');
    cover.textContent = 'Uploading…';
    note.classList.remove('err');
    note.textContent = 'Uploading your photo…';
    saveBtn.classList.add('loading');
    if (form.requestSubmit) form.requestSubmit(); else form.submit();
    // if the browser blocked submit (e.g. a required field is empty), recover the UI
    setTimeout(function () {
      if (!document.hidden && !form.checkValidity()) {
        submitting = false; wrap.classList.remove('busy'); saveBtn.classList.remove('loading');
        cover.textContent = 'Click to upload';
        note.textContent = 'Fill in all required fields, then press Update Profile to save your photo.';
      }
    }, 300);
  }

  function handleFile(file) {
    if (!file) return;
    var okType = /^image\/(jpeg|png|webp)$/.test(file.type) || /\.(jpe?g|png|webp)$/i.test(file.name);
    if (!okType) { fail('Please choose a JPG, PNG or WebP image.'); return; }
    if (file.size > MAX) { fail('That image is over 5 MB. Please choose a smaller one.'); return; }

    var reader = new FileReader();
    reader.onload = function (ev) {
      preview.innerHTML = '';
      var img = document.createElement('img');
      img.src = ev.target.result;
      img.alt = 'Selected profile photo preview';
      preview.appendChild(img);
      submitForm();                      // upload straight away
    };
    reader.onerror = function () { fail('Could not read that file. Please try another image.'); };
    reader.readAsDataURL(file);
  }

  function openPicker() { note.classList.remove('err'); note.textContent = defaultNote; input.click(); }

  btn.addEventListener('click', openPicker);
  wrap.addEventListener('click', openPicker);
  wrap.addEventListener('keydown', function (e) {
    if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); openPicker(); }
  });
  input.addEventListener('change', function () { handleFile(this.files && this.files[0]); });

  /* drag & drop onto the avatar */
  ['dragenter', 'dragover'].forEach(function (ev) {
    wrap.addEventListener(ev, function (e) { e.preventDefault(); wrap.classList.add('drag'); cover.textContent = 'Drop to upload'; });
  });
  ['dragleave', 'drop'].forEach(function (ev) {
    wrap.addEventListener(ev, function (e) { e.preventDefault(); wrap.classList.remove('drag'); cover.textContent = 'Click to upload'; });
  });
  wrap.addEventListener('drop', function (e) {
    var f = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0];
    if (!f) return;
    try { var dt = new DataTransfer(); dt.items.add(f); input.files = dt.files; } catch (err) {}
    handleFile(f);
  });

  /* ---------- manual save button feedback ---------- */
  form.addEventListener('submit', function () {
    if (form.checkValidity()) {
      saveBtn.classList.add('loading');
      saveBtn.querySelector('i').innerHTML =
        '<svg viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-6.2-8.55"/></svg>';
    }
  });

  /* returning with the back button must not leave things stuck */
  window.addEventListener('pageshow', function (e) {
    if (!e.persisted) return;
    submitting = false; wrap.classList.remove('busy'); saveBtn.classList.remove('loading');
  });
})();
</script>
</body>
</html>
