```jsp
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    String errorMessage =
        (String) request.getAttribute("errorMessage");

    String successMessage =
        (String) request.getAttribute("successMessage");
%>

<!DOCTYPE html>
<html lang="en" data-theme="dark">

<head>
<meta charset="UTF-8">
<meta name="viewport"
      content="width=device-width, initial-scale=1, viewport-fit=cover">

<title>Forgot Password | Digital Purohit Assistant</title>

<link rel="preconnect" href="https://fonts.googleapis.com">

<link href="https://fonts.googleapis.com/css2?family=Anton&family=Inter:wght@400;500;600;700&family=Caveat:wght@500;600&display=swap"
      rel="stylesheet">

<style>
:root {
    --accent: #426188;
    --link: #2b7fff;
    --good: #34d399;
    --bad: #ff6b6b;
}

:root,
:root[data-theme="dark"] {
    --bg: #050608;
    --surface: #10141c;
    --surface2: #161b26;
    --text: #f5f5f5;
    --muted: rgba(255,255,255,.58);
    --border: rgba(255,255,255,.09);
    --hover: rgba(255,255,255,.06);
    --tile: rgba(255,255,255,.07);
    --glow: rgba(66,97,136,.4);
    color-scheme: dark;
}

:root[data-theme="light"] {
    --bg: #f1f4f9;
    --surface: #ffffff;
    --surface2: #f5f6f8;
    --text: #1b1b1b;
    --muted: #6b7280;
    --border: rgba(0,0,0,.10);
    --hover: rgba(0,0,0,.045);
    --tile: rgba(0,0,0,.06);
    --glow: rgba(66,97,136,.18);
    --good: #168a4a;
    --bad: #c93434;
    color-scheme: light;
}

* {
    box-sizing: border-box;
}

html,
body {
    margin: 0;
    min-height: 100%;
}

body {
    min-height: 100vh;
    min-height: 100dvh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 32px;
    overflow-x: hidden;
    position: relative;

    font-family: 'Inter', sans-serif;
    font-size: 14px;
    line-height: 1.5;
    color: var(--text);
    background: var(--bg);

    -webkit-font-smoothing: antialiased;
    transition: background .3s, color .3s;
}

body::before,
body::after {
    content: "";
    position: fixed;
    z-index: 0;
    width: 420px;
    height: 420px;
    border-radius: 50%;
    filter: blur(80px);
    pointer-events: none;
    animation: float 15s ease-in-out infinite;
}

body::before {
    top: -200px;
    left: -160px;
    background: radial-gradient(circle, var(--glow), transparent 70%);
}

body::after {
    bottom: -220px;
    right: -150px;
    background: radial-gradient(circle, rgba(43,127,255,.17), transparent 70%);
    animation-direction: reverse;
}

@keyframes float {
    0%,100% { transform: translate(0,0); }
    50% { transform: translate(25px,30px); }
}

@keyframes rise {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

@keyframes drift {
    from { transform: translateX(0); }
    to { transform: translateX(-50%); }
}

@keyframes shake {
    0%,100% { transform: translateX(0); }
    25% { transform: translateX(-5px); }
    75% { transform: translateX(5px); }
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

svg {
    width: 1em;
    height: 1em;
    fill: none;
    stroke: currentColor;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
}

i {
    display: inline-flex;
}

/* Theme button */

.theme-btn {
    position: fixed;
    top: 18px;
    right: 18px;
    z-index: 5;

    width: 44px;
    height: 44px;

    display: flex;
    align-items: center;
    justify-content: center;

    border: 1px solid var(--border);
    border-radius: 12px;
    background: var(--surface);
    color: var(--text);

    font-size: 19px;
    cursor: pointer;
    transition: .2s;
}

.theme-btn:hover {
    border-color: var(--accent);
    background: var(--hover);
}

.sun {
    display: none;
}

:root[data-theme="light"] .moon {
    display: none;
}

:root[data-theme="light"] .sun {
    display: inline-flex;
    color: #e0a100;
}

/* Main layout */

.shell {
    position: relative;
    z-index: 1;

    width: 100%;
    max-width: 1000px;

    display: grid;
    grid-template-columns: 1fr 1.05fr;

    overflow: hidden;
    border: 1px solid var(--border);
    border-radius: 24px;

    background: var(--surface);
    box-shadow: 0 30px 80px rgba(0,0,0,.35);

    animation: rise .7s ease both;
}

/* Brand panel */

.brand {
    position: relative;
    isolation: isolate;
    overflow: hidden;

    display: flex;
    flex-direction: column;
    justify-content: space-between;
    gap: 32px;

    padding: 40px 36px;

    color: #fff;
    background: #05070b;
}

.brand::before,
.brand::after {
    content: "";
    position: absolute;
    z-index: -1;

    width: 380px;
    height: 380px;
    border-radius: 50%;
    filter: blur(55px);
    pointer-events: none;
}

.brand::before {
    top: -180px;
    left: -120px;
    background: rgba(66,97,136,.7);
}

.brand::after {
    right: -200px;
    bottom: -190px;
    background: rgba(43,127,255,.28);
}

.watermark {
    position: absolute;
    z-index: -1;
    top: 43%;
    left: 0;

    white-space: nowrap;
    pointer-events: none;

    font-family: 'Anton', sans-serif;
    font-size: 110px;
    line-height: 1;
    color: transparent;
    -webkit-text-stroke: 1px rgba(255,255,255,.07);

    animation: drift 45s linear infinite;
}

.logo {
    width: 56px;
    height: 56px;

    display: flex;
    align-items: center;
    justify-content: center;

    border: 1px solid rgba(255,255,255,.5);
    border-radius: 16px;
    background: rgba(255,255,255,.05);

    font-size: 25px;
}

.brand h1 {
    margin: 28px 0 0;
    font-family: 'Anton', sans-serif;
    font-size: clamp(36px, 4vw, 52px);
    font-weight: 400;
    line-height: 1.05;
    text-transform: uppercase;
}

.brand h1 em {
    display: block;
    margin-top: 6px;

    color: #86a9d8;
    font-family: 'Caveat', cursive;
    font-size: 1.05em;
    font-weight: 600;
    text-transform: none;
}

.brand p {
    max-width: 300px;
    margin: 16px 0 0;
    color: rgba(255,255,255,.72);
    font-weight: 400;
}

.tips {
    display: grid;
    gap: 18px;

    margin: 0;
    padding: 0;
    list-style: none;
}

.tips li {
    display: flex;
    align-items: flex-start;
    gap: 12px;

    color: rgba(255,255,255,.8);
    font-size: 13px;
    font-weight: 400;
}

.tips li > i {
    flex-shrink: 0;
    width: 32px;
    height: 32px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 9px;
    background: rgba(255,255,255,.1);
}

/* Form panel */

.panel {
    display: flex;
    flex-direction: column;
    justify-content: center;

    min-width: 0;
    padding: 38px 36px;
}

.panel h2 {
    margin: 0;
    font-size: 27px;
    font-weight: 700;
    letter-spacing: -.7px;
}

.subtitle {
    margin: 7px 0 24px;
    color: var(--muted);
    font-weight: 400;
}

.alert {
    display: flex;
    align-items: flex-start;
    gap: 10px;

    margin-bottom: 18px;
    padding: 12px 14px;

    border: 1px solid;
    border-radius: 12px;

    font-size: 13px;
    font-weight: 600;
    overflow-wrap: anywhere;
    animation: rise .3s ease;
}

.alert i {
    flex-shrink: 0;
    font-size: 18px;
}

.error-message {
    color: var(--bad);
    background: rgba(255,107,107,.10);
    border-color: rgba(255,107,107,.35);
}

.success-message {
    color: var(--good);
    background: rgba(52,211,153,.10);
    border-color: rgba(52,211,153,.35);
}

form {
    display: grid;
    gap: 17px;
    margin: 0;
}

.field {
    display: grid;
    gap: 7px;
    min-width: 0;
}

.field > label {
    color: var(--muted);
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 1px;
    text-transform: uppercase;
}

.input-wrap {
    display: flex;
    align-items: center;
    gap: 12px;

    min-width: 0;
    padding: 0 13px;

    border: 1.5px solid var(--border);
    border-radius: 12px;
    background: var(--surface2);

    transition: border-color .2s, box-shadow .2s;
}

.input-wrap > i {
    flex-shrink: 0;
    color: var(--muted);
    font-size: 17px;
}

.input-wrap:hover {
    border-color: var(--accent);
}

.input-wrap:focus-within {
    border-color: var(--accent);
    box-shadow: 0 0 0 4px rgba(66,97,136,.18);
}

.input-wrap.invalid {
    border-color: var(--bad);
    animation: shake .3s;
}

.input-wrap.valid {
    border-color: var(--good);
}

.input-wrap input {
    width: 100%;
    min-width: 0;
    padding: 14px 0;

    border: 0;
    outline: 0;
    box-shadow: none;

    background: transparent;
    color: var(--text);

    font-family: inherit;
    font-size: 13px;
}

.input-wrap input::placeholder {
    color: var(--muted);
    opacity: .75;
}

.toggle-eye {
    flex-shrink: 0;
    width: 34px;
    height: 34px;

    display: flex;
    align-items: center;
    justify-content: center;

    border: 0;
    border-radius: 8px;
    background: transparent;
    color: var(--muted);

    font-size: 17px;
    cursor: pointer;
}

.toggle-eye:hover {
    color: var(--text);
    background: var(--hover);
}

.toggle-eye .off {
    display: none;
}

.toggle-eye.shown .on {
    display: none;
}

.toggle-eye.shown .off {
    display: inline-flex;
}

/* Password strength */

.meter {
    display: grid;
    gap: 6px;
    margin-top: 2px;
}

.bars {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 5px;
}

.bars span {
    height: 4px;
    border-radius: 20px;
    background: var(--tile);
}

.meter .lbl {
    color: var(--muted);
    font-size: 11px;
    font-weight: 600;
}

.meter[data-s="1"] .bars span:nth-child(-n+1) {
    background: var(--bad);
}

.meter[data-s="2"] .bars span:nth-child(-n+2) {
    background: #f0a43a;
}

.meter[data-s="3"] .bars span:nth-child(-n+3) {
    background: #7bd88f;
}

.meter[data-s="4"] .bars span {
    background: var(--good);
}

.hint {
    display: none;
    align-items: center;
    gap: 6px;
    font-size: 12px;
    font-weight: 600;
}

.hint.show {
    display: flex;
}

.hint.bad {
    color: var(--bad);
}

.hint.good {
    color: var(--good);
}

/* Submit button */

.btn-submit {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;

    margin-top: 5px;
    padding: 15px 20px;

    border: 1px solid var(--accent);
    border-radius: 12px;

    background: var(--accent);
    color: #fff;

    font-family: inherit;
    font-size: 14px;
    font-weight: 700;

    cursor: pointer;
    transition: .2s;
}

.btn-submit:hover {
    filter: brightness(1.18);
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(66,97,136,.3);
}

.btn-submit:active {
    transform: scale(.98);
}

.btn-submit.loading {
    pointer-events: none;
    opacity: .8;
}

.btn-submit.loading i {
    animation: spin .8s linear infinite;
}

/* Back link */

.back {
    margin-top: 20px;
    text-align: center;
}

.back a {
    display: inline-flex;
    align-items: center;
    gap: 8px;

    padding: 8px 12px;
    border-radius: 9px;

    color: var(--link);
    font-weight: 600;
    text-decoration: none;
}

.back a:hover {
    background: var(--hover);
}

button:focus-visible,
a:focus-visible,
input:focus-visible {
    outline: 2px solid var(--link);
    outline-offset: 3px;
}

/* Responsive */

@media (max-width: 900px) {
    body {
        padding: 24px 16px;
    }

    .shell {
        max-width: 540px;
        grid-template-columns: 1fr;
    }

    .brand {
        padding: 27px 28px;
        gap: 20px;
    }

    .brand h1 {
        margin-top: 18px;
        font-size: 39px;
    }

    .brand .tips {
        display: none;
    }

    .watermark {
        font-size: 75px;
    }

    .panel {
        padding: 30px 28px;
    }
}

@media (max-width: 480px) {
    body {
        padding: 70px 12px 18px;
    }

    .shell {
        border-radius: 18px;
    }

    .brand {
        padding: 24px 22px;
    }

    .brand h1 {
        font-size: 34px;
    }

    .panel {
        padding: 25px 20px;
    }

    .panel h2 {
        font-size: 24px;
    }

    .theme-btn {
        top: 12px;
        right: 12px;
    }
}

@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        animation: none !important;
        transition: none !important;
    }
}
</style>
</head>

<body>

<button type="button"
        class="theme-btn"
        id="themeBtn"
        aria-label="Switch theme">

    <span class="moon" aria-hidden="true">
        <i>
            <svg viewBox="0 0 24 24">
                <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/>
            </svg>
        </i>
    </span>

    <span class="sun" aria-hidden="true">
        <i>
            <svg viewBox="0 0 24 24">
                <circle cx="12" cy="12" r="4"/>
                <path d="M12 2v2M12 20v2M2 12h2M20 12h2"/>
                <path d="m4.93 4.93 1.41 1.41m11.32 11.32 1.41 1.41"/>
                <path d="m19.07 4.93-1.41 1.41M6.34 17.66l-1.41 1.41"/>
            </svg>
        </i>
    </span>
</button>

<main class="shell">

    <!-- BRAND PANEL -->

    <section class="brand">

        <span class="watermark" aria-hidden="true">
            Digital Purohit · Digital Purohit · Digital Purohit ·
        </span>

        <div>

            <div class="logo">
                <i>
                    <svg viewBox="0 0 24 24">
                        <path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6  .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/>
                    </svg>
                </i>
            </div>

            <h1>
                Digital Purohit
                <em>Assistant</em>
            </h1>

            <p>
                Reset your password in a few steps and get back
                to managing your events.
            </p>

        </div>

        <ul class="tips">

            <li>
                <i>
                    <svg viewBox="0 0 24 24">
                        <rect x="3" y="5" width="18" height="14" rx="2"/>
                        <path d="m3 7 9 6 9-6"/>
                    </svg>
                </i>

                <span>
                    Enter the email address registered with your account.
                </span>
            </li>

            <li>
                <i>
                    <svg viewBox="0 0 24 24">
                        <rect x="3" y="11" width="18" height="11" rx="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                </i>

                <span>
                    Choose a new, strong password for your account.
                </span>
            </li>

            <li>
                <i>
                    <svg viewBox="0 0 24 24">
                        <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>
                        <path d="m9 12 2 2 4-4"/>
                    </svg>
                </i>

                <span>
                    Sign in securely with your new password.
                </span>
            </li>

        </ul>

    </section>

    <!-- RESET PASSWORD FORM -->

    <section class="panel">

        <h2>Reset Password</h2>

        <p class="subtitle">
            Enter your registered details to set a new password.
        </p>

        <% if (errorMessage != null) { %>

            <div class="alert error-message" role="alert">
                <i>
                    <svg viewBox="0 0 24 24">
                        <circle cx="12" cy="12" r="10"/>
                        <path d="M12 8v4M12 16h.01"/>
                    </svg>
                </i>

                <div><%= escapeHtml(errorMessage) %></div>
            </div>

        <% } %>

        <% if (successMessage != null) { %>

            <div class="alert success-message" role="status">
                <i>
                    <svg viewBox="0 0 24 24">
                        <circle cx="12" cy="12" r="10"/>
                        <path d="m9 12 2 2 4-4"/>
                    </svg>
                </i>

                <div><%= escapeHtml(successMessage) %></div>
            </div>

        <% } %>

        <form id="resetForm"
              action="${pageContext.request.contextPath}/forgot-password"
              method="post">

            <!-- EMAIL -->

            <div class="field">

                <label for="email">Email Address</label>

                <div class="input-wrap" id="emailWrap">

                    <i>
                        <svg viewBox="0 0 24 24">
                            <rect x="3" y="5" width="18" height="14" rx="2"/>
                            <path d="m3 7 9 6 9-6"/>
                        </svg>
                    </i>

                    <input type="email"
                           id="email"
                           name="email"
                           autocomplete="email"
                           placeholder="Enter your registered email"
                           required>
                </div>

                <div class="hint bad" id="emailHint">
                    Please enter a valid email address.
                </div>

            </div>

            <!-- PHONE -->

            <div class="field">

                <label for="phone">Phone Number</label>

                <div class="input-wrap" id="phoneWrap">

                    <i>
                        <svg viewBox="0 0 24 24">
                            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
                        </svg>
                    </i>

                    <input type="tel"
                           id="phone"
                           name="phone"
                           maxlength="10"
                           inputmode="numeric"
                           autocomplete="tel"
                           placeholder="10-digit phone number"
                           required>
                </div>

                <div class="hint bad" id="phoneHint">
                    Enter a valid 10-digit phone number.
                </div>

            </div>

            <!-- NEW PASSWORD -->

            <div class="field">

                <label for="password">New Password</label>

                <div class="input-wrap" id="passWrap">

                    <i>
                        <svg viewBox="0 0 24 24">
                            <rect x="3" y="11" width="18" height="11" rx="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                    </i>

                    <input type="password"
                           id="password"
                           name="password"
                           minlength="8"
                           autocomplete="new-password"
                           placeholder="Enter a new password"
                           required>

                    <button type="button"
                            class="toggle-eye"
                            data-target="password"
                            aria-label="Show password">

                        <span class="on">
                            <i>
                                <svg viewBox="0 0 24 24">
                                    <path d="M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7-10-7-10-7Z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                            </i>
                        </span>

                        <span class="off">
                            <i>
                                <svg viewBox="0 0 24 24">
                                    <path d="m3 3 18 18M10.6 10.6a2 2 0 0 0 2.8 2.8"/>
                                    <path d="M9.9 5.2A10 10 0 0 1 12 5c6.4 0 10 7 10 7a14 14 0 0 1-3 3.8"/>
                                    <path d="M6.2 6.2C3.5 8 2 12 2 12s3.6 7 10 7a10 10 0 0 0 3-.5"/>
                                </svg>
                            </i>
                        </span>

                    </button>
                </div>

                <div class="meter" id="meter" data-s="0">
                    <div class="bars">
                        <span></span>
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>

                    <div class="lbl" id="meterLbl">
                        Password strength
                    </div>
                </div>

                <div class="hint bad" id="passHint">
                    Password must contain at least 8 characters.
                </div>

            </div>

            <!-- CONFIRM PASSWORD -->

            <div class="field">

                <label for="confirmPassword">Confirm Password</label>

                <div class="input-wrap" id="confWrap">

                    <i>
                        <svg viewBox="0 0 24 24">
                            <rect x="3" y="11" width="18" height="11" rx="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            <path d="m9 16 2 2 4-4"/>
                        </svg>
                    </i>

                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           minlength="8"
                           autocomplete="new-password"
                           placeholder="Re-enter the new password"
                           required>

                    <button type="button"
                            class="toggle-eye"
                            data-target="confirmPassword"
                            aria-label="Show password">

                        <span class="on">
                            <i>
                                <svg viewBox="0 0 24 24">
                                    <path d="M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7-10-7-10-7Z"/>
                                    <circle cx="12" cy="12" r="3"/>
                                </svg>
                            </i>
                        </span>

                        <span class="off">
                            <i>
                                <svg viewBox="0 0 24 24">
                                    <path d="m3 3 18 18M10.6 10.6a2 2 0 0 0 2.8 2.8"/>
                                    <path d="M9.9 5.2A10 10 0 0 1 12 5c6.4 0 10 7 10 7a14 14 0 0 1-3 3.8"/>
                                    <path d="M6.2 6.2C3.5 8 2 12 2 12s3.6 7 10 7a10 10 0 0 0 3-.5"/>
                                </svg>
                            </i>
                        </span>

                    </button>

                </div>

                <div class="hint" id="matchHint"></div>

            </div>

            <!-- SUBMIT -->

            <button type="submit" class="btn-submit" id="submitBtn">

                <i>
                    <svg viewBox="0 0 24 24">
                        <path d="m21 2-9.6 9.6"/>
                        <circle cx="7.5" cy="15.5" r="5.5"/>
                    </svg>
                </i>

                <span>Reset Password</span>

            </button>

        </form>

        <div class="back">
            <a href="${pageContext.request.contextPath}/login">
                <i>
                    <svg viewBox="0 0 24 24">
                        <path d="m12 19-7-7 7-7M19 12H5"/>
                    </svg>
                </i>

                Back to Login
            </a>
        </div>

    </section>

</main>

<script>
(function () {

    function $(id) {
        return document.getElementById(id);
    }

    // Restore the saved theme.

    var root = document.documentElement;

    try {
        root.setAttribute(
            'data-theme',
            localStorage.getItem('dpa-theme') === 'light'
                ? 'light'
                : 'dark'
        );
    } catch (e) {}

    $('themeBtn').addEventListener('click', function () {

        var next =
            root.getAttribute('data-theme') === 'light'
                ? 'dark'
                : 'light';

        root.setAttribute('data-theme', next);

        try {
            localStorage.setItem('dpa-theme', next);
        } catch (e) {}
    });

    // Show or hide passwords.

    document.querySelectorAll('.toggle-eye').forEach(function (button) {

        button.addEventListener('click', function () {

            var input = $(button.getAttribute('data-target'));
            var show = input.type === 'password';

            input.type = show ? 'text' : 'password';

            button.classList.toggle('shown', show);

            button.setAttribute(
                'aria-label',
                show ? 'Hide password' : 'Show password'
            );
        });
    });

    var email = $('email');
    var phone = $('phone');
    var pass = $('password');
    var conf = $('confirmPassword');

    // Email validation.

    function validEmail(value) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
    }

    email.addEventListener('input', function () {
        $('emailWrap').classList.remove('invalid');
        $('emailHint').classList.remove('show');
    });

    // Allow only digits in the phone number.

    phone.addEventListener('input', function () {

        phone.value = phone.value.replace(/\D/g, '').slice(0, 10);

        $('phoneWrap').classList.remove('invalid');
        $('phoneHint').classList.remove('show');
    });

    // Password strength.

    function calculateStrength(value) {

        if (!value) return 0;

        var score = 0;

        if (value.length >= 8) score++;
        if (value.length >= 12) score++;
        if (/[a-z]/.test(value) && /[A-Z]/.test(value)) score++;
        if (/\d/.test(value) && /[^A-Za-z0-9]/.test(value)) score++;

        return Math.max(1, Math.min(4, score));
    }

    var labels = [
        'Password strength',
        'Weak',
        'Fair',
        'Good',
        'Strong'
    ];

    function updateStrength() {

        var score = calculateStrength(pass.value);

        $('meter').setAttribute('data-s', score);
        $('meterLbl').textContent = labels[score];
    }

    // Password confirmation.

    function updateMatch() {

        var hint = $('matchHint');
        var wrap = $('confWrap');

        if (!conf.value) {
            hint.className = 'hint';
            hint.textContent = '';
            wrap.classList.remove('valid', 'invalid');
            return;
        }

        if (conf.value === pass.value) {

            hint.className = 'hint good show';
            hint.textContent = 'Passwords match.';

            wrap.classList.add('valid');
            wrap.classList.remove('invalid');

        } else {

            hint.className = 'hint bad show';
            hint.textContent = 'Passwords do not match.';

            wrap.classList.remove('valid');
        }
    }

    pass.addEventListener('input', function () {

        updateStrength();
        updateMatch();

        $('passWrap').classList.remove('invalid');
        $('passHint').classList.remove('show');
    });

    conf.addEventListener('input', updateMatch);

    // Form validation.

    $('resetForm').addEventListener('submit', function (event) {

        var firstInvalid = null;

        if (!validEmail(email.value.trim())) {

            $('emailWrap').classList.add('invalid');
            $('emailHint').classList.add('show');

            firstInvalid = firstInvalid || email;
        }

        if (!/^\d{10}$/.test(phone.value)) {

            $('phoneWrap').classList.add('invalid');
            $('phoneHint').classList.add('show');

            firstInvalid = firstInvalid || phone;
        }

        if (pass.value.length < 8) {

            $('passWrap').classList.add('invalid');
            $('passHint').classList.add('show');

            firstInvalid = firstInvalid || pass;
        }

        if (pass.value !== conf.value) {

            $('confWrap').classList.add('invalid');

            firstInvalid = firstInvalid || conf;
        }

        if (firstInvalid) {
            event.preventDefault();
            firstInvalid.focus();
            return;
        }

        var button = $('submitBtn');

        button.classList.add('loading');
        button.querySelector('span').textContent = 'Resetting...';
    });

})();
</script>

</body>
</html>