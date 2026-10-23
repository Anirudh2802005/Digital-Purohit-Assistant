package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;
import com.digitalpurohit.dao.EventSamagriDAO;
import com.digitalpurohit.model.Samagri;
import com.digitalpurohit.util.DBConnection;

public class EventSamagriDAOImpl implements EventSamagriDAO {

    @Override
    public boolean copySamagriToEvent(int eventId, int typeId) {

        String sql = """
            INSERT INTO event_samagri(event_id,samagri_id,samagri_name)
            SELECT ?, s.samagri_id, s.samagri_name
            FROM event_type_samagri ets
            JOIN samagri s
            ON ets.samagri_id=s.samagri_id
            WHERE ets.type_id=?
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, eventId);
            ps.setInt(2, typeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<Samagri> getEventSamagri(int eventId) {

        List<Samagri> list = new ArrayList<>();

        String sql = """
            SELECT samagri_id,
                   samagri_name,
                   is_completed
            FROM event_samagri
            WHERE event_id=?
            ORDER BY samagri_name
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, eventId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Samagri s = new Samagri();

                s.setSamagriId(rs.getInt("samagri_id"));
                s.setSamagriName(rs.getString("samagri_name"));
                s.setCompleted(rs.getBoolean("is_completed"));

                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    @Override
    public boolean resetChecklist(int eventId) {

        String sql =
                "UPDATE event_samagri SET is_completed = 0 WHERE event_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, eventId);

            return ps.executeUpdate() >= 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateChecklist(int eventId,
                                   int samagriId,
                                   boolean completed) {

        String sql =
                "UPDATE event_samagri SET is_completed=? WHERE event_id=? AND samagri_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setBoolean(1, completed);
            ps.setInt(2, eventId);
            ps.setInt(3, samagriId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateSamagriStatus(int eventId,
                                       int samagriId,
                                       boolean completed) {

        return updateChecklist(eventId, samagriId, completed);
    }

    @Override
    public boolean addEventSamagri(int eventId,
                                   int samagriId,
                                   String samagriName) {

        String sql =
                "INSERT INTO event_samagri(event_id,samagri_id,samagri_name,is_completed) VALUES(?,?,?,0)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, eventId);
            ps.setInt(2, samagriId);
            ps.setString(3, samagriName);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    @Override
    public boolean addExtraSamagri(int eventId,
                                   String samagriName) {

        Connection con = null;

        try {

            con = DBConnection.getConnection();

            con.setAutoCommit(false);

            int samagriId = -1;

            // Check whether samagri already exists

            String checkSql =
                    "SELECT samagri_id FROM samagri WHERE samagri_name=?";

            try (PreparedStatement ps = con.prepareStatement(checkSql)) {

                ps.setString(1, samagriName);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {

                    samagriId = rs.getInt("samagri_id");

                }

            }

            // If not found, insert into samagri table

            if (samagriId == -1) {

                String insertSamagri =
                        "INSERT INTO samagri(samagri_name) VALUES(?)";

                try (PreparedStatement ps =
                        con.prepareStatement(insertSamagri,
                        PreparedStatement.RETURN_GENERATED_KEYS)) {

                    ps.setString(1, samagriName);

                    ps.executeUpdate();

                    ResultSet rs = ps.getGeneratedKeys();

                    if (rs.next()) {

                        samagriId = rs.getInt(1);

                    }

                }

            }

            // Insert into event_samagri

            String insertEventSamagri =
                    "INSERT INTO event_samagri(event_id,samagri_id,samagri_name,is_completed) VALUES(?,?,?,0)";

            try (PreparedStatement ps =
                    con.prepareStatement(insertEventSamagri)) {

                ps.setInt(1, eventId);
                ps.setInt(2, samagriId);
                ps.setString(3, samagriName);

                ps.executeUpdate();

            }

            con.commit();

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            try {

                if (con != null) {

                    con.rollback();

                }

            } catch (Exception ex) {

                ex.printStackTrace();

            }

        } finally {

            try {

                if (con != null) {

                    con.setAutoCommit(true);
                    con.close();

                }

            } catch (Exception e) {

                e.printStackTrace();

            }

        }

        return false;
    }
}