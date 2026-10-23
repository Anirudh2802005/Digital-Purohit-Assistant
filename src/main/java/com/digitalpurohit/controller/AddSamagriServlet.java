package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.SamagriDAO;
import com.digitalpurohit.dao.impl.SamagriDAOImpl;
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

@WebServlet("/add-samagri")
public class AddSamagriServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // DAO
    // =========================================================

    private SamagriDAO samagriDAO;

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
        // CREATE SAMAGRI
        // =====================================================

        Samagri samagri =
                new Samagri();


        // -----------------------------------------------------
        // ASSIGN ADMIN
        // -----------------------------------------------------

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
        // SAVE SAMAGRI
        // =====================================================

        int samagriId =
                samagriDAO.saveSamagri(
                        samagri
                );


        // =====================================================
        // SUCCESS
        // =====================================================

        if (samagriId > 0) {

            // -------------------------------------------------
            // CREATE MULTI-USER NOTIFICATION
            // -------------------------------------------------

            boolean notificationCreated =
                    notificationService.createNotification(
                            adminId,
                            "Samagri Added",
                            samagri.getSamagriName()
                                    + " added successfully.",
                            "SAMAGRI",
                            "ADD",
                            samagriId,
                            "/samagri"
                    );


            System.out.println(
                    "SAMAGRI NOTIFICATION"
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
                    "Samagri Added",
                    samagri.getSamagriName()
                            + " added successfully."
            );


        } else {

            // =================================================
            // SAVE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Save Failed",
                    "Unable to add Samagri."
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