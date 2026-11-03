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

@WebServlet("/add-family")
public class AddFamilyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Validate the bulk event ID and pass it to the JSP as an Integer.
        String idParam = request.getParameter("bulkEventId");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Bulk Event ID is required.");
            return;
        }

        final Integer bulkEventId;
        try {
            bulkEventId = Integer.valueOf(idParam.trim());
            if (bulkEventId <= 0) {
                throw new NumberFormatException("ID must be positive");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid Bulk Event ID.");
            return;
        }

        // Get the authenticated admin ID from the session.
        HttpSession session = request.getSession(false);
        Object adminIdObject = session == null ? null : session.getAttribute("adminId");

        Integer adminId = parseAdminId(adminIdObject);
        if (adminId == null || adminId <= 0) {
            // Avoid loading another admin's customers through the DAO's
            // unscoped compatibility method.
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED,
                    "Your admin session has expired. Please log in again.");
            return;
        }

        // CustomerDAOImpl.getAllCustomers(adminId) filters by c.admin_id.
        List<Customer> customers = customerDAO.getAllCustomers(adminId);

        request.setAttribute("bulkEventId", bulkEventId);
        request.setAttribute("customers", customers);

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/family-form.jsp")
                .forward(request, response);
    }

    private Integer parseAdminId(Object value) {
        if (value instanceof Integer) {
            return (Integer) value;
        }
        if (value instanceof String) {
            try {
                return Integer.valueOf(((String) value).trim());
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        return null;
    }
}
