package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.IncomeReportDAO;
import com.digitalpurohit.model.IncomeReport;
import com.digitalpurohit.util.DBConnection;

public class IncomeReportDAOImpl implements IncomeReportDAO {


    // =========================================================
    // TODAY'S INCOME
    // =========================================================

    @Override
    public List<IncomeReport> getTodayIncome(
            int adminId) {

        List<IncomeReport> list =
                new ArrayList<>();

        try (Connection con =
                     DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            e.event_id,
                            e.event_date,

                            c.customer_name,

                            e.event_title,

                            e.total_amount,
                            e.amount_paid,

                            e.payment_status

                        FROM events e

                        JOIN customers c
                            ON e.customer_id =
                               c.customer_id

                        WHERE e.event_date = CURDATE()

                        AND e.admin_id = ?

                        ORDER BY e.event_time
                    """);

            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                list.add(
                        extractIncome(rs));
            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }


    // =========================================================
    // MONTHLY INCOME
    // =========================================================

    @Override
    public List<IncomeReport> getMonthlyIncome(
            int month,
            int year,
            int adminId) {

        List<IncomeReport> list =
                new ArrayList<>();

        try (Connection con =
                     DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            e.event_id,
                            e.event_date,

                            c.customer_name,

                            e.event_title,

                            e.total_amount,
                            e.amount_paid,

                            e.payment_status

                        FROM events e

                        JOIN customers c
                            ON e.customer_id =
                               c.customer_id

                        WHERE MONTH(e.event_date) = ?

                        AND YEAR(e.event_date) = ?

                        AND e.admin_id = ?

                        ORDER BY
                            e.event_date,
                            e.event_time
                    """);

            ps.setInt(1, month);
            ps.setInt(2, year);
            ps.setInt(3, adminId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                list.add(
                        extractIncome(rs));
            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }


    // =========================================================
    // YEARLY INCOME
    // =========================================================

    @Override
    public List<IncomeReport> getYearlyIncome(
            int year,
            int adminId) {

        List<IncomeReport> list =
                new ArrayList<>();

        try (Connection con =
                     DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            e.event_id,
                            e.event_date,

                            c.customer_name,

                            e.event_title,

                            e.total_amount,
                            e.amount_paid,

                            e.payment_status

                        FROM events e

                        JOIN customers c
                            ON e.customer_id =
                               c.customer_id

                        WHERE YEAR(e.event_date) = ?

                        AND e.admin_id = ?

                        ORDER BY
                            e.event_date,
                            e.event_time
                    """);

            ps.setInt(1, year);
            ps.setInt(2, adminId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                list.add(
                        extractIncome(rs));
            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }


    // =========================================================
    // CUSTOM DATE RANGE
    // =========================================================

    @Override
    public List<IncomeReport> getCustomIncome(
            Date fromDate,
            Date toDate,
            int adminId) {

        List<IncomeReport> list =
                new ArrayList<>();

        try (Connection con =
                     DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            e.event_id,
                            e.event_date,

                            c.customer_name,

                            e.event_title,

                            e.total_amount,
                            e.amount_paid,

                            e.payment_status

                        FROM events e

                        JOIN customers c
                            ON e.customer_id =
                               c.customer_id

                        WHERE e.event_date
                              BETWEEN ? AND ?

                        AND e.admin_id = ?

                        ORDER BY
                            e.event_date,
                            e.event_time
                    """);

            ps.setDate(1, fromDate);
            ps.setDate(2, toDate);
            ps.setInt(3, adminId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                list.add(
                        extractIncome(rs));
            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }


    // =========================================================
    // MONTHLY GRAPH LABELS
    // =========================================================

    @Override
    public List<String> getMonthlyLabels(
            int year,
            int adminId) {

        List<String> labels =
                new ArrayList<>();

        try (Connection con =
                     DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            MONTHNAME(event_date)
                            AS month

                        FROM events

                        WHERE YEAR(event_date) = ?

                        AND admin_id = ?

                        GROUP BY
                            MONTH(event_date),
                            MONTHNAME(event_date)

                        ORDER BY
                            MONTH(event_date)
                    """);

            ps.setInt(1, year);
            ps.setInt(2, adminId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                labels.add(
                        rs.getString("month"));
            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return labels;
    }


    // =========================================================
    // MONTHLY GRAPH VALUES
    // =========================================================

    @Override
    public List<Double> getMonthlyIncomeValues(
            int year,
            int adminId) {

        List<Double> values =
                new ArrayList<>();

        try (Connection con =
                     DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("""
                        SELECT

                            IFNULL(
                                SUM(amount_paid),
                                0
                            ) AS income

                        FROM events

                        WHERE YEAR(event_date) = ?

                        AND admin_id = ?

                        GROUP BY
                            MONTH(event_date)

                        ORDER BY
                            MONTH(event_date)
                    """);

            ps.setInt(1, year);
            ps.setInt(2, adminId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                values.add(
                        rs.getDouble("income"));
            }

            rs.close();
            ps.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return values;
    }

 // =========================================================
 // EVENT TYPE LABELS
 // =========================================================

 @Override
 public List<String> getEventTypeLabels(
         int year,
         int adminId) {

     List<String> labels =
             new ArrayList<>();

     try (Connection con =
                  DBConnection.getConnection()) {

         PreparedStatement ps =
                 con.prepareStatement("""
                     SELECT
                         et.type_name

                     FROM events e

                     INNER JOIN event_types et
                         ON e.type_id = et.type_id

                     WHERE YEAR(e.event_date) = ?

                     AND e.admin_id = ?

                     GROUP BY
                         et.type_id,
                         et.type_name

                     ORDER BY
                         et.type_name
                 """);

         ps.setInt(1, year);
         ps.setInt(2, adminId);

         ResultSet rs =
                 ps.executeQuery();

         while (rs.next()) {

             labels.add(
                     rs.getString("type_name"));
         }

         rs.close();
         ps.close();

     } catch (Exception e) {

         e.printStackTrace();
     }

     return labels;
 }


 // =========================================================
 // EVENT TYPE INCOME VALUES
 // =========================================================

 @Override
 public List<Double> getEventTypeIncomeValues(
         int year,
         int adminId) {

     List<Double> values =
             new ArrayList<>();

     try (Connection con =
                  DBConnection.getConnection()) {

         PreparedStatement ps =
                 con.prepareStatement("""
                     SELECT

                         IFNULL(
                             SUM(e.amount_paid),
                             0
                         ) AS income

                     FROM events e

                     INNER JOIN event_types et
                         ON e.type_id = et.type_id

                     WHERE YEAR(e.event_date) = ?

                     AND e.admin_id = ?

                     GROUP BY
                         et.type_id,
                         et.type_name

                     ORDER BY
                         et.type_name
                 """);

         ps.setInt(1, year);
         ps.setInt(2, adminId);

         ResultSet rs =
                 ps.executeQuery();

         while (rs.next()) {

             values.add(
                     rs.getDouble("income"));
         }

         rs.close();
         ps.close();

     } catch (Exception e) {

         e.printStackTrace();
     }

     return values;
 }
    // =========================================================
    // EXTRACT INCOME
    // =========================================================

    private IncomeReport extractIncome(
            ResultSet rs)
            throws Exception {

        IncomeReport income =
                new IncomeReport();

        income.setEventId(
                rs.getInt("event_id"));

        income.setEventDate(
                rs.getDate("event_date"));

        income.setCustomerName(
                rs.getString("customer_name"));

        income.setEventTitle(
                rs.getString("event_title"));

        income.setTotalAmount(
                rs.getDouble("total_amount"));

        income.setAmountPaid(
                rs.getDouble("amount_paid"));

        income.setPendingAmount(
                rs.getDouble("total_amount")
                -
                rs.getDouble("amount_paid"));

        income.setPaymentStatus(
                rs.getString("payment_status"));

        return income;
    }
}