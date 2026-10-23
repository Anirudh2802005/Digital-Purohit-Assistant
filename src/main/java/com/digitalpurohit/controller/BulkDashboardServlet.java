package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.BulkEventDAO;
import com.digitalpurohit.dao.impl.BulkEventDAOImpl;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/bulk-dashboard")
public class BulkDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BulkEventDAO bulkEventDAO = new BulkEventDAOImpl();
    private BulkEventCustomerDAO customerDAO = new BulkEventCustomerDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

    	HttpSession session =
    	        request.getSession(false);

    	int adminId =
    	        (Integer) session.getAttribute("adminId");

    	System.out.println("Logged in Admin ID = " + adminId);

    	System.out.println("Bulk Count = "
    	        + bulkEventDAO.getBulkEventCount(adminId));

    	System.out.println("Today Count = "
    	        + bulkEventDAO.getTodayBulkEventCount(adminId));

    	System.out.println("Monthly Income = "
    	        + bulkEventDAO.getMonthlyBulkIncome(adminId));

    	request.setAttribute(
    	        "totalBulkEvents",
    	        bulkEventDAO.getBulkEventCount(adminId));

        request.setAttribute(
                "totalBulkEvents",
                bulkEventDAO.getBulkEventCount(adminId));

        request.setAttribute(
                "todayBulkEvents",
                bulkEventDAO.getTodayBulkEventCount(adminId));

        request.setAttribute(
                "monthlyIncome",
                bulkEventDAO.getMonthlyBulkIncome(adminId));

        request.setAttribute(
                "pendingPayments",
                customerDAO.getPendingPaymentCount(adminId));

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/bulk-dashboard.jsp")
                .forward(request, response);
    }
}