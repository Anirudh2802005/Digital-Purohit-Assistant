package com.digitalpurohit.dao;

import java.util.List;

import com.digitalpurohit.model.BulkEventReport;

public interface BulkEventReportDAO {

	List<BulkEventReport> getAllBulkEventReports(int adminId);

}