# ======================
# Build stage
# ======================
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and download dependencies first (cache optimization)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Package the app
RUN mvn clean package -DskipTests

# ======================
# Runtime stage
# ======================
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/hire-orbit-0.0.1-SNAPSHOT.jar app.jar

# Expose the port (Render uses $PORT)
EXPOSE 8080

# Pass Render's PORT env var to Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]