FROM r-base:4.2.2


RUN apt-get update && \
    apt-get install -y r-cran-devtools openjdk-11-jdk

RUN Rscript -e "install.packages('rJava')"
RUN R CMD javareconf

RUN Rscript -e "devtools::install_github('OHDSI/ETL-Synthea@8e00de1495e9eb7b9627eb109d15e5f928644990')"

COPY load_synthea.r /

CMD Rscript /load_synthea.r