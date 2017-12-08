CREATE OR REPLACE FUNCTION geraVezesReservadas()
RETURNS trigger AS
$BODY$
/**
 * Realiza os inserts na pessoa e pessoa_fisica
 **/
DECLARE
    v_cur_pessoa CURSOR FOR SELECT idpessoa FROM pessoa;
    v_count integer;
    v_num_registros integer;
    v_idpessoa integer;
BEGIN
    UPDATE pessoa SET vezes_reservadas=0;

    OPEN v_cur_pessoa;
    v_count := 1;

    SELECT count(*) INTO v_num_registros FROM pessoa;
    WHILE v_count <= v_num_registros
    LOOP
        FETCH v_cur_pessoa INTO v_idpessoa;

        UPDATE pessoa SET vezes_reservadas = (SELECT count(idpessoa) FROM reservas WHERE idpessoa = v_idpessoa) WHERE idpessoa = v_idpessoa;

        v_count := v_count+1;
    END LOOP;
    CLOSE v_cur_pessoa;
    RETURN null;
END;
$BODY$
LANGUAGE plpgsql;

update reservas set idpessoa = idpessoa where idpessoa = 1;
