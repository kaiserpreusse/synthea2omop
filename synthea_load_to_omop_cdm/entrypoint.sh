#while !</dev/tcp/postgres/5432; do sleep 1; done;

Rscript /load_synthea.r
#
#PGPASSWORD=$POSTGRES_PASSWORD PGOPTIONS="--search_path=cdm_synthea10" psql -p 15432 -U $POSTGRES_USER -h $POSTGRES_HOST $POSTGRES_DB -f /output/postgresql_5.3.1_index_ddl.sql
#
#PGPASSWORD=$POSTGRES_PASSWORD PGOPTIONS="--search_path=cdm_synthea10" psql -p 15432 -U $POSTGRES_USER -h $POSTGRES_HOST $POSTGRES_DB -f /output/postgresql_5.3.1_constraint_ddl.sql
#

