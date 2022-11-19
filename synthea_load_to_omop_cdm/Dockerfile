FROM r-base


RUN apt-get update && \
apt-get install -y r-cran-devtools openjdk-11-jdk liblzma-dev libbz2-dev postgresql postgresql-contrib wget build-essential libcurl4-openssl-dev libssl-dev libssh2-1-dev libxml2-dev zlib1g-dev postgresql-client dirmngr apt-transport-https ca-certificates software-properties-common gnupg2 libgit2-dev

RUN Rscript -e "install.packages('rJava')"
RUN R CMD javareconf

RUN Rscript -e "devtools::install_github('OHDSI/ETL-Synthea')"

ENV POSTGRES_PATH=/usr/lib/postgresql/11/bin

COPY load_synthea.r /
COPY entrypoint.sh /

CMD bash /entrypoint.sh