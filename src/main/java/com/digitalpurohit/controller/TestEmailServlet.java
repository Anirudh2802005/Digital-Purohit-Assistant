package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.service.email.EmailService;
import com.digitalpurohit.service.email.EmailServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/test-email")
public class TestEmailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EmailService emailService;

    @Override
    public void init() {

        emailService = new EmailServiceImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        boolean success = emailService.sendEmail(

                "YOUR_EMAIL@gmail.com",

                "Digital Purohit Test Email",

                "Congratulations!\n\n"
              + "Your Email Service is working successfully.\n\n"
              + "Digital Purohit Assistant");

        response.setContentType("text/plain");

        if(success){

            response.getWriter().println(
                    "Email Sent Successfully.");

        }else{

            response.getWriter().println(
                    "Failed to Send Email.");

        }

    }

}