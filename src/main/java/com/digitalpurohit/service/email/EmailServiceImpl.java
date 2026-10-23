package com.digitalpurohit.service.email;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailServiceImpl implements EmailService {

    // CHANGE THESE
	private static final String EMAIL =
	        "chintalapatianirudh2005@gmail.com";

	private static final String PASSWORD =
	        "xlfx muul xdem poic";

    @Override
    public boolean sendEmail(String to,
                             String subject,
                             String body) {

        try {

            Properties props = new Properties();

            props.put("mail.smtp.host",
                    "smtp.gmail.com");

            props.put("mail.smtp.port",
                    "587");

            props.put("mail.smtp.auth",
                    "true");

            props.put("mail.smtp.starttls.enable",
                    "true");

            Session session =
                    Session.getInstance(props,

                    new Authenticator() {

                        @Override
                        protected PasswordAuthentication
                        getPasswordAuthentication() {

                            return new PasswordAuthentication(
                                    EMAIL,
                                    PASSWORD);

                        }

                    });

            Message message =
                    new MimeMessage(session);

            message.setFrom(
                    new InternetAddress(EMAIL));

            message.setRecipients(
                    Message.RecipientType.TO,

                    InternetAddress.parse(to));

            message.setSubject(subject);

            message.setText(body);

            Transport.send(message);

            System.out.println(
                    "Email Sent Successfully");

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            return false;

        }

    }

}