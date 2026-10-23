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

@WebServlet("/delete-samagri")
public class DeleteSamagriServlet extends HttpServlet {

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
        // GET SAMAGRI BEFORE DELETE
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
        // SAVE NAME BEFORE DELETE
        // =====================================================

        String samagriName =
                samagri.getSamagriName();


        // =====================================================
        // DELETE SAMAGRI
        // =====================================================

        boolean success =
                samagriDAO.deleteSamagri(
                        samagriId,
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
                            "Samagri Deleted",
                            samagriName
                                    + " deleted successfully.",
                            "SAMAGRI",
                            "DELETE",
                            samagriId,
                            "/samagri"
                    );


            System.out.println(
                    "SAMAGRI DELETE NOTIFICATION"
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
                    "Samagri Deleted",
                    samagriName
                            + " deleted successfully."
            );


        } else {

            // =================================================
            // DELETE FAILED
            // =================================================

            Toast.error(
                    request,
                    "Delete Failed",
                    "Unable to delete Samagri."
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