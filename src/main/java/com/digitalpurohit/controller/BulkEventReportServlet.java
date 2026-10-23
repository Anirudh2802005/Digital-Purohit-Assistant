package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.model.BulkEventCustomer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/bulk-event-report")
public class BulkEventReportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BulkEventCustomerDAO bulkEventCustomerDAO;

    @Override
    public void init() {
        bulkEventCustomerDAO = new BulkEventCustomerDAOImpl();
    }

    
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("BulkEventReportServlet Executed");

        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");

        int bulkEventId =
                Integer.parseInt(
                        request.getParameter("bulkEventId"));

        int totalFamilies =
                bulkEventCustomerDAO.getTotalFamilies(
                        bulkEventId,
                        adminId);

        int paidFamilies =
                bulkEventCustomerDAO.getPaidFamilies(
                        bulkEventId,
                        adminId);

        int pendingFamilies =
                bulkEventCustomerDAO.getPendingFamilies(
                        bulkEventId,
                        adminId);

        List<BulkEventCustomer> families =
                bulkEventCustomerDAO.getFamilyDetails(
                        bulkEventId,
                        adminId);

        double totalAmount = 0;
        double collectedAmount = 0;
        double pendingAmount = 0;

        for (BulkEventCustomer family : families) {

            totalAmount += family.getTotalAmount();

            collectedAmount += family.getAmountPaid();

            pendingAmount +=
                    family.getTotalAmount()
                    - family.getAmountPaid();
        }

        request.setAttribute(
                "bulkEventId",
                bulkEventId);

        request.setAttribute(
                "totalFamilies",
                totalFamilies);

        request.setAttribute(
                "paidFamilies",
                paidFamilies);

        request.setAttribute(
                "pendingFamilies",
                pendingFamilies);

        request.setAttribute(
                "totalAmount",
                totalAmount);

        request.setAttribute(
                "collectedAmount",
                collectedAmount);

        request.setAttribute(
                "pendingAmount",
                pendingAmount);

        request.setAttribute(
                "families",
                families);

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/bulk-event-report.jsp")
                .forward(request, response);
    }
}