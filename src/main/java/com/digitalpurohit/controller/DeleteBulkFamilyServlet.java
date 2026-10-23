package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.CustomerDAO;

import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
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

@WebServlet("/delete-bulk-family")
public class DeleteBulkFamilyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAOs
    // =========================================================

    private BulkEventCustomerDAO dao;

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

        dao =
                new BulkEventCustomerDAOImpl();

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
                dao.getFamilyById(
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
        // GET BULK EVENT ID
        // =====================================================

        int bulkEventId =
                family.getBulkEventId();


        // =====================================================
        // GET CUSTOMER
        // =====================================================

        Customer customer =
                customerDAO.getCustomerById(
                        family.getCustomerId(),
                        adminId
                );


        String customerName =
                customer != null
                ? customer.getCustomerName()
                : "Customer";


        // =====================================================
        // DELETE FAMILY
        // =====================================================

        boolean success =
                dao.deleteBulkFamily(
                        id,
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
                            "Family Removed",
                            customerName
                                    + " removed successfully.",
                            "BULK_EVENT",
                            "DELETE_FAMILY",
                            bulkEventId,
                            "/bulk-event-families?bulkEventId="
                                    + bulkEventId
                    );


            System.out.println(
                    "BULK FAMILY DELETE NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | BULK EVENT ID = "
                    + bulkEventId
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
                    "Family Removed",
                    customerName
                            + " removed successfully."
            );


        } else {

            // =================================================
            // DELETE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Delete Failed",
                    "Unable to remove family."
            );
        }


        // =====================================================
        // REDIRECT
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/bulk-event-families?bulkEventId="
                + bulkEventId
        );
    }
}