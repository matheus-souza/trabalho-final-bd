CREATE OR REPLACE FUNCTION geraPessoaFisica(p_quantidade integer)
RETURNS boolean AS
$BODY$
/**
 * Realiza os inserts na pessoa e pessoa_fisica
 **/
DECLARE
    v_tipo_documento integer;
    v_count integer;
    v_random_endereco integer;
    v_random_documento integer;
    v_random_nome integer;
    v_idpessoa integer;
    v_dtnascimento date;
BEGIN
    v_count := 0;

    WHILE v_count < p_quantidade
    LOOP
        v_random_documento := (select random() * 49 + 1);
        v_random_endereco := (select random() * 49 + 1);
        v_random_nome := (select random() * 199 + 1);

        IF NOT EXISTS (SELECT idpessoa FROM pessoa WHERE idendereco = v_random_endereco)
            AND NOT EXISTS (SELECT iddocumento FROM fisica WHERE iddocumento = v_random_documento)
            AND EXISTS (SELECT idendereco FROM endereco WHERE idendereco = v_random_endereco)
            AND EXISTS (SELECT iddocumento FROM documento WHERE iddocumento = v_random_documento)
            AND EXISTS (SELECT idtmp_nome FROM tmp_nome WHERE idtmp_nome = v_random_nome)
        THEN
        BEGIN
            INSERT INTO pessoa (idendereco) VALUES (v_random_endereco) RETURNING idpessoa INTO v_idpessoa;
            v_dtnascimento := (SELECT cast(now() - '100 year'::interval * random() as date));
            INSERT INTO fisica (idpessoa, iddocumento, nome, dt_nascimento) VALUES (v_idpessoa, v_random_documento, (SELECT valor FROM tmp_nome WHERE idtmp_nome = v_random_nome), v_dtnascimento);
            v_count := v_count +1;
        END;
        END IF;
    END LOOP;
    DROP TABLE tmp_nome;
    RETURN true;
END;
$BODY$
LANGUAGE plpgsql;
