package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.BulkEventIncomeDAO;
import com.digitalpurohit.dao.impl.BulkEventIncomeDAOImpl;
import com.digitalpurohit.model.BulkEventIncomeReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/bulk-event-income")
public class BulkEventIncomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BulkEventIncomeDAO incomeDAO;


    @Override
    public void init() {

        incomeDAO =
                new BulkEventIncomeDAOImpl();
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
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
                    request.getContextPath()
                    + "/login");

            return;
        }


        // ==========================================
        // LOGGED-IN ADMIN
        // ==========================================

        int adminId =
                (Integer)
                session.getAttribute("adminId");


        // ==========================================
        // BULK EVENT REPORTS
        // ==========================================

        List<BulkEventIncomeReport> reports =
                incomeDAO.getAllBulkEventIncome(
                        adminId);


        request.setAttribute(
                "reports",
                reports);


        // ==========================================
        // SUMMARY
        // ==========================================

        request.setAttribute(
                "totalBulkEvents",
                incomeDAO.getTotalBulkEvents(
                        adminId));


        request.setAttribute(
                "totalFamilies",
                incomeDAO.getTotalFamilies(
                        adminId));


        request.setAttribute(
                "totalAmount",
                incomeDAO.getTotalAmount(
                        adminId));


        request.setAttribute(
                "receivedAmount",
                incomeDAO.getReceivedAmount(
                        adminId));


        request.setAttribute(
                "pendingAmount",
                incomeDAO.getPendingAmount(
                        adminId));


        // ==========================================
        // FORWARD
        // ==========================================

        request.getRequestDispatcher(
                "/WEB-INF/views/reports/bulk-event-income.jsp")
                .forward(request, response);
    }
}