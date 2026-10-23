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

@WebServlet("/add-customer")
public class AddCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAOs / SERVICES
    // =========================================================

    private CustomerDAO customerDAO;

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

        request.getRequestDispatcher(
                "/WEB-INF/views/customer/customer-form.jsp")
                .forward(request, response);
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
        // GET SESSION
        // =====================================================

        HttpSession session =
                request.getSession(false);


        // =====================================================
        // CHECK LOGIN
        // =====================================================

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );

            return;
        }


        // =====================================================
        // GET CURRENT ADMIN ID
        // =====================================================

        int adminId =
                (Integer) session.getAttribute(
                        "adminId"
                );


        // =====================================================
        // CREATE CUSTOMER
        // =====================================================

        Customer customer =
                new Customer();


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


        customer.setNotes(
                request.getParameter(
                        "notes"
                )
        );


        // =====================================================
        // VERY IMPORTANT
        // CUSTOMER BELONGS TO CURRENT ADMIN
        // =====================================================

        customer.setAdminId(
                adminId
        );


        // =====================================================
        // SAVE CUSTOMER
        // =====================================================

        boolean success =
                customerDAO.saveCustomer(
                        customer
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
                            "Customer Added",
                            customer.getCustomerName()
                                    + " was added successfully.",
                            "CUSTOMER",
                            "ADD",
                            customer.getCustomerId(),
                            "/customers"
                    );


            System.out.println(
                    "CUSTOMER NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | CUSTOMER ID = "
                    + customer.getCustomerId()
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Customer Added",
                    customer.getCustomerName()
                            + " was added successfully."
            );


        } else {

            // =================================================
            // CUSTOMER SAVE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Customer Not Added",
                    "Unable to save customer."
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