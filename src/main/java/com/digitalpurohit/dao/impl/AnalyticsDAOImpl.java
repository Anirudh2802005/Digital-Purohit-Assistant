package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.digitalpurohit.dao.AnalyticsDAO;
import com.digitalpurohit.util.DBConnection;

public class AnalyticsDAOImpl implements AnalyticsDAO {

    // ==========================================
    // MONTHLY LABELS
    // ==========================================

    @Override
    public List<String> getMonthlyLabels(
            int year,
            int adminId) {

        List<String> labels =
                new ArrayList<>();

        String sql = """
                SELECT
                    MONTHNAME(event_date) AS month
                FROM events
                WHERE YEAR(event_date) = ?
                AND admin_id = ?
                GROUP BY
                    MONTH(event_date),
                    MONTHNAME(event_date)
                ORDER BY MONTH(event_date)
                """;

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, year);
            ps.setInt(2, adminId);

            try (ResultSet rs =
                    ps.executeQuery()) {

                while (rs.next()) {

                    labels.add(
                            rs.getString("month"));

                }
            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return labels;
    }


    // ==========================================
    // MONTHLY INCOME
    // ==========================================

    @Override
    public List<Double> getMonthlyIncome(
            int year,
            int adminId) {

        List<Double> income =
                new ArrayList<>();

        String sql = """
                SELECT
                    SUM(amount_paid) AS income
                FROM events
                WHERE YEAR(event_date) = ?
                AND admin_id = ?
                GROUP BY MONTH(event_date)
                ORDER BY MONTH(event_date)
                """;

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, year);
            ps.setInt(2, adminId);

            try (ResultSet rs =
                    ps.executeQuery()) {

                while (rs.next()) {

                    income.add(
                            rs.getDouble("income"));

                }
            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return income;
    }


    // ==========================================
    // PAYMENT STATUS
    // ==========================================

    @Override
    public Map<String, Integer>
    getPaymentStatusCount(int adminId) {

        Map<String, Integer> status =
                new LinkedHashMap<>();

        // Initialize all statuses
        status.put("PAID", 0);
        status.put("PARTIAL", 0);
        status.put("PENDING", 0);

        String sql = """
                SELECT
                    payment_status,
                    COUNT(*) AS total
                FROM events
                WHERE admin_id = ?
                GROUP BY payment_status
                """;

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, adminId);

            try (ResultSet rs =
                    ps.executeQuery()) {

                while (rs.next()) {

                    String paymentStatus =
                            rs.getString(
                                    "payment_status");

                    int total =
                            rs.getInt("total");

                    if (paymentStatus != null) {

                        status.put(
                                paymentStatus,
                                total);
                    }
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return status;
    }


    // ==========================================
    // EVENT TYPE LABELS
    // ==========================================

    @Override
    public List<String>
    getEventTypeLabels(int adminId) {

        List<String> labels =
                new ArrayList<>();

        String sql = """
                SELECT
                    event_title,
                    SUM(amount_paid) AS income
                FROM events
                WHERE admin_id = ?
                GROUP BY event_title
                ORDER BY income DESC
                """;

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, adminId);

            try (ResultSet rs =
                    ps.executeQuery()) {

                while (rs.next()) {

                    labels.add(
                            rs.getString(
                                    "event_title"));

                }
            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return labels;
    }


    // ==========================================
    // EVENT TYPE INCOME
    // ==========================================

    @Override
    public List<Double>
    getEventTypeIncome(int adminId) {

        List<Double> income =
                new ArrayList<>();

        String sql = """
                SELECT
                    event_title,
                    SUM(amount_paid) AS income
                FROM events
                WHERE admin_id = ?
                GROUP BY event_title
                ORDER BY income DESC
                """;

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, adminId);

            try (ResultSet rs =
                    ps.executeQuery()) {

                while (rs.next()) {

                    income.add(
                            rs.getDouble("income"));

                }
            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return income;
    }
}