package com.digitalpurohit.model;

import java.sql.Date;

public class BulkEventReport {

    private int bulkEventId;
    private String bulkEventName;

    private Date startDate;
    private Date endDate;

    private int totalFamilies;

    private double totalAmount;

    public BulkEventReport() {
    }

    public int getBulkEventId() {
        return bulkEventId;
    }

    public void setBulkEventId(int bulkEventId) {
        this.bulkEventId = bulkEventId;
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

    public int getTotalFamilies() {
        return totalFamilies;
    }

    public void setTotalFamilies(int totalFamilies) {
        this.totalFamilies = totalFamilies;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

}