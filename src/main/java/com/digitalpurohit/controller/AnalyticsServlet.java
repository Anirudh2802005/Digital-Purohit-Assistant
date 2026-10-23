package com.digitalpurohit.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import com.digitalpurohit.dao.AnalyticsDAO;
import com.digitalpurohit.dao.impl.AnalyticsDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/analytics")
public class AnalyticsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AnalyticsDAO analyticsDAO;

    @Override
    public void init() {

        analyticsDAO = new AnalyticsDAOImpl();

    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // GET LOGGED-IN ADMIN
        // ==========================================

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login");

            return;
        }

        int adminId =
                (Integer) session.getAttribute("adminId");


        // ==========================================
        // CURRENT YEAR
        // ==========================================

        int year =
                LocalDate.now().getYear();


        // ==========================================
        // MONTHLY INCOME
        // ==========================================

        List<String> monthlyLabels =
                analyticsDAO.getMonthlyLabels(
                        year,
                        adminId);


        List<Double> monthlyIncome =
                analyticsDAO.getMonthlyIncome(
                        year,
                        adminId);


        // ==========================================
        // PAYMENT STATUS
        // ==========================================

        Map<String, Integer> paymentStatus =
                analyticsDAO.getPaymentStatusCount(
                        adminId);


        // ==========================================
        // EVENT TYPES
        // ==========================================

        List<String> eventTypes =
                analyticsDAO.getEventTypeLabels(
                        adminId);


        List<Double> eventIncome =
                analyticsDAO.getEventTypeIncome(
                        adminId);


        // ==========================================
        // SEND DATA TO JSP
        // ==========================================

        request.setAttribute(
                "monthlyLabels",
                monthlyLabels);

        request.setAttribute(
                "monthlyIncome",
                monthlyIncome);

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
                "/WEB-INF/views/reports/analytics.jsp")
                .forward(request, response);
    }
}