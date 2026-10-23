package com.digitalpurohit.service.email;

public interface EmailService {

    boolean sendEmail(String to,
                      String subject,
                      String body);

}