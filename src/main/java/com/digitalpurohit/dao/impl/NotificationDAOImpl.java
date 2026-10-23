package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.NotificationDAO;
import com.digitalpurohit.model.Notification;
import com.digitalpurohit.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
public class NotificationDAOImpl implements NotificationDAO {

    // =========================================================
    // CREATE NOTIFICATION
    // =========================================================

    private static final String INSERT_NOTIFICATION =
            """
            INSERT INTO notifications
            (
                title,
                message,
                module,
                action,
                reference_id,
                redirect_url,
                is_read,
                admin_id
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """;

   
    // =========================================================
    // NORMAL NOTIFICATIONS
    // =========================================================

    private static final String GET_ALL =
            """
            SELECT *
            FROM notifications
            WHERE admin_id=?
            ORDER BY created_at DESC
            """;


    private static final String GET_UNREAD =
            """
            SELECT *
            FROM notifications
            WHERE admin_id=?
            AND is_read=FALSE
            AND action <> 'REMINDER'
            ORDER BY created_at DESC
            """;


    private static final String GET_UNREAD_COUNT =
            """
            SELECT COUNT(*)
            FROM notifications
            WHERE admin_id=?
            AND is_read=FALSE
            AND action <> 'REMINDER'
            """;


    // =========================================================
    // GET NOTIFICATION BY ID
    // =========================================================

    private static final String GET_BY_ID =
            """
            SELECT *
            FROM notifications
            WHERE notification_id=?
            AND admin_id=?
            """;


    // =========================================================
    // MARK READ
    // =========================================================

    private static final String MARK_AS_READ =
            """
            UPDATE notifications
            SET is_read=TRUE
            WHERE notification_id=?
            AND admin_id=?
            """;


    private static final String MARK_ALL_READ =
            """
            UPDATE notifications
            SET is_read=TRUE
            WHERE admin_id=?
            AND is_read=FALSE
            AND action <> 'REMINDER'
            """;


    // =========================================================
    // DELETE
    // =========================================================

    private static final String DELETE_NOTIFICATION =
            """
            DELETE FROM notifications
            WHERE notification_id=?
            AND admin_id=?
            """;


    private static final String DELETE_OLD =
            """
            DELETE FROM notifications
            WHERE admin_id=?
            AND created_at <
                DATE_SUB(NOW(), INTERVAL ? DAY)
            """;


    // =========================================================
    // REMINDER CREATED TODAY
    // =========================================================

    private static final String REMINDER_ALREADY_CREATED =
            """
            SELECT COUNT(*)
            FROM notifications
            WHERE admin_id=?
            AND reference_id=?
            AND action='REMINDER'
            AND DATE(created_at)=CURDATE()
            """;


    // =========================================================
    // REMINDER EXISTS FOR DATE
    // =========================================================

    private static final String REMINDER_EXISTS =
            """
            SELECT COUNT(*)
            FROM notifications
            WHERE admin_id=?
            AND reference_id=?
            AND action='REMINDER'
            AND DATE(created_at)=?
            """;


    // =========================================================
    // NEXT UNREAD REMINDER
    //
    // IMPORTANT:
    // Only REMINDER notifications.
    // Only current admin.
    // Oldest reminder first.
    // =========================================================
    private static final String GET_NEXT_UNREAD_REMINDER =
            """
            SELECT *
            FROM notifications
            WHERE admin_id=?
            AND action='REMINDER'
            AND is_read=FALSE
            AND DATE(created_at)=CURDATE()
            ORDER BY notification_id ASC
            LIMIT 1
            """;


    // =========================================================
    // EXTRACT NOTIFICATION
    // =========================================================

    private Notification extractNotification(
            ResultSet rs) throws Exception {

        Notification notification =
                new Notification();


        notification.setNotificationId(
                rs.getInt("notification_id"));


        notification.setAdminId(
                rs.getInt("admin_id"));


        notification.setTitle(
                rs.getString("title"));


        notification.setMessage(
                rs.getString("message"));


        notification.setModule(
                rs.getString("module"));


        notification.setAction(
                rs.getString("action"));


        Object referenceId =
                rs.getObject("reference_id");


        if (referenceId != null) {

            notification.setReferenceId(
                    ((Number) referenceId)
                            .intValue());

        } else {

            notification.setReferenceId(
                    null);
        }


        notification.setRedirectUrl(
                rs.getString("redirect_url"));


        notification.setRead(
                rs.getBoolean("is_read"));


        notification.setCreatedAt(
                rs.getTimestamp("created_at"));


        return notification;
    }


    // =========================================================
    // ADD NOTIFICATION
    // =========================================================

    @Override
    public boolean addNotification(
            Notification notification) {

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(
                                INSERT_NOTIFICATION)
        ) {


            ps.setString(
                    1,
                    notification.getTitle());


            ps.setString(
                    2,
                    notification.getMessage());


            ps.setString(
                    3,
                    notification.getModule());


            ps.setString(
                    4,
                    notification.getAction());


            if (notification.getReferenceId() != null) {

                ps.setInt(
                        5,
                        notification.getReferenceId());

            } else {

                ps.setNull(
                        5,
                        java.sql.Types.INTEGER);
            }


            ps.setString(
                    6,
                    notification.getRedirectUrl());


            ps.setBoolean(
                    7,
                    notification.isRead());


            ps.setInt(
                    8,
                    notification.getAdminId());


            return ps.executeUpdate() > 0;


        } catch (Exception e) {

            e.printStackTrace();
        }


        return false;
    }


    // =========================================================
    // GET ALL NOTIFICATIONS
    //
    // Normal notification center can still show reminders
    // if you want them there.
    // =========================================================

    @Override
    public List<Notification> getAllNotifications(
            int adminId) {

        List<Notification> notifications =
                new ArrayList<>();


        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(GET_ALL)
        ) {


            ps.setInt(
                    1,
                    adminId);


            ResultSet rs =
                    ps.executeQuery();


            while (rs.next()) {

                notifications.add(
                        extractNotification(rs));
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return notifications;
    }


    // =========================================================
    // GET UNREAD NORMAL NOTIFICATIONS
    //
    // IMPORTANT:
    // REMINDER notifications are excluded.
    // =========================================================

    @Override
    public List<Notification> getUnreadNotifications(
            int adminId) {

        List<Notification> notifications =
                new ArrayList<>();


        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(GET_UNREAD)
        ) {


            ps.setInt(
                    1,
                    adminId);


            ResultSet rs =
                    ps.executeQuery();


            while (rs.next()) {

                notifications.add(
                        extractNotification(rs));
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return notifications;
    }


    // =========================================================
    // UNREAD NORMAL NOTIFICATION COUNT
    // =========================================================

    @Override
    public int getUnreadCount(
            int adminId) {

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(
                                GET_UNREAD_COUNT)
        ) {


            ps.setInt(
                    1,
                    adminId);


            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                return rs.getInt(1);
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return 0;
    }


    // =========================================================
    // GET NOTIFICATION BY ID
    // =========================================================

    @Override
    public Notification getNotificationById(
            int notificationId,
            int adminId) {

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(
                                GET_BY_ID)
        ) {


            ps.setInt(
                    1,
                    notificationId);


            ps.setInt(
                    2,
                    adminId);


            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                return extractNotification(rs);
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return null;
    }


    // =========================================================
    // MARK ONE AS READ
    //
    // Used by reminder Dismiss button too.
    // =========================================================

    @Override
    public boolean markAsRead(
            int notificationId,
            int adminId) {

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(
                                MARK_AS_READ)
        ) {


            ps.setInt(
                    1,
                    notificationId);


            ps.setInt(
                    2,
                    adminId);


            return ps.executeUpdate() > 0;


        } catch (Exception e) {

            e.printStackTrace();
        }


        return false;
    }


    // =========================================================
    // MARK ALL NORMAL NOTIFICATIONS READ
    //
    // Does NOT mark reminders as read.
    // =========================================================

    @Override
    public boolean markAllAsRead(
            int adminId) {

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(
                                MARK_ALL_READ)
        ) {


            ps.setInt(
                    1,
                    adminId);


            return ps.executeUpdate() >= 0;


        } catch (Exception e) {

            e.printStackTrace();
        }


        return false;
    }


    // =========================================================
    // REMINDER ALREADY CREATED TODAY
    //
    // Prevents:
    //
    // 6:00 PM
    //    ↓
    // Reminder created
    //    ↓
    // 6:10 PM
    //    ↓
    // Same reminder created again ❌
    //
    // =========================================================

    @Override
    public boolean reminderAlreadyCreatedToday(
            int reminderId,
            int adminId) {

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(
                                REMINDER_ALREADY_CREATED)
        ) {


            ps.setInt(
                    1,
                    adminId);


            ps.setInt(
                    2,
                    reminderId);


            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                return rs.getInt(1) > 0;
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return false;
    }


    // =========================================================
    // GET NEXT UNREAD REMINDER
    //
    // THIS IS THE IMPORTANT METHOD
    //
    // Example:
    //
    // Reminder 1 -> unread
    // Reminder 2 -> unread
    // Reminder 3 -> unread
    //
    // Returns Reminder 1.
    //
    // After Dismiss:
    //
    // Reminder 1 -> READ
    // Reminder 2 -> unread
    // Reminder 3 -> unread
    //
    // Next request returns Reminder 2.
    // =========================================================

    @Override
    public Notification getNextUnreadReminder(
            int adminId) {

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(
                                GET_NEXT_UNREAD_REMINDER)
        ) {


            ps.setInt(
                    1,
                    adminId);


            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                return extractNotification(rs);
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return null;
    }


    // =========================================================
    // REMINDER EXISTS
    // =========================================================

    @Override
    public boolean reminderExists(
            int reminderId,
            Date date,
            int adminId) {

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(
                                REMINDER_EXISTS)
        ) {


            ps.setInt(
                    1,
                    adminId);


            ps.setInt(
                    2,
                    reminderId);


            ps.setDate(
                    3,
                    date);


            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                return rs.getInt(1) > 0;
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return false;
    }


    // =========================================================
    // DELETE ONE NOTIFICATION
    // =========================================================

 

    // =========================================================
    // DELETE OLD NOTIFICATIONS
    // =========================================================

    @Override
    public boolean deleteOldNotifications(
            int adminId,
            int days) {

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(
                                DELETE_OLD)
        ) {


            ps.setInt(
                    1,
                    adminId);


            ps.setInt(
                    2,
                    days);


            return ps.executeUpdate() >= 0;


        } catch (Exception e) {

            e.printStackTrace();
        }


        return false;
    }


    // =========================================================
    // DELETE ALL
    //
    // NOTE:
    // This is kept because your existing DAO has this method.
    // =========================================================

    


    // =========================================================
    // LEGACY METHOD
    //
    // Keep only because your current NotificationDAO contains it.
    //
    // Do NOT use this method for reminder popup.
    // =========================================================

    

    @Override
    public boolean deleteAllNotifications(int adminId) {

        String sql =
                "DELETE FROM notifications WHERE admin_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }
    @Override
    public boolean deleteNotification(
            int notificationId,
            int adminId) {

        try (
            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(
                            DELETE_NOTIFICATION)
        ) {

            ps.setInt(1, notificationId);
            ps.setInt(2, adminId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}