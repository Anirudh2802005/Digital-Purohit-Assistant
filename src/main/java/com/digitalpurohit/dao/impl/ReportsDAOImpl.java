package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.digitalpurohit.dao.ReportsDAO;
import com.digitalpurohit.model.DashboardReport;
import com.digitalpurohit.util.DBConnection;

public class ReportsDAOImpl implements ReportsDAO {

	@Override
	public DashboardReport getDashboardReport(int adminId) {

	    DashboardReport report = new DashboardReport();

	    try (Connection con = DBConnection.getConnection()) {

	        PreparedStatement ps;
	        ResultSet rs;

	        // ==========================================
	        // TOTAL EVENTS
	        // ==========================================

	        ps = con.prepareStatement(
	                "SELECT COUNT(*) FROM events WHERE admin_id = ?");

	        ps.setInt(1, adminId);

	        rs = ps.executeQuery();

	        if (rs.next()) {
	            report.setTotalEvents(rs.getInt(1));
	        }

	        rs.close();
	        ps.close();


	        // ==========================================
	        // TOTAL BULK EVENTS
	        // ==========================================

	        ps = con.prepareStatement(
	                "SELECT COUNT(*) FROM bulk_events WHERE admin_id = ?");

	        ps.setInt(1, adminId);

	        rs = ps.executeQuery();

	        if (rs.next()) {
	            report.setTotalBulkEvents(rs.getInt(1));
	        }

	        rs.close();
	        ps.close();


	        // ==========================================
	        // TOTAL CUSTOMERS
	        // ==========================================

	        ps = con.prepareStatement(
	                "SELECT COUNT(*) FROM customers WHERE admin_id = ?");

	        ps.setInt(1, adminId);

	        rs = ps.executeQuery();

	        if (rs.next()) {
	            report.setTotalCustomers(rs.getInt(1));
	        }

	        rs.close();
	        ps.close();


	        // ==========================================
	        // EVENT COLLECTION
	        // ==========================================

	        double eventPaid = 0;
	        double eventPending = 0;

	        ps = con.prepareStatement("""
	                SELECT
	                IFNULL(SUM(amount_paid),0),
	                IFNULL(SUM(total_amount - amount_paid),0)
	                FROM events
	                WHERE admin_id = ?
	                """);

	        ps.setInt(1, adminId);

	        rs = ps.executeQuery();

	        if (rs.next()) {
	            eventPaid = rs.getDouble(1);
	            eventPending = rs.getDouble(2);
	        }

	        rs.close();
	        ps.close();


	        // ==========================================
	        // BULK EVENT COLLECTION
	        // ==========================================

	        double bulkPaid = 0;
	        double bulkPending = 0;

	        ps = con.prepareStatement("""
	                SELECT
	                IFNULL(SUM(bec.amount_paid),0),
	                IFNULL(SUM(bec.total_amount - bec.amount_paid),0)
	                FROM bulk_event_customers bec
	                JOIN bulk_events be
	                ON bec.bulk_event_id = be.yatra_id
	                WHERE be.admin_id = ?
	                """);

	        ps.setInt(1, adminId);

	        rs = ps.executeQuery();

	        if (rs.next()) {
	            bulkPaid = rs.getDouble(1);
	            bulkPending = rs.getDouble(2);
	        }

	        rs.close();
	        ps.close();


	        // ==========================================
	        // DASHBOARD TOTALS
	        // ==========================================

	        report.setTotalPaid(
	                eventPaid + bulkPaid);

	        report.setTotalPending(
	                eventPending + bulkPending);

	        report.setTotalIncome(
	                eventPaid + bulkPaid);


	        // ==========================================
	        // PAYMENT STATUS
	        // EVENTS + BULK EVENTS
	        // ==========================================

	        int paid = 0;
	        int pending = 0;
	        int partial = 0;


	        // ==========================================
	        // EVENT PAYMENT STATUS
	        // ==========================================

	        ps = con.prepareStatement("""
	                SELECT
	                payment_status,
	                COUNT(*)
	                FROM events
	                WHERE admin_id = ?
	                GROUP BY payment_status
	                """);

	        ps.setInt(1, adminId);

	        rs = ps.executeQuery();

	        while (rs.next()) {

	            String status = rs.getString(1);

	            switch (status) {

	                case "PAID":
	                    paid += rs.getInt(2);
	                    break;

	                case "PENDING":
	                    pending += rs.getInt(2);
	                    break;

	                case "PARTIAL":
	                    partial += rs.getInt(2);
	                    break;
	            }
	        }

	        rs.close();
	        ps.close();


	        // ==========================================
	        // BULK EVENT CUSTOMER PAYMENT STATUS
	        // ==========================================

	        ps = con.prepareStatement("""
	                SELECT
	                bec.payment_status,
	                COUNT(*)
	                FROM bulk_event_customers bec
	                JOIN bulk_events be
	                ON bec.bulk_event_id = be.yatra_id
	                WHERE be.admin_id = ?
	                GROUP BY bec.payment_status
	                """);

	        ps.setInt(1, adminId);

	        rs = ps.executeQuery();

	        while (rs.next()) {

	            String status = rs.getString(1);

	            switch (status) {

	                case "PAID":
	                    paid += rs.getInt(2);
	                    break;

	                case "PENDING":
	                    pending += rs.getInt(2);
	                    break;

	                case "PARTIAL":
	                    partial += rs.getInt(2);
	                    break;
	            }
	        }

	        report.setPaidCount(paid);
	        report.setPendingCount(pending);
	        report.setPartialCount(partial);

	        rs.close();
	        ps.close();



	     // ==========================================
	     // MONTHLY EVENTS - CURRENT YEAR
	     // ==========================================

	     int[] monthlyEvents = new int[12];

	     ps = con.prepareStatement("""
	             SELECT
	                 MONTH(event_date),
	                 COUNT(*)
	             FROM events
	             WHERE admin_id = ?
	             AND YEAR(event_date) = YEAR(CURDATE())
	             GROUP BY MONTH(event_date)
	             ORDER BY MONTH(event_date)
	             """);

	     ps.setInt(1, adminId);

	     rs = ps.executeQuery();

	     while (rs.next()) {

	         int month = rs.getInt(1);

	         monthlyEvents[month - 1] =
	                 rs.getInt(2);
	     }

	     report.setMonthlyEvents(monthlyEvents);

	     rs.close();
	     ps.close();


	     // ==========================================
	     // MONTHLY INCOME - EVENTS
	     // CURRENT YEAR
	     // ==========================================

	     double[] monthlyIncome = new double[12];

	     ps = con.prepareStatement("""
	             SELECT
	                 MONTH(event_date),
	                 IFNULL(SUM(amount_paid), 0)
	             FROM events
	             WHERE admin_id = ?
	             AND YEAR(event_date) = YEAR(CURDATE())
	             GROUP BY MONTH(event_date)
	             ORDER BY MONTH(event_date)
	             """);

	     ps.setInt(1, adminId);

	     rs = ps.executeQuery();

	     while (rs.next()) {

	         int month = rs.getInt(1);

	         monthlyIncome[month - 1] +=
	                 rs.getDouble(2);
	     }

	     rs.close();
	     ps.close();


	     // ==========================================
	     // MONTHLY INCOME - BULK EVENTS
	     // CURRENT YEAR
	     // ==========================================

	     ps = con.prepareStatement("""
	             SELECT
	                 MONTH(bec.created_at),
	                 IFNULL(SUM(bec.amount_paid), 0)
	             FROM bulk_event_customers bec
	             JOIN bulk_events be
	                 ON bec.bulk_event_id = be.yatra_id
	             WHERE be.admin_id = ?
	             AND YEAR(bec.created_at) = YEAR(CURDATE())
	             GROUP BY MONTH(bec.created_at)
	             ORDER BY MONTH(bec.created_at)
	             """);

	     ps.setInt(1, adminId);

	     rs = ps.executeQuery();

	     while (rs.next()) {

	         int month = rs.getInt(1);

	         monthlyIncome[month - 1] +=
	                 rs.getDouble(2);
	     }

	     report.setMonthlyIncome(monthlyIncome);

	     rs.close();
	     ps.close();


	     // ==========================================
	     // YEARLY INCOME
	     // EVENTS + BULK EVENTS
	     // ==========================================

	     // Store up to 10 years
	     String[] years = new String[10];

	     double[] yearlyIncome = new double[10];


	     // ==========================================
	     // YEARLY INCOME - EVENTS
	     // ==========================================

	     ps = con.prepareStatement("""
	             SELECT
	                 YEAR(event_date),
	                 IFNULL(SUM(amount_paid), 0)
	             FROM events
	             WHERE admin_id = ?
	             GROUP BY YEAR(event_date)
	             ORDER BY YEAR(event_date)
	             """);

	     ps.setInt(1, adminId);

	     rs = ps.executeQuery();

	     int index = 0;

	     while (rs.next() && index < years.length) {

	         years[index] =
	                 String.valueOf(rs.getInt(1));

	         yearlyIncome[index] =
	                 rs.getDouble(2);

	         index++;
	     }

	     rs.close();
	     ps.close();


	     // ==========================================
	     // YEARLY INCOME - BULK EVENTS
	     // ==========================================

	     ps = con.prepareStatement("""
	             SELECT
	                 YEAR(bec.created_at),
	                 IFNULL(SUM(bec.amount_paid), 0)
	             FROM bulk_event_customers bec
	             JOIN bulk_events be
	                 ON bec.bulk_event_id = be.yatra_id
	             WHERE be.admin_id = ?
	             GROUP BY YEAR(bec.created_at)
	             ORDER BY YEAR(bec.created_at)
	             """);

	     ps.setInt(1, adminId);

	     rs = ps.executeQuery();

	     while (rs.next()) {

	         int year =
	                 rs.getInt(1);

	         double amount =
	                 rs.getDouble(2);

	         boolean yearFound = false;


	         // ======================================
	         // CHECK IF YEAR ALREADY EXISTS
	         // ======================================

	         for (int i = 0; i < years.length; i++) {

	             if (years[i] == null) {
	                 continue;
	             }

	             if (Integer.parseInt(years[i]) == year) {

	                 yearlyIncome[i] += amount;

	                 yearFound = true;

	                 break;
	             }
	         }


	         // ======================================
	         // IF YEAR EXISTS ONLY IN BULK EVENTS
	         // ADD IT
	         // ======================================

	         if (!yearFound) {

	             for (int i = 0; i < years.length; i++) {

	                 if (years[i] == null) {

	                     years[i] =
	                             String.valueOf(year);

	                     yearlyIncome[i] =
	                             amount;

	                     break;
	                 }
	             }
	         }
	     }

	     rs.close();
	     ps.close();


	     // ==========================================
	     // SAVE YEARLY DATA TO REPORT
	     // ==========================================

	     report.setYears(years);

	     report.setYearlyIncome(yearlyIncome);
	        rs.close();
	        ps.close();


	    } catch (Exception e) {

	        e.printStackTrace();
	    }

	    return report;
	}
}