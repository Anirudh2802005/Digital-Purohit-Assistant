package com.digitalpurohit.controller;

import java.io.IOException;
import java.sql.Time;

import com.digitalpurohit.dao.ReminderDAO;
import com.digitalpurohit.dao.impl.ReminderDAOImpl;
import com.digitalpurohit.model.Reminder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/update-reminder")
public class UpdateReminderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ReminderDAO reminderDAO;

    @Override
    public void init() {

        reminderDAO = new ReminderDAOImpl();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // =====================================================
        // SESSION CHECK
        // =====================================================

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED);

            response.getWriter().write("""
                {
                    "success": false,
                    "message": "Session expired. Please login again."
                }
                """);

            return;
        }

        // =====================================================
        // ADMIN ID
        // =====================================================

        int adminId =
                (Integer) session.getAttribute("adminId");

        // =====================================================
        // GET PARAMETERS
        // =====================================================

        String idParameter =
                request.getParameter("id");

        String timeParameter =
                request.getParameter("time");

        String enabledParameter =
                request.getParameter("enabled");

        if (idParameter == null ||
            idParameter.trim().isEmpty()) {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST);

            response.getWriter().write("""
                {
                    "success": false,
                    "message": "Reminder ID is required."
                }
                """);

            return;
        }

        if (timeParameter == null ||
            timeParameter.trim().isEmpty()) {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST);

            response.getWriter().write("""
                {
                    "success": false,
                    "message": "Reminder time is required."
                }
                """);

            return;
        }

        try {

            // =================================================
            // PARSE VALUES
            // =================================================

            int reminderId =
                    Integer.parseInt(idParameter);

            boolean enabled =
                    "true".equalsIgnoreCase(
                            enabledParameter);

            Time reminderTime =
                    Time.valueOf(timeParameter);

            System.out.println(
                    "======================================");

            System.out.println(
                    "UPDATE REMINDER");

            System.out.println(
                    "Admin ID    : " + adminId);

            System.out.println(
                    "Reminder ID : " + reminderId);

            System.out.println(
                    "Time        : " + reminderTime);

            System.out.println(
                    "Enabled     : " + enabled);

            // =================================================
            // FIRST VERIFY OWNERSHIP
            // =================================================

            Reminder existingReminder =
                    reminderDAO.getReminderById(
                            reminderId,
                            adminId);

            if (existingReminder == null) {

                System.out.println(
                        "Reminder NOT FOUND / NOT OWNED");

                response.setStatus(
                        HttpServletResponse.SC_FORBIDDEN);

                response.getWriter().write("""
                    {
                        "success": false,
                        "message": "Reminder not found or not owned by this admin."
                    }
                    """);

                return;
            }

            // =================================================
            // UPDATE MODEL
            // =================================================

            existingReminder.setReminderTime(
                    reminderTime);

            existingReminder.setEnabled(
                    enabled);

            existingReminder.setAdminId(
                    adminId);

            // =================================================
            // UPDATE DATABASE
            // =================================================

            boolean success =
                    reminderDAO.updateReminder(
                            existingReminder,
                            adminId);

            System.out.println(
                    "Update Result : " + success);

            System.out.println(
                    "======================================");

            // =================================================
            // RESPONSE
            // =================================================

            if (success) {

                response.getWriter().write("""
                    {
                        "success": true,
                        "message": "Reminder updated successfully."
                    }
                    """);

            } else {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST);

                response.getWriter().write("""
                    {
                        "success": false,
                        "message": "Unable to update reminder."
                    }
                    """);
            }

        } catch (NumberFormatException e) {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST);

            response.getWriter().write("""
                {
                    "success": false,
                    "message": "Invalid reminder ID."
                }
                """);

        } catch (IllegalArgumentException e) {

            e.printStackTrace();

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST);

            response.getWriter().write("""
                {
                    "success": false,
                    "message": "Invalid reminder time."
                }
                """);

        }  catch (Exception e) {

            e.printStackTrace();

            System.out.println("======================================");
            System.out.println("UPDATE REMINDER ERROR");
            System.out.println("Error Type    : " + e.getClass().getName());
            System.out.println("Error Message : " + e.getMessage());
            System.out.println("======================================");

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            response.getWriter().write(
                    "{"
                    + "\"success\":false,"
                    + "\"message\":\""
                    + e.getMessage()
                            .replace("\"", "'")
                            .replace("\n", " ")
                            .replace("\r", " ")
                    + "\""
                    + "}"
            );
        }
    }
}