package com.digitalpurohit.controller;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.digitalpurohit.dao.ReportsDAO;
import com.digitalpurohit.dao.impl.ReportsDAOImpl;
import com.digitalpurohit.model.DashboardReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reports")
public class ReportsDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ReportsDAO reportsDAO;

    @Override
    public void init() {

        reportsDAO = new ReportsDAOImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // SESSION CHECK
        // ==========================================

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login");

            return;
        }


        // ==========================================
        // GET LOGGED-IN ADMIN ID
        // ==========================================

        int adminId =
                (Integer) session.getAttribute("adminId");


        // ==========================================
        // GET ADMIN-SPECIFIC REPORT
        // ==========================================

        DashboardReport report =
                reportsDAO.getDashboardReport(adminId);


        // ==========================================
        // SEND REPORT TO JSP
        // ==========================================

        request.setAttribute(
                "report",
                report);


        // ==========================================
        // OPEN REPORTS DASHBOARD
        // ==========================================

        request.getRequestDispatcher(
                "/WEB-INF/views/reports/reports-dashboard.jsp")
                .forward(request, response);
    }
}