package com.digitalpurohit.dao;

import java.sql.Date;
import java.util.List;

import com.digitalpurohit.model.Reminder;

public interface ReminderDAO {

    // =========================================================
    // REMINDER SETTINGS
    // =========================================================

    boolean saveReminder(Reminder reminder);

    boolean updateReminder(
            Reminder reminder,
            int adminId);

    boolean updateReminderStatus(
            int reminderId,
            boolean enabled,
            int adminId);

    boolean deleteReminder(
            int reminderId,
            int adminId);


    // =========================================================
    // GET REMINDER
    // =========================================================

    Reminder getReminderById(
            int reminderId,
            int adminId);

    List<Reminder> getAllReminders(
            int adminId);

    List<Reminder> getEnabledReminders(
            int adminId);

    Reminder getReminderByType(
            String reminderType,
            int adminId);
 // =========================================================
 // CREATE DEFAULT REMINDERS FOR ADMIN
 // =========================================================

 boolean createDefaultReminders(int adminId);

    // =========================================================
    // ENABLE / DISABLE
    // =========================================================

    boolean enableReminder(
            int reminderId,
            int adminId);

    boolean disableReminder(
            int reminderId,
            int adminId);


    // =========================================================
    // LAST TRIGGERED
    // =========================================================

    boolean updateLastTriggeredDate(
            int reminderId,
            Date date,
            int adminId);


    // =========================================================
    // REMINDER OCCURRENCES
    // =========================================================

    /*
     * Creates today's occurrence for a reminder.
     *
     * Because reminder_occurrences has:
     *
     * UNIQUE(reminder_id, reminder_date)
     *
     * the same reminder cannot get duplicate
     * occurrences for the same day.
     */
    boolean createOccurrence(
            int reminderId,
            int adminId,
            Date reminderDate);


    /*
     * Get one occurrence for a specific
     * reminder and date.
     */
    Reminder getOccurrence(
            int reminderId,
            int adminId,
            Date reminderDate);


    /*
     * Get all occurrences for an admin
     * on a particular date.
     */
    List<Reminder> getOccurrencesByDate(
            int adminId,
            Date reminderDate);


    /*
     * Get the next reminder that is due
     * for the logged-in admin.
     *
     * This is used by the popup system.
     */
    Reminder getNextDueReminder(
            int adminId,
            Date reminderDate);


    /*
     * Mark reminder occurrence as triggered.
     */
    boolean markOccurrenceTriggered(
            int occurrenceId,
            int adminId);


    /*
     * Mark reminder occurrence as dismissed.
     *
     * This is the important method for:
     *
     * "Dismiss once -> don't show again today."
     */
    boolean dismissOccurrence(
            int occurrenceId,
            int adminId);


    /*
     * Check whether an occurrence has
     * already been dismissed.
     */
    boolean isOccurrenceDismissed(
            int reminderId,
            int adminId,
            Date reminderDate);


    /*
     * Get all pending popup reminders
     * for the current admin.
     *
     * These can be queued one after another
     * when multiple reminders have the
     * same time.
     */
    List<Reminder> getPendingPopupReminders(
            int adminId,
            Date reminderDate);
}