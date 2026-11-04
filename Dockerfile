
# Stage 1: Build the Java application
FROM maven:3-eclipse-temurin-21-noble AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Run using Tomcat 10.1 and Java 21
FROM tomcat:10.1.61-jre21-temurin-noble

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy using the original WAR name
COPY --from=build /app/target/Digital_Purohit_Assistant.war \
    /usr/local/tomcat/webapps/Digital_Purohit_Assistant.war

# Render's application port
ENV PORT=10000

EXPOSE 10000

# Configure Tomcat to listen on Render's port
CMD ["sh", "-c", "sed -i 's/port=\"8080\"/port=\"'\"$PORT\"'\"/' /usr/local/tomcat/conf/server.xml && catalina.sh run"]
