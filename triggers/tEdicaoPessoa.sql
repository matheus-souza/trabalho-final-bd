CREATE OR REPLACE FUNCTION edicaoPessoa()
RETURNS trigger AS
$BODY$
/**
 *
 **/
DECLARE
    v_colunas_padrao VARCHAR[];
    v_changes hstore;
BEGIN
    IF (TG_OP = 'UPDATE')
    THEN
        v_changes := hstore(NEW) - hstore(OLD);
        v_colunas_padrao := ARRAY['vezes_reservadas'];
        v_changes := v_changes - v_colunas_padrao;
        
        IF v_changes != ''::hstore
        THEN
            NEW.edicao = NOW();
        END IF;
    END IF;
    RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS edicao_pessoa ON pessoa;
CREATE TRIGGER edicao_pessoa
BEFORE UPDATE ON pessoa
FOR EACH ROW
EXECUTE PROCEDURE edicaoPessoa();

update pessoa set criacao = now() where idpessoa > 40;
