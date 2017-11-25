#!/bin/bash

usuario=$1;
base=$2;
resetar_base=$3;

if [[ $1 == "--help" || $1 == "-h" ]]
then
  echo 'Uso: ./run usuario base [resetar_base]'
  echo 'Exemplo: ./run postgres reservas true'
  exit
fi

if [[ -z ${usuario} ]]; then
	echo "Informe o usuário do PostgreSQL";
	exit 0;
fi

if [[ -z ${base} ]]; then
	echo "Informe o nome da base";
	exit 0;
fi

if [[ $resetar_base == "true" ]]; then
	echo "Deletando base ${base}"
	dropdb -U${usuario} ${base};
	echo "Criando base ${base}"
	createdb -U${usuario} ${base};
fi

sqls=(
	'create/create_tables.sql'
	)

for sql in ${sqls[@]}; do
	psql -U${usuario} -d ${base} -a -f ${sql[@]}
	psql -U${usuario} -d ${base} -a -f ${sql[@]}
done