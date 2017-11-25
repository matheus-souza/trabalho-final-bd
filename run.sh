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
  # Lista tabelas com dados ficticios para uso
  sqls_tmp=(
    'generatedata/tmp/tmp_documento_valor.sql'
  )
  for sql_tmp in ${sqls_tmp[@]}; do
    psql -U${usuario} -d ${base} -a -f ${sql_tmp[@]}
  done

  # Lista de sqls para a geração de dados ficticios
  sqls_dados=(
    'generatedata/tipo_documento.sql'
    'generatedata/functions/fGeraDocumentos.sql'
    'generatedata/documento.sql'
    'generatedata/pais.sql'
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
