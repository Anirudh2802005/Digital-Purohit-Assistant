package com.digitalpurohit.service;

import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import com.digitalpurohit.dao.ReminderDAO;
import com.digitalpurohit.dao.impl.ReminderDAOImpl;
import com.digitalpurohit.model.Reminder;

public class ReminderService {

    private final ReminderDAO reminderDAO;


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    public ReminderService() {

        reminderDAO =
                new ReminderDAOImpl();
    }


    // =========================================================
    // RUN REMINDER ENGINE
    // =========================================================
    /*
     * Called for one admin.
     *
     * Responsibilities:
     *
     * 1. Get enabled reminders
     * 2. Create today's occurrence
     * 3. Check whether reminder time has arrived
     * 4. Keep dismissed reminders dismissed
     *
     * This method DOES NOT show the popup.
     *
     * The popup is handled by the frontend through
     * CheckReminderPopupServlet.
     */

    public void runReminderEngine(
            int adminId) {

        try {

            if (adminId <= 0) {

                System.out.println(
                        "Invalid Admin ID: "
                        + adminId);

                return;
            }


            Date today =
                    Date.valueOf(
                            LocalDate.now());


            System.out.println(
                    "==========================================");

            System.out.println(
                    "REMINDER ENGINE");

            System.out.println(
                    "Admin ID : "
                    + adminId);

            System.out.println(
                    "Date     : "
                    + today);


            // =================================================
            // GET ENABLED REMINDERS
            // =================================================

            List<Reminder> reminders =
                    reminderDAO.getEnabledReminders(
                            adminId);


            if (reminders == null ||
                reminders.isEmpty()) {

                System.out.println(
                        "No enabled reminders for Admin "
                        + adminId);

                return;
            }


            // =================================================
            // CREATE TODAY'S OCCURRENCES
            // =================================================

            for (Reminder reminder : reminders) {

                try {

                    reminderDAO.createOccurrence(
                            reminder.getReminderId(),
                            adminId,
                            today);


                    System.out.println(
                            "Occurrence checked/created"
                            + " | Reminder ID = "
                            + reminder.getReminderId()
                            + " | Type = "
                            + reminder.getReminderType());


                } catch (Exception e) {

                    System.out.println(
                            "Failed to create occurrence"
                            + " | Reminder ID = "
                            + reminder.getReminderId());

                    e.printStackTrace();
                }
            }


            System.out.println(
                    "Reminder occurrences prepared.");

            System.out.println(
                    "==========================================");


        } catch (Exception e) {

            System.out.println(
                    "Reminder engine failed"
                    + " | Admin ID = "
                    + adminId);

            e.printStackTrace();
        }
    }


    // =========================================================
    // PREPARE TODAY'S REMINDERS
    // =========================================================
    /*
     * Useful when the user logs in.
     *
     * Example:
     *
     * Reminder = 6:00 PM
     * User logs in = 6:30 PM
     *
     * The occurrence is still created.
     */

    public void prepareToday(
            int adminId) {

        try {

            if (adminId <= 0) {
                return;
            }


            Date today =
                    Date.valueOf(
                            LocalDate.now());


            List<Reminder> reminders =
                    reminderDAO.getEnabledReminders(
                            adminId);


            if (reminders == null) {
                return;
            }


            for (Reminder reminder : reminders) {

                reminderDAO.createOccurrence(
                        reminder.getReminderId(),
                        adminId,
                        today);
            }


        } catch (Exception e) {

            System.out.println(
                    "Unable to prepare today's reminders"
                    + " | Admin ID = "
                    + adminId);

            e.printStackTrace();
        }
    }


    // =========================================================
    // GET DUE REMINDERS
    // =========================================================
    /*
     * Returns ALL reminders whose time has arrived.
     *
     * This is important because:
     *
     * 6:30 PM
     * Today's Events
     *
     * 6:30 PM
     * Tomorrow's Events
     *
     * 6:30 PM
     * Pending Payments
     *
     * must all be available.
     */

    public List<Reminder> getDueReminders(
            int adminId) {

        Date today =
                Date.valueOf(
                        LocalDate.now());


        prepareToday(adminId);


        return reminderDAO
                .getPendingPopupReminders(
                        adminId,
                        today);
    }


    // =========================================================
    // GET NEXT DUE REMINDER
    // =========================================================
    /*
     * Returns only ONE reminder.
     *
     * This is useful if the frontend wants
     * one popup at a time.
     */

    public Reminder getNextDueReminder(
            int adminId) {

        Date today =
                Date.valueOf(
                        LocalDate.now());


        prepareToday(adminId);


        return reminderDAO
                .getNextDueReminder(
                        adminId,
                        today);
    }


    // =========================================================
    // DISMISS REMINDER
    // =========================================================

    public boolean dismissReminder(
            int occurrenceId,
            int adminId) {

        if (occurrenceId <= 0 ||
            adminId <= 0) {

            return false;
        }


        return reminderDAO
                .dismissOccurrence(
                        occurrenceId,
                        adminId);
    }


    // =========================================================
    // MARK TRIGGERED
    // =========================================================

    public boolean markTriggered(
            int occurrenceId,
            int adminId) {

        if (occurrenceId <= 0 ||
            adminId <= 0) {

            return false;
        }


        return reminderDAO
                .markOccurrenceTriggered(
                        occurrenceId,
                        adminId);
    }


    // =========================================================
    // CHECK WHETHER DISMISSED
    // =========================================================

    public boolean isDismissed(
            int reminderId,
            int adminId) {

        Date today =
                Date.valueOf(
                        LocalDate.now());


        return reminderDAO
                .isOccurrenceDismissed(
                        reminderId,
                        adminId,
                        today);
    }


    // =========================================================
    // GET TODAY'S OCCURRENCES
    // =========================================================

    public List<Reminder> getTodayOccurrences(
            int adminId) {

        Date today =
                Date.valueOf(
                        LocalDate.now());


        return reminderDAO
                .getOccurrencesByDate(
                        adminId,
                        today);
    }


    // =========================================================
    // GET CURRENT TIME
    // =========================================================

    public LocalTime getCurrentTime() {

        return LocalTime.now();
    }
}