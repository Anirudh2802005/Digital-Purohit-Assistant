package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.dao.impl.CustomerDAOImpl;
import com.digitalpurohit.model.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/view-customers")
public class ViewCustomerServlet extends HttpServlet {

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

        String keyword =
                request.getParameter("keyword");
        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");
        List<Customer> customers;

        if(keyword != null &&
           !keyword.trim().isEmpty()) {

        	customers =
        	        customerDAO.searchCustomers(
        	                keyword,
        	                adminId);
        }
        else {

        	customers =
        	        customerDAO.getAllCustomers(adminId);

        }

        request.setAttribute(
                "customers",
                customers);

        request.getRequestDispatcher(
                "/WEB-INF/views/customer/customer-list.jsp")
                .forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);

    }

}