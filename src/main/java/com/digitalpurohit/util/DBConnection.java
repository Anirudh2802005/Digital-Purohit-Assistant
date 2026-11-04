
package com.digitalpurohit.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Local database configuration (Eclipse)
    private static final String LOCAL_URL =
            "jdbc:mysql://localhost:3306/digital_purohit_assistant";

    private static final String LOCAL_USERNAME = "root";

    // Keep your existing local MySQL password here.
    private static final String LOCAL_PASSWORD = "Anirudh@2005";

    private DBConnection() {
    }

    public static Connection getConnection() {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Check whether cloud database configuration exists.
            String dbHost = System.getenv("DB_HOST");

            if (dbHost == null || dbHost.isBlank()) {

                // LOCAL MODE: Eclipse
                Connection connection = DriverManager.getConnection(
                        LOCAL_URL,
                        LOCAL_USERNAME,
                        LOCAL_PASSWORD
                );

                System.out.println("Connected to LOCAL MySQL database");

                return connection;
            }

            // CLOUD MODE: Render + Aiven
            String dbPort = getEnv("DB_PORT", "20001");
            String dbName = getEnv(
                    "DB_NAME",
                    "digital_purohit_assistant"
            );
            String dbUsername = getEnv("DB_USER", "");
            String dbPassword = getEnv("DB_PASSWORD", "");

            if (dbUsername.isBlank() || dbPassword.isBlank()) {
                throw new SQLException(
                        "Cloud database username or password is missing."
                );
            }

            String cloudUrl = "jdbc:mysql://" + dbHost + ":" + dbPort
                    + "/" + dbName
                    + "?sslMode=REQUIRED";

            Connection connection = DriverManager.getConnection(
                    cloudUrl,
                    dbUsername,
                    dbPassword
            );

            System.out.println("Connected to CLOUD MySQL database");

            return connection;

        } catch (ClassNotFoundException e) {

            System.out.println("MySQL Driver Not Found");
            e.printStackTrace();

        } catch (SQLException e) {

            System.out.println("Database Connection Failed");
            e.printStackTrace();
        }

        return null;
    }

    private static String getEnv(String name, String defaultValue) {
        String value = System.getenv(name);

        return (value == null || value.isBlank())
                ? defaultValue
                : value;
    }
}
