package com.digitalpurohit.controller;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.BulkEventDAO;
import com.digitalpurohit.dao.impl.BulkEventDAOImpl;
import com.digitalpurohit.model.BulkEvent;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
@WebServlet("/bulk-events")
public class BulkEventServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BulkEventDAO bulkEventDAO;
    
    private BulkEventCustomerDAO bulkEventCustomerDAO;

    @Override
    public void init() {

        bulkEventDAO = new BulkEventDAOImpl();
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

        List<BulkEvent> bulkEvents =
                bulkEventDAO.getAllBulkEvents(adminId);

        for (BulkEvent event : bulkEvents) {

            int id = event.getYatraId();

            event.setTotalFamilies(
                    bulkEventCustomerDAO.getTotalFamilies(id));

            event.setPaidFamilies(
                    bulkEventCustomerDAO.getPaidFamilies(id));

            event.setPendingFamilies(
                    bulkEventCustomerDAO.getPendingFamilies(id));

            event.setTotalAmountCollected(
                    bulkEventCustomerDAO.getTotalAmountCollected(id));
        }

        request.setAttribute(
                "bulkEvents",
                bulkEvents);

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/bulk-event-list.jsp")
                .forward(request, response);
    }
}