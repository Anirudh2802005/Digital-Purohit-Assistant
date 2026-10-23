	package com.digitalpurohit.dao.impl;
	
	import java.sql.Connection;import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
	import java.sql.PreparedStatement;
	import java.sql.ResultSet;
	import java.sql.SQLException;
	import java.util.ArrayList;
	import java.util.List;
	
	import com.digitalpurohit.dao.EventTypeDAO;
	import com.digitalpurohit.model.EventType;
	import com.digitalpurohit.util.DBConnection;
	import java.sql.Connection;
	import java.sql.PreparedStatement;
	import java.sql.ResultSet;
	import java.util.ArrayList;
	import java.util.List;

	import com.digitalpurohit.model.Samagri;
	
	public class EventTypeDAOImpl implements EventTypeDAO {
	
	    
	    @Override
	    public int saveEventType(EventType eventType) {
	    	
	    	String query =
	    		    "INSERT INTO event_types(admin_id, type_name, description, is_active) " +
	    		    "VALUES (?, ?, ?, ?)";
	        try (Connection connection = DBConnection.getConnection();
	             PreparedStatement ps =
	                     connection.prepareStatement(
	                             query,
	                             PreparedStatement.RETURN_GENERATED_KEYS)) {
	
	        	ps.setInt(1, eventType.getAdminId());
	        	ps.setString(2, eventType.getTypeName());
	        	ps.setString(3, eventType.getDescription());
	        	ps.setBoolean(4, eventType.isActive());
	
	            int rows =
	                    ps.executeUpdate();
	
	            if (rows > 0) {
	
	                ResultSet rs =
	                        ps.getGeneratedKeys();
	
	                if (rs.next()) {
	
	                    return rs.getInt(1);
	
	                }
	
	            }
	
	        } catch (SQLException e) {
	
	            e.printStackTrace();
	
	        }
	
	        return -1;
	    }
	    @Override
	    public List<EventType> getActiveEventTypes(int adminId) {

	        List<EventType> eventTypes = new ArrayList<>();

	        String sql = """
	                SELECT *
	                FROM event_types
	                WHERE admin_id = ?
	                AND is_active = true
	                ORDER BY type_name
	                """;

	        try (
	                Connection con = DBConnection.getConnection();
	                PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, adminId);

	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {

	                EventType eventType = new EventType();

	                eventType.setTypeId(
	                        rs.getInt("type_id"));

	                eventType.setAdminId(
	                        rs.getInt("admin_id"));

	                eventType.setTypeName(
	                        rs.getString("type_name"));

	                eventType.setDescription(
	                        rs.getString("description"));

	                eventType.setActive(
	                        rs.getBoolean("is_active"));

	                eventType.setCreatedAt(
	                        rs.getTimestamp("created_at"));

	                eventTypes.add(eventType);
	            }

	        } catch (Exception e) {

	            e.printStackTrace();

	        }

	        return eventTypes;
	    }
	    
	    
	    @Override
	    public boolean updateEventType(EventType eventType,
	                                   int adminId) {

	        String sql = """
	                UPDATE event_types
	                SET
	                    type_name = ?,
	                    description = ?,
	                    is_active = ?
	                WHERE type_id = ?
	                AND admin_id = ?
	                """;

	        try (
	                Connection con = DBConnection.getConnection();
	                PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setString(1, eventType.getTypeName());
	            ps.setString(2, eventType.getDescription());
	            ps.setBoolean(3, eventType.isActive());
	            ps.setInt(4, eventType.getTypeId());
	            ps.setInt(5, adminId);

	            return ps.executeUpdate() > 0;

	        } catch (Exception e) {

	            e.printStackTrace();

	        }

	        return false;
	    }
	    
	    
	    @Override
	    public boolean deleteEventType(int typeId,
	                                   int adminId) {

	        String sql = """
	                DELETE FROM event_types
	                WHERE type_id = ?
	                AND admin_id = ?
	                """;

	        try (
	                Connection con = DBConnection.getConnection();
	                PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, typeId);
	            ps.setInt(2, adminId);

	            return ps.executeUpdate() > 0;

	        } catch (Exception e) {

	            e.printStackTrace();

	        }

	        return false;
	    }
	    @Override
	    public EventType getEventTypeById(int typeId,
	                                      int adminId) {

	        String sql = """
	                SELECT *
	                FROM event_types
	                WHERE type_id = ?
	                AND admin_id = ?
	                """;

	        try (
	                Connection con = DBConnection.getConnection();
	                PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, typeId);
	            ps.setInt(2, adminId);

	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {

	                EventType eventType = new EventType();

	                eventType.setTypeId(
	                        rs.getInt("type_id"));

	                eventType.setAdminId(
	                        rs.getInt("admin_id"));

	                eventType.setTypeName(
	                        rs.getString("type_name"));

	                eventType.setDescription(
	                        rs.getString("description"));

	                eventType.setActive(
	                        rs.getBoolean("is_active"));

	                eventType.setCreatedAt(
	                        rs.getTimestamp("created_at"));

	                return eventType;
	            }

	        } catch (Exception e) {

	            e.printStackTrace();

	        }

	        return null;
	    }
	    
	    @Override
	    public List<EventType> searchEventTypes(String keyword,
	                                            int adminId) {

	        List<EventType> eventTypes = new ArrayList<>();

	        String sql = """
	                SELECT *
	                FROM event_types
	                WHERE admin_id = ?
	                AND (
	                    type_name LIKE ?
	                    OR description LIKE ?
	                )
	                ORDER BY type_name
	                """;

	        try (
	                Connection con = DBConnection.getConnection();
	                PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, adminId);

	            ps.setString(2, "%" + keyword + "%");
	            ps.setString(3, "%" + keyword + "%");

	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {

	                EventType eventType = new EventType();

	                eventType.setTypeId(
	                        rs.getInt("type_id"));

	                eventType.setAdminId(
	                        rs.getInt("admin_id"));

	                eventType.setTypeName(
	                        rs.getString("type_name"));

	                eventType.setDescription(
	                        rs.getString("description"));

	                eventType.setActive(
	                        rs.getBoolean("is_active"));

	                eventType.setCreatedAt(
	                        rs.getTimestamp("created_at"));

	                eventTypes.add(eventType);
	            }

	        } catch (Exception e) {

	            e.printStackTrace();

	        }

	        return eventTypes;
	    }
	   
	
	   
	 
	   
	    @Override
	    public int getEventTypeCount(int adminId) {

	        String sql = """
	                SELECT COUNT(*)
	                FROM event_types
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
	    public int getActiveEventTypeCount(int adminId) {

	        String sql = """
	                SELECT COUNT(*)
	                FROM event_types
	                WHERE admin_id = ?
	                AND is_active = true
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
	    public int getFrequentlyUsedCount(int adminId) {

	        String sql = """
	                SELECT COUNT(DISTINCT e.type_id)
	                FROM events e
	                INNER JOIN event_types t
	                    ON e.type_id = t.type_id
	                WHERE t.admin_id = ?
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
	    
	    
	    
	    
	  
	    public List<Samagri> getAssignedSamagri(int typeId, int adminId) {

	        List<Samagri> list = new ArrayList<>();

	        String sql =
	                "SELECT s.* " +
	                "FROM samagri s " +
	                "JOIN event_type_samagri ets " +
	                "ON s.samagri_id = ets.samagri_id " +
	                "WHERE ets.type_id=? " +
	                "ORDER BY s.samagri_name";

	        try (Connection con = DBConnection.getConnection();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, typeId);

	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {

	                Samagri samagri = new Samagri();

	                samagri.setSamagriId(rs.getInt("samagri_id"));
	                samagri.setSamagriName(rs.getString("samagri_name"));
	                samagri.setDescription(rs.getString("description"));
	                samagri.setCreatedAt(rs.getTimestamp("created_at"));

	                list.add(samagri);
	            }

	        } catch (Exception e) {

	            e.printStackTrace();

	        }

	        return list;
	    }
	    
	   
	    
	    @Override
	    public List<Samagri> getAvailableSamagri(int typeId, int adminId) {

	        List<Samagri> list = new ArrayList<>();

	        String sql =
	                "SELECT * FROM samagri " +
	                "WHERE samagri_id NOT IN (" +
	                "SELECT samagri_id FROM event_type_samagri WHERE type_id=?" +
	                ") ORDER BY samagri_name";

	        try (Connection con = DBConnection.getConnection();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, typeId);

	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {

	                Samagri samagri = new Samagri();

	                samagri.setSamagriId(rs.getInt("samagri_id"));
	                samagri.setSamagriName(rs.getString("samagri_name"));
	                samagri.setDescription(rs.getString("description"));
	                samagri.setCreatedAt(rs.getTimestamp("created_at"));

	                list.add(samagri);
	            }

	        } catch (Exception e) {

	            e.printStackTrace();

	        }

	        return list;
	    }
	    
	    
	    @Override
	    public boolean assignSamagri(int typeId, int samagriId) {

	        String sql =
	                "INSERT INTO event_type_samagri(type_id,samagri_id) VALUES(?,?)";

	        try (Connection con = DBConnection.getConnection();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, typeId);
	            ps.setInt(2, samagriId);

	            return ps.executeUpdate() > 0;

	        } catch (Exception e) {

	            e.printStackTrace();

	        }

	        return false;
	    }
	    
	    
	    @Override
	    public boolean removeAssignedSamagri(int typeId, int samagriId) {

	        String sql =
	                "DELETE FROM event_type_samagri " +
	                "WHERE type_id=? AND samagri_id=?";

	        try (Connection con = DBConnection.getConnection();
	             PreparedStatement ps = con.prepareStatement(sql)) {

	            ps.setInt(1, typeId);
	            ps.setInt(2, samagriId);

	            return ps.executeUpdate() > 0;

	        } catch (Exception e) {

	            e.printStackTrace();

	        }

	        return false;
	    }
	    @Override
	    public int getAssignedSamagriCount(int typeId) {

	        int count = 0;

	        String sql = """
	            SELECT COUNT(*)
	            FROM event_type_samagri
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
		public List<EventType> getAllEventTypes(int adminId) {

		    List<EventType> eventTypes = new ArrayList<>();

		    String sql =
		            """
		            SELECT *
		            FROM event_types
		            WHERE admin_id = ?
		            ORDER BY type_name
		            """;

		    try (
		            Connection con = DBConnection.getConnection();
		            PreparedStatement ps = con.prepareStatement(sql)) {

		        ps.setInt(1, adminId);

		        ResultSet rs = ps.executeQuery();

		        while (rs.next()) {

		            EventType eventType = new EventType();

		            eventType.setTypeId(
		                    rs.getInt("type_id"));

		            eventType.setAdminId(
		                    rs.getInt("admin_id"));

		            eventType.setTypeName(
		                    rs.getString("type_name"));

		            eventType.setDescription(
		                    rs.getString("description"));

		            eventType.setActive(
		                    rs.getBoolean("is_active"));

		            eventType.setCreatedAt(
		                    rs.getTimestamp("created_at"));

		            eventTypes.add(eventType);
		        }

		    } catch (Exception e) {

		        e.printStackTrace();

		    }

		    return eventTypes;
		}
	}