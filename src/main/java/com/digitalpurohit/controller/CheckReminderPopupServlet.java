package com.digitalpurohit.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.model.Reminder;
import com.digitalpurohit.service.ReminderService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/check-reminder-popup")
public class CheckReminderPopupServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ReminderService reminderService;

    private Gson gson;


    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

        reminderService = new ReminderService();

        gson = new Gson();
    }


    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
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
                        "loggedIn": false,
                        "reminders": []
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


        if (adminId <= 0) {

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED);

            response.getWriter().write(
                    """
                    {
                        "success": false,
                        "loggedIn": false,
                        "reminders": []
                    }
                    """);

            return;
        }


        try {

            System.out.println(
                    "==========================================");

            System.out.println(
                    "CHECK REMINDER POPUP");

            System.out.println(
                    "Admin ID : " + adminId);


            // =================================================
            // PREPARE TODAY
            // =================================================

            reminderService.prepareToday(
                    adminId);


            // =================================================
            // GET ALL DUE REMINDERS
            // =================================================

            List<Reminder> dueReminders =
                    reminderService.getDueReminders(
                            adminId);


            if (dueReminders == null) {

                dueReminders =
                        new ArrayList<>();
            }


            System.out.println(
                    "Due reminders : "
                    + dueReminders.size());


            // =================================================
            // BUILD RESPONSE
            // =================================================

            List<ReminderPopupResponse> popupList =
                    new ArrayList<>();


            for (Reminder reminder : dueReminders) {

                ReminderPopupResponse popup =
                        createPopupResponse(
                                request,
                                reminder);


                popupList.add(
                        popup);


                System.out.println(
                        "Reminder found"
                        + " | Reminder ID = "
                        + reminder.getReminderId()
                        + " | Occurrence ID = "
                        + reminder.getOccurrenceId()
                        + " | Name = "
                        + reminder.getReminderName()
                        + " | Type = "
                        + reminder.getReminderType()
                        + " | Time = "
                        + reminder.getReminderTime());
            }


            // =================================================
            // FINAL RESPONSE
            // =================================================

            ReminderResponse finalResponse =
                    new ReminderResponse();

            finalResponse.success = true;

            finalResponse.hasReminder =
                    !popupList.isEmpty();

            finalResponse.reminders =
                    popupList;


            response.getWriter().write(
                    gson.toJson(
                            finalResponse));


            System.out.println(
                    "Reminder response sent.");

            System.out.println(
                    "==========================================");


        } catch (Exception e) {

            System.out.println(
                    "Reminder popup check failed.");

            e.printStackTrace();


            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR);


            response.getWriter().write(
                    """
                    {
                        "success": false,
                        "hasReminder": false,
                        "reminders": [],
                        "message": "Server error"
                    }
                    """);
        }
    }


    // =========================================================
    // CREATE POPUP RESPONSE
    // =========================================================

    private ReminderPopupResponse createPopupResponse(
            HttpServletRequest request,
            Reminder reminder) {

        ReminderPopupResponse response =
                new ReminderPopupResponse();


        response.occurrenceId =
                reminder.getOccurrenceId();


        response.reminderId =
                reminder.getReminderId();


        response.reminderName =
                reminder.getReminderName();


        response.reminderType =
                reminder.getReminderType();


        response.reminderTime =
                reminder.getReminderTime() != null
                        ? reminder.getReminderTime().toString()
                        : null;


        response.message =
                createMessage(
                        reminder);


        response.redirectUrl =
                createRedirectUrl(
                        request,
                        reminder);


        return response;
    }


    // =========================================================
    // MESSAGE
    // =========================================================

    private String createMessage(
            Reminder reminder) {

        String type =
                reminder.getReminderType();


        if ("TODAY_EVENTS".equals(type)) {

            return
                    "You have events scheduled for today.";
        }


        if ("TOMORROW_EVENTS".equals(type)) {

            return
                    "You have events scheduled for tomorrow.";
        }


        if ("PENDING_PAYMENTS".equals(type)) {

            return
                    "You have pending payments to check.";
        }


        return
                "You have a reminder.";
    }


    // =========================================================
    // REDIRECT URL
    // =========================================================

    private String createRedirectUrl(
            HttpServletRequest request,
            Reminder reminder) {

        String contextPath =
                request.getContextPath();


        String type =
                reminder.getReminderType();


        if ("TODAY_EVENTS".equals(type)) {

            return contextPath +
                    "/events";
        }


        if ("TOMORROW_EVENTS".equals(type)) {

            return contextPath +
                    "/events";
        }


        if ("PENDING_PAYMENTS".equals(type)) {

            return contextPath +
                    "/pending-payments";
        }


        return contextPath +
                "/reminders";
    }


    // =========================================================
    // SINGLE POPUP RESPONSE
    // =========================================================

    private static class ReminderPopupResponse {

        int occurrenceId;

        int reminderId;

        String reminderName;

        String reminderType;

        String reminderTime;

        String message;

        String redirectUrl;
    }


    // =========================================================
    // FINAL RESPONSE
    // =========================================================

    private static class ReminderResponse {

        boolean success;

        boolean hasReminder;

        List<ReminderPopupResponse> reminders;
    }
}