package com.digitalpurohit.controller;

import java.io.IOException;
import java.sql.Date;

import com.digitalpurohit.dao.BulkEventDAO;
import com.digitalpurohit.dao.impl.BulkEventDAOImpl;
import com.digitalpurohit.model.BulkEvent;
import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;
import com.digitalpurohit.util.Toast;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-bulk-event")
public class AddBulkEventServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAO / SERVICE
    // =========================================================

    private BulkEventDAO bulkEventDAO;

    private NotificationService notificationService;


    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

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

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/bulk-event-form.jsp")
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
        // CURRENT ADMIN ID
        // =====================================================

        int adminId =
                (Integer) session.getAttribute(
                        "adminId"
                );


        // =====================================================
        // CREATE BULK EVENT
        // =====================================================

        BulkEvent bulkEvent =
                new BulkEvent();


        // -----------------------------------------------------
        // ASSIGN CURRENT ADMIN
        // -----------------------------------------------------

        bulkEvent.setAdminId(
                adminId
        );


        // -----------------------------------------------------
        // BULK EVENT NAME
        // -----------------------------------------------------

        bulkEvent.setBulkEventName(
                request.getParameter(
                        "bulkEventName"
                )
        );


        // -----------------------------------------------------
        // START DATE
        // -----------------------------------------------------

        bulkEvent.setStartDate(
                Date.valueOf(
                        request.getParameter(
                                "startDate"
                        )
                )
        );


        // -----------------------------------------------------
        // END DATE
        // -----------------------------------------------------

        bulkEvent.setEndDate(
                Date.valueOf(
                        request.getParameter(
                                "endDate"
                        )
                )
        );


        // -----------------------------------------------------
        // LOCATION
        // -----------------------------------------------------

        bulkEvent.setLocation(
                request.getParameter(
                        "location"
                )
        );


        // -----------------------------------------------------
        // NOTES
        // -----------------------------------------------------

        bulkEvent.setNotes(
                request.getParameter(
                        "notes"
                )
        );


        // =====================================================
        // SAVE BULK EVENT
        // =====================================================

        boolean success =
                bulkEventDAO.saveBulkEvent(
                        bulkEvent
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
                            "Bulk Event Created",
                            bulkEvent.getBulkEventName()
                                    + " created successfully.",
                            "BULK_EVENT",
                            "ADD",
                            bulkEvent.getYatraId(),
                            "/bulk-events"
                    );


            System.out.println(
                    "BULK EVENT NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | BULK EVENT ID = "
                    + bulkEvent.getYatraId()
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Bulk Event Created",
                    bulkEvent.getBulkEventName()
                            + " created successfully."
            );


        } else {

            // =================================================
            // SAVE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Save Failed",
                    "Unable to create Bulk Event."
            );
        }


        // =====================================================
        // REDIRECT
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/bulk-events"
        );
    }
}