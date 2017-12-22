```sql
select f.nome
from pessoa p
inner join fisica f
on f.idpessoa = p.idpessoa
inner join email e
on e.idpessoa = p.idpessoa
where f.dt_nascimento >= '2000-01-01'
and e.receber_promocoes is true
group by f.nome
```
```sql
select case when j.idpessoa is not null then j.razao_social else f.nome end as nome,
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
from pessoa p
inner join telefone t
using (idpessoa)
left join juridica j
on j.idpessoa = p.idpessoa
left join fisica f
on f.idpessoa = p.idpessoa
inner join reservas r
on r.idpessoa = p.idpessoa
inner join dia_atendimento da
on da.iddia_atendimento = r.iddia_atendimento
where r.idreservas in (select idreservas from reservas where iddia_atendimento = 2)
and r.hora_inicio > '14:00'
group by j.idpessoa, j.razao_social, f.nome, t.telefone, dia_semana
```
```sql
select sum(s.valor) as valor_agosto_2016
from pessoa p
inner join telefone t
using (idpessoa)
left join juridica j
on j.idpessoa = p.idpessoa
left join fisica f
on f.idpessoa = p.idpessoa
inner join reservas r
on r.idpessoa = p.idpessoa
inner join reservas_has_servicos rs
on rs.idreservas = r.idreservas
inner  join servicos s
on s.idservicos = rs.idservicos
where r.data_atendimento > '2016-08-01'
and r.data_atendimento < '2016-08-31'
```
```sql
select p.idpessoa,
       case when j.idpessoa is not null then j.razao_social else f.nome end as nome,
       CASE EXTRACT( DOW FROM r.data_atendimento)
           WHEN 0 THEN 'Domingo'
           WHEN 1 THEN 'Segunda'
           WHEN 2 THEN 'Terça'
           WHEN 3 THEN 'Quarta'
           WHEN 4 THEN 'Quinta'
           WHEN 5 THEN 'Sexta'
           WHEN 6 THEN 'Sábado'
       END AS dia_semana,
       r.data_atendimento,
       sum(s.valor) as valor,
       r.hora_inicio as hora_reserva
from pessoa p
left join juridica j
on j.idpessoa = p.idpessoa
left join fisica f
on f.idpessoa = p.idpessoa
inner join reservas r
on r.idpessoa = p.idpessoa
inner join email e
on e.idpessoa = p.idpessoa
inner join reservas_has_servicos rs
on rs.idreservas = r.idreservas
inner join servicos s
on s.idservicos = rs.idservicos
where (select count(*) from reservas where idpessoa = p.idpessoa) = 1
and r.data_atendimento >= '2016-01-01'
and r.data_atendimento <= all (select data_atendimento from reservas inner join pessoa on pessoa.idpessoa = reservas.idpessoa 
                               where data_atendimento >= '2016-01-01' and (select count(*) from reservas where idpessoa = pessoa.idpessoa) = 1)
group by p.idpessoa, j.idpessoa, f.nome, r.data_atendimento, r.hora_inicio
```
```sql
select p.idpessoa,
       case when j.idpessoa is not null then j.razao_social else f.nome end as nome,
       e.email
from pessoa p
left join juridica j
on j.idpessoa = p.idpessoa
left join fisica f
on f.idpessoa = p.idpessoa
inner join reservas r
on r.idpessoa = p.idpessoa
inner join email e
on e.idpessoa = p.idpessoa
where (select count(*) from reservas where idpessoa = p.idpessoa) > 2
and e.receber_promocoes is true
and r.data_atendimento > '2016-06-01'
group by p.idpessoa, j.idpessoa, f.nome, e.email
```
```sql
select case when j.idpessoa is not null then j.razao_social else f.nome end as nome,
       t.receber_promocoes,
       '(' || t.ddd || ')' || t.telefone
from pessoa p
left join juridica j
on j.idpessoa = p.idpessoa
left join fisica f
on f.idpessoa = p.idpessoa
inner join reservas r
on r.idpessoa = p.idpessoa
inner join telefone t
on t.idpessoa = p.idpessoa
where (r.hora_fim - r.hora_inicio) >= all (select hora_fim-hora_inicio from reservas)
and r.data_atendimento > '2017-06-30'
and r.data_atendimento < '2017-12-31'
```
```sql
select count(p.*)
from pessoa p
inner join telefone t
using (idpessoa)
inner join reservas r
on r.idpessoa = p.idpessoa
where p.idpessoa <> all (select idpessoa from reservas where data_atendimento >= '2016-01-01' and data_atendimento <= '2016-06-30')
and t.operadora = 'BMW'
```
```sql
select case when j.idpessoa is not null then j.razao_social else f.nome end as nome,
c.nome as cidade,
sum(s.valor) as valor
from pessoa p
inner join telefone t
using (idpessoa)
inner join endereco e
on e.idendereco = p.idendereco
inner join cidade c
on e.idcidade = c.idcidade
left join fisica f
on f.idpessoa = p.idpessoa
left join juridica j
on j.idpessoa = p.idpessoa
inner join reservas r
on r.idpessoa = p.idpessoa
inner join reservas_has_servicos rs
on rs.idreservas = r.idreservas
inner join servicos s
on s.idservicos = rs.idservicos
where t.operadora in ('BMW', 'Mercedes-Benz')
and (select vezes_reservadas from pessoa where idpessoa = p.idpessoa) >= 1
group by j.idpessoa, f.idpessoa, c.nome
```
```sql
select j.idpessoa,
       j.nome_fantasia,
       d.valor,
       td.descricao
from pessoa p
inner join juridica j
using (idpessoa)
inner join documento d
using (iddocumento)
inner join tipo_documento td
using (idtipo_documento)
inner join endereco e
on p.idendereco = e.idendereco
inner join cidade c
using (idcidade)
where (j.data_fundacao >= '2000-01-01'
and j.data_fundacao <= '2005-12-31')
or c.idestado = 23
```
```sql
select case when j.idpessoa is not null then j.razao_social else f.nome end as nome,
       t.telefone,
       e.email
from reservas r
inner join pessoa p
using (idpessoa)
left join fisica f
on f.idpessoa = p.idpessoa
left join juridica j
on j.idpessoa = p.idpessoa
left join telefone t
on t.idpessoa = p.idpessoa
left join email e
on e.idpessoa = p.idpessoa
where r.iddia_atendimento = 2
and r.hora_inicio < '12:00'
and r.hora_fim < '12:00'
and r.data_atendimento between '2017-09-01' and '2017-09-30'
group by j.idpessoa, f.idpessoa, t.telefone, e.email
```
