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

@WebServlet("/bulk-event-family-view")
public class ViewBulkFamilyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BulkEventCustomerDAO dao;

    @Override
    public void init() {

        dao = new BulkEventCustomerDAOImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        BulkEventCustomer family =
                dao.getFamilyById(id);

        if (family == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events");

            return;
        }

        request.setAttribute("family", family);

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/family-view.jsp")
                .forward(request, response);
    }
}