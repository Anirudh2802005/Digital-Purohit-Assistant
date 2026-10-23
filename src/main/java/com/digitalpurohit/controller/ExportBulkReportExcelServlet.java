package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.model.BulkEventCustomer;

import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/export-bulk-report-excel")
public class ExportBulkReportExcelServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAO
    // =========================================================

    private BulkEventCustomerDAO dao;

    // =========================================================
    // NOTIFICATION SERVICE
    // =========================================================

    private NotificationService notificationService;


    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

        dao =
                new BulkEventCustomerDAOImpl();

        notificationService =
                new NotificationServiceImpl();
    }


    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // =====================================================
        // SESSION CHECK FIRST
        // =====================================================

        HttpSession session =
                request.getSession(false);


        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );

            return;
        }


        // =====================================================
        // CURRENT ADMIN
        // =====================================================

        int adminId =
                (Integer) session.getAttribute(
                        "adminId"
                );


        // =====================================================
        // GET BULK EVENT ID
        // =====================================================

        String bulkEventIdParameter =
                request.getParameter(
                        "bulkEventId"
                );


        if (bulkEventIdParameter == null ||
            bulkEventIdParameter.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Bulk Event ID is required."
            );

            return;
        }


        int bulkEventId;

        try {

            bulkEventId =
                    Integer.parseInt(
                            bulkEventIdParameter
                    );

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid Bulk Event ID."
            );

            return;
        }


        // =====================================================
        // GET REPORT DATA
        // =====================================================

        List<BulkEventCustomer> families =
                dao.getFamilyDetails(
                        bulkEventId
                );


        // =====================================================
        // EXCEL RESPONSE
        // =====================================================

        response.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        );


        response.setHeader(
                "Content-Disposition",
                "attachment; filename=Bulk_Event_Report.xlsx"
        );


        // =====================================================
        // CREATE WORKBOOK
        // =====================================================

        Workbook workbook =
                new XSSFWorkbook();


        try {

            Sheet sheet =
                    workbook.createSheet(
                            "Bulk Event Report"
                    );


            // =================================================
            // HEADER
            // =================================================

            Row header =
                    sheet.createRow(0);


            header.createCell(0)
                    .setCellValue("Family Name");


            header.createCell(1)
                    .setCellValue("Phone");


            header.createCell(2)
                    .setCellValue("Total Amount");


            header.createCell(3)
                    .setCellValue("Amount Paid");


            header.createCell(4)
                    .setCellValue("Pending Amount");


            header.createCell(5)
                    .setCellValue("Status");


            // =================================================
            // DATA
            // =================================================

            int rowNum = 1;


            double totalAmount = 0;

            double totalPaid = 0;

            double totalPending = 0;


            for (BulkEventCustomer family : families) {

                Row row =
                        sheet.createRow(
                                rowNum++
                        );


                row.createCell(0)
                        .setCellValue(
                                family.getCustomerName()
                        );


                row.createCell(1)
                        .setCellValue(
                                family.getPhone()
                        );


                row.createCell(2)
                        .setCellValue(
                                family.getTotalAmount()
                        );


                row.createCell(3)
                        .setCellValue(
                                family.getAmountPaid()
                        );


                double pending =
                        family.getTotalAmount()
                        - family.getAmountPaid();


                row.createCell(4)
                        .setCellValue(
                                pending
                        );


                row.createCell(5)
                        .setCellValue(
                                family.getPaymentStatus()
                        );


                totalAmount +=
                        family.getTotalAmount();


                totalPaid +=
                        family.getAmountPaid();


                totalPending +=
                        pending;
            }


            // =================================================
            // SUMMARY
            // =================================================

            rowNum++;


            Row totalFamilies =
                    sheet.createRow(
                            rowNum++
                    );


            totalFamilies.createCell(0)
                    .setCellValue(
                            "Total Families"
                    );


            totalFamilies.createCell(1)
                    .setCellValue(
                            families.size()
                    );


            Row totalAmountRow =
                    sheet.createRow(
                            rowNum++
                    );


            totalAmountRow.createCell(0)
                    .setCellValue(
                            "Total Amount"
                    );


            totalAmountRow.createCell(1)
                    .setCellValue(
                            totalAmount
                    );


            Row paidRow =
                    sheet.createRow(
                            rowNum++
                    );


            paidRow.createCell(0)
                    .setCellValue(
                            "Collected Amount"
                    );


            paidRow.createCell(1)
                    .setCellValue(
                            totalPaid
                    );


            Row pendingRow =
                    sheet.createRow(
                            rowNum++
                    );


            pendingRow.createCell(0)
                    .setCellValue(
                            "Pending Amount"
                    );


            pendingRow.createCell(1)
                    .setCellValue(
                            totalPending
                    );


            // =================================================
            // AUTO SIZE
            // =================================================

            for (int i = 0; i <= 5; i++) {

                sheet.autoSizeColumn(i);
            }


            // =================================================
            // WRITE EXCEL
            // =================================================

            workbook.write(
                    response.getOutputStream()
            );


        } finally {

            workbook.close();
        }


        // =====================================================
        // CREATE MULTI-USER NOTIFICATION
        // =====================================================

        boolean notificationCreated =
                notificationService.createNotification(
                        adminId,
                        "Bulk Event Report Exported",
                        "Bulk Event report was exported successfully.",
                        "BULK_EVENT",
                        "EXPORT_EXCEL",
                        bulkEventId,
                        "/bulk-events"
                );


        System.out.println(
                "BULK EVENT EXCEL EXPORT NOTIFICATION"
                + " | ADMIN ID = "
                + adminId
                + " | BULK EVENT ID = "
                + bulkEventId
                + " | SUCCESS = "
                + notificationCreated
        );
    }
}