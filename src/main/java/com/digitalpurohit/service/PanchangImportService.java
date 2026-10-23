package com.digitalpurohit.service;

import java.io.File;
import java.sql.Date;
import java.util.List;

import com.digitalpurohit.dao.PanchangDAO;
import com.digitalpurohit.dao.impl.PanchangDAOImpl;
import com.digitalpurohit.model.Panchang;
import com.digitalpurohit.util.ExcelImporter;
public class PanchangImportService {

    private PanchangDAO panchangDAO;

    public PanchangImportService() {

        panchangDAO = new PanchangDAOImpl();

    }

    /**
     * Import Panchang Excel File
     */
    public int importPanchang(File excelFile) {

        int importedCount = 0;

        try {

            List<Panchang> panchangList =
                    ExcelImporter.importExcel(excelFile);

            for (Panchang panchang : panchangList) {

                Date date = panchang.getPanchangDate();

                if (panchangDAO.exists(date)) {

                    panchangDAO.updatePanchang(panchang);

                } else {

                    panchangDAO.savePanchang(panchang);

                }

                importedCount++;

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return importedCount;

    }

    /**
     * Get Panchang by Date
     */
    public Panchang getPanchang(Date date) {

        return panchangDAO.getPanchangByDate(date);

    }

    /**
     * Get All Panchang
     */
    public List<Panchang> getAllPanchang() {

        return panchangDAO.getAllPanchang();

    }

    /**
     * Total Imported Days
     */
    public int getTotalDays() {

        return panchangDAO.getTotalDays();

    }

}