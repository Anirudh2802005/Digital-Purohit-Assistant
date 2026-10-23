package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.dao.impl.CustomerDAOImpl;
import com.digitalpurohit.model.Customer;
import com.digitalpurohit.model.CustomerHistory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/customer-history")
public class CustomerHistoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CustomerDAO customerDAO;

    @Override
    public void init() {

        customerDAO = new CustomerDAOImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int customerId =
                Integer.parseInt(
                        request.getParameter("customerId"));
        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");
        Customer customer =
                customerDAO.getCustomerById(
                        customerId,
                        adminId);
        
        if (customer == null) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access Denied");

            return;
        }

        List<CustomerHistory> history =
                customerDAO.getCustomerHistory(customerId);

        int totalEvents = history.size();

        double totalAmount = 0;

        double amountPaid = 0;

        for(CustomerHistory h : history){

            totalAmount += h.getAmount();

            amountPaid += h.getAmountPaid();

        }

        double pendingAmount =
                totalAmount - amountPaid;

        request.setAttribute(
                "customer",
                customer);

        request.setAttribute(
                "history",
                history);

        request.setAttribute(
                "totalEvents",
                totalEvents);

        request.setAttribute(
                "totalAmount",
                totalAmount);

        request.setAttribute(
                "amountPaid",
                amountPaid);

        request.setAttribute(
                "pendingAmount",
                pendingAmount);

        request.getRequestDispatcher(
                "/WEB-INF/views/customer/customer-history.jsp")
                .forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);

    }
}