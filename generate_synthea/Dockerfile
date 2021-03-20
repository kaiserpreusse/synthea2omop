FROM openjdk:11-jre-buster

WORKDIR /

RUN apt-get update; apt-get install -y wget
# RUN wget https://github.com/synthetichealth/synthea/releases/download/v2.7.0/synthea-with-dependencies.jar
# use master for now
RUN wget https://github.com/synthetichealth/synthea/releases/download/master-branch-latest/synthea-with-dependencies.jar
COPY settings.conf /

WORKDIR /output

CMD java -jar /synthea-with-dependencies.jar -p 10 -c /settings.conf