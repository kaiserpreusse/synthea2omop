FROM openjdk:11-jdk-buster

# install base dependencies
RUN apt-get update; apt-get install -y wget libcurl4-openssl-dev libssl-dev libssh2-1-dev libxml2-dev zlib1g-dev postgresql-client dirmngr apt-transport-https ca-certificates software-properties-common gnupg2
# add R repository
RUN apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian buster-cran35/'
# install R
RUN apt-get update; apt-get install -y r-base

RUN R -e "install.packages(c('devtools'))"
RUN R CMD javareconf

RUN R -e "devtools::install_github('OHDSI/ETL-Synthea')"

RUN apt-get install -y postgresql postgresql-contrib

ENV POSTGRES_PATH=/usr/lib/postgresql/11/bin

COPY load_synthea.r /
COPY entrypoint.sh /

CMD bash /entrypoint.sh