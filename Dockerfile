#FROM anapsix/alpine-java
#LABEL maintainer="shanem@liatrio.com"
#COPY /target/spring-petclinic-3.3.0-SNAPSHOT.jar /home/spring-petclinic-3.3.0-SNAPSHOT.jar
#CMD ["java","-jar","/home/spring-petclinic-3.3.0-SNAPSHOT.jar"]
FROM openjdk:17-jdk-alpine
LABEL maintainer="shanem@liatrio.com"
COPY target/spring-petclinic-3.3.0-SNAPSHOT.jar /home/spring-petclinic-3.3.0-SNAPSHOT.jar
CMD ["java","-jar","/home/spring-petclinic-3.3.0-SNAPSHOT.jar"]
