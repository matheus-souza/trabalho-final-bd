CREATE TYPE t_reserva
AS (quantidade_reservas integer);

CREATE OR REPLACE FUNCTION quantidadeReservasPorServico(p_servico integer)
RETURNS SETOF t_reserva
AS $$
    select count(*)::integer
      from reservas r
inner join reservas_has_servicos rs
     using (idreservas)
inner join servicos s
     using (idservicos)
     where s.idservicos = p_servico

$$ LANGUAGE sql;
