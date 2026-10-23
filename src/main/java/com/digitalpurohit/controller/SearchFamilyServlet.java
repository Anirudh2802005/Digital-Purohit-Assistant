package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.dao.impl.CustomerDAOImpl;
import com.digitalpurohit.model.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/search-family")
public class SearchFamilyServlet extends HttpServlet {

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

        String phone = request.getParameter("phone");
        String bulkEventId = request.getParameter("bulkEventId");

        Customer customer = customerDAO.getCustomerByPhone(phone);

        request.setAttribute("bulkEventId", bulkEventId);
        request.setAttribute("searchedCustomer", customer);

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/family-form.jsp")
                .forward(request, response);
    }
}