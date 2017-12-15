FROM postgres:9.6.5
MAINTAINER Matheus Henrique de Souza "mh.matheussouza@gmail.com"

RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8

ENV LANG pt_BR.utf8
