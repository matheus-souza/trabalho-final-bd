#!/bin/bash

usuario=$1;
base=$2;
gerar_dados=$3;
resetar_base=$4;

cria_tabelas_visoes_procedures() {
  sqls=(
    'create/create_tables.sql'
    'views/vClientesRecorrentes.sql'
  )

  for sql in ${sqls[@]}; do
    psql -U${usuario} -d ${base} -a -f ${sql[@]}
  done
}

gera_dados_ficticios() {
  # Lista tabelas com dados ficticios para uso
  sqls_tmp=(
    'generatedata/tmp/tmp_documento_valor.sql'
    'generatedata/tmp/tmp_endereco.sql'
    'generatedata/tmp/tmp_nome.sql'
    'generatedata/tmp/tmp_email.sql'
    'generatedata/tmp/tmp_telefone.sql'
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
    'generatedata/estado.sql'
    'generatedata/cidade.sql'
    'generatedata/functions/fGeraEnderecos.sql'
    'generatedata/endereco.sql'
    'generatedata/servicos.sql'
    'generatedata/dia_atendimento.sql'
    'generatedata/horario_atendimento.sql'
    'generatedata/functions/fGeraPessoaFisica.sql'
    'generatedata/pessoa_fisica.sql'
    'generatedata/functions/fGeraPessoaJuridica.sql'
    'generatedata/pessoa_juridica.sql'
    'generatedata/functions/fGeraEmails.sql'
    'generatedata/email.sql'
    'generatedata/functions/fGeraTelefones.sql'
    'generatedata/telefone.sql'
    'generatedata/functions/fGeraReservas.sql'
    'generatedata/reservas.sql'
  )
  for sql_dado in ${sqls_dados[@]}; do
    psql -U${usuario} -d ${base} -a -f ${sql_dado[@]}
  done
}

roda_selects() {
  sqls_selects=(
    'selects/selects.sql'
  )

  for sql_select in ${sqls_selects[@]}; do
    psql -U${usuario} -d ${base} -a -f ${sql_select[@]}
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

roda_selects
