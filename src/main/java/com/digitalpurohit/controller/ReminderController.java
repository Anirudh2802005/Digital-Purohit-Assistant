package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.ReminderDAO;
import com.digitalpurohit.dao.impl.ReminderDAOImpl;
import com.digitalpurohit.model.Reminder;
import com.digitalpurohit.service.ReminderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/reminders")
public class ReminderController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ReminderDAO reminderDAO;

    private ReminderService reminderService;


    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

        reminderDAO =
                new ReminderDAOImpl();

        reminderService =
                new ReminderService();
    }


    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        // =====================================================
        // SESSION
        // =====================================================

        HttpSession session =
                request.getSession(false);


        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login");

            return;
        }


        // =====================================================
        // CURRENT ADMIN
        // =====================================================

        int adminId =
                (Integer)
                session.getAttribute("adminId");

     // =====================================================
     // CREATE DEFAULT REMINDERS FOR THIS ADMIN
     // =====================================================

     reminderDAO.createDefaultReminders(adminId);
        System.out.println(
                "==========================================");

        System.out.println(
                "REMINDER CENTER");

        System.out.println(
                "Admin ID : "
                + adminId);


        // =====================================================
        // PREPARE TODAY'S OCCURRENCES
        // =====================================================

        /*
         * Important:
         *
         * If the user logs in after the reminder time,
         * today's occurrence is still created.
         *
         * Example:
         *
         * Reminder = 6:00 PM
         * Login    = 6:30 PM
         *
         * Occurrence still exists.
         */

        try {

            reminderService.prepareToday(
                    adminId);

        } catch (Exception e) {

            System.out.println(
                    "Unable to prepare reminders.");

            e.printStackTrace();
        }


        // =====================================================
        // GET THIS ADMIN'S REMINDERS
        // =====================================================

        List<Reminder> reminders =
                reminderDAO.getAllReminders(
                        adminId);


        if (reminders == null) {

            reminders =
                    new java.util.ArrayList<>();
        }


        System.out.println(
                "Total Reminders : "
                + reminders.size());


        // =====================================================
        // COUNT ENABLED / DISABLED
        // =====================================================

        int enabledCount = 0;

        int disabledCount = 0;


        for (Reminder reminder : reminders) {

            if (reminder.isEnabled()) {

                enabledCount++;

            } else {

                disabledCount++;
            }


            System.out.println(
                    "Reminder ID : "
                    + reminder.getReminderId()
                    + " | Admin ID : "
                    + reminder.getAdminId()
                    + " | Name : "
                    + reminder.getReminderName()
                    + " | Type : "
                    + reminder.getReminderType()
                    + " | Time : "
                    + reminder.getReminderTime()
                    + " | Enabled : "
                    + reminder.isEnabled());
        }


        // =====================================================
        // SEND DATA TO JSP
        // =====================================================

        request.setAttribute(
                "reminders",
                reminders);


        request.setAttribute(
                "adminId",
                adminId);


        request.setAttribute(
                "enabledCount",
                enabledCount);


        request.setAttribute(
                "disabledCount",
                disabledCount);


        // =====================================================
        // FORWARD
        // =====================================================

        request.getRequestDispatcher(
                "/WEB-INF/views/reminder-dashboard.jsp")
                .forward(
                        request,
                        response);


        System.out.println(
                "==========================================");
    }
}