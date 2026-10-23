package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.CustomerReportDAO;
import com.digitalpurohit.model.BulkEventCustomer;
import com.digitalpurohit.model.CustomerReport;
import com.digitalpurohit.model.CustomerReportDetails;
import com.digitalpurohit.model.Event;
import com.digitalpurohit.util.DBConnection;

public class CustomerReportDAOImpl implements CustomerReportDAO {

    // =========================================================
    // ALL CUSTOMER REPORTS
    // =========================================================

    @Override
    public List<CustomerReport> getAllCustomerReports(int adminId) {

        List<CustomerReport> reports = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement("""
                SELECT

                    c.customer_id,
                    c.customer_name,
                    c.phone,

                    IFNULL(e.total_events, 0) AS totalEvents,

                    IFNULL(b.total_bulk_events, 0) AS totalBulkEvents,

                    IFNULL(e.total_amount, 0)
                    +
                    IFNULL(b.total_amount, 0)
                    AS totalAmount,

                    IFNULL(e.received_amount, 0)
                    +
                    IFNULL(b.received_amount, 0)
                    AS receivedAmount,

                    IFNULL(e.pending_amount, 0)
                    +
                    IFNULL(b.pending_amount, 0)
                    AS pendingAmount

                FROM customers c

                LEFT JOIN (

                    SELECT

                        e.customer_id,

                        COUNT(*) AS total_events,

                        SUM(e.total_amount) AS total_amount,

                        SUM(e.amount_paid) AS received_amount,

                        SUM(e.total_amount - e.amount_paid)
                        AS pending_amount

                    FROM events e

                    WHERE e.admin_id = ?

                    GROUP BY e.customer_id

                ) e

                ON c.customer_id = e.customer_id

                LEFT JOIN (

                    SELECT

                        bc.customer_id,

                        COUNT(*) AS total_bulk_events,

                        SUM(bc.total_amount) AS total_amount,

                        SUM(bc.amount_paid) AS received_amount,

                        SUM(bc.total_amount - bc.amount_paid)
                        AS pending_amount

                    FROM bulk_event_customers bc

                    INNER JOIN bulk_events b

                        ON bc.bulk_event_id = b.yatra_id

                    WHERE b.admin_id = ?

                    GROUP BY bc.customer_id

                ) b

                ON c.customer_id = b.customer_id

                WHERE c.admin_id = ?

                ORDER BY c.customer_name

                """);

            ps.setInt(1, adminId);
            ps.setInt(2, adminId);
            ps.setInt(3, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                CustomerReport report =
                        new CustomerReport();

                report.setCustomerId(
                        rs.getInt("customer_id"));

                report.setCustomerName(
                        rs.getString("customer_name"));

                report.setPhone(
                        rs.getString("phone"));

                report.setTotalEvents(
                        rs.getInt("totalEvents"));

                report.setTotalBulkEvents(
                        rs.getInt("totalBulkEvents"));

                report.setTotalAmount(
                        rs.getDouble("totalAmount"));

                report.setReceivedAmount(
                        rs.getDouble("receivedAmount"));

                report.setPendingAmount(
                        rs.getDouble("pendingAmount"));


                // ==============================
                // PAYMENT STATUS
                // ==============================

                if (report.getPendingAmount() == 0) {

                    report.setPaymentStatus("PAID");

                } else if (report.getReceivedAmount() > 0) {

                    report.setPaymentStatus("PARTIAL");

                } else {

                    report.setPaymentStatus("PENDING");
                }

                reports.add(report);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return reports;
    }


    // =========================================================
    // TOTAL CUSTOMERS
    // =========================================================

    @Override
    public int getTotalCustomers(int adminId) {

        int total = 0;

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT COUNT(*)
                        FROM customers
                        WHERE admin_id = ?
                    """);

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                total = rs.getInt(1);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return total;
    }


    // =========================================================
    // TOTAL EVENTS
    // =========================================================

    @Override
    public int getTotalEvents(int adminId) {

        int total = 0;

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT COUNT(*)
                        FROM events
                        WHERE admin_id = ?
                    """);

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                total = rs.getInt(1);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return total;
    }


    // =========================================================
    // TOTAL BULK EVENTS
    // =========================================================

    @Override
    public int getTotalBulkEvents(int adminId) {

        int total = 0;

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT COUNT(*)
                        FROM bulk_event_customers bc

                        INNER JOIN bulk_events b
                            ON bc.bulk_event_id = b.yatra_id

                        WHERE b.admin_id = ?
                    """);

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                total = rs.getInt(1);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return total;
    }


    // =========================================================
    // TOTAL RECEIVED AMOUNT
    // =========================================================

    @Override
    public double getTotalReceivedAmount(int adminId) {

        double total = 0;

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            IFNULL(
                                (
                                    SELECT SUM(amount_paid)
                                    FROM events
                                    WHERE admin_id = ?
                                ), 0
                            )

                            +

                            IFNULL(
                                (
                                    SELECT SUM(bc.amount_paid)

                                    FROM bulk_event_customers bc

                                    INNER JOIN bulk_events b
                                        ON bc.bulk_event_id = b.yatra_id

                                    WHERE b.admin_id = ?

                                ), 0
                            )
                    """);

            ps.setInt(1, adminId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                total = rs.getDouble(1);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return total;
    }


    // =========================================================
    // TOTAL PENDING AMOUNT
    // =========================================================

    @Override
    public double getTotalPendingAmount(int adminId) {

        double total = 0;

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            IFNULL(
                                (
                                    SELECT
                                        SUM(total_amount - amount_paid)

                                    FROM events

                                    WHERE admin_id = ?

                                ), 0
                            )

                            +

                            IFNULL(
                                (
                                    SELECT
                                        SUM(
                                            bc.total_amount
                                            -
                                            bc.amount_paid
                                        )

                                    FROM bulk_event_customers bc

                                    INNER JOIN bulk_events b
                                        ON bc.bulk_event_id = b.yatra_id

                                    WHERE b.admin_id = ?

                                ), 0
                            )
                    """);

            ps.setInt(1, adminId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                total = rs.getDouble(1);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return total;
    }


    // =========================================================
    // CUSTOMER DETAILS
    // =========================================================

    @Override
    public CustomerReportDetails getCustomerDetails(
            int customerId,
            int adminId) {

        CustomerReportDetails customer =
                new CustomerReportDetails();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            c.customer_id,
                            c.customer_name,
                            c.phone,
                            c.address,
                            c.gothram,

                            (
                                SELECT COUNT(*)
                                FROM events e
                                WHERE e.customer_id = c.customer_id
                                AND e.admin_id = ?
                            ) AS totalEvents,

                            (
                                SELECT COUNT(*)

                                FROM bulk_event_customers bc

                                INNER JOIN bulk_events b
                                    ON bc.bulk_event_id = b.yatra_id

                                WHERE bc.customer_id = c.customer_id
                                AND b.admin_id = ?

                            ) AS totalBulkEvents,

                            IFNULL(
                                (
                                    SELECT SUM(e.total_amount)

                                    FROM events e

                                    WHERE e.customer_id = c.customer_id
                                    AND e.admin_id = ?

                                ), 0
                            )

                            +

                            IFNULL(
                                (
                                    SELECT SUM(bc.total_amount)

                                    FROM bulk_event_customers bc

                                    INNER JOIN bulk_events b
                                        ON bc.bulk_event_id = b.yatra_id

                                    WHERE bc.customer_id = c.customer_id
                                    AND b.admin_id = ?

                                ), 0
                            ) AS totalAmount,

                            IFNULL(
                                (
                                    SELECT SUM(e.amount_paid)

                                    FROM events e

                                    WHERE e.customer_id = c.customer_id
                                    AND e.admin_id = ?

                                ), 0
                            )

                            +

                            IFNULL(
                                (
                                    SELECT SUM(bc.amount_paid)

                                    FROM bulk_event_customers bc

                                    INNER JOIN bulk_events b
                                        ON bc.bulk_event_id = b.yatra_id

                                    WHERE bc.customer_id = c.customer_id
                                    AND b.admin_id = ?

                                ), 0
                            ) AS receivedAmount,

                            IFNULL(
                                (
                                    SELECT
                                        SUM(
                                            e.total_amount
                                            -
                                            e.amount_paid
                                        )

                                    FROM events e

                                    WHERE e.customer_id = c.customer_id
                                    AND e.admin_id = ?

                                ), 0
                            )

                            +

                            IFNULL(
                                (
                                    SELECT
                                        SUM(
                                            bc.total_amount
                                            -
                                            bc.amount_paid
                                        )

                                    FROM bulk_event_customers bc

                                    INNER JOIN bulk_events b
                                        ON bc.bulk_event_id = b.yatra_id

                                    WHERE bc.customer_id = c.customer_id
                                    AND b.admin_id = ?

                                ), 0
                            ) AS pendingAmount

                        FROM customers c

                        WHERE c.customer_id = ?
                        AND c.admin_id = ?

                    """);

            // ==============================
            // SET PARAMETERS
            // ==============================

            ps.setInt(1, adminId);
            ps.setInt(2, adminId);
            ps.setInt(3, adminId);
            ps.setInt(4, adminId);
            ps.setInt(5, adminId);
            ps.setInt(6, adminId);
            ps.setInt(7, adminId);
            ps.setInt(8, adminId);

            ps.setInt(9, customerId);
            ps.setInt(10, adminId);


            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                customer.setCustomerId(
                        rs.getInt("customer_id"));

                customer.setCustomerName(
                        rs.getString("customer_name"));

                customer.setPhone(
                        rs.getString("phone"));

                customer.setAddress(
                        rs.getString("address"));

                customer.setGothram(
                        rs.getString("gothram"));

                customer.setTotalEvents(
                        rs.getInt("totalEvents"));

                customer.setTotalBulkEvents(
                        rs.getInt("totalBulkEvents"));

                customer.setTotalAmount(
                        rs.getDouble("totalAmount"));

                customer.setReceivedAmount(
                        rs.getDouble("receivedAmount"));

                customer.setPendingAmount(
                        rs.getDouble("pendingAmount"));
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return customer;
    }


    // =========================================================
    // CUSTOMER EVENTS
    // =========================================================

    @Override
    public List<Event> getCustomerEvents(
            int customerId,
            int adminId) {

        List<Event> events =
                new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            e.event_id,
                            e.event_title,
                            e.event_date,
                            e.event_time,
                            e.location,
                            e.total_amount,
                            e.amount_paid,
                            e.payment_status,
                            et.type_name

                        FROM events e

                        INNER JOIN event_types et
                            ON e.type_id = et.type_id

                        WHERE e.customer_id = ?
                        AND e.admin_id = ?

                        ORDER BY e.event_date DESC
                    """);

            ps.setInt(1, customerId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Event event =
                        new Event();

                event.setEventId(
                        rs.getInt("event_id"));

                event.setEventTitle(
                        rs.getString("event_title"));

                event.setEventDate(
                        rs.getDate("event_date"));

                event.setEventTime(
                        rs.getTime("event_time"));

                event.setLocation(
                        rs.getString("location"));

                event.setTotalAmount(
                        rs.getDouble("total_amount"));

                event.setAmountPaid(
                        rs.getDouble("amount_paid"));

                event.setPaymentStatus(
                        rs.getString("payment_status"));

                /*
                 * Your old code was setting eventTitle
                 * again with type_name.
                 *
                 * Leaving eventTitle as the actual
                 * event title is safer.
                 */

                events.add(event);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return events;
    }


    // =========================================================
    // CUSTOMER BULK EVENTS
    // =========================================================

    @Override
    public List<BulkEventCustomer> getCustomerBulkEvents(
            int customerId,
            int adminId) {

        List<BulkEventCustomer> bulkEvents =
                new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            bc.bulk_event_id,
                            b.bulk_event_name,
                            b.start_date,
                            b.end_date,
                            b.location,

                            bc.customer_id,
                            bc.total_amount,
                            bc.amount_paid,
                            bc.payment_status,
                            bc.notes

                        FROM bulk_event_customers bc

                        INNER JOIN bulk_events b
                            ON bc.bulk_event_id = b.yatra_id

                        WHERE bc.customer_id = ?
                        AND b.admin_id = ?

                        ORDER BY b.start_date DESC
                    """);

            ps.setInt(1, customerId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BulkEventCustomer bulkEvent =
                        new BulkEventCustomer();

                bulkEvent.setBulkEventId(
                        rs.getInt("bulk_event_id"));

                bulkEvent.setCustomerId(
                        rs.getInt("customer_id"));

                bulkEvent.setTotalAmount(
                        rs.getDouble("total_amount"));

                bulkEvent.setAmountPaid(
                        rs.getDouble("amount_paid"));

                bulkEvent.setPaymentStatus(
                        rs.getString("payment_status"));

                bulkEvent.setNotes(
                        rs.getString("notes"));

                bulkEvent.setBulkEventName(
                        rs.getString("bulk_event_name"));

                bulkEvent.setStartDate(
                        rs.getDate("start_date"));

                bulkEvent.setEndDate(
                        rs.getDate("end_date"));

                bulkEvent.setLocation(
                        rs.getString("location"));

                bulkEvents.add(bulkEvent);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return bulkEvents;
    }
}