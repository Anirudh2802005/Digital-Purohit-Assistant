
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login | Digital Purohit Assistant</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Anton&family=Caveat:wght@500;600&display=swap" rel="stylesheet">

<style>
:root {
    --white: #ffffff;
    --haze: #f5f5f5;
    --ink: #1b1b1b;
    --black: #000000;
    --blue: #426188;
    --signal-blue: #2b7fff;
    --font: 'Inter', system-ui, sans-serif;
    --display: 'Anton', sans-serif;
    --script: 'Caveat', cursive;
    --bad: #d64545;
}

* { box-sizing: border-box; }

html, body {
    margin: 0;
    min-height: 100%;
}

body {
    background: var(--black);
    color: var(--white);
    font-family: var(--font);
    font-weight: 500;
    -webkit-font-smoothing: antialiased;
    overflow-x: hidden;
}

a { color: inherit; text-decoration: none; }
button { font-family: inherit; }
::selection { background: var(--blue); color: white; }

.ic {
    width: 1em;
    height: 1em;
    fill: none;
    stroke: currentColor;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
}

/* Background */
.stage {
    position: relative;
    min-height: 100vh;
    overflow: hidden;
    display: flex;
    align-items: center;
    background: radial-gradient(ellipse at 50% 15%, #10151f 0%, #000 62%);
}

.glass {
    position: absolute;
    border-radius: 50%;
    filter: blur(50px);
    opacity: .55;
    mix-blend-mode: screen;
    pointer-events: none;
    animation: float 14s ease-in-out infinite;
}

.glass-a {
    width: 560px;
    height: 560px;
    top: -160px;
    left: 4%;
    background: radial-gradient(circle at 30% 30%,
        rgba(66,97,136,.95), transparent 70%);
}

.glass-b {
    width: 680px;
    height: 680px;
    bottom: -240px;
    right: 2%;
    animation-delay: -5s;
    background: radial-gradient(circle at 60% 40%,
        rgba(255,255,255,.32), transparent 70%);
}

.glass-c {
    width: 400px;
    height: 400px;
    top: 34%;
    left: 42%;
    animation-delay: -9s;
    background: radial-gradient(circle at 50% 50%,
        rgba(43,127,255,.35), transparent 70%);
}

@keyframes float {
    0%, 100% { transform: translate(0,0) scale(1); }
    50% { transform: translate(-26px,30px) scale(1.07); }
}

.marquee {
    position: absolute;
    left: 0;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    white-space: nowrap;
    pointer-events: none;
    user-select: none;
    z-index: 0;
    font-family: var(--display);
    font-size: clamp(120px, 24vw, 340px);
    line-height: .85;
    color: transparent;
    -webkit-text-stroke: 1px rgba(255,255,255,.09);
    animation: drift 40s linear infinite;
}

@keyframes drift {
    from { transform: translate(0,-50%); }
    to { transform: translate(-50%,-50%); }
}

.spotlight {
    position: fixed;
    width: 520px;
    height: 520px;
    border-radius: 50%;
    left: 0;
    top: 0;
    pointer-events: none;
    z-index: 1;
    background: radial-gradient(circle,
        rgba(255,255,255,.07), transparent 65%);
    transform: translate(-50%,-50%);
    opacity: 0;
    transition: opacity .4s;
}

/* Navigation */
.top {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    z-index: 5;
    height: 72px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 32px;
}

.logo {
    font-size: 15px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 10px;
}

.logo .mark {
    width: 32px;
    height: 32px;
    border-radius: 9px;
    border: 1px solid rgba(255,255,255,.6);
    display: flex;
    align-items: center;
    justify-content: center;
}

.logo .mark .ic { width: 16px; height: 16px; }

.logo .accent {
    font-family: var(--script);
    font-style: italic;
    font-size: 19px;
    color: var(--blue);
}

.back {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    border: 1px solid var(--white);
    border-radius: 8px;
    padding: 8px 14px;
    transition: background .2s, color .2s;
}

.back .ic { width: 14px; height: 14px; }

.back:hover {
    background: var(--white);
    color: var(--ink);
}

/* Layout */
.content {
    position: relative;
    z-index: 2;
    width: 100%;
    max-width: 1150px;
    margin: 0 auto;
    padding: 96px 24px 56px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 36px;
}

.brand { text-align: center; }

.brand h1 {
    font-family: var(--display);
    font-weight: 900;
    text-transform: uppercase;
    font-size: clamp(52px, 9vw, 120px);
    line-height: .9;
    margin: 0;
}

/* Login card */
.card-wrap { perspective: 1100px; }

.card {
    background: var(--haze);
    color: var(--ink);
    border-radius: 12px;
    padding: 34px 30px;
    width: 100%;
    max-width: 430px;
    margin: 0 auto;
    transition: transform .15s ease-out;
}

.card h2 {
    font-size: 26px;
    font-weight: 700;
    margin: 0 0 6px;
}

.card h2 .accent {
    font-family: var(--script);
    font-style: italic;
    color: var(--blue);
    font-size: 1.1em;
}

.card .lead {
    margin: 0 0 22px;
    font-size: 14px;
    color: #666;
    font-weight: 400;
}

/* Error message from LoginServlet */
.error-message {
    display: flex;
    align-items: center;
    gap: 10px;
    background: #fdecec;
    color: var(--bad);
    border: 1px solid #f6c6c6;
    border-radius: 6px;
    padding: 10px 14px;
    font-size: 13px;
    margin-bottom: 16px;
    overflow-wrap: anywhere;
    animation: shake .4s ease;
}

@keyframes shake {
    10%, 90% { transform: translateX(-1px); }
    20%, 80% { transform: translateX(2px); }
    30%, 50%, 70% { transform: translateX(-4px); }
    40%, 60% { transform: translateX(4px); }
}

/* Google sign-in */
.google-note {
    margin-top: 10px;
    padding: 10px 12px;
    font-size: 12.5px;
    color: #8a5a00;
    background: #fff6e0;
    border: 1px solid #f1dca6;
    border-radius: 6px;
}

.google-login-wrapper { min-height: 44px; }

.google-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    width: 100%;
    background: white;
    color: var(--ink);
    border: 1px solid var(--ink);
    border-radius: 8px;
    padding: 12px 16px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: transform .12s, box-shadow .2s;
}

.google-btn:hover {
    box-shadow: 0 6px 18px rgba(0,0,0,.14);
    transform: translateY(-1px);
}

.google-btn svg { width: 18px; height: 18px; }

/* Divider */
.divider {
    display: flex;
    align-items: center;
    gap: 12px;
    margin: 20px 0;
    font-size: 12px;
    color: #8a8a8a;
    text-transform: uppercase;
    letter-spacing: .1em;
}

.divider::before, .divider::after {
    content: "";
    flex: 1;
    height: 1px;
    background: #dcdcdc;
}

/* Input fields */
.field { margin-bottom: 16px; }

.field label {
    display: block;
    font-size: 12px;
    font-weight: 600;
    color: #444;
    margin-bottom: 7px;
}

.input-wrap {
    display: flex;
    align-items: center;
    background: white;
    border: 1.5px solid rgba(0,0,0,.1);
    border-radius: 4px;
    padding: 0 14px;
    transition: border-color .18s, box-shadow .18s, background .18s;
}

.input-wrap:focus-within {
    border-color: var(--blue);
    background: #eef2f7;
    box-shadow: 0 0 0 3px rgba(66,97,136,.16);
}

.input-wrap > .ic {
    width: 16px;
    height: 16px;
    color: #8a8a8a;
    flex-shrink: 0;
}

.input-wrap input {
    flex: 1;
    border: none;
    background: transparent;
    outline: none;
    min-width: 0;
    padding: 12px 10px;
    font-size: 14px;
    font-family: inherit;
    color: var(--ink);
}

.toggle-password {
    cursor: pointer;
    padding: 6px;
    display: flex;
    align-items: center;
}

.toggle-password .ic { width: 16px; height: 16px; }

/* Forgot password */
.row {
    display: flex;
    justify-content: flex-end;
    margin: -4px 0 20px;
}

.forgot {
    font-size: 13px;
    font-weight: 600;
    color: var(--signal-blue);
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

.forgot .ic { width: 14px; height: 14px; }

/* Login button */
.login-btn {
    position: relative;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    width: 100%;
    background: var(--ink);
    color: white;
    border: none;
    border-radius: 8px;
    padding: 14px 20px;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: background .2s, transform .12s, box-shadow .2s;
}

.login-btn::after {
    content: "";
    position: absolute;
    top: 0;
    left: -120%;
    width: 60%;
    height: 100%;
    background: linear-gradient(100deg,
        transparent, rgba(255,255,255,.25), transparent);
    transform: skewX(-20deg);
    transition: left .6s;
}

.login-btn:hover {
    background: var(--blue);
    box-shadow: 0 8px 22px rgba(66,97,136,.4);
}

.login-btn:hover::after { left: 140%; }

.login-btn .ic { width: 16px; height: 16px; }

.login-btn.loading {
    pointer-events: none;
    opacity: .85;
}

.login-btn.loading .ic {
    animation: spin .8s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* Register */
.no-account {
    margin-top: 22px;
    padding-top: 20px;
    border-top: 1px solid #dcdcdc;
    text-align: center;
    font-size: 13px;
    color: #666;
}

.no-account p { margin: 0 0 12px; }

.register-btn {
    display: block;
    width: 100%;
    text-align: center;
    background: transparent;
    color: var(--ink);
    border: 1px solid var(--ink);
    border-radius: 8px;
    padding: 11px 16px;
    font-size: 14px;
    font-weight: 600;
    transition: background .2s, color .2s;
}

.register-btn:hover {
    background: var(--ink);
    color: white;
}

/* Entrance animation */
.reveal {
    opacity: 0;
    transform: translateY(22px);
    animation: rise .8s cubic-bezier(.2,.8,.2,1) forwards;
}

@keyframes rise {
    to { opacity: 1; transform: translateY(0); }
}

.d1 { animation-delay: .05s; }
.d3 { animation-delay: .25s; }

/* Responsive */
@media (max-width: 560px) {
    .top { padding: 0 18px; }
    .content { padding: 88px 16px 40px; gap: 28px; }
    .card { padding: 26px 20px; }
    .logo span.name { display: none; }
}

@media (prefers-reduced-motion: reduce) {
    .glass, .marquee, .reveal, .error-message {
        animation: none !important;
        opacity: 1 !important;
        transform: none !important;
    }
}
</style>
</head>

<body>

<div class="stage" id="stage">
    <div class="glass glass-a"></div>
    <div class="glass glass-b"></div>
    <div class="glass glass-c"></div>

    <div class="marquee" aria-hidden="true">
        Digital Purohit Assist · Digital Purohit Assist · Digital Purohit Assist ·
    </div>

    <div class="spotlight" id="spotlight"></div>

    <!-- Navigation -->
    <div class="top">
        <a class="logo"
           href="${pageContext.request.contextPath}/">
            <span class="mark">
                <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                    <line x1="3" x2="21" y1="22" y2="22"/>
                    <line x1="6" x2="6" y1="18" y2="11"/>
                    <line x1="10" x2="10" y1="18" y2="11"/>
                    <line x1="14" x2="14" y1="18" y2="11"/>
                    <line x1="18" x2="18" y1="18" y2="11"/>
                    <polygon points="12 2 20 7 4 7"/>
                </svg>
            </span>
            <span class="name">
                digital purohit <span class="accent">assist</span>
            </span>
        </a>

        <a class="back" href="${pageContext.request.contextPath}/">
            <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                <path d="m12 19-7-7 7-7"/>
                <path d="M19 12H5"/>
            </svg>
            Home
        </a>
    </div>

    <div class="content">

        <div class="brand">
            <h1 class="reveal d1">Digital Purohit</h1>
        </div>

        <div class="card-wrap reveal d3">
            <div class="card" id="card">

                <h2>Log in to <span class="accent">continue</span></h2>
                <p class="lead">
                    Continue with Google, or use your email and password.
                </p>

                <!-- Error message from the login servlet / Google servlet -->
             <%
    String errorMessage =
        (String) request.getAttribute("errorMessage");

    if (errorMessage == null || errorMessage.trim().isEmpty()) {
        String code = request.getParameter("error");

        if ("google_failed".equals(code)
                || "google_invalid_token".equals(code)) {
            errorMessage =
                "Google sign-in failed. Please try again.";

        } else if ("google_csrf".equals(code)) {
            errorMessage =
                "Google sign-in could not be verified. Please try again.";

        } else if ("google_unverified".equals(code)) {
            errorMessage =
                "Your Google email address is not verified.";

        } else if ("google_not_registered".equals(code)) {
            errorMessage =
                "No admin account is registered with this Google email.";

        } else if ("google_client_id_mismatch".equals(code)) {
            errorMessage =
                "Google configuration mismatch. Check your Client ID.";

        } else if ("google_missing_credential".equals(code)) {
            errorMessage =
                "Google did not return a login credential. Please try again.";

        } else if ("google_invalid_issuer".equals(code)
                || "google_invalid_expiration".equals(code)
                || "google_token_expired".equals(code)) {
            errorMessage =
                "Google authentication could not be verified. Please try again.";

        } else if ("google_email_missing".equals(code)) {
            errorMessage =
                "Google did not provide an email address.";

        } else if ("google_interrupted".equals(code)) {
            errorMessage =
                "Google sign-in was interrupted. Please try again.";
        }
    }

    if (errorMessage != null && !errorMessage.trim().isEmpty()) {
        String safeMessage = errorMessage
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;");
%>
    <div class="error-message" role="alert">
        <%= safeMessage %>
    </div>
<%
    }
%>

                <!-- Direct Google sign-in. The email/password login below stays as an alternative. -->
<%
    String googleClientId = "270644021286-e9sikomura4stu09satp0qq3ct1kag7d.apps.googleusercontent.com";

    /* Google needs the full address of the endpoint that receives the sign-in */
   String forwardedProto = request.getHeader("X-Forwarded-Proto");

String scheme;

if (forwardedProto != null && !forwardedProto.isBlank()) {
    scheme = forwardedProto.split(",")[0].trim();
} else {
    scheme = request.getScheme();
}

String googleLoginUri =
        scheme + "://"
        + request.getServerName()
        + request.getContextPath()
        + "/auth/google";
    int port = request.getServerPort();
    boolean defaultPort = ("http".equals(scheme) && port == 80) || ("https".equals(scheme) && port == 443);
    googleLoginUri = scheme + "://" + request.getServerName()
            + (defaultPort ? "" : ":" + port)
            + request.getContextPath() + "/auth/google";
%>

<div class="google-login-wrapper" id="googleWrap" style="width:100%; margin:0 auto; display:flex; justify-content:center;">
    <div id="googleBtn"></div>
</div>
<div class="google-note" id="googleNote" role="status" hidden>
    Google sign-in could not be loaded. Check your connection, or use your email and password below.
</div>

                <div class="divider">or with email</div>

                <!-- IMPORTANT: submits to your existing LoginServlet -->
                <form action="${pageContext.request.contextPath}/login"
                      method="post"
                      id="loginForm">

                    <div class="field">
                        <label for="email">Email address</label>

                        <div class="input-wrap">
                            <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                                <rect width="20" height="16" x="2" y="4" rx="2"/>
                                <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                            </svg>

                            <input type="email"
                                   id="email"
                                   name="email"
                                   placeholder="you@example.com"
                                   autocomplete="username"
                                   required>
                        </div>
                    </div>

                    <div class="field">
                        <label for="password">Password</label>

                        <div class="input-wrap">
                            <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                                <rect width="18" height="11" x="3" y="11" rx="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>

                            <input type="password"
                                   id="password"
                                   name="password"
                                   placeholder="Enter your password"
                                   autocomplete="current-password"
                                   required>

                            <button type="button"
                                    class="toggle-password"
                                    id="togglePassword"
                                    aria-label="Show password"
                                    aria-pressed="false"
                                    style="border:0;background:transparent;">
                                <svg class="ic eye-on" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                                <svg class="ic eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display:none">
                                    <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/>
                                    <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/>
                                    <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/>
                                    <line x1="2" x2="22" y1="2" y2="22"/>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <div class="row">
                        <a class="forgot"
                           href="${pageContext.request.contextPath}/forgot-password">
                            Forgot password?
                        </a>
                    </div>

                    <button type="submit"
                            class="login-btn"
                            id="loginBtn">
                        <span>Login securely</span>
                        <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M5 12h14"/>
                            <path d="m12 5 7 7-7 7"/>
                        </svg>
                    </button>
                </form>

                <div class="no-account">
                    <p>Don’t have an account yet?</p>
                    <a class="register-btn"
                       href="${pageContext.request.contextPath}/register">
                        Create free account
                    </a>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
var GOOGLE_CFG = {
    clientId: "<%= googleClientId %>",
    loginUri: "<%= googleLoginUri %>"
};

/* Called by the Google library when it has loaded */
function initGoogleSignIn() {
    if (!window.google || !google.accounts || !google.accounts.id) { return; }

    var note = document.getElementById('googleNote');
    var wrap = document.getElementById('googleWrap');
    note.hidden = true;

    google.accounts.id.initialize({
        client_id: GOOGLE_CFG.clientId,
        login_uri: GOOGLE_CFG.loginUri,
        ux_mode: 'redirect',
        auto_select: false
    });

    /* the button width follows the card, so it never overflows on small phones */
    var width = Math.max(200, Math.min(360, wrap.clientWidth || 360));
    google.accounts.id.renderButton(document.getElementById('googleBtn'), {
        type: 'standard',
        theme: 'outline',
        size: 'large',
        text: 'continue_with',
        shape: 'rectangular',
        width: width
    });
}

function googleLoadFailed() {
    document.getElementById('googleNote').hidden = false;
}

/* if the library never arrives (offline, blocked), tell the user instead of showing nothing */
setTimeout(function () {
    if (!(window.google && google.accounts && google.accounts.id)) { googleLoadFailed(); }
}, 6000);
</script>
<script src="https://accounts.google.com/gsi/client" async defer
        onload="initGoogleSignIn()" onerror="googleLoadFailed()"></script>

<script>
(function () {
    // Show / hide password
    var toggle = document.getElementById('togglePassword');
    var password = document.getElementById('password');

    toggle.addEventListener('click', function () {
        var isHidden = password.type === 'password';

        password.type = isHidden ? 'text' : 'password';
        toggle.querySelector('.eye-on').style.display =
            isHidden ? 'none' : '';
        toggle.querySelector('.eye-off').style.display =
            isHidden ? '' : 'none';

        toggle.setAttribute('aria-pressed', String(isHidden));
        toggle.setAttribute(
            'aria-label',
            isHidden ? 'Hide password' : 'Show password'
        );
    });

    // Loading effect without cancelling the real form submission
    document.getElementById('loginForm').addEventListener('submit', function () {
        var button = document.getElementById('loginBtn');

        if (!this.checkValidity()) {
            return;
        }

        button.classList.add('loading');
        button.querySelector('span').textContent = 'Signing in…';
        button.querySelector('svg').innerHTML =
            '<path d="M21 12a9 9 0 1 1-6.219-8.56"/>';
    });

    // Cursor spotlight and card tilt
    var fine = window.matchMedia('(pointer:fine)').matches;
    var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (fine && !reduce) {
        var spotlight = document.getElementById('spotlight');
        var card = document.getElementById('card');
        var stage = document.getElementById('stage');

        var overGoogle = false;
        var googleWrap = document.getElementById('googleWrap');
        googleWrap.addEventListener('mouseenter', function () {
            overGoogle = true;
            card.style.transform = 'none';
        });
        googleWrap.addEventListener('mouseleave', function () { overGoogle = false; });

        stage.addEventListener('mousemove', function (event) {
            spotlight.style.opacity = 1;
            if (overGoogle) { return; }
            spotlight.style.left = event.clientX + 'px';
            spotlight.style.top = event.clientY + 'px';

            var rect = card.getBoundingClientRect();
            var centerX = rect.left + rect.width / 2;
            var centerY = rect.top + rect.height / 2;
            var dx = (event.clientX - centerX) / window.innerWidth;
            var dy = (event.clientY - centerY) / window.innerHeight;

            card.style.transform =
                'rotateY(' + (dx * 7) + 'deg) rotateX(' + (-dy * 7) + 'deg)';
        });

        stage.addEventListener('mouseleave', function () {
            spotlight.style.opacity = 0;
            card.style.transform = 'rotateY(0) rotateX(0)';
        });
    }
})();

</script>
<script>
(function () {

    // Revalidate the login page when restored using
    // the browser Back or Forward buttons.

    window.addEventListener("pageshow", function (event) {

        if (event.persisted) {
            window.location.reload();
        }

    });

})();
</script>
</body>
</html>
