1. Listar todas as pessoas físicas que tenham data de nascimento após o ano 2000 e que queiram receber promoções em seus e-mails.
```sql
SELECT f.nome
FROM pessoa p
INNER JOIN fisica f ON f.idpessoa = p.idpessoa
INNER JOIN email e ON e.idpessoa = p.idpessoa
WHERE f.dt_nascimento >= '2000-01-01'
  AND e.receber_promocoes IS TRUE
GROUP BY f.nome
```
2. Listar todas as pessoas físicas que tenham reservas na Quarta-feira após as 02:00 PM, apresentando o seu nome  e telefone de contato.
```sql
SELECT CASE
           WHEN j.idpessoa IS NOT NULL THEN j.razao_social
           ELSE f.nome
       END AS nome,
       t.telefone,
       CASE da.dia_semana
           WHEN 0 THEN 'Domingo'
           WHEN 1 THEN 'Segunda'
           WHEN 2 THEN 'Terça'
           WHEN 3 THEN 'Quarta'
           WHEN 4 THEN 'Quinta'
           WHEN 5 THEN 'Sexta'
           WHEN 6 THEN 'Sábado'
       END AS dia_semana
FROM pessoa p
INNER JOIN telefone t USING (idpessoa)
LEFT JOIN juridica j ON j.idpessoa = p.idpessoa
LEFT JOIN fisica f ON f.idpessoa = p.idpessoa
INNER JOIN reservas r ON r.idpessoa = p.idpessoa
INNER JOIN dia_atendimento da ON da.iddia_atendimento = r.iddia_atendimento
WHERE r.idreservas IN
    (SELECT idreservas
     FROM reservas
     WHERE iddia_atendimento = 2)
  AND r.hora_inicio > '14:00'
GROUP BY j.idpessoa,
         j.razao_social,
         f.nome,
         t.telefone,
         dia_semana
```
3. Realizar uma consulta que some os valores arrecadados no mês de Agosto de 2016. Mostrando o valor total na tela.
```sql
SELECT sum(s.valor) AS valor_agosto_2016
FROM pessoa p
INNER JOIN telefone t USING (idpessoa)
LEFT JOIN juridica j ON j.idpessoa = p.idpessoa
LEFT JOIN fisica f ON f.idpessoa = p.idpessoa
INNER JOIN reservas r ON r.idpessoa = p.idpessoa
INNER JOIN reservas_has_servicos rs ON rs.idreservas = r.idreservas
INNER  JOIN servicos s ON s.idservicos = rs.idservicos
WHERE r.data_atendimento > '2016-08-01'
  AND r.data_atendimento < '2016-08-31'
```
4. Realizar uma consulta que mostre a primeira pessoa fisica que realizou uma reserva a partir do mês de janeiro de 2016, mostrando o  nome da pessoa, dia da semana, a hora agendada e o valor gasto.
```sql
SELECT p.idpessoa,
       CASE
           WHEN j.idpessoa IS NOT NULL THEN j.razao_social
           ELSE f.nome
       END AS nome,
       CASE EXTRACT(DOW
                    FROM r.data_atendimento)
           WHEN 0 THEN 'Domingo'
           WHEN 1 THEN 'Segunda'
           WHEN 2 THEN 'Terça'
           WHEN 3 THEN 'Quarta'
           WHEN 4 THEN 'Quinta'
           WHEN 5 THEN 'Sexta'
           WHEN 6 THEN 'Sábado'
       END AS dia_semana,
       r.data_atendimento,
       sum(s.valor) AS valor,
       r.hora_inicio AS hora_reserva
FROM pessoa p
LEFT JOIN juridica j ON j.idpessoa = p.idpessoa
LEFT JOIN fisica f ON f.idpessoa = p.idpessoa
INNER JOIN reservas r ON r.idpessoa = p.idpessoa
INNER JOIN email e ON e.idpessoa = p.idpessoa
INNER JOIN reservas_has_servicos rs ON rs.idreservas = r.idreservas
INNER JOIN servicos s ON s.idservicos = rs.idservicos
WHERE
    (SELECT count(*)
     FROM reservas
     WHERE idpessoa = p.idpessoa) = 1
  AND r.data_atendimento >= '2016-01-01'
  AND r.data_atendimento <= ALL
    (SELECT data_atendimento
     FROM reservas
     INNER JOIN pessoa ON pessoa.idpessoa = reservas.idpessoa
     WHERE data_atendimento >= '2016-01-01'
       AND
         (SELECT count(*)
          FROM reservas
          WHERE idpessoa = pessoa.idpessoa) = 1)
GROUP BY p.idpessoa,
         j.idpessoa,
         f.nome,
         r.data_atendimento,
         r.hora_inicio
```
5. Mostrar a lista de pessoas físicas que possuem mais de duas reservas a partir do segundo semestre de 2016 e que possuem interesse de receber e-mail promocional, mostrando seu código, nome e e-mail.
```sql
SELECT p.idpessoa,
       CASE
           WHEN j.idpessoa IS NOT NULL THEN j.razao_social
           ELSE f.nome
       END AS nome,
       e.email
FROM pessoa p
LEFT JOIN juridica j ON j.idpessoa = p.idpessoa
LEFT JOIN fisica f ON f.idpessoa = p.idpessoa
INNER JOIN reservas r ON r.idpessoa = p.idpessoa
INNER JOIN email e ON e.idpessoa = p.idpessoa
WHERE
    (SELECT count(*)
     FROM reservas
     WHERE idpessoa = p.idpessoa) > 2
  AND e.receber_promocoes IS TRUE
  AND r.data_atendimento > '2016-06-01'
GROUP BY p.idpessoa,
         j.idpessoa,
         f.nome,
         e.email
```
6. Mostrar a reserva que possui maior duração no segundo semestre de 2017, mostrando o código, nome e se ela deseja receber promoções por telefone ou não.
```sql
SELECT CASE
           WHEN j.idpessoa IS NOT NULL THEN j.razao_social
           ELSE f.nome
       END AS nome,
       t.receber_promocoes,
       '(' || t.ddd || ')' || t.telefone
FROM pessoa p
LEFT JOIN juridica j ON j.idpessoa = p.idpessoa
LEFT JOIN fisica f ON f.idpessoa = p.idpessoa
INNER JOIN reservas r ON r.idpessoa = p.idpessoa
INNER JOIN telefone t ON t.idpessoa = p.idpessoa
WHERE (r.hora_fim - r.hora_inicio) >= ALL
    (SELECT hora_fim-hora_inicio
     FROM reservas)
  AND r.data_atendimento > '2017-06-30'
  AND r.data_atendimento < '2017-12-31'
```
7. Mostrar o total de pessoas que utilizam a operadora BMW e que não tenham realizado nenhuma reserva no primeiro semestre de 2016.
```sql
SELECT count(p.*)
FROM pessoa p
INNER JOIN telefone t USING (idpessoa)
INNER JOIN reservas r ON r.idpessoa = p.idpessoa
WHERE p.idpessoa <> ALL
    (SELECT idpessoa
     FROM reservas
     WHERE data_atendimento >= '2016-01-01'
       AND data_atendimento <= '2016-06-30')
  AND t.operadora = 'BMW'
```
8. Listar o nome das cidades que possuem pessoas que utilizam a operadora BMW e Mercedes-Benz, e que tenham realizado ao menos uma reserva, mostrando a cidade, nome e valor gasto na reserva.
```sql
SELECT CASE
           WHEN j.idpessoa IS NOT NULL THEN j.razao_social
           ELSE f.nome
       END AS nome,
       c.nome AS cidade,
       sum(s.valor) AS valor
FROM pessoa p
INNER JOIN telefone t USING (idpessoa)
INNER JOIN endereco e ON e.idendereco = p.idendereco
INNER JOIN cidade c ON e.idcidade = c.idcidade
LEFT JOIN fisica f ON f.idpessoa = p.idpessoa
LEFT JOIN juridica j ON j.idpessoa = p.idpessoa
INNER JOIN reservas r ON r.idpessoa = p.idpessoa
INNER JOIN reservas_has_servicos rs ON rs.idreservas = r.idreservas
INNER JOIN servicos s ON s.idservicos = rs.idservicos
WHERE t.operadora IN ('BMW',
                      'Mercedes-Benz')
  AND
    (SELECT vezes_reservadas
     FROM pessoa
     WHERE idpessoa = p.idpessoa) >= 1
GROUP BY j.idpessoa,
         f.idpessoa,
         c.nome
```
9. Mostrar o nome fantasia, código e o valor do documento de todas as pessoas jurídicas que possuem data de fundação entre 2000 e 2005 ou que sejam sediadas no estado do Rio Grande do Sul.
```sql
SELECT j.idpessoa,
       j.nome_fantasia,
       d.valor,
       td.descricao
FROM pessoa p
INNER JOIN juridica j USING (idpessoa)
INNER JOIN documento d USING (iddocumento)
INNER JOIN tipo_documento td USING (idtipo_documento)
INNER JOIN endereco e ON p.idendereco = e.idendereco
INNER JOIN cidade c USING (idcidade)
WHERE (j.data_fundacao >= '2000-01-01'
       AND j.data_fundacao <= '2005-12-31')
  OR c.idestado = 23
```
10. A empresa X quer desmarcar as reservas no turno da manhã de todas as terças-feiras do mês de setembro de 2017, para isso ela deseja realizar uma consulta que retorne todos os nomes e telefones das pessoas que já tenham marcado uma reserva nesta data, caso as pessoas não tenham a opção de receber promoções pelo telefone o e-mail também deve ser mostrado.
```sql
SELECT CASE
           WHEN j.idpessoa IS NOT NULL THEN j.razao_social
           ELSE f.nome
       END AS nome,
       t.telefone,
       e.email
FROM reservas r
INNER JOIN pessoa p USING (idpessoa)
LEFT JOIN fisica f ON f.idpessoa = p.idpessoa
LEFT JOIN juridica j ON j.idpessoa = p.idpessoa
LEFT JOIN telefone t ON t.idpessoa = p.idpessoa
LEFT JOIN email e ON e.idpessoa = p.idpessoa
WHERE r.iddia_atendimento = 2
  AND r.hora_inicio < '12:00'
  AND r.hora_fim < '12:00'
  AND r.data_atendimento BETWEEN '2017-09-01' AND '2017-09-30'
GROUP BY j.idpessoa,
         f.idpessoa,
         t.telefone,
         e.email
```
