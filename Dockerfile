# 1️⃣ Use Amazon Corretto 17 (AWS Public ECR, lightweight)
FROM public.ecr.aws/amazoncorretto/amazoncorretto:17-alpine

# 2️⃣ Set working directory
WORKDIR /app

# 3️⃣ Copy your compiled JAR
COPY target/app.jar /app/app.jar

# 4️⃣ Expose the port your app listens on
EXPOSE 8080

# 5️⃣ Run the Java app
ENTRYPOINT ["java", "-jar", "app.jar"]
