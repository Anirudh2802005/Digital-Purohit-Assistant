package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.impl.EventDAOImpl;
import com.digitalpurohit.model.Event;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/event-pending-payments")
public class PendingEventPaymentsServlet extends HttpServlet {

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

        List<Event> events =
                eventDAO.getPendingPaymentEvents();

        request.setAttribute(
                "events",
                events);

        request.getRequestDispatcher(
                "/WEB-INF/views/event/event-pending-payments.jsp")
                .forward(request, response);
    }
}	