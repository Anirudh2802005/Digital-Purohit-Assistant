package com.digitalpurohit.model;

import java.time.LocalDate;
import java.util.List;

public class CalendarDay {

    private LocalDate date;
    private int eventCount;
    private int day;

    private int month;

    private int year;

    private boolean currentMonth;

    private boolean today;

    private boolean selected;
    private String weekday;
    private String tithiEndTime;
    
    private String nakshatraEndTime;
    private String notes;
    // Panchang Details
    private String tithi;
    private String nakshatra;
    private String masa;
    private String paksha;
    private String sunrise;
    private String sunset;
    private String festival;
    
    private List<Event> events;

    public List<Event> getEvents() {
        return events;
    }

    public void setEvents(List<Event> events) {
        this.events = events;
    }
    public int getEventCount() {
        return eventCount;
    }

    public void setEventCount(int eventCount) {
        this.eventCount = eventCount;
    }
    public CalendarDay() {

    }

    public CalendarDay(LocalDate date) {
        this.date = date;
        this.day = date.getDayOfMonth();
        this.month = date.getMonthValue();
        this.year = date.getYear();
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public int getDay() {
        return day;
    }

    public void setDay(int day) {
        this.day = day;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public boolean isCurrentMonth() {
        return currentMonth;
    }

    public void setCurrentMonth(boolean currentMonth) {
        this.currentMonth = currentMonth;
    }

    public boolean isToday() {
        return today;
    }

    public void setToday(boolean today) {
        this.today = today;
    }

    public boolean isSelected() {
        return selected;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    public String getTithi() {
        return tithi;
    }

    public void setTithi(String tithi) {
        this.tithi = tithi;
    }

    public String getNakshatra() {
        return nakshatra;
    }

    public void setNakshatra(String nakshatra) {
        this.nakshatra = nakshatra;
    }

    public String getMasa() {
        return masa;
    }

    public void setMasa(String masa) {
        this.masa = masa;
    }

    public String getPaksha() {
        return paksha;
    }

    public void setPaksha(String paksha) {
        this.paksha = paksha;
    }

    public String getSunrise() {
        return sunrise;
    }

    public void setSunrise(String sunrise) {
        this.sunrise = sunrise;
    }

    public String getSunset() {
        return sunset;
    }

    public void setSunset(String sunset) {
        this.sunset = sunset;
    }

    public String getFestival() {
        return festival;
    }

    public void setFestival(String festival) {
        this.festival = festival;
    }
    public String getWeekday() {
        return weekday;
    }

    public void setWeekday(String weekday) {
        this.weekday = weekday;
    }

    public String getTithiEndTime() {
        return tithiEndTime;
    }

    public void setTithiEndTime(String tithiEndTime) {
        this.tithiEndTime = tithiEndTime;
    }

   

    public String getNakshatraEndTime() {
        return nakshatraEndTime;
    }

    public void setNakshatraEndTime(String nakshatraEndTime) {
        this.nakshatraEndTime = nakshatraEndTime;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    
}