package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.digitalpurohit.dao.CustomerReportDAO;
import com.digitalpurohit.dao.impl.CustomerReportDAOImpl;
import com.digitalpurohit.model.CustomerReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/customer-reports")
public class CustomerReportsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CustomerReportDAO reportDAO;

    @Override
    public void init() {

        reportDAO = new CustomerReportDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // SESSION CHECK
        // ==========================================

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login");

            return;
        }


        // ==========================================
        // GET LOGGED-IN ADMIN ID
        // ==========================================

        int adminId =
                (Integer) session.getAttribute("adminId");


        // ==========================================
        // GET ADMIN-SPECIFIC CUSTOMER REPORTS
        // ==========================================

        List<CustomerReport> reports =
                reportDAO.getAllCustomerReports(adminId);


        // ==========================================
        // GRAPH DATA
        // ==========================================

        List<String> graphLabels =
                new ArrayList<>();

        List<Double> graphValues =
                new ArrayList<>();

        Map<String, Integer> paymentStatus =
                new HashMap<>();

        paymentStatus.put("PAID", 0);
        paymentStatus.put("PARTIAL", 0);
        paymentStatus.put("PENDING", 0);


        for (CustomerReport report : reports) {

            // Customer name
            graphLabels.add(
                    report.getCustomerName());


            // Received amount
            graphValues.add(
                    report.getReceivedAmount());


            // Payment status
            String status =
                    report.getPaymentStatus();

            if (status != null &&
                paymentStatus.containsKey(status)) {

                paymentStatus.put(
                        status,
                        paymentStatus.get(status) + 1);
            }
        }


        // ==========================================
        // SEND GRAPH DATA
        // ==========================================

        request.setAttribute(
                "graphLabels",
                graphLabels);

        request.setAttribute(
                "graphValues",
                graphValues);

        request.setAttribute(
                "paymentStatus",
                paymentStatus);


        // ==========================================
        // SEND CUSTOMER REPORTS
        // ==========================================

        request.setAttribute(
                "reports",
                reports);


        // ==========================================
        // ADMIN-SPECIFIC SUMMARY
        // ==========================================

        request.setAttribute(
                "totalCustomers",
                reportDAO.getTotalCustomers(adminId));

        request.setAttribute(
                "totalEvents",
                reportDAO.getTotalEvents(adminId));

        request.setAttribute(
                "totalBulkEvents",
                reportDAO.getTotalBulkEvents(adminId));

        request.setAttribute(
                "totalReceivedAmount",
                reportDAO.getTotalReceivedAmount(adminId));

        request.setAttribute(
                "totalPendingAmount",
                reportDAO.getTotalPendingAmount(adminId));


        // ==========================================
        // OPEN CUSTOMER REPORT PAGE
        // ==========================================

        request.getRequestDispatcher(
                "/WEB-INF/views/reports/customer-reports.jsp")
                .forward(request, response);
    }
}