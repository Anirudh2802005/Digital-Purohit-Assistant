package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.EventTypeDAO;
import com.digitalpurohit.dao.impl.EventTypeDAOImpl;
import com.digitalpurohit.model.EventType;
import com.digitalpurohit.model.Samagri;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/manage-eventtype-samagri")
public class ManageEventTypeSamagriServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EventTypeDAO eventTypeDAO;

    @Override
    public void init() throws ServletException {
        eventTypeDAO = new EventTypeDAOImpl();
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

        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view-event-types");
            return;
        }

        int typeId = Integer.parseInt(id);

        // ✅ Secure fetch
        EventType eventType =
                eventTypeDAO.getEventTypeById(typeId, adminId);

        if (eventType == null) {
            response.sendRedirect(request.getContextPath() + "/view-event-types");
            return;
        }

        // ✅ FIXED HERE (VERY IMPORTANT)
        List<Samagri> assignedSamagri =
                eventTypeDAO.getAssignedSamagri(typeId, adminId);

        List<Samagri> availableSamagri =
                eventTypeDAO.getAvailableSamagri(typeId, adminId);

        request.setAttribute("eventType", eventType);
        request.setAttribute("assignedSamagri", assignedSamagri);
        request.setAttribute("availableSamagri", availableSamagri);

        request.getRequestDispatcher(
                "/WEB-INF/views/eventtype/manage-eventtype-samagri.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        int typeId =
                Integer.parseInt(request.getParameter("typeId"));

        int samagriId =
                Integer.parseInt(request.getParameter("samagriId"));

        // ✅ Verify ownership
        EventType eventType =
                eventTypeDAO.getEventTypeById(typeId, adminId);

        if (eventType == null) {
            response.sendRedirect(request.getContextPath() + "/view-event-types");
            return;
        }

        boolean success =
                eventTypeDAO.assignSamagri(typeId, samagriId);

        if (success) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/manage-eventtype-samagri?id="
                            + typeId
                            + "&success=assigned");

        } else {

            response.sendRedirect(
                    request.getContextPath()
                            + "/manage-eventtype-samagri?id="
                            + typeId
                            + "&error=assign");
        }
    }
}