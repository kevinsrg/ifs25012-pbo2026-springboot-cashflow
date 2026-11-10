# ---- Stage 1: build (Java 25 + Maven, Vaadin production mode) ----
FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B -q dependency:go-offline -Pproduction || true
COPY src ./src
RUN mvn -B clean package -Pproduction -DskipTests

# ---- Stage 2: runtime ----
FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENV APP_PORT=8080
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
