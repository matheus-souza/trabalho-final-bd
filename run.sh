#!/bin/bash

dropdb -Uubuntu reservas;
dropdb -Upostgres reservas;

createdb -Uubuntu reservas;
createdb -Upostgres reservas;

sqls=(
	'create/create_tables.sql'
	)

for sql in ${sqls[@]}; do
	psql -Uubuntu -d reservas -a -f ${sql[@]}
	psql -Upostgres -d reservas -a -f ${sql[@]}
done