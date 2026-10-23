package com.digitalpurohit.model;

import java.sql.Timestamp;

public class Notification {

    private int notificationId;
    private String title;
    private String message;
    private String module;
    private String action;
    private Integer referenceId;
    private String redirectUrl;
    private boolean isRead;
    private Timestamp createdAt;
    private int adminId;

    // =========================================================
    // DEFAULT CONSTRUCTOR
    // =========================================================

    public Notification() {
    }

    // =========================================================
    // CONSTRUCTOR WITHOUT ID
    // =========================================================

    public Notification(
            String title,
            String message,
            String module,
            String action,
            Integer referenceId,
            String redirectUrl,
            boolean isRead,
            int adminId) {

        this.title = title;
        this.message = message;
        this.module = module;
        this.action = action;
        this.referenceId = referenceId;
        this.redirectUrl = redirectUrl;
        this.isRead = isRead;
        this.adminId = adminId;
    }

    // =========================================================
    // GETTERS AND SETTERS
    // =========================================================

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Integer getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(Integer referenceId) {
        this.referenceId = referenceId;
    }

    public String getRedirectUrl() {
        return redirectUrl;
    }

    public void setRedirectUrl(String redirectUrl) {
        this.redirectUrl = redirectUrl;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        this.isRead = read;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }
}