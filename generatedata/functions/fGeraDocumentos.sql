CREATE OR REPLACE FUNCTION geraDocumentos(p_quantidade integer)
RETURNS boolean AS
$BODY$
/**
 * Realiza os inserts na tabela documentos
 **/
DECLARE
    v_tipo_documento integer;
    v_count integer;
    v_random_tipo integer;
    v_random_documento integer;
BEGIN
    v_count := 0;

    WHILE v_count < p_quantidade
    LOOP
        v_random_documento := (select random() * 99 + 1);
        v_random_tipo := (select random() * 7 + 1);

        IF NOT EXISTS (SELECT valor FROM documento WHERE valor ilike (SELECT valor FROM tmp_documento_valor WHERE idtmp_documento_valor = v_random_documento)) THEN
        BEGIN
            INSERT INTO documento (idtipo_documento, valor) VALUES (v_random_tipo, (SELECT valor FROM tmp_documento_valor WHERE idtmp_documento_valor = v_random_documento));
            v_count := v_count +1;
        END;
        END IF;
    END LOOP;
    DROP TABLE tmp_documento_valor;
    RETURN true;
END;
$BODY$
LANGUAGE plpgsql;
