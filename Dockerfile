FROM openjdk:12-jdk-alpine AS builder

WORKDIR /app
COPY . .
RUN ./mvnw package

RUN export APPLICATION_JAR=$(./mvnw -q -Dexec.executable=echo \
                                       -Dexec.args='${project.name}-${project.version}.jar' \
                                       --non-recursive exec:exec)\
  && mv "target/${APPLICATION_JAR}" "target/app.jar"

FROM openjdk:12-jdk-alpine

COPY --from=builder /app/target/app.jar /app/app.jar
CMD ["/opt/openjdk-12/bin/java", "-jar", "/app/app.jar"]
