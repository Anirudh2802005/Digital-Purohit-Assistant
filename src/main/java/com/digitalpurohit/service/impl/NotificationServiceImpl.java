package com.digitalpurohit.service.impl;

import com.digitalpurohit.dao.NotificationDAO;
import com.digitalpurohit.dao.impl.NotificationDAOImpl;
import com.digitalpurohit.model.Notification;
import com.digitalpurohit.service.NotificationService;

public class NotificationServiceImpl
        implements NotificationService {

    private final NotificationDAO notificationDAO;

    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    public NotificationServiceImpl() {

        notificationDAO =
                new NotificationDAOImpl();
    }


    // =========================================================
    // CREATE NORMAL NOTIFICATION
    // =========================================================

    @Override
    public boolean createNotification(
            int adminId,
            String title,
            String message,
            String module,
            String action,
            Integer referenceId,
            String redirectUrl) {

        try {

            // -------------------------------------------------
            // VALIDATE ADMIN ID
            // -------------------------------------------------

            if (adminId <= 0) {

                System.out.println(
                        "NOTIFICATION ERROR: Invalid Admin ID = "
                        + adminId
                );

                return false;
            }

            // -------------------------------------------------
            // CREATE NOTIFICATION
            // -------------------------------------------------

            Notification notification =
                    new Notification();

            notification.setAdminId(
                    adminId
            );

            notification.setTitle(
                    title
            );

            notification.setMessage(
                    message
            );

            notification.setModule(
                    module
            );

            notification.setAction(
                    action
            );

            notification.setReferenceId(
                    referenceId
            );

            notification.setRedirectUrl(
                    redirectUrl
            );

            // New notification = unread
            notification.setRead(
                    false
            );

            // -------------------------------------------------
            // SAVE TO DATABASE
            // -------------------------------------------------

            boolean success =
                    notificationDAO.addNotification(
                            notification
                    );

            System.out.println(
                    "NOTIFICATION CREATED"
                    + " | ADMIN ID = "
                    + adminId
                    + " | MODULE = "
                    + module
                    + " | ACTION = "
                    + action
                    + " | SUCCESS = "
                    + success
            );

            return success;

        } catch (Exception e) {

            System.out.println(
                    "ERROR CREATING NOTIFICATION"
            );

            e.printStackTrace();

            return false;
        }
    }


    // =========================================================
    // CREATE REMINDER
    // =========================================================

    @Override
    public boolean createReminder(
            int adminId,
            String title,
            String message,
            Integer referenceId,
            String redirectUrl) {

        try {

            // -------------------------------------------------
            // VALIDATE ADMIN ID
            // -------------------------------------------------

            if (adminId <= 0) {

                System.out.println(
                        "REMINDER ERROR: Invalid Admin ID = "
                        + adminId
                );

                return false;
            }

            // -------------------------------------------------
            // CREATE REMINDER NOTIFICATION
            // -------------------------------------------------

            Notification notification =
                    new Notification();

            notification.setAdminId(
                    adminId
            );

            notification.setTitle(
                    title
            );

            notification.setMessage(
                    message
            );

            notification.setModule(
                    "REMINDER"
            );

            notification.setAction(
                    "REMINDER"
            );

            notification.setReferenceId(
                    referenceId
            );

            notification.setRedirectUrl(
                    redirectUrl
            );

            // Reminder starts unread
            notification.setRead(
                    false
            );

            // -------------------------------------------------
            // SAVE TO DATABASE
            // -------------------------------------------------

            boolean success =
                    notificationDAO.addNotification(
                            notification
                    );

            System.out.println(
                    "REMINDER CREATED"
                    + " | ADMIN ID = "
                    + adminId
                    + " | REFERENCE ID = "
                    + referenceId
                    + " | SUCCESS = "
                    + success
            );

            return success;

        } catch (Exception e) {

            System.out.println(
                    "ERROR CREATING REMINDER"
            );

            e.printStackTrace();

            return false;
        }
    }
}