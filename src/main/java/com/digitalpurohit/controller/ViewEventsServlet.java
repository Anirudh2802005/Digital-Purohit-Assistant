package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.impl.EventDAOImpl;
import com.digitalpurohit.model.Event;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/view-events")
public class ViewEventsServlet extends HttpServlet {

    private EventDAO eventDAO;

    @Override
    public void init() {
        eventDAO = new EventDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String filter = request.getParameter("filter");
        System.out.println("Filter = " + filter);
        String eventTypeId =
                request.getParameter("eventTypeId");
        
        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");

        List<Event> events = new java.util.ArrayList<>();

        if (eventTypeId != null && !eventTypeId.isBlank()) {

        	events =
        	        eventDAO.getEventsByType(
        	                Integer.parseInt(eventTypeId),
        	                adminId);

        } else if (keyword != null && !keyword.trim().isEmpty()) {

        	events =
        	        eventDAO.searchEvents(
        	                keyword,
        	                adminId);

        } else if ("today".equals(filter)) {

        	events =
        	        eventDAO.getTodayEvents(adminId);

        } else if ("upcoming".equals(filter)) {

        	events =
        	        eventDAO.getUpcomingEventsByAdmin(adminId);
        } else if ("pending".equals(filter)) {

        	System.out.println(eventDAO.getClass().getName());

        	events =
        	        eventDAO.getPendingPaymentEvents(adminId);

        	System.out.println("Events Size = " + events.size());
        } else {

        	events =
        	        eventDAO.getAllEvents(adminId);

        }

        request.setAttribute("events", events);
        request.setAttribute("selectedFilter", filter);
        request.getRequestDispatcher(
                "/WEB-INF/views/event/event-list.jsp")
                .forward(request, response);
    }
}