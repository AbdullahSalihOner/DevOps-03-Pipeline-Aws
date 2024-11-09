# Specify the JDK version required for the application
# Using Amazon Corretto JDK version 17 or OpenJDK 17
# FROM amazoncorretto:17
FROM openjdk:21

# Define the location of the project's JAR file
ARG JAR_FILE=target/*.jar

# Copy the JAR file into the Docker container with a specified name
COPY ${JAR_FILE} my-application.jar

# Use CMD to run any commands needed during setup
CMD apt-get update
CMD apt-get upgrade -y

# Expose port 8081 to fix the internal port
EXPOSE 8083

# Command to run the application
ENTRYPOINT ["java","-jar","my-application.jar"]