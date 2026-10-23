package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.digitalpurohit.dao.EventReportDAO;
import com.digitalpurohit.dao.impl.EventReportDAOImpl;
import com.digitalpurohit.model.EventReport;

import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/export-event-excel")
public class ExportEventExcelServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAO
    // =========================================================

    private EventReportDAO reportDAO;

    // =========================================================
    // NOTIFICATION SERVICE
    // =========================================================

    private NotificationService notificationService;


    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

        reportDAO =
                new EventReportDAOImpl();

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
        // SESSION CHECK
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
        // GET ADMIN-SPECIFIC REPORTS
        // =====================================================

        List<EventReport> reports =
                reportDAO.getAllReports(
                        adminId
                );


        // =====================================================
        // EXCEL RESPONSE
        // =====================================================

        response.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        );


        response.setHeader(
                "Content-Disposition",
                "attachment; filename=Event_Report.xlsx"
        );


        Workbook workbook =
                new XSSFWorkbook();


        try {

            Sheet sheet =
                    workbook.createSheet(
                            "Event Reports"
                    );


            // =================================================
            // HEADER
            // =================================================

            Row header =
                    sheet.createRow(0);


            header.createCell(0)
                    .setCellValue("Date");

            header.createCell(1)
                    .setCellValue("Customer");

            header.createCell(2)
                    .setCellValue("Event");

            header.createCell(3)
                    .setCellValue("Total Amount");

            header.createCell(4)
                    .setCellValue("Amount Paid");

            header.createCell(5)
                    .setCellValue("Pending Amount");

            header.createCell(6)
                    .setCellValue("Payment Status");


            // =================================================
            // DATA
            // =================================================

            int rowNum = 1;


            double totalIncome = 0;

            double totalPaid = 0;

            double totalPending = 0;


            for (EventReport report : reports) {

                Row row =
                        sheet.createRow(
                                rowNum++
                        );


                row.createCell(0)
                        .setCellValue(
                                report.getEventDate()
                                        .toString()
                        );


                row.createCell(1)
                        .setCellValue(
                                report.getCustomerName()
                        );


                row.createCell(2)
                        .setCellValue(
                                report.getEventTitle()
                        );


                row.createCell(3)
                        .setCellValue(
                                report.getTotalAmount()
                        );


                row.createCell(4)
                        .setCellValue(
                                report.getAmountPaid()
                        );


                row.createCell(5)
                        .setCellValue(
                                report.getPendingAmount()
                        );


                row.createCell(6)
                        .setCellValue(
                                report.getPaymentStatus()
                        );


                totalIncome +=
                        report.getTotalAmount();


                totalPaid +=
                        report.getAmountPaid();


                totalPending +=
                        report.getPendingAmount();
            }


            // =================================================
            // SUMMARY
            // =================================================

            rowNum++;


            Row totalEventsRow =
                    sheet.createRow(
                            rowNum++
                    );


            totalEventsRow.createCell(0)
                    .setCellValue(
                            "Total Events"
                    );


            totalEventsRow.createCell(1)
                    .setCellValue(
                            reports.size()
                    );


            Row totalIncomeRow =
                    sheet.createRow(
                            rowNum++
                    );


            totalIncomeRow.createCell(0)
                    .setCellValue(
                            "Total Income"
                    );


            totalIncomeRow.createCell(1)
                    .setCellValue(
                            totalIncome
                    );


            Row totalPaidRow =
                    sheet.createRow(
                            rowNum++
                    );


            totalPaidRow.createCell(0)
                    .setCellValue(
                            "Amount Paid"
                    );


            totalPaidRow.createCell(1)
                    .setCellValue(
                            totalPaid
                    );


            Row totalPendingRow =
                    sheet.createRow(
                            rowNum++
                    );


            totalPendingRow.createCell(0)
                    .setCellValue(
                            "Pending Amount"
                    );


            totalPendingRow.createCell(1)
                    .setCellValue(
                            totalPending
                    );


            // =================================================
            // AUTO SIZE
            // =================================================

            for (int i = 0; i <= 6; i++) {

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
        // MULTI-USER NOTIFICATION
        // =====================================================

        boolean notificationCreated =
                notificationService.createNotification(
                        adminId,
                        "Event Report Exported",
                        "Event report was exported successfully.",
                        "EVENT_REPORT",
                        "EXPORT_EXCEL",
                        null,
                        "/events"
                );


        System.out.println(
                "EVENT REPORT EXCEL EXPORT NOTIFICATION"
                + " | ADMIN ID = "
                + adminId
                + " | SUCCESS = "
                + notificationCreated
        );
    }
}