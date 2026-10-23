package com.digitalpurohit.controller;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.impl.EventDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/events")
public class EventDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EventDAO eventDAO;

    @Override
    public void init() {

        eventDAO = new EventDAOImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");

        request.setAttribute(
                "totalEvents",
                eventDAO.getTotalEvents(adminId));

        request.setAttribute(
                "todayEvents",
                eventDAO.getTodayEventCount(adminId));

        request.setAttribute(
                "upcomingEvents",
                eventDAO.getUpcomingEventsCount(adminId));

        request.setAttribute(
                "pendingPayments",
                eventDAO.getPendingPaymentsCount(adminId));

        request.getRequestDispatcher(
                "/WEB-INF/views/event/event-dashboard.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);

    }
}