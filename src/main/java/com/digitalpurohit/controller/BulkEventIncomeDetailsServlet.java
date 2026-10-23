package com.digitalpurohit.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.BulkEventIncomeDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.dao.impl.BulkEventIncomeDAOImpl;
import com.digitalpurohit.model.BulkEventCustomer;
import com.digitalpurohit.model.BulkEventIncomeReport;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.http.HttpSession;
@WebServlet("/bulk-event-income-details")
public class BulkEventIncomeDetailsServlet
extends HttpServlet{

    private static final long serialVersionUID = 1L;

    private BulkEventIncomeDAO incomeDAO;

    private BulkEventCustomerDAO customerDAO;

    @Override
    public void init(){

        incomeDAO =
                new BulkEventIncomeDAOImpl();

        customerDAO =
                new BulkEventCustomerDAOImpl();

    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int bulkEventId =
                Integer.parseInt(
                request.getParameter(
                "bulkEventId"));
        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");
        BulkEventIncomeReport summary =
                incomeDAO.getBulkEventSummary(
                        bulkEventId,
                        adminId);

        List<BulkEventCustomer> families =
                customerDAO.getFamilyDetails(
                        bulkEventId,
                        adminId);

        request.setAttribute(
                "summary",
                summary);

        request.setAttribute(
                "families",
                families);
        
        double totalAmount = 0;

        double receivedAmount = 0;

        double pendingAmount = 0;

        int paidFamilies = 0;

        int partialFamilies = 0;

        int pendingFamilies = 0;

        for(BulkEventCustomer family : families){

            totalAmount += family.getTotalAmount();

            receivedAmount += family.getAmountPaid();

            pendingAmount +=
                    family.getTotalAmount()
                    - family.getAmountPaid();

            if("PAID".equals(family.getPaymentStatus())){

                paidFamilies++;

            }else if("PARTIAL".equals(family.getPaymentStatus())){

                partialFamilies++;

            }else{

                pendingFamilies++;

            }

        }
        double collectionPercentage = 0;

        if(totalAmount > 0){

            collectionPercentage =
                    (receivedAmount * 100)
                    / totalAmount;

        }
        List<String> graphLabels =
                new ArrayList<>();

        List<Double> graphValues =
                new ArrayList<>();

        for(BulkEventCustomer family : families){

            graphLabels.add(
                    family.getCustomerName());

            graphValues.add(
                    family.getAmountPaid());

        }
        Map<String,Integer> paymentStatus =
                new LinkedHashMap<>();

        paymentStatus.put(
                "Paid",
                paidFamilies);

        paymentStatus.put(
                "Partial",
                partialFamilies);

        paymentStatus.put(
                "Pending",
                pendingFamilies);
        request.setAttribute(
                "totalAmount",
                totalAmount);

        request.setAttribute(
                "receivedAmount",
                receivedAmount);

        request.setAttribute(
                "pendingAmount",
                pendingAmount);

        request.setAttribute(
                "collectionPercentage",
                collectionPercentage);

        request.setAttribute(
                "graphLabels",
                graphLabels);

        request.setAttribute(
                "graphValues",
                graphValues);

        request.setAttribute(
                "paymentStatus",
                paymentStatus);
        request.getRequestDispatcher(

        		"/WEB-INF/views/reports/bulk-event-income-details.jsp")

        		.forward(request,response);

        		}
        		}