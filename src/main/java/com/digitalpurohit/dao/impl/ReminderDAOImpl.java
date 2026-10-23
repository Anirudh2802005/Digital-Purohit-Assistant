package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.ReminderDAO;
import com.digitalpurohit.model.Reminder;
import com.digitalpurohit.util.DBConnection;

public class ReminderDAOImpl implements ReminderDAO {

    // =========================================================
    // SAVE REMINDER
    // =========================================================
	@Override
	public boolean createOccurrence(
	        int reminderId,
	        int adminId,
	        Date reminderDate) {

	    String sql = """
	            INSERT IGNORE INTO reminder_occurrences
	            (
	                reminder_id,
	                admin_id,
	                reminder_date
	            )
	            VALUES (?, ?, ?)
	            """;

	    try (
	            Connection con =
	                    DBConnection.getConnection();

	            PreparedStatement ps =
	                    con.prepareStatement(sql)) {

	        ps.setInt(1, reminderId);

	        ps.setInt(2, adminId);

	        ps.setDate(3, reminderDate);

	        ps.executeUpdate();

	        return true;

	    } catch (Exception e) {

	        e.printStackTrace();

	        return false;
	    }
	}
    @Override
    public boolean saveReminder(Reminder reminder) {

        String sql = """
                INSERT INTO reminder_settings
                (
                    admin_id,
                    reminder_name,
                    reminder_type,
                    enabled,
                    reminder_time,
                    frequency_days,
                    email_enabled,
                    reminder_interval
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, reminder.getAdminId());
            ps.setString(2, reminder.getReminderName());
            ps.setString(3, reminder.getReminderType());
            ps.setBoolean(4, reminder.isEnabled());
            ps.setTime(5, reminder.getReminderTime());
            ps.setInt(6, reminder.getFrequencyDays());
            ps.setBoolean(7, reminder.isEmailEnabled());
            ps.setInt(8, reminder.getReminderInterval());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // UPDATE REMINDER
    // =========================================================

    @Override
    public boolean updateReminder(
            Reminder reminder,
            int adminId) {

        String sql = """
                UPDATE reminder_settings
                SET
                    reminder_name = ?,
                    reminder_time = ?,
                    enabled = ?,
                    frequency_days = ?,
                    email_enabled = ?,
                    reminder_interval = ?
                WHERE reminder_id = ?
                  AND admin_id = ?
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setString(1, reminder.getReminderName());
            ps.setTime(2, reminder.getReminderTime());
            ps.setBoolean(3, reminder.isEnabled());
            ps.setInt(4, reminder.getFrequencyDays());
            ps.setBoolean(5, reminder.isEmailEnabled());
            ps.setInt(6, reminder.getReminderInterval());
            ps.setInt(7, reminder.getReminderId());
            ps.setInt(8, adminId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // UPDATE ENABLE / DISABLE
    // =========================================================

    @Override
    public boolean updateReminderStatus(
            int reminderId,
            boolean enabled,
            int adminId) {

        String sql = """
                UPDATE reminder_settings
                SET enabled = ?
                WHERE reminder_id = ?
                  AND admin_id = ?
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setBoolean(1, enabled);
            ps.setInt(2, reminderId);
            ps.setInt(3, adminId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // ENABLE
    // =========================================================

    @Override
    public boolean enableReminder(
            int reminderId,
            int adminId) {

        return updateReminderStatus(
                reminderId,
                true,
                adminId);
    }


    // =========================================================
    // DISABLE
    // =========================================================

    @Override
    public boolean disableReminder(
            int reminderId,
            int adminId) {

        return updateReminderStatus(
                reminderId,
                false,
                adminId);
    }


    // =========================================================
    // DELETE
    // =========================================================

    @Override
    public boolean deleteReminder(
            int reminderId,
            int adminId) {

        String sql = """
                DELETE FROM reminder_settings
                WHERE reminder_id = ?
                  AND admin_id = ?
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, reminderId);
            ps.setInt(2, adminId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // GET BY ID
    // =========================================================

    @Override
    public Reminder getReminderById(
            int reminderId,
            int adminId) {

        String sql = """
                SELECT *
                FROM reminder_settings
                WHERE reminder_id = ?
                  AND admin_id = ?
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, reminderId);
            ps.setInt(2, adminId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapReminderSettings(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    // =========================================================
    // GET ALL
    // =========================================================

    @Override
    public List<Reminder> getAllReminders(
            int adminId) {

        List<Reminder> reminders =
                new ArrayList<>();

        String sql = """
                SELECT *
                FROM reminder_settings
                WHERE admin_id = ?
                ORDER BY reminder_time ASC
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    reminders.add(
                            mapReminderSettings(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return reminders;
    }


    // =========================================================
    // GET ENABLED REMINDERS
    // =========================================================

    @Override
    public List<Reminder> getEnabledReminders(
            int adminId) {

        List<Reminder> reminders =
                new ArrayList<>();

        String sql = """
                SELECT *
                FROM reminder_settings
                WHERE admin_id = ?
                  AND enabled = TRUE
                ORDER BY reminder_time ASC
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    reminders.add(
                            mapReminderSettings(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return reminders;
    }


    // =========================================================
    // GET BY TYPE
    // =========================================================

    @Override
    public Reminder getReminderByType(
            String reminderType,
            int adminId) {

        String sql = """
                SELECT *
                FROM reminder_settings
                WHERE reminder_type = ?
                  AND admin_id = ?
                LIMIT 1
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setString(1, reminderType);
            ps.setInt(2, adminId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapReminderSettings(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    // =========================================================
    // UPDATE LAST TRIGGERED DATE
    // =========================================================

    @Override
    public boolean updateLastTriggeredDate(
            int reminderId,
            Date date,
            int adminId) {

        String sql = """
                UPDATE reminder_settings
                SET last_triggered_date = ?
                WHERE reminder_id = ?
                  AND admin_id = ?
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setDate(1, date);
            ps.setInt(2, reminderId);
            ps.setInt(3, adminId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // CREATE OCCURRENCE
    // =========================================================

  
    // =========================================================
    // GET ONE OCCURRENCE
    // =========================================================
    @Override
    public List<Reminder> getPendingPopupReminders(
            int adminId,
            Date reminderDate) {

        List<Reminder> reminders =
                new ArrayList<>();

        String sql = """
                SELECT
                    r.reminder_id,
                    r.admin_id,
                    r.reminder_name,
                    r.reminder_type,
                    r.enabled,
                    r.reminder_time,
                    r.frequency_days,
                    r.email_enabled,
                    r.created_at,
                    r.reminder_interval,
                    r.last_triggered_date,

                    o.occurrence_id,
                    o.triggered,
                    o.dismissed,
                    o.reminder_date,
                    o.created_at AS occurrence_created_at,
                    o.dismissed_at

                FROM reminder_settings r

                INNER JOIN reminder_occurrences o
                    ON r.reminder_id = o.reminder_id

                WHERE r.admin_id = ?
                  AND o.admin_id = ?
                  AND o.reminder_date = ?

                  AND r.enabled = TRUE

                  AND o.dismissed = FALSE

                  AND r.reminder_time <= CURTIME()

                ORDER BY
                    r.reminder_time ASC,
                    r.reminder_id ASC
                """;

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            ps.setInt(2, adminId);

            ps.setDate(3, reminderDate);

            ResultSet rs =
                    ps.executeQuery();


            while (rs.next()) {

                Reminder reminder =
                        mapReminder(rs);

                reminders.add(reminder);
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return reminders;
    }
    
    
    @Override
    public boolean markOccurrenceTriggered(
            int occurrenceId,
            int adminId) {

        String sql = """
                UPDATE reminder_occurrences

                SET triggered = TRUE

                WHERE occurrence_id = ?

                  AND admin_id = ?

                  AND dismissed = FALSE
                """;


        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, occurrenceId);

            ps.setInt(2, adminId);


            return ps.executeUpdate() > 0;


        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }
    @Override
    public Reminder getOccurrence(
            int reminderId,
            int adminId,
            Date reminderDate) {

        String sql = """
                SELECT
                    r.reminder_id,
                    r.admin_id,
                    r.reminder_name,
                    r.reminder_type,
                    r.enabled,
                    r.reminder_time,
                    r.frequency_days,
                    r.email_enabled,
                    r.created_at,
                    r.reminder_interval,
                    r.last_triggered_date,

                    o.occurrence_id,
                    o.reminder_date,
                    o.triggered,
                    o.dismissed,
                    o.dismissed_at

                FROM reminder_settings r

                INNER JOIN reminder_occurrences o
                    ON r.reminder_id = o.reminder_id

                WHERE r.reminder_id = ?
                  AND r.admin_id = ?
                  AND o.admin_id = ?
                  AND o.reminder_date = ?
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, reminderId);
            ps.setInt(2, adminId);
            ps.setInt(3, adminId);
            ps.setDate(4, reminderDate);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapReminderWithOccurrence(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    // =========================================================
    // GET OCCURRENCES BY DATE
    // =========================================================

   

    // =========================================================
    // GET NEXT DUE REMINDER
    // =========================================================




    // =========================================================
    // GET PENDING POPUP REMINDERS
    // =========================================================
    private Reminder mapReminder(
            ResultSet rs)
            throws Exception {

        Reminder reminder =
                new Reminder();


        // =====================================================
        // REMINDER SETTINGS
        // =====================================================

        reminder.setReminderId(
                rs.getInt("reminder_id"));


        reminder.setAdminId(
                rs.getInt("admin_id"));


        reminder.setReminderName(
                rs.getString("reminder_name"));


        reminder.setReminderType(
                rs.getString("reminder_type"));


        reminder.setEnabled(
                rs.getBoolean("enabled"));


        reminder.setReminderTime(
                rs.getTime("reminder_time"));


        reminder.setFrequencyDays(
                rs.getInt("frequency_days"));


        reminder.setEmailEnabled(
                rs.getBoolean("email_enabled"));


        reminder.setCreatedAt(
                rs.getTimestamp("created_at"));


        reminder.setReminderInterval(
                rs.getInt("reminder_interval"));


        reminder.setLastTriggeredDate(
                rs.getDate("last_triggered_date"));


        // =====================================================
        // OCCURRENCE
        // =====================================================

        reminder.setOccurrenceId(
                rs.getInt("occurrence_id"));


        reminder.setTriggered(
                rs.getBoolean("triggered"));


        reminder.setDismissed(
                rs.getBoolean("dismissed"));


        return reminder;
    }
    
    @Override
    public boolean createDefaultReminders(int adminId) {

        if (adminId <= 0) {
            return false;
        }

        String sql = """
            INSERT INTO reminder_settings
            (
                admin_id,
                reminder_name,
                reminder_type,
                enabled,
                reminder_time,
                frequency_days,
                email_enabled,
                reminder_interval
            )
            SELECT ?, ?, ?, ?, ?, ?, ?, ?
            WHERE NOT EXISTS
            (
                SELECT 1
                FROM reminder_settings
                WHERE admin_id = ?
                AND reminder_type = ?
            )
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // =====================================================
            // TODAY'S EVENTS
            // =====================================================

            ps.setInt(1, adminId);
            ps.setString(2, "Today's Events");
            ps.setString(3, "TODAY_EVENTS");
            ps.setBoolean(4, true);
            ps.setTime(5, Time.valueOf("18:00:00"));
            ps.setInt(6, 1);
            ps.setBoolean(7, true);
            ps.setInt(8, 1);

            ps.setInt(9, adminId);
            ps.setString(10, "TODAY_EVENTS");

            ps.executeUpdate();


            // =====================================================
            // TOMORROW'S EVENTS
            // =====================================================

            ps.clearParameters();

            ps.setInt(1, adminId);
            ps.setString(2, "Tomorrow's Events");
            ps.setString(3, "TOMORROW_EVENTS");
            ps.setBoolean(4, true);
            ps.setTime(5, Time.valueOf("18:00:00"));
            ps.setInt(6, 1);
            ps.setBoolean(7, true);
            ps.setInt(8, 1);

            ps.setInt(9, adminId);
            ps.setString(10, "TOMORROW_EVENTS");

            ps.executeUpdate();


            // =====================================================
            // PENDING PAYMENTS
            // =====================================================

            ps.clearParameters();

            ps.setInt(1, adminId);
            ps.setString(2, "Pending Payments");
            ps.setString(3, "PENDING_PAYMENTS");
            ps.setBoolean(4, true);
            ps.setTime(5, Time.valueOf("18:00:00"));
            ps.setInt(6, 1);
            ps.setBoolean(7, true);
            ps.setInt(8, 1);

            ps.setInt(9, adminId);
            ps.setString(10, "PENDING_PAYMENTS");

            ps.executeUpdate();


            System.out.println(
                    "Default reminders checked/created for Admin ID: "
                    + adminId
            );

            return true;

        } catch (Exception e) {

            System.out.println(
                    "Failed to create default reminders for Admin ID: "
                    + adminId
            );

            e.printStackTrace();

            return false;
        }
    }
    @Override
    public Reminder getNextDueReminder(
            int adminId,
            Date reminderDate) {

        String sql = """
                SELECT
                    r.reminder_id,
                    r.admin_id,
                    r.reminder_name,
                    r.reminder_type,
                    r.enabled,
                    r.reminder_time,
                    r.frequency_days,
                    r.email_enabled,
                    r.created_at,
                    r.reminder_interval,
                    r.last_triggered_date,

                    o.occurrence_id,
                    o.triggered,
                    o.dismissed,
                    o.reminder_date,
                    o.created_at AS occurrence_created_at,
                    o.dismissed_at

                FROM reminder_settings r

                INNER JOIN reminder_occurrences o
                    ON r.reminder_id = o.reminder_id

                WHERE r.admin_id = ?
                  AND o.admin_id = ?
                  AND o.reminder_date = ?

                  AND r.enabled = TRUE

                  AND o.dismissed = FALSE

                  AND r.reminder_time <= CURTIME()

                ORDER BY
                    r.reminder_time ASC,
                    r.reminder_id ASC

                LIMIT 1
                """;


        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            ps.setInt(2, adminId);

            ps.setDate(3, reminderDate);


            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                return mapReminder(rs);
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return null;
    }


    // =========================================================
    // MARK OCCURRENCE TRIGGERED
    // =========================================================

   
    // =========================================================
    // DISMISS OCCURRENCE
    // =========================================================

   
    @Override
    public boolean dismissOccurrence(
            int occurrenceId,
            int adminId) {

        String sql = """
                UPDATE reminder_occurrences

                SET
                    dismissed = TRUE,
                    triggered = TRUE,
                    dismissed_at = CURRENT_TIMESTAMP

                WHERE occurrence_id = ?

                  AND admin_id = ?

                  AND dismissed = FALSE
                """;


        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, occurrenceId);

            ps.setInt(2, adminId);


            return ps.executeUpdate() > 0;


        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }
    // =========================================================
    // CHECK DISMISSED
    // =========================================================

    @Override
    public boolean isOccurrenceDismissed(
            int reminderId,
            int adminId,
            Date reminderDate) {

        String sql = """
                SELECT dismissed

                FROM reminder_occurrences

                WHERE reminder_id = ?

                  AND admin_id = ?

                  AND reminder_date = ?

                LIMIT 1
                """;


        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, reminderId);

            ps.setInt(2, adminId);

            ps.setDate(3, reminderDate);


            ResultSet rs =
                    ps.executeQuery();


            if (rs.next()) {

                return rs.getBoolean("dismissed");
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return false;
    }
    @Override
    public List<Reminder> getOccurrencesByDate(
            int adminId,
            Date reminderDate) {

        List<Reminder> reminders =
                new ArrayList<>();


        String sql = """
                SELECT
                    r.reminder_id,
                    r.admin_id,
                    r.reminder_name,
                    r.reminder_type,
                    r.enabled,
                    r.reminder_time,
                    r.frequency_days,
                    r.email_enabled,
                    r.created_at,
                    r.reminder_interval,
                    r.last_triggered_date,

                    o.occurrence_id,
                    o.triggered,
                    o.dismissed,
                    o.reminder_date,
                    o.created_at AS occurrence_created_at,
                    o.dismissed_at

                FROM reminder_settings r

                INNER JOIN reminder_occurrences o
                    ON r.reminder_id = o.reminder_id

                WHERE r.admin_id = ?

                  AND o.admin_id = ?

                  AND o.reminder_date = ?

                ORDER BY
                    r.reminder_time ASC,
                    r.reminder_id ASC
                """;


        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            ps.setInt(2, adminId);

            ps.setDate(3, reminderDate);


            ResultSet rs =
                    ps.executeQuery();


            while (rs.next()) {

                reminders.add(
                        mapReminder(rs));
            }


        } catch (Exception e) {

            e.printStackTrace();
        }


        return reminders;
    }

    // =========================================================
    // MAP REMINDER SETTINGS
    // =========================================================

    private Reminder mapReminderSettings(
            ResultSet rs)
            throws Exception {

        Reminder reminder =
                new Reminder();

        reminder.setReminderId(
                rs.getInt("reminder_id"));

        reminder.setAdminId(
                rs.getInt("admin_id"));

        reminder.setReminderName(
                rs.getString("reminder_name"));

        reminder.setReminderType(
                rs.getString("reminder_type"));

        reminder.setEnabled(
                rs.getBoolean("enabled"));

        reminder.setReminderTime(
                rs.getTime("reminder_time"));

        reminder.setFrequencyDays(
                rs.getInt("frequency_days"));

        reminder.setEmailEnabled(
                rs.getBoolean("email_enabled"));

        reminder.setCreatedAt(
                rs.getTimestamp("created_at"));

        reminder.setReminderInterval(
                rs.getInt("reminder_interval"));

        reminder.setLastTriggeredDate(
                rs.getDate("last_triggered_date"));

        return reminder;
    }


    // =========================================================
    // MAP REMINDER + OCCURRENCE
    // =========================================================

    private Reminder mapReminderWithOccurrence(
            ResultSet rs)
            throws Exception {

        Reminder reminder =
                mapReminderSettings(rs);

        reminder.setOccurrenceId(
                rs.getInt("occurrence_id"));

        reminder.setReminderDate(
                rs.getDate("reminder_date"));

        reminder.setTriggered(
                rs.getBoolean("triggered"));

        reminder.setDismissed(
                rs.getBoolean("dismissed"));

        reminder.setDismissedAt(
                rs.getTimestamp("dismissed_at"));

        return reminder;
    }
}