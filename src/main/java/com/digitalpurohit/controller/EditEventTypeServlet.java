package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.EventTypeDAO;
import com.digitalpurohit.dao.EventTypeSamagriDAO;
import com.digitalpurohit.dao.SamagriDAO;

import com.digitalpurohit.dao.impl.EventTypeDAOImpl;
import com.digitalpurohit.dao.impl.EventTypeSamagriDAOImpl;
import com.digitalpurohit.dao.impl.SamagriDAOImpl;

import com.digitalpurohit.model.EventType;
import com.digitalpurohit.model.Samagri;

import com.digitalpurohit.service.NotificationService;
import com.digitalpurohit.service.impl.NotificationServiceImpl;

import com.digitalpurohit.util.Toast;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/edit-event-type")
public class EditEventTypeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAOs
    // =========================================================

    private EventTypeDAO eventTypeDAO;

    private SamagriDAO samagriDAO;

    private EventTypeSamagriDAO eventTypeSamagriDAO;


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

        samagriDAO =
                new SamagriDAOImpl();

        eventTypeSamagriDAO =
                new EventTypeSamagriDAOImpl();

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
        // SESSION CHECK
        // -----------------------------------------------------

        HttpSession session =
                request.getSession(false);

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
        // GET TYPE ID
        // -----------------------------------------------------

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


        // -----------------------------------------------------
        // GET EVENT TYPE FOR CURRENT ADMIN
        // -----------------------------------------------------

        EventType eventType =
                eventTypeDAO.getEventTypeById(
                        typeId,
                        adminId
                );


        if (eventType == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Event Type not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/event-types"
            );

            return;
        }


        // -----------------------------------------------------
        // GET SAMAGRI FOR CURRENT ADMIN
        // -----------------------------------------------------

        List<Samagri> samagriList =
                samagriDAO.getAllSamagri(
                        adminId
                );


        // -----------------------------------------------------
        // GET SELECTED SAMAGRI
        // -----------------------------------------------------

        List<Integer> selectedSamagriIds =
                eventTypeSamagriDAO
                        .getSelectedSamagriIds(
                                typeId
                        );


        // -----------------------------------------------------
        // SET ATTRIBUTES
        // -----------------------------------------------------

        request.setAttribute(
                "eventType",
                eventType
        );

        request.setAttribute(
                "samagriList",
                samagriList
        );

        request.setAttribute(
                "selectedSamagriIds",
                selectedSamagriIds
        );


        // -----------------------------------------------------
        // FORWARD
        // -----------------------------------------------------

        request.getRequestDispatcher(
                "/WEB-INF/views/eventtype/eventtype-form.jsp"
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
        // SESSION CHECK
        // -----------------------------------------------------

        HttpSession session =
                request.getSession(false);


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
                request.getParameter(
                        "typeId"
                );


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
        // VERIFY OWNERSHIP BEFORE UPDATE
        // =====================================================

        EventType existingEventType =
                eventTypeDAO.getEventTypeById(
                        typeId,
                        adminId
                );


        if (existingEventType == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Event Type not found."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/event-types"
            );

            return;
        }


        // =====================================================
        // CREATE UPDATED EVENT TYPE
        // =====================================================

        EventType eventType =
                new EventType();


        eventType.setTypeId(
                typeId
        );


        eventType.setAdminId(
                adminId
        );


        eventType.setTypeName(
                request.getParameter(
                        "typeName"
                )
        );


        eventType.setDescription(
                request.getParameter(
                        "description"
                )
        );


        eventType.setActive(
                request.getParameter(
                        "active"
                ) != null
        );


        // =====================================================
        // UPDATE EVENT TYPE
        // =====================================================

        boolean success =
                eventTypeDAO.updateEventType(
                        eventType,
                        adminId
                );


        // =====================================================
        // SUCCESS
        // =====================================================

        if (success) {

            // -------------------------------------------------
            // DELETE OLD SAMAGRI MAPPING
            // -------------------------------------------------

            eventTypeSamagriDAO.deleteByEventType(
                    typeId
            );


            // -------------------------------------------------
            // SAVE NEW SAMAGRI MAPPING
            // -------------------------------------------------

            String[] samagriIds =
                    request.getParameterValues(
                            "samagriIds"
                    );


            if (samagriIds != null) {

                for (String id : samagriIds) {

                    try {

                        int samagriId =
                                Integer.parseInt(id);


                        eventTypeSamagriDAO
                                .saveEventTypeSamagri(
                                        typeId,
                                        samagriId
                                );

                    } catch (NumberFormatException e) {

                        System.out.println(
                                "Invalid Samagri ID: "
                                + id
                        );
                    }
                }
            }


            // -------------------------------------------------
            // CREATE MULTI-USER NOTIFICATION
            // -------------------------------------------------

            boolean notificationCreated =
                    notificationService.createNotification(
                            adminId,
                            "Event Type Updated",
                            eventType.getTypeName()
                                    + " updated successfully.",
                            "EVENT_TYPE",
                            "UPDATE",
                            typeId,
                            "/event-types"
                    );


            System.out.println(
                    "EVENT TYPE UPDATE NOTIFICATION"
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
                    "Event Type Updated",
                    eventType.getTypeName()
                            + " updated successfully."
            );


        } else {

            // =================================================
            // UPDATE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Update Failed",
                    "Unable to update Event Type."
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