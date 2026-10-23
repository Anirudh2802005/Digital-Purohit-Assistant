package com.digitalpurohit.model;

import java.sql.Date;

public class BulkEventCustomer {

    private int id;
    private int bulkEventId;
    private int customerId;

    private String paymentStatus;

    private double amountPaid;
    private double totalAmount;
    private String notes;
    private String bulkEventName;
    private String customerName;
    private String phone;
    private String address;
    
    private Date startDate;
    private Date endDate;
    private String location;
    private String gothram;
    
    
    public BulkEventCustomer() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    public String getBulkEventName() {
        return bulkEventName;
    }
    public void setBulkEventName(String bulkEventName) {
        this.bulkEventName = bulkEventName;
    }
    public int getBulkEventId() {
        return bulkEventId;
    }

    public void setBulkEventId(int bulkEventId) {
        this.bulkEventId = bulkEventId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public double getAmountPaid() {
        return amountPaid;
    }

    public void setAmountPaid(double amountPaid) {
        this.amountPaid = amountPaid;
    }
    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getGothram() {
        return gothram;
    }

    public void setGothram(String gothram) {
        this.gothram = gothram;
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
}