#!/bin/bash

echo "Criando container trabalho_final_bd..."
docker-compose up -d 1> /dev/null 2> /dev/stdout;
echo "Container criado com sucesso"
echo "Criando base de dados..."
sleep 10;
docker exec -it trabalho_final_bd bash /trabalho-final-bd/run.sh postgres reservas true true /trabalho-final-bd/ 1> /dev/null 2> /dev/stdout;
echo "Base de dados criada com sucesso"
