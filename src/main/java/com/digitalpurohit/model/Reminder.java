package com.digitalpurohit.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Reminder {

    // =========================================================
    // REMINDER SETTINGS
    // =========================================================

    private int reminderId;

    private int adminId;

    private String reminderName;

    private String reminderType;

    private boolean enabled;

    private Time reminderTime;

    private int frequencyDays;

    private boolean emailEnabled;

    private Timestamp createdAt;

    private int reminderInterval;

    private Date lastTriggeredDate;


    // =========================================================
    // REMINDER OCCURRENCE
    // =========================================================

    private int occurrenceId;

    private Date reminderDate;

    private boolean triggered;

    private boolean dismissed;

    private Timestamp dismissedAt;


    // =========================================================
    // DEFAULT CONSTRUCTOR
    // =========================================================

    public Reminder() {
    }


    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    public Reminder(
            String reminderName,
            String reminderType,
            boolean enabled,
            Time reminderTime,
            int frequencyDays,
            boolean emailEnabled) {

        this.reminderName = reminderName;
        this.reminderType = reminderType;
        this.enabled = enabled;
        this.reminderTime = reminderTime;
        this.frequencyDays = frequencyDays;
        this.emailEnabled = emailEnabled;
    }


    // =========================================================
    // REMINDER ID
    // =========================================================

    public int getReminderId() {
        return reminderId;
    }

    public void setReminderId(int reminderId) {
        this.reminderId = reminderId;
    }


    // =========================================================
    // ADMIN ID
    // =========================================================

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }


    // =========================================================
    // REMINDER NAME
    // =========================================================

    public String getReminderName() {
        return reminderName;
    }

    public void setReminderName(String reminderName) {
        this.reminderName = reminderName;
    }


    // =========================================================
    // REMINDER TYPE
    // =========================================================

    public String getReminderType() {
        return reminderType;
    }

    public void setReminderType(String reminderType) {
        this.reminderType = reminderType;
    }


    // =========================================================
    // ENABLED
    // =========================================================

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }


    // =========================================================
    // REMINDER TIME
    // =========================================================

    public Time getReminderTime() {
        return reminderTime;
    }

    public void setReminderTime(Time reminderTime) {
        this.reminderTime = reminderTime;
    }


    // =========================================================
    // FREQUENCY DAYS
    // =========================================================

    public int getFrequencyDays() {
        return frequencyDays;
    }

    public void setFrequencyDays(int frequencyDays) {
        this.frequencyDays = frequencyDays;
    }


    // =========================================================
    // EMAIL ENABLED
    // =========================================================

    public boolean isEmailEnabled() {
        return emailEnabled;
    }

    public void setEmailEnabled(boolean emailEnabled) {
        this.emailEnabled = emailEnabled;
    }


    // =========================================================
    // CREATED AT
    // =========================================================

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }


    // =========================================================
    // REMINDER INTERVAL
    // =========================================================

    public int getReminderInterval() {
        return reminderInterval;
    }

    public void setReminderInterval(int reminderInterval) {
        this.reminderInterval = reminderInterval;
    }


    // =========================================================
    // LAST TRIGGERED DATE
    // =========================================================

    public Date getLastTriggeredDate() {
        return lastTriggeredDate;
    }

    public void setLastTriggeredDate(Date lastTriggeredDate) {
        this.lastTriggeredDate = lastTriggeredDate;
    }


    // =========================================================
    // OCCURRENCE ID
    // =========================================================

    public int getOccurrenceId() {
        return occurrenceId;
    }

    public void setOccurrenceId(int occurrenceId) {
        this.occurrenceId = occurrenceId;
    }


    // =========================================================
    // REMINDER DATE
    // =========================================================

    public Date getReminderDate() {
        return reminderDate;
    }

    public void setReminderDate(Date reminderDate) {
        this.reminderDate = reminderDate;
    }


    // =========================================================
    // TRIGGERED
    // =========================================================

    public boolean isTriggered() {
        return triggered;
    }

    public void setTriggered(boolean triggered) {
        this.triggered = triggered;
    }


    // =========================================================
    // DISMISSED
    // =========================================================

    public boolean isDismissed() {
        return dismissed;
    }

    public void setDismissed(boolean dismissed) {
        this.dismissed = dismissed;
    }


    // =========================================================
    // DISMISSED AT
    // =========================================================

    public Timestamp getDismissedAt() {
        return dismissedAt;
    }

    public void setDismissedAt(Timestamp dismissedAt) {
        this.dismissedAt = dismissedAt;
    }
}