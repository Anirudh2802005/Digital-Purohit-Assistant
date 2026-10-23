package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.EventTypeDAO;
import com.digitalpurohit.dao.impl.EventTypeDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/remove-eventtype-samagri")
public class RemoveEventTypeSamagriServlet extends HttpServlet {

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

        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");

        int typeId =
                Integer.parseInt(
                        request.getParameter("typeId"));

        int samagriId =
                Integer.parseInt(
                        request.getParameter("samagriId"));

        // Verify the Event Type belongs to the logged-in admin
        if (eventTypeDAO.getEventTypeById(
                typeId,
                adminId) == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/view-event-types");

            return;
        }

        boolean success =
                eventTypeDAO.removeAssignedSamagri(
                        typeId,
                        samagriId);

        if (success) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/manage-eventtype-samagri?id="
                    + typeId
                    + "&success=removed");

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/manage-eventtype-samagri?id="
                    + typeId
                    + "&error=remove");

        }
    }
}