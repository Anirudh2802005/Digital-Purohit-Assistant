package com.digitalpurohit.controller;
import com.digitalpurohit.util.Toast;
import java.io.IOException;

import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.dao.impl.CustomerDAOImpl;
import com.digitalpurohit.model.Customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/edit-customer")
public class EditCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CustomerDAO customerDAO;

    @Override
    public void init() {

        customerDAO = new CustomerDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

    	int customerId =
    	        Integer.parseInt(
    	                request.getParameter("customerId"));
    	HttpSession session =
    	        request.getSession(false);

    	int adminId =
    	        (Integer) session.getAttribute("adminId");

    	Customer customer =
    	        customerDAO.getCustomerById(
    	                customerId,
    	                adminId);
    	if (customer == null) {

    	    Toast.error(
    	            request,
    	            "Access Denied",
    	            "Customer not found.");

    	    response.sendRedirect(
    	            request.getContextPath()
    	            + "/customers");

    	    return;
    	}

        request.setAttribute(
                "customer",
                customer);

        request.getRequestDispatcher(
                "/WEB-INF/views/customer/customer-form.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        Customer customer = new Customer();

        customer.setCustomerId(
                Integer.parseInt(
                        request.getParameter("customerId")));

        customer.setCustomerName(
                request.getParameter("customerName"));

        customer.setPhone(
                request.getParameter("phone"));

        customer.setAddress(
                request.getParameter("address"));

        customer.setGothram(
                request.getParameter("gothram"));

        customer.setNotes(
                request.getParameter("notes"));
        
        HttpSession session =
                request.getSession(false);

        int adminId =
                (Integer) session.getAttribute("adminId");

        customer.setAdminId(adminId);

        boolean success = customerDAO.updateCustomer(customer);

        if (success) {

            Toast.success(
                    request,
                    "Customer Updated",
                    customer.getCustomerName() + " was updated successfully."
            );

        } else {

            Toast.error(
                    request,
                    "Update Failed",
                    "Unable to update customer."
            );

        }

        response.sendRedirect(
                request.getContextPath() + "/customers");
    }
}