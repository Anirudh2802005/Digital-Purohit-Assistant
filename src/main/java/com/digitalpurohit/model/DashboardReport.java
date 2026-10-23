package com.digitalpurohit.model;

public class DashboardReport {

    private int totalEvents;
    private int totalBulkEvents;
    private int totalCustomers;

    private double totalIncome;
    private double totalPaid;
    private double totalPending;

    
    private String monthlyIncomeJson;
    private String monthlyEventsJson;
    private String annualIncomeJson;

    public String getMonthlyIncomeJson() {
        return monthlyIncomeJson;
    }

    public void setMonthlyIncomeJson(String monthlyIncomeJson) {
        this.monthlyIncomeJson = monthlyIncomeJson;
    }

    public String getMonthlyEventsJson() {
        return monthlyEventsJson;
    }

    public void setMonthlyEventsJson(String monthlyEventsJson) {
        this.monthlyEventsJson = monthlyEventsJson;
    }

    public String getAnnualIncomeJson() {
        return annualIncomeJson;
    }

    public void setAnnualIncomeJson(String annualIncomeJson) {
        this.annualIncomeJson = annualIncomeJson;
    }
    public DashboardReport() {
    }

    public int getTotalEvents() {
        return totalEvents;
    }

    public void setTotalEvents(int totalEvents) {
        this.totalEvents = totalEvents;
    }

    public int getTotalBulkEvents() {
        return totalBulkEvents;
    }

    public void setTotalBulkEvents(int totalBulkEvents) {
        this.totalBulkEvents = totalBulkEvents;
    }

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public double getTotalIncome() {
        return totalIncome;
    }

    public void setTotalIncome(double totalIncome) {
        this.totalIncome = totalIncome;
    }

    public double getTotalPaid() {
        return totalPaid;
    }

    public void setTotalPaid(double totalPaid) {
        this.totalPaid = totalPaid;
    }

    public double getTotalPending() {
        return totalPending;
    }

    public void setTotalPending(double totalPending) {
        this.totalPending = totalPending;
    }

   
    private double[] monthlyIncome = new double[12];
    private int[] monthlyEvents = new int[12];

    private String[] years = new String[10];
    private double[] yearlyIncome = new double[10];

    private int paidCount;
    private int pendingCount;
    private int partialCount;

    public double[] getMonthlyIncome() {
        return monthlyIncome;
    }

    public void setMonthlyIncome(double[] monthlyIncome) {
        this.monthlyIncome = monthlyIncome;
    }

    public int[] getMonthlyEvents() {
        return monthlyEvents;
    }

    public void setMonthlyEvents(int[] monthlyEvents) {
        this.monthlyEvents = monthlyEvents;
    }

    public String[] getYears() {
        return years;
    }

    public void setYears(String[] years) {
        this.years = years;
    }

    public double[] getYearlyIncome() {
        return yearlyIncome;
    }

    public void setYearlyIncome(double[] yearlyIncome) {
        this.yearlyIncome = yearlyIncome;
    }

    public int getPaidCount() {
        return paidCount;
    }

    public void setPaidCount(int paidCount) {
        this.paidCount = paidCount;
    }

    public int getPendingCount() {
        return pendingCount;
    }

    public void setPendingCount(int pendingCount) {
        this.pendingCount = pendingCount;
    }

    public int getPartialCount() {
        return partialCount;
    }

    public void setPartialCount(int partialCount) {
        this.partialCount = partialCount;
    }

}