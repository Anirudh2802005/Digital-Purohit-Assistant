package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.model.Admin;
import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.dao.impl.AdminDAOImpl;
import com.digitalpurohit.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminDAO adminDAO;

    @Override
    public void init() {
        adminDAO = new AdminDAOImpl();
    }

    private void preventCache(HttpServletResponse response) {
        response.setHeader(
            "Cache-Control",
            "no-store, no-cache, must-revalidate, private"
        );
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    // GET - LOGIN PAGE
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        preventCache(response);

        // If admin is already logged in, do not show login page.
        HttpSession session = request.getSession(false);

        if (session != null &&
                session.getAttribute("adminId") != null) {

            response.sendRedirect(
                request.getContextPath() + "/dashboard"
            );
            return;
        }

        request.getRequestDispatcher(
            "/WEB-INF/views/login.jsp"
        ).forward(request, response);
    }

    // POST - EMAIL AND PASSWORD LOGIN
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        preventCache(response);

        System.out.println(
            "========== LOGIN SERVLET POST CALLED =========="
        );

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // VALIDATION
        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {

            request.setAttribute(
                "errorMessage",
                "Email and Password are required"
            );

            request.getRequestDispatcher(
                "/WEB-INF/views/login.jsp"
            ).forward(request, response);

            return;
        }

        email = email.trim().toLowerCase();

        // FIND ADMIN
        Admin admin = adminDAO.getAdminByEmail(email);

        System.out.println("LOGIN DEBUG: Email received = " + email);
        System.out.println("LOGIN DEBUG: Admin found = " + (admin != null));

        boolean valid = false;

        if (admin != null && admin.getPassword() != null) {

            System.out.println(
                "LOGIN DEBUG: Stored hash length = "
                + admin.getPassword().length()
            );

            System.out.println(
                "LOGIN DEBUG: BCrypt hash format = "
                + admin.getPassword().startsWith("$2")
            );

            try {
                valid = PasswordUtil.verifyPassword(
                    password,
                    admin.getPassword()
                );

                System.out.println(
                    "LOGIN DEBUG: Password verified = " + valid
                );

            } catch (Exception e) {
                System.out.println("LOGIN DEBUG: BCrypt verification failed");
                e.printStackTrace();
            }
        } else {
            System.out.println("LOGIN DEBUG: Admin or password hash is missing");
        }

        // VERIFY PASSWORD
         valid = false;

        if (admin != null && admin.getPassword() != null) {
            valid = PasswordUtil.verifyPassword(
                password,
                admin.getPassword()
            );
        }

        // INVALID LOGIN
        if (!valid) {

            request.setAttribute(
                "errorMessage",
                "Invalid Email or Password"
            );

            request.getRequestDispatcher(
                "/WEB-INF/views/login.jsp"
            ).forward(request, response);

            return;
        }

        // INVALIDATE PREVIOUS SESSION
        HttpSession oldSession = request.getSession(false);

        if (oldSession != null) {
            oldSession.invalidate();
        }

        // CREATE A FRESH SESSION
        HttpSession session = request.getSession(true);

        // SESSION TIMEOUT: 30 MINUTES
        session.setMaxInactiveInterval(30 * 60);

        // ADMIN DETAILS
        session.setAttribute("adminId", admin.getAdminId());
        session.setAttribute("adminName", admin.getName());
        session.setAttribute("adminUsername", admin.getUsername());
        session.setAttribute("adminEmail", admin.getEmail());
        session.setAttribute("adminPhone", admin.getPhone());

        // PROFILE IMAGE
        if (admin.getProfileImage() != null
                && !admin.getProfileImage().trim().isEmpty()) {

            session.setAttribute(
                "profileImage",
                admin.getProfileImage()
            );
        }

        // LOGIN TYPE
        session.setAttribute("loginType", "EMAIL");

        System.out.println(
            "Admin login successful: " + admin.getAdminId()
        );

        // REDIRECT TO DASHBOARD
        response.sendRedirect(
            request.getContextPath() + "/dashboard"
        );
    }
}