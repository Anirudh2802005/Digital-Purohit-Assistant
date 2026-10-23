package com.digitalpurohit.dao;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import com.digitalpurohit.model.Event;

public interface EventDAO {

    // ================= CRUD =================

    int saveEvent(Event event);

    boolean updateEvent(Event event);

    boolean deleteEvent(int eventId);

    Event getEventById(int eventId);

    Event getEventById(int eventId, int adminId);

    Event getEvent(int eventId);

    // ================= Event List =================

    
    
    List<Event> getAllEvents();

    List<Event> getAllEvents(int adminId);

    List<Event> searchEvents(String keyword);

    List<Event> searchEvents(String keyword,
                             int adminId);

    // ================= Filters =================

    List<Event> getTodayEvents();

   
    List<Event> getUpcomingEvents();

    List<Event> getUpcomingEvents(int adminId);

    List<Event> getPendingPaymentEvents();

    List<Event> getPendingPaymentEvents(int adminId);

    List<Event> getEventsByType(int typeId);

    List<Event> getEventsByType(int typeId,
                                int adminId);
    int getEventCountByDate(Date eventDate, int adminId);
    List<Event> getEventsByDate(Date date,
            int adminId);
    List<Event> getEventsByCustomer(int customerId);

    List<Event> getWeeklyEvents();

    List<Event> getMonthlyEvents();

    List<Event> getFridayEvents();

    List<Event> getEventsByPaymentStatus(
            String paymentStatus);
    int getEventCountByType(int typeId, int adminId);

    double getTotalIncomeByType(int typeId, int adminId);
    List<Event> getPendingPaymentEventsByAdmin(int adminId);

    // ================= Statistics =================

    int getEventCount();

    int getEventCountByType(int typeId);

    int getEventCountByDate(LocalDate date);

    double getTotalIncomeByType(int typeId);

    double getTodayIncome();

    double getMonthlyIncome();

    double getYearlyIncome();

    double getEventIncome(int eventId);

    double getPendingIncome();

    // ================= Payment =================

    boolean receivePayment(
            int eventId,
            double receiveAmount,
            String notes);

    boolean updatePaymentStatus(
            int eventId,
            String paymentStatus,
            double amountReceived);

    // ================= Conflict Checking =================

    Event getConflictEvent(
            java.sql.Date eventDate,
            java.sql.Time eventTime);

    Event getCustomerConflict(
            String phone,
            java.sql.Date eventDate);

    Event getPreviousEvent(
            java.sql.Date eventDate,
            java.sql.Time eventTime);

    // ================= Dashboard =================
    boolean updateEvent(Event event, int adminId);

    boolean deleteEvent(int eventId, int adminId);
    int getTodayEventCount();


    int getTotalEvents(int adminId);

    List<Event> getEventsByMonth(int year, int month, int adminId);
    int getUpcomingEventsCount(int adminId);

    int getPendingPaymentsCount(int adminId);
    
    
    List<Event> getUpcomingEventsByAdmin(int adminId);
    // ================= Events Dashboard =================

    int getTotalEvents();

    int getUpcomingEventsCount();

    int getPendingPaymentsCount();
    int getEventCount(int adminId);

    int getTodayEventCount(int adminId);

    double getTodayIncome(int adminId);

    double getMonthlyIncome(int adminId);

    double getPendingIncome(int adminId);

    List<Event> getUpcomingEvents(int limit, int adminId);

    List<Event> getTodayEvents(int adminId);
}