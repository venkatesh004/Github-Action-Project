FROM eclipse-temurin:17-jdk-alpine

EXPOSE 8080

ENV APP_HOME=/usr/src/app
WORKDIR $APP_HOME

# Ensure directory exists (WORKDIR already creates it, but explicit is fine)
RUN mkdir -p $APP_HOME

# Copy the jar downloaded by GitHub Actions into the container
COPY app/*.jar app.jar

CMD ["java", "-jar", "app.jar"]
