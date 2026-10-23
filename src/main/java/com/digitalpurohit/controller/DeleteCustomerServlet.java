package com.digitalpurohit.controller;

import java.io.IOException;

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

@WebServlet("/delete-customer")
public class DeleteCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAO
    // =========================================================

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
        // GET CUSTOMER ID
        // =====================================================

        String customerIdParameter =
                request.getParameter(
                        "customerId"
                );


        if (customerIdParameter == null ||
            customerIdParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Customer ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/customers"
            );

            return;
        }


        int customerId;

        try {

            customerId =
                    Integer.parseInt(
                            customerIdParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid customer ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/customers"
            );

            return;
        }


        // =====================================================
        // GET CUSTOMER BEFORE DELETE
        // =====================================================

        Customer customer =
                customerDAO.getCustomerById(
                        customerId,
                        adminId
                );


        // =====================================================
        // VERIFY OWNERSHIP
        // =====================================================

        if (customer == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Customer not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/customers"
            );

            return;
        }


        // =====================================================
        // SAVE NAME BEFORE DELETE
        // =====================================================

        String customerName =
                customer.getCustomerName();


        // =====================================================
        // DELETE CUSTOMER
        // =====================================================

        boolean success =
                customerDAO.deleteCustomer(
                        customerId,
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
                            "Customer Deleted",
                            customerName
                                    + " was deleted successfully.",
                            "CUSTOMER",
                            "DELETE",
                            customerId,
                            "/customers"
                    );


            System.out.println(
                    "CUSTOMER DELETE NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
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
                    "Customer Deleted",
                    customerName
                            + " was deleted successfully."
            );


        } else {

            // =================================================
            // DELETE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Delete Failed",
                    "Unable to delete customer."
            );
        }


        // =====================================================
        // REDIRECT
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/customers"
        );
    }
}