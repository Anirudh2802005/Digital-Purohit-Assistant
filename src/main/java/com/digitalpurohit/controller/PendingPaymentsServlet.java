package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.dao.impl.EventDAOImpl;
import com.digitalpurohit.model.BulkEventCustomer;
import com.digitalpurohit.model.Event;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/pending-payments")
public class PendingPaymentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EventDAO eventDAO;
    private BulkEventCustomerDAO bulkEventCustomerDAO;

    @Override
    public void init() {

        eventDAO = new EventDAOImpl();
        bulkEventCustomerDAO = new BulkEventCustomerDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");

        List<Event> eventPayments =
                eventDAO.getPendingPaymentEventsByAdmin(
                        adminId);

        List<BulkEventCustomer> bulkPayments =
                bulkEventCustomerDAO.getPendingPayments(
                        adminId);

        request.setAttribute(
                "eventPayments",
                eventPayments);

        request.setAttribute(
                "bulkPayments",
                bulkPayments);

        request.getRequestDispatcher(
                "/WEB-INF/views/pending-payments.jsp")
                .forward(request, response);
    }
}