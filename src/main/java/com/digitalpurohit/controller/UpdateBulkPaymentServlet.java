package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.dao.impl.CustomerDAOImpl;
import com.digitalpurohit.model.Customer;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;

import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;
import com.digitalpurohit.util.Toast;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/update-bulk-payment")
public class UpdateBulkPaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAOs
    // =========================================================

    private BulkEventCustomerDAO bulkEventCustomerDAO;

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

        bulkEventCustomerDAO =
                new BulkEventCustomerDAOImpl();

        customerDAO =
                new CustomerDAOImpl();

        notificationService =
                new NotificationServiceImpl();
    }


    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // =====================================================
        // SESSION CHECK
        // =====================================================

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


        // =====================================================
        // CURRENT ADMIN
        // =====================================================

        int adminId =
                (Integer) session.getAttribute(
                        "adminId"
                );


        // =====================================================
        // GET PARAMETERS
        // =====================================================

        String bulkEventIdParameter =
                request.getParameter(
                        "bulkEventId"
                );

        String customerIdParameter =
                request.getParameter(
                        "customerId"
                );

        String amountParameter =
                request.getParameter(
                        "amountPaid"
                );


        if (bulkEventIdParameter == null ||
            customerIdParameter == null ||
            amountParameter == null ||
            bulkEventIdParameter.trim().isEmpty() ||
            customerIdParameter.trim().isEmpty() ||
            amountParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Required payment information is missing."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // =====================================================
        // PARSE VALUES
        // =====================================================

        int bulkEventId;

        int customerId;

        double receiveAmount;


        try {

            bulkEventId =
                    Integer.parseInt(
                            bulkEventIdParameter
                    );

            customerId =
                    Integer.parseInt(
                            customerIdParameter
                    );

            receiveAmount =
                    Double.parseDouble(
                            amountParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid payment information."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // =====================================================
        // VALIDATE AMOUNT
        // =====================================================

        if (receiveAmount <= 0) {

            Toast.error(
                    request,
                    "Invalid Amount",
                    "Payment amount must be greater than zero."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-event-payments?bulkEventId="
                    + bulkEventId
            );

            return;
        }


        String notes =
                request.getParameter(
                        "notes"
                );


        String source =
                request.getParameter(
                        "source"
                );


        // =====================================================
        // DEBUG
        // =====================================================

        System.out.println(
                "=========================================="
        );

        System.out.println(
                "UPDATE BULK PAYMENT"
        );

        System.out.println(
                "Admin ID       : "
                + adminId
        );

        System.out.println(
                "Bulk Event ID  : "
                + bulkEventId
        );

        System.out.println(
                "Customer ID    : "
                + customerId
        );

        System.out.println(
                "Receive Amount : "
                + receiveAmount
        );

        System.out.println(
                "=========================================="
        );


        // =====================================================
        // UPDATE PAYMENT
        // =====================================================

        boolean updated =
                bulkEventCustomerDAO.updatePaymentStatus(
                        bulkEventId,
                        customerId,
                        receiveAmount,
                        notes,
                        adminId
                );


        System.out.println(
                "Payment Updated = "
                + updated
        );


        // =====================================================
        // GET CUSTOMER
        // =====================================================

        Customer customer =
                customerDAO.getCustomerById(
                        customerId,
                        adminId
                );


        if (customer == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Customer not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // =====================================================
        // SUCCESS
        // =====================================================

        if (updated) {

            // -------------------------------------------------
            // MULTI-USER NOTIFICATION
            // -------------------------------------------------

            boolean notificationCreated =
                    notificationService.createNotification(
                            adminId,
                            "Bulk Payment Received",
                            "₹"
                                    + receiveAmount
                                    + " received from "
                                    + customer.getCustomerName(),
                            "BULK_EVENT_PAYMENT",
                            "RECEIVED",
                            bulkEventId,
                            "/bulk-event-payments?bulkEventId="
                                    + bulkEventId
                    );


            System.out.println(
                    "BULK PAYMENT NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | BULK EVENT ID = "
                    + bulkEventId
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
                    "Payment Updated",
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

        if ("bulkIncome".equals(source)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-event-income-details?bulkEventId="
                    + bulkEventId
            );


        } else if ("bulk-report".equals(source)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-event-report?bulkEventId="
                    + bulkEventId
            );


        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-event-payments?bulkEventId="
                    + bulkEventId
            );
        }
    }
}