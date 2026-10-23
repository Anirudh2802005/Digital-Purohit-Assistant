package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.dao.impl.AdminDAOImpl;
import com.digitalpurohit.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminDAO adminDAO;

    @Override
    public void init() {

        adminDAO = new AdminDAOImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/forgot-password.jsp")
                .forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username =
                request.getParameter("username");

        String phone =
                request.getParameter("phone");

        String password =
                request.getParameter("password");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if(!password.equals(confirmPassword)){

            request.setAttribute(
                    "errorMessage",
                    "Passwords do not match.");

            request.getRequestDispatcher(
                    "/WEB-INF/views/forgot-password.jsp")
                    .forward(request,response);

            return;

        }

        boolean success =
        		adminDAO.resetPassword(
        		        username,
        		        phone,
        		        PasswordUtil.hashPassword(password));

        if(success){

            request.setAttribute(
                    "successMessage",
                    "Password updated successfully. Please login.");

            request.getRequestDispatcher(
                    "/WEB-INF/views/login.jsp")
                    .forward(request,response);

        }else{

            request.setAttribute(
                    "errorMessage",
                    "Invalid Username or Phone Number.");

            request.getRequestDispatcher(
                    "/WEB-INF/views/forgot-password.jsp")
                    .forward(request,response);

        }

    }

}