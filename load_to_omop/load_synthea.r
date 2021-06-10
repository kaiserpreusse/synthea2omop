library(ETLSyntheaBuilder)
library(SqlRender)

 # We are loading a version 5.3.1 CDM into a local PostgreSQL database called "synthea10".  
 # The supported Synthea version is 2.6.1
 # The schema to load the Synthea tables is called "native".
 # The schema to load the Vocabulary and CDM tables is "cdm_synthea10".  
 # The username and pw are "postgres" and "lollipop".
 # The Synthea and Vocabulary CSV files are located in /tmp/synthea/output/csv and /tmp/Vocabulary_20181119, respectively.
 
DatabaseConnector::downloadJdbcDrivers(
  'postgresql',
  pathToDriver = '/',
  method = "auto"
)

 cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql", 
  server   = paste(Sys.getenv("POSTGRES_HOST"), "/synthea", sep=""),
  user     = Sys.getenv("POSTGRES_USER"), 
  password = Sys.getenv("POSTGRES_PASSWORD"), 
  port     = 5432,
  pathToDriver = '/'
)

cdmSchema      <- "cdm_synthea10"
cdmVersion     <- "5.3.1"
syntheaVersion <- Sys.getenv("SYNTHEA_VERSION")
syntheaSchema  <- "native"
syntheaFileLoc <- "/output/csv"
vocabFileLoc   <- "/vocabulary"


conn <- DatabaseConnector::connect(cd)

# drop and recreate CDM schema
DatabaseConnector::executeSql(conn, 'DROP SCHEMA IF EXISTS cdm_synthea10 CASCADE')
DatabaseConnector::executeSql(conn, 'CREATE SCHEMA IF NOT EXISTS cdm_synthea10')
ETLSyntheaBuilder::TruncateEventTables(connectionDetails = cd, cdmSchema = cdmSchema)

# drop and recreate Synthea native schema
DatabaseConnector::executeSql(conn, 'DROP SCHEMA IF EXISTS native CASCADE')
DatabaseConnector::executeSql(conn, 'CREATE SCHEMA IF NOT EXISTS native')

# create CDM tables
ETLSyntheaBuilder::CreateCDMTables(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion)

# create and load Synthea native
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)                                       
ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaFileLoc = syntheaFileLoc)

# Load Vocabulary                                     
ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails = cd, cdmSchema = cdmSchema, vocabFileLoc = vocabFileLoc)

# Synthea ETL
ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion, syntheaVersion = syntheaVersion)

# Optional: Create index and constraint DDL scripts for the rdbms that support them.  Scripts will be written to the "output" directory.
ETLSyntheaBuilder::CreateCDMIndexAndConstraintScripts(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion, githubTag = "v5.3.1")

