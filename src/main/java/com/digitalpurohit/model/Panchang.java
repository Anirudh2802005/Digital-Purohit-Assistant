package com.digitalpurohit.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Panchang {

    private int panchangId;
    private String tithiEndTime;
    private String nakshatraEndTime;
    private Date panchangDate;

    private String weekdayTelugu;

    private String tithi;

    private String nakshatra;

    private String yoga;

    private String karana;

    private String masa;

    private String paksha;

    private String ritu;

    private String ayana;

    private Time sunrise;

    private Time sunset;

    private Time moonrise;

    private Time moonset;

    private String rahukalam;

    private String yamagandam;

    private String gulika;

    private String durmuhurtham;

    private String abhijitMuhurtham;

    private String amritakalam;

    private String varjyam;

    private String festival;

    private String notes;

    private Timestamp createdAt;

    public Panchang() {

    }

    /*==============================
            GETTERS & SETTERS
    ==============================*/

    public int getPanchangId() {
        return panchangId;
    }

    public void setPanchangId(int panchangId) {
        this.panchangId = panchangId;
    }

    public Date getPanchangDate() {
        return panchangDate;
    }

    public void setPanchangDate(Date panchangDate) {
        this.panchangDate = panchangDate;
    }

    public String getWeekdayTelugu() {
        return weekdayTelugu;
    }

    public void setWeekdayTelugu(String weekdayTelugu) {
        this.weekdayTelugu = weekdayTelugu;
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

    public String getYoga() {
        return yoga;
    }

    public void setYoga(String yoga) {
        this.yoga = yoga;
    }

    public String getKarana() {
        return karana;
    }

    public void setKarana(String karana) {
        this.karana = karana;
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

    public String getRitu() {
        return ritu;
    }

    public void setRitu(String ritu) {
        this.ritu = ritu;
    }

    public String getAyana() {
        return ayana;
    }

    public void setAyana(String ayana) {
        this.ayana = ayana;
    }

    public Time getSunrise() {
        return sunrise;
    }

    public void setSunrise(Time sunrise) {
        this.sunrise = sunrise;
    }

    public Time getSunset() {
        return sunset;
    }

    public void setSunset(Time sunset) {
        this.sunset = sunset;
    }

    public Time getMoonrise() {
        return moonrise;
    }

    public void setMoonrise(Time moonrise) {
        this.moonrise = moonrise;
    }

    public Time getMoonset() {
        return moonset;
    }

    public void setMoonset(Time moonset) {
        this.moonset = moonset;
    }

    public String getRahukalam() {
        return rahukalam;
    }

    public void setRahukalam(String rahukalam) {
        this.rahukalam = rahukalam;
    }

    public String getYamagandam() {
        return yamagandam;
    }

    public void setYamagandam(String yamagandam) {
        this.yamagandam = yamagandam;
    }

    public String getGulika() {
        return gulika;
    }

    public void setGulika(String gulika) {
        this.gulika = gulika;
    }

    public String getDurmuhurtham() {
        return durmuhurtham;
    }

    public void setDurmuhurtham(String durmuhurtham) {
        this.durmuhurtham = durmuhurtham;
    }

    public String getAbhijitMuhurtham() {
        return abhijitMuhurtham;
    }

    public void setAbhijitMuhurtham(String abhijitMuhurtham) {
        this.abhijitMuhurtham = abhijitMuhurtham;
    }

    public String getAmritakalam() {
        return amritakalam;
    }

    public void setAmritakalam(String amritakalam) {
        this.amritakalam = amritakalam;
    }

    public String getVarjyam() {
        return varjyam;
    }

    public void setVarjyam(String varjyam) {
        this.varjyam = varjyam;
    }

    public String getFestival() {
        return festival;
    }

    public void setFestival(String festival) {
        this.festival = festival;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
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

}