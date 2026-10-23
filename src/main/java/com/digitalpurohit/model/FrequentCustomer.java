package com.digitalpurohit.model;

public class FrequentCustomer {

    private int customerId;
    private String customerName;
    private String phone;
    private String gothram;
    private int totalEvents;

    public FrequentCustomer() {
    }

    public FrequentCustomer(int customerId,
                            String customerName,
                            String phone,
                            String gothram,
                            int totalEvents) {

        this.customerId = customerId;
        this.customerName = customerName;
        this.phone = phone;
        this.gothram = gothram;
        this.totalEvents = totalEvents;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
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

    public String getGothram() {
        return gothram;
    }

    public void setGothram(String gothram) {
        this.gothram = gothram;
    }

    public int getTotalEvents() {
        return totalEvents;
    }

    public void setTotalEvents(int totalEvents) {
        this.totalEvents = totalEvents;
    }

}