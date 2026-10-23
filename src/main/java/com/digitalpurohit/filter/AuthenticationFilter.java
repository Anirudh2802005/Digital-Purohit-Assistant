package com.digitalpurohit.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthenticationFilter extends HttpFilter implements Filter {

    private static final long serialVersionUID = 1L;

    @Override
    public void doFilter(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        String uri = request.getRequestURI();

        HttpSession session = request.getSession(false);

        boolean loggedIn =
                session != null &&
                session.getAttribute("adminUsername") != null;

        /*
         * Public pages and resources.
         *
         * These pages can be accessed without logging in.
         */
        boolean allowed =
                uri.equals(request.getContextPath() + "/")
             || uri.endsWith("/index.html")
             || uri.endsWith("/login")
             || uri.endsWith("/register")
             || uri.endsWith("/forgot-password")
             || uri.contains("/assets/")
             || uri.endsWith(".css")
             || uri.endsWith(".js")
             || uri.endsWith(".png")
             || uri.endsWith(".jpg")
             || uri.endsWith(".jpeg")
             || uri.endsWith(".gif")
             || uri.endsWith(".ico");

        /*
         * User is already logged in.
         */
        if (loggedIn) {

            response.setHeader(
                    "Cache-Control",
                    "no-cache, no-store, must-revalidate");

            response.setHeader(
                    "Pragma",
                    "no-cache");

            response.setDateHeader(
                    "Expires",
                    0);

            chain.doFilter(request, response);

        /*
         * User is not logged in,
         * but the requested page/resource is public.
         */
        } else if (allowed) {

            chain.doFilter(request, response);

        /*
         * User is not logged in and the requested
         * page is protected.
         */
        } else {

            response.sendRedirect(
                    request.getContextPath() + "/login");
        }
    }
}