package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.PanchangDAO;
import com.digitalpurohit.model.Panchang;
import com.digitalpurohit.util.DBConnection;

public class PanchangDAOImpl implements PanchangDAO {

	@Override
	public boolean savePanchang(Panchang panchang) {

	    String sql =
	            "INSERT INTO panchang("
	          + "panchang_date,"
	          + "weekday_telugu,"
	          + "tithi,"
	          + "tithi_end_time,"
	          + "nakshatra,"
	          + "nakshatra_end_time,"
	          + "yoga,"
	          + "karana,"
	          + "masa,"
	          + "paksha,"
	          + "ritu,"
	          + "ayana,"
	          + "sunrise,"
	          + "sunset,"
	          + "moonrise,"
	          + "moonset,"
	          + "rahukalam,"
	          + "yamagandam,"
	          + "gulika,"
	          + "durmuhurtham,"
	          + "abhijit_muhurtham,"
	          + "amritakalam,"
	          + "varjyam,"
	          + "festival,"
	          + "notes)"
	          + " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        setPreparedStatement(ps, panchang);

	        return ps.executeUpdate() > 0;

	    } catch (Exception e) {

	        e.printStackTrace();

	    }

	    return false;
	}

	@Override
	public boolean updatePanchang(Panchang panchang) {

	    String sql =
	            "UPDATE panchang SET "
	          + "weekday_telugu=?,"
	          + "tithi=?,"
	          + "tithi_end_time=?,"
	          + "nakshatra=?,"
	          + "nakshatra_end_time=?,"
	          + "yoga=?,"
	          + "karana=?,"
	          + "masa=?,"
	          + "paksha=?,"
	          + "ritu=?,"
	          + "ayana=?,"
	          + "sunrise=?,"
	          + "sunset=?,"
	          + "moonrise=?,"
	          + "moonset=?,"
	          + "rahukalam=?,"
	          + "yamagandam=?,"
	          + "gulika=?,"
	          + "durmuhurtham=?,"
	          + "abhijit_muhurtham=?,"
	          + "amritakalam=?,"
	          + "varjyam=?,"
	          + "festival=?,"
	          + "notes=? "
	          + "WHERE panchang_date=?";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, panchang.getWeekdayTelugu());
	        ps.setString(2, panchang.getTithi());
	        ps.setString(3, panchang.getTithiEndTime());
	        ps.setString(4, panchang.getNakshatra());
	        ps.setString(5, panchang.getNakshatraEndTime());
	        ps.setString(6, panchang.getYoga());
	        ps.setString(7, panchang.getKarana());
	        ps.setString(8, panchang.getMasa());
	        ps.setString(9, panchang.getPaksha());
	        ps.setString(10, panchang.getRitu());
	        ps.setString(11, panchang.getAyana());
	        ps.setTime(12, panchang.getSunrise());
	        ps.setTime(13, panchang.getSunset());
	        ps.setTime(14, panchang.getMoonrise());
	        ps.setTime(15, panchang.getMoonset());
	        ps.setString(16, panchang.getRahukalam());
	        ps.setString(17, panchang.getYamagandam());
	        ps.setString(18, panchang.getGulika());
	        ps.setString(19, panchang.getDurmuhurtham());
	        ps.setString(20, panchang.getAbhijitMuhurtham());
	        ps.setString(21, panchang.getAmritakalam());
	        ps.setString(22, panchang.getVarjyam());
	        ps.setString(23, panchang.getFestival());
	        ps.setString(24, panchang.getNotes());
	        ps.setDate(25, panchang.getPanchangDate());

	        return ps.executeUpdate() > 0;

	    } catch (Exception e) {

	        e.printStackTrace();

	    }

	    return false;
	}

	@Override
	public boolean deletePanchang(Date date) {

	    String sql = "DELETE FROM panchang WHERE panchang_date=?";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setDate(1, date);

	        return ps.executeUpdate() > 0;

	    } catch (Exception e) {

	        e.printStackTrace();

	    }

	    return false;
	}

	@Override
	public Panchang getPanchangByDate(Date date) {

	    String sql = "SELECT * FROM panchang WHERE panchang_date=?";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setDate(1, date);

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {

	            return extractPanchang(rs);

	        }

	    } catch (Exception e) {

	        e.printStackTrace();

	    }

	    return null;
	}

	@Override
	public Panchang getPanchangById(int id) {

	    String sql = "SELECT * FROM panchang WHERE panchang_id=?";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setInt(1, id);

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {

	            return extractPanchang(rs);

	        }

	    } catch (Exception e) {

	        e.printStackTrace();

	    }

	    return null;
	}

	@Override
	public List<Panchang> getAllPanchang() {

	    List<Panchang> list = new ArrayList<>();

	    String sql = "SELECT * FROM panchang ORDER BY panchang_date";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {

	            list.add(extractPanchang(rs));

	        }

	    } catch (Exception e) {

	        e.printStackTrace();

	    }

	    return list;
	}

	@Override
	public List<Panchang> getPanchangBetweenDates(Date from, Date to) {

	    List<Panchang> list = new ArrayList<>();

	    String sql =
	            "SELECT * FROM panchang "
	          + "WHERE panchang_date BETWEEN ? AND ? "
	          + "ORDER BY panchang_date";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setDate(1, from);
	        ps.setDate(2, to);

	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {

	            list.add(extractPanchang(rs));

	        }

	    } catch (Exception e) {

	        e.printStackTrace();

	    }

	    return list;
	}

	@Override
	public boolean importPanchang(List<Panchang> list) {

	    String sql =
	            "INSERT INTO panchang("
	          + "panchang_date,"
	          + "weekday_telugu,"
	          + "tithi,"
	          + "tithi_end_time,"
	          + "nakshatra,"
	          + "nakshatra_end_time,"
	          + "yoga,"
	          + "karana,"
	          + "masa,"
	          + "paksha,"
	          + "ritu,"
	          + "ayana,"
	          + "sunrise,"
	          + "sunset,"
	          + "moonrise,"
	          + "moonset,"
	          + "rahukalam,"
	          + "yamagandam,"
	          + "gulika,"
	          + "durmuhurtham,"
	          + "abhijit_muhurtham,"
	          + "amritakalam,"
	          + "varjyam,"
	          + "festival,"
	          + "notes)"
	          + " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        con.setAutoCommit(false);

	        for (Panchang p : list) {

	            setPreparedStatement(ps, p);

	            ps.addBatch();

	        }

	        ps.executeBatch();

	        con.commit();

	        return true;

	    } catch (Exception e) {

	        e.printStackTrace();

	    }

	    return false;
	}

	@Override
	public boolean exists(Date date) {

	    String sql =
	            "SELECT COUNT(*) FROM panchang WHERE panchang_date=?";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setDate(1, date);

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {

	            return rs.getInt(1) > 0;

	        }

	    } catch (Exception e) {

	        e.printStackTrace();

	    }

	    return false;
	}

	@Override
	public int getTotalDays() {

	    String sql = "SELECT COUNT(*) FROM panchang";

	    try (Connection con = DBConnection.getConnection();
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
    /*======================================================
                     HELPER METHODS
    ======================================================*/

    /*======================================================
    HELPER METHODS
======================================================*/

private void setPreparedStatement(
PreparedStatement ps,
Panchang p) throws Exception {

ps.setDate(1, p.getPanchangDate());

ps.setString(2, p.getWeekdayTelugu());

ps.setString(3, p.getTithi());

ps.setString(4, p.getTithiEndTime());

ps.setString(5, p.getNakshatra());

ps.setString(6, p.getNakshatraEndTime());

ps.setString(7, p.getYoga());

ps.setString(8, p.getKarana());

ps.setString(9, p.getMasa());

ps.setString(10, p.getPaksha());

ps.setString(11, p.getRitu());

ps.setString(12, p.getAyana());

ps.setTime(13, p.getSunrise());

ps.setTime(14, p.getSunset());

ps.setTime(15, p.getMoonrise());

ps.setTime(16, p.getMoonset());

ps.setString(17, p.getRahukalam());

ps.setString(18, p.getYamagandam());

ps.setString(19, p.getGulika());

ps.setString(20, p.getDurmuhurtham());

ps.setString(21, p.getAbhijitMuhurtham());

ps.setString(22, p.getAmritakalam());

ps.setString(23, p.getVarjyam());

ps.setString(24, p.getFestival());

ps.setString(25, p.getNotes());

}

private Panchang extractPanchang(ResultSet rs) throws Exception {

Panchang p = new Panchang();

p.setPanchangId(
rs.getInt("panchang_id"));

p.setPanchangDate(
rs.getDate("panchang_date"));

p.setWeekdayTelugu(
rs.getString("weekday_telugu"));

p.setTithi(
rs.getString("tithi"));

p.setTithiEndTime(
rs.getString("tithi_end_time"));

p.setNakshatra(
rs.getString("nakshatra"));

p.setNakshatraEndTime(
rs.getString("nakshatra_end_time"));

p.setYoga(
rs.getString("yoga"));

p.setKarana(
rs.getString("karana"));

p.setMasa(
rs.getString("masa"));

p.setPaksha(
rs.getString("paksha"));

p.setRitu(
rs.getString("ritu"));

p.setAyana(
rs.getString("ayana"));

p.setSunrise(
rs.getTime("sunrise"));

p.setSunset(
rs.getTime("sunset"));

p.setMoonrise(
rs.getTime("moonrise"));

p.setMoonset(
rs.getTime("moonset"));

p.setRahukalam(
rs.getString("rahukalam"));

p.setYamagandam(
rs.getString("yamagandam"));

p.setGulika(
rs.getString("gulika"));

p.setDurmuhurtham(
rs.getString("durmuhurtham"));

p.setAbhijitMuhurtham(
rs.getString("abhijit_muhurtham"));

p.setAmritakalam(
rs.getString("amritakalam"));

p.setVarjyam(
rs.getString("varjyam"));

p.setFestival(
rs.getString("festival"));

p.setNotes(
rs.getString("notes"));

p.setCreatedAt(
rs.getTimestamp("created_at"));

return p;

}
}