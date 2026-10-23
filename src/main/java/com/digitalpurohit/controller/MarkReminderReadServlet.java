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

@WebServlet("/mark-reminder-read")
public class MarkReminderReadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private NotificationDAO notificationDAO =
            new NotificationDAOImpl();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        System.out.println("==================================");
        System.out.println("MARK REMINDER READ CALLED");
        System.out.println("Time : " + java.time.LocalDateTime.now());

        // ==========================================
        // SESSION
        // ==========================================

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            System.out.println("ERROR: Admin session not found");

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED);

            response.getWriter().print("false");

            return;
        }

        // ==========================================
        // ADMIN ID
        // ==========================================

        int adminId =
                (Integer) session.getAttribute("adminId");

        System.out.println(
                "Admin ID : " + adminId);

        // ==========================================
        // NOTIFICATION ID
        // ==========================================

        String notificationIdParameter =
                request.getParameter("notificationId");

        System.out.println(
                "Notification ID parameter : "
                + notificationIdParameter);

        if (notificationIdParameter == null ||
            notificationIdParameter.trim().isEmpty()) {

            System.out.println(
                    "ERROR: notificationId is missing");

            response.getWriter().print("false");

            return;
        }

        try {

            int notificationId =
                    Integer.parseInt(
                            notificationIdParameter);

            System.out.println(
                    "Notification ID : "
                    + notificationId);

            // ==========================================
            // MARK AS READ
            // ==========================================

            boolean success =
                    notificationDAO.markAsRead(
                            notificationId,
                            adminId);

            System.out.println(
                    "Updated Successfully : "
                    + success);

            response.getWriter().print(success);

        } catch (NumberFormatException e) {

            System.out.println(
                    "ERROR: Invalid notification ID");

            e.printStackTrace();

            response.getWriter().print("false");

        } catch (Exception e) {

            System.out.println(
                    "ERROR while marking reminder as read");

            e.printStackTrace();

            response.getWriter().print("false");
        }

        System.out.println("==================================");
    }
}