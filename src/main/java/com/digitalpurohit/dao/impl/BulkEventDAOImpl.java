package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.BulkEventDAO;
import com.digitalpurohit.model.BulkEvent;
import com.digitalpurohit.model.BulkEventIncomeReport;
import com.digitalpurohit.util.DBConnection;
import java.sql.ResultSet;
public class BulkEventDAOImpl implements BulkEventDAO {

	
	@Override
	public double getTotalBulkIncome(int adminId) {

	    String query =
	            "SELECT IFNULL(SUM(bec.amount_paid), 0) " +
	            "FROM bulk_event_customers bec " +
	            "JOIN bulk_events be " +
	            "ON bec.bulk_event_id = be.yatra_id " +
	            "WHERE be.admin_id = ?";

	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement ps = connection.prepareStatement(query)) {

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
	public boolean saveBulkEvent(BulkEvent bulkEvent) {

		String query =
			    "INSERT INTO bulk_events(" +
			    "admin_id," +
			    "bulk_event_name," +
			    "start_date," +
			    "end_date," +
			    "location," +
			    "notes" +
			    ") VALUES (?, ?, ?, ?, ?, ?)";
	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement ps = connection.prepareStatement(
	                 query,
	                 PreparedStatement.RETURN_GENERATED_KEYS)) {

	    	ps.setInt(1, bulkEvent.getAdminId());
	    	ps.setString(2, bulkEvent.getBulkEventName());
	    	ps.setDate(3, bulkEvent.getStartDate());
	    	ps.setDate(4, bulkEvent.getEndDate());
	    	ps.setString(5, bulkEvent.getLocation());
	    	ps.setString(6, bulkEvent.getNotes());

	        int rows = ps.executeUpdate();

	        if (rows > 0) {

	            ResultSet rs = ps.getGeneratedKeys();

	            if (rs.next()) {

	                bulkEvent.setYatraId(rs.getInt(1));

	            }

	            return true;
	        }

	    } catch (SQLException e) {

	        e.printStackTrace();

	    }

	    return false;
	}

   
    
   
    @Override
    public int getBulkEventCount(int adminId) {

        String query =
                "SELECT COUNT(*) " +
                "FROM bulk_events " +
                "WHERE admin_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

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
    public int getTodayBulkEventCount(int adminId) {

        String query =
                "SELECT COUNT(*) " +
                "FROM bulk_events " +
                "WHERE admin_id = ? " +
                "AND CURDATE() BETWEEN start_date AND end_date";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

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
    public double getMonthlyBulkIncome(int adminId) {

        String query =
                "SELECT IFNULL(SUM(bec.amount_paid),0) " +
                "FROM bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE be.admin_id = ? " +
                "AND MONTH(be.created_at)=MONTH(CURDATE()) " +
                "AND YEAR(be.created_at)=YEAR(CURDATE())";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

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
    public BulkEvent getBulkEventById(int bulkEventId,
                                      int adminId) {

        String query =
                "SELECT * " +
                "FROM bulk_events " +
                "WHERE yatra_id = ? " +
                "AND admin_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                BulkEvent event =
                        new BulkEvent();

                event.setYatraId(
                        rs.getInt("yatra_id"));

                event.setAdminId(
                        rs.getInt("admin_id"));

                event.setBulkEventName(
                        rs.getString("bulk_event_name"));

                event.setStartDate(
                        rs.getDate("start_date"));

                event.setEndDate(
                        rs.getDate("end_date"));

                event.setLocation(
                        rs.getString("location"));

                event.setNotes(
                        rs.getString("notes"));

                event.setCreatedAt(
                        rs.getTimestamp("created_at"));

                return event;
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return null;
    }
    
    
    
    @Override
    public List<BulkEvent> getAllBulkEvents(int adminId) {

        List<BulkEvent> bulkEvents =
                new ArrayList<>();

        String query =
                "SELECT * " +
                "FROM bulk_events " +
                "WHERE admin_id = ? " +
                "ORDER BY start_date DESC";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                BulkEvent event =
                        new BulkEvent();

                event.setYatraId(
                        rs.getInt("yatra_id"));

                event.setAdminId(
                        rs.getInt("admin_id"));

                event.setBulkEventName(
                        rs.getString("bulk_event_name"));

                event.setStartDate(
                        rs.getDate("start_date"));

                event.setEndDate(
                        rs.getDate("end_date"));

                event.setLocation(
                        rs.getString("location"));

                event.setNotes(
                        rs.getString("notes"));

                event.setCreatedAt(
                        rs.getTimestamp("created_at"));

                bulkEvents.add(event);
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return bulkEvents;
    }
    
    @Override
    public boolean updateBulkEvent(BulkEvent bulkEvent,
                                   int adminId) {

        String query =
                "UPDATE bulk_events SET " +
                "bulk_event_name=?, " +
                "start_date=?, " +
                "end_date=?, " +
                "location=?, " +
                "notes=? " +
                "WHERE yatra_id=? " +
                "AND admin_id=?";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setString(1, bulkEvent.getBulkEventName());
            ps.setDate(2, bulkEvent.getStartDate());
            ps.setDate(3, bulkEvent.getEndDate());
            ps.setString(4, bulkEvent.getLocation());
            ps.setString(5, bulkEvent.getNotes());
            ps.setInt(6, bulkEvent.getYatraId());
            ps.setInt(7, adminId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return false;
    }
    
    @Override
    public boolean deleteBulkEvent(int bulkEventId,
                                   int adminId) {

        String query =
                "DELETE FROM bulk_events " +
                "WHERE yatra_id = ? " +
                "AND admin_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, adminId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return false;
    }
  
    private BulkEvent extractBulkEvent(ResultSet rs) throws SQLException {

        BulkEvent event = new BulkEvent();

        event.setYatraId(rs.getInt("yatra_id"));
        event.setBulkEventName(rs.getString("bulk_event_name"));
        event.setStartDate(rs.getDate("start_date"));
        event.setEndDate(rs.getDate("end_date"));
        event.setLocation(rs.getString("location"));
        event.setNotes(rs.getString("notes"));
        event.setCreatedAt(rs.getTimestamp("created_at"));

        return event;
    }




	




    @Override
    public double getTotalPendingAmount(int adminId) {

        String query =
                "SELECT IFNULL(SUM(bec.total_amount - bec.amount_paid), 0) " +
                "FROM bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE be.admin_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

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
    public int getUpcomingBulkEventCount(int adminId) {

        String query =
                "SELECT COUNT(*) " +
                "FROM bulk_events " +
                "WHERE admin_id = ? " +
                "AND start_date > CURDATE()";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

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
    public String getMostPopularBulkEvent(int adminId) {

        String query =
                "SELECT be.bulk_event_name, COUNT(bec.id) AS total " +
                "FROM bulk_events be " +
                "JOIN bulk_event_customers bec " +
                "ON be.yatra_id = bec.bulk_event_id " +
                "WHERE be.admin_id = ? " +
                "GROUP BY be.yatra_id " +
                "ORDER BY total DESC " +
                "LIMIT 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("bulk_event_name");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "N/A";
    }



   



    @Override
    public List<BulkEvent> getUpcomingBulkEvents(int adminId, int limit) {

        List<BulkEvent> list = new ArrayList<>();

        String query =
                "SELECT * FROM bulk_events " +
                "WHERE admin_id = ? " +
                "AND start_date > CURDATE() " +
                "ORDER BY start_date ASC " +
                "LIMIT ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, adminId);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BulkEvent event = new BulkEvent();

                event.setYatraId(rs.getInt("yatra_id"));
                event.setAdminId(rs.getInt("admin_id"));
                event.setBulkEventName(rs.getString("bulk_event_name"));
                event.setStartDate(rs.getDate("start_date"));
                event.setEndDate(rs.getDate("end_date"));
                event.setLocation(rs.getString("location"));
                event.setNotes(rs.getString("notes"));
                event.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(event);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
  
    @Override
    public List<BulkEvent> getRecentBulkEvents(int adminId, int limit) {

        List<BulkEvent> list = new ArrayList<>();

        String query =
                "SELECT * FROM bulk_events " +
                "WHERE admin_id = ? " +
                "ORDER BY created_at DESC " +
                "LIMIT ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, adminId);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BulkEvent event = new BulkEvent();

                event.setYatraId(rs.getInt("yatra_id"));
                event.setAdminId(rs.getInt("admin_id"));
                event.setBulkEventName(rs.getString("bulk_event_name"));
                event.setStartDate(rs.getDate("start_date"));
                event.setEndDate(rs.getDate("end_date"));
                event.setLocation(rs.getString("location"));
                event.setNotes(rs.getString("notes"));
                event.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(event);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    @Override
    public List<BulkEventIncomeReport> getBulkEventIncomeReport(
            int adminId,
            Date fromDate,
            Date toDate) {

        List<BulkEventIncomeReport> list = new ArrayList<>();

        String query =
                "SELECT be.yatra_id, be.bulk_event_name, " +
                "COUNT(bec.id) AS total_customers, " +
                "IFNULL(SUM(bec.total_amount),0) AS total_amount, " +
                "IFNULL(SUM(bec.amount_paid),0) AS amount_paid, " +
                "IFNULL(SUM(bec.total_amount - bec.amount_paid),0) AS pending " +
                "FROM bulk_events be " +
                "LEFT JOIN bulk_event_customers bec " +
                "ON be.yatra_id = bec.bulk_event_id " +
                "WHERE be.admin_id = ? " +
                "AND be.start_date BETWEEN ? AND ? " +
                "GROUP BY be.yatra_id " +
                "ORDER BY be.start_date DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, adminId);
            ps.setDate(2, fromDate);
            ps.setDate(3, toDate);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BulkEventIncomeReport report =
                        new BulkEventIncomeReport();

                report.setBulkEventId(rs.getInt("yatra_id"));
                report.setBulkEventName(rs.getString("bulk_event_name"));
                report.setTotalFamilies(rs.getInt("total_customers"));
                report.setReceivedAmount(rs.getDouble("amount_paid"));
                report.setTotalAmount(rs.getDouble("total_amount"));
              
                report.setPendingAmount(rs.getDouble("pending"));

                list.add(report);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}