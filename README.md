
# Create Synthea data and load to OMOP CDM (v5.3.1)
Docker images to (1) generate Synthea data and (2) load Synthea data into OMOP CDM. The goal is to quickly load an OMOP CDM with data
for testing and demonstration.

1. Synthea data is created with the official Synthea builder: https://github.com/synthetichealth/synthea
2. Data is loaded to OMOP CDM with the [ETL-Synthea](https://github.com/OHDSI/ETL-Synthea) project developed by OHDSI

Synthea data creation and OMOP ETL version have to be synchronized. The following versions are currently pinned:

| image | module | version |
| ----- | ----- | ---- | 
| synthea_generate_data | synthea | 3.0.0 |
| synthea_load_to_omop_cdm | [r-base](https://hub.docker.com/_/r-base) | 4.2.2 |
| synthea_load_to_omop_cdm | [Synthea ETL](https://github.com/OHDSI/ETL-Synthea) | [8e00de1495e9eb7b9627eb109d15e5f928644990](https://github.com/OHDSI/ETL-Synthea/tree/8e00de1495e9eb7b9627eb109d15e5f928644990) |
| synthea_load_to_omop_cdm | OMOP CDM | 5.3 |

> :warning: For now Postgres and OMOP CDM 5.3 are hard coded, the Synthea ETL repo has early support for OMOP CDM 5.4 but this was not tested.

## How to use

### Prerequresites
You need a OMOP CDM database with vocabularies.

> :point_right: Guide to set up a simple test OMOP CDM database in Postgres: https://github.com/kaiserpreusse/omop_database

The following environment variables are needed, best practice is to store them in a `.env` file:

```
OUTPUT_PATH=Writable local path for output
POSTGRES_PASSWORD=Postgres password
POSTGRES_USER=Postgres user
POSTGRES_HOST=Postgres host
POSTGRES_DB=Postgres database name
POSTGRES_PORT=Postgres port
CDM_SCHEMA=name of CDM schema in OMOP DB (this has to be set up before, with vocabularies)
SYNTHEA_NUM_PATIENTS=Number of patients for synthea
```
### 1. Generate Synthea data
Build and run the `synthea_generate_data` image, e.g. with the provided compose file:

```docker-compose -f compose_generate_data.yml up --build```

See the compose file for required ENV variables.

### 2. Load Synthea data to OMOP CDM
Build and run the `synthea_load_to_omop_cdm` image, e.g. with the provided compose file. Note that the compose file
also starts a Postgres database.

```docker-compose -f compose_load_data.yml up --build```

See the compose file for required ENV variables.

> :warning: Building the images takes considerable time because R builds a lot of packages from source. Help with this issue would be appreciated.

## TODO
- OMOP CDM v6
    - right now this works with OMOP CDM 5.3.1 only
    - in principle, the [ETL-Synthea](https://github.com/OHDSI/ETL-Synthea) can also load to OMOP CDM v6
