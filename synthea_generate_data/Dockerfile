FROM openjdk:11-jre-buster

WORKDIR /

RUN apt-get update; apt-get install -y wget
# use specific version
RUN wget https://github.com/synthetichealth/synthea/releases/download/v3.0.0/synthea-with-dependencies.jar
# use latest master
#RUN wget https://github.com/synthetichealth/synthea/releases/download/master-branch-latest/synthea-with-dependencies.jar

COPY settings.conf /

WORKDIR /output

CMD java -jar /synthea-with-dependencies.jar -p $SYNTHEA_NUM_PATIENTS -c /settings.conf