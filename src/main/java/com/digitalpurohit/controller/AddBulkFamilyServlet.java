package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.BulkEventDAO;
import com.digitalpurohit.dao.CustomerDAO;

import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.dao.impl.BulkEventDAOImpl;
import com.digitalpurohit.dao.impl.CustomerDAOImpl;

import com.digitalpurohit.model.BulkEvent;
import com.digitalpurohit.model.BulkEventCustomer;
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

@WebServlet("/add-bulk-family")
public class AddBulkFamilyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAOs
    // =========================================================

    private CustomerDAO customerDAO;

    private BulkEventCustomerDAO bulkCustomerDAO;

    private BulkEventDAO bulkEventDAO;


    // =========================================================
    // NOTIFICATION SERVICE
    // =========================================================

    private NotificationService notificationService;


    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

        customerDAO =
                new CustomerDAOImpl();

        bulkCustomerDAO =
                new BulkEventCustomerDAOImpl();

        bulkEventDAO =
                new BulkEventDAOImpl();

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
        // GET BULK EVENT ID
        // -----------------------------------------------------

        String bulkEventIdParameter =
                request.getParameter(
                        "bulkEventId"
                );


        if (bulkEventIdParameter == null ||
            bulkEventIdParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Bulk Event ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        int bulkEventId;

        try {

            bulkEventId =
                    Integer.parseInt(
                            bulkEventIdParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid Bulk Event ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // -----------------------------------------------------
        // VERIFY BULK EVENT BELONGS TO ADMIN
        // -----------------------------------------------------

        BulkEvent bulkEvent =
                bulkEventDAO.getBulkEventById(
                        bulkEventId,
                        adminId
                );


        if (bulkEvent == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Bulk Event not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // -----------------------------------------------------
        // LOAD DATA
        // -----------------------------------------------------

        request.setAttribute(
                "bulkEventId",
                bulkEventId
        );


        request.setAttribute(
                "customers",
                customerDAO.getAllCustomers(
                        adminId
                )
        );


        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/family-form.jsp"
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


        System.out.println(
                "===== AddBulkFamilyServlet POST ====="
        );

        System.out.println(
                "Admin ID = "
                + adminId
        );


        // =====================================================
        // GET BULK EVENT ID
        // =====================================================

        String bulkEventIdParameter =
                request.getParameter(
                        "bulkEventId"
                );


        if (bulkEventIdParameter == null ||
            bulkEventIdParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Bulk Event ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        int bulkEventId;

        try {

            bulkEventId =
                    Integer.parseInt(
                            bulkEventIdParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid Bulk Event ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // =====================================================
        // VERIFY BULK EVENT BELONGS TO CURRENT ADMIN
        // =====================================================

        BulkEvent bulkEvent =
                bulkEventDAO.getBulkEventById(
                        bulkEventId,
                        adminId
                );


        if (bulkEvent == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Bulk Event not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // =====================================================
        // CUSTOMER SELECTION
        // =====================================================

        String customerType =
                request.getParameter(
                        "customerType"
                );


        int customerId;


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
                        + "/add-bulk-family?bulkEventId="
                        + bulkEventId
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
                        + "/add-bulk-family?bulkEventId="
                        + bulkEventId
                );

                return;
            }


            System.out.println(
                    "Existing Customer Selected"
            );

            System.out.println(
                    "Customer ID = "
                    + customerId
            );


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
                        + "/add-bulk-family?bulkEventId="
                        + bulkEventId
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


            // -------------------------------------------------
            // ASSIGN CURRENT ADMIN
            // -------------------------------------------------

            customer.setAdminId(
                    adminId
            );


            customer.setCustomerName(
                    request.getParameter(
                            "customerName"
                    )
            );


            customer.setPhone(
                    request.getParameter(
                            "phone"
                    )
            );


            customer.setAddress(
                    request.getParameter(
                            "address"
                    )
            );


            customer.setGothram(
                    request.getParameter(
                            "gothram"
                    )
            );


            System.out.println(
                    "New Customer"
            );

            System.out.println(
                    "Phone = "
                    + customer.getPhone()
            );


            // -------------------------------------------------
            // CHECK EXISTING PHONE
            // -------------------------------------------------

            Customer existingCustomer =
                    customerDAO.getCustomerByPhone(
                            customer.getPhone(),
                            adminId
                    );


            if (existingCustomer != null) {

                customerId =
                        existingCustomer.getCustomerId();


                System.out.println(
                        "Existing Phone Found"
                );

                System.out.println(
                        "Customer ID = "
                        + customerId
                );

            } else {

                // ---------------------------------------------
                // SAVE NEW CUSTOMER
                // ---------------------------------------------

                customerId =
                        customerDAO.saveCustomerAndReturnId(
                                customer
                        );


                System.out.println(
                        "New Customer Saved"
                );

                System.out.println(
                        "Customer ID = "
                        + customerId
                );


                if (customerId <= 0) {

                    Toast.error(
                            request,
                            "Save Failed",
                            "Unable to save customer."
                    );

                    response.sendRedirect(
                            request.getContextPath()
                            + "/add-bulk-family?bulkEventId="
                            + bulkEventId
                    );

                    return;
                }
            }
        }


        // =====================================================
        // SAVE FAMILY
        // =====================================================

        BulkEventCustomer family =
                new BulkEventCustomer();


        family.setBulkEventId(
                bulkEventId
        );


        family.setCustomerId(
                customerId
        );


        // -----------------------------------------------------
        // TOTAL AMOUNT
        // -----------------------------------------------------

        String totalAmountParameter =
                request.getParameter(
                        "totalAmount"
                );


        double totalAmount;

        try {

            totalAmount =
                    Double.parseDouble(
                            totalAmountParameter
                    );

        } catch (Exception e) {

            Toast.error(
                    request,
                    "Invalid Amount",
                    "Please enter a valid total amount."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/add-bulk-family?bulkEventId="
                    + bulkEventId
            );

            return;
        }


        // -----------------------------------------------------
        // AMOUNT PAID
        // -----------------------------------------------------

        String amountPaidStr =
                request.getParameter(
                        "amountPaid"
                );


        double amountPaid = 0;


        if (amountPaidStr != null &&
            !amountPaidStr.trim().isEmpty()) {

            try {

                amountPaid =
                        Double.parseDouble(
                                amountPaidStr
                        );

            } catch (NumberFormatException e) {

                Toast.error(
                        request,
                        "Invalid Amount",
                        "Please enter a valid paid amount."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/add-bulk-family?bulkEventId="
                        + bulkEventId
                );

                return;
            }
        }


        family.setTotalAmount(
                totalAmount
        );


        family.setAmountPaid(
                amountPaid
        );


        family.setNotes(
                request.getParameter(
                        "notes"
                )
        );


        // =====================================================
        // PAYMENT STATUS
        // =====================================================

        if (amountPaid == 0) {

            family.setPaymentStatus(
                    "PENDING"
            );

        } else if (amountPaid < totalAmount) {

            family.setPaymentStatus(
                    "PARTIAL"
            );

        } else {

            family.setPaymentStatus(
                    "PAID"
            );
        }


        // =====================================================
        // SAVE FAMILY
        // =====================================================

        boolean success =
                bulkCustomerDAO.addCustomerToBulkEvent(
                        family
                );


        System.out.println(
                "Bulk Customer Saved = "
                + success
        );


        // =====================================================
        // SUCCESS
        // =====================================================

        if (success) {

            Customer savedCustomer =
                    customerDAO.getCustomerById(
                            customerId,
                            adminId
                    );


            String customerName =
                    savedCustomer != null
                    ? savedCustomer.getCustomerName()
                    : "Customer";


            // -------------------------------------------------
            // CREATE MULTI-USER NOTIFICATION
            // -------------------------------------------------

            boolean notificationCreated =
                    notificationService.createNotification(
                            adminId,
                            "Family Added",
                            customerName
                                    + " added successfully to "
                                    + bulkEvent.getBulkEventName()
                                    + ".",
                            "BULK_EVENT",
                            "ADD_FAMILY",
                            bulkEventId,
                            "/bulk-event-families?bulkEventId="
                                    + bulkEventId
                    );


            System.out.println(
                    "BULK FAMILY NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | BULK EVENT ID = "
                    + bulkEventId
                    + " | CUSTOMER ID = "
                    + customerId
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Family Added",
                    customerName
                            + " added successfully."
            );


        } else {

            Toast.error(
                    request,
                    "Save Failed",
                    "Unable to add family."
            );


            throw new ServletException(
                    "Unable to add customer to Bulk Event."
            );
        }


        // =====================================================
        // REDIRECT
        // =====================================================

        System.out.println(
                "Redirecting to bulk-event-families..."
        );


        response.sendRedirect(
                request.getContextPath()
                + "/bulk-event-families?bulkEventId="
                + bulkEventId
        );
    }
}