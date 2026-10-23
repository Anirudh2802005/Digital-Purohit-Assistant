package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.impl.EventDAOImpl;
import com.digitalpurohit.model.Event;
import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;
import com.digitalpurohit.util.Toast;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/delete-event")
public class DeleteEventServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAO
    // =========================================================

    private EventDAO eventDAO;

    // =========================================================
    // NOTIFICATION SERVICE
    // =========================================================

    private NotificationService notificationService;


    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

        eventDAO =
                new EventDAOImpl();

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
        // GET EVENT ID
        // =====================================================

        String eventIdParameter =
                request.getParameter("id");


        if (eventIdParameter == null ||
            eventIdParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Event ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


        int eventId;

        try {

            eventId =
                    Integer.parseInt(
                            eventIdParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid event ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


        // =====================================================
        // GET EVENT BEFORE DELETE
        // =====================================================

        Event event =
                eventDAO.getEventById(
                        eventId,
                        adminId
                );


        // =====================================================
        // VERIFY OWNERSHIP
        // =====================================================

        if (event == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Event not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/events"
            );

            return;
        }


        // =====================================================
        // SAVE TITLE BEFORE DELETE
        // =====================================================

        String eventTitle =
                event.getEventTitle();


        // =====================================================
        // DELETE EVENT
        // =====================================================

        boolean success =
                eventDAO.deleteEvent(
                        eventId,
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
                            "Event Deleted",
                            eventTitle
                                    + " was deleted successfully.",
                            "EVENT",
                            "DELETE",
                            eventId,
                            "/events"
                    );


            System.out.println(
                    "EVENT DELETE NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | EVENT ID = "
                    + eventId
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Event Deleted",
                    eventTitle
                            + " was deleted successfully."
            );


        } else {

            // =================================================
            // DELETE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Delete Failed",
                    "Unable to delete event."
            );
        }


        // =====================================================
        // REDIRECT
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/events"
        );
    }
}