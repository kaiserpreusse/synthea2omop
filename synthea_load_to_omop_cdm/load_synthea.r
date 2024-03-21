library(ETLSyntheaBuilder)
library(SqlRender)

# Function to CASCADE TRUNCATE event tables
CascadeTruncateEventTables <- function(connectionDetails, cdmSchema)
{
message("Truncating event tables...")
eventTables <- c(
"CARE_SITE",
"CDM_SOURCE",
"COHORT",
"COHORT_ATTRIBUTE",
"CONDITION_ERA",
"CONDITION_OCCURRENCE",
"COST",
"DEATH",
"DEVICE_EXPOSURE",
"DOSE_ERA",
"DRUG_ERA",
"DRUG_EXPOSURE",
"FACT_RELATIONSHIP",
"LOCATION",
"MEASUREMENT",
"METADATA",
"NOTE",
"NOTE_NLP",
"OBSERVATION",
"OBSERVATION_PERIOD",
"PAYER_PLAN_PERIOD",
"PERSON",
"PROCEDURE_OCCURRENCE",
"PROVIDER",
"SPECIMEN",
"VISIT_DETAIL",
"VISIT_OCCURRENCE"
)

conn <- DatabaseConnector::connect(connectionDetails)

# loop version 1
for (p in eventTables) {
  print(p)

      sql <-
    paste(
    "truncate table @cdm_schema.",
    p,
    " CASCADE;",
    collapse = "\n",
    sep = ""
    )
    sql <- SqlRender::render(sql, cdm_schema = cdmSchema)

    sql <-
    SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
    message(sql)


    tryCatch(
    expr = {DatabaseConnector::executeSql(conn, sql)},
    error = function(e) {
        print(e)
    }
    )

    }


on.exit(DatabaseConnector::disconnect(conn))

}

 # The ETLSyntheaBuilder package leverages the OHDSI/CommonDataModel package for CDM creation.
 # Valid CDM versions are determined by executing CommonDataModel::listSupportedVersions().
 # The strings representing supported CDM versions are currently "5.3" and "5.4".


postgres_user = Sys.getenv("POSTGRES_USER")
postgres_password = Sys.getenv("POSTGRES_PASSWORD")
postgres_host = Sys.getenv("POSTGRES_HOST")
postgres_db = Sys.getenv("POSTGRES_DB")
postgres_port = as.integer(Sys.getenv("POSTGRES_PORT"))
cdm_schema = Sys.getenv("CDM_SCHEMA")
print(c(postgres_user, postgres_password, postgres_host, postgres_db, postgres_port, cdm_schema))

postgres_server_url = paste(postgres_host, "/", postgres_db, sep="")
print(postgres_server_url)

 DatabaseConnector::downloadJdbcDrivers(
   'postgresql',
   pathToDriver = '/',
   method = "auto"
 )

cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql",
  server   = postgres_server_url,
  user     = postgres_user,
  password = postgres_password,
  port     = postgres_port,
  pathToDriver = "/"
)

cdmVersion     <- "5.3"
syntheaVersion <- "3.2.0"
syntheaSchema  <- "native"
syntheaFileLoc <- "/output/csv"


conn <- DatabaseConnector::connect(cd)

# for testing: drop and create CDM tables (vocabularies are required for Synthea ETL, this will
# not create data in the event tables if the vocabularies are not loaded)
# DatabaseConnector::executeSql(conn, sprintf("DROP SCHEMA IF EXISTS %s CASCADE", cdm_schema))
# DatabaseConnector::executeSql(conn, sprintf("CREATE SCHEMA IF NOT EXISTS %s", cdm_schema))
# ETLSyntheaBuilder::CreateCDMTables(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion)

# truncate the event tables but do not drop them
CascadeTruncateEventTables(connectionDetails = cd, cdmSchema = cdm_schema)

# drop and recreate Synthea native schema
DatabaseConnector::executeSql(conn, 'DROP SCHEMA IF EXISTS native CASCADE')
DatabaseConnector::executeSql(conn, 'CREATE SCHEMA IF NOT EXISTS native')
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)

# create and load Synthea native
ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaFileLoc = syntheaFileLoc)

# create map tables
ETLSyntheaBuilder::CreateMapAndRollupTables(connectionDetails = cd, cdmSchema = cdm_schema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion, syntheaVersion = syntheaVersion)

# Synthea ETL
ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd, cdmSchema = cdm_schema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion, syntheaVersion = syntheaVersion)
