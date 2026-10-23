package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.BulkEventDAO;
import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.impl.BulkEventDAOImpl;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.model.BulkEvent;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/bulk-event-details")
public class BulkEventDetailsServlet extends HttpServlet {

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

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        int bulkEventId =
                Integer.parseInt(request.getParameter("id"));

        // ✅ Get event (ADMIN SAFE)
        BulkEvent event =
                bulkEventDAO.getBulkEventById(
                        bulkEventId,
                        adminId);

        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/bulk-events");
            return;
        }

        // ✅ Set additional details
        event.setTotalFamilies(
                bulkEventCustomerDAO.getTotalFamilies(bulkEventId));

        event.setPaidFamilies(
                bulkEventCustomerDAO.getPaidFamilies(bulkEventId));

        event.setPendingFamilies(
                bulkEventCustomerDAO.getPendingFamilies(bulkEventId));

        event.setTotalAmountCollected(
                bulkEventCustomerDAO.getTotalAmountCollected(bulkEventId));

        // ✅ Set attributes
        request.setAttribute("bulkEvent", event);

        request.setAttribute("familyCount",
                bulkEventCustomerDAO
                        .getCustomersByBulkEvent(bulkEventId)
                        .size());

        request.setAttribute("amountCollected",
                bulkEventCustomerDAO
                        .getTotalAmountCollected(bulkEventId));

        // ✅ ONLY ONE FORWARD
        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/bulk-event-details.jsp")
                .forward(request, response);
    }
}