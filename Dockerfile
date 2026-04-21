#  stage 1: build the application
FROM eclipse-temurin:21-jdk-jammy AS builder

WORKDIR /app

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./

RUN ./mvnw dependency:go-offline 

COPY src/ src/

RUN ./mvnw package -DskipTests


# stage 2: run the application
FROM eclipse-temurin:21-jre-jammy AS runtime

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]