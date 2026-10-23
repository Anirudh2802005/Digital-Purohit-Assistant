package com.digitalpurohit.dao;

import java.sql.Date;
import java.util.List;

import com.digitalpurohit.model.Notification;

public interface NotificationDAO {

    // =========================================================
    // CREATE
    // =========================================================

    boolean addNotification(Notification notification);


    // =========================================================
    // NORMAL NOTIFICATIONS
    // =========================================================

    List<Notification> getAllNotifications(int adminId);

    List<Notification> getUnreadNotifications(int adminId);

    int getUnreadCount(int adminId);


    // =========================================================
    // GET BY ID
    // =========================================================

    Notification getNotificationById(
            int notificationId,
            int adminId);


    // =========================================================
    // MARK AS READ
    // =========================================================

    boolean markAsRead(
            int notificationId,
            int adminId);

    boolean markAllAsRead(
            int adminId);


    // =========================================================
    // REMINDERS
    // =========================================================

    Notification getNextUnreadReminder(
            int adminId);

    boolean reminderExists(
            int reminderId,
            Date date,
            int adminId);

    boolean reminderAlreadyCreatedToday(
            int reminderId,
            int adminId);


    // =========================================================
    // DELETE
    // =========================================================

    boolean deleteNotification(
            int notificationId,
            int adminId);

    boolean deleteAllNotifications(
            int adminId);

    boolean deleteOldNotifications(
            int adminId,
            int days);
}