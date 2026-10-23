package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.EventTypeDAO;
import com.digitalpurohit.dao.impl.EventTypeDAOImpl;
import com.digitalpurohit.model.EventType;
import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;
import com.digitalpurohit.util.Toast;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/delete-event-type")
public class DeleteEventTypeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAO
    // =========================================================

    private EventTypeDAO eventTypeDAO;

    // =========================================================
    // NOTIFICATION SERVICE
    // =========================================================

    private NotificationService notificationService;


    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

        eventTypeDAO =
                new EventTypeDAOImpl();

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
        // GET TYPE ID
        // =====================================================

        String typeIdParameter =
                request.getParameter("id");


        if (typeIdParameter == null ||
            typeIdParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Event Type ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/event-types"
            );

            return;
        }


        int typeId;

        try {

            typeId =
                    Integer.parseInt(
                            typeIdParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid Event Type ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/event-types"
            );

            return;
        }


        // =====================================================
        // GET EVENT TYPE BEFORE DELETE
        // =====================================================

        EventType eventType =
                eventTypeDAO.getEventTypeById(
                        typeId,
                        adminId
                );


        // =====================================================
        // VERIFY OWNERSHIP
        // =====================================================

        if (eventType == null) {

            Toast.error(
                    request,
                    "Delete Failed",
                    "Event Type not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/event-types"
            );

            return;
        }


        // =====================================================
        // SAVE NAME BEFORE DELETE
        // =====================================================

        String typeName =
                eventType.getTypeName();


        // =====================================================
        // DELETE EVENT TYPE
        // =====================================================

        boolean success =
                eventTypeDAO.deleteEventType(
                        typeId,
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
                            "Event Type Deleted",
                            typeName
                                    + " deleted successfully.",
                            "EVENT_TYPE",
                            "DELETE",
                            typeId,
                            "/event-types"
                    );


            System.out.println(
                    "EVENT TYPE DELETE NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | TYPE ID = "
                    + typeId
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Event Type Deleted",
                    typeName
                            + " deleted successfully."
            );


        } else {

            // =================================================
            // DELETE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Delete Failed",
                    "Unable to delete Event Type."
            );
        }


        // =====================================================
        // REDIRECT
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/event-types"
        );
    }
}