package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.dao.impl.AdminDAOImpl;
import com.digitalpurohit.model.Admin;
import com.digitalpurohit.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminDAO adminDAO;


    @Override
    public void init() {

        adminDAO =
                new AdminDAOImpl();
    }


    // =========================================================
    // GET - REGISTER PAGE
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/register.jsp")
                .forward(request, response);
    }


    // =========================================================
    // POST - REGISTER ADMIN
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        // =====================================================
        // GET FORM DATA
        // =====================================================

        String name =
                request.getParameter("name");

        String phone =
                request.getParameter("phone");

        String email =
                request.getParameter("email");

        String username =
                request.getParameter("username");

        String password =
                request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirmPassword");


        // =====================================================
        // BASIC VALIDATION
        // =====================================================

        if (name == null ||
            name.trim().isEmpty() ||

            phone == null ||
            phone.trim().isEmpty() ||

            email == null ||
            email.trim().isEmpty() ||

            username == null ||
            username.trim().isEmpty() ||

            password == null ||
            password.isEmpty() ||

            confirmPassword == null ||
            confirmPassword.isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "All fields are required.");

            request.getRequestDispatcher(
                    "/WEB-INF/views/register.jsp")
                    .forward(request, response);

            return;
        }


        // =====================================================
        // CLEAN INPUT
        // =====================================================

        name =
                name.trim();

        phone =
                phone.trim();

        email =
                email.trim().toLowerCase();

        username =
                username.trim();


        // =====================================================
        // PASSWORD MATCH
        // =====================================================

        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                    "errorMessage",
                    "Passwords do not match.");

            request.getRequestDispatcher(
                    "/WEB-INF/views/register.jsp")
                    .forward(request, response);

            return;
        }


        // =====================================================
        // USERNAME CHECK
        // =====================================================

        if (adminDAO.usernameExists(username)) {

            request.setAttribute(
                    "errorMessage",
                    "Username already exists.");

            request.getRequestDispatcher(
                    "/WEB-INF/views/register.jsp")
                    .forward(request, response);

            return;
        }


        // =====================================================
        // EMAIL CHECK
        // =====================================================

        if (adminDAO.emailExists(email)) {

            request.setAttribute(
                    "errorMessage",
                    "Email already exists.");

            request.getRequestDispatcher(
                    "/WEB-INF/views/register.jsp")
                    .forward(request, response);

            return;
        }


        // =====================================================
        // CREATE ADMIN
        // =====================================================

        Admin admin =
                new Admin();


        admin.setName(
                name);

        admin.setPhone(
                phone);

        admin.setEmail(
                email);

        admin.setUsername(
                username);

        admin.setPassword(
                PasswordUtil.hashPassword(
                        password));


        // =====================================================
        // SAVE ADMIN
        // =====================================================

        boolean success =
                adminDAO.registerAdmin(
                        admin);


        // =====================================================
        // REGISTRATION SUCCESS
        // =====================================================

        if (success) {

            request.setAttribute(
                    "successMessage",
                    "Registration successful. Please login with your email and password.");

            request.getRequestDispatcher(
                    "/WEB-INF/views/login.jsp")
                    .forward(request, response);

        }


        // =====================================================
        // REGISTRATION FAILED
        // =====================================================

        else {

            request.setAttribute(
                    "errorMessage",
                    "Registration failed. Please try again.");

            request.getRequestDispatcher(
                    "/WEB-INF/views/register.jsp")
                    .forward(request, response);
        }
    }
}