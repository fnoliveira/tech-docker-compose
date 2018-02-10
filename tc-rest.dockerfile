FROM openjdk:8-jre-alpine
LABEL key="fnoliveira"
COPY /var/tc/deploy/prod/final/ rest-0.0.1-SNAPSHOT.jar /var/www/api
WORKDIR /var/www/api
ENTRYPOINT [ "sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=docker -jar /rest-0.0.1-SNAPSHOT.jar" ]

EXPOSE 9090