package com.digitalpurohit.model;

import java.sql.Timestamp;

public class Samagri {

    private int samagriId;

    private String samagriName;

    private String description;

    private Timestamp createdAt;
    private boolean completed;
    public Samagri() {

    }

    public int getSamagriId() {
        return samagriId;
    }

    public void setSamagriId(int samagriId) {
        this.samagriId = samagriId;
    }
    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public String getSamagriName() {
        return samagriName;
    }

    public void setSamagriName(String samagriName) {
        this.samagriName = samagriName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    private int adminId;

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

}