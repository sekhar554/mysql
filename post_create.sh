#!/bin/bash

set -e
set -u

echo "  Creating camunda user ($CAMUNDA_USER) and database ($CAMUNDA_DB)"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER "$CAMUNDA_USER" WITH PASSWORD '$CAMUNDA_PASSWORD';
    CREATE DATABASE "$CAMUNDA_DB";
    GRANT ALL PRIVILEGES ON DATABASE "$CAMUNDA_DB" TO "$CAMUNDA_USER";
EOSQL

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# No need to run them here as the tables are Created when kong migrations are run
# echo "Creating authentication schema  ..."
# psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB"  -f $DIR/sql/auth_schema.sql
