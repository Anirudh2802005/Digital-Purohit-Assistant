package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.List;

import com.digitalpurohit.dao.SamagriDAO;
import com.digitalpurohit.dao.impl.SamagriDAOImpl;
import com.digitalpurohit.model.Samagri;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/samagri")
public class SamagriServlet extends HttpServlet {


private static final long serialVersionUID = 1L;

private SamagriDAO samagriDAO;

@Override
public void init() {

    samagriDAO = new SamagriDAOImpl();
}

@Override
protected void doGet(HttpServletRequest request,
                     HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session =
            request.getSession(false);

    int adminId =
            (Integer) session.getAttribute("adminId");

    String keyword =
            request.getParameter("keyword");

    List<Samagri> samagriList;

    if (keyword != null &&
        !keyword.trim().isEmpty()) {

        samagriList =
                samagriDAO.searchSamagri(
                        keyword,
                        adminId);

    } else {

        samagriList =
                samagriDAO.getAllSamagri(
                        adminId);
    }

    request.setAttribute(
            "samagriList",
            samagriList);

    request.getRequestDispatcher(
            "/WEB-INF/views/samagri/samagri-list.jsp")
            .forward(request, response);
}

}
