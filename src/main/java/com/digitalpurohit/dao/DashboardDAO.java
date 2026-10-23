package com.digitalpurohit.dao;
import com.digitalpurohit.model.FrequentCustomer;
import java.util.List;

import com.digitalpurohit.model.DashboardSummary;
import com.digitalpurohit.model.Event;

public interface DashboardDAO {

    DashboardSummary getDashboardSummary();

    List<Event> getTodayEvents();

    List<Event> getTomorrowEvents();

    List<Event> getUpcomingEvents(int days);
    
    int getTotalCustomerCount(int adminId);

    int getNewCustomersThisMonth(int adminId);

    int getFrequentCustomerCount(int adminId);

    List<FrequentCustomer> getFrequentCustomers(int adminId);
    }