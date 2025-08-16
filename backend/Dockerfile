FROM maven:3.9.8-eclipse-temurin-21 AS build

COPY . .

RUN mvn clean package -DskipTests

 
FROM eclipse-temurin:21-jdk-alpine
COPY --from=build /app/target/hire-orbit-0.0.1-SNAPSHOT.jar app.jar

# Expose the port (Render uses $PORT)
EXPOSE 8080

# Pass Render's PORT env var to Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]