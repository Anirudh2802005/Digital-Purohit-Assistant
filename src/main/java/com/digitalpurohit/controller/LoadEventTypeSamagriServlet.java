package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.EventTypeDAO;
import com.digitalpurohit.dao.EventTypeSamagriDAO;
import com.digitalpurohit.dao.impl.EventTypeDAOImpl;
import com.digitalpurohit.dao.impl.EventTypeSamagriDAOImpl;
import com.digitalpurohit.model.Samagri;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/load-event-type-samagri")
public class LoadEventTypeSamagriServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EventTypeSamagriDAO dao;

    @Override
    public void init() {
        dao = new EventTypeSamagriDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");

        String typeIdParam =
                request.getParameter("typeId");

        if (typeIdParam == null ||
            typeIdParam.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "typeId is required");

            return;
        }

        int typeId =
                Integer.parseInt(typeIdParam);

        EventTypeDAO eventTypeDAO =
                new EventTypeDAOImpl();

        if (eventTypeDAO.getEventTypeById(
                typeId,
                adminId) == null) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access Denied");

            return;
        }

        List<Samagri> samagriList =
                dao.getSamagriByEventType(typeId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Gson gson = new Gson();

        response.getWriter().write(
                gson.toJson(samagriList));
    }
}