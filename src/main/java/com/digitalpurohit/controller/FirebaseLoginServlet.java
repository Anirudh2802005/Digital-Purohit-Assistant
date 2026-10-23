package com.digitalpurohit.controller;

import java.io.IOException;
import java.io.InputStream;

import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.dao.impl.AdminDAOImpl;
import com.digitalpurohit.model.Admin;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/firebase-login")
public class FirebaseLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {

        adminDAO = new AdminDAOImpl();

        try {

            /*
             * Initialize Firebase Admin SDK only once.
             */

            if (FirebaseApp.getApps().isEmpty()) {

                InputStream serviceAccount =
                        getClass()
                                .getClassLoader()
                                .getResourceAsStream(
                                        "firebase/serviceAccountKey.json"
                                );

                if (serviceAccount == null) {

                    throw new ServletException(
                            "Firebase serviceAccountKey.json not found."
                    );
                }

                FirebaseOptions options =
                        FirebaseOptions.builder()
                                .setCredentials(
                                        GoogleCredentials
                                                .fromStream(serviceAccount)
                                )
                                .build();

                FirebaseApp.initializeApp(options);

                serviceAccount.close();
            }

            System.out.println(
                    "Firebase Admin SDK initialized successfully."
            );

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Firebase initialization failed.",
                    e
            );
        }
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println();
        System.out.println("=================================");
        System.out.println("GOOGLE LOGIN STARTED");
        System.out.println("=================================");


        /*
         * 1. Get Firebase ID token
         */

        String idToken =
                request.getParameter("idToken");


        if (idToken == null ||
            idToken.trim().isEmpty()) {

            System.out.println(
                    "ERROR: Firebase ID token missing."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/login?error=google-token"
            );

            return;
        }


        try {

            /*
             * 2. Verify Firebase token
             */

            FirebaseToken decodedToken =
                    FirebaseAuth
                            .getInstance()
                            .verifyIdToken(idToken);


            /*
             * 3. Get Google/Firebase user information
             */

            String firebaseUid =
                    decodedToken.getUid();

            String email =
                    decodedToken.getEmail();

            String name =
                    (String) decodedToken
                            .getClaims()
                            .get("name");

            String picture =
                    (String) decodedToken
                            .getClaims()
                            .get("picture");


            System.out.println(
                    "Google email: " + email
            );

            System.out.println(
                    "Google UID received: "
                            + (firebaseUid != null)
            );


            /*
             * 4. Validate email
             */

            if (email == null ||
                email.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/login?error=google-email"
                );

                return;
            }


            email =
                    email.trim().toLowerCase();


            /*
             * 5. Find admin by email
             */

            Admin admin =
                    adminDAO.getAdminByEmail(email);


            if (admin == null) {

                System.out.println(
                        "No admin found for Google email: "
                                + email
                );

                response.sendRedirect(
                        request.getContextPath()
                                + "/login?error=account-not-found"
                );

                return;
            }


            System.out.println(
                    "Admin found: "
                            + admin.getAdminId()
            );


            /*
             * 6. Save Google information
             */

            if (firebaseUid != null) {

                adminDAO.updateGoogleLogin(
                        admin.getAdminId(),
                        firebaseUid,
                        picture
                );
            }


            /*
             * 7. Create a fresh session
             *
             * Do NOT run ReminderScheduler here.
             */

            HttpSession oldSession =
                    request.getSession(false);

            if (oldSession != null) {

                oldSession.invalidate();
            }


            HttpSession session =
                    request.getSession(true);


            /*
             * 8. Store the SAME session attributes
             *    used by AuthenticationFilter
             */

            session.setAttribute(
                    "adminId",
                    admin.getAdminId()
            );

            session.setAttribute(
                    "adminName",
                    admin.getName()
            );

            session.setAttribute(
                    "adminUsername",
                    admin.getUsername()
            );

            session.setAttribute(
                    "adminEmail",
                    admin.getEmail()
            );

            session.setAttribute(
                    "adminPhone",
                    admin.getPhone()
            );


            /*
             * 9. Profile image
             */

            if (picture != null &&
                !picture.trim().isEmpty()) {

                session.setAttribute(
                        "profileImage",
                        picture
                );

            } else if (
                    admin.getProfileImage() != null &&
                    !admin.getProfileImage()
                            .trim()
                            .isEmpty()) {

                session.setAttribute(
                        "profileImage",
                        admin.getProfileImage()
                );
            }


            /*
             * 10. Login type
             */

            session.setAttribute(
                    "loginType",
                    "GOOGLE"
            );


            /*
             * 11. Debug session
             */

            System.out.println(
                    "Session created successfully."
            );

            System.out.println(
                    "Session ID: "
                            + session.getId()
            );

            System.out.println(
                    "adminUsername: "
                            + session.getAttribute(
                                    "adminUsername"
                            )
            );


            /*
             * 12. Redirect to dashboard
             */

            System.out.println(
                    "GOOGLE LOGIN SUCCESS"
            );

            System.out.println(
                    "Redirecting to dashboard..."
            );

            System.out.println(
                    "================================="
            );


            response.sendRedirect(
                    request.getContextPath()
                            + "/dashboard"
            );


        } catch (Exception e) {

            System.out.println();
            System.out.println(
                    "================================="
            );

            System.out.println(
                    "GOOGLE LOGIN FAILED"
            );

            System.out.println(
                    "================================="
            );

            e.printStackTrace();


            response.sendRedirect(
                    request.getContextPath()
                            + "/login?error=google-login"
            );
        }
    }
}