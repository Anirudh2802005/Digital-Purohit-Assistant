package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.EventTypeDAO;
import com.digitalpurohit.dao.impl.EventTypeDAOImpl;
import com.digitalpurohit.model.EventType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/view-event-types")
public class ViewEventTypesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EventTypeDAO eventTypeDAO;

    @Override
    public void init() throws ServletException {

        eventTypeDAO = new EventTypeDAOImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");

        List<EventType> eventTypes;

        if (keyword != null && !keyword.trim().isEmpty()) {

            eventTypes =
                    eventTypeDAO.searchEventTypes(
                            keyword,
                            adminId);

        } else {

            eventTypes =
                    eventTypeDAO.getAllEventTypes(
                            adminId);

        }

        request.setAttribute("eventTypes", eventTypes);

        request.getRequestDispatcher(
                "/WEB-INF/views/eventtype/eventtype-list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);

    }
}