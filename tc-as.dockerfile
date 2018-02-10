FROM openjdk:8-jre-alpine
LABEL key="fnoliveira"
RUN mkdir -p /var/www/api
COPY deploy/prod/final/authorization-0.0.1-SNAPSHOT.jar /var/www/api
WORKDIR /var/www/api
CMD ["java","-Djava.security.egd=file:/dev/./urandom","-Dspring.profiles.active=docker","-jar","authorization-0.0.1-SNAPSHOT.jar"]
EXPOSE 9998