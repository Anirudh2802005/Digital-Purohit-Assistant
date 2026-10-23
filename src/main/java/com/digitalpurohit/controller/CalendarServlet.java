package com.digitalpurohit.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.Month;
import java.time.format.TextStyle;
import java.util.List;
import java.util.Locale;

import com.digitalpurohit.model.CalendarDay;
import com.digitalpurohit.service.CalendarService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/calendar")
public class CalendarServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CalendarService calendarService;

    @Override
    public void init() throws ServletException {
        calendarService = new CalendarService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate today = LocalDate.now();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");
        int month = today.getMonthValue();
        int year = today.getYear();

        /* -----------------------------
           Read Month & Year
        ------------------------------ */

        try {

            if (request.getParameter("month") != null) {

                month = Integer.parseInt(request.getParameter("month"));

            }

            if (request.getParameter("year") != null) {

                year = Integer.parseInt(request.getParameter("year"));

            }

        } catch (NumberFormatException e) {

            month = today.getMonthValue();
            year = today.getYear();

        }

        /* -----------------------------
           Fix Month Overflow
        ------------------------------ */

        if (month < 1) {

            month = 12;
            year--;

        } else if (month > 12) {

            month = 1;
            year++;

        }

        /* -----------------------------
           Selected Date
        ------------------------------ */

        LocalDate selectedDate = today;

        String selected = request.getParameter("selected");

        if (selected != null && !selected.isBlank()) {

            try {

                selectedDate = LocalDate.parse(selected);

            } catch (Exception e) {

                selectedDate = today;

            }

        }

        /* -----------------------------
           Generate Calendar
        ------------------------------ */

        List<CalendarDay> calendarDays =
        		calendarService.generateCalendar(
        		        month,
        		        year,
        		        selectedDate,
        		        adminId);

        /* -----------------------------
           Find Selected Day
        ------------------------------ */

        CalendarDay selectedDay = null;

        for (CalendarDay day : calendarDays) {

            if (day.getDate() != null &&
                day.getDate().equals(selectedDate)) {

                selectedDay = day;
                break;

            }

        }
        

        /* -----------------------------
           Month Name
        ------------------------------ */

        String monthName = Month.of(month)
                .getDisplayName(TextStyle.FULL, Locale.ENGLISH);

        /* -----------------------------
           Send to JSP
        ------------------------------ */

        request.setAttribute("calendarDays", calendarDays);
        request.setAttribute("month", month);
        request.setAttribute("year", year);
        request.setAttribute("monthName", monthName);

        request.setAttribute("today", today);

        request.setAttribute("selectedDate", selectedDate);
        request.setAttribute("selectedDay", selectedDay);

        request.getRequestDispatcher(
                "/WEB-INF/views/calendar/calendar.jsp")
                .forward(request, response);
    }

}