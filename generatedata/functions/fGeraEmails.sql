CREATE OR REPLACE FUNCTION geraEmail(p_quantidade integer)
RETURNS boolean AS
$BODY$
/**
 * Realiza os inserts na tabela email
 **/
DECLARE
    v_count integer;
    v_random_email integer;
    v_random_pessoa integer;
BEGIN
    v_count := 0;

    WHILE v_count < p_quantidade
    LOOP
        v_random_email := (select random() * 999 + 1);
        v_random_pessoa := (select random() * 49 + 1);

        IF NOT EXISTS (SELECT email FROM email WHERE email ilike (SELECT email FROM tmp_email WHERE idtmp_email = v_random_email))
            AND EXISTS (SELECT idpessoa FROM pessoa WHERE idpessoa = v_random_pessoa)
        THEN
        BEGIN
            INSERT INTO email (idpessoa, email, receber_promocoes) VALUES (v_random_pessoa, (SELECT email FROM tmp_email WHERE idtmp_email = v_random_email), (SELECT receber_promocoes FROM tmp_email WHERE idtmp_email = v_random_email));
            v_count := v_count +1;
        END;
        END IF;
    END LOOP;
    DROP TABLE tmp_email;
    RETURN true;
END;
$BODY$
LANGUAGE plpgsql;
