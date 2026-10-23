package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.model.BulkEventCustomer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/bulk-event-payments")
public class BulkEventPaymentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BulkEventCustomerDAO bulkEventCustomerDAO;

    @Override
    public void init() {
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

        int bulkEventId =
                Integer.parseInt(
                        request.getParameter("bulkEventId"));

        List<BulkEventCustomer> families =
                bulkEventCustomerDAO.getFamilyDetails(
                        bulkEventId,
                        adminId);

        request.setAttribute(
                "bulkEventId",
                bulkEventId);

        request.setAttribute(
                "families",
                families);

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/bulk-event-payments.jsp")
                .forward(request, response);
    }
}