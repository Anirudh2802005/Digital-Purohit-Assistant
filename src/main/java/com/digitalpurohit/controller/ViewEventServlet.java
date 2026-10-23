package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.EventSamagriDAO;
import com.digitalpurohit.dao.impl.CustomerDAOImpl;
import com.digitalpurohit.dao.impl.EventDAOImpl;
import com.digitalpurohit.dao.impl.EventSamagriDAOImpl;
import com.digitalpurohit.model.Customer;
import com.digitalpurohit.model.Event;
import com.digitalpurohit.model.Samagri;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/view-event")
public class ViewEventServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EventDAO eventDAO;
    private CustomerDAO customerDAO;
    private EventSamagriDAO eventSamagriDAO;

    @Override
    public void init() {

        eventDAO = new EventDAOImpl();

        customerDAO = new CustomerDAOImpl();

        eventSamagriDAO = new EventSamagriDAOImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

    	
    			String id = request.getParameter("id");

    	System.out.println("id = " + id);

    	if (id == null) {
    	    throw new ServletException("Parameter 'id' is missing");
    	}

    	int eventId = Integer.parseInt(id);

    	HttpSession session =
    	        request.getSession(false);

    	int adminId =
    	        (Integer) session.getAttribute("adminId");

    	Event event =
    	        eventDAO.getEventById(eventId, adminId);

    	if (event == null) {

    	    response.sendRedirect(
    	            request.getContextPath() + "/events");

    	    return;
    	}

    	Customer customer =
    	        customerDAO.getCustomerById(
    	                event.getCustomerId(),
    	                adminId);

        List<Samagri> samagriList =
                eventSamagriDAO.getEventSamagri(
                        eventId);

        request.setAttribute(
                "event",
                event);

        request.setAttribute(
                "customer",
                customer);

        request.setAttribute(
                "samagriList",
                samagriList);

        request.getRequestDispatcher(
                "/WEB-INF/views/event/event-details.jsp")
                .forward(request, response);
        
    }

}