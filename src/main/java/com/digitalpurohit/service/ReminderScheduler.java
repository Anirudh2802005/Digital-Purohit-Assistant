package com.digitalpurohit.service;

import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.dao.impl.AdminDAOImpl;
import com.digitalpurohit.model.Admin;

public class ReminderScheduler {

    private ScheduledExecutorService scheduler;

    private ReminderService reminderService;

    private AdminDAO adminDAO;


    // =========================================================
    // START
    // =========================================================

    public void start() {

        // Prevent duplicate scheduler
        if (scheduler != null &&
            !scheduler.isShutdown()) {

            System.out.println(
                    "Reminder Scheduler already running.");

            return;
        }


        reminderService =
                new ReminderService();

        adminDAO =
                new AdminDAOImpl();


        scheduler =
                Executors.newSingleThreadScheduledExecutor();


        System.out.println(
                "==========================================");

        System.out.println(
                "REMINDER SCHEDULER STARTED");

        System.out.println(
                "Runs every 1 minute");

        System.out.println(
                "Multi-user reminder occurrence engine");

        System.out.println(
                "==========================================");


        scheduler.scheduleAtFixedRate(
                () -> runForAllAdmins(),
                0,
                1,
                TimeUnit.MINUTES
        );
    }


    // =========================================================
    // RUN FOR ALL ADMINS
    // =========================================================

    private void runForAllAdmins() {

        try {

            System.out.println();
            System.out.println(
                    "------------------------------------------");

            System.out.println(
                    "REMINDER SCHEDULER TICK");

            System.out.println(
                    "Time: "
                    + java.time.LocalDateTime.now());


            // =================================================
            // GET ALL ADMINS
            // =================================================

            List<Admin> admins =
                    adminDAO.getAllAdmins();


            if (admins == null ||
                admins.isEmpty()) {

                System.out.println(
                        "No admins found.");

                return;
            }


            // =================================================
            // RUN FOR EACH ADMIN
            // =================================================

            for (Admin admin : admins) {

                if (admin == null) {
                    continue;
                }


                int adminId =
                        admin.getAdminId();


                if (adminId <= 0) {
                    continue;
                }


                System.out.println(
                        "Preparing reminders for Admin "
                        + adminId);


                try {

                    /*
                     * This creates today's occurrence
                     * for every enabled reminder belonging
                     * to this admin.
                     *
                     * INSERT IGNORE prevents duplicate
                     * occurrences for the same day.
                     */

                    reminderService
                            .runReminderEngine(
                                    adminId);


                } catch (Exception e) {

                    System.out.println(
                            "Reminder engine failed for Admin "
                            + adminId);

                    e.printStackTrace();
                }
            }


        } catch (Exception e) {

            System.out.println(
                    "Reminder scheduler error.");

            e.printStackTrace();


        } finally {

            System.out.println(
                    "------------------------------------------");
        }
    }


    // =========================================================
    // RUN FOR ONE ADMIN
    // =========================================================
    /*
     * Called after login.
     *
     * This is important for:
     *
     * User logs in at 6:45 PM
     * Reminder was set for 6:00 PM
     *
     * The occurrence will still exist,
     * and the popup endpoint will detect
     * that the reminder is overdue.
     */

    public static void runForAdmin(
            int adminId) {

        try {

            if (adminId <= 0) {

                System.out.println(
                        "Invalid Admin ID: "
                        + adminId);

                return;
            }


            System.out.println(
                    "==========================================");

            System.out.println(
                    "LOGIN REMINDER CHECK");

            System.out.println(
                    "Admin ID : "
                    + adminId);

            System.out.println(
                    "==========================================");


            ReminderService reminderService =
                    new ReminderService();


            reminderService.runReminderEngine(
                    adminId);


        } catch (Exception e) {

            System.out.println(
                    "Login reminder check failed.");

            e.printStackTrace();
        }
    }


    // =========================================================
    // STOP
    // =========================================================

    public void stop() {

        if (scheduler != null) {

            System.out.println(
                    "Stopping Reminder Scheduler");


            scheduler.shutdownNow();

            scheduler = null;
        }
    }
}