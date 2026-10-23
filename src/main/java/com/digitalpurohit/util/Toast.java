package com.digitalpurohit.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class Toast {

    // ==========================
    // SUCCESS
    // ==========================
    public static void success(HttpServletRequest request,
                               String title,
                               String message) {

        HttpSession session = request.getSession();

        session.setAttribute("toastType", "success");
        session.setAttribute("toastTitle", title);
        session.setAttribute("toastMessage", message);

    }

    // ==========================
    // ERROR
    // ==========================
    public static void error(HttpServletRequest request,
                             String title,
                             String message) {

        HttpSession session = request.getSession();

        session.setAttribute("toastType", "error");
        session.setAttribute("toastTitle", title);
        session.setAttribute("toastMessage", message);

    }

    // ==========================
    // WARNING
    // ==========================
    public static void warning(HttpServletRequest request,
                               String title,
                               String message) {

        HttpSession session = request.getSession();

        session.setAttribute("toastType", "warning");
        session.setAttribute("toastTitle", title);
        session.setAttribute("toastMessage", message);

    }

    // ==========================
    // INFO
    // ==========================
    public static void info(HttpServletRequest request,
                            String title,
                            String message) {

        HttpSession session = request.getSession();

        session.setAttribute("toastType", "info");
        session.setAttribute("toastTitle", title);
        session.setAttribute("toastMessage", message);

    }

}