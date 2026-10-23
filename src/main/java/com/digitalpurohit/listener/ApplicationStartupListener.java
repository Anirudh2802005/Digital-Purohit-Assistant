package com.digitalpurohit.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import com.digitalpurohit.service.ReminderScheduler;
@WebListener
public class ApplicationStartupListener
        implements ServletContextListener {
	private ReminderScheduler scheduler;
	@Override
	public void contextInitialized(ServletContextEvent sce) {

	    System.out.println("===================================");

	    System.out.println("Digital Purohit Started");

	    System.out.println("===================================");

	    scheduler = new ReminderScheduler();

	    scheduler.start();

	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {

	    if (scheduler != null) {

	        scheduler.stop();

	    }

	    System.out.println("Digital Purohit Stopped");

	}

}