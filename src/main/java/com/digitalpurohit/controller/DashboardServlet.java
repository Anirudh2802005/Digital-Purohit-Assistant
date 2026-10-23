package com.digitalpurohit.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.BulkEventDAO;
import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.EventTypeDAO;

import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.dao.impl.BulkEventDAOImpl;
import com.digitalpurohit.dao.impl.CustomerDAOImpl;
import com.digitalpurohit.dao.impl.EventDAOImpl;
import com.digitalpurohit.dao.impl.EventTypeDAOImpl;

import com.digitalpurohit.model.Event;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CustomerDAO customerDAO;
    private EventDAO eventDAO;
    private EventTypeDAO eventTypeDAO;
    private BulkEventDAO bulkEventDAO;
    private BulkEventCustomerDAO bulkEventCustomerDAO;

    @Override
    public void init() {

        customerDAO = new CustomerDAOImpl();
        eventDAO = new EventDAOImpl();
        eventTypeDAO = new EventTypeDAOImpl();
        bulkEventDAO = new BulkEventDAOImpl();
        bulkEventCustomerDAO = new BulkEventCustomerDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // SESSION / MULTI-USER SECURITY
        // ==========================================

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login");

            return;
        }

        int adminId =
                (Integer) session.getAttribute("adminId");


        // ==========================================
        // TODAY
        // ==========================================

        int todayEventCount =
                eventDAO.getTodayEventCount(adminId);

        int todayBulkEventCount =
                bulkEventDAO.getTodayBulkEventCount(adminId);

        double todayIncome =
                eventDAO.getTodayIncome(adminId);


        // ==========================================
        // MONTHLY INCOME
        // ==========================================

        double monthlyEventIncome =
                eventDAO.getMonthlyIncome(adminId);

        double monthlyBulkIncome =
                bulkEventDAO.getMonthlyBulkIncome(adminId);

        double totalMonthlyIncome =
                monthlyEventIncome +
                monthlyBulkIncome;


        // ==========================================
        // PENDING PAYMENTS
        // ==========================================

        double pendingIncome =
                eventDAO.getPendingIncome(adminId);

        int pendingPaymentCount =
                bulkEventCustomerDAO
                        .getPendingPaymentCount(adminId);


        // ==========================================
        // TODAY EVENTS
        // ==========================================

        List<Event> todayEvents =
                eventDAO.getTodayEvents(adminId);


        // ==========================================
        // TOMORROW EVENTS
        // ==========================================

        LocalDate tomorrow =
                LocalDate.now().plusDays(1);

        List<Event> tomorrowEvents =
                eventDAO.getEventsByDate(
                        java.sql.Date.valueOf(tomorrow),
                        adminId);


        // ==========================================
        // UPCOMING EVENTS
        // ==========================================

        List<Event> upcomingEvents =
                eventDAO.getUpcomingEvents(
                        7,
                        adminId);


        // ==========================================
        // RECENT PENDING PAYMENTS
        // ==========================================

        List<Event> pendingPayments =
                eventDAO.getPendingPaymentEvents(adminId);


        // ==========================================
        // DASHBOARD ATTRIBUTES
        // ==========================================

        request.setAttribute(
                "todayEventCount",
                todayEventCount);

        request.setAttribute(
                "todayBulkEventCount",
                todayBulkEventCount);

        request.setAttribute(
                "todayTotalEvents",
                todayEventCount +
                todayBulkEventCount);

        request.setAttribute(
                "todayIncome",
                todayIncome);

        request.setAttribute(
                "monthlyEventIncome",
                monthlyEventIncome);

        request.setAttribute(
                "monthlyBulkIncome",
                monthlyBulkIncome);

        request.setAttribute(
                "totalMonthlyIncome",
                totalMonthlyIncome);

        request.setAttribute(
                "pendingIncome",
                pendingIncome);

        request.setAttribute(
                "pendingPaymentCount",
                pendingPaymentCount);


        // ==========================================
        // EVENT LISTS
        // ==========================================

        request.setAttribute(
                "todayEvents",
                todayEvents);

        request.setAttribute(
                "tomorrowEvents",
                tomorrowEvents);

        request.setAttribute(
                "upcomingEvents",
                upcomingEvents);

        request.setAttribute(
                "pendingPayments",
                pendingPayments);


        // ==========================================
        // DATE / TIME
        // ==========================================

        LocalDate today =
                LocalDate.now();

        LocalTime now =
                LocalTime.now();

        request.setAttribute(
                "currentDate",
                today);

        request.setAttribute(
                "currentTime",
                now.withSecond(0)
                   .withNano(0));


        // ==========================================
        // USER INFORMATION
        // ==========================================

        request.setAttribute(
                "adminId",
                adminId);

        request.setAttribute(
                "adminName",
                session.getAttribute("adminName"));


        // ==========================================
        // FORWARD TO DASHBOARD
        // ==========================================

        request.getRequestDispatcher(
                "/WEB-INF/views/dashboard.jsp")
                .forward(request, response);
    }
}