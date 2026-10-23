package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.EventSamagriDAO;
import com.digitalpurohit.dao.impl.EventSamagriDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.digitalpurohit.dao.EventSamagriDAO;
import com.digitalpurohit.dao.impl.EventSamagriDAOImpl;
@WebServlet("/update-event-samagri")
public class UpdateEventSamagriServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EventSamagriDAO eventSamagriDAO;

    

    @Override
    public void init() throws ServletException {

        eventSamagriDAO = new EventSamagriDAOImpl();

    }
   

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int eventId =
                Integer.parseInt(
                        request.getParameter("eventId"));

        eventSamagriDAO.resetChecklist(
                eventId);

        String[] completed =
                request.getParameterValues(
                        "completedSamagri");

        if(completed != null){

            for(String samagriId : completed){

                eventSamagriDAO
                        .updateSamagriStatus(
                                eventId,
                                Integer.parseInt(samagriId),
                                true);

            }

        }

        response.sendRedirect(
        	    request.getContextPath()
        	    + "/view-event?id="
        	    + eventId
        	    + "&checklistSaved=true");

    }

}