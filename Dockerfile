FROM openjdk:17-jdk-alpine
LABEL maintainer="antonio.barroso@defensoria.pi.def.br"
COPY target/spring-petclinic-3.3.0-SNAPSHOT.jar /home/spring-petclinic-3.3.0-SNAPSHOT.jar
CMD ["java","-jar","/home/spring-petclinic-3.3.0-SNAPSHOT.jar"]
