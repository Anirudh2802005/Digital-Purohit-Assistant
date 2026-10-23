package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.BulkEventReportDAO;
import com.digitalpurohit.model.BulkEventReport;
import com.digitalpurohit.util.DBConnection;

public class BulkEventReportDAOImpl
        implements BulkEventReportDAO {

	@Override
	public List<BulkEventReport> getAllBulkEventReports(
	        int adminId) {

	    List<BulkEventReport> reports =
	            new ArrayList<>();

	    try (Connection con =
	            DBConnection.getConnection()) {

	        PreparedStatement ps =
	                con.prepareStatement("""

	SELECT

	b.yatra_id,

	b.bulk_event_name,

	b.start_date,

	b.end_date,

	COUNT(bc.customer_id) AS total_families,

	IFNULL(SUM(bc.total_amount),0) AS total_amount

	FROM bulk_events b

	LEFT JOIN bulk_event_customers bc

	ON b.yatra_id = bc.bulk_event_id

	WHERE b.admin_id = ?

	GROUP BY

	b.yatra_id,

	b.bulk_event_name,

	b.start_date,

	b.end_date

	ORDER BY b.start_date DESC

	""");

	        ps.setInt(1, adminId);

	        ResultSet rs =
	                ps.executeQuery();

	        while (rs.next()) {

	            BulkEventReport report =
	                    new BulkEventReport();

	            report.setBulkEventId(
	                    rs.getInt("yatra_id"));

	            report.setBulkEventName(
	                    rs.getString("bulk_event_name"));

	            report.setStartDate(
	                    rs.getDate("start_date"));

	            report.setEndDate(
	                    rs.getDate("end_date"));

	            report.setTotalFamilies(
	                    rs.getInt("total_families"));

	            report.setTotalAmount(
	                    rs.getDouble("total_amount"));

	            reports.add(report);

	        }

	        rs.close();
	        ps.close();

	    } catch (Exception e) {

	        e.printStackTrace();

	    }

	    return reports;
	}

}