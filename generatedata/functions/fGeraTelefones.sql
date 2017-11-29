CREATE OR REPLACE FUNCTION geraTelefones(p_quantidade integer)
RETURNS boolean AS
$BODY$
/**
 * Realiza os inserts na tabela telefone
 **/
DECLARE
    v_count integer;
    v_random_telefone integer;
    v_random_pessoa integer;
BEGIN
    v_count := 0;

    WHILE v_count < p_quantidade
    LOOP
        v_random_telefone := (select random() * 999 + 1);
        v_random_pessoa := (select random() * 49 + 1);

        IF NOT EXISTS (SELECT telefone FROM telefone WHERE telefone = (SELECT telefone FROM tmp_telefone WHERE idtmp_telefone = v_random_telefone))
            AND EXISTS (SELECT idpessoa FROM pessoa WHERE idpessoa = v_random_pessoa)
        THEN
        BEGIN
            INSERT INTO telefone (idpessoa, ddd, telefone, receber_promocoes, operadora) VALUES (v_random_pessoa, (SELECT ddd FROM tmp_telefone WHERE idtmp_telefone = v_random_telefone), (SELECT telefone FROM tmp_telefone WHERE idtmp_telefone = v_random_telefone), (SELECT receber_promocoes FROM tmp_telefone WHERE idtmp_telefone = v_random_telefone), (SELECT operadora FROM tmp_telefone WHERE idtmp_telefone = v_random_telefone));
            v_count := v_count +1;
        END;
        END IF;
    END LOOP;
    DROP TABLE tmp_telefone;
    RETURN true;
END;
$BODY$
LANGUAGE plpgsql;
