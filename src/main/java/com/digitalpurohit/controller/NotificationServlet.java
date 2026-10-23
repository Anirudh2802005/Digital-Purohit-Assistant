package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.NotificationDAO;
import com.digitalpurohit.dao.impl.NotificationDAOImpl;
import com.digitalpurohit.model.Notification;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private NotificationDAO notificationDAO;

    private Gson gson;

    // =========================================================
    // INIT
    // =========================================================

    @Override
    public void init() {

        notificationDAO =
                new NotificationDAOImpl();

        gson =
                new Gson();
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
        // RESPONSE CONFIGURATION
        // -----------------------------------------------------

        response.setContentType(
                "application/json"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );

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

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED
            );

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Not logged in\"}"
            );

            return;
        }

        // -----------------------------------------------------
        // GET CURRENT ADMIN ID
        // -----------------------------------------------------

        Object adminIdObject =
                session.getAttribute("adminId");

        int adminId;

        try {

            if (adminIdObject instanceof Integer) {

                adminId =
                        (Integer) adminIdObject;

            } else {

                adminId =
                        Integer.parseInt(
                                adminIdObject.toString()
                        );
            }

        } catch (Exception e) {

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED
            );

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Invalid admin session\"}"
            );

            return;
        }

        // -----------------------------------------------------
        // GET ACTION
        // -----------------------------------------------------

        String action =
                request.getParameter("action");

        System.out.println(
                "NOTIFICATION GET"
                + " | ADMIN ID = "
                + adminId
                + " | ACTION = "
                + action
        );

        // =====================================================
        // ACTION: COUNT
        // =====================================================

        if ("count".equalsIgnoreCase(action)) {

            int count =
                    notificationDAO.getUnreadCount(
                            adminId
                    );

            response.getWriter().write(
                    "{\"count\":" +
                    count +
                    "}"
            );

            return;
        }

        // =====================================================
        // ACTION: LIST
        // =====================================================

        if ("list".equalsIgnoreCase(action)
                || action == null
                || action.trim().isEmpty()) {

            List<Notification> notifications =
                    notificationDAO.getAllNotifications(
                            adminId
                    );

            response.getWriter().write(
                    gson.toJson(
                            notifications
                    )
            );

            return;
        }

        // =====================================================
        // ACTION: UNREAD
        // =====================================================

        if ("unread".equalsIgnoreCase(action)) {

            List<Notification> notifications =
                    notificationDAO.getUnreadNotifications(
                            adminId
                    );

            response.getWriter().write(
                    gson.toJson(
                            notifications
                    )
            );

            return;
        }

        // =====================================================
        // UNKNOWN ACTION
        // =====================================================

        response.setStatus(
                HttpServletResponse.SC_BAD_REQUEST
        );

        response.getWriter().write(
                "{\"success\":false,\"message\":\"Unknown action\"}"
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
        // RESPONSE CONFIGURATION
        // -----------------------------------------------------

        response.setContentType(
                "application/json"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );

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

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED
            );

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Not logged in\"}"
            );

            return;
        }

        // -----------------------------------------------------
        // GET CURRENT ADMIN ID
        // -----------------------------------------------------

        Object adminIdObject =
                session.getAttribute("adminId");

        int adminId;

        try {

            if (adminIdObject instanceof Integer) {

                adminId =
                        (Integer) adminIdObject;

            } else {

                adminId =
                        Integer.parseInt(
                                adminIdObject.toString()
                        );
            }

        } catch (Exception e) {

            response.setStatus(
                    HttpServletResponse.SC_UNAUTHORIZED
            );

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Invalid admin session\"}"
            );

            return;
        }

        // -----------------------------------------------------
        // GET ACTION
        // -----------------------------------------------------

        String action =
                request.getParameter("action");

        System.out.println(
                "NOTIFICATION POST"
                + " | ADMIN ID = "
                + adminId
                + " | ACTION = "
                + action
        );

        // =====================================================
        // ACTION: DELETE
        // =====================================================

        if ("delete".equalsIgnoreCase(action)) {

            String idParameter =
                    request.getParameter("id");

            // -------------------------------------------------
            // VALIDATE ID
            // -------------------------------------------------

            if (idParameter == null ||
                idParameter.trim().isEmpty()) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Notification ID required\"}"
                );

                return;
            }

            int notificationId;

            try {

                notificationId =
                        Integer.parseInt(
                                idParameter
                        );

            } catch (NumberFormatException e) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Invalid notification ID\"}"
                );

                return;
            }

            // -------------------------------------------------
            // DELETE ONLY CURRENT ADMIN'S NOTIFICATION
            // -------------------------------------------------

            boolean success =
                    notificationDAO.deleteNotification(
                            notificationId,
                            adminId
                    );

            response.getWriter().write(
                    "{\"success\":" +
                    success +
                    "}"
            );

            return;
        }

        // =====================================================
        // ACTION: MARK ONE AS READ
        // =====================================================

        if ("markRead".equalsIgnoreCase(action)) {

            String idParameter =
                    request.getParameter("id");

            // -------------------------------------------------
            // VALIDATE ID
            // -------------------------------------------------

            if (idParameter == null ||
                idParameter.trim().isEmpty()) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Notification ID required\"}"
                );

                return;
            }

            int notificationId;

            try {

                notificationId =
                        Integer.parseInt(
                                idParameter
                        );

            } catch (NumberFormatException e) {

                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST
                );

                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Invalid notification ID\"}"
                );

                return;
            }

            // -------------------------------------------------
            // MARK ONLY CURRENT ADMIN'S NOTIFICATION
            // -------------------------------------------------

            boolean success =
                    notificationDAO.markAsRead(
                            notificationId,
                            adminId
                    );

            response.getWriter().write(
                    "{\"success\":" +
                    success +
                    "}"
            );

            return;
        }
     // =====================================================
     // MARK ONE NOTIFICATION AS READ
     // =====================================================

     if ("markRead".equals(action)) {

         String idParameter =
                 request.getParameter("id");

         if (idParameter == null ||
             idParameter.trim().isEmpty()) {

             response.getWriter().write(
                     "{\"success\":false,\"message\":\"Notification ID missing\"}"
             );

             return;
         }

         int notificationId =
                 Integer.parseInt(idParameter);

         boolean success =
                 notificationDAO.markAsRead(
                         notificationId,
                         adminId
                 );

         response.getWriter().write(
                 "{\"success\":" +
                 success +
                 "}"
         );

         return;
     }
        // =====================================================
        // ACTION: MARK ALL AS READ
        // =====================================================

        if ("markAllRead".equalsIgnoreCase(action)) {

            boolean success =
                    notificationDAO.markAllAsRead(
                            adminId
                    );

            response.getWriter().write(
                    "{\"success\":" +
                    success +
                    "}"
            );

            return;
        }

        // =====================================================
        // ACTION: DELETE ALL
        // =====================================================

        if ("deleteAll".equalsIgnoreCase(action)) {

            boolean success =
                    notificationDAO.deleteAllNotifications(
                            adminId
                    );

            response.getWriter().write(
                    "{\"success\":" +
                    success +
                    "}"
            );

            return;
        }

        // =====================================================
        // UNKNOWN ACTION
        // =====================================================

        response.setStatus(
                HttpServletResponse.SC_BAD_REQUEST
        );

        response.getWriter().write(
                "{\"success\":false,\"message\":\"Unknown action\"}"
        );
    }
}