CREATE OR REPLACE FUNCTION geraAnosFiscais()
RETURNS boolean AS
$BODY$
DECLARE
    v_sql varchar;
    v_maior_ano integer;
    v_menor_ano integer;
    v_count integer;
BEGIN
    SELECT min(EXTRACT(YEAR FROM data_atendimento))::integer into v_menor_ano from reservas;
    SELECT max(EXTRACT(YEAR FROM data_atendimento))::integer into v_maior_ano from reservas;

    v_count := v_menor_ano;
    WHILE v_count <= v_maior_ano
    LOOP
        v_sql := 'CREATE OR REPLACE VIEW ano_fiscal_'||v_count||' as
        select sum(s.valor) as valor_anual, EXTRACT(YEAR FROM r.data_atendimento) as ano
        from reservas r
        inner join reservas_has_servicos rs
        using (idreservas)
        inner join servicos s
        using (idservicos)
        where EXTRACT(YEAR FROM r.data_atendimento)::integer =' || v_count ||
        'group by ano';

        EXECUTE v_sql;

        v_count := v_count + 1;
    END LOOP;
    RETURN true;
END;
$BODY$
LANGUAGE plpgsql;

select geraAnosFiscais();
