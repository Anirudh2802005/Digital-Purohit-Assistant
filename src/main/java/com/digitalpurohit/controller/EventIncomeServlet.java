package com.digitalpurohit.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.digitalpurohit.dao.AnalyticsDAO;
import com.digitalpurohit.dao.IncomeReportDAO;
import com.digitalpurohit.dao.impl.AnalyticsDAOImpl;
import com.digitalpurohit.dao.impl.IncomeReportDAOImpl;
import com.digitalpurohit.model.IncomeReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/event-income")
public class EventIncomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private IncomeReportDAO incomeDAO;
    private AnalyticsDAO analyticsDAO;


    @Override
    public void init() {

        incomeDAO = new IncomeReportDAOImpl();
        analyticsDAO = new AnalyticsDAOImpl();

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
                    request.getContextPath() + "/login");

            return;
        }


        // ==========================================
        // LOGGED-IN ADMIN
        // ==========================================

        int adminId =
                (Integer) session.getAttribute("adminId");


        // ==========================================
        // REPORT TYPE
        // ==========================================

        String type =
                request.getParameter("type");

        if (type == null ||
            type.isBlank()) {

            type = "today";
        }


        List<IncomeReport> reports =
                new ArrayList<>();

        LocalDate today =
                LocalDate.now();


        // ==========================================
        // LOAD REPORT
        // ==========================================

        switch (type) {


            // ======================================
            // TODAY
            // ======================================

            case "today":

                reports =
                        incomeDAO.getTodayIncome(
                                adminId);

                break;


            // ======================================
            // MONTH
            // ======================================

            case "month":

                reports =
                        incomeDAO.getMonthlyIncome(
                                today.getMonthValue(),
                                today.getYear(),
                                adminId);

                break;


            // ======================================
            // YEAR
            // ======================================

            case "year":

                reports =
                        incomeDAO.getYearlyIncome(
                                today.getYear(),
                                adminId);

                break;


            // ======================================
            // CUSTOM DATE
            // ======================================

            case "custom":

                String from =
                        request.getParameter(
                                "fromDate");

                String to =
                        request.getParameter(
                                "toDate");


                if (from != null &&
                    to != null &&
                    !from.isBlank() &&
                    !to.isBlank()) {

                    reports =
                            incomeDAO.getCustomIncome(
                                    java.sql.Date.valueOf(from),
                                    java.sql.Date.valueOf(to),
                                    adminId);

                } else {

                    reports =
                            incomeDAO.getTodayIncome(
                                    adminId);

                    type = "today";
                }

                break;


            // ======================================
            // DEFAULT
            // ======================================

            default:

                reports =
                        incomeDAO.getTodayIncome(
                                adminId);

                type = "today";

                break;
        }


        // ==========================================
        // CALCULATE TOTALS
        // ==========================================

        double totalIncome = 0;
        double receivedAmount = 0;
        double pendingAmount = 0;


        for (IncomeReport report : reports) {

            totalIncome +=
                    report.getTotalAmount();

            receivedAmount +=
                    report.getAmountPaid();

            pendingAmount +=
                    report.getPendingAmount();
        }


        // ==========================================
        // FILTER-SPECIFIC INCOME
        // ==========================================

        double todayIncome = 0;
        double monthlyIncome = 0;
        double yearlyIncome = 0;
        double customIncome = 0;


        switch (type) {

            case "today":

                todayIncome =
                        totalIncome;

                break;


            case "month":

                monthlyIncome =
                        totalIncome;

                break;


            case "year":

                yearlyIncome =
                        totalIncome;

                break;


            case "custom":

                customIncome =
                        totalIncome;

                break;
        }


        // ==========================================
        // SEND SUMMARY DATA
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


        // ==========================================
        // GRAPH DATA
        // ==========================================

        List<String> graphLabels =
                new ArrayList<>();

        List<Double> graphValues =
                new ArrayList<>();


        // ==========================================
        // TODAY GRAPH
        // ==========================================

        if (type.equals("today")) {

            for (IncomeReport report :
                    reports) {

                graphLabels.add(
                        report.getEventTitle());

                graphValues.add(
                        report.getAmountPaid());
            }
        }


        // ==========================================
        // MONTH GRAPH
        // ==========================================

        else if (type.equals("month")) {

            Map<String, Double> map =
                    new LinkedHashMap<>();


            for (IncomeReport report :
                    reports) {

                String day =
                        String.valueOf(
                                report.getEventDate()
                                      .toLocalDate()
                                      .getDayOfMonth());


                map.put(
                        day,
                        map.getOrDefault(
                                day,
                                0.0)
                        + report.getAmountPaid());
            }


            graphLabels.addAll(
                    map.keySet());

            graphValues.addAll(
                    map.values());
        }


        // ==========================================
        // YEAR GRAPH
        // ==========================================

        else if (type.equals("year")) {

            Map<String, Double> map =
                    new LinkedHashMap<>();


            String[] months = {

                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "May",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Oct",
                "Nov",
                "Dec"
            };


            for (String month :
                    months) {

                map.put(
                        month,
                        0.0);
            }


            for (IncomeReport report :
                    reports) {

                int monthIndex =
                        report.getEventDate()
                              .toLocalDate()
                              .getMonthValue();


                String monthName =
                        months[monthIndex - 1];


                map.put(
                        monthName,
                        map.get(monthName)
                        + report.getAmountPaid());
            }


            graphLabels.addAll(
                    map.keySet());

            graphValues.addAll(
                    map.values());
        }


        // ==========================================
        // CUSTOM GRAPH
        // ==========================================

        else if (type.equals("custom")) {

            Map<String, Double> map =
                    new LinkedHashMap<>();


            for (IncomeReport report :
                    reports) {

                String date =
                        report.getEventDate()
                              .toString();


                map.put(
                        date,
                        map.getOrDefault(
                                date,
                                0.0)
                        + report.getAmountPaid());
            }


            graphLabels.addAll(
                    map.keySet());

            graphValues.addAll(
                    map.values());
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


        // ==========================================
        // ANALYTICS - MULTI USER
        // ==========================================

        request.setAttribute(
                "paymentStatus",
                analyticsDAO.getPaymentStatusCount(
                        adminId));


        request.setAttribute(
                "eventTypes",
                analyticsDAO.getEventTypeLabels(
                        adminId));


        request.setAttribute(
                "eventIncome",
                analyticsDAO.getEventTypeIncome(
                        adminId));


        // ==========================================
        // SELECTED FILTER
        // ==========================================

        request.setAttribute(
                "selectedType",
                type);


        // ==========================================
        // FORWARD TO JSP
        // ==========================================

        request.getRequestDispatcher(
                "/WEB-INF/views/reports/event-income.jsp")
                .forward(request, response);

    }
}