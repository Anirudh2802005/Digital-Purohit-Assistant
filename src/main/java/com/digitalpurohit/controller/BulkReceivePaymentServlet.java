
package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.model.BulkEventCustomer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/bulk-receive-payment")
public class BulkReceivePaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BulkEventCustomerDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new BulkEventCustomerDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check whether the admin session exists
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        // 2. Validate the admin ID stored in the session
        Object adminIdObject = session.getAttribute("adminId");

        int adminId;

        try {
            if (adminIdObject instanceof Integer) {
                adminId = (Integer) adminIdObject;
            } else {
                adminId = Integer.parseInt(adminIdObject.toString());
            }
        } catch (NumberFormatException e) {
            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        // 3. Read and validate the family/customer ID
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Missing required parameter: id");
            return;
        }

        int id;

        try {
            id = Integer.parseInt(idParam.trim());

            if (id <= 0) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid customer ID");
                return;
            }

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Customer ID must be a valid number");
            return;
        }

        // 4. Retrieve the family/customer record
        BulkEventCustomer family = dao.getFamilyById(id, adminId);

        if (family == null) {
            response.sendRedirect(
                    request.getContextPath() + "/bulk-events");
            return;
        }

        // 5. Set attributes required by the JSP
        request.setAttribute("family", family);

        // 6. Forward to the Receive Payment page
        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/receive-payment.jsp")
                .forward(request, response);
    }
}
