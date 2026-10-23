package com.digitalpurohit.util;

import java.util.List;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.dao.impl.BulkEventCustomerDAOImpl;
import com.digitalpurohit.model.BulkEventCustomer;

public class BulkEventCustomerTest {

    public static void main(String[] args) {

        BulkEventCustomerDAO dao =
                new BulkEventCustomerDAOImpl();

        List<BulkEventCustomer> customers =
                dao.getCustomersByBulkEvent(1);

        for(BulkEventCustomer customer : customers) {

            System.out.println(
                    customer.getCustomerId()
                    + " | "
                    + customer.getPaymentStatus()
                    + " | "
                    + customer.getAmountPaid());
        }
    }
}