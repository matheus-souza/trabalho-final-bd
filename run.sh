#!/bin/bash

usuario=$1;
base=$2;
gerar_dados=$3;
resetar_base=$4;
#Se rodar com Docker necessário passar o caminho completo do arquivo
diretorio=$5;


cria_tabelas_procedures() {
  sqls=(
    ${diretorio}'create/create_tables.sql'
    ${diretorio}'triggers/tGeraVezesReservadas.sql'
    ${diretorio}'triggers/tEdicaoPessoa.sql'
    ${diretorio}'triggers/tDeletaDadosPessoa.sql'
    ${diretorio}'functions/fListaPessoas.sql'
    ${diretorio}'functions/fQuantidadeReservasPorServico.sql'
  )

  for sql in ${sqls[@]}; do
    psql -U${usuario} -d ${base} -a -f ${sql[@]}
  done
}

gera_dados_ficticios() {
  # Lista tabelas com dados ficticios para uso
  sqls_tmp=(
    ${diretorio}'generatedata/tmp/tmp_documento_valor.sql'
    ${diretorio}'generatedata/tmp/tmp_endereco.sql'
    ${diretorio}'generatedata/tmp/tmp_nome.sql'
    ${diretorio}'generatedata/tmp/tmp_email.sql'
    ${diretorio}'generatedata/tmp/tmp_telefone.sql'
  )
  for sql_tmp in ${sqls_tmp[@]}; do
    psql -U${usuario} -d ${base} -a -f ${sql_tmp[@]}
  done

  # Lista de sqls para a geração de dados ficticios
  sqls_dados=(
    ${diretorio}'generatedata/tipo_documento.sql'
    ${diretorio}'generatedata/functions/fGeraDocumentos.sql'
    ${diretorio}'generatedata/documento.sql'
    ${diretorio}'generatedata/pais.sql'
    ${diretorio}'generatedata/estado.sql'
    ${diretorio}'generatedata/cidade.sql'
    ${diretorio}'generatedata/functions/fGeraEnderecos.sql'
    ${diretorio}'generatedata/endereco.sql'
    ${diretorio}'generatedata/servicos.sql'
    ${diretorio}'generatedata/dia_atendimento.sql'
    ${diretorio}'generatedata/horario_atendimento.sql'
    ${diretorio}'generatedata/functions/fGeraPessoaFisica.sql'
    ${diretorio}'generatedata/pessoa_fisica.sql'
    ${diretorio}'generatedata/functions/fGeraPessoaJuridica.sql'
    ${diretorio}'generatedata/pessoa_juridica.sql'
    ${diretorio}'generatedata/functions/fGeraEmails.sql'
    ${diretorio}'generatedata/email.sql'
    ${diretorio}'generatedata/functions/fGeraTelefones.sql'
    ${diretorio}'generatedata/telefone.sql'
    ${diretorio}'generatedata/functions/fGeraReservas.sql'
    ${diretorio}'generatedata/reservas.sql'
  )
  for sql_dado in ${sqls_dados[@]}; do
    psql -U${usuario} -d ${base} -a -f ${sql_dado[@]}
  done
}

roda_selects_views() {
  sqls_selects=(
    ${diretorio}'views/vClientesRecorrentes.sql'
    ${diretorio}'views/vAnosFiscais.sql'
    ${diretorio}'views/vEnviarPromocoesEmail.sql'
    ${diretorio}'views/vEnviarPromocoesTelefone.sql'
    ${diretorio}'selects/selects.sql'
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
  echo "Criando extensão hstore"
  psql template1 -c 'create extension if not exists hstore;' -U${usuario}
  cria_tabelas_procedures
fi

if [[ $gerar_dados == "true" ]]; then
  gera_dados_ficticios
fi

roda_selects_views
