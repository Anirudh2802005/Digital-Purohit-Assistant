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

@WebServlet("/add-event-type")
public class AddEventTypeServlet extends HttpServlet {

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


        // -----------------------------------------------------
        // GET SAMAGRI FOR CURRENT ADMIN
        // -----------------------------------------------------

        List<Samagri> samagriList =
                samagriDAO.getAllSamagri(
                        adminId
                );


        request.setAttribute(
                "samagriList",
                samagriList
        );


        // -----------------------------------------------------
        // FORWARD TO FORM
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
        // CREATE EVENT TYPE
        // =====================================================

        EventType eventType =
                new EventType();


        // -----------------------------------------------------
        // ASSIGN CURRENT ADMIN
        // -----------------------------------------------------

        eventType.setAdminId(
                adminId
        );


        // -----------------------------------------------------
        // TYPE NAME
        // -----------------------------------------------------

        eventType.setTypeName(
                request.getParameter(
                        "typeName"
                )
        );


        // -----------------------------------------------------
        // DESCRIPTION
        // -----------------------------------------------------

        eventType.setDescription(
                request.getParameter(
                        "description"
                )
        );


        // -----------------------------------------------------
        // ACTIVE
        // -----------------------------------------------------

        eventType.setActive(
                request.getParameter(
                        "active"
                ) != null
        );


        // =====================================================
        // SAVE EVENT TYPE
        // =====================================================

        int typeId =
                eventTypeDAO.saveEventType(
                        eventType
                );


        // =====================================================
        // SUCCESS
        // =====================================================

        if (typeId > 0) {

            // -------------------------------------------------
            // SAVE SAMAGRI
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
                            "Event Type Added",
                            eventType.getTypeName()
                                    + " added successfully.",
                            "EVENT_TYPE",
                            "ADD",
                            typeId,
                            "/event-types"
                    );


            System.out.println(
                    "EVENT TYPE NOTIFICATION"
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
                    "Event Type Added",
                    eventType.getTypeName()
                            + " added successfully."
            );


        } else {

            // =================================================
            // SAVE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Save Failed",
                    "Unable to add Event Type."
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