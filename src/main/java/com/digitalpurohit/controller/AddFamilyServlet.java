package com.digitalpurohit.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/add-family")
public class AddFamilyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
                "bulkEventId",
                request.getParameter("bulkEventId"));

        request.getRequestDispatcher(
                "/WEB-INF/views/bulk-event/family-form.jsp")
                .forward(request, response);

    }

}