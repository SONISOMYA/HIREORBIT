# ---- Build stage ----
FROM maven:3.9.8-eclipse-temurin-21 AS build

WORKDIR /app

# First, copy only the pom.xml (to cache dependencies)
COPY pom.xml .

# Download dependencies (cached in Docker layer)
RUN mvn dependency:go-offline -B

# Now copy the actual source code
COPY src ./src

# Build the project (skip tests for faster build)
RUN mvn clean package -DskipTests


# ---- Runtime stage ----
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/hire-orbit-0.0.1-SNAPSHOT.jar app.jar

# Expose Render's $PORT
EXPOSE 8080

# Start Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]