create or replace view enviar_promocoes_email as
select p.idpessoa,
       case when j.idpessoa is not null then j.razao_social else f.nome end as nome,
       e.email
from pessoa p
inner join email e
using (idpessoa)
left join juridica j
on j.idpessoa = p.idpessoa
left join fisica f
on f.idpessoa = p.idpessoa
where e.receber_promocoes is true;
