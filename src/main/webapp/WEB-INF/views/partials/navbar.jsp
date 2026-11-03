<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>

<%@ page import="com.digitalpurohit.dao.NotificationDAO" %>
<%@ page import="com.digitalpurohit.dao.impl.NotificationDAOImpl" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
Integer adminId = (Integer) session.getAttribute("adminId");
int unreadCount = 0;
if (adminId != null) {
    NotificationDAO dao = new NotificationDAOImpl();
    unreadCount = dao.getUnreadCount(adminId);
}
%>

<!-- =========================================================
     FONT AWESOME (shared with sidebar — safe to include once)
========================================================= -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<!-- =========================================================
     GOOGLE FONTS — Inter + Caveat (same as sidebar)
========================================================= -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap" rel="stylesheet">

<!-- =========================================================
     EXTERNAL POPUP CSS (kept as-is)
========================================================= -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/notification.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/notification-popup.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reminder-popup.css">

<!-- =========================================================
     NAVBAR CSS — fully self-contained, uses same design tokens
     as sidebar.jsp so both respond to the same data-theme attr.
========================================================= -->
<style>
/* -----------------------------------------------------------------
   DESIGN TOKENS (mirrors sidebar.jsp exactly — only defined once
   per page; safe to redeclare here because they are identical)
----------------------------------------------------------------- */
:root {
    --dpa-sidebar-w: 260px;
    --dpa-bad:       #d64545;
    --dpa-twilight:  #426188;
    --dpa-link:      #2b7fff;
}

/* DARK (default) */
:root,
:root[data-theme="dark"] {
    --dpa-bg:          #050608;
    --dpa-surface:     #10141c;
    --dpa-surface-2:   #161b26;
    --dpa-text:        #f5f5f5;
    --dpa-muted:       rgba(255,255,255,.58);
    --dpa-border:      rgba(255,255,255,.09);
    --dpa-sb-bg:       #080a0f;
    --dpa-hover:       rgba(255,255,255,.06);
    --dpa-tile:        rgba(255,255,255,.07);
    --dpa-active-bg:   #f5f5f5;
    --dpa-active-text: #1b1b1b;
    --dpa-scroll:      rgba(255,255,255,.18);
    --dpa-mobile-bar:  rgba(8,10,15,.88);
    color-scheme: dark;
}

/* LIGHT */
:root[data-theme="light"] {
    --dpa-bg:          #f1f4f9 !important;
    --dpa-surface:     #ffffff !important;
    --dpa-surface-2:   #f5f5f5 !important;
    --dpa-text:        #1b1b1b !important;
    --dpa-muted:       #6b7280 !important;
    --dpa-border:      rgba(0,0,0,.09) !important;
    --dpa-sb-bg:       #ffffff !important;
    --dpa-hover:       rgba(0,0,0,.045) !important;
    --dpa-tile:        rgba(0,0,0,.05) !important;
    --dpa-active-bg:   #1b1b1b !important;
    --dpa-active-text: #ffffff !important;
    --dpa-scroll:      rgba(0,0,0,.18) !important;
    --dpa-mobile-bar:  rgba(255,255,255,.92) !important;
    color-scheme: light;
}

/* Ensure html/body itself responds to theme switch */
html[data-theme="dark"]  { background: #050608; color: #f5f5f5; }
html[data-theme="light"] { background: #f1f4f9; color: #1b1b1b; }
body {
    background: var(--dpa-bg);
    color: var(--dpa-text);
    transition: background-color .35s ease, color .35s ease;
}

/* Responsive sidebar width override for mobile */
@media (max-width:900px),(max-width:1100px) and (max-height:520px) {
    :root { --dpa-sidebar-w: 0px; }
}

/* -----------------------------------------------------------------
   NAVBAR SHELL
----------------------------------------------------------------- */
.dpa-navbar {
    position: fixed;
    top: 0;
    left: var(--dpa-sidebar-w);
    right: 0;
    z-index: 900;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    padding: 0 24px 0 20px;

    background: var(--dpa-sb-bg);
    border-bottom: 1px solid var(--dpa-border);
    -webkit-backdrop-filter: blur(14px);
    backdrop-filter: blur(14px);

    font-family: 'Inter', ui-sans-serif, system-ui, sans-serif;
    font-size: 14px;
    font-weight: 500;
    color: var(--dpa-text);
    box-sizing: border-box;
    -webkit-font-smoothing: antialiased;

    transition:
        background-color .35s ease,
        border-color     .35s ease,
        left             .3s  ease,
        color            .35s ease;
}

/* Mobile: navbar starts from left=0 because sidebar is a drawer */
@media (max-width:900px),(max-width:1100px) and (max-height:520px) {
    .dpa-navbar {
        left: 0;
        height: 0;        /* hidden — sidebar.jsp already provides a mobile bar */
        overflow: hidden;
        border: none;
        padding: 0;
        pointer-events: none;
    }
}

/* -----------------------------------------------------------------
   LEFT SECTION — breadcrumb / page title
----------------------------------------------------------------- */
.dpa-navbar-left {
    display: flex;
    align-items: center;
    gap: 14px;
    min-width: 0;
    flex: 1;
}

.dpa-navbar-logo {
    display: none; /* shown only on tablet when sidebar is collapsed */
    align-items: center;
    gap: 10px;
    font-weight: 700;
    font-size: 15px;
    letter-spacing: -.01em;
    white-space: nowrap;
    color: var(--dpa-text);
    text-decoration: none;
}
.dpa-navbar-logo em {
    font-family: 'Caveat', cursive;
    font-style: italic;
    font-weight: 600;
    font-size: 20px;
    color: var(--dpa-twilight);
}

/* Breadcrumb / page title */
.dpa-breadcrumb {
    display: flex;
    align-items: center;
    gap: 8px;
    min-width: 0;
    flex-wrap: wrap;
}
.dpa-breadcrumb-home {
    color: var(--dpa-muted);
    font-size: 13px;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 5px;
    transition: color .2s;
    white-space: nowrap;
}
.dpa-breadcrumb-home:hover { color: var(--dpa-text); }
.dpa-breadcrumb-sep {
    color: var(--dpa-muted);
    font-size: 12px;
    flex-shrink: 0;
}
.dpa-breadcrumb-current {
    font-size: 14px;
    font-weight: 600;
    color: var(--dpa-text);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* -----------------------------------------------------------------
   RIGHT SECTION
----------------------------------------------------------------- */
.dpa-navbar-right {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-shrink: 0;
}

/* ----- Date/time pill ----- */
.dpa-datetime {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    line-height: 1.25;
    margin-right: 6px;
}
.dpa-datetime-date {
    font-size: 11.5px;
    font-weight: 600;
    color: var(--dpa-text);
    white-space: nowrap;
}
.dpa-datetime-time {
    font-size: 11px;
    color: var(--dpa-muted);
    white-space: nowrap;
    font-variant-numeric: tabular-nums;
}

/* Hide date on very small desktops to save room */
@media (max-width:1100px) {
    .dpa-datetime { display: none; }
}

/* ----- Icon button base ----- */
.dpa-nav-btn {
    position: relative;
    width: 40px;
    height: 40px;
    flex-shrink: 0;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 10px;
    background: var(--dpa-tile);
    border: 1px solid var(--dpa-border);
    color: var(--dpa-muted);
    cursor: pointer;
    font-size: 15px;
    text-decoration: none;
    transition:
        background-color .2s,
        color            .2s,
        border-color     .2s,
        transform        .15s;
}
.dpa-nav-btn:hover {
    background: var(--dpa-hover);
    color: var(--dpa-text);
    border-color: var(--dpa-twilight);
}
.dpa-nav-btn:active { transform: scale(.93); }
.dpa-nav-btn:focus-visible {
    outline: 2px solid var(--dpa-link);
    outline-offset: 2px;
}

/* ----- Notification bell animation ----- */
.dpa-nav-btn.bell-btn:hover i {
    animation: dpaNavBell .7s ease;
}
@keyframes dpaNavBell {
    0%,100% { transform: rotate(0);     }
    20%     { transform: rotate(-18deg);}
    40%     { transform: rotate(14deg); }
    60%     { transform: rotate(-9deg); }
    80%     { transform: rotate(5deg);  }
}

/* ----- Notification badge ----- */
.dpa-nav-badge {
    position: absolute;
    top: 5px;
    right: 5px;
    min-width: 17px;
    height: 17px;
    padding: 0 4px;
    border-radius: 999px;
    background: var(--dpa-bad);
    color: #fff;
    font-size: 10px;
    font-weight: 700;
    line-height: 17px;
    text-align: center;
    pointer-events: none;
    animation: dpaNavBadgePulse 2.2s ease-out infinite;
}
@keyframes dpaNavBadgePulse {
    0%       { box-shadow: 0 0 0 0   rgba(214,69,69,.65); }
    70%,100% { box-shadow: 0 0 0 8px rgba(214,69,69,0);   }
}

/* ----- Search bar (optional, hidden on small screens) ----- */
.dpa-search-wrap {
    position: relative;
    flex-shrink: 1;
}
.dpa-search {
    height: 38px;
    width: 200px;
    padding: 0 14px 0 36px;
    border-radius: 10px;
    border: 1px solid var(--dpa-border);
    background: var(--dpa-tile);
    color: var(--dpa-text);
    font-family: inherit;
    font-size: 13px;
    outline: none;
    transition: border-color .2s, background-color .2s, width .3s;
}
.dpa-search::placeholder { color: var(--dpa-muted); }
.dpa-search:focus {
    border-color: var(--dpa-twilight);
    background: var(--dpa-surface);
    width: 260px;
}
.dpa-search-icon {
    position: absolute;
    left: 11px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--dpa-muted);
    font-size: 13px;
    pointer-events: none;
}
@media (max-width:1280px) { .dpa-search-wrap { display: none; } }

/* ----- Profile avatar ----- */
.dpa-nav-profile {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    overflow: hidden;
    border: 2px solid var(--dpa-border);
    flex-shrink: 0;
    cursor: pointer;
    transition: border-color .2s, transform .15s;
    text-decoration: none;
}
.dpa-nav-profile:hover {
    border-color: var(--dpa-twilight);
    transform: scale(1.05);
}
.dpa-nav-profile img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}
.dpa-nav-avatar-text {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: var(--dpa-twilight);
    color: #fff;
    font-size: 13px;
    font-weight: 700;
    letter-spacing: .04em;
}

/* ----- Divider ----- */
.dpa-nav-divider {
    width: 1px;
    height: 24px;
    background: var(--dpa-border);
    border-radius: 2px;
    flex-shrink: 0;
    margin: 0 2px;
}

/* -----------------------------------------------------------------
   CONTENT PUSH — leave room below the navbar
   Add this class to your page wrapper element
----------------------------------------------------------------- */
.dpa-page-content {
    padding-top: 64px;
    margin-left: var(--dpa-sidebar-w);
    transition: margin-left .3s, padding-top .3s;
    box-sizing: border-box;
}
@media (max-width:900px),(max-width:1100px) and (max-height:520px) {
    .dpa-page-content {
        margin-left: 0;
        padding-top: calc(56px + env(safe-area-inset-top,0px));
    }
}

/* -----------------------------------------------------------------
   LARGE MONITORS — scale up to match sidebar
----------------------------------------------------------------- */
@media (min-width:1700px) {
    :root { --dpa-sidebar-w: 296px; }
    .dpa-navbar { height: 68px; padding: 0 30px 0 24px; font-size: 15px; }
    .dpa-datetime-date { font-size: 12.5px; }
    .dpa-datetime-time { font-size: 12px; }
    .dpa-nav-btn { width: 44px; height: 44px; font-size: 16px; }
    .dpa-nav-profile { width: 44px; height: 44px; }
    .dpa-search { height: 42px; font-size: 14px; }
    .dpa-page-content { padding-top: 68px; }
}
@media (min-width:2400px) {
    :root { --dpa-sidebar-w: 360px; }
    .dpa-navbar { height: 76px; padding: 0 36px 0 30px; font-size: 17px; }
    .dpa-nav-btn { width: 50px; height: 50px; font-size: 18px; border-radius: 12px; }
    .dpa-nav-profile { width: 50px; height: 50px; }
    .dpa-breadcrumb-current { font-size: 16px; }
    .dpa-page-content { padding-top: 76px; }
}
@media (min-width:3200px) {
    :root { --dpa-sidebar-w: 460px; }
    .dpa-navbar { height: 90px; padding: 0 44px 0 38px; font-size: 21px; }
    .dpa-nav-btn { width: 60px; height: 60px; font-size: 22px; border-radius: 15px; }
    .dpa-nav-profile { width: 60px; height: 60px; }
    .dpa-breadcrumb-current { font-size: 20px; }
    .dpa-page-content { padding-top: 90px; }
}

/* -----------------------------------------------------------------
   PRINT — hide navbar
----------------------------------------------------------------- */
@media print {
    .dpa-navbar { display: none !important; }
    .dpa-page-content { margin-left: 0 !important; padding-top: 0 !important; }
}

/* -----------------------------------------------------------------
   SMOOTH THEME TRANSITION (matches sidebar.jsp)
----------------------------------------------------------------- */
html.dpa-theme-anim .dpa-navbar,
html.dpa-theme-anim .dpa-navbar * {
    transition:
        background-color .35s,
        color            .35s,
        border-color     .35s !important;
}
</style>


<!-- =========================================================
     NAVBAR HTML
========================================================= -->
<nav class="dpa-navbar" id="dpaNavbar" role="navigation" aria-label="Top navigation">

    <!-- ── LEFT: breadcrumb ── -->
    <div class="dpa-navbar-left">

        <!-- Mini logo shown only when sidebar is hidden (tablet portrait) -->
        <a href="${pageContext.request.contextPath}/dashboard" class="dpa-navbar-logo" id="dpaNavLogo">
            🛕 Digital Purohit <em>Assistant</em>
        </a>

        <!-- Breadcrumb -->
        <div class="dpa-breadcrumb" id="dpaBreadcrumb">
            <a href="${pageContext.request.contextPath}/dashboard" class="dpa-breadcrumb-home">
                <i class="fa-solid fa-house"></i>
                Home
            </a>
            <span class="dpa-breadcrumb-sep"><i class="fa-solid fa-chevron-right" style="font-size:10px;"></i></span>
            <span class="dpa-breadcrumb-current" id="dpaPageTitle">Dashboard</span>
        </div>

    </div>

    <!-- ── RIGHT: search · date/time · bell · profile ── -->
    <div class="dpa-navbar-right">

        <!-- Search (hidden on narrow desktops) -->
        <div class="dpa-search-wrap">
            <i class="fa-solid fa-magnifying-glass dpa-search-icon"></i>
            <input
                type="search"
                class="dpa-search"
                id="dpaNavSearch"
                placeholder="Search…"
                aria-label="Site search"
                autocomplete="off">
        </div>

        <!-- Date / Time -->
        <div class="dpa-datetime" id="dpaNavDateTime">
            <span class="dpa-datetime-date" id="dpaNavDate">—</span>
            <span class="dpa-datetime-time" id="dpaNavTime">—</span>
        </div>

        <div class="dpa-nav-divider"></div>

        <!-- Notification Bell -->
        <button
            type="button"
            class="dpa-nav-btn bell-btn"
            id="dpaNavBell"
            onclick="openNotifications()"
            aria-label="Open notifications"
            title="Notifications">

            <i class="fa-solid fa-bell"></i>

            <% if (unreadCount > 0) { %>
                <span class="dpa-nav-badge" id="dpaNavBadge"><%= unreadCount %></span>
            <% } %>

        </button>

        <!-- Profile -->
        <a
            href="${pageContext.request.contextPath}/profile"
            class="dpa-nav-profile"
            id="dpaNavProfile"
            title="Your profile"
            aria-label="Go to your profile">

            <c:choose>
                <c:when test="${not empty sessionScope.profileImage}">
                    <img
                        src="${pageContext.request.contextPath}/uploads/${sessionScope.profileImage}?v=<%= System.currentTimeMillis() %>"
                        alt="Profile photo">
                </c:when>
                <c:otherwise>
                    <div class="dpa-nav-avatar-text">
                        ${sessionScope.adminName.substring(0,2).toUpperCase()}
                    </div>
                </c:otherwise>
            </c:choose>

        </a>

    </div>

</nav>


<!-- =========================================================
     REMINDER POPUP (kept from original navbar.jsp)
========================================================= -->
<div id="reminderPopupOverlay" class="reminder-popup-overlay">
    <div id="reminderPopup" class="reminder-popup">

        <div class="reminder-popup-icon" id="reminderPopupIcon">
            <i class="fa-solid fa-bell"></i>
        </div>

        <div class="reminder-popup-content">

            <div class="reminder-popup-type" id="reminderPopupType">REMINDER</div>

            <h2 id="reminderPopupTitle">Reminder</h2>

            <p id="reminderPopupMessage">You have a reminder.</p>

            <div class="reminder-popup-time">
                <i class="fa-regular fa-clock"></i>
                <span id="reminderPopupTime">--</span>
            </div>

        </div>

        <div class="reminder-popup-actions">
            <button type="button" class="reminder-view-btn" id="reminderViewDetailsBtn">
                <i class="fa-solid fa-eye"></i> View Details
            </button>
            <button type="button" class="reminder-dismiss-btn" id="reminderDismissBtn">
                <i class="fa-solid fa-check"></i> Dismiss
            </button>
        </div>

    </div>
</div>


<!-- =========================================================
     NAVBAR JAVASCRIPT
========================================================= -->
<script>
(function () {

    var root = document.documentElement;
    var KEY  = 'dpa-theme';

    /* ----------------------------------------------------------
       1. THEME SYNC — THREE-LAYER APPROACH
       Layer A: MutationObserver (most reliable — watches the
                actual html[data-theme] attr the sidebar sets)
       Layer B: Custom event (same-page instant signal)
       Layer C: storage event (cross-tab sync)
    ---------------------------------------------------------- */
    function applyTheme(t) {
        var theme = (t === 'light') ? 'light' : 'dark';
        if (root.getAttribute('data-theme') !== theme) {
            root.setAttribute('data-theme', theme);
        }
    }

    /* Layer A — MutationObserver: watches data-theme changes
       on <html> directly. Fires even if the sidebar sets it
       without dispatching any event. This is the catch-all. */
    if (window.MutationObserver) {
        var themeObserver = new MutationObserver(function (mutations) {
            mutations.forEach(function (m) {
                if (m.attributeName === 'data-theme') {
                    /* Attribute already applied — just keep localStorage in sync */
                    try {
                        var cur = root.getAttribute('data-theme') || 'dark';
                        localStorage.setItem(KEY, cur);
                    } catch (_) {}
                }
            });
        });
        themeObserver.observe(root, { attributes: true, attributeFilter: ['data-theme'] });
    }

    /* Layer B — sidebar dispatches this custom event */
    window.addEventListener('dpa-theme-change', function (e) {
        if (e && e.detail && e.detail.theme) applyTheme(e.detail.theme);
    });

    /* Layer C — another browser tab toggled the theme */
    window.addEventListener('storage', function (e) {
        if (e.key === KEY && e.newValue) applyTheme(e.newValue);
    });

    /* Apply saved preference immediately on page load */
    (function () {
        try {
            var stored = localStorage.getItem(KEY);
            if (stored) applyTheme(stored);
        } catch (_) {}
    })();


    /* ----------------------------------------------------------
       2. LIVE DATE / TIME
    ---------------------------------------------------------- */
    var dateEl = document.getElementById('dpaNavDate');
    var timeEl = document.getElementById('dpaNavTime');

    function updateClock() {
        var now   = new Date();
        var dOpts = { weekday:'short', day:'2-digit', month:'short', year:'numeric' };
        if (dateEl) dateEl.textContent = now.toLocaleDateString('en-IN', dOpts);
        if (timeEl) timeEl.textContent = now.toLocaleTimeString('en-IN', { hour12: true });
    }
    updateClock();
    setInterval(updateClock, 1000);


    /* ----------------------------------------------------------
       3. AUTO BREADCRUMB — reads the page <h1> or <title>
    ---------------------------------------------------------- */
    var titleEl = document.getElementById('dpaPageTitle');
    if (titleEl) {
        document.addEventListener('DOMContentLoaded', function () {
            var h1  = document.querySelector('main h1, .dpa-page-content h1, h1');
            var src = (h1 && h1.textContent.trim()) ||
                      document.title.replace(/\s*[|\-\u2013]\s*Digital Purohit.*$/i, '').trim() ||
                      'Dashboard';
            titleEl.textContent = src;
        });
    }


    /* ----------------------------------------------------------
       4. MINI-LOGO — show when sidebar drawer is off-screen
    ---------------------------------------------------------- */
    var logo = document.getElementById('dpaNavLogo');
    var mq   = window.matchMedia('(max-width:900px),(max-width:1100px) and (max-height:520px)');

    function syncLogo() {
        if (!logo) return;
        logo.style.display = mq.matches ? 'none' : '';
    }
    syncLogo();
    if (mq.addEventListener) mq.addEventListener('change', syncLogo);
    else                      mq.addListener(syncLogo);


    /* ----------------------------------------------------------
       5. SEARCH — Ctrl+K / Cmd+K shortcut
    ---------------------------------------------------------- */
    document.addEventListener('keydown', function (e) {
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            var s = document.getElementById('dpaNavSearch');
            if (s) { s.focus(); s.select(); }
        }
    });

})();
</script>
