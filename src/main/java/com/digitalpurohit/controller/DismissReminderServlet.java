package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.service.ReminderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dismiss-reminder")
public class DismissReminderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ReminderService reminderService;

    @Override
    public void init() {

        reminderService =
                new ReminderService();
    }


    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType(
                "application/json");

        response.setCharacterEncoding(
                "UTF-8");


        // =====================================================
        // SESSION
        // =====================================================

        HttpSession session =
                request.getSession(false);


        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED);

            response.getWriter().write(
                    """
                    {
                        "success": false,
                        "message": "Not logged in"
                    }
                    """);

            return;
        }


        // =====================================================
        // ADMIN ID
        // =====================================================

        int adminId =
                (Integer)
                session.getAttribute("adminId");


        // =====================================================
        // OCCURRENCE ID
        // =====================================================

        String occurrenceParameter =
                request.getParameter(
                        "occurrenceId");


        if (occurrenceParameter == null ||
            occurrenceParameter.trim().isEmpty()) {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST);

            response.getWriter().write(
                    """
                    {
                        "success": false,
                        "message": "Occurrence ID is required"
                    }
                    """);

            return;
        }


        int occurrenceId;

        try {

            occurrenceId =
                    Integer.parseInt(
                            occurrenceParameter);

        } catch (NumberFormatException e) {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST);

            response.getWriter().write(
                    """
                    {
                        "success": false,
                        "message": "Invalid occurrence ID"
                    }
                    """);

            return;
        }


        // =====================================================
        // DISMISS
        // =====================================================

        boolean success =
                reminderService.dismissReminder(
                        occurrenceId,
                        adminId);


        // =====================================================
        // RESPONSE
        // =====================================================

        if (success) {

            System.out.println(
                    "Reminder dismissed"
                    + " | Admin ID = "
                    + adminId
                    + " | Occurrence ID = "
                    + occurrenceId);


            response.getWriter().write(
                    """
                    {
                        "success": true,
                        "message": "Reminder dismissed"
                    }
                    """);

        } else {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST);

            response.getWriter().write(
                    """
                    {
                        "success": false,
                        "message": "Unable to dismiss reminder"
                    }
                    """);
        }
    }
}