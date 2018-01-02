# Trabalho final de Banco de Dados
 - O escopo do trabalho está disponível em [ESCOPO.md](ESCOPO.md)
 - O arquivo com as consultas está disponível em [CONSULTAS.md](CONSULTAS.md)


## Como rodar
### Máquina local
Para criar a base com os scripts basta rodar:
```bash
./run usuario base [gerar_dados] [resetar_base]
```
Exemplo:
```bash
./run.sh postgres reservas true true
```
### Docker
Rodar arquivo [run-docker.sh](run-docker.sh) com o comando:
```bash
./run-docker.sh
```
