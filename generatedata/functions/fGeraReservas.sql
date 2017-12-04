CREATE OR REPLACE FUNCTION geraReservas(p_quantidade integer)
RETURNS boolean AS
$BODY$
/**
 * Realiza os inserts na tabela reservas
 **/
DECLARE
    v_count integer;
    v_random_pessoa integer;
    v_random_servico integer;
    v_random_dia_atendimento integer;
    v_data date;
    v_hora_inicio time;
    v_idreservas integer;
BEGIN
    v_count := 0;

    WHILE v_count < p_quantidade
    LOOP
        v_random_pessoa := (select random() * 49 + 1);
        v_random_servico := (select random() * 6 + 1);
        v_random_dia_atendimento := (select random() * 5 + 1);
        v_data := (SELECT cast(now() - '3 year'::interval * random() as date));
        v_hora_inicio := (SELECT to_char((SELECT cast(now() - '3 year'::interval * random() as timestamp)), 'HH24:MI'))::time;

        IF EXISTS (SELECT idpessoa FROM pessoa WHERE idpessoa = v_random_pessoa)
            AND EXISTS (SELECT idservicos FROM servicos WHERE idservicos = v_random_servico)
            AND EXISTS (SELECT dia_semana FROM dia_atendimento WHERE dia_semana = (select EXTRACT(DOW FROM v_data::date)))
            AND EXISTS (SELECT hora_inicio FROM horario_atendimento WHERE iddia_atendimento = v_random_dia_atendimento AND hora_inicio < v_hora_inicio AND hora_fim > (v_hora_inicio::interval + (SELECT tempo_medio_atendimento FROM servicos WHERE idservicos = v_random_servico))::time)
            AND NOT EXISTS (SELECT idreservas FROM reservas WHERE (hora_inicio BETWEEN v_hora_inicio AND (v_hora_inicio::interval + (SELECT tempo_medio_atendimento FROM servicos WHERE idservicos = v_random_servico))::time) OR (hora_fim BETWEEN v_hora_inicio AND (v_hora_inicio::interval + (SELECT tempo_medio_atendimento FROM servicos WHERE idservicos = v_random_servico))::time) AND data_atendimento = v_data)
            AND (v_hora_inicio < (v_hora_inicio::interval + (SELECT tempo_medio_atendimento FROM servicos WHERE idservicos = v_random_servico))::time)
        THEN
        BEGIN
            INSERT INTO reservas (idpessoa, iddia_atendimento, data_atendimento, hora_inicio, hora_fim, lembrete) VALUES
            (v_random_pessoa, v_random_dia_atendimento, v_data, v_hora_inicio, (v_hora_inicio::interval + (SELECT tempo_medio_atendimento FROM servicos WHERE idservicos = v_random_servico))::time, (random() > 0.5))
            RETURNING idreservas INTO v_idreservas;

            INSERT INTO reservas_has_servicos (idreservas, idservicos) VALUES (v_idreservas, v_random_servico);

            v_count := v_count +1;
        END;
        END IF;
    END LOOP;
    RETURN true;
END;
$BODY$
LANGUAGE plpgsql;
