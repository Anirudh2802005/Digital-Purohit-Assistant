package com.digitalpurohit.dao;

import java.util.List;

import com.digitalpurohit.model.BulkEventIncomeReport;

public interface BulkEventIncomeDAO {

    // ==========================================
    // ALL BULK EVENT INCOME
    // ==========================================

    List<BulkEventIncomeReport> getAllBulkEventIncome(
            int adminId);


    // ==========================================
    // SUMMARY
    // ==========================================

    int getTotalBulkEvents(
            int adminId);

    int getTotalFamilies(
            int adminId);

    double getTotalAmount(
            int adminId);

    double getReceivedAmount(
            int adminId);

    double getPendingAmount(
            int adminId);


    // ==========================================
    // SINGLE BULK EVENT
    // ==========================================

    BulkEventIncomeReport getBulkEventSummary(
            int bulkEventId,
            int adminId);
}