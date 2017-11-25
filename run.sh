#!/bin/bash

usuario=$1;
base=$2;
gerar_dados=$3;
resetar_base=$4;

cria_tabelas_visoes_procedures() {
  sqls=(
    'create/create_tables.sql'
  )

  for sql in ${sqls[@]}; do
    psql -U${usuario} -d ${base} -a -f ${sql[@]}
  done
}

gera_dados_ficticios() {
  sqls_dados=(
    'generatedata/tipo_documento.sql'
  )

  for sql_dado in ${sqls_dados[@]}; do
    psql -U${usuario} -d ${base} -a -f ${sql_dado[@]}
  done
}

if [[ $1 == "--help" || $1 == "-h" ]]
then
  echo 'Uso: ./run usuario base [gerar_dados] [resetar_base]'
  echo 'Exemplo: ./run postgres reservas true true'
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
  cria_tabelas_visoes_procedures
fi

if [[ $gerar_dados == "true" ]]; then
  gera_dados_ficticios
fi
