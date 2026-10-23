package com.digitalpurohit.dao;

import java.util.List;
import java.util.Map;

public interface AnalyticsDAO {

    // ==========================================
    // MONTHLY ANALYTICS
    // ==========================================

    List<String> getMonthlyLabels(
            int year,
            int adminId);

    List<Double> getMonthlyIncome(
            int year,
            int adminId);


    // ==========================================
    // PAYMENT STATUS
    // ==========================================

    Map<String, Integer> getPaymentStatusCount(
            int adminId);


    // ==========================================
    // EVENT TYPES
    // ==========================================

    List<String> getEventTypeLabels(
            int adminId);

    List<Double> getEventTypeIncome(
            int adminId);
}