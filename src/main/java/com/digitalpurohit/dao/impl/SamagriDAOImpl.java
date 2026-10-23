package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.SamagriDAO;
import com.digitalpurohit.model.Samagri;
import com.digitalpurohit.util.DBConnection;

public class SamagriDAOImpl implements SamagriDAO {

	
	@Override
	public int getSamagriCount(int adminId) {

	    String sql = """
	            SELECT COUNT(*)
	            FROM samagri
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
	public int getFrequentlyUsedSamagriCount(int adminId) {

	    String sql = """
	            SELECT COUNT(DISTINCT ets.samagri_id)
	            FROM event_type_samagri ets
	            JOIN samagri s
	            ON ets.samagri_id = s.samagri_id
	            WHERE s.admin_id = ?
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
	public int getUnusedSamagriCount(int adminId) {

	    String sql = """
	            SELECT COUNT(*)
	            FROM samagri s
	            WHERE s.admin_id = ?
	            AND s.samagri_id NOT IN (
	                SELECT samagri_id
	                FROM event_type_samagri
	            )
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
	
	public List<Samagri> getAvailableSamagri(int typeId, int adminId) {

	    List<Samagri> list = new ArrayList<>();

	    String sql = "SELECT * FROM samagri " +
	                 "WHERE admin_id = ? " +
	                 "AND samagri_id NOT IN (" +
	                 "SELECT samagri_id FROM event_type_samagri WHERE type_id = ?" +
	                 ") ORDER BY samagri_name";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, adminId);   // ✅ VERY IMPORTANT
	        ps.setInt(2, typeId);

	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {

	            Samagri s = new Samagri();

	            s.setSamagriId(rs.getInt("samagri_id"));
	            s.setSamagriName(rs.getString("samagri_name"));
	            s.setDescription(rs.getString("description"));

	            list.add(s);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	public List<Samagri> getAssignedSamagri(int typeId, int adminId) {

	    List<Samagri> list = new ArrayList<>();

	    String sql = "SELECT s.* FROM samagri s " +
	                 "JOIN event_type_samagri ets " +
	                 "ON s.samagri_id = ets.samagri_id " +
	                 "WHERE ets.type_id = ? AND s.admin_id = ?";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, typeId);
	        ps.setInt(2, adminId);

	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {

	            Samagri s = new Samagri();

	            s.setSamagriId(rs.getInt("samagri_id"));
	            s.setSamagriName(rs.getString("samagri_name"));
	            s.setDescription(rs.getString("description"));

	            list.add(s);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	@Override
	public int saveSamagri(Samagri samagri) {

	    String query =
	            "INSERT INTO samagri(admin_id, samagri_name, description) VALUES(?, ?, ?)";

	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement ps = connection.prepareStatement(
	                 query,
	                 PreparedStatement.RETURN_GENERATED_KEYS)) {

	        ps.setInt(1, samagri.getAdminId());
	        ps.setString(2, samagri.getSamagriName());
	        ps.setString(3, samagri.getDescription());

	        int rows = ps.executeUpdate();

	        if (rows > 0) {

	            ResultSet rs = ps.getGeneratedKeys();

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
	public List<Samagri> getAllSamagri(int adminId) {

	    List<Samagri> samagriList =
	            new ArrayList<>();

	    String query =
	            """
	            SELECT *
	            FROM samagri
	            WHERE admin_id = ?
	            ORDER BY samagri_name
	            """;

	    try (
	            Connection connection =
	                    DBConnection.getConnection();

	            PreparedStatement ps =
	                    connection.prepareStatement(query)) {

	        ps.setInt(1, adminId);

	        ResultSet rs =
	                ps.executeQuery();

	        while (rs.next()) {

	            Samagri samagri =
	                    new Samagri();

	            samagri.setSamagriId(
	                    rs.getInt("samagri_id"));

	            samagri.setAdminId(
	                    rs.getInt("admin_id"));

	            samagri.setSamagriName(
	                    rs.getString("samagri_name"));

	            samagri.setDescription(
	                    rs.getString("description"));

	            samagri.setCreatedAt(
	                    rs.getTimestamp("created_at"));

	            samagriList.add(samagri);
	        }

	    } catch (SQLException e) {

	        e.printStackTrace();

	    }

	    return samagriList;
	}
	

    @Override
    public boolean updateSamagri(Samagri samagri) {

        String query =
                "UPDATE samagri SET samagri_name=?, description=? WHERE samagri_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, samagri.getSamagriName());
            ps.setString(2, samagri.getDescription());
            ps.setInt(3, samagri.getSamagriId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteSamagri(int samagriId) {

        String query =
                "DELETE FROM samagri WHERE samagri_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, samagriId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Samagri getSamagriById(int samagriId) {

        String query =
                "SELECT * FROM samagri WHERE samagri_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, samagriId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Samagri samagri = new Samagri();

                samagri.setSamagriId(
                        rs.getInt("samagri_id"));

                samagri.setSamagriName(
                        rs.getString("samagri_name"));

                samagri.setDescription(
                        rs.getString("description"));

                samagri.setCreatedAt(
                        rs.getTimestamp("created_at"));

                return samagri;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Samagri> getAllSamagri() {

        List<Samagri> samagriList =
                new ArrayList<>();

        String query =
                "SELECT * FROM samagri ORDER BY samagri_name";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Samagri samagri = new Samagri();

                samagri.setSamagriId(
                        rs.getInt("samagri_id"));

                samagri.setSamagriName(
                        rs.getString("samagri_name"));

                samagri.setDescription(
                        rs.getString("description"));

                samagri.setCreatedAt(
                        rs.getTimestamp("created_at"));

                samagriList.add(samagri);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return samagriList;
    }

    @Override
    public List<Samagri> searchSamagri(String keyword) {

        List<Samagri> samagriList =
                new ArrayList<>();

        String query =
                "SELECT * FROM samagri " +
                "WHERE samagri_name LIKE ? " +
                "OR description LIKE ? " +
                "ORDER BY samagri_name";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Samagri samagri = new Samagri();

                samagri.setSamagriId(
                        rs.getInt("samagri_id"));

                samagri.setSamagriName(
                        rs.getString("samagri_name"));

                samagri.setDescription(
                        rs.getString("description"));

                samagri.setCreatedAt(
                        rs.getTimestamp("created_at"));

                samagriList.add(samagri);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return samagriList;
    }

    @Override
    public List<Samagri> searchSamagri(String keyword, int adminId) {

        List<Samagri> samagriList = new ArrayList<>();

        String query =
                """
                SELECT *
                FROM samagri
                WHERE admin_id = ?
                AND (
                    samagri_name LIKE ?
                    OR description LIKE ?
                )
                ORDER BY samagri_name
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, adminId);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Samagri samagri = new Samagri();

                samagri.setSamagriId(
                        rs.getInt("samagri_id"));

                samagri.setAdminId(
                        rs.getInt("admin_id"));

                samagri.setSamagriName(
                        rs.getString("samagri_name"));

                samagri.setDescription(
                        rs.getString("description"));

                samagri.setCreatedAt(
                        rs.getTimestamp("created_at"));

                samagriList.add(samagri);
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return samagriList;
    }
    @Override
    public Samagri getSamagriById(int samagriId,
                                  int adminId) {

        String query =
                """
                SELECT *
                FROM samagri
                WHERE samagri_id = ?
                AND admin_id = ?
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, samagriId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Samagri samagri = new Samagri();

                samagri.setSamagriId(
                        rs.getInt("samagri_id"));

                samagri.setAdminId(
                        rs.getInt("admin_id"));

                samagri.setSamagriName(
                        rs.getString("samagri_name"));

                samagri.setDescription(
                        rs.getString("description"));

                samagri.setCreatedAt(
                        rs.getTimestamp("created_at"));

                return samagri;
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return null;
    }

    @Override
    public boolean updateSamagri(Samagri samagri,
                                 int adminId) {

        String query =
                """
                UPDATE samagri
                SET
                    samagri_name = ?,
                    description = ?
                WHERE samagri_id = ?
                AND admin_id = ?
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, samagri.getSamagriName());
            ps.setString(2, samagri.getDescription());
            ps.setInt(3, samagri.getSamagriId());
            ps.setInt(4, adminId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return false;
    }
    @Override
    public boolean deleteSamagri(int samagriId,
                                 int adminId) {

        String query =
                """
                DELETE
                FROM samagri
                WHERE samagri_id = ?
                AND admin_id = ?
                """;

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, samagriId);
            ps.setInt(2, adminId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return false;
    }
}