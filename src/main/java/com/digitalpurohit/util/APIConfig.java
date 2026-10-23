package com.digitalpurohit.util;

import java.io.InputStream;
import java.util.Properties;

public class APIConfig {

    private static final Properties properties = new Properties();

    static {

        try {

            InputStream input = APIConfig.class
                    .getClassLoader()
                    .getResourceAsStream("api.properties");

            if (input != null) {
                properties.load(input);
            } else {
                throw new RuntimeException("api.properties not found");
            }

        } catch (Exception e) {

            throw new RuntimeException(e);

        }

    }

    public static String get(String key) {

        return properties.getProperty(key);

    }

}