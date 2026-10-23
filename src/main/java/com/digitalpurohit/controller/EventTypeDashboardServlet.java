package com.digitalpurohit.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.digitalpurohit.dao.EventTypeDAO;
import com.digitalpurohit.dao.impl.EventTypeDAOImpl;

@WebServlet("/event-types")
public class EventTypeDashboardServlet extends HttpServlet {

    private EventTypeDAO eventTypeDAO;

    @Override
    public void init() {
        eventTypeDAO = new EventTypeDAOImpl();
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
    	        "totalEventTypes",
    	        eventTypeDAO.getEventTypeCount(adminId));

    	request.setAttribute(
    	        "activeEventTypes",
    	        eventTypeDAO.getActiveEventTypeCount(adminId));

    	request.setAttribute(
    	        "frequentlyUsed",
    	        eventTypeDAO.getFrequentlyUsedCount(adminId));

        request.getRequestDispatcher(
                "/WEB-INF/views/eventtype/eventtype-dashboard.jsp")
                .forward(request, response);
    }
}