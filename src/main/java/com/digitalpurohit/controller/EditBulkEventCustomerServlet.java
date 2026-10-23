package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.BulkEventDAO;
import com.digitalpurohit.dao.CustomerDAO;

import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.dao.impl.BulkEventDAOImpl;
import com.digitalpurohit.dao.impl.CustomerDAOImpl;

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

@WebServlet("/edit-bulk-family")
public class EditBulkEventCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAOs
    // =========================================================

    private BulkEventCustomerDAO bulkEventCustomerDAO;

    private CustomerDAO customerDAO;

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

        bulkEventCustomerDAO =
                new BulkEventCustomerDAOImpl();

        customerDAO =
                new CustomerDAOImpl();

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


        // =====================================================
        // GET FAMILY ID
        // =====================================================

        String idParameter =
                request.getParameter("id");


        if (idParameter == null ||
            idParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Family ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        int id;

        try {

            id =
                    Integer.parseInt(
                            idParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid family ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // =====================================================
        // GET FAMILY
        // =====================================================

        BulkEventCustomer family =
                bulkEventCustomerDAO.getFamilyById(
                        id,
                        adminId
                );


        // =====================================================
        // VERIFY OWNERSHIP
        // =====================================================

        if (family == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Family not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // =====================================================
        // SEND DATA TO FORM
        // =====================================================

        request.setAttribute(
                "family",
                family
        );


        request.setAttribute(
                "bulkEventId",
                family.getBulkEventId()
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


        // =====================================================
        // GET FAMILY ID
        // =====================================================

        String idParameter =
                request.getParameter("id");


        if (idParameter == null ||
            idParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Family ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        int id;

        try {

            id =
                    Integer.parseInt(
                            idParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid family ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // =====================================================
        // GET FAMILY
        // =====================================================

        BulkEventCustomer family =
                bulkEventCustomerDAO.getFamilyById(
                        id,
                        adminId
                );


        // =====================================================
        // VERIFY OWNERSHIP
        // =====================================================

        if (family == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Family not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-events"
            );

            return;
        }


        // =====================================================
        // GET CUSTOMER
        // =====================================================

        Customer customer =
                customerDAO.getCustomerById(
                        family.getCustomerId(),
                        adminId
                );


        if (customer == null) {

            Toast.error(
                    request,
                    "Customer Not Found",
                    "Customer not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/bulk-event-families?bulkEventId="
                    + family.getBulkEventId()
            );

            return;
        }


        // =====================================================
        // UPDATE CUSTOMER DETAILS
        // =====================================================

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


        customerDAO.updateCustomer(
                customer,
                adminId
        );


        // =====================================================
        // UPDATE FAMILY DETAILS
        // =====================================================

        String totalAmountParameter =
                request.getParameter(
                        "totalAmount"
                );


        String amountPaidParameter =
                request.getParameter(
                        "amountPaid"
                );


        double totalAmount;

        double amountPaid;


        try {

            totalAmount =
                    Double.parseDouble(
                            totalAmountParameter
                    );

            amountPaid =
                    Double.parseDouble(
                            amountPaidParameter
                    );

        } catch (Exception e) {

            Toast.error(
                    request,
                    "Invalid Amount",
                    "Please enter valid payment amounts."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/edit-bulk-family?id="
                    + id
            );

            return;
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

        double total =
                family.getTotalAmount();


        double paid =
                family.getAmountPaid();


        if (paid == 0) {

            family.setPaymentStatus(
                    "PENDING"
            );

        } else if (paid < total) {

            family.setPaymentStatus(
                    "PARTIAL"
            );

        } else {

            family.setPaymentStatus(
                    "PAID"
            );
        }


        // =====================================================
        // UPDATE FAMILY
        // =====================================================

        boolean success =
                bulkEventCustomerDAO.updateBulkFamily(
                        family,
                        adminId
                );


        // =====================================================
        // SUCCESS
        // =====================================================

        if (success) {

            // -------------------------------------------------
            // CREATE MULTI-USER NOTIFICATION
            // -------------------------------------------------

            boolean notificationCreated =
                    notificationService.createNotification(
                            adminId,
                            "Family Updated",
                            customer.getCustomerName()
                                    + " updated successfully.",
                            "BULK_EVENT",
                            "UPDATE_FAMILY",
                            family.getBulkEventId(),
                            "/bulk-event-families?bulkEventId="
                                    + family.getBulkEventId()
                    );


            System.out.println(
                    "BULK FAMILY UPDATE NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | BULK EVENT ID = "
                    + family.getBulkEventId()
                    + " | CUSTOMER ID = "
                    + family.getCustomerId()
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Family Updated",
                    customer.getCustomerName()
                            + " updated successfully."
            );


        } else {

            // =================================================
            // UPDATE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Update Failed",
                    "Unable to update family."
            );
        }


        // =====================================================
        // REDIRECT
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/bulk-event-families?bulkEventId="
                + family.getBulkEventId()
        );
    }
}