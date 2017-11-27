CREATE OR REPLACE FUNCTION geraEnderecos(p_quantidade integer)
RETURNS boolean AS
$BODY$
/**
 * Realiza os inserts na tabela endereco
 **/
DECLARE
    v_count integer;
    v_random_cidade integer;
    v_random_endereco integer;
BEGIN
    v_count := 0;

    WHILE v_count < p_quantidade
    LOOP
        v_random_cidade := (select random() * 5593 + 1);
        v_random_endereco := (select random() * 99 + 1);

        IF NOT EXISTS (SELECT rua, bairro, numero FROM endereco WHERE rua ilike (select rua from tmp_endereco WHERE idtmp_endereco = v_random_endereco) AND bairro ilike (select bairro from tmp_endereco WHERE idtmp_endereco = v_random_endereco) AND numero = (select numero from tmp_endereco WHERE idtmp_endereco = v_random_endereco)::bigint)
            AND EXISTS (SELECT idcidade FROM cidade WHERE idcidade = v_random_cidade) THEN
        BEGIN
            INSERT INTO endereco (idcidade, rua, bairro, numero) VALUES (v_random_cidade, (SELECT rua FROM tmp_endereco WHERE idtmp_endereco = v_random_endereco), replace(replace((SELECT bairro FROM tmp_endereco WHERE idtmp_endereco = v_random_endereco), '.', ''), ',', ''), (SELECT numero FROM tmp_endereco WHERE idtmp_endereco = v_random_endereco));
            v_count := v_count +1;
        END;
        END IF;
    END LOOP;
    DROP TABLE tmp_endereco;
    RETURN true;
END;
$BODY$
LANGUAGE plpgsql;
