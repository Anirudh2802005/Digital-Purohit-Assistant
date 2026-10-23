package com.digitalpurohit.dao;

import java.sql.Date;
import java.util.List;
import com.digitalpurohit.model.BulkEvent;
import com.digitalpurohit.model.BulkEventIncomeReport;

public interface BulkEventDAO {

    boolean saveBulkEvent(BulkEvent bulkEvent);

    boolean updateBulkEvent(BulkEvent bulkEvent, int adminId);

    boolean deleteBulkEvent(int bulkEventId, int adminId);

    BulkEvent getBulkEventById(int bulkEventId, int adminId);

    List<BulkEvent> getAllBulkEvents(int adminId);

    int getBulkEventCount(int adminId);

    int getTodayBulkEventCount(int adminId);

    double getMonthlyBulkIncome(int adminId);

    double getTotalBulkIncome(int adminId);

    double getTotalPendingAmount(int adminId);

    int getUpcomingBulkEventCount(int adminId);

    String getMostPopularBulkEvent(int adminId);

    List<BulkEvent> getRecentBulkEvents(int adminId, int limit);

    List<BulkEvent> getUpcomingBulkEvents(int adminId, int limit);
    
    List<BulkEventIncomeReport> getBulkEventIncomeReport(
            int adminId,
            Date fromDate,
            Date toDate);
}