package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.digitalpurohit.dao.CustomerReportDAO;
import com.digitalpurohit.dao.impl.CustomerReportDAOImpl;
import com.digitalpurohit.model.BulkEventCustomer;
import com.digitalpurohit.model.CustomerReportDetails;
import com.digitalpurohit.model.Event;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/customer-report-details")
public class CustomerReportDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CustomerReportDAO dao;

    @Override
    public void init() {

        dao = new CustomerReportDAOImpl();
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
        // GET CUSTOMER ID
        // ==========================================

        String customerIdParam =
                request.getParameter("customerId");

        if (customerIdParam == null ||
            customerIdParam.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/customer-reports");

            return;
        }


        int customerId;

        try {

            customerId =
                    Integer.parseInt(customerIdParam);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/customer-reports");

            return;
        }


        // ==========================================
        // GET CUSTOMER DETAILS
        // ADMIN-SPECIFIC
        // ==========================================

        CustomerReportDetails customer =
                dao.getCustomerDetails(
                        customerId,
                        adminId);


        // ==========================================
        // CUSTOMER DOES NOT BELONG TO THIS ADMIN
        // ==========================================

        if (customer == null ||
            customer.getCustomerId() == 0) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/customer-reports");

            return;
        }


        // ==========================================
        // GET CUSTOMER EVENTS
        // ADMIN-SPECIFIC
        // ==========================================

        List<Event> events =
                dao.getCustomerEvents(
                        customerId,
                        adminId);


        // ==========================================
        // GET CUSTOMER BULK EVENTS
        // ADMIN-SPECIFIC
        // ==========================================

        List<BulkEventCustomer> bulkEvents =
                dao.getCustomerBulkEvents(
                        customerId,
                        adminId);


        // ==========================================
        // SEND DATA TO JSP
        // ==========================================

        request.setAttribute(
                "customer",
                customer);

        request.setAttribute(
                "events",
                events);

        request.setAttribute(
                "bulkEvents",
                bulkEvents);


        // ==========================================
        // BAR CHART DATA
        // ==========================================

        List<String> graphLabels =
                new ArrayList<>();

        List<Double> graphValues =
                new ArrayList<>();


        // Normal events

        for (Event event : events) {

            graphLabels.add(
                    event.getEventTitle());

            graphValues.add(
                    event.getAmountPaid());
        }


        // Bulk events

        for (BulkEventCustomer bulk : bulkEvents) {

            graphLabels.add(
                    bulk.getBulkEventName());

            graphValues.add(
                    bulk.getAmountPaid());
        }


        request.setAttribute(
                "graphLabels",
                graphLabels);

        request.setAttribute(
                "graphValues",
                graphValues);


        // ==========================================
        // PAYMENT STATUS
        // ==========================================

        Map<String, Integer> paymentStatus =
                new HashMap<>();

        paymentStatus.put("PAID", 0);
        paymentStatus.put("PARTIAL", 0);
        paymentStatus.put("PENDING", 0);


        // Normal events

        for (Event event : events) {

            String status =
                    event.getPaymentStatus();

            if (status != null &&
                paymentStatus.containsKey(status)) {

                paymentStatus.put(
                        status,
                        paymentStatus.get(status) + 1);
            }
        }


        // Bulk events

        for (BulkEventCustomer bulk : bulkEvents) {

            String status =
                    bulk.getPaymentStatus();

            if (status != null &&
                paymentStatus.containsKey(status)) {

                paymentStatus.put(
                        status,
                        paymentStatus.get(status) + 1);
            }
        }


        request.setAttribute(
                "paymentStatus",
                paymentStatus);


        // ==========================================
        // FORWARD TO DETAILS PAGE
        // ==========================================

        request.getRequestDispatcher(
                "/WEB-INF/views/reports/customer-report-details.jsp")
                .forward(request, response);
    }
}