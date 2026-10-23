package com.digitalpurohit.controller;
import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.impl.EventDAOImpl;
import java.io.IOException;

import com.digitalpurohit.dao.EventTypeDAO;
import com.digitalpurohit.dao.impl.EventTypeDAOImpl;
import com.digitalpurohit.model.EventType;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/event-type-details")
public class EventTypeDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EventTypeDAO eventTypeDAO;
    private EventDAO eventDAO;

    @Override
    public void init() {

        eventTypeDAO = new EventTypeDAOImpl();

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

        String id =
                request.getParameter("id");

        if (id == null || id.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/view-event-types");

            return;
        }

        int typeId =
                Integer.parseInt(id);

        EventType eventType =
                eventTypeDAO.getEventTypeById(
                        typeId,
                        adminId);

        if (eventType == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/view-event-types");

            return;
        }

        int eventCount =
                eventDAO.getEventCountByType(
                        typeId,
                        adminId);

        int samagriCount =
                eventTypeDAO.getAssignedSamagriCount(
                        typeId);

        double totalIncome =
                eventDAO.getTotalIncomeByType(
                        typeId,
                        adminId);

        request.setAttribute(
                "eventType",
                eventType);

        request.setAttribute(
                "eventCount",
                eventCount);

        request.setAttribute(
                "samagriCount",
                samagriCount);

        request.setAttribute(
                "totalIncome",
                totalIncome);

        request.getRequestDispatcher(
                "/WEB-INF/views/eventtype/eventtype-details.jsp")
                .forward(request, response);
    }
}