package com.digitalpurohit.controller;

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
import jakarta.servlet.http.HttpSession;

@WebServlet("/view-bulk-events")
public class BulkEventListServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BulkEventDAO bulkEventDAO;

    @Override
    public void init() {
        bulkEventDAO = new BulkEventDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 🔒 Session check
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        // ✅ Fetch only this admin's data
        List<BulkEvent> bulkEvents =
                bulkEventDAO.getAllBulkEvents(adminId);

        request.setAttribute("bulkEvents", bulkEvents);

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/bulk-event-list.jsp")
                .forward(request, response);
    }
}