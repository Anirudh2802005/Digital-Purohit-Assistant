package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.model.BulkEventCustomer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/link-family")
public class LinkFamilyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BulkEventCustomerDAO bulkEventCustomerDAO;

    @Override
    public void init() {
        bulkEventCustomerDAO = new BulkEventCustomerDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int bulkEventId =
                Integer.parseInt(request.getParameter("bulkEventId"));

        int customerId =
                Integer.parseInt(request.getParameter("customerId"));

        BulkEventCustomer bulkEventCustomer =
                new BulkEventCustomer();

        bulkEventCustomer.setBulkEventId(bulkEventId);
        bulkEventCustomer.setCustomerId(customerId);
        double totalAmount =
                Double.parseDouble(
                        request.getParameter("totalAmount"));

        bulkEventCustomer.setTotalAmount(totalAmount);

        bulkEventCustomer.setAmountPaid(0);

        bulkEventCustomer.setPaymentStatus("PENDING");

        bulkEventCustomer.setNotes("");

        if (bulkEventCustomerDAO.existsInBulkEvent(
                bulkEventId,
                customerId)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-event-details?id="
                    + bulkEventId
                    + "&message=duplicate");

            return;
        }

        bulkEventCustomerDAO.addCustomerToBulkEvent(
                bulkEventCustomer);

        response.sendRedirect(
                request.getContextPath()
                + "/bulk-event-details?id="
                + bulkEventId
                + "&message=added");
    }
}