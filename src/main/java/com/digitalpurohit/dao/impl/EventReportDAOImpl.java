package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.EventReportDAO;
import com.digitalpurohit.model.EventReport;
import com.digitalpurohit.util.DBConnection;

public class EventReportDAOImpl implements EventReportDAO {

    private EventReport extractReport(ResultSet rs) throws Exception {

        EventReport report = new EventReport();

        report.setEventId(rs.getInt("event_id"));

        report.setEventDate(rs.getDate("event_date"));

        report.setCustomerName(
                rs.getString("customer_name"));

        report.setEventTitle(
                rs.getString("event_title"));

        report.setTotalAmount(
                rs.getDouble("total_amount"));

        report.setAmountPaid(
                rs.getDouble("amount_paid"));

        report.setPendingAmount(
                rs.getDouble("total_amount")
                - rs.getDouble("amount_paid"));

        report.setPaymentStatus(
                rs.getString("payment_status"));

        return report;

    }
    
    @Override
    public List<EventReport> getEventTypeReport(int typeId,
                                                int adminId) {

        List<EventReport> reports = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement("""

                    SELECT

                    e.event_id,

                    e.event_date,

                    e.event_title,

                    c.customer_name,

                    e.total_amount,

                    e.amount_paid,

                    e.payment_status

                    FROM events e

                    JOIN customers c

                    ON e.customer_id = c.customer_id

                    WHERE e.type_id = ?

                    AND e.admin_id = ?

                    ORDER BY e.event_date,
                             e.event_time

                    """);

            ps.setInt(1, typeId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                reports.add(extractReport(rs));

            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();

        }

        return reports;

    }
   
    @Override
    public List<EventReport> getTodayReport(int adminId) {

        List<EventReport> reports = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement("""

                    SELECT

                    e.event_id,

                    e.event_date,

                    e.event_title,

                    c.customer_name,

                    e.total_amount,

                    e.amount_paid,

                    e.payment_status

                    FROM events e

                    JOIN customers c

                    ON e.customer_id = c.customer_id

                    WHERE e.event_date = CURDATE()

                    AND e.admin_id = ?

                    ORDER BY e.event_time

                    """);

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                reports.add(extractReport(rs));

            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();

        }

        return reports;

    }
    @Override
    public List<EventReport> getMonthlyReport(int month,
                                              int year,
                                              int adminId) {

        List<EventReport> reports = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement("""

                    SELECT

                    e.event_id,

                    e.event_date,

                    e.event_title,

                    c.customer_name,

                    e.total_amount,

                    e.amount_paid,

                    e.payment_status

                    FROM events e

                    JOIN customers c

                    ON e.customer_id = c.customer_id

                    WHERE MONTH(e.event_date)=?

                    AND YEAR(e.event_date)=?

                    AND e.admin_id=?

                    ORDER BY e.event_date,
                             e.event_time

                    """);

            ps.setInt(1, month);
            ps.setInt(2, year);
            ps.setInt(3, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                reports.add(extractReport(rs));

            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();

        }

        return reports;

    }
    @Override
    public List<EventReport> getYearlyReport(int year,
                                             int adminId) {

        List<EventReport> reports = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement("""

                    SELECT

                    e.event_id,

                    e.event_date,

                    e.event_title,

                    c.customer_name,

                    e.total_amount,

                    e.amount_paid,

                    e.payment_status

                    FROM events e

                    JOIN customers c

                    ON e.customer_id = c.customer_id

                    WHERE YEAR(e.event_date)=?

                    AND e.admin_id=?

                    ORDER BY e.event_date,
                             e.event_time

                    """);

            ps.setInt(1, year);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                reports.add(extractReport(rs));

            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();

        }

        return reports;

    }
    @Override
    public List<EventReport> getDateRangeReport(Date fromDate,
                                                Date toDate,
                                                int adminId) {

        List<EventReport> reports = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement("""

                    SELECT

                    e.event_id,

                    e.event_date,

                    e.event_title,

                    c.customer_name,

                    e.total_amount,

                    e.amount_paid,

                    e.payment_status

                    FROM events e

                    JOIN customers c

                    ON e.customer_id = c.customer_id

                    WHERE e.event_date BETWEEN ? AND ?

                    AND e.admin_id = ?

                    ORDER BY e.event_date,
                             e.event_time

                    """);

            ps.setDate(1, fromDate);
            ps.setDate(2, toDate);
            ps.setInt(3, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                reports.add(extractReport(rs));

            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();

        }

        return reports;

    }

    @Override
    public List<EventReport> getAllReports(int adminId) {

        List<EventReport> reports =
                new ArrayList<>();

        try (Connection con =
                DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""

                    SELECT

                    e.event_id,

                    e.event_date,

                    e.event_title,

                    c.customer_name,

                    e.total_amount,

                    e.amount_paid,

                    e.payment_status

                    FROM events e

                    JOIN customers c

                    ON e.customer_id = c.customer_id

                    WHERE e.admin_id = ?

                    ORDER BY e.event_date DESC

                    """);

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                reports.add(extractReport(rs));

            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();

        }

        return reports;
    }
 }