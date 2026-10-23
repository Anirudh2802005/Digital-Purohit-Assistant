package com.digitalpurohit.controller;

import java.io.IOException;
import jakarta.servlet.http.HttpSession;
import com.digitalpurohit.dao.DashboardDAO;
import com.digitalpurohit.dao.impl.DashboardDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/customers")
public class CustomerServlet extends HttpServlet {

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

        request.setAttribute(
                "totalCustomers",
                dashboardDAO.getTotalCustomerCount(adminId));

        request.setAttribute(
                "newCustomers",
                dashboardDAO.getNewCustomersThisMonth(adminId));

        request.setAttribute(
                "frequentCustomers",
                dashboardDAO.getFrequentCustomerCount(adminId));

        request.getRequestDispatcher(
                "/WEB-INF/views/customer/customer-dashboard.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);

    }
}