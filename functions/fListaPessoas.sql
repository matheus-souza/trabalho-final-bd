CREATE TYPE t_pessoa
AS (idpessoa integer, nome varchar, criacao timestamp, edicao timestamp);

CREATE OR REPLACE FUNCTION listaPessoas(p_alteradas boolean default false)
RETURNS SETOF t_pessoa
AS $$
    select p.idpessoa,
       case when j.idpessoa is not null then j.razao_social else f.nome end as nome,
       p.criacao,
       p.edicao
    from pessoa p
    left join juridica j
    on j.idpessoa = p.idpessoa
    left join fisica f
    on f.idpessoa = p.idpessoa
    where case when p_alteradas is true then p.edicao is not null else true end
    and ((exists(select idpessoa from fisica where idpessoa = p.idpessoa)) or (exists(select idpessoa from juridica where idpessoa = p.idpessoa)))

$$ LANGUAGE sql;
