
# Create Synthea data and load to OMOP CDM (v5.3.1)
Docker images to (1) generate Synthea data and (2) load Synthea data into OMOP CDM. The goal is to quickly spin up OMOP CDM with data 
for testing and demonstration.

1. Synthea data is created with the official Synthea builder: https://github.com/synthetichealth/synthea
2. Data is loaded to OMOP CDM with the [ETL-Synthea](https://github.com/OHDSI/ETL-Synthea) project developed by OHDSI

> :warning: Some settings are not parameterized yet. For now Postgres and OMOP CDM v5.3.1 are hard coded.

> :warning: This should work with Synthea version 2.7.0 and the latest master but only master was tested.

> :warning: Building the images takes considerable time because R builds a lot of packages from source. Help with this issue would be appreciated.

## How to use

### Prerequresites
You have to download the default set of vocabularies from https://athena.ohdsi.org/.

The following environment variables are needed, best practice is to store them in a `.env` file:

```
VOCAB_PATH=/path/to/vocabulary
OUTPUT_PATH=/mountable/output/path
POSTGRES_PASSWORD=password for postgres
POSTGRES_USER=postgres user
POSTGRES_HOST=host of postgres instance
SYNTHEA_VERSION=Version of synthea (either 2.7.0 or master)
```

### 1. Generate Synthea data
Build and run the `generate_synthea` image, e.g. with the provided compose file:

```docker-compose -f compose_generate_data.yml up --build```

See the compose file for required ENV variables.

### 2. Load Synthea dat to OMOP CDM
Build and run the `load_to_omop` image, e.g. with the provided compose file. Note that the compose file
also starts a Postgres database.

```docker-compose -f compose_load_data.yml up --build```

See the compose file for required ENV variables.

## OMOP CDM v6
- right now this works with OMOP CDM 5.3.1 only
- in principle, the [ETL-Synthea](https://github.com/OHDSI/ETL-Synthea) can also load to OMOP CDM v6
- for now some things are hardcoded to v5.3.1 but this can be parameterized in future:
    - github tag that is required in `ETLSyntheaBuilder::CreateCDMIndexAndConstraintScripts`
    - execution of index/constraint scripts
