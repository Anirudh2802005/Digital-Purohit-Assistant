package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.EventReportDAO;
import com.digitalpurohit.dao.impl.EventReportDAOImpl;
import com.digitalpurohit.model.EventReport;

import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;

import com.itextpdf.text.Document;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/export-event-pdf")
public class ExportEventPdfServlet extends HttpServlet {

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
        // PDF RESPONSE
        // =====================================================

        response.setContentType(
                "application/pdf"
        );

        response.setHeader(
                "Content-Disposition",
                "attachment; filename=Event_Report.pdf"
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

            Font titleFont =
                    new Font(
                            Font.FontFamily.HELVETICA,
                            18,
                            Font.BOLD
                    );


            Paragraph title =
                    new Paragraph(
                            "Digital Purohit Assistant\nEvent Report",
                            titleFont
                    );


            title.setSpacingAfter(20);


            document.add(title);


            // =================================================
            // CALCULATE TOTALS
            // =================================================

            double totalIncome = 0;

            double totalPaid = 0;

            double totalPending = 0;


            for (EventReport report : reports) {

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

            document.add(
                    new Paragraph(
                            "Total Events : "
                            + reports.size()
                    )
            );


            document.add(
                    new Paragraph(
                            "Total Income : ₹"
                            + totalIncome
                    )
            );


            document.add(
                    new Paragraph(
                            "Amount Paid : ₹"
                            + totalPaid
                    )
            );


            document.add(
                    new Paragraph(
                            "Pending Amount : ₹"
                            + totalPending
                    )
            );


            document.add(
                    new Paragraph(" ")
            );


            // =================================================
            // EVENT TABLE
            // =================================================

            PdfPTable table =
                    new PdfPTable(7);


            table.setWidthPercentage(
                    100
            );


            table.setSpacingBefore(
                    10
            );


            table.setWidths(
                    new float[] {
                            2f,
                            3f,
                            3f,
                            2f,
                            2f,
                            2f,
                            2f
                    }
            );


            // =================================================
            // HEADER FONT
            // =================================================

            Font headerFont =
                    new Font(
                            Font.FontFamily.HELVETICA,
                            11,
                            Font.BOLD
                    );


            // =================================================
            // TABLE HEADERS
            // =================================================

            table.addCell(
                    new PdfPCell(
                            new Phrase(
                                    "Date",
                                    headerFont
                            )
                    )
            );


            table.addCell(
                    new PdfPCell(
                            new Phrase(
                                    "Customer",
                                    headerFont
                            )
                    )
            );


            table.addCell(
                    new PdfPCell(
                            new Phrase(
                                    "Event",
                                    headerFont
                            )
                    )
            );


            table.addCell(
                    new PdfPCell(
                            new Phrase(
                                    "Total",
                                    headerFont
                            )
                    )
            );


            table.addCell(
                    new PdfPCell(
                            new Phrase(
                                    "Paid",
                                    headerFont
                            )
                    )
            );


            table.addCell(
                    new PdfPCell(
                            new Phrase(
                                    "Pending",
                                    headerFont
                            )
                    )
            );


            table.addCell(
                    new PdfPCell(
                            new Phrase(
                                    "Status",
                                    headerFont
                            )
                    )
            );


            // =================================================
            // TABLE DATA
            // =================================================

            for (EventReport report : reports) {

                table.addCell(
                        String.valueOf(
                                report.getEventDate()
                        )
                );


                table.addCell(
                        report.getCustomerName()
                );


                table.addCell(
                        report.getEventTitle()
                );


                table.addCell(
                        "₹ "
                        + report.getTotalAmount()
                );


                table.addCell(
                        "₹ "
                        + report.getAmountPaid()
                );


                table.addCell(
                        "₹ "
                        + report.getPendingAmount()
                );


                table.addCell(
                        report.getPaymentStatus()
                );
            }


            // =================================================
            // ADD TABLE
            // =================================================

            document.add(table);


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
                            "Event Report Exported",
                            "Event report was exported successfully.",
                            "EVENT_REPORT",
                            "EXPORT_PDF",
                            null,
                            "/events"
                    );


            System.out.println(
                    "EVENT REPORT PDF EXPORT NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
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