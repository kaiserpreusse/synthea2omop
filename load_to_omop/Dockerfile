FROM openjdk:11-jdk-buster

RUN apt-get update; apt-get install -y wget r-base libcurl4-openssl-dev libssl-dev libssh2-1-dev libxml2-dev zlib1g-dev postgresql-client
RUN R -e "install.packages(c('devtools'))"
RUN R CMD javareconf

RUN R -e "devtools::install_github('OHDSI/ETL-Synthea')"

RUN apt-get install -y postgresql postgresql-contrib

ENV POSTGRES_PATH=/usr/lib/postgresql/11/bin

COPY load_synthea.r /
COPY entrypoint.sh /

CMD bash /entrypoint.sh