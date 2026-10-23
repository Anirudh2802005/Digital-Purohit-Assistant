package com.digitalpurohit.dao;

import java.sql.Date;
import java.util.List;

import com.digitalpurohit.model.EventReport;

public interface EventReportDAO {

    // All reports
	List<EventReport> getAllReports(int adminId);

    // Today's report
   

    // Monthly report


    // Annual report
    

   
    

    List<EventReport> getTodayReport(int adminId);

    List<EventReport> getMonthlyReport(
            int month,
            int year,
            int adminId);

    List<EventReport> getYearlyReport(
            int year,
            int adminId);

    List<EventReport> getDateRangeReport(
            Date fromDate,
            Date toDate,
            int adminId);

    List<EventReport> getEventTypeReport(
            int typeId,
            int adminId);
    // Event type report
    

}