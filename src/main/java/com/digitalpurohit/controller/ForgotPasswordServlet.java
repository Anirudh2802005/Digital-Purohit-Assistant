package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.dao.impl.AdminDAOImpl;
import com.digitalpurohit.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAOImpl();
    }

    // Open forgot password page
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/forgot-password.jsp")
                .forward(request, response);
    }

    // Reset password using registered email and phone
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");

        // Validate required fields
        if (email == null || email.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || password == null || password.isEmpty()
                || confirmPassword == null
                || confirmPassword.isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Please fill in all fields.");

            showForgotPasswordPage(request, response);
            return;
        }

        email = email.trim();
        phone = phone.trim();

        // Validate email format
        if (!email.matches(
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {

            request.setAttribute(
                    "errorMessage",
                    "Please enter a valid email address.");

            showForgotPasswordPage(request, response);
            return;
        }

        // Validate password length
        if (password.length() < 8) {

            request.setAttribute(
                    "errorMessage",
                    "Password must contain at least 8 characters.");

            showForgotPasswordPage(request, response);
            return;
        }

        // Confirm password
        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                    "errorMessage",
                    "Passwords do not match.");

            showForgotPasswordPage(request, response);
            return;
        }

        try {

            // Hash password using the existing utility
            String hashedPassword =
                    PasswordUtil.hashPassword(password);

            // Reset password using email and registered phone
            boolean success = adminDAO.resetPassword(
                    email,
                    phone,
                    hashedPassword
            );

            if (success) {

                request.setAttribute(
                        "successMessage",
                        "Password updated successfully. Please log in.");

                request.getRequestDispatcher(
                        "/WEB-INF/views/login.jsp")
                        .forward(request, response);

            } else {

                request.setAttribute(
                        "errorMessage",
                        "Email address or phone number is incorrect.");

                showForgotPasswordPage(request, response);
            }

        } catch (Exception e) {

            getServletContext().log(
                    "Error resetting password.", e);

            request.setAttribute(
                    "errorMessage",
                    "Unable to reset password. Please try again.");

            showForgotPasswordPage(request, response);
        }
    }

    private void showForgotPasswordPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/forgot-password.jsp")
                .forward(request, response);
    }
}