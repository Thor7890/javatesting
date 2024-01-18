FROM maven:3.8.4-openjdk-17-slim

WORKDIR /app

# Copy your application files
COPY . /app

# Run your application
CMD ["mvn", "clean", "test", "spring-boot:run"]


