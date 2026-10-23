package com.digitalpurohit.controller;

import com.digitalpurohit.service.ReminderScheduler;
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


    // =========================================================
    // GET - LOGIN PAGE
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/login.jsp")
                .forward(request, response);
    }


    // =========================================================
    // POST - EMAIL + PASSWORD LOGIN
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");


        // =====================================================
        // VALIDATION
        // =====================================================

        if (email == null ||
            email.trim().isEmpty() ||
            password == null ||
            password.isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Email and Password are required");

            request.getRequestDispatcher(
                    "/WEB-INF/views/login.jsp")
                    .forward(request, response);

            return;
        }


        email =
                email.trim().toLowerCase();


        // =====================================================
        // FIND ADMIN BY EMAIL
        // =====================================================

        Admin admin =
                adminDAO.getAdminByEmail(email);


        // =====================================================
        // VERIFY PASSWORD
        // =====================================================

        boolean valid = false;


        if (admin != null &&
            admin.getPassword() != null) {

            valid =
                    PasswordUtil.verifyPassword(
                            password,
                            admin.getPassword());
        }


        // =====================================================
        // INVALID LOGIN
        // =====================================================

        if (!valid) {

            request.setAttribute(
                    "errorMessage",
                    "Invalid Email or Password");

            request.getRequestDispatcher(
                    "/WEB-INF/views/login.jsp")
                    .forward(request, response);

            return;
        }


        // =====================================================
        // REMOVE OLD SESSION
        // =====================================================

        HttpSession oldSession =
                request.getSession(false);


        if (oldSession != null) {

            oldSession.invalidate();
        }


        // =====================================================
        // CREATE NEW SESSION
        // =====================================================

        HttpSession session =
                request.getSession(true);


        // =====================================================
        // ADMIN INFORMATION
        // =====================================================

        session.setAttribute(
                "adminId",
                admin.getAdminId());

        session.setAttribute(
                "adminName",
                admin.getName());

        session.setAttribute(
                "adminUsername",
                admin.getUsername());

        session.setAttribute(
                "adminEmail",
                admin.getEmail());

        session.setAttribute(
                "adminPhone",
                admin.getPhone());


        // =====================================================
        // PROFILE IMAGE
        // =====================================================

        if (admin.getProfileImage() != null &&
            !admin.getProfileImage()
                 .trim()
                 .isEmpty()) {

            session.setAttribute(
                    "profileImage",
                    admin.getProfileImage());

        } else {

            session.removeAttribute(
                    "profileImage");
        }


        // =====================================================
        // LOGIN TYPE
        // =====================================================

        session.setAttribute(
                "loginType",
                "EMAIL");


        // =====================================================
        // RUN REMINDER ENGINE
        // =====================================================

        try {

            ReminderScheduler.runForAdmin(
                    admin.getAdminId());

        } catch (Exception e) {

            e.printStackTrace();
        }


        // =====================================================
        // DASHBOARD
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/dashboard");
    }
}