# ======================
# Build stage
# ======================
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# ======================
# Runtime stage
# ======================
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/hire-orbit-0.0.1-SNAPSHOT.jar app.jar

# Expose the port (Render will auto-map it)
EXPOSE 8080

# Run the app
CMD ["java", "-jar", "app.jar"]
