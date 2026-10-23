package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.Collections;

import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.dao.impl.AdminDAOImpl;
import com.digitalpurohit.model.Admin;
import com.digitalpurohit.service.ReminderScheduler;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================================
    // GOOGLE WEB CLIENT ID
    // =========================================================

    private static final String GOOGLE_CLIENT_ID =
            "1063020356143-3qddcufvgi1tit9rvmdlta0oo1boampk.apps.googleusercontent.com";


    private AdminDAO adminDAO;


    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

        adminDAO = new AdminDAOImpl();

    }


    // =========================================================
    // GOOGLE LOGIN
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        // =====================================================
        // GET GOOGLE CREDENTIAL
        // =====================================================

        String credential =
                request.getParameter("credential");


        System.out.println(
                "====================================");

        System.out.println(
                "GOOGLE LOGIN STARTED");

        System.out.println(
                "Credential received: "
                + (credential != null));

        System.out.println(
                "====================================");


        // =====================================================
        // CHECK CREDENTIAL
        // =====================================================

        if (credential == null ||
            credential.trim().isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Google login failed. No credential received.");

            request.getRequestDispatcher(
                    "/WEB-INF/views/login.jsp")
                    .forward(request, response);

            return;
        }


        try {


            // =================================================
            // CREATE GOOGLE TOKEN VERIFIER
            // =================================================

            GoogleIdTokenVerifier verifier =
                    new GoogleIdTokenVerifier.Builder(
                            GoogleNetHttpTransport.newTrustedTransport(),
                            GsonFactory.getDefaultInstance())
                            .setAudience(
                                    Collections.singletonList(
                                            GOOGLE_CLIENT_ID))
                            .build();


            // =================================================
            // VERIFY GOOGLE ID TOKEN
            // =================================================

            GoogleIdToken idToken =
                    verifier.verify(credential);


            System.out.println(
                    "Google token verification completed");


            if (idToken == null) {

                System.out.println(
                        "Google token verification FAILED");


                request.setAttribute(
                        "errorMessage",
                        "Invalid Google login token.");

                request.getRequestDispatcher(
                        "/WEB-INF/views/login.jsp")
                        .forward(request, response);

                return;
            }


            // =================================================
            // GET GOOGLE USER INFORMATION
            // =================================================

            GoogleIdToken.Payload payload =
                    idToken.getPayload();


            String googleId =
                    payload.getSubject();


            String email =
                    payload.getEmail();


            System.out.println(
                    "Google Email: " + email);


            String name =
                    (String) payload.get("name");


            String profileImage =
                    (String) payload.get("picture");


            Boolean emailVerified =
                    payload.getEmailVerified();


            System.out.println(
                    "Google Name: " + name);


            System.out.println(
                    "Google ID received: "
                    + (googleId != null));


            System.out.println(
                    "Google Profile Image: "
                    + profileImage);


            System.out.println(
                    "Email Verified: "
                    + emailVerified);


            // =================================================
            // CHECK VERIFIED EMAIL
            // =================================================

            if (!Boolean.TRUE.equals(emailVerified)) {

                request.setAttribute(
                        "errorMessage",
                        "Your Google email is not verified.");

                request.getRequestDispatcher(
                        "/WEB-INF/views/login.jsp")
                        .forward(request, response);

                return;
            }


            // =================================================
            // VALIDATE GOOGLE EMAIL
            // =================================================

            if (email == null ||
                email.trim().isEmpty()) {

                request.setAttribute(
                        "errorMessage",
                        "Google account email not available.");

                request.getRequestDispatcher(
                        "/WEB-INF/views/login.jsp")
                        .forward(request, response);

                return;
            }


            email =
                    email.trim().toLowerCase();


            // =================================================
            // FIND EXISTING ADMIN BY EMAIL
            // =================================================

            System.out.println(
                    "Searching admin by email...");


            Admin admin =
                    adminDAO.getAdminByEmail(email);


            System.out.println(
                    "Admin found: "
                    + (admin != null));


            // =================================================
            // ADMIN DOES NOT EXIST
            // =================================================

            if (admin == null) {

                System.out.println(
                        "No admin found for Google email");


                request.setAttribute(
                        "errorMessage",
                        "This Google email is not registered as an admin.");

                request.getRequestDispatcher(
                        "/WEB-INF/views/login.jsp")
                        .forward(request, response);

                return;
            }


            // =================================================
            // SAVE GOOGLE ID + PROFILE IMAGE
            // =================================================

            System.out.println(
                    "Saving Google information...");


            boolean googleUpdated =
                    adminDAO.updateGoogleLogin(
                            admin.getAdminId(),
                            googleId,
                            profileImage);


            System.out.println(
                    "Google information saved: "
                    + googleUpdated);


            if (!googleUpdated) {

                System.out.println(
                        "WARNING: Google information was NOT saved");

            }


            // =================================================
            // REMOVE OLD SESSION
            // =================================================

            HttpSession oldSession =
                    request.getSession(false);


            if (oldSession != null) {

                oldSession.invalidate();

            }


            // =================================================
            // CREATE NEW SESSION
            // =================================================

            HttpSession session =
                    request.getSession(true);


            // =================================================
            // ADMIN INFORMATION
            // =================================================

            session.setAttribute(
                    "adminId",
                    admin.getAdminId());


            session.setAttribute(
                    "adminName",
                    admin.getName());


            session.setAttribute(
                    "adminUsername",
                    admin.getUsername());


            session.setAttribute(
                    "adminEmail",
                    admin.getEmail());


            session.setAttribute(
                    "adminPhone",
                    admin.getPhone());


            // =================================================
            // GOOGLE PROFILE IMAGE
            // =================================================

            if (profileImage != null &&
                !profileImage.trim().isEmpty()) {

                session.setAttribute(
                        "profileImage",
                        profileImage);

            } else {

                session.removeAttribute(
                        "profileImage");

            }


            // =================================================
            // GOOGLE ID
            // =================================================

            session.setAttribute(
                    "googleId",
                    googleId);


            // =================================================
            // LOGIN TYPE
            // =================================================

            session.setAttribute(
                    "loginType",
                    "GOOGLE");


            // =================================================
            // REMINDER ENGINE
            // =================================================

            try {

                ReminderScheduler.runForAdmin(
                        admin.getAdminId());

            } catch (Exception e) {

                e.printStackTrace();

            }


            // =================================================
            // GOOGLE LOGIN SUCCESS
            // =================================================

            System.out.println(
                    "====================================");

            System.out.println(
                    "GOOGLE LOGIN SUCCESS");

            System.out.println(
                    "Admin ID: "
                    + admin.getAdminId());

            System.out.println(
                    "Admin Name: "
                    + admin.getName());

            System.out.println(
                    "Admin Email: "
                    + admin.getEmail());

            System.out.println(
                    "Redirecting to dashboard...");

            System.out.println(
                    "====================================");


            // =================================================
            // DASHBOARD
            // =================================================

            response.sendRedirect(
                    request.getContextPath()
                    + "/dashboard");


        } catch (Exception e) {


            // =================================================
            // GOOGLE LOGIN ERROR
            // =================================================

            e.printStackTrace();


            System.out.println(
                    "====================================");

            System.out.println(
                    "GOOGLE LOGIN ERROR");

            System.out.println(
                    "Error: "
                    + e.getMessage());

            System.out.println(
                    "====================================");


            request.setAttribute(
                    "errorMessage",
                    "Google login failed: "
                    + e.getMessage());


            request.getRequestDispatcher(
                    "/WEB-INF/views/login.jsp")
                    .forward(request, response);

        }

    }

}