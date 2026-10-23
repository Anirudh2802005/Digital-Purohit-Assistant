package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.BulkEventIncomeDAO;
import com.digitalpurohit.model.BulkEventIncomeReport;
import com.digitalpurohit.util.DBConnection;

public class BulkEventIncomeDAOImpl
        implements BulkEventIncomeDAO {


    // =========================================================
    // ALL BULK EVENT INCOME
    // =========================================================

    @Override
    public List<BulkEventIncomeReport>
    getAllBulkEventIncome(int adminId) {

        List<BulkEventIncomeReport> list =
                new ArrayList<>();

        String sql = """
            SELECT

                b.yatra_id,

                b.bulk_event_name,

                COUNT(bc.customer_id)
                    AS totalFamilies,

                IFNULL(
                    SUM(bc.total_amount),
                    0
                ) AS totalAmount,

                IFNULL(
                    SUM(bc.amount_paid),
                    0
                ) AS receivedAmount,

                IFNULL(
                    SUM(
                        bc.total_amount
                        - bc.amount_paid
                    ),
                    0
                ) AS pendingAmount

            FROM bulk_events b

            LEFT JOIN bulk_event_customers bc
                ON b.yatra_id =
                   bc.bulk_event_id

            WHERE b.admin_id = ?

            GROUP BY
                b.yatra_id,
                b.bulk_event_name

            ORDER BY
                b.start_date DESC
            """;


        try (Connection con =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {


            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();


            while (rs.next()) {

                BulkEventIncomeReport report =
                        new BulkEventIncomeReport();


                report.setBulkEventId(
                        rs.getInt("yatra_id"));


                report.setBulkEventName(
                        rs.getString(
                                "bulk_event_name"));


                report.setTotalFamilies(
                        rs.getInt(
                                "totalFamilies"));


                report.setTotalAmount(
                        rs.getDouble(
                                "totalAmount"));


                report.setReceivedAmount(
                        rs.getDouble(
                                "receivedAmount"));


                report.setPendingAmount(
                        rs.getDouble(
                                "pendingAmount"));


                // ==========================================
                // PAYMENT STATUS
                // ==========================================

                if (report.getPendingAmount() == 0) {

                    report.setPaymentStatus(
                            "PAID");

                } else if (
                        report.getReceivedAmount() > 0) {

                    report.setPaymentStatus(
                            "PARTIAL");

                } else {

                    report.setPaymentStatus(
                            "PENDING");
                }


                list.add(report);
            }


        } catch (SQLException e) {

            e.printStackTrace();
        }


        return list;
    }


    // =========================================================
    // TOTAL BULK EVENTS
    // =========================================================

    @Override
    public int getTotalBulkEvents(
            int adminId) {

        int total = 0;

        String sql = """
            SELECT COUNT(*)

            FROM bulk_events

            WHERE admin_id = ?
            """;


        try (Connection con =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {


            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                total =
                        rs.getInt(1);
            }


        } catch (SQLException e) {

            e.printStackTrace();
        }


        return total;
    }


    // =========================================================
    // TOTAL FAMILIES
    // =========================================================

    @Override
    public int getTotalFamilies(
            int adminId) {

        int total = 0;

        String sql = """
            SELECT COUNT(*)

            FROM bulk_event_customers bec

            INNER JOIN bulk_events be
                ON bec.bulk_event_id =
                   be.yatra_id

            WHERE be.admin_id = ?
            """;


        try (Connection con =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {


            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                total =
                        rs.getInt(1);
            }


        } catch (SQLException e) {

            e.printStackTrace();
        }


        return total;
    }


    // =========================================================
    // TOTAL AMOUNT
    // =========================================================

    @Override
    public double getTotalAmount(
            int adminId) {

        double total = 0;

        String sql = """
            SELECT
                IFNULL(
                    SUM(bec.total_amount),
                    0
                )

            FROM bulk_event_customers bec

            INNER JOIN bulk_events be
                ON bec.bulk_event_id =
                   be.yatra_id

            WHERE be.admin_id = ?
            """;


        try (Connection con =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {


            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                total =
                        rs.getDouble(1);
            }


        } catch (SQLException e) {

            e.printStackTrace();
        }


        return total;
    }


    // =========================================================
    // RECEIVED AMOUNT
    // =========================================================

    @Override
    public double getReceivedAmount(
            int adminId) {

        double total = 0;

        String sql = """
            SELECT
                IFNULL(
                    SUM(bec.amount_paid),
                    0
                )

            FROM bulk_event_customers bec

            INNER JOIN bulk_events be
                ON bec.bulk_event_id =
                   be.yatra_id

            WHERE be.admin_id = ?
            """;


        try (Connection con =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {


            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                total =
                        rs.getDouble(1);
            }


        } catch (SQLException e) {

            e.printStackTrace();
        }


        return total;
    }


    // =========================================================
    // PENDING AMOUNT
    // =========================================================

    @Override
    public double getPendingAmount(
            int adminId) {

        double total = 0;

        String sql = """
            SELECT

                IFNULL(
                    SUM(
                        bec.total_amount
                        - bec.amount_paid
                    ),
                    0
                )

            FROM bulk_event_customers bec

            INNER JOIN bulk_events be
                ON bec.bulk_event_id =
                   be.yatra_id

            WHERE be.admin_id = ?
            """;


        try (Connection con =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {


            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                total =
                        rs.getDouble(1);
            }


        } catch (SQLException e) {

            e.printStackTrace();
        }


        return total;
    }


    // =========================================================
    // SINGLE BULK EVENT SUMMARY
    // =========================================================

    @Override
    public BulkEventIncomeReport
    getBulkEventSummary(
            int bulkEventId,
            int adminId) {

        BulkEventIncomeReport report =
                new BulkEventIncomeReport();


        String sql = """
            SELECT

                be.yatra_id,

                be.bulk_event_name,

                COUNT(bec.customer_id)
                    AS totalFamilies,

                IFNULL(
                    SUM(bec.total_amount),
                    0
                ) AS totalAmount,

                IFNULL(
                    SUM(bec.amount_paid),
                    0
                ) AS receivedAmount,

                IFNULL(
                    SUM(
                        bec.total_amount
                        - bec.amount_paid
                    ),
                    0
                ) AS pendingAmount

            FROM bulk_events be

            LEFT JOIN bulk_event_customers bec
                ON be.yatra_id =
                   bec.bulk_event_id

            WHERE be.yatra_id = ?

            AND be.admin_id = ?

            GROUP BY
                be.yatra_id,
                be.bulk_event_name
            """;


        try (Connection con =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {


            ps.setInt(1, bulkEventId);
            ps.setInt(2, adminId);

            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                report.setBulkEventId(
                        rs.getInt("yatra_id"));


                report.setBulkEventName(
                        rs.getString(
                                "bulk_event_name"));


                report.setTotalFamilies(
                        rs.getInt(
                                "totalFamilies"));


                report.setTotalAmount(
                        rs.getDouble(
                                "totalAmount"));


                report.setReceivedAmount(
                        rs.getDouble(
                                "receivedAmount"));


                report.setPendingAmount(
                        rs.getDouble(
                                "pendingAmount"));


                if (report.getPendingAmount() == 0) {

                    report.setPaymentStatus(
                            "PAID");

                } else if (
                        report.getReceivedAmount() > 0) {

                    report.setPaymentStatus(
                            "PARTIAL");

                } else {

                    report.setPaymentStatus(
                            "PENDING");
                }
            }


        } catch (SQLException e) {

            e.printStackTrace();
        }


        return report;
    }
}