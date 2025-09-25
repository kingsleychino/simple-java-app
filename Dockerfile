# Use a base image with Java installed (e.g., OpenJDK 17)
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /usr/app

# Copy the built JAR file into the container
#COPY target/spring-boot-docker-SNAPSHOT.jar /app/app.jar
COPY ./target/java-maven-app-*.jar /usr/app/

# Expose the port your Spring Boot application listens on (default is 8080)
EXPOSE 8080

# Define the command to run the application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
