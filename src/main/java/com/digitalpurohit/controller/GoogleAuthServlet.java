package com.digitalpurohit.controller;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Locale;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.dao.impl.AdminDAOImpl;
import com.digitalpurohit.model.Admin;
import com.digitalpurohit.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/auth/google")
public class GoogleAuthServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /*
     * Google Client ID
     * Must match login.jsp and Google Cloud Console.
     */
    private static final String CLIENT_ID =
            "270644021286-e9sikomura4stu09satp0qq3ct1kag7d.apps.googleusercontent.com";

    private static final String DASHBOARD_PATH = "/dashboard";
    private static final String LOGIN_PATH = "/login";

    private AdminDAO adminDAO;
    private HttpClient httpClient;

    @Override
    public void init() throws ServletException {

        adminDAO = new AdminDAOImpl();

        httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(8))
                .followRedirects(HttpClient.Redirect.NEVER)
                .build();
    }

    // =====================================================
    // PREVENT BROWSER CACHING
    // =====================================================

    private void preventCache(HttpServletResponse response) {

        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate, private"
        );

        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    // =====================================================
    // GET - GOOGLE AUTH URL
    // =====================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        preventCache(response);

        HttpSession session = request.getSession(false);

        // Already authenticated
        if (session != null
                && session.getAttribute("adminId") != null) {

            response.sendRedirect(
                    request.getContextPath() + DASHBOARD_PATH
            );

            return;
        }

        // Not authenticated
        response.sendRedirect(
                request.getContextPath() + LOGIN_PATH
        );
    }

    // =====================================================
    // POST - GOOGLE SIGN-IN
    // =====================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        preventCache(response);

        request.setCharacterEncoding("UTF-8");

        log("========================================");
        log("GOOGLE SIGN-IN REQUEST RECEIVED");
        log("Request URI: " + request.getRequestURI());

        try {

            // -------------------------------------------------
            // 1. READ GOOGLE CREDENTIAL
            // -------------------------------------------------

            String credential = request.getParameter("credential");

            if (credential == null || credential.isBlank()) {

                log("Google credential missing.");

                fail(request, response, "google_missing_credential");
                return;
            }

            // -------------------------------------------------
            // 2. GOOGLE CSRF VALIDATION
            // -------------------------------------------------

            String csrfParameter =
                    request.getParameter("g_csrf_token");

            String csrfCookie =
                    cookieValue(request, "g_csrf_token");

            if (csrfParameter == null
                    || csrfParameter.isBlank()
                    || csrfCookie == null
                    || !csrfParameter.equals(csrfCookie)) {

                log("Google CSRF validation failed.");

                fail(request, response, "google_csrf");
                return;
            }

            // -------------------------------------------------
            // 3. VERIFY GOOGLE ID TOKEN
            // -------------------------------------------------

            String encodedCredential = URLEncoder.encode(
                    credential,
                    StandardCharsets.UTF_8
            );

            URI tokenInfoUri = URI.create(
                    "https://oauth2.googleapis.com/tokeninfo?id_token="
                            + encodedCredential
            );

            HttpRequest tokenRequest = HttpRequest.newBuilder()
                    .uri(tokenInfoUri)
                    .timeout(Duration.ofSeconds(8))
                    .header("Accept", "application/json")
                    .GET()
                    .build();

            HttpResponse<String> tokenResponse = httpClient.send(
                    tokenRequest,
                    HttpResponse.BodyHandlers.ofString(
                            StandardCharsets.UTF_8
                    )
            );

            if (tokenResponse.statusCode() != 200) {

                log("Google token verification failed. HTTP status: "
                        + tokenResponse.statusCode());

                fail(request, response, "google_invalid_token");
                return;
            }

            String tokenJson = tokenResponse.body();

            // -------------------------------------------------
            // 4. EXTRACT GOOGLE TOKEN DETAILS
            // -------------------------------------------------

            String audience = jsonString(tokenJson, "aud");
            String issuer = jsonString(tokenJson, "iss");
            String email = jsonString(tokenJson, "email");
            String emailVerified = jsonString(tokenJson, "email_verified");
            String expirationValue = jsonString(tokenJson, "exp");
            String googleId = jsonString(tokenJson, "sub");
            String googleName = jsonString(tokenJson, "name");

            // CLIENT ID VALIDATION

            if (audience == null || !CLIENT_ID.equals(audience)) {

                log("Google Client ID mismatch.");
                log("Expected: " + CLIENT_ID);
                log("Received: " + audience);

                fail(request, response, "google_client_id_mismatch");
                return;
            }

            // ISSUER VALIDATION

            if (issuer == null
                    || !(issuer.equals("accounts.google.com")
                    || issuer.equals("https://accounts.google.com"))) {

                log("Invalid Google token issuer.");

                fail(request, response, "google_invalid_issuer");
                return;
            }

            // EMAIL VALIDATION

            if (email == null || email.isBlank()) {

                log("Google email missing.");

                fail(request, response, "google_email_missing");
                return;
            }

            // VERIFIED EMAIL

            if (!"true".equalsIgnoreCase(emailVerified)) {

                log("Google email is not verified.");

                fail(request, response, "google_unverified");
                return;
            }

            // TOKEN EXPIRATION

            long expiration;

            try {

                if (expirationValue == null) {
                    throw new NumberFormatException("Missing expiration");
                }

                expiration = Long.parseLong(expirationValue);

            } catch (NumberFormatException e) {

                log("Invalid Google token expiration.");

                fail(request, response, "google_invalid_expiration");
                return;
            }

            long currentTime =
                    System.currentTimeMillis() / 1000L;

            if (expiration <= currentTime) {

                log("Google token expired.");

                fail(request, response, "google_token_expired");
                return;
            }

            // -------------------------------------------------
            // 5. FIND ADMIN ACCOUNT
            // -------------------------------------------------

            email = email.trim().toLowerCase(Locale.ROOT);

            Admin admin = adminDAO.getAdminByEmail(email);

            if (admin == null) {

                // NEW GOOGLE USER

                log("New Google user. Creating admin account.");

                admin = createGoogleAdmin(
                        email,
                        googleName,
                        googleId
                );

                if (admin == null) {

                    log("Google account registration failed.");

                    fail(request, response, "google_register_failed");
                    return;
                }

            } else if (googleId != null
                    && !googleId.isBlank()
                    && (admin.getGoogleId() == null
                    || admin.getGoogleId().isBlank())) {

                // EXISTING ADMIN - LINK GOOGLE ACCOUNT

                adminDAO.updateGoogleLogin(
                        admin.getAdminId(),
                        googleId,
                        admin.getProfileImage()
                );

            }

            // -------------------------------------------------
            // 6. CREATE AUTHENTICATED SESSION
            // -------------------------------------------------

            HttpSession oldSession = request.getSession(false);

            if (oldSession != null) {
                oldSession.invalidate();
            }

            // Create a fresh session.
            // A new session already receives a new session ID.

            HttpSession session = request.getSession(true);

            session.setMaxInactiveInterval(30 * 60);

            // ADMIN DETAILS

            session.setAttribute(
                    "adminId",
                    admin.getAdminId()
            );

            session.setAttribute(
                    "adminName",
                    admin.getName()
            );

            session.setAttribute(
                    "adminUsername",
                    admin.getUsername()
            );

            session.setAttribute(
                    "adminEmail",
                    admin.getEmail()
            );

            session.setAttribute(
                    "adminPhone",
                    admin.getPhone()
            );

            session.setAttribute(
                    "loginType",
                    "GOOGLE"
            );

            // PROFILE IMAGE

            String profileImage = admin.getProfileImage();

            if (profileImage != null
                    && !profileImage.isBlank()) {

                session.setAttribute(
                        "profileImage",
                        profileImage
                );

            } else {

                session.removeAttribute("profileImage");
            }

            log("Google sign-in successful.");
            log("Admin ID: " + admin.getAdminId());

            // -------------------------------------------------
            // 7. REDIRECT TO DASHBOARD
            // -------------------------------------------------

            String dashboardUrl =
                    request.getContextPath() + DASHBOARD_PATH;

            log("Redirecting to: " + dashboardUrl);
            log("========================================");

            response.sendRedirect(dashboardUrl);

        } catch (InterruptedException e) {

            Thread.currentThread().interrupt();

            log("Google authentication interrupted.", e);

            fail(request, response, "google_interrupted");

        } catch (Exception e) {

            log("Unexpected Google authentication error.", e);

            fail(request, response, "google_failed");
        }
    }

    // =====================================================
    // CREATE GOOGLE ADMIN
    // =====================================================

    private Admin createGoogleAdmin(
            String email,
            String googleName,
            String googleId) {

        String localPart = email.contains("@")
                ? email.substring(0, email.indexOf('@'))
                : email;

        String name = (googleName == null || googleName.isBlank())
                ? localPart
                : googleName.trim();

        Admin admin = new Admin();

        admin.setName(name);
        admin.setPhone("");
        admin.setEmail(email);

        admin.setUsername(
                uniqueUsername(localPart)
        );

        admin.setPassword(
                PasswordUtil.hashPassword(
                        UUID.randomUUID().toString()
                                + UUID.randomUUID()
                )
        );

        if (!adminDAO.registerAdmin(admin)) {
            return null;
        }

        // GET SAVED ADMIN DETAILS

        Admin saved = adminDAO.getAdminByEmail(email);

        if (saved == null) {
            return null;
        }

        // SAVE GOOGLE ID

        if (googleId != null && !googleId.isBlank()) {

            adminDAO.updateGoogleLogin(
                    saved.getAdminId(),
                    googleId,
                    saved.getProfileImage()
            );

            saved.setGoogleId(googleId);
        }

        log("New Google admin created: "
                + saved.getAdminId());

        return saved;
    }

    // =====================================================
    // GENERATE UNIQUE USERNAME
    // =====================================================

    private String uniqueUsername(String base) {

        String clean = base.toLowerCase(Locale.ROOT)
                .replaceAll("[^a-z0-9._]", "");

        if (clean.isEmpty()) {
            clean = "user";
        }

        if (clean.length() > 30) {
            clean = clean.substring(0, 30);
        }

        String candidate = clean;

        int counter = 1;

        while (adminDAO.usernameExists(candidate)) {

            candidate = clean + counter;

            counter++;
        }

        return candidate;
    }

    // =====================================================
    // READ COOKIE
    // =====================================================

    private String cookieValue(
            HttpServletRequest request,
            String cookieName) {

        Cookie[] cookies = request.getCookies();

        if (cookies == null) {
            return null;
        }

        for (Cookie cookie : cookies) {

            if (cookieName.equals(cookie.getName())) {
                return cookie.getValue();
            }
        }

        return null;
    }

    // =====================================================
    // EXTRACT GOOGLE JSON STRING
    // =====================================================

    private String jsonString(String json, String key) {

        if (json == null || key == null) {
            return null;
        }

        Pattern pattern = Pattern.compile(
                "\"" + Pattern.quote(key)
                        + "\"\\s*:\\s*\"((?:[^\"\\\\]|\\\\.)*)\""
        );

        Matcher matcher = pattern.matcher(json);

        if (!matcher.find()) {
            return null;
        }

        String value = matcher.group(1);

        return value
                .replace("\\\"", "\"")
                .replace("\\\\", "\\")
                .replace("\\/", "/")
                .replace("\\n", "\n")
                .replace("\\r", "\r")
                .replace("\\t", "\t");
    }

    // =====================================================
    // GOOGLE LOGIN FAILURE
    // =====================================================

    private void fail(
            HttpServletRequest request,
            HttpServletResponse response,
            String errorCode) throws IOException {

        log("Google sign-in failed. Error code: " + errorCode);

        preventCache(response);

        String loginUrl = request.getContextPath()
                + LOGIN_PATH
                + "?error="
                + URLEncoder.encode(
                        errorCode,
                        StandardCharsets.UTF_8
                );

        response.sendRedirect(loginUrl);
    }
}