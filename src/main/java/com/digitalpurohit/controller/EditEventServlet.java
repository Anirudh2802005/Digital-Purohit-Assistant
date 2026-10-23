package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.EventTypeDAO;

import com.digitalpurohit.dao.impl.CustomerDAOImpl;
import com.digitalpurohit.dao.impl.EventDAOImpl;
import com.digitalpurohit.dao.impl.EventTypeDAOImpl;

import com.digitalpurohit.model.Customer;
import com.digitalpurohit.model.Event;
import com.digitalpurohit.model.EventType;

import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;

import com.digitalpurohit.util.Toast;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/edit-event")
public class EditEventServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAOs
    // =========================================================

    private EventDAO eventDAO;

    private CustomerDAO customerDAO;

    private EventTypeDAO eventTypeDAO;


    // =========================================================
    // NOTIFICATION SERVICE
    // =========================================================

    private NotificationService notificationService;


    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

        eventDAO =
                new EventDAOImpl();

        customerDAO =
                new CustomerDAOImpl();

        eventTypeDAO =
                new EventTypeDAOImpl();

        notificationService =
                new NotificationServiceImpl();
    }


    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // -----------------------------------------------------
        // SESSION CHECK
        // -----------------------------------------------------

        HttpSession session =
                request.getSession(false);


        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );

            return;
        }


        // -----------------------------------------------------
        // CURRENT ADMIN
        // -----------------------------------------------------

        int adminId =
                (Integer) session.getAttribute(
                        "adminId"
                );


        // -----------------------------------------------------
        // GET EVENT ID
        // -----------------------------------------------------

        String eventIdParameter =
                request.getParameter("id");


        if (eventIdParameter == null ||
            eventIdParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Event ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


        int eventId;

        try {

            eventId =
                    Integer.parseInt(
                            eventIdParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid Event ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


        // -----------------------------------------------------
        // FETCH EVENT FOR CURRENT ADMIN
        // -----------------------------------------------------

        Event event =
                eventDAO.getEventById(
                        eventId,
                        adminId
                );


        if (event == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Event not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


        // -----------------------------------------------------
        // FETCH CUSTOMERS
        // -----------------------------------------------------

        List<Customer> customers =
                customerDAO.getAllCustomers(
                        adminId
                );


        // -----------------------------------------------------
        // FETCH EVENT TYPES
        // -----------------------------------------------------

        List<EventType> eventTypes =
                eventTypeDAO.getAllEventTypes(
                        adminId
                );


        // -----------------------------------------------------
        // SET ATTRIBUTES
        // -----------------------------------------------------

        request.setAttribute(
                "event",
                event
        );


        request.setAttribute(
                "customers",
                customers
        );


        request.setAttribute(
                "eventTypes",
                eventTypes
        );


        // -----------------------------------------------------
        // FORWARD
        // -----------------------------------------------------

        request.getRequestDispatcher(
                "/WEB-INF/views/event/event-form.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // -----------------------------------------------------
        // SESSION CHECK
        // -----------------------------------------------------

        HttpSession session =
                request.getSession(false);


        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );

            return;
        }


        // -----------------------------------------------------
        // CURRENT ADMIN
        // -----------------------------------------------------

        int adminId =
                (Integer) session.getAttribute(
                        "adminId"
                );


        // =====================================================
        // GET EVENT ID
        // =====================================================

        String eventIdParameter =
                request.getParameter(
                        "eventId"
                );


        if (eventIdParameter == null ||
            eventIdParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Event ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


        int eventId;

        try {

            eventId =
                    Integer.parseInt(
                            eventIdParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid Event ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


        // =====================================================
        // VERIFY EXISTING EVENT OWNERSHIP
        // =====================================================

        Event existingEvent =
                eventDAO.getEventById(
                        eventId,
                        adminId
                );


        if (existingEvent == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Event not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


        // =====================================================
        // CREATE UPDATED EVENT
        // =====================================================

        Event event =
                new Event();


        event.setEventId(
                eventId
        );


        event.setCustomerId(
                Integer.parseInt(
                        request.getParameter(
                                "customerId"
                        )
                )
        );


        event.setTypeId(
                Integer.parseInt(
                        request.getParameter(
                                "typeId"
                        )
                )
        );


        event.setEventTitle(
                request.getParameter(
                        "eventTitle"
                )
        );


        event.setEventDate(
                java.sql.Date.valueOf(
                        request.getParameter(
                                "eventDate"
                        )
                )
        );


        event.setEventTime(
                java.sql.Time.valueOf(
                        request.getParameter(
                                "eventTime"
                        )
                        + ":00"
                )
        );


        event.setLocation(
                request.getParameter(
                        "location"
                )
        );


        event.setTotalAmount(
                Double.parseDouble(
                        request.getParameter(
                                "totalAmount"
                        )
                )
        );


        event.setAmountPaid(
                Double.parseDouble(
                        request.getParameter(
                                "amountPaid"
                        )
                )
        );


        // =====================================================
        // PAYMENT STATUS
        // =====================================================

        double totalAmount =
                event.getTotalAmount();


        double amountPaid =
                event.getAmountPaid();


        if (amountPaid <= 0) {

            event.setPaymentStatus(
                    "PENDING"
            );

        } else if (
                amountPaid < totalAmount) {

            event.setPaymentStatus(
                    "PARTIAL"
            );

        } else {

            event.setPaymentStatus(
                    "PAID"
            );
        }


        event.setNotes(
                request.getParameter(
                        "notes"
                )
        );


        // -----------------------------------------------------
        // CURRENT ADMIN
        // -----------------------------------------------------

        event.setAdminId(
                adminId
        );


        // =====================================================
        // UPDATE EVENT
        // =====================================================

        boolean success =
                eventDAO.updateEvent(
                        event,
                        adminId
                );


        // =====================================================
        // SUCCESS
        // =====================================================

        if (success) {

            // -------------------------------------------------
            // MULTI-USER NOTIFICATION
            // -------------------------------------------------

            boolean notificationCreated =
                    notificationService.createNotification(
                            adminId,
                            "Event Updated",
                            event.getEventTitle()
                                    + " was updated successfully.",
                            "EVENT",
                            "UPDATE",
                            event.getEventId(),
                            "/events"
                    );


            System.out.println(
                    "EVENT UPDATE NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | EVENT ID = "
                    + event.getEventId()
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Event Updated",
                    event.getEventTitle()
                            + " was updated successfully."
            );


        } else {

            // =================================================
            // UPDATE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Update Failed",
                    "Unable to update event."
            );
        }


        // =====================================================
        // REDIRECT
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/events"
        );
    }
}