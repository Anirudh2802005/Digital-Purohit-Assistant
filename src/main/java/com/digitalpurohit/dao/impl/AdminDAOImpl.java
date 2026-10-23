package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.model.Admin;
import com.digitalpurohit.util.DBConnection;

public class AdminDAOImpl implements AdminDAO {

    // =========================================================
    // VALIDATE ADMIN
    // =========================================================

    @Override
    public boolean validateAdmin(String username, String password) {

        String query =
                "SELECT * FROM admin WHERE username = ? AND password = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // USERNAME EXISTS
    // =========================================================

    @Override
    public boolean usernameExists(String username) {

        String sql =
                "SELECT admin_id FROM admin WHERE username = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // RESET PASSWORD
    // =========================================================

    @Override
    public boolean resetPassword(
            String username,
            String phone,
            String newPassword) {

        String sql =
                "UPDATE admin " +
                "SET password = ? " +
                "WHERE username = ? AND phone = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, username);
            ps.setString(3, phone);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // REGISTER ADMIN
    // =========================================================

    @Override
    public boolean registerAdmin(Admin admin) {

        String sql =
                "INSERT INTO admin " +
                "(name, phone, username, password, email) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, admin.getName());
            ps.setString(2, admin.getPhone());
            ps.setString(3, admin.getUsername());
            ps.setString(4, admin.getPassword());
            ps.setString(5, admin.getEmail());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // GET ADMIN BY ID
    // =========================================================

    @Override
    public Admin getAdminById(int adminId) {

        Admin admin = null;

        String sql =
                "SELECT * FROM admin WHERE admin_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                admin = mapAdmin(rs);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return admin;
    }


    // =========================================================
    // GET ADMIN BY USERNAME
    // =========================================================

   

    // =========================================================
    // UPDATE PASSWORD
    // =========================================================

    @Override
    public boolean updatePassword(
            int adminId,
            String newPassword) {

        String query =
                "UPDATE admin " +
                "SET password = ? " +
                "WHERE admin_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setString(1, newPassword);
            ps.setInt(2, adminId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // UPDATE PROFILE
    // =========================================================

    @Override
    public boolean updateProfile(Admin admin) {

        String query =
                "UPDATE admin " +
                "SET name = ?, " +
                "phone = ?, " +
                "email = ?, " +
                "profile_image = ? " +
                "WHERE admin_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(query)) {

            ps.setString(1, admin.getName());
            ps.setString(2, admin.getPhone());
            ps.setString(3, admin.getEmail());
            ps.setString(4, admin.getProfileImage());
            ps.setInt(5, admin.getAdminId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // GET ALL ADMINS
    // =========================================================

    @Override
    public List<Admin> getAllAdmins() {

        List<Admin> admins =
                new ArrayList<>();

        String sql =
                "SELECT * FROM admin ORDER BY admin_id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs =
                     ps.executeQuery()) {

            while (rs.next()) {

                admins.add(mapAdmin(rs));
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return admins;
    }
  
    @Override
    public Admin getAdminByGoogleId(String googleId) {

        String sql =
                "SELECT * FROM admin WHERE google_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setString(1, googleId);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                return mapAdmin(rs);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }
    @Override
    public boolean emailExists(String email) {

        String sql =
                "SELECT admin_id FROM admin WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setString(1, email);

            ResultSet rs =
                    ps.executeQuery();

            return rs.next();

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }
    
    @Override
    public boolean updateGoogleLogin(
            int adminId,
            String googleId,
            String profileImage) {

        String sql =
                "UPDATE admin " +
                "SET google_id = ?, profile_image = ? " +
                "WHERE admin_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setString(1, googleId);
            ps.setString(2, profileImage);
            ps.setInt(3, adminId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }
    
    @Override
    public Admin getAdminByEmail(String email) {

        String sql =
                "SELECT * FROM admin WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setString(1, email);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                return mapAdmin(rs);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }
    
    

    // =========================================================
    // COMMON ADMIN MAPPER
    // =========================================================

    private Admin mapAdmin(ResultSet rs)
            throws SQLException {

        Admin admin = new Admin();

        admin.setAdminId(
                rs.getInt("admin_id"));

        admin.setName(
                rs.getString("name"));

        admin.setUsername(
                rs.getString("username"));

        admin.setPassword(
                rs.getString("password"));

        admin.setPhone(
                rs.getString("phone"));

        admin.setEmail(
                rs.getString("email"));

        admin.setGoogleId(
                rs.getString("google_id"));

        admin.setProfileImage(
                rs.getString("profile_image"));

        return admin;
    }
}