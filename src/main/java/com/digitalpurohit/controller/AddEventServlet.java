package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.EventSamagriDAO;
import com.digitalpurohit.dao.EventTypeDAO;

import com.digitalpurohit.dao.impl.CustomerDAOImpl;
import com.digitalpurohit.dao.impl.EventDAOImpl;
import com.digitalpurohit.dao.impl.EventSamagriDAOImpl;
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

@WebServlet("/add-event")
public class AddEventServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAOs
    // =========================================================

    private EventDAO eventDAO;

    private EventSamagriDAO eventSamagriDAO;

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

        eventSamagriDAO =
                new EventSamagriDAOImpl();

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
        // GET SESSION
        // -----------------------------------------------------

        HttpSession session =
                request.getSession(false);


        // -----------------------------------------------------
        // CHECK LOGIN
        // -----------------------------------------------------

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
        // GET CUSTOMERS
        // -----------------------------------------------------

        List<Customer> customers =
                customerDAO.getAllCustomers(
                        adminId
                );


        // -----------------------------------------------------
        // GET ACTIVE EVENT TYPES
        // -----------------------------------------------------

        List<EventType> eventTypes =
                eventTypeDAO.getActiveEventTypes(
                        adminId
                );


        request.setAttribute(
                "customers",
                customers
        );


        request.setAttribute(
                "eventTypes",
                eventTypes
        );


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
        // GET SESSION
        // -----------------------------------------------------

        HttpSession session =
                request.getSession(false);


        // -----------------------------------------------------
        // CHECK LOGIN
        // -----------------------------------------------------

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
        // CREATE EVENT OBJECT
        // =====================================================

        Event event =
                new Event();


        // =====================================================
        // FORCE SAVE
        // =====================================================

        String forceSave =
                request.getParameter(
                        "forceSave"
                );


        boolean saveAnyway =
                "true".equals(forceSave);


        // =====================================================
        // CUSTOMER TYPE
        // =====================================================

        String customerType =
                request.getParameter(
                        "customerType"
                );


        int customerId = 0;


        // =====================================================
        // EXISTING CUSTOMER
        // =====================================================

        if ("existing".equals(customerType)) {

            String customerIdParameter =
                    request.getParameter(
                            "customerId"
                    );


            if (customerIdParameter == null ||
                customerIdParameter.trim().isEmpty()) {

                Toast.error(
                        request,
                        "Customer Required",
                        "Please select a customer."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/add-event"
                );

                return;
            }


            try {

                customerId =
                        Integer.parseInt(
                                customerIdParameter
                        );

            } catch (NumberFormatException e) {

                Toast.error(
                        request,
                        "Invalid Customer",
                        "Invalid customer ID."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/add-event"
                );

                return;
            }


            // -------------------------------------------------
            // VERIFY CUSTOMER BELONGS TO CURRENT ADMIN
            // -------------------------------------------------

            Customer existingCustomer =
                    customerDAO.getCustomerById(
                            customerId,
                            adminId
                    );


            if (existingCustomer == null) {

                Toast.error(
                        request,
                        "Access Denied",
                        "Customer not found."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/add-event"
                );

                return;
            }
        }


        // =====================================================
        // NEW CUSTOMER
        // =====================================================

        else {

            Customer customer =
                    new Customer();


            customer.setCustomerName(
                    request.getParameter(
                            "newCustomerName"
                    )
            );


            customer.setPhone(
                    request.getParameter(
                            "newCustomerPhone"
                    )
            );


            customer.setAddress(
                    request.getParameter(
                            "newCustomerAddress"
                    )
            );


            customer.setGothram(
                    ""
            );


            customer.setNotes(
                    ""
            );


            // -------------------------------------------------
            // CURRENT ADMIN
            // -------------------------------------------------

            customer.setAdminId(
                    adminId
            );


            customerId =
                    customerDAO.saveCustomerAndReturnId(
                            customer
                    );


            if (customerId <= 0) {

                Toast.error(
                        request,
                        "Customer Failed",
                        "Unable to save customer."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/add-event"
                );

                return;
            }
        }


        // =====================================================
        // EVENT DETAILS
        // =====================================================

        event.setCustomerId(
                customerId
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

        if (event.getAmountPaid() == 0) {

            event.setPaymentStatus(
                    "PENDING"
            );

        } else if (
                event.getAmountPaid()
                < event.getTotalAmount()) {

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


        // =====================================================
        // CONFLICT CHECKING
        // =====================================================

        if (!saveAnyway) {

            Customer customer =
                    customerDAO.getCustomerById(
                            event.getCustomerId(),
                            adminId
                    );


            if (customer == null) {

                Toast.error(
                        request,
                        "Customer Error",
                        "Customer not found."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/add-event"
                );

                return;
            }


            Event conflictEvent =
                    eventDAO.getConflictEvent(
                            event.getEventDate(),
                            event.getEventTime()
                    );


            Event duplicateEvent =
                    eventDAO.getCustomerConflict(
                            customer.getPhone(),
                            event.getEventDate()
                    );


            Event previousEvent =
                    eventDAO.getPreviousEvent(
                            event.getEventDate(),
                            event.getEventTime()
                    );


            request.setAttribute(
                    "newEvent",
                    event
            );


            request.setAttribute(
                    "conflictEvent",
                    conflictEvent
            );


            request.setAttribute(
                    "duplicateEvent",
                    duplicateEvent
            );


            request.setAttribute(
                    "previousEvent",
                    previousEvent
            );


            if (conflictEvent != null
                    || duplicateEvent != null
                    || previousEvent != null) {

                request.getRequestDispatcher(
                        "/WEB-INF/views/event/booking-warning.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }
        }


        // =====================================================
        // SAVE EVENT
        // =====================================================

        event.setAdminId(
                adminId
        );


        int eventId =
                eventDAO.saveEvent(
                        event
                );


        // =====================================================
        // DEBUG
        // =====================================================

        System.out.println(
                "========== EVENT =========="
        );


        System.out.println(
                "Admin ID        : "
                + event.getAdminId()
        );


        System.out.println(
                "Customer ID     : "
                + event.getCustomerId()
        );


        System.out.println(
                "Type ID         : "
                + event.getTypeId()
        );


        System.out.println(
                "Title           : "
                + event.getEventTitle()
        );


        System.out.println(
                "Recurring Type  : "
                + event.getRecurringType()
        );


        System.out.println(
                "Recurring Day   : "
                + event.getRecurringDay()
        );


        System.out.println(
                "Recurring End   : "
                + event.getRecurringEndDate()
        );


        System.out.println(
                "==========================="
        );


        // =====================================================
        // EVENT SAVED
        // =====================================================

        if (eventId > 0) {

            // -------------------------------------------------
            // COPY DEFAULT SAMAGRI
            // -------------------------------------------------

            eventSamagriDAO.copySamagriToEvent(
                    eventId,
                    event.getTypeId()
            );


            // -------------------------------------------------
            // SAVE EXTRA SAMAGRI
            // -------------------------------------------------

            String[] extras =
                    request.getParameterValues(
                            "extraSamagri"
                    );


            if (extras != null) {

                for (String extra : extras) {

                    eventSamagriDAO.addExtraSamagri(
                            eventId,
                            extra
                    );
                }
            }


            // -------------------------------------------------
            // CREATE MULTI-USER NOTIFICATION
            // -------------------------------------------------

            boolean notificationCreated =
                    notificationService.createNotification(
                            adminId,
                            "Event Created",
                            event.getEventTitle()
                                    + " created successfully.",
                            "EVENT",
                            "ADD",
                            eventId,
                            "/events"
                    );


            System.out.println(
                    "EVENT NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | EVENT ID = "
                    + eventId
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Event Created",
                    event.getEventTitle()
                            + " created successfully."
            );


        } else {

            // =================================================
            // SAVE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Save Failed",
                    "Unable to create event."
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