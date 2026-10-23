package com.digitalpurohit.dao.impl;
import com.digitalpurohit.model.Samagri;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.EventTypeSamagriDAO;
import com.digitalpurohit.util.DBConnection;

public class EventTypeSamagriDAOImpl
        implements EventTypeSamagriDAO {

    @Override
    public boolean saveEventTypeSamagri(
            int typeId,
            int samagriId) {

        String query =
                "INSERT INTO event_type_samagri(type_id, samagri_id) VALUES(?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, typeId);
            ps.setInt(2, samagriId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return false;
    }

    @Override
    public boolean deleteByEventType(
            int typeId) {

        String query =
                "DELETE FROM event_type_samagri WHERE type_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, typeId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return false;
    }

    @Override
    public List<Integer> getSelectedSamagriIds(
            int typeId) {

        List<Integer> list =
                new ArrayList<>();

        String query =
                "SELECT samagri_id FROM event_type_samagri WHERE type_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, typeId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                list.add(
                        rs.getInt("samagri_id"));

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return list;
    }
    
    @Override
    public List<Samagri> getSamagriByEventType(int typeId) {

        List<Samagri> samagriList = new ArrayList<>();

        String sql = """
            SELECT s.*
            FROM event_type_samagri ets
            JOIN samagri s
            ON ets.samagri_id = s.samagri_id
            WHERE ets.type_id = ?
            ORDER BY s.samagri_name
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, typeId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Samagri s = new Samagri();

                s.setSamagriId(rs.getInt("samagri_id"));
                s.setSamagriName(rs.getString("samagri_name"));
                s.setDescription(rs.getString("description"));

                if (rs.getTimestamp("created_at") != null) {
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                }

                samagriList.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return samagriList;
    }

}