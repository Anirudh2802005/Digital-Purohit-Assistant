package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.NotificationDAO;
import com.digitalpurohit.dao.impl.NotificationDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/mark-all-notifications-read")
public class MarkAllNotificationsReadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        // =====================================================
        // CHECK LOGIN
        // =====================================================

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED
            );

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Not logged in\"}"
            );

            return;
        }

        // =====================================================
        // CURRENT ADMIN
        // =====================================================

        int adminId =
                (Integer) session.getAttribute("adminId");

        // =====================================================
        // MARK ONLY CURRENT ADMIN'S NOTIFICATIONS
        // =====================================================

        boolean success =
                notificationDAO.markAllAsRead(adminId);

        response.getWriter().write(
                "{\"success\":" + success + "}"
        );
    }
}