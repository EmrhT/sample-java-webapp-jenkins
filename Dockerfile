FROM tomcat:9.0.73-jdk8

COPY build/libs/sample-java-webapp-jenkins.war /usr/local/tomcat/webapps/
EXPOSE 8080