package com.digitalpurohit.model;

public class BulkEventIncomeReport {

    private int bulkEventId;

    private String bulkEventName;

    private int totalFamilies;

    private double totalAmount;

    private double receivedAmount;

    private double pendingAmount;

    private String paymentStatus;

    public BulkEventIncomeReport() {
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

    public double getReceivedAmount() {
        return receivedAmount;
    }

    public void setReceivedAmount(double receivedAmount) {
        this.receivedAmount = receivedAmount;
    }

    public double getPendingAmount() {
        return pendingAmount;
    }

    public void setPendingAmount(double pendingAmount) {
        this.pendingAmount = pendingAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
}