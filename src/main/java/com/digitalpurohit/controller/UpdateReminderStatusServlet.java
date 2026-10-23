package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.ReminderDAO;
import com.digitalpurohit.dao.impl.ReminderDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/update-reminder-status")
public class UpdateReminderStatusServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ReminderDAO reminderDAO;


    @Override
    public void init() {

        reminderDAO =
                new ReminderDAOImpl();
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType(
                "application/json");

        response.setCharacterEncoding(
                "UTF-8");


        try {

            // =========================================
            // SESSION
            // =========================================

            HttpSession session =
                    request.getSession(false);


            if (
                session == null ||
                session.getAttribute("adminId") == null
            ) {

                response.setStatus(
                        HttpServletResponse.SC_UNAUTHORIZED
                );

                response.getWriter().print(
                        "{\"success\":false}"
                );

                return;
            }


            // =========================================
            // ADMIN ID
            // =========================================

            int adminId =
                    (Integer)
                    session.getAttribute(
                            "adminId"
                    );


            // =========================================
            // PARAMETERS
            // =========================================

            int reminderId =
                    Integer.parseInt(
                            request.getParameter("id")
                    );


            boolean enabled =
                    Boolean.parseBoolean(
                            request.getParameter(
                                    "enabled"
                            )
                    );


            // =========================================
            // UPDATE
            // =========================================

            boolean success =
                    reminderDAO.updateReminderStatus(
                            reminderId,
                            enabled,
                            adminId
                    );


            // =========================================
            // RESPONSE
            // =========================================

            response.getWriter().print(
                    "{\"success\":"
                    + success
                    + "}"
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().print(
                    "{\"success\":false}"
            );
        }
    }
}