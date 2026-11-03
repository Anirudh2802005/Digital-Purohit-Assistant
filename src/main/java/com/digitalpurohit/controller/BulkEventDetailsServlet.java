package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

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
    public void init() throws ServletException {
        bulkEventDAO = new BulkEventDAOImpl();
        bulkEventCustomerDAO = new BulkEventCustomerDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * STEP 1: Check whether the admin is logged in.
         */
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        /*
         * STEP 2: Validate the admin ID stored in the session.
         */
        int adminId;

        try {
            Object adminIdObject = session.getAttribute("adminId");

            if (adminIdObject == null) {
                response.sendRedirect(
                        request.getContextPath() + "/login");
                return;
            }

            if (adminIdObject instanceof Number) {
                adminId = ((Number) adminIdObject).intValue();
            } else {
                adminId = Integer.parseInt(
                        adminIdObject.toString().trim());
            }

            if (adminId <= 0) {
                session.invalidate();

                response.sendRedirect(
                        request.getContextPath() + "/login");
                return;
            }

        } catch (NumberFormatException e) {
            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        /*
         * STEP 3: Read the bulk event ID from the URL.
         *
         * Expected URL:
         * /bulk-event-details?id=5
         *
         * The number 5 is only an example.
         */
        String idParameter = request.getParameter("id");

        if (idParameter == null || idParameter.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/bulk-events");
            return;
        }

        /*
         * STEP 4: Validate the bulk event ID.
         */
        int bulkEventId;

        try {
            bulkEventId = Integer.parseInt(idParameter.trim());

            if (bulkEventId <= 0) {
                response.sendRedirect(
                        request.getContextPath() + "/bulk-events");
                return;
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/bulk-events");
            return;
        }

        /*
         * STEP 5: Retrieve the bulk event.
         *
         * The DAO should check both the event ID and admin ID
         * so one admin cannot access another admin's event.
         */
        BulkEvent event;

        try {
            event = bulkEventDAO.getBulkEventById(
                    bulkEventId,
                    adminId);

        } catch (RuntimeException e) {
            log("Failed to retrieve bulk event. Event ID: "
                    + bulkEventId + ", Admin ID: " + adminId, e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to retrieve bulk event details.");
            return;
        }

        /*
         * STEP 6: Redirect if the event does not exist
         * or is not accessible to the logged-in admin.
         */
        if (event == null) {
            response.sendRedirect(
                    request.getContextPath() + "/bulk-events");
            return;
        }

        /*
         * STEP 7: Load family and payment statistics.
         */
        try {
            event.setTotalFamilies(
                    bulkEventCustomerDAO.getTotalFamilies(
                            bulkEventId));

            event.setPaidFamilies(
                    bulkEventCustomerDAO.getPaidFamilies(
                            bulkEventId));

            event.setPendingFamilies(
                    bulkEventCustomerDAO.getPendingFamilies(
                            bulkEventId));

            event.setTotalAmountCollected(
                    bulkEventCustomerDAO.getTotalAmountCollected(
                            bulkEventId));

            /*
             * Retrieve the customers associated with this event.
             */
            List<?> customers =
                    bulkEventCustomerDAO.getCustomersByBulkEvent(
                            bulkEventId);

            /*
             * STEP 8: Set attributes for the details JSP.
             */
            request.setAttribute("bulkEvent", event);

            request.setAttribute(
                    "familyCount",
                    customers == null ? 0 : customers.size());

            request.setAttribute(
                    "amountCollected",
                    bulkEventCustomerDAO.getTotalAmountCollected(
                            bulkEventId));

        } catch (RuntimeException e) {
            log("Failed to load bulk event statistics. Event ID: "
                    + bulkEventId, e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load bulk event statistics.");
            return;
        }

        /*
         * STEP 9: Forward to the existing bulk event details JSP.
         *
         * Do not redirect here because the request attributes
         * must remain available to the JSP.
         */
        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/bulk-event-details.jsp")
                .forward(request, response);
    }
}