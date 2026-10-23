package com.digitalpurohit.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.digitalpurohit.dao.IncomeReportDAO;
import com.digitalpurohit.dao.impl.IncomeReportDAOImpl;
import com.digitalpurohit.model.IncomeReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/income-reports")
public class IncomeReportsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private IncomeReportDAO incomeDAO;

    @Override
    public void init() {

        incomeDAO = new IncomeReportDAOImpl();
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
        // GET LOGGED-IN ADMIN
        // ==========================================

        int adminId =
                (Integer) session.getAttribute("adminId");


        // ==========================================
        // GET FILTER TYPE
        // ==========================================

        String type =
                request.getParameter("type");

        if (type == null ||
            type.trim().isEmpty()) {

            type = "today";
        }


        // ==========================================
        // CURRENT DATE
        // ==========================================

        LocalDate today =
                LocalDate.now();

        int currentYear =
                today.getYear();

        int currentMonth =
                today.getMonthValue();


        // ==========================================
        // REPORT DATA
        // ==========================================

        List<IncomeReport> reports =
                new ArrayList<>();


        // ==========================================
        // TODAY
        // ==========================================

        if ("today".equalsIgnoreCase(type)) {

            reports =
                    incomeDAO.getTodayIncome(
                            adminId);
        }


        // ==========================================
        // MONTH
        // ==========================================

        else if ("month".equalsIgnoreCase(type)) {

            reports =
                    incomeDAO.getMonthlyIncome(
                            currentMonth,
                            currentYear,
                            adminId);
        }


        // ==========================================
        // YEAR
        // ==========================================

        else if ("year".equalsIgnoreCase(type)) {

            reports =
                    incomeDAO.getYearlyIncome(
                            currentYear,
                            adminId);
        }


        // ==========================================
        // CUSTOM DATE RANGE
        // ==========================================

        else if ("custom".equalsIgnoreCase(type)) {

            String fromDateParam =
                    request.getParameter("fromDate");

            String toDateParam =
                    request.getParameter("toDate");


            if (fromDateParam != null &&
                !fromDateParam.isEmpty() &&
                toDateParam != null &&
                !toDateParam.isEmpty()) {

                try {

                    Date fromDate =
                            Date.valueOf(
                                    fromDateParam);

                    Date toDate =
                            Date.valueOf(
                                    toDateParam);

                    reports =
                            incomeDAO.getCustomIncome(
                                    fromDate,
                                    toDate,
                                    adminId);

                } catch (IllegalArgumentException e) {

                    reports =
                            new ArrayList<>();
                }
            }
        }


        // ==========================================
        // SUMMARY CALCULATIONS
        // ==========================================

        double receivedAmount = 0;
        double pendingAmount = 0;

        double todayIncome = 0;
        double monthlyIncome = 0;
        double yearlyIncome = 0;
        double customIncome = 0;


        // ==========================================
        // CURRENT REPORT TOTALS
        // ==========================================

        for (IncomeReport report : reports) {

            receivedAmount +=
                    report.getAmountPaid();

            pendingAmount +=
                    report.getPendingAmount();
        }


        // ==========================================
        // TODAY INCOME
        // ==========================================

        List<IncomeReport> todayReports =
                incomeDAO.getTodayIncome(
                        adminId);

        for (IncomeReport report :
                todayReports) {

            todayIncome +=
                    report.getAmountPaid();
        }


        // ==========================================
        // MONTHLY INCOME
        // ==========================================

        List<IncomeReport> monthlyReports =
                incomeDAO.getMonthlyIncome(
                        currentMonth,
                        currentYear,
                        adminId);

        for (IncomeReport report :
                monthlyReports) {

            monthlyIncome +=
                    report.getAmountPaid();
        }


        // ==========================================
        // YEARLY INCOME
        // ==========================================

        List<IncomeReport> yearlyReports =
                incomeDAO.getYearlyIncome(
                        currentYear,
                        adminId);

        for (IncomeReport report :
                yearlyReports) {

            yearlyIncome +=
                    report.getAmountPaid();
        }


        // ==========================================
        // CUSTOM INCOME
        // ==========================================

        if ("custom".equalsIgnoreCase(type)) {

            customIncome =
                    receivedAmount;
        }


        // ==========================================
        // PAYMENT STATUS
        // ==========================================

        Map<String, Integer> paymentStatus =
                new HashMap<>();

        paymentStatus.put("PAID", 0);
        paymentStatus.put("PARTIAL", 0);
        paymentStatus.put("PENDING", 0);


        for (IncomeReport report :
                reports) {

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
        // MONTHLY GRAPH
        // ==========================================

        List<String> graphLabels =
                incomeDAO.getMonthlyLabels(
                        currentYear,
                        adminId);

        List<Double> graphValues =
                incomeDAO.getMonthlyIncomeValues(
                        currentYear,
                        adminId);


        // ==========================================
        // EVENT TYPE GRAPH
        //
        // Your current IncomeReportDAO does not
        // provide event-type data.
        //
        // Therefore initialize empty lists
        // instead of inventing data.
        // ==========================================

     // ==========================================
     // EVENT TYPE GRAPH
     // ADMIN-SPECIFIC
     // ==========================================

     List<String> eventTypes =
             incomeDAO.getEventTypeLabels(
                     currentYear,
                     adminId);

     List<Double> eventIncome =
             incomeDAO.getEventTypeIncomeValues(
                     currentYear,
                     adminId);

        // ==========================================
        // SEND DATA TO JSP
        // ==========================================

        request.setAttribute(
                "reports",
                reports);

        request.setAttribute(
                "todayIncome",
                todayIncome);

        request.setAttribute(
                "monthlyIncome",
                monthlyIncome);

        request.setAttribute(
                "yearlyIncome",
                yearlyIncome);

        request.setAttribute(
                "customIncome",
                customIncome);

        request.setAttribute(
                "receivedAmount",
                receivedAmount);

        request.setAttribute(
                "pendingAmount",
                pendingAmount);

        request.setAttribute(
                "graphLabels",
                graphLabels);

        request.setAttribute(
                "graphValues",
                graphValues);

        request.setAttribute(
                "paymentStatus",
                paymentStatus);

        request.setAttribute(
                "eventTypes",
                eventTypes);

        request.setAttribute(
                "eventIncome",
                eventIncome);


        // ==========================================
        // FORWARD
        // ==========================================

        request.getRequestDispatcher(
                "/WEB-INF/views/reports/income-reports.jsp")
                .forward(request, response);
    }
}