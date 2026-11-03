package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.BulkEventDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.dao.impl.BulkEventDAOImpl;
import com.digitalpurohit.model.BulkEvent;
import com.digitalpurohit.model.BulkEventCustomer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/bulk-event-families")
public class BulkEventFamiliesServlet extends HttpServlet {

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

        String id = request.getParameter("bulkEventId");
        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");
        if (id == null || id.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/bulk-events");
            return;
        }

        int bulkEventId = Integer.parseInt(id);

        String keyword = request.getParameter("keyword");

        List<BulkEventCustomer> families;

        if (keyword != null && !keyword.trim().isEmpty()) {

        	families =
        	        bulkEventCustomerDAO.searchFamilies(
        	                bulkEventId,
        	                keyword,
        	                adminId);
        } else {

        	families =
        	        bulkEventCustomerDAO.getFamilyDetails(
        	                bulkEventId,
        	                adminId);

        }

        // Load Bulk Event
        BulkEvent event =
                bulkEventDAO.getBulkEventById(
                        bulkEventId,
                        adminId);
        
        if (event == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events");

            return;
        }
        if (event != null) {

        	event.setTotalFamilies(
        	        bulkEventCustomerDAO.getTotalFamilies(
        	                bulkEventId,
        	                adminId));

        	event.setPaidFamilies(
        	        bulkEventCustomerDAO.getPaidFamilies(
        	                bulkEventId,
        	                adminId));

        	event.setPendingFamilies(
        	        bulkEventCustomerDAO.getPendingFamilies(
        	                bulkEventId,
        	                adminId));

        	event.setTotalAmountCollected(
        	        bulkEventCustomerDAO.getTotalAmountCollected(
        	                bulkEventId,
        	                adminId));
        }

        request.setAttribute("event", event);

        request.setAttribute("bulkEventId", bulkEventId);

        request.setAttribute("families", families);

        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/bulk-event-families.jsp")
                .forward(request, response);

    }

}