package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.impl.EventDAOImpl;
import com.digitalpurohit.model.Event;

import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.dao.impl.CustomerDAOImpl;
import com.digitalpurohit.model.Customer;

import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;
import com.digitalpurohit.util.Toast;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/event-receive-payment")
public class ReceivePaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAOs
    // =========================================================

    private EventDAO eventDAO;

    private CustomerDAO customerDAO;


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
        // GET EVENT
        // =====================================================

        Event event =
                eventDAO.getEventById(
                        eventId,
                        adminId
                );


        // =====================================================
        // VERIFY OWNERSHIP
        // =====================================================

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


        request.setAttribute(
                "event",
                event
        );


        // =====================================================
        // FORWARD
        // =====================================================

        request.getRequestDispatcher(
                "/WEB-INF/views/event/receive-payment.jsp"
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
        // VERIFY EVENT BELONGS TO CURRENT ADMIN
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
        // GET RECEIVE AMOUNT
        // =====================================================

        String receiveAmountParameter =
                request.getParameter(
                        "receiveAmount"
                );


        if (receiveAmountParameter == null ||
            receiveAmountParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Amount",
                    "Please enter the received amount."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/event-receive-payment?eventId="
                    + eventId
            );

            return;
        }


        double receiveAmount;

        try {

            receiveAmount =
                    Double.parseDouble(
                            receiveAmountParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Amount",
                    "Please enter a valid amount."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/event-receive-payment?eventId="
                    + eventId
            );

            return;
        }


        // =====================================================
        // NOTES
        // =====================================================

        String notes =
                request.getParameter(
                        "notes"
                );


        System.out.println(
                "=========================================="
        );

        System.out.println(
                "RECEIVE PAYMENT"
        );

        System.out.println(
                "Admin ID       : "
                + adminId
        );

        System.out.println(
                "Event ID       : "
                + eventId
        );

        System.out.println(
                "Receive Amount : "
                + receiveAmount
        );

        System.out.println(
                "=========================================="
        );


        // =====================================================
        // RECEIVE PAYMENT
        // =====================================================

        boolean success =
                eventDAO.receivePayment(
                        eventId,
                        receiveAmount,
                        notes
                );


        // =====================================================
        // GET UPDATED EVENT
        // =====================================================

        Event event =
                eventDAO.getEventById(
                        eventId,
                        adminId
                );


        if (event == null) {

            Toast.error(
                    request,
                    "Error",
                    "Unable to retrieve updated event."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


        // =====================================================
        // GET CUSTOMER
        // =====================================================

        Customer customer =
                customerDAO.getCustomerById(
                        event.getCustomerId(),
                        adminId
                );


        if (customer == null) {

            Toast.error(
                    request,
                    "Error",
                    "Customer not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


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
                            "Payment Received",
                            "₹"
                                    + receiveAmount
                                    + " received from "
                                    + customer.getCustomerName(),
                            "EVENT_PAYMENT",
                            "RECEIVED",
                            eventId,
                            "/events"
                    );


            System.out.println(
                    "EVENT PAYMENT NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | EVENT ID = "
                    + eventId
                    + " | CUSTOMER = "
                    + customer.getCustomerName()
                    + " | AMOUNT = "
                    + receiveAmount
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Payment Received",
                    "₹"
                            + receiveAmount
                            + " received from "
                            + customer.getCustomerName()
            );


        } else {

            // =================================================
            // PAYMENT FAILED
            // =================================================

            Toast.error(
                    request,
                    "Payment Failed",
                    "Unable to update payment."
            );
        }


        // =====================================================
        // REDIRECT
        // =====================================================

        String source =
                request.getParameter(
                        "source"
                );


        if ("reports".equals(source)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/event-reports"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/event-receive-payment?eventId="
                    + eventId
                    + "&success=true"
            );
        }
    }
}