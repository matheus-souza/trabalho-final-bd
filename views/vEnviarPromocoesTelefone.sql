create or replace view enviar_promocoes_telefone as
select p.idpessoa,
       case when j.idpessoa is not null then j.razao_social else f.nome end as nome,
       '(' || t.ddd || ')' || t.telefone,
t.operadora
from pessoa p
inner join telefone t
using (idpessoa)
left join juridica j
on j.idpessoa = p.idpessoa
left join fisica f
on f.idpessoa = p.idpessoa
where t.receber_promocoes is true;
