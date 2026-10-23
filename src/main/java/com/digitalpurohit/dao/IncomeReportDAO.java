package com.digitalpurohit.dao;

import java.sql.Date;
import java.util.List;

import com.digitalpurohit.model.IncomeReport;

public interface IncomeReportDAO {

    // ==========================================
    // MONTHLY CHART
    // ==========================================

    List<String> getMonthlyLabels(
            int year,
            int adminId);

    List<Double> getMonthlyIncomeValues(
            int year,
            int adminId);


    // ==========================================
    // TODAY
    // ==========================================

    List<IncomeReport> getTodayIncome(
            int adminId);


    // ==========================================
    // MONTHLY
    // ==========================================

    List<IncomeReport> getMonthlyIncome(
            int month,
            int year,
            int adminId);


    // ==========================================
    // YEARLY
    // ==========================================

    List<IncomeReport> getYearlyIncome(
            int year,
            int adminId);


    // ==========================================
    // CUSTOM DATE RANGE
    // ==========================================

    List<IncomeReport> getCustomIncome(
            Date fromDate,
            Date toDate,
            int adminId);
    
 // ==========================================
 // INCOME BY EVENT TYPE
 // ==========================================

 List<String> getEventTypeLabels(
         int year,
         int adminId);

 List<Double> getEventTypeIncomeValues(
         int year,
         int adminId);
}