package com.digitalpurohit.dao;

import java.util.List;

import com.digitalpurohit.model.BulkEventCustomer;
import com.digitalpurohit.model.PendingPaymentSummary;

public interface BulkEventCustomerDAO {
	BulkEventCustomer getFamilyById(int id);
    boolean addCustomerToBulkEvent(
            BulkEventCustomer bulkEventCustomer);

    boolean updateBulkEventCustomer(
            BulkEventCustomer bulkEventCustomer);
    int getPendingPaymentCount(int adminId);
    boolean removeCustomerFromBulkEvent(
            int bulkEventId,
            int customerId);

    BulkEventCustomer getBulkEventCustomer(
            int bulkEventId,
            int customerId);
    boolean updateBulkFamily(
            BulkEventCustomer bulkEventCustomer);

    BulkEventCustomer getBulkFamilyForEdit(
            int bulkEventId,
            int customerId);
    List<PendingPaymentSummary> getPendingPaymentSummary();

    List<BulkEventCustomer> getCustomersByBulkEvent(
            int bulkEventId);

    List<BulkEventCustomer> getBulkEventsByCustomer(
            int customerId);
    boolean deleteBulkFamily(int id);
    List<BulkEventCustomer> getFamilyDetails(
            int bulkEventId,
            int adminId);

    List<BulkEventCustomer> searchFamilies(
            int bulkEventId,
            String keyword,
            int adminId);

    int getTotalFamilies(
            int bulkEventId,
            int adminId);

    int getPaidFamilies(
            int bulkEventId,
            int adminId);

    int getPendingFamilies(
            int bulkEventId,
            int adminId);

    double getTotalAmountCollected(
            int bulkEventId,
            int adminId);
    
    BulkEventCustomer getFamilyById(
            int id,
            int adminId);

    boolean updateBulkFamily(
            BulkEventCustomer family,
            int adminId);
    
    boolean deleteBulkFamily(
            int id,
            int adminId);
    
    boolean updatePaymentStatus(
            int bulkEventId,
            int customerId,
            double receiveAmount,
            String notes,
            int adminId);
    List<BulkEventCustomer> getPendingPayments(int adminId);
    
    // Updated
    boolean updatePaymentStatus(
            int bulkEventId,
            int customerId,
            double receiveAmount,
            String notes);

    boolean existsInBulkEvent(
            int bulkEventId,
            int customerId);

    List<BulkEventCustomer> getFamilyDetails(
            int bulkEventId);

    int getTotalFamilies(
            int bulkEventId);

    int getPaidFamilies(
            int bulkEventId);

    int getPendingFamilies(
            int bulkEventId);

    List<BulkEventCustomer> getPendingPayments();

    int getPendingPaymentCount();

    double getTotalAmountCollected(
            int bulkEventId);
    
    List<BulkEventCustomer> searchFamilies(
            int bulkEventId,
            String keyword);
}