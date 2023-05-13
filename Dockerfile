FROM tomcat:9.0.73-jdk8

COPY build/libs/Java_Webapp_Pipeline.war /usr/local/tomcat/webapps/
EXPOSE 8080
