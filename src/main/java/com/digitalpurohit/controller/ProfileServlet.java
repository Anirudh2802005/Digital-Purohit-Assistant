package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.dao.impl.AdminDAOImpl;
import com.digitalpurohit.model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminDAO adminDAO;

    @Override
    public void init() {
        adminDAO = new AdminDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // 🔒 SESSION CHECK
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ✅ GET ADMIN ID
        int adminId = (Integer) session.getAttribute("adminId");

        // ✅ FETCH ADMIN DATA FROM DB
        Admin admin = adminDAO.getAdminById(adminId);

        // ❗ SAFETY CHECK
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ✅ UPDATE SESSION WITH CURRENT PROFILE IMAGE
        session.setAttribute("profileImage", admin.getProfileImage());

        // ✅ ALSO KEEP ADMIN NAME UPDATED
        session.setAttribute("adminName", admin.getName());

        // ✅ SEND DATA TO JSP
        request.setAttribute("admin", admin);

        // ✅ FORWARD TO PROFILE PAGE
        request.getRequestDispatcher(
                "/WEB-INF/views/profile/profile.jsp")
                .forward(request, response);
    }
}