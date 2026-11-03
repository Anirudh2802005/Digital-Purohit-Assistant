package com.digitalpurohit.filter;

import java.io.IOException;
import java.util.Set;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthenticationFilter extends HttpFilter {

    private static final long serialVersionUID = 1L;

    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/",
            "/index.html",
            "/login",
            "/auth/google",
            "/register",
            "/forgot-password",
            "/logout"
    );

    @Override
    protected void doFilter(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();

        String path = uri.substring(contextPath.length());

        if (path.isEmpty()) {
            path = "/";
        }

        // =========================================
        // 1. PREVENT BROWSER CACHING
        // =========================================

        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate, private"
        );

        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // =========================================
        // 2. ALLOW STATIC RESOURCES
        // =========================================

        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // =========================================
        // 3. CHECK EXISTING SESSION
        // =========================================

        HttpSession session = request.getSession(false);

        boolean loggedIn = session != null
                && session.getAttribute("adminId") != null;

        // =========================================
        // 4. HANDLE LOGOUT
        // =========================================

        // Always allow LogoutServlet to execute.
        // It is responsible for invalidating the session.

        if ("/logout".equals(path)) {
            chain.doFilter(request, response);
            return;
        }

        // =========================================
        // 5. ALREADY LOGGED IN?
        // =========================================

        // If the user clicks Back and reaches the login
        // URL, redirect them to the dashboard.

        if ("/login".equals(path) && loggedIn) {

            response.sendRedirect(
                    contextPath + "/dashboard"
            );

            return;
        }

        // =========================================
        // 6. ALLOW PUBLIC PAGES
        // =========================================

        if (PUBLIC_PATHS.contains(path)) {

            chain.doFilter(request, response);

            return;
        }

        // =========================================
        // 7. PROTECT PRIVATE PAGES
        // =========================================

        if (!loggedIn) {

            response.sendRedirect(
                    contextPath + "/login"
            );

            return;
        }

        // =========================================
        // 8. ALLOW AUTHENTICATED USER
        // =========================================

        chain.doFilter(request, response);
    }

    // =========================================
    // STATIC RESOURCE CHECK
    // =========================================

    private boolean isStaticResource(String path) {

        String lowerPath = path.toLowerCase();

        return lowerPath.startsWith("/assets/")
                || lowerPath.startsWith("/css/")
                || lowerPath.startsWith("/js/")
                || lowerPath.startsWith("/images/")
                || lowerPath.startsWith("/fonts/")
                || lowerPath.startsWith("/uploads/")

                || lowerPath.endsWith(".css")
                || lowerPath.endsWith(".js")
                || lowerPath.endsWith(".png")
                || lowerPath.endsWith(".jpg")
                || lowerPath.endsWith(".jpeg")
                || lowerPath.endsWith(".gif")
                || lowerPath.endsWith(".svg")
                || lowerPath.endsWith(".ico")
                || lowerPath.endsWith(".webp")
                || lowerPath.endsWith(".woff")
                || lowerPath.endsWith(".woff2")
                || lowerPath.endsWith(".ttf")
                || lowerPath.endsWith(".eot");
    }
}