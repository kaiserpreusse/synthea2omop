while !</dev/tcp/postgres/5432; do sleep 1; done; 

Rscript /load_synthea.r

PGPASSWORD=$POSTGRES_PASSWORD PGOPTIONS="--search_path=cdm_synthea10" psql -U $POSTGRES_USER -h postgres synthea -f /output/postgresql_5.3.1_constraint_ddl.sql

PGPASSWORD=$POSTGRES_PASSWORD PGOPTIONS="--search_path=cdm_synthea10" psql -U $POSTGRES_USER -h postgres synthea -f /output/postgresql_5.3.1_index_ddl.sql

