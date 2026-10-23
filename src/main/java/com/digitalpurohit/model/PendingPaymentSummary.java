package com.digitalpurohit.model;

public class PendingPaymentSummary {

    private int bulkEventId;
    private String bulkEventName;

    private int totalFamilies;
    private int pendingFamilies;

    private double outstandingAmount;

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

    public double getOutstandingAmount() {
        return outstandingAmount;
    }

    public void setOutstandingAmount(double outstandingAmount) {
        this.outstandingAmount = outstandingAmount;
    }
}