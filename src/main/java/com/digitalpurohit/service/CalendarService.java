package com.digitalpurohit.service;

import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.PanchangDAO;
import com.digitalpurohit.dao.impl.PanchangDAOImpl;
import com.digitalpurohit.model.CalendarDay;
import com.digitalpurohit.model.Event;
import com.digitalpurohit.model.Panchang;
import com.digitalpurohit.dao.EventDAO;
import com.digitalpurohit.dao.impl.EventDAOImpl;
public class CalendarService {

    private final PanchangDAO panchangDAO;
    private EventDAO eventDAO = new EventDAOImpl();
    public CalendarService() {
        panchangDAO = new PanchangDAOImpl();
    }

    public List<CalendarDay> generateCalendar(
            int month,
            int year,
            LocalDate selectedDate,
            int adminId)
    {

        List<CalendarDay> calendar = new ArrayList<>();

        YearMonth yearMonth = YearMonth.of(year, month);

        LocalDate firstDay = yearMonth.atDay(1);

        LocalDate today = LocalDate.now();

        /* Find the first Sunday of the calendar */

        LocalDate start = firstDay;

        while (start.getDayOfWeek() != DayOfWeek.SUNDAY) {
            start = start.minusDays(1);
        }

        LocalDate current = start;

        /* Always create 42 cells */

        for (int i = 0; i < 42; i++) {

            CalendarDay day = new CalendarDay(current);

            day.setCurrentMonth(current.getMonthValue() == month);

            day.setToday(current.equals(today));

            day.setSelected(current.equals(selectedDate));

            loadPanchang(day);
         // ✅ Keep count (optional)
            day.setEventCount(
                    eventDAO.getEventCountByDate(
                            Date.valueOf(day.getDate()),
                            adminId));

            // 🔥 ADD THIS (IMPORTANT)
            List<Event> events =
                    eventDAO.getEventsByDate(
                            Date.valueOf(day.getDate()),
                            adminId);

            day.setEvents(events);
            calendar.add(day);

            current = current.plusDays(1);

        }

        return calendar;
    }

    /**
     * Load P details from database
     */
    private void loadPanchang(CalendarDay day) {

        try {

            Panchang p = panchangDAO.getPanchangByDate(
                    Date.valueOf(day.getDate()));

            if (p == null) {

                day.setTithi("");
                day.setFestival("");
                day.setSunrise("");
                day.setSunset("");
                return;
            }

            day.setTithi(p.getTithi());
            day.setFestival(p.getFestival());
            day.setWeekday(p.getWeekdayTelugu());

            day.setTithiEndTime(p.getTithiEndTime());

            day.setNakshatra(p.getNakshatra());

           day.setNakshatraEndTime(p.getNakshatraEndTime());

            day.setNotes(p.getNotes());
            day.setSunrise(
                p.getSunrise() == null ? "" : p.getSunrise().toString());

            day.setSunset(
                p.getSunset() == null ? "" : p.getSunset().toString());

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

}