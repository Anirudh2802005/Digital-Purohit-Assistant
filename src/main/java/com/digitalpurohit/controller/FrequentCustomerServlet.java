package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.DashboardDAO;
import com.digitalpurohit.dao.impl.DashboardDAOImpl;
import com.digitalpurohit.model.FrequentCustomer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/frequent-customers")
public class FrequentCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DashboardDAO dashboardDAO;

    @Override
    public void init() {

        dashboardDAO = new DashboardDAOImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");

        List<FrequentCustomer> customers =
                dashboardDAO.getFrequentCustomers(adminId);

        request.setAttribute(
                "frequentCustomers",
                customers);

        request.getRequestDispatcher(
                "/WEB-INF/views/customer/frequent-customers.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}