package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.BulkEventReportDAO;
import com.digitalpurohit.dao.impl.BulkEventReportDAOImpl;
import com.digitalpurohit.model.BulkEventReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/bulk-event-reports")
public class BulkReportsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BulkEventReportDAO reportDAO;

    @Override
    public void init() {

        reportDAO = new BulkEventReportDAOImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
    	HttpSession session =
    	        request.getSession(false);

    	int adminId =
    	        (Integer) session.getAttribute("adminId");
    	List<BulkEventReport> reports =
    	        reportDAO.getAllBulkEventReports(adminId);
    	int totalBulkEvents = reports.size();

        int totalFamilies = 0;

        double totalAmount = 0;

        for(BulkEventReport report : reports){

            totalFamilies += report.getTotalFamilies();

            totalAmount += report.getTotalAmount();

        }

        request.setAttribute(
                "totalBulkEvents",
                totalBulkEvents);

        request.setAttribute(
                "totalFamilies",
                totalFamilies);

        request.setAttribute(
                "totalAmount",
                totalAmount);
        request.setAttribute("reports", reports);

        request.getRequestDispatcher(
                "/WEB-INF/views/reports/bulk-event-reports.jsp")
                .forward(request, response);

    }
}