package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.DashboardDAO;
import com.digitalpurohit.model.DashboardSummary;
import com.digitalpurohit.model.Event;
import com.digitalpurohit.util.DBConnection;
import java.util.ArrayList;
import com.digitalpurohit.model.FrequentCustomer;
public class DashboardDAOImpl implements DashboardDAO {

   
    @Override
    public DashboardSummary getDashboardSummary() {

        DashboardSummary summary = new DashboardSummary();

        String query =
                "SELECT " +
                "(SELECT COUNT(*) FROM customers) totalCustomers, " +
                "(SELECT COUNT(*) FROM events WHERE event_date = CURDATE()) todayEvents, " +
                "(SELECT COUNT(*) FROM bulk_events WHERE event_date = CURDATE()) todayGroupEvents, " +
                "(SELECT IFNULL(SUM(amount_paid),0) FROM events WHERE event_date = CURDATE()) todayIncome, " +
                "(SELECT IFNULL(SUM(amount_paid),0) FROM events " +
                " WHERE MONTH(event_date)=MONTH(CURDATE()) " +
                " AND YEAR(event_date)=YEAR(CURDATE())) monthlyEventIncome, " +
                "(SELECT IFNULL(SUM(amount_paid),0) FROM bulk_event_customers " +
                " WHERE MONTH(created_at)=MONTH(CURDATE()) " +
                " AND YEAR(created_at)=YEAR(CURDATE())) monthlyGroupIncome, " +
                "(SELECT IFNULL(SUM(total_amount-amount_paid),0) " +
                " FROM events WHERE payment_status<>'PAID') pendingIncome";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                summary.setTotalCustomers(
                        rs.getInt("totalCustomers"));

                summary.setTodayEvents(
                        rs.getInt("todayEvents"));

                summary.setTodayGroupEvents(
                        rs.getInt("todayGroupEvents"));

                summary.setTodayIncome(
                        rs.getDouble("todayIncome"));

                summary.setMonthlyEventIncome(
                        rs.getDouble("monthlyEventIncome"));

                summary.setMonthlyGroupIncome(
                        rs.getDouble("monthlyGroupIncome"));

                summary.setPendingIncome(
                        rs.getDouble("pendingIncome"));

                summary.setTotalMonthlyIncome(
                        summary.getMonthlyEventIncome()
                      + summary.getMonthlyGroupIncome());

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return summary;
    }

    @Override
    public List<Event> getTodayEvents() {

        return new ArrayList<>();
    }
    @Override
    public int getTotalCustomerCount(int adminId) {

        String sql =
                "SELECT COUNT(*) FROM customers WHERE admin_id=?";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    @Override
    public int getNewCustomersThisMonth(int adminId) {

        String sql =
                """
                SELECT COUNT(*)
                FROM customers
                WHERE admin_id=?
                AND MONTH(created_at)=MONTH(CURDATE())
                AND YEAR(created_at)=YEAR(CURDATE())
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    
    @Override
    public int getFrequentCustomerCount(int adminId) {

        String sql =
                """
                SELECT COUNT(DISTINCT customer_id)
                FROM events
                WHERE admin_id=?
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;
    }

    @Override
    public List<Event> getTomorrowEvents() {

        return new ArrayList<>();
    }

    @Override
    public List<Event> getUpcomingEvents(int days) {

        return new ArrayList<>();
    }
    @Override
    public List<FrequentCustomer> getFrequentCustomers(int adminId) {

        List<FrequentCustomer> list = new ArrayList<>();

        String sql =
                """
                SELECT
                    c.customer_id,
                    c.customer_name,
                    c.phone,
                    c.gothram,
                    COUNT(e.event_id) AS total_events
                FROM customers c
                INNER JOIN events e
                    ON c.customer_id = e.customer_id
                WHERE c.admin_id=?
                GROUP BY
                    c.customer_id,
                    c.customer_name,
                    c.phone,
                    c.gothram
                ORDER BY total_events DESC
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                FrequentCustomer customer = new FrequentCustomer();

                customer.setCustomerId(
                        rs.getInt("customer_id"));

                customer.setCustomerName(
                        rs.getString("customer_name"));

                customer.setPhone(
                        rs.getString("phone"));

                customer.setGothram(
                        rs.getString("gothram"));

                customer.setTotalEvents(
                        rs.getInt("total_events"));

                list.add(customer);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;
    }
}