package com.digitalpurohit.dao;
import com.digitalpurohit.model.CustomerHistory;
import java.util.List;

import com.digitalpurohit.model.Customer;

public interface CustomerDAO {

    boolean saveCustomer(Customer customer);

    boolean updateCustomer(Customer customer);

    boolean deleteCustomer(int customerId, int adminId);
    Customer getCustomerByPhone(
            String phone,
            int adminId);
    
    boolean updateCustomer(Customer customer, int adminId);
    int getCustomerCount(int adminId);

    List<Customer> getAllCustomers(int adminId);

    List<Customer> searchCustomers(String keyword, int adminId);
    Customer getCustomerById(int customerId, int adminId);
    Customer getCustomerByPhone(String phone);
    
    List<Customer> getAllCustomers();

    List<Customer> searchCustomers(String keyword);

    List<Customer> getFrequentCustomers();

    
    
 // ================= Dashboard =================

    int getTotalCustomerCount();

    int getNewCustomersThisMonth();

    int getFrequentCustomerCount();
    
    List<CustomerHistory> getCustomerHistory(int customerId);

    Customer getCustomerById(int customerId);
    int saveCustomerAndReturnId(Customer customer);
    
    
    
}