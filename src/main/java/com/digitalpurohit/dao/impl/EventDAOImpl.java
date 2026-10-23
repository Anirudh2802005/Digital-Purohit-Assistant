package com.digitalpurohit.dao.impl;

import java.sql.Connection;import java.util.List;
import java.util.ArrayList;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.model.Event;
import com.digitalpurohit.util.DBConnection;
import java.time.LocalDate;
public class EventDAOImpl implements EventDAO {

	@Override
	public int saveEvent(Event event) {

	    String query =
	            "INSERT INTO events(" +
	            "admin_id, " +
	            "customer_id, " +
	            "type_id, " +
	            "event_title, " +
	            "event_date, " +
	            "event_time, " +
	            "location, " +
	            "recurring_type, " +
	            "recurring_day, " +
	            "recurring_end_date, " +
	            "total_amount, " +
	            "amount_paid, " +
	            "payment_status, " +
	            "notes" +
	            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement ps =
	                 connection.prepareStatement(
	                         query,
	                         PreparedStatement.RETURN_GENERATED_KEYS)) {

	        ps.setInt(1, event.getAdminId());
	        ps.setInt(2, event.getCustomerId());
	        ps.setInt(3, event.getTypeId());
	        ps.setString(4, event.getEventTitle());
	        ps.setDate(5, event.getEventDate());
	        ps.setTime(6, event.getEventTime());
	        ps.setString(7, event.getLocation());
	        ps.setString(8, event.getRecurringType());
	        ps.setString(9, event.getRecurringDay());
	        ps.setDate(10, event.getRecurringEndDate());
	        ps.setDouble(11, event.getTotalAmount());
	        ps.setDouble(12, event.getAmountPaid());
	        ps.setString(13, event.getPaymentStatus());
	        ps.setString(14, event.getNotes());

	        int rows = ps.executeUpdate();

	        if (rows > 0) {

	            ResultSet rs = ps.getGeneratedKeys();

	            if (rs.next()) {

	                return rs.getInt(1);

	            }

	        }

	    } catch (SQLException e) {

	        System.out.println("========== SAVE EVENT ERROR ==========");
	        System.out.println("Message : " + e.getMessage());
	        System.out.println("SQLState: " + e.getSQLState());
	        System.out.println("Code    : " + e.getErrorCode());
	        e.printStackTrace();
	    }

	    return -1;
	}

    
	@Override
	public boolean deleteEvent(int eventId) {

	    String query =
	            "DELETE FROM events WHERE event_id=?";

	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement ps =
	                 connection.prepareStatement(query)) {

	        ps.setInt(1, eventId);

	        return ps.executeUpdate() > 0;

	    } catch (SQLException e) {

	        e.printStackTrace();

	    }

	    return false;
	}

    @Override
    public Event getEventById(int eventId) {

        String query =
                "SELECT * FROM events WHERE event_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, eventId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Event event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setAdminId(
                        rs.getInt("admin_id"));
                event.setCustomerId(rs.getInt("customer_id"));
                event.setTypeId(rs.getInt("type_id"));
                event.setEventTitle(rs.getString("event_title"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));
                event.setRecurringType(rs.getString("recurring_type"));
                event.setRecurringDay(rs.getString("recurring_day"));
                event.setRecurringEndDate(rs.getDate("recurring_end_date"));
                event.setTotalAmount(rs.getDouble("total_amount"));
                event.setAmountPaid(rs.getDouble("amount_paid"));
                event.setPaymentStatus(rs.getString("payment_status"));
                event.setNotes(rs.getString("notes"));
                event.setCreatedAt(rs.getTimestamp("created_at"));

                return event;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    private Event extractEvent(ResultSet rs) throws Exception {

        Event event = new Event();

        event.setEventId(rs.getInt("event_id"));
        event.setAdminId(
                rs.getInt("admin_id"));
        event.setCustomerId(rs.getInt("customer_id"));
        event.setTypeId(rs.getInt("type_id"));

        event.setEventTitle(rs.getString("event_title"));

        event.setEventDate(rs.getDate("event_date"));

        event.setEventTime(rs.getTime("event_time"));

        event.setLocation(rs.getString("location"));

        event.setRecurringType(rs.getString("recurring_type"));

        event.setRecurringDay(rs.getString("recurring_day"));

        event.setRecurringEndDate(rs.getDate("recurring_end_date"));

        event.setTotalAmount(rs.getDouble("total_amount"));

        event.setAmountPaid(rs.getDouble("amount_paid"));

        event.setPaymentStatus(rs.getString("payment_status"));

        event.setNotes(rs.getString("notes"));

        event.setCreatedAt(rs.getTimestamp("created_at"));

        return event;
    }
    @Override
    public boolean receivePayment(
            int eventId,
            double receiveAmount,
            String notes) {

        String selectQuery =
                "SELECT total_amount, amount_paid " +
                "FROM events WHERE event_id=?";

        String updateQuery =
                "UPDATE events " +
                "SET amount_paid=?, payment_status=?, notes=? " +
                "WHERE event_id=?";

        try (Connection connection = DBConnection.getConnection()) {

            double totalAmount = 0;
            double amountPaid = 0;

            PreparedStatement selectPs =
                    connection.prepareStatement(selectQuery);

            selectPs.setInt(1, eventId);

            ResultSet rs = selectPs.executeQuery();

            if (rs.next()) {

                totalAmount =
                        rs.getDouble("total_amount");

                amountPaid =
                        rs.getDouble("amount_paid");
            }

            // Add today's received amount
            amountPaid += receiveAmount;

            // Prevent amount from exceeding total amount
            if (amountPaid > totalAmount) {

                amountPaid = totalAmount;
            }

            String paymentStatus = "PENDING";

            if (amountPaid > 0 && amountPaid < totalAmount) {
                paymentStatus = "PARTIAL";
            } else if (amountPaid >= totalAmount) {
                paymentStatus = "PAID";
            }
            PreparedStatement updatePs =
                    connection.prepareStatement(updateQuery);

            updatePs.setDouble(1, amountPaid);
            updatePs.setString(2, paymentStatus);
            updatePs.setString(3, notes);
            updatePs.setInt(4, eventId);

            int rows = updatePs.executeUpdate();

            System.out.println("Rows Updated : " + rows);
            System.out.println("Event ID     : " + eventId);
            System.out.println("Total Amount : " + totalAmount);
            System.out.println("Amount Paid  : " + amountPaid);
            System.out.println("Status       : " + paymentStatus);

            return rows > 0;
            

        } catch (SQLException e) {

            e.printStackTrace();
        }
        

        return false;
    }
    
    @Override
    public int getEventCount(int adminId) {

        String query =
                "SELECT COUNT(*) FROM events WHERE admin_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

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
    public double getTodayIncome(int adminId) {

        String query =
                "SELECT IFNULL(SUM(amount_paid),0) " +
                "FROM events " +
                "WHERE admin_id = ? AND event_date = CURDATE()";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    
    @Override
    public List<Event> getUpcomingEvents(int limit, int adminId) {

        List<Event> list = new ArrayList<>();

        String query =
                "SELECT * FROM events " +
                "WHERE admin_id = ? AND event_date > CURDATE() " +
                "ORDER BY event_date ASC LIMIT ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, adminId);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Event event = new Event();
                event.setEventId(rs.getInt("event_id"));
                event.setEventTitle(rs.getString("event_title")); 
                event.setEventDate(rs.getDate("event_date"));

                list.add(event);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    @Override
    public int getTodayEventCount() {

        String query =
                "SELECT COUNT(*) FROM events WHERE event_date = CURDATE()";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    @Override
    public double getPendingIncome() {

        String query =
                "SELECT SUM(total_amount - amount_paid) " +
                "FROM events " +
                "WHERE payment_status <> 'PAID'";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                return rs.getDouble(1);

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    
    @Override
    public List<Event> getUpcomingEvents(int days) {

        List<Event> events = new ArrayList<>();

        String query =
                "SELECT * FROM events " +
                "WHERE event_date BETWEEN CURDATE() " +
                "AND DATE_ADD(CURDATE(), INTERVAL ? DAY) " +
                "ORDER BY event_date";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, days);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Event event = new Event();

                event.setEventId(
                        rs.getInt("event_id"));

                event.setCustomerId(
                        rs.getInt("customer_id"));

                event.setTypeId(
                        rs.getInt("type_id"));

                event.setEventTitle(
                        rs.getString("event_title"));

                event.setEventDate(
                        rs.getDate("event_date"));

                event.setEventTime(
                        rs.getTime("event_time"));

                event.setLocation(
                        rs.getString("location"));

                events.add(event);

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return events;
    }
    @Override
    public Event getEvent(int eventId) {

        Event event = null;

        String query = "SELECT * FROM events WHERE event_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, eventId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setCustomerId(rs.getInt("customer_id"));
                event.setTypeId(rs.getInt("type_id"));
                event.setEventTitle(rs.getString("event_title"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));
                event.setRecurringType(rs.getString("recurring_type"));
                event.setRecurringDay(rs.getString("recurring_day"));
                event.setRecurringEndDate(rs.getDate("recurring_end_date"));

                event.setTotalAmount(rs.getDouble("total_amount"));
                event.setAmountPaid(rs.getDouble("amount_paid"));

                event.setPaymentStatus(rs.getString("payment_status"));
                event.setNotes(rs.getString("notes"));
                event.setCreatedAt(rs.getTimestamp("created_at"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return event;
    }
   
    @Override
    public Event getConflictEvent(
            Date eventDate,
            Time eventTime) {

        String query =
                "SELECT e.*, c.customer_name, c.phone " +
                "FROM events e " +
                "JOIN customers c ON e.customer_id = c.customer_id " +
                "WHERE e.event_date=? AND e.event_time=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setDate(1, eventDate);
            ps.setTime(2, eventTime);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Event event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setCustomerId(rs.getInt("customer_id"));
                event.setEventTitle(rs.getString("event_title"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));

                event.setCustomerName(
                        rs.getString("customer_name"));

                event.setPhone(
                        rs.getString("phone"));

                return event;
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return null;
    }
    
    
    @Override
    public Event getCustomerConflict(
            String phone,
            Date eventDate) {

        String query =
                "SELECT e.*, c.customer_name, c.phone " +
                "FROM events e " +
                "JOIN customers c ON e.customer_id = c.customer_id " +
                "WHERE c.phone=? " +
                "AND e.event_date=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, phone);
            ps.setDate(2, eventDate);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Event event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setCustomerId(rs.getInt("customer_id"));
                event.setEventTitle(rs.getString("event_title"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));

                event.setCustomerName(
                        rs.getString("customer_name"));

                event.setPhone(
                        rs.getString("phone"));

                return event;
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return null;
    }
    @Override
    public Event getPreviousEvent(
            Date eventDate,
            Time eventTime) {

        String query =
                "SELECT e.*, c.customer_name, c.phone " +
                "FROM events e " +
                "JOIN customers c ON e.customer_id = c.customer_id " +
                "WHERE e.event_date=? " +
                "AND e.event_time < ? " +
                "ORDER BY e.event_time DESC " +
                "LIMIT 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setDate(1, eventDate);
            ps.setTime(2, eventTime);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Event event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setCustomerId(rs.getInt("customer_id"));
                event.setEventTitle(rs.getString("event_title"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));
                event.setCustomerName(rs.getString("customer_name"));
                event.setPhone(rs.getString("phone"));

                return event;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    
    @Override
    public List<Event> getAllEvents() {

        List<Event> events =
                new ArrayList<>();

        String query =
        	    "SELECT e.*, c.customer_name " +
        	    "FROM events e " +
        	    "JOIN customers c " +
        	    "ON e.customer_id = c.customer_id " +
        	    "ORDER BY e.event_date";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query);

             ResultSet rs =
                     ps.executeQuery()) {

            while (rs.next()) {

                Event event =
                        new Event();

                event.setEventId(
                        rs.getInt("event_id"));

                event.setCustomerId(
                        rs.getInt("customer_id"));
                event.setCustomerName(
                        rs.getString("customer_name"));
                event.setTypeId(
                        rs.getInt("type_id"));

                event.setEventTitle(
                        rs.getString("event_title"));

                event.setEventDate(
                        rs.getDate("event_date"));

                event.setEventTime(
                        rs.getTime("event_time"));

                event.setLocation(
                        rs.getString("location"));

                event.setRecurringType(
                        rs.getString("recurring_type"));

                event.setRecurringDay(
                        rs.getString("recurring_day"));

                event.setRecurringEndDate(
                        rs.getDate("recurring_end_date"));

                event.setTotalAmount(
                        rs.getDouble("total_amount"));

                event.setAmountPaid(rs.getDouble("amount_paid"));
                event.setPaymentStatus(
                        rs.getString("payment_status"));

                event.setNotes(
                        rs.getString("notes"));

                events.add(event);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return events;
    }
    
    @Override
    public boolean updateEvent(Event event) {

        String query =
                "UPDATE events SET " +
                "customer_id=?, " +
                "type_id=?, " +
                "event_title=?, " +
                "event_date=?, " +
                "event_time=?, " +
                "location=?, " +
                "total_amount=?, " +
                "amount_paid=?, " +
                "payment_status=?, " +
                "notes=? " +
                "WHERE event_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, event.getCustomerId());
            ps.setInt(2, event.getTypeId());
            ps.setString(3, event.getEventTitle());
            ps.setDate(4, event.getEventDate());
            ps.setTime(5, event.getEventTime());
            ps.setString(6, event.getLocation());
            ps.setDouble(7, event.getTotalAmount());
            ps.setDouble(8, event.getAmountPaid());
            ps.setString(9, event.getPaymentStatus());
            ps.setString(10, event.getNotes());
            ps.setInt(11, event.getEventId());

            int rows = ps.executeUpdate();

            System.out.println("Rows Updated : " + rows);

            return rows > 0;

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return false;
    }   
    @Override
    public List<Event> searchEvents(String keyword) {

        List<Event> events =
                new ArrayList<>();

        String query =
        	    "SELECT e.*, c.customer_name " +
        	    "FROM events e " +
        	    "JOIN customers c ON e.customer_id = c.customer_id " +
        	    "WHERE e.event_title LIKE ? " +
        	    "OR e.location LIKE ? " +
        	    "OR c.customer_name LIKE ? " +
        	    "OR c.phone LIKE ? " +
        	    "ORDER BY e.event_date";
        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

        	ps.setString(1, "%" + keyword + "%");
        	ps.setString(2, "%" + keyword + "%");
        	ps.setString(3, "%" + keyword + "%");
        	ps.setString(4, "%" + keyword + "%");

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Event event =
                        new Event();

                event.setEventId(
                        rs.getInt("event_id"));

                event.setCustomerId(
                        rs.getInt("customer_id"));

                event.setTypeId(
                        rs.getInt("type_id"));

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

                event.setAmountPaid(rs.getDouble("amount_paid"));

                event.setPaymentStatus(
                        rs.getString("payment_status"));
                event.setCustomerName(
                	    rs.getString("customer_name"));
                event.setNotes(
                        rs.getString("notes"));

                events.add(event);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return events;
    }
    
    @Override
    public List<Event> getAllEvents(int adminId) {

        List<Event> events = new ArrayList<>();

        String query =
                "SELECT e.*, c.customer_name " +
                "FROM events e " +
                "JOIN customers c ON e.customer_id = c.customer_id " +
                "WHERE e.admin_id = ? " +
                "ORDER BY e.event_date";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Event event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setAdminId(rs.getInt("admin_id"));
                event.setCustomerId(rs.getInt("customer_id"));
                event.setCustomerName(rs.getString("customer_name"));
                event.setTypeId(rs.getInt("type_id"));
                event.setEventTitle(rs.getString("event_title"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));
                event.setRecurringType(rs.getString("recurring_type"));
                event.setRecurringDay(rs.getString("recurring_day"));
                event.setRecurringEndDate(rs.getDate("recurring_end_date"));
                event.setTotalAmount(rs.getDouble("total_amount"));
                event.setAmountPaid(rs.getDouble("amount_paid"));
                event.setPaymentStatus(rs.getString("payment_status"));
                event.setNotes(rs.getString("notes"));

                events.add(event);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return events;
    }
    
    @Override
    public List<Event> searchEvents(String keyword, int adminId) {

        List<Event> events = new ArrayList<>();

        String query =
                "SELECT e.*, c.customer_name " +
                "FROM events e " +
                "JOIN customers c ON e.customer_id = c.customer_id " +
                "WHERE e.admin_id = ? " +
                "AND (" +
                "e.event_title LIKE ? " +
                "OR e.location LIKE ? " +
                "OR c.customer_name LIKE ? " +
                "OR c.phone LIKE ?) " +
                "ORDER BY e.event_date";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, adminId);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Event event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setAdminId(rs.getInt("admin_id"));
                event.setCustomerId(rs.getInt("customer_id"));
                event.setCustomerName(rs.getString("customer_name"));
                event.setTypeId(rs.getInt("type_id"));
                event.setEventTitle(rs.getString("event_title"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));
                event.setTotalAmount(rs.getDouble("total_amount"));
                event.setAmountPaid(rs.getDouble("amount_paid"));
                event.setPaymentStatus(rs.getString("payment_status"));
                event.setNotes(rs.getString("notes"));

                events.add(event);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return events;
    }
    
    
    @Override
    public List<Event> getTodayEvents(int adminId) {

        List<Event> events = new ArrayList<>();

        String sql =
                "SELECT e.*, c.customer_name " +
                "FROM events e " +
                "JOIN customers c ON e.customer_id = c.customer_id " +
                "WHERE e.admin_id=? " +
                "AND e.event_date=CURDATE() " +
                "ORDER BY e.event_time";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Event event = extractEvent(rs);
                event.setCustomerName(rs.getString("customer_name"));

                events.add(event);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return events;
    }
    
    
    @Override
    public List<Event> getUpcomingEventsByAdmin(int adminId) {

        List<Event> events = new ArrayList<>();

        String sql =
                "SELECT e.*, c.customer_name " +
                "FROM events e " +
                "JOIN customers c ON e.customer_id = c.customer_id " +
                "WHERE e.admin_id=? " +
                "AND e.event_date > CURDATE() " +
                "ORDER BY e.event_date,e.event_time";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Event event = extractEvent(rs);
                event.setCustomerName(rs.getString("customer_name"));

                events.add(event);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return events;
    }
    
    
    @Override
    public boolean updateEvent(Event event, int adminId) {

        String query =
                "UPDATE events SET " +
                "customer_id=?, " +
                "type_id=?, " +
                "event_title=?, " +
                "event_date=?, " +
                "event_time=?, " +
                "location=?, " +
                "total_amount=?, " +
                "amount_paid=?, " +
                "payment_status=?, " +
                "notes=? " +
                "WHERE event_id=? AND admin_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, event.getCustomerId());
            ps.setInt(2, event.getTypeId());
            ps.setString(3, event.getEventTitle());
            ps.setDate(4, event.getEventDate());
            ps.setTime(5, event.getEventTime());
            ps.setString(6, event.getLocation());
            ps.setDouble(7, event.getTotalAmount());
            ps.setDouble(8, event.getAmountPaid());
            ps.setString(9, event.getPaymentStatus());
            ps.setString(10, event.getNotes());
            ps.setInt(11, event.getEventId());
            ps.setInt(12, adminId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;
    }
    
    
    @Override
    public boolean deleteEvent(int eventId, int adminId) {

        String query =
                "DELETE FROM events " +
                "WHERE event_id=? AND admin_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, eventId);
            ps.setInt(2, adminId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;
    }
    
    
    
    
    @Override
    public List<Event> getEventsByType(int typeId,
                                       int adminId) {

        List<Event> events = new ArrayList<>();

        String sql =
                "SELECT e.*, c.customer_name " +
                "FROM events e " +
                "JOIN customers c ON e.customer_id=c.customer_id " +
                "WHERE e.type_id=? " +
                "AND e.admin_id=? " +
                "ORDER BY e.event_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, typeId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Event event = extractEvent(rs);

                event.setCustomerName(
                        rs.getString("customer_name"));

                events.add(event);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return events;
    }
    
    
    @Override
    public Event getEventById(int eventId, int adminId) {

        String query =
                "SELECT * FROM events " +
                "WHERE event_id=? AND admin_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, eventId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return extractEvent(rs);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return null;
    }

    @Override
    public int getEventCount() {

        String query = "SELECT COUNT(*) FROM events";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
    @Override
    public List<Event> getTodayEvents() {

        List<Event> events = new ArrayList<>();

        String query =
            "SELECT e.*, c.customer_name " +
            "FROM events e " +
            "JOIN customers c ON e.customer_id = c.customer_id " +
            "WHERE e.event_date = CURDATE() " +
            "ORDER BY e.event_time";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Event event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setCustomerId(rs.getInt("customer_id"));
                event.setCustomerName(rs.getString("customer_name"));
                event.setTypeId(rs.getInt("type_id"));
                event.setEventTitle(rs.getString("event_title"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));
                event.setTotalAmount(rs.getDouble("total_amount"));
                event.setAmountPaid(rs.getDouble("amount_paid"));
                event.setPaymentStatus(rs.getString("payment_status"));
                event.setNotes(rs.getString("notes"));

                events.add(event);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return events;
    }

    @Override
    public List<Event> getUpcomingEvents() {

        List<Event> events = new ArrayList<>();

        String query =
            "SELECT e.*, c.customer_name " +
            "FROM events e " +
            "JOIN customers c ON e.customer_id = c.customer_id " +
            "WHERE e.event_date > CURDATE() " +
            "ORDER BY e.event_date, e.event_time";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Event event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setCustomerId(rs.getInt("customer_id"));
                event.setCustomerName(rs.getString("customer_name"));
                event.setTypeId(rs.getInt("type_id"));
                event.setEventTitle(rs.getString("event_title"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));
                event.setTotalAmount(rs.getDouble("total_amount"));
                event.setAmountPaid(rs.getDouble("amount_paid"));
                event.setPaymentStatus(rs.getString("payment_status"));
                event.setNotes(rs.getString("notes"));

                events.add(event);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return events;
    
    }
    @Override
    public int getEventCountByDate(LocalDate date) {

        String sql =
            "SELECT COUNT(*) FROM events WHERE event_date=?";

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(date));

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                return rs.getInt(1);

            }

        } catch(Exception e) {

            e.printStackTrace();

        }

        return 0;
    }

    @Override
    public List<Event> getEventsByDate(Date date,
                                       int adminId) {

        List<Event> events =
                new ArrayList<>();

        String sql =
                "SELECT * " +
                "FROM events " +
                "WHERE event_date = ? " +
                "AND admin_id = ? " +
                "ORDER BY event_time";

        try (Connection con =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setDate(1, date);

            ps.setInt(2, adminId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                events.add(extractEvent(rs));

            }

            rs.close();

        } catch (Exception e) {

            e.printStackTrace();

        }

        return events;
    }
    
    
    private static final String GET_PENDING_PAYMENT_EVENTS =

    		"SELECT * FROM events " +
    		"WHERE payment_status IN ('PENDING','PARTIAL') " +
    		"ORDER BY event_date";
    
    
    
    @Override
    public List<Event> getEventsByCustomer(int customerId) {
        return new ArrayList<>();
    }

    @Override
    public int getEventCountByType(int typeId) {

        int count = 0;

        String sql = """
            SELECT COUNT(*)
            FROM events
            WHERE type_id = ?
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, typeId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                count = rs.getInt(1);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return count;
    }
    @Override
    public double getTotalIncomeByType(int typeId) {

        double total = 0;

        String sql = """
            SELECT IFNULL(SUM(amount_paid),0)
            FROM events
            WHERE type_id = ?
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, typeId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                total = rs.getDouble(1);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return total;
    }

    @Override
    public List<Event> getWeeklyEvents() {
        return new ArrayList<>();
    }

    @Override
    public List<Event> getMonthlyEvents() {
        return new ArrayList<>();
    }
    
    

    @Override
    public List<Event> getFridayEvents() {
        return new ArrayList<>();
    }
    @Override
    public int getPendingPaymentsCount(int adminId) {

        String sql = """
                SELECT COUNT(*)
                FROM events
                WHERE admin_id = ?
                AND payment_status <> 'PAID'
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
    public int getUpcomingEventsCount(int adminId) {

        String sql = """
                SELECT COUNT(*)
                FROM events
                WHERE admin_id = ?
                AND event_date > CURDATE()
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
    public int getTodayEventCount(int adminId) {

        String sql = """
                SELECT COUNT(*)
                FROM events
                WHERE admin_id = ?
                AND event_date = CURDATE()
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
    public int getTotalEvents(int adminId) {

        String sql = """
                SELECT COUNT(*)
                FROM events
                WHERE admin_id = ?
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
    public int getEventCountByType(int typeId,
                                   int adminId) {

        String query =
                "SELECT COUNT(*) " +
                "FROM events " +
                "WHERE type_id = ? " +
                "AND admin_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, typeId);
            ps.setInt(2, adminId);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    @Override
    public double getTotalIncomeByType(int typeId,
                                       int adminId) {

        String query =
                "SELECT IFNULL(SUM(total_amount), 0) " +
                "FROM events " +
                "WHERE type_id = ? " +
                "AND admin_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, typeId);
            ps.setInt(2, adminId);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                return rs.getDouble(1);

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    @Override
    public List<Event> getPendingPaymentEventsByAdmin(int adminId) {

        List<Event> events =
                new ArrayList<>();

        String query =
                "SELECT e.*, " +
                "c.customer_name, " +
                "c.phone " +
                "FROM events e " +
                "JOIN customers c " +
                "ON e.customer_id = c.customer_id " +
                "WHERE e.admin_id = ? " +
                "AND e.payment_status IN ('PENDING','PARTIAL') " +
                "ORDER BY e.event_date";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Event event =
                        new Event();

                event.setEventId(
                        rs.getInt("event_id"));

                event.setAdminId(
                        rs.getInt("admin_id"));

                event.setCustomerId(
                        rs.getInt("customer_id"));

                event.setCustomerName(
                        rs.getString("customer_name"));

                event.setPhone(
                        rs.getString("phone"));

                event.setTypeId(
                        rs.getInt("type_id"));

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

                event.setNotes(
                        rs.getString("notes"));

                events.add(event);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return events;
    }
    
    @Override
    public List<Event> getPendingPaymentEvents() {

        List<Event> events = new ArrayList<>();

        String query =
                "SELECT e.*, c.customer_name, c.phone " +
                "FROM events e " +
                "JOIN customers c " +
                "ON e.customer_id = c.customer_id " +
                "WHERE e.payment_status IN ('PENDING','PARTIAL') " +
                "ORDER BY e.event_date";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Event event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setCustomerId(rs.getInt("customer_id"));
                event.setCustomerName(
                        rs.getString("customer_name"));
                event.setPhone(
                        rs.getString("phone"));
                event.setTypeId(rs.getInt("type_id"));
                event.setEventTitle(rs.getString("event_title"));
                event.setEventDate(rs.getDate("event_date"));
                event.setEventTime(rs.getTime("event_time"));
                event.setLocation(rs.getString("location"));

                event.setTotalAmount(
                        rs.getDouble("total_amount"));

                event.setAmountPaid(
                        rs.getDouble("amount_paid"));

                event.setPaymentStatus(
                        rs.getString("payment_status"));

                event.setNotes(
                        rs.getString("notes"));

                events.add(event);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return events;
    }

    @Override
    public List<Event> getEventsByPaymentStatus(String paymentStatus) {
        return new ArrayList<>();
    }

    @Override
    public boolean updatePaymentStatus(int eventId,
                                       String paymentStatus,
                                       double amountReceived) {
        return false;
    }

   
    @Override
    public double getTodayIncome() {

        String query =
                "SELECT IFNULL(SUM(amount_paid),0) " +
                "FROM events " +
                "WHERE event_date = CURDATE()";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public double getMonthlyIncome() {

        String query =
                "SELECT IFNULL(SUM(amount_paid),0) " +
                "FROM events " +
                "WHERE MONTH(event_date)=MONTH(CURDATE()) " +
                "AND YEAR(event_date)=YEAR(CURDATE())";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public double getYearlyIncome() {

        String query =
                "SELECT IFNULL(SUM(amount_paid),0) " +
                "FROM events " +
                "WHERE YEAR(event_date)=YEAR(CURDATE())";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public double getEventIncome(int eventId) {

        String query =
                "SELECT amount_paid " +
                "FROM events " +
                "WHERE event_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, eventId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("amount_paid");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
    @Override
    public int getTotalEvents() {

        String sql = "SELECT COUNT(*) FROM events";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    @Override
    public int getUpcomingEventsCount() {

        String sql = """
                SELECT COUNT(*)
                FROM events
                WHERE event_date > CURDATE()
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    @Override
    public int getPendingPaymentsCount() {

        String sql = """
                SELECT COUNT(*)
                FROM events
                WHERE payment_status <> 'PAID'
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;
    }	
    @Override
    public List<Event> getEventsByType(int typeId) {

        List<Event> events = new ArrayList<>();

        String sql = """
            SELECT
                e.*,
                c.customer_name,
                et.type_name
            FROM events e
            JOIN customers c
                ON e.customer_id = c.customer_id
            JOIN event_types et
                ON e.type_id = et.type_id
            WHERE e.type_id = ?
            ORDER BY e.event_date DESC
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, typeId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                events.add(extractEvent(rs));

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return events;
    }


    @Override
    public List<Event> getPendingPaymentEvents(int adminId) {

        List<Event> events = new ArrayList<>();

        String query =
                "SELECT e.*, c.customer_name, c.phone " +
                "FROM events e " +
                "JOIN customers c " +
                "ON e.customer_id = c.customer_id " +
                "WHERE e.admin_id = ? " +
                "AND (e.payment_status = 'PENDING' " +
                "OR e.payment_status = 'PARTIAL') " +
                "ORDER BY e.event_date ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Event event = new Event();

                event.setEventId(
                        rs.getInt("event_id"));

                event.setAdminId(
                        rs.getInt("admin_id"));

                event.setCustomerId(
                        rs.getInt("customer_id"));

                event.setCustomerName(
                        rs.getString("customer_name"));

                event.setPhone(
                        rs.getString("phone"));

                event.setTypeId(
                        rs.getInt("type_id"));

                event.setEventTitle(
                        rs.getString("event_title"));

                event.setEventDate(
                        rs.getDate("event_date"));

                event.setEventTime(
                        rs.getTime("event_time"));

                event.setLocation(
                        rs.getString("location"));

                event.setRecurringType(
                        rs.getString("recurring_type"));

                event.setRecurringDay(
                        rs.getString("recurring_day"));

                event.setRecurringEndDate(
                        rs.getDate("recurring_end_date"));

                event.setTotalAmount(
                        rs.getDouble("total_amount"));

                event.setAmountPaid(
                        rs.getDouble("amount_paid"));

                event.setPaymentStatus(
                        rs.getString("payment_status"));

                event.setNotes(
                        rs.getString("notes"));

                event.setCreatedAt(
                        rs.getTimestamp("created_at"));

                events.add(event);
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return events;
    }


    @Override
    public double getMonthlyIncome(int adminId) {

        String query =
                "SELECT IFNULL(SUM(amount_paid), 0) " +
                "FROM events " +
                "WHERE admin_id = ? " +
                "AND MONTH(event_date) = MONTH(CURDATE()) " +
                "AND YEAR(event_date) = YEAR(CURDATE())";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    @Override
    public double getPendingIncome(int adminId) {

        String query =
                "SELECT IFNULL(SUM(total_amount - amount_paid), 0) " +
                "FROM events " +
                "WHERE admin_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    
    
    @Override
    public List<Event> getEventsByMonth(int year, int month, int adminId) {

        List<Event> list = new ArrayList<>();

        String query =
                "SELECT * FROM events " +
                "WHERE admin_id = ? " +
                "AND YEAR(event_date) = ? " +
                "AND MONTH(event_date) = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, adminId);
            ps.setInt(2, year);
            ps.setInt(3, month);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Event event = new Event();

                event.setEventId(rs.getInt("event_id"));
                event.setEventTitle(rs.getString("event_title")); // ✅ correct column
                event.setEventDate(rs.getDate("event_date"));

                list.add(event);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    
    @Override
    public int getEventCountByDate(Date date, int adminId) {

        int count = 0;

        String sql =
            "SELECT COUNT(*) FROM events " +
            "WHERE event_date = ? AND admin_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, date);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
}