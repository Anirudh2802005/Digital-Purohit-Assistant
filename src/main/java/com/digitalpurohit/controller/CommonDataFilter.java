package com.digitalpurohit.controller;

import java.io.IOException;

import com.digitalpurohit.dao.NotificationDAO;
import com.digitalpurohit.dao.impl.NotificationDAOImpl;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class CommonDataFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;

        HttpSession session = req.getSession(false);

        if (session != null &&
            session.getAttribute("adminId") != null) {

            int adminId =
                    (Integer) session.getAttribute("adminId");

            NotificationDAO notificationDAO =
                    new NotificationDAOImpl();

            int unreadCount =
                    notificationDAO.getUnreadCount(adminId);

            req.setAttribute("unreadCount", unreadCount);
        }

        chain.doFilter(request, response);
    }
}