package com.digitalpurohit.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import com.digitalpurohit.dao.EventReportDAO;
import com.digitalpurohit.dao.impl.EventReportDAOImpl;
import com.digitalpurohit.model.EventReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/event-reports")
public class EventReportsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EventReportDAO reportDAO =
            new EventReportDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
    	HttpSession session =
    	        request.getSession(false);

    	int adminId =
    	        (Integer) session.getAttribute("adminId");
        String filter = request.getParameter("filter");

        List<EventReport> reports;
        if (filter == null || filter.isBlank()) {

        	reports = reportDAO.getAllReports(adminId);

        }

        else if ("today".equalsIgnoreCase(filter)) {

        	reports = reportDAO.getTodayReport(adminId);

        }

        else if ("month".equalsIgnoreCase(filter)) {

            int month = Integer.parseInt(
                    request.getParameter("month"));

            int year = Integer.parseInt(
                    request.getParameter("year"));

            reports = reportDAO.getMonthlyReport(
                    month,
                    year,
                    adminId);

        }

        else if ("year".equalsIgnoreCase(filter)) {

            int year = Integer.parseInt(
                    request.getParameter("year"));

            reports = reportDAO.getYearlyReport(
                    year,
                    adminId);

        }

        else if ("daterange".equalsIgnoreCase(filter)) {

            Date fromDate = Date.valueOf(
                    request.getParameter("fromDate"));

            Date toDate = Date.valueOf(
                    request.getParameter("toDate"));

            reports = reportDAO.getDateRangeReport(
                    fromDate,
                    toDate,
                    adminId);

        }

        else if ("eventtype".equalsIgnoreCase(filter)) {

            int typeId = Integer.parseInt(
                    request.getParameter("typeId"));

            reports = reportDAO.getEventTypeReport(
                    typeId,
                    adminId);

        }

        else {

        	reports = reportDAO.getAllReports(adminId);
        }
        // ==========================================
        // Calculate Summary
        // ==========================================

        int totalEvents = reports.size();

        double totalIncome = 0;
        double totalPaid = 0;
        double totalPending = 0;

        for (EventReport report : reports) {

            totalIncome += report.getTotalAmount();

            totalPaid += report.getAmountPaid();

            totalPending += report.getPendingAmount();

        }

        // ==========================================
        // Send Data to JSP
        // ==========================================

        request.setAttribute("reports", reports);

        request.setAttribute("totalEvents", totalEvents);

        request.setAttribute("totalIncome", totalIncome);

        request.setAttribute("totalPaid", totalPaid);

        request.setAttribute("totalPending", totalPending);

        request.setAttribute("selectedFilter", filter);

        request.getRequestDispatcher(
                "/WEB-INF/views/reports/event-reports.jsp")
                .forward(request, response);

    }

}