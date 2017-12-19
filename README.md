# Trabalho final de Banco de Dados

O escopo do trabalho está disponível em [ESCOPO.md](ESCOPO.md)

## Como utilizar

### Máquina local
Para criar a base com os scripts basta rodar:
```
./run usuario base [gerar_dados] [resetar_base]
```
Exemplo:
```
./run.sh postgres reservas true true
```

### Docker
Rodar arquivo [./run-docker.sh](run-docker.sh) com o comando:
```
./run-docker.sh
```
