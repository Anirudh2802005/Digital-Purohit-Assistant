package com.digitalpurohit.dao;

import java.util.List;

import com.digitalpurohit.model.BulkEventCustomer;
import com.digitalpurohit.model.CustomerReport;
import com.digitalpurohit.model.CustomerReportDetails;
import com.digitalpurohit.model.Event;

public interface CustomerReportDAO {

    // ==========================================
    // CUSTOMER REPORTS - MULTI USER
    // ==========================================

    List<CustomerReport> getAllCustomerReports(int adminId);

    // ==========================================
    // SUMMARY - MULTI USER
    // ==========================================

    int getTotalCustomers(int adminId);

    int getTotalEvents(int adminId);

    int getTotalBulkEvents(int adminId);

    double getTotalReceivedAmount(int adminId);

    double getTotalPendingAmount(int adminId);

    // ==========================================
    // CUSTOMER DETAILS - MULTI USER
    // ==========================================

    CustomerReportDetails getCustomerDetails(
            int customerId,
            int adminId);

    // ==========================================
    // CUSTOMER EVENT HISTORY - MULTI USER
    // ==========================================

    List<Event> getCustomerEvents(
            int customerId,
            int adminId);

    // ==========================================
    // CUSTOMER BULK EVENT HISTORY - MULTI USER
    // ==========================================

    List<BulkEventCustomer> getCustomerBulkEvents(
            int customerId,
            int adminId);
}