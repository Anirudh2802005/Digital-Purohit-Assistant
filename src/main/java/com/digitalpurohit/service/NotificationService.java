package com.digitalpurohit.service;

import com.digitalpurohit.model.Notification;

public interface NotificationService {

    // =========================================================
    // CREATE NORMAL NOTIFICATION
    // =========================================================

    boolean createNotification(
            int adminId,
            String title,
            String message,
            String module,
            String action,
            Integer referenceId,
            String redirectUrl
    );

    // =========================================================
    // CREATE REMINDER NOTIFICATION
    // =========================================================

    boolean createReminder(
            int adminId,
            String title,
            String message,
            Integer referenceId,
            String redirectUrl
    );
}