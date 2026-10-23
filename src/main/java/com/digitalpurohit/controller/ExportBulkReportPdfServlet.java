package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.model.BulkEventCustomer;

import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;

import com.itextpdf.text.Document;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/export-bulk-report-pdf")
public class ExportBulkReportPdfServlet extends HttpServlet {

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
        // PDF RESPONSE
        // =====================================================

        response.setContentType(
                "application/pdf"
        );


        response.setHeader(
                "Content-Disposition",
                "attachment; filename=Bulk_Event_Report.pdf"
        );


        try {

            // =================================================
            // CREATE DOCUMENT
            // =================================================

            Document document =
                    new Document();


            PdfWriter.getInstance(
                    document,
                    response.getOutputStream()
            );


            document.open();


            // =================================================
            // TITLE
            // =================================================

            Font title =
                    new Font(
                            Font.FontFamily.HELVETICA,
                            18,
                            Font.BOLD
                    );


            document.add(
                    new Paragraph(
                            "Bulk Event Report",
                            title
                    )
            );


            document.add(
                    new Paragraph(" ")
            );


            // =================================================
            // TABLE
            // =================================================

            PdfPTable table =
                    new PdfPTable(6);


            table.setWidthPercentage(
                    100
            );


            table.addCell("Family");
            table.addCell("Phone");
            table.addCell("Total");
            table.addCell("Paid");
            table.addCell("Pending");
            table.addCell("Status");


            // =================================================
            // CALCULATE TOTALS
            // =================================================

            double totalAmount = 0;

            double totalPaid = 0;

            double totalPending = 0;


            // =================================================
            // ADD FAMILY DATA
            // =================================================

            for (BulkEventCustomer family : families) {

                double pending =
                        family.getTotalAmount()
                        - family.getAmountPaid();


                table.addCell(
                        family.getCustomerName()
                );


                table.addCell(
                        family.getPhone()
                );


                table.addCell(
                        String.valueOf(
                                family.getTotalAmount()
                        )
                );


                table.addCell(
                        String.valueOf(
                                family.getAmountPaid()
                        )
                );


                table.addCell(
                        String.valueOf(
                                pending
                        )
                );


                table.addCell(
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
            // ADD TABLE
            // =================================================

            document.add(
                    table
            );


            document.add(
                    new Paragraph(" ")
            );


            // =================================================
            // SUMMARY
            // =================================================

            document.add(
                    new Paragraph(
                            "Total Families : "
                            + families.size()
                    )
            );


            document.add(
                    new Paragraph(
                            "Total Amount : ₹ "
                            + totalAmount
                    )
            );


            document.add(
                    new Paragraph(
                            "Collected Amount : ₹ "
                            + totalPaid
                    )
            );


            document.add(
                    new Paragraph(
                            "Pending Amount : ₹ "
                            + totalPending
                    )
            );


            // =================================================
            // CLOSE PDF
            // =================================================

            document.close();


            // =================================================
            // MULTI-USER NOTIFICATION
            // =================================================

            boolean notificationCreated =
                    notificationService.createNotification(
                            adminId,
                            "Bulk Event Report Exported",
                            "Bulk Event PDF report was exported successfully.",
                            "BULK_EVENT",
                            "EXPORT_PDF",
                            bulkEventId,
                            "/bulk-events"
                    );


            System.out.println(
                    "BULK EVENT PDF EXPORT NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | BULK EVENT ID = "
                    + bulkEventId
                    + " | SUCCESS = "
                    + notificationCreated
            );


        } catch (Exception e) {

            throw new ServletException(
                    e
            );
        }
    }
}