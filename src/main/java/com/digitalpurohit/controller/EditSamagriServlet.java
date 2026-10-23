package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.EventTypeDAO;
import com.digitalpurohit.dao.SamagriDAO;

import com.digitalpurohit.dao.impl.EventTypeDAOImpl;
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

@WebServlet("/edit-samagri")
public class EditSamagriServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAOs
    // =========================================================

    private SamagriDAO samagriDAO;

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

        samagriDAO =
                new SamagriDAOImpl();

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
        // GET SAMAGRI ID
        // =====================================================

        String samagriIdParameter =
                request.getParameter("id");


        if (samagriIdParameter == null ||
            samagriIdParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Samagri ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/samagri"
            );

            return;
        }


        int samagriId;

        try {

            samagriId =
                    Integer.parseInt(
                            samagriIdParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid Samagri ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/samagri"
            );

            return;
        }


        // =====================================================
        // GET SAMAGRI FOR CURRENT ADMIN
        // =====================================================

        Samagri samagri =
                samagriDAO.getSamagriById(
                        samagriId,
                        adminId
                );


        // =====================================================
        // VERIFY OWNERSHIP
        // =====================================================

        if (samagri == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Samagri not found or you do not have permission."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/samagri"
            );

            return;
        }


        // =====================================================
        // GET EVENT TYPES FOR CURRENT ADMIN
        // =====================================================

        List<EventType> eventTypes =
                eventTypeDAO.getAllEventTypes(
                        adminId
                );


        // =====================================================
        // SET ATTRIBUTES
        // =====================================================

        request.setAttribute(
                "samagri",
                samagri
        );

        request.setAttribute(
                "eventTypes",
                eventTypes
        );


        // =====================================================
        // FORWARD
        // =====================================================

        request.getRequestDispatcher(
                "/WEB-INF/views/samagri/samagri-form.jsp"
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
        // GET SAMAGRI ID
        // =====================================================

        String samagriIdParameter =
                request.getParameter(
                        "samagriId"
                );


        if (samagriIdParameter == null ||
            samagriIdParameter.trim().isEmpty()) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Samagri ID is required."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/samagri"
            );

            return;
        }


        int samagriId;

        try {

            samagriId =
                    Integer.parseInt(
                            samagriIdParameter
                    );

        } catch (NumberFormatException e) {

            Toast.error(
                    request,
                    "Invalid Request",
                    "Invalid Samagri ID."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/samagri"
            );

            return;
        }


        // =====================================================
        // VERIFY OWNERSHIP BEFORE UPDATE
        // =====================================================

        Samagri existingSamagri =
                samagriDAO.getSamagriById(
                        samagriId,
                        adminId
                );


        if (existingSamagri == null) {

            Toast.error(
                    request,
                    "Access Denied",
                    "Samagri not found or you do not have permission."
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/samagri"
            );

            return;
        }


        // =====================================================
        // CREATE UPDATED SAMAGRI
        // =====================================================

        Samagri samagri =
                new Samagri();


        samagri.setSamagriId(
                samagriId
        );


        samagri.setAdminId(
                adminId
        );


        samagri.setSamagriName(
                request.getParameter(
                        "samagriName"
                )
        );


        samagri.setDescription(
                request.getParameter(
                        "description"
                )
        );


        // =====================================================
        // UPDATE SAMAGRI
        // =====================================================

        boolean success =
                samagriDAO.updateSamagri(
                        samagri,
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
                            "Samagri Updated",
                            samagri.getSamagriName()
                                    + " updated successfully.",
                            "SAMAGRI",
                            "UPDATE",
                            samagriId,
                            "/samagri"
                    );


            System.out.println(
                    "SAMAGRI UPDATE NOTIFICATION"
                    + " | ADMIN ID = "
                    + adminId
                    + " | SAMAGRI ID = "
                    + samagriId
                    + " | SUCCESS = "
                    + notificationCreated
            );


            // -------------------------------------------------
            // SUCCESS TOAST
            // -------------------------------------------------

            Toast.success(
                    request,
                    "Samagri Updated",
                    samagri.getSamagriName()
                            + " updated successfully."
            );


        } else {

            // =================================================
            // UPDATE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Update Failed",
                    "Unable to update Samagri."
            );
        }


        // =====================================================
        // REDIRECT
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/samagri"
        );
    }
}