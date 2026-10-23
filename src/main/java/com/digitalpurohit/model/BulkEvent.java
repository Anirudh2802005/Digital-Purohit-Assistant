package com.digitalpurohit.model;

import java.sql.Date;
import java.sql.Timestamp;

public class BulkEvent {

    private int yatraId;
    private String bulkEventName;

    private Date startDate;
    private Date endDate;

    private String location;
    private String notes;
    private int totalFamilies;

    private int pendingFamilies;

    private int paidFamilies;

    private double totalAmountCollected;
    private Timestamp createdAt;

    public BulkEvent() {
    }

    public int getTotalFamilies() {
        return totalFamilies;
    }

    public void setTotalFamilies(int totalFamilies) {
        this.totalFamilies = totalFamilies;
    }

    public int getPendingFamilies() {
        return pendingFamilies;
    }

    public void setPendingFamilies(int pendingFamilies) {
        this.pendingFamilies = pendingFamilies;
    }

    public int getPaidFamilies() {
        return paidFamilies;
    }

    public void setPaidFamilies(int paidFamilies) {
        this.paidFamilies = paidFamilies;
    }

    public double getTotalAmountCollected() {
        return totalAmountCollected;
    }

    public void setTotalAmountCollected(double totalAmountCollected) {
        this.totalAmountCollected = totalAmountCollected;
    }
    public int getYatraId() {
        return yatraId;
    }

    public void setYatraId(int yatraId) {
        this.yatraId = yatraId;
    }

    public String getBulkEventName() {
        return bulkEventName;
    }

    public void setBulkEventName(String bulkEventName) {
        this.bulkEventName = bulkEventName;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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