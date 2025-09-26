# # Use a base image with Java installed (e.g., OpenJDK 17)
# FROM openjdk:17-jdk-slim

# # Set the working directory inside the container
# WORKDIR /usr/app

# # Copy the built JAR file into the container
# #COPY target/spring-boot-docker-SNAPSHOT.jar /app/app.jar
# COPY ./target/java-maven-app-*.jar /usr/app/

# # Expose the port your Spring Boot application listens on (default is 8080)
# EXPOSE 8080

# # Define the command to run the application when the container starts
# ENTRYPOINT ["java", "-jar", "app.jar"]





# Stage 1: Build
FROM maven:3.9.3-amazoncorretto-17 AS build

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM amazoncorretto:17-alpine
WORKDIR /app

# Copy built JAR from build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
