package com.digitalpurohit.model;

public class DashboardSummary {

    private int totalCustomers;

    private int todayEvents;

    private int todayGroupEvents;

    private double todayIncome;

    private double monthlyEventIncome;

    private double monthlyGroupIncome;

    private double totalMonthlyIncome;

    private double pendingIncome;

    public DashboardSummary() {
    }

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public int getTodayEvents() {
        return todayEvents;
    }

    public void setTodayEvents(int todayEvents) {
        this.todayEvents = todayEvents;
    }

    public int getTodayGroupEvents() {
        return todayGroupEvents;
    }

    public void setTodayGroupEvents(int todayGroupEvents) {
        this.todayGroupEvents = todayGroupEvents;
    }

    public double getTodayIncome() {
        return todayIncome;
    }

    public void setTodayIncome(double todayIncome) {
        this.todayIncome = todayIncome;
    }

    public double getMonthlyEventIncome() {
        return monthlyEventIncome;
    }

    public void setMonthlyEventIncome(double monthlyEventIncome) {
        this.monthlyEventIncome = monthlyEventIncome;
    }

    public double getMonthlyGroupIncome() {
        return monthlyGroupIncome;
    }

    public void setMonthlyGroupIncome(double monthlyGroupIncome) {
        this.monthlyGroupIncome = monthlyGroupIncome;
    }

    public double getTotalMonthlyIncome() {
        return totalMonthlyIncome;
    }

    public void setTotalMonthlyIncome(double totalMonthlyIncome) {
        this.totalMonthlyIncome = totalMonthlyIncome;
    }

    public double getPendingIncome() {
        return pendingIncome;
    }

    public void setPendingIncome(double pendingIncome) {
        this.pendingIncome = pendingIncome;
    }
}