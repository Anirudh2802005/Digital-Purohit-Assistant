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

@WebServlet("/delete-bulk-event")
public class DeleteBulkEventServlet extends HttpServlet {

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
        // VERIFY OWNERSHIP
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
        // SAVE NAME BEFORE DELETE
        // =====================================================

        String bulkEventName =
                bulkEvent.getBulkEventName();


        // =====================================================
        // DELETE BULK EVENT
        // =====================================================

        boolean success =
                bulkEventDAO.deleteBulkEvent(
                        bulkEventId,
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
                            "Bulk Event Deleted",
                            bulkEventName
                                    + " deleted successfully.",
                            "BULK_EVENT",
                            "DELETE",
                            bulkEventId,
                            "/bulk-events"
                    );


            System.out.println(
                    "BULK EVENT DELETE NOTIFICATION"
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
                    "Bulk Event Deleted",
                    bulkEventName
                            + " deleted successfully."
            );


        } else {

            // =================================================
            // DELETE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Delete Failed",
                    "Unable to delete Bulk Event."
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