FROM eclipse-temurin:21-jdk-alpine as builder
WORKDIR /app
COPY . .
RUN ./gradlew clean build -x test

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
# Strict memory limits for free tier hosting (Render/Koyeb 512MB RAM)
ENTRYPOINT ["java", "-Xmx128m", "-Xms64m", "-jar", "app.jar"]
