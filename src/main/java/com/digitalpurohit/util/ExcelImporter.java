package com.digitalpurohit.util;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.digitalpurohit.model.Panchang;

public class ExcelImporter {

    public static List<Panchang> importExcel(File excelFile) {

        List<Panchang> list = new ArrayList<>();

        DataFormatter formatter = new DataFormatter();

        try (FileInputStream fis = new FileInputStream(excelFile);
             XSSFWorkbook workbook = new XSSFWorkbook(fis)) {

            XSSFSheet sheet = workbook.getSheetAt(0);

            boolean firstRow = true;

            for (Row row : sheet) {

                if (firstRow) {
                    firstRow = false;
                    continue;
                }

                if (row == null ||
                    row.getCell(0) == null ||
                    formatter.formatCellValue(row.getCell(0)).trim().isEmpty()) {
                    continue;
                }

                Panchang p = new Panchang();

                // Date
                p.setPanchangDate(
                        Date.valueOf(getCell(row,0,formatter)));

                // Weekday
                p.setWeekdayTelugu(
                        getCell(row,1,formatter));

                // Tithi
                p.setTithi(
                        getCell(row,2,formatter));

                // Tithi End Time
                p.setTithiEndTime(
                        getCell(row,3,formatter));

                // Nakshatra
                p.setNakshatra(
                        getCell(row,4,formatter));

                // Nakshatra End Time
                p.setNakshatraEndTime(
                        getCell(row,5,formatter));

                // Sunrise
                p.setSunrise(
                        parseTime(getCell(row,6,formatter)));

                // Sunset
                p.setSunset(
                        parseTime(getCell(row,7,formatter)));

                // Festival
                p.setFestival(
                        getCell(row,8,formatter));

                // Notes
                p.setNotes(
                        getCell(row,9,formatter));
                if (p.getPanchangDate().toString().equals("2026-07-01")) {

                    System.out.println("========== DEBUG ==========");
                    System.out.println("Date              : " + p.getPanchangDate());
                    System.out.println("Weekday           : " + p.getWeekdayTelugu());
                    System.out.println("Tithi             : " + p.getTithi());
                    System.out.println("Tithi End         : " + p.getTithiEndTime());
                    System.out.println("Nakshatra         : " + p.getNakshatra());
                    System.out.println("Nakshatra End     : " + p.getNakshatraEndTime());
                    System.out.println("Sunrise           : " + p.getSunrise());
                    System.out.println("Sunset            : " + p.getSunset());
                    System.out.println("Festival          : " + p.getFestival());
                    System.out.println("Notes             : " + p.getNotes());
                    System.out.println("===========================");
                }
                list.add(p);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;

    }

    /*====================================
            Helper Methods
    ====================================*/

    private static String getCell(Row row,
                                  int index,
                                  DataFormatter formatter) {

        if (row.getCell(index) == null) {

            return "";

        }

        return formatter
                .formatCellValue(row.getCell(index))
                .trim();

    }

    private static Time parseTime(String value) {

        if (value == null || value.isBlank()) {

            return null;

        }

        try {

            return Time.valueOf(value);

        } catch (Exception e) {

            return null;

        }

    }

}