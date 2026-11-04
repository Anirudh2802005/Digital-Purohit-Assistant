# 🕉️ Digital Purohit Assistant

### A Complete Digital Management System for Purohits

![Java](https://img.shields.io/badge/Java-21-orange)
![JSP](https://img.shields.io/badge/JSP-JavaServer%20Pages-blue)
![Servlets](https://img.shields.io/badge/Java-Servlets-red)
![MySQL](https://img.shields.io/badge/Database-MySQL-blue)
![Maven](https://img.shields.io/badge/Build-Maven-C71A36)
![Tomcat](https://img.shields.io/badge/Server-Tomcat%2010.1-yellow)
![Status](https://img.shields.io/badge/Project-Developed-success)

---

## 📌 1. Project Overview

**Digital Purohit Assistant** is a Java-based web application developed to digitize and simplify the daily operations of Purohits.

Traditionally, Purohits maintain customer details, event schedules, payment records, income information, and religious activity details using notebooks and manual records. Managing these records becomes difficult when the number of customers and events increases.

Digital Purohit Assistant provides a centralized platform where all these activities can be managed digitally.

The application helps Purohits:

- Maintain customer information in one place.
- Schedule and manage religious events.
- Track payments and pending amounts.
- Monitor monthly and overall income.
- Manage bulk events involving multiple customers.
- Maintain Kashi Yatra records.
- Organize Pooja Samagri requirements.
- Manage reminders and notifications.
- Access important information through a centralized dashboard.

### 🎯 Main Objective

The primary objective is to replace traditional manual record-keeping with a structured digital management system that improves organization, accessibility, accuracy, and efficiency.

---

# ✨ 2. Key Features

## 📊 2.1 Dashboard Management

The dashboard provides a centralized overview of important application information.

Features include:

- Overview of customers and events.
- Payment and income summaries.
- Pending payment information.
- Important activity details.
- Quick navigation to different modules.
- Visual representation of business information through reports and charts.

## 👥 2.2 Customer Management

The customer management module maintains customer information digitally.

Features:

- Add new customers.
- View customer details.
- Update customer information.
- Search and manage customer records.
- Access customer history.
- View associated events and payment information.

## 🗓️ 2.3 Event Management

The event management module helps organize and maintain religious event information.

Features:

- Create new events.
- Manage event details.
- Assign customers to events.
- Manage event types.
- View scheduled events.
- Update event information.
- Maintain event history.

This module makes it easier to organize and track different religious ceremonies and activities.

## 📋 2.4 Event Type Management

This module helps manage different categories of religious events.

Features:

- Add event types.
- Update event type details.
- View available event types.
- Activate or deactivate event types.
- Maintain event descriptions.

## 👨‍👩‍👧‍👦 2.5 Bulk Event Management

Bulk Event Management is designed to handle events involving multiple customers or families.

Features:

- Create bulk events.
- Manage family and customer records.
- Associate multiple customers with an event.
- Maintain bulk event information.
- Track payment details for bulk events.
- Manage customer-wise records.

This functionality helps reduce the effort required to manage events involving multiple participants.

## 💰 2.6 Payment Management

The payment management module helps maintain financial records and monitor customer payments.

Supported payment statuses include:

- **PAID:** The complete payment has been received.
- **PENDING:** Payment has not yet been received.
- **PARTIAL:** A portion of the total amount has been received.

Features:

- Record received payments.
- Manage pending payments.
- Receive partial payments.
- Update payment information.
- Track customer-wise payment status.
- Maintain payment history.
- Navigate from payment status to the relevant payment management screen.

## 📈 2.7 Income and Reports Management

The reports module provides information about the financial activities of the application.

Features:

- View income summaries.
- Monitor monthly income.
- Track received payments.
- Identify pending payments.
- Review payment information.
- View graphical representations of financial data.

These reports help Purohits understand their income and outstanding payments.

## 🛕 2.8 Kashi Yatra Management

The Kashi Yatra module maintains records related to Kashi Yatra activities and customers.

Features:

- Maintain Kashi Yatra records.
- Manage Kashi Yatra customer information.
- Store associated details in the database.
- Retrieve and manage existing records.

## 🪔 2.9 Pooja Samagri Management

The Pooja Samagri module helps organize the materials required for religious ceremonies.

Features:

- Maintain Samagri information.
- Manage Samagri checklists.
- Organize required materials.
- Retrieve Samagri details for management purposes.

## 🔔 2.10 Reminder and Notification Management

The reminder module helps manage important event-related reminders.

Features:

- Maintain reminder information.
- Manage enabled reminders.
- Display notification information.
- Access reminders through the application interface.

## 🔐 2.11 Authentication and Login

The application provides authentication functionality to manage application access.

Features:

- User login.
- User registration.
- Password management.
- Google Sign-In integration.
- Session-based application access.

---

# 🛠️ 3. Technology Stack

The application uses Java-based web development technologies.

| Technology | Purpose |
|---|---|
| Java 21 | Backend programming |
| Java Servlets | Request handling and business operations |
| JSP | Dynamic web page rendering |
| JDBC | Database connectivity |
| MySQL | Relational database |
| HTML5 | Web page structure |
| CSS3 | Styling and layout |
| JavaScript | Client-side interactions |
| Maven | Project and dependency management |
| Apache Tomcat 10.1 | Application server |
| Eclipse IDE | Development environment |
| Git | Version control |
| GitHub | Source code management |

---

# 🏗️ 4. Application Architecture

The application follows a layered architecture using the DAO (Data Access Object) design pattern.

This architecture separates request handling, business logic, database operations, and presentation.

### Architecture Flow

```text
             USER
               |
               v
        JSP / HTML / CSS
         Presentation Layer
               |
               v
          JAVA SERVLETS
         Controller Layer
               |
               v
          SERVICE LAYER
         Business Logic
               |
               v
           DAO LAYER
       Data Access Objects
               |
               v
          JDBC CONNECTION
               |
               v
           MYSQL DB
```

### Architecture Components

**1. Presentation Layer**

- JSP pages.
- HTML.
- CSS.
- JavaScript.

Responsible for displaying application information and collecting user input.

**2. Controller Layer**

- Java Servlets.

Responsible for receiving HTTP requests, processing user actions, and coordinating application operations.

**3. Service Layer**

Responsible for handling application business logic and coordinating operations between controllers and DAOs.

**4. DAO Layer**

The Data Access Object pattern is used to separate database operations from application logic.

Examples of DAO components include:

- AdminDAO
- CustomerDAO
- EventDAO
- EventTypeDAO
- SamagriDAO
- BulkEventDAO
- BulkEventCustomerDAO

**5. Database Layer**

MySQL stores application information, including customer details, event information, payment records, and other application data.

---

# 🗄️ 5. Database Management

The application uses MySQL as its relational database.

### Database Name

```sql
digital_purohit_assistant
```

### Database Responsibilities

The database is used to maintain:

- Admin and authentication information.
- Customer records.
- Event information.
- Event type information.
- Bulk event information.
- Bulk event customer associations.
- Payment information.
- Kashi Yatra information.
- Pooja Samagri information.
- Reminder information.

### Database Connectivity

JDBC is used to establish connectivity between the Java application and MySQL.

The application uses a centralized database connection utility to manage database connections.

---

# 📂 6. Project Structure

The project follows a Maven-based Java web application structure.

```text
Digital_Purohit_Assistant/
│
├── src/
│   └── main/
│       │
│       ├── java/
│       │   └── com/
│       │       └── digitalpurohit/
│       │           │
│       │           ├── controller/
│       │           │
│       │           ├── dao/
│       │           │
│       │           ├── dao/impl/
│       │           │
│       │           ├── model/
│       │           │
│       │           ├── service/
│       │           │
│       │           └── util/
│       │
│       ├── resources/
│       │
│       └── webapp/
│           │
│           ├── WEB-INF/
│           │   └── views/
│           │
│           ├── css/
│           │
│           ├── js/
│           │
│           ├── images/
│           │
│           └── index.jsp
│
├── pom.xml
├── .gitignore
└── README.md
```

*Note: This is a representative structure. Individual folders and files may vary in the actual repository.*

---

# ⚙️ 7. Installation and Configuration

Follow these steps to run the application locally.

### Prerequisites

Install the following software:

- JDK 21
- Apache Maven 3.9 or later
- MySQL Server
- Apache Tomcat 10.1
- Eclipse IDE

### Step 1: Clone the Repository

```bash
git clone https://github.com/Anirudh2802005/Digital-Purohit-Assistant.git
```

### Step 2: Open the Project

1. Open Eclipse IDE.
2. Select File → Import.
3. Choose Existing Maven Projects.
4. Browse to the cloned project directory.
5. Select the project and finish importing.

### Step 3: Create the MySQL Database

Open MySQL Workbench or your MySQL terminal.

Execute:

```sql
CREATE DATABASE digital_purohit_assistant;
```

### Step 4: Configure Database Connectivity

Update the application's database connection configuration with your local MySQL details.

Example configuration:

```java
private static final String URL =
    "jdbc:mysql://localhost:3306/digital_purohit_assistant";

private static final String USER = "your_mysql_username";

private static final String PASSWORD = "your_mysql_password";
```

Use your own local database credentials. Never commit actual passwords to GitHub.

### Step 5: Configure Database Tables

Create or import the required application tables before running the application.

Ensure that the database schema matches the application's DAO and model classes.

### Step 6: Build the Application

Open the terminal in the project directory.

Execute:

```bash
mvn clean package
```

Maven downloads the required dependencies and builds the application.

### Step 7: Deploy on Apache Tomcat

1. Configure Apache Tomcat 10.1 in Eclipse.
2. Add the project to the Tomcat server.
3. Start the server.
4. Open the application in your browser.

Example:

```text
http://localhost:8080/Digital_Purohit_Assistant/
```

The context path may vary depending on your deployment configuration.

---

# 🔄 8. Application Workflow

The general application workflow is:

```text
       LOGIN / GOOGLE LOGIN
                |
                v
           DASHBOARD
                |
       +--------+--------+
       |        |        |
       v        v        v
   CUSTOMERS  EVENTS   REPORTS
       |        |        |
       v        v        v
  CUSTOMER   EVENT     INCOME
  HISTORY    TYPES    REPORTS
       |        |
       +--------+
            |
            v
     PAYMENT MANAGEMENT
            |
      +-----+------+
      |     |      |
      v     v      v
     PAID PARTIAL PENDING
```

Additional modules:

- Bulk Event Management
- Kashi Yatra Management
- Pooja Samagri Management
- Reminder Management

---

# 🔒 9. Security Considerations

The application includes authentication functionality and database access management.

Security practices to follow:

- Keep database credentials outside public source control.
- Never upload private keys or service-account JSON files.
- Store sensitive configuration separately.
- Validate user input on the server side.
- Use secure password handling.
- Protect authenticated pages using session validation.
- Apply appropriate access controls to application operations.

---

# 🚀 10. Future Enhancements

Possible future improvements include:

- WhatsApp notifications for upcoming events.
- Automated email reminders.
- Online payment gateway integration.
- PDF invoice generation.
- Advanced financial analytics.
- Cloud database integration.
- Mobile application support.
- Automated database backups.
- Multi-user and role-based access management.

---

# 🎓 11. Learning Outcomes

This project provides practical experience in:

- Java backend development.
- Object-Oriented Programming.
- Java Servlets and JSP.
- JDBC database connectivity.
- MySQL database management.
- DAO design pattern.
- Maven project management.
- Authentication integration.
- CRUD operations.
- Dynamic web application development.
- Git and GitHub version control.
- Deploying Java web applications using Apache Tomcat.

---

# 👨‍💻 12. Developer

**Anirudh**

GitHub: [@Anirudh2802005](https://github.com/Anirudh2802005)

Repository: [Digital Purohit Assistant](https://github.com/Anirudh2802005/Digital-Purohit-Assistant)

---

## ⭐ Support

If you find this project interesting or useful, consider giving the repository a star!

---

**Digital Purohit Assistant – Bringing Traditional Purohit Services into the Digital World.** 🕉️
