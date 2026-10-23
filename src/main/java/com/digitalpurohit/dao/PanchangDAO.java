package com.digitalpurohit.dao;

import java.sql.Date;
import java.util.List;

import com.digitalpurohit.model.Panchang;

public interface PanchangDAO {

    /* ==========================================
       CREATE
    ========================================== */

    boolean savePanchang(Panchang panchang);

    /* ==========================================
       UPDATE
    ========================================== */

    boolean updatePanchang(Panchang panchang);

    /* ==========================================
       DELETE
    ========================================== */

    boolean deletePanchang(Date panchangDate);

    /* ==========================================
       READ
    ========================================== */

    Panchang getPanchangByDate(Date panchangDate);

    Panchang getPanchangById(int panchangId);

    List<Panchang> getAllPanchang();

    List<Panchang> getPanchangBetweenDates(Date fromDate,
                                           Date toDate);

    /* ==========================================
       IMPORT
    ========================================== */

    boolean importPanchang(List<Panchang> panchangList);

    /* ==========================================
       CHECK
    ========================================== */

    boolean exists(Date panchangDate);

    /* ==========================================
       STATISTICS
    ========================================== */

    int getTotalDays();

}