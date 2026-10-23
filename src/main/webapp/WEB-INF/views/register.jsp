
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register | Digital Purohit Assistant</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Anton&family=Caveat:wght@500;600&display=swap" rel="stylesheet">

<style>
:root {
    --white: #fff;
    --haze: #f5f5f5;
    --ink: #1b1b1b;
    --blue: #426188;
    --signal-blue: #2b7fff;
    --bad: #d64545;
    --good: #1f9d55;
    --font: 'Inter', system-ui, sans-serif;
    --display: 'Anton', sans-serif;
    --script: 'Caveat', cursive;
}

* { box-sizing: border-box; }
html, body { margin: 0; min-height: 100%; }

body {
    background: #000;
    color: var(--white);
    font-family: var(--font);
    overflow-x: hidden;
}

a { color: inherit; text-decoration: none; }
button, input { font-family: inherit; }
::selection { background: var(--blue); color: #fff; }

.ic {
    width: 1em;
    height: 1em;
    fill: none;
    stroke: currentColor;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
    flex-shrink: 0;
}

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
    width: 560px; height: 560px; top: -160px; left: 4%;
    background: radial-gradient(circle, rgba(66,97,136,.8), transparent 70%);
}
.glass-b {
    width: 680px; height: 680px; bottom: -240px; right: 2%;
    animation-delay: -5s;
    background: radial-gradient(circle, rgba(255,255,255,.25), transparent 70%);
}
.glass-c {
    width: 400px; height: 400px; top: 34%; left: 42%;
    animation-delay: -9s;
    background: radial-gradient(circle, rgba(43,127,255,.3), transparent 70%);
}

@keyframes float {
    0%, 100% { transform: translate(0,0) scale(1); }
    50% { transform: translate(-26px,30px) scale(1.07); }
}

.marquee {
    position: absolute;
    left: 0; right: 0; top: 50%;
    transform: translateY(-50%);
    white-space: nowrap;
    pointer-events: none;
    user-select: none;
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
    width: 520px; height: 520px;
    border-radius: 50%;
    pointer-events: none;
    z-index: 1;
    background: radial-gradient(circle, rgba(255,255,255,.07), transparent 65%);
    transform: translate(-50%,-50%);
    opacity: 0;
}

.top {
    position: absolute;
    top: 0; left: 0; right: 0;
    z-index: 5;
    height: 72px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 32px;
}

.logo {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 15px;
    font-weight: 600;
}

.mark {
    width: 32px; height: 32px;
    border: 1px solid rgba(255,255,255,.6);
    border-radius: 9px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.mark .ic { width: 16px; height: 16px; }

.accent {
    font-family: var(--script);
    font-style: italic;
    color: var(--blue);
}

.logo .accent { font-size: 19px; }

.back {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    border: 1px solid white;
    border-radius: 8px;
    padding: 8px 14px;
    font-size: 14px;
}

.back .ic { width: 14px; height: 14px; }
.back:hover { background: white; color: var(--ink); }

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
    margin: 0;
    font-family: var(--display);
    font-size: clamp(52px, 9vw, 120px);
    line-height: .9;
    text-transform: uppercase;
}

.card-wrap { width: 100%; perspective: 1100px; }

.card {
    width: 100%;
    max-width: 560px;
    margin: 0 auto;
    padding: 34px 30px;
    border-radius: 12px;
    background: var(--haze);
    color: var(--ink);
    transition: transform .15s ease-out;
    transform-style: preserve-3d;
}

.card h2 {
    font-size: 26px;
    margin: 0 0 6px;
}

.card h2 .accent { font-size: 1.1em; }

.lead {
    margin: 0 0 22px;
    font-size: 14px;
    color: #666;
    font-weight: 400;
}

.error-message, .success-message {
    display: flex;
    align-items: center;
    gap: 10px;
    border-radius: 6px;
    padding: 10px 14px;
    font-size: 13px;
    margin-bottom: 16px;
    overflow-wrap: anywhere;
}

.error-message {
    background: #fdecec;
    color: var(--bad);
    border: 1px solid #f6c6c6;
}

.success-message {
    background: #e4f6ea;
    color: var(--good);
    border: 1px solid #bfe6cc;
}

#clientError { display: none; }

.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    column-gap: 14px;
}

.form-group { min-width: 0; margin-bottom: 16px; }

.form-group label {
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
    color: #888;
}

.input-wrap input {
    flex: 1;
    width: 0;
    min-width: 0;
    padding: 12px 10px;
    border: none;
    outline: none;
    background: transparent;
    color: var(--ink);
    font-size: 14px;
}

.toggle-password {
    cursor: pointer;
    padding: 6px;
    display: flex;
    align-items: center;
    border: 0;
    background: transparent;
}

.toggle-password .ic { width: 16px; height: 16px; }

.register-btn {
    position: relative;
    overflow: hidden;
    margin-top: 6px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    padding: 14px 20px;
    background: var(--ink);
    color: white;
    border: 0;
    border-radius: 8px;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: background .2s, transform .12s;
}

.register-btn:hover {
    background: var(--blue);
    box-shadow: 0 8px 22px rgba(66,97,136,.4);
}

.register-btn:active { transform: scale(.98); }
.register-btn .ic { width: 16px; height: 16px; }

.register-btn.loading {
    pointer-events: none;
    opacity: .85;
}

.register-btn.loading .ic { animation: spin .8s linear infinite; }

@keyframes spin { to { transform: rotate(360deg); } }

.login-links {
    margin-top: 22px;
    padding-top: 20px;
    border-top: 1px solid #dcdcdc;
    text-align: center;
    font-size: 13px;
    color: #666;
}

.login-links p { margin: 0 0 12px; }

.login-btn-link {
    display: block;
    width: 100%;
    padding: 11px 16px;
    border: 1px solid var(--ink);
    border-radius: 8px;
    color: var(--ink);
    text-align: center;
    font-size: 14px;
    font-weight: 600;
}

.login-btn-link:hover { background: var(--ink); color: white; }

.reveal {
    opacity: 0;
    transform: translateY(22px);
    animation: rise .8s cubic-bezier(.2,.8,.2,1) forwards;
}

@keyframes rise { to { opacity: 1; transform: translateY(0); } }

.d1 { animation-delay: .05s; }
.d3 { animation-delay: .25s; }
.d4 { animation-delay: .33s; }
.d5 { animation-delay: .41s; }
.d6 { animation-delay: .49s; }
.d7 { animation-delay: .57s; }

@media (max-width: 620px) {
    .form-grid { grid-template-columns: 1fr; }
    .top { padding: 0 18px; }
    .content { padding: 88px 16px 40px; gap: 28px; }
    .card { padding: 26px 20px; }
    .logo .name { display: none; }
}

@media (prefers-reduced-motion: reduce) {
    .glass, .marquee, .reveal {
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

    <div class="top">
        <a class="logo" href="${pageContext.request.contextPath}/">
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
            <span class="name">digital purohit <span class="accent">assist</span></span>
        </a>

        <a class="back" href="${pageContext.request.contextPath}/login">
            <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                <path d="m12 19-7-7 7-7"/>
                <path d="M19 12H5"/>
            </svg>
            Login
        </a>
    </div>

    <div class="content">

        <div class="brand">
            <h1 class="reveal d1">Digital Purohit</h1>
        </div>

        <div class="card-wrap reveal d3">
            <div class="card" id="card">

                <h2>Create <span class="accent">Admin Account</span></h2>
                <p class="lead">Fill in your details to get started.</p>

                <%!
                    // Escape untrusted text before rendering it as HTML.
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

                    if (errorMessage != null && !errorMessage.trim().isEmpty()) {
                %>
                    <div class="error-message" role="alert">
                        <%= escapeHtml(errorMessage) %>
                    </div>
                <%
                    }

                    if (successMessage != null && !successMessage.trim().isEmpty()) {
                %>
                    <div class="success-message" role="status">
                        <%= escapeHtml(successMessage) %>
                    </div>
                <%
                    }
                %>

                <div class="error-message" id="clientError" role="alert">
                    <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/>
                        <path d="M12 9v4"/>
                        <path d="M12 17h.01"/>
                    </svg>
                    <span id="clientErrorText"></span>
                </div>

                <!-- Registration form connected to the Java Servlet -->
                <form action="${pageContext.request.contextPath}/register"
                      method="post"
                      id="registerForm">

                    <div class="form-grid">

                        <div class="form-group reveal d3">
                            <label for="name">Full Name</label>
                            <div class="input-wrap">
                                <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
                                    <circle cx="12" cy="7" r="4"/>
                                </svg>
                                <input type="text" id="name" name="name"
                                       placeholder="Enter Full Name"
                                       autocomplete="name" required>
                            </div>
                        </div>

                        <div class="form-group reveal d3">
                            <label for="phone">Phone Number</label>
                            <div class="input-wrap">
                                <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
                                </svg>
                                <input type="tel" id="phone" name="phone"
                                       placeholder="Enter Phone Number"
                                       maxlength="10" pattern="[0-9]{10}"
                                       inputmode="numeric" autocomplete="tel" required>
                            </div>
                        </div>

                        <div class="form-group reveal d4">
                            <label for="email">Email</label>
                            <div class="input-wrap">
                                <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect width="20" height="16" x="2" y="4" rx="2"/>
                                    <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                                </svg>
                                <input type="email" id="email" name="email"
                                       placeholder="Enter Email Address"
                                       autocomplete="email" required>
                            </div>
                        </div>

                        <div class="form-group reveal d4">
                            <label for="username">Username</label>
                            <div class="input-wrap">
                                <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="4"/>
                                    <path d="M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8"/>
                                </svg>
                                <input type="text" id="username" name="username"
                                       placeholder="Choose Username"
                                       autocomplete="username" required>
                            </div>
                        </div>

                        <div class="form-group reveal d5">
                            <label for="password">Password</label>
                            <div class="input-wrap">
                                <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect width="18" height="11" x="3" y="11" rx="2"/>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                                <input type="password" id="password" name="password"
                                       placeholder="Enter Password"
                                       autocomplete="new-password" required>
                                <button type="button" class="toggle-password"
                                        data-target="password"
                                        aria-label="Show password"
                                        aria-pressed="false">
                                    <svg class="ic eye-on" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/>
                                        <circle cx="12" cy="12" r="3"/>
                                    </svg>
                                    <svg class="ic eye-off" viewBox="0 0 24 24"
                                         aria-hidden="true" style="display:none">
                                        <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/>
                                        <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/>
                                        <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/>
                                        <line x1="2" x2="22" y1="2" y2="22"/>
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <div class="form-group reveal d5">
                            <label for="confirmPassword">Confirm Password</label>
                            <div class="input-wrap">
                                <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect width="18" height="11" x="3" y="11" rx="2"/>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                                <input type="password" id="confirmPassword"
                                       name="confirmPassword"
                                       placeholder="Confirm Password"
                                       autocomplete="new-password" required>
                                <button type="button" class="toggle-password"
                                        data-target="confirmPassword"
                                        aria-label="Show confirmation password"
                                        aria-pressed="false">
                                    <svg class="ic eye-on" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/>
                                        <circle cx="12" cy="12" r="3"/>
                                    </svg>
                                    <svg class="ic eye-off" viewBox="0 0 24 24"
                                         aria-hidden="true" style="display:none">
                                        <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/>
                                        <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/>
                                        <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/>
                                        <line x1="2" x2="22" y1="2" y2="22"/>
                                    </svg>
                                </button>
                            </div>
                        </div>

                    </div>

                    <button type="submit" class="register-btn reveal d6"
                            id="registerBtn">
                        <span>Register</span>
                        <svg class="ic" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M5 12h14"/>
                            <path d="m12 5 7 7-7 7"/>
                        </svg>
                    </button>

                </form>

                <div class="login-links reveal d7">
                    <p>Already have an account?</p>
                    <a class="login-btn-link"
                       href="${pageContext.request.contextPath}/login">
                        Login
                    </a>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
(function () {
    // Show / hide both password fields
    document.querySelectorAll('.toggle-password').forEach(function (button) {
        button.addEventListener('click', function () {
            var input = document.getElementById(button.dataset.target);
            var show = input.type === 'password';

            input.type = show ? 'text' : 'password';
            button.querySelector('.eye-on').style.display = show ? 'none' : '';
            button.querySelector('.eye-off').style.display = show ? '' : 'none';
            button.setAttribute('aria-pressed', String(show));
            button.setAttribute(
                'aria-label',
                show ? 'Hide password' : 'Show password'
            );
        });
    });

    // Allow only digits in the phone number
    document.getElementById('phone').addEventListener('input', function () {
        this.value = this.value.replace(/\D/g, '').slice(0, 10);
    });

    // Validate password confirmation but allow valid form submission
    document.getElementById('registerForm').addEventListener('submit', function (event) {
        var password = document.getElementById('password').value;
        var confirmPassword = document.getElementById('confirmPassword').value;
        var errorBox = document.getElementById('clientError');
        var errorText = document.getElementById('clientErrorText');

        if (password !== confirmPassword) {
            event.preventDefault();
            errorText.textContent = 'Passwords do not match.';
            errorBox.style.display = 'flex';
            document.getElementById('confirmPassword').focus();
            return;
        }

        errorBox.style.display = 'none';

        var button = document.getElementById('registerBtn');
        button.classList.add('loading');
        button.querySelector('span').textContent = 'Creating account…';
        button.querySelector('svg').innerHTML =
            '<path d="M21 12a9 9 0 1 1-6.219-8.56"/>';
        // Do not prevent default: the browser submits to /register.
    });

    // Cursor spotlight and card tilt
    var fine = window.matchMedia('(pointer:fine)').matches;
    var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (fine && !reduce) {
        var spotlight = document.getElementById('spotlight');
        var card = document.getElementById('card');
        var stage = document.getElementById('stage');

        stage.addEventListener('mousemove', function (event) {
            spotlight.style.opacity = 1;
            spotlight.style.left = event.clientX + 'px';
            spotlight.style.top = event.clientY + 'px';

            var rect = card.getBoundingClientRect();
            var dx = (event.clientX - (rect.left + rect.width / 2)) / window.innerWidth;
            var dy = (event.clientY - (rect.top + rect.height / 2)) / window.innerHeight;

            card.style.transform =
                'rotateY(' + (dx * 6) + 'deg) rotateX(' + (-dy * 6) + 'deg)';
        });

        stage.addEventListener('mouseleave', function () {
            spotlight.style.opacity = 0;
            card.style.transform = 'rotateY(0) rotateX(0)';
        });
    }
})();
</script>

</body>
</html>
