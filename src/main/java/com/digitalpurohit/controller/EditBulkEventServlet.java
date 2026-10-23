package com.digitalpurohit.controller;

import java.io.IOException;

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

@WebServlet("/edit-bulk-event")
public class EditBulkEventServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAO
    // =========================================================

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

        int adminId =
                (Integer) session.getAttribute(
                        "adminId"
                );


        // -----------------------------------------------------
        // GET BULK EVENT ID
        // -----------------------------------------------------

        String idParameter =
                request.getParameter("id");

        if (idParameter == null ||
            idParameter.trim().isEmpty()) {

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
                            idParameter
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
        // GET BULK EVENT FOR CURRENT ADMIN
        // -----------------------------------------------------

        BulkEvent bulkEvent =
                bulkEventDAO.getBulkEventById(
                        bulkEventId,
                        adminId
                );


        // -----------------------------------------------------
        // VERIFY OWNERSHIP
        // -----------------------------------------------------

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


        request.setAttribute(
                "bulkEvent",
                bulkEvent
        );


        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/bulk-event-form.jsp"
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


        int adminId =
                (Integer) session.getAttribute(
                        "adminId"
                );


        // =====================================================
        // GET BULK EVENT ID
        // =====================================================

        String idParameter =
                request.getParameter("id");


        /*
         * IMPORTANT:
         *
         * We need the existing Bulk Event ID so that
         * the update cannot accidentally modify another
         * admin's record.
         */

        if (idParameter == null ||
            idParameter.trim().isEmpty()) {

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
                            idParameter
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
        // VERIFY EXISTING BULK EVENT
        // =====================================================

        BulkEvent existingBulkEvent =
                bulkEventDAO.getBulkEventById(
                        bulkEventId,
                        adminId
                );


        if (existingBulkEvent == null) {

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
        // CREATE UPDATED BULK EVENT
        // =====================================================

        BulkEvent bulkEvent =
                new BulkEvent();


        bulkEvent.setAdminId(
                adminId
        );


        /*
         * IMPORTANT:
         *
         * Keep the original ID.
         */

        bulkEvent.setYatraId(
                bulkEventId
        );


        bulkEvent.setBulkEventName(
                request.getParameter(
                        "bulkEventName"
                )
        );


        bulkEvent.setStartDate(
                java.sql.Date.valueOf(
                        request.getParameter(
                                "startDate"
                        )
                )
        );


        bulkEvent.setEndDate(
                java.sql.Date.valueOf(
                        request.getParameter(
                                "endDate"
                        )
                )
        );


        bulkEvent.setLocation(
                request.getParameter(
                        "location"
                )
        );


        bulkEvent.setNotes(
                request.getParameter(
                        "notes"
                )
        );


        // =====================================================
        // UPDATE
        // =====================================================

        boolean success =
                bulkEventDAO.updateBulkEvent(
                        bulkEvent,
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
                            "Bulk Event Updated",
                            bulkEvent.getBulkEventName()
                                    + " updated successfully.",
                            "BULK_EVENT",
                            "UPDATE",
                            bulkEventId,
                            "/bulk-events"
                    );


            System.out.println(
                    "BULK EVENT UPDATE NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | BULK EVENT ID = "
                    + bulkEventId
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Bulk Event Updated",
                    bulkEvent.getBulkEventName()
                            + " updated successfully."
            );


        } else {

            // =================================================
            // UPDATE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Update Failed",
                    "Unable to update Bulk Event."
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