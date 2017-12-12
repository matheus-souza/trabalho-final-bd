CREATE OR REPLACE FUNCTION deletaDadosPessoa()
RETURNS trigger AS
$BODY$
DECLARE
BEGIN
    INSERT INTO dados_remanescentes (
        nome,
        telefone,
        email) VALUES (
        (SELECT CASE WHEN nome IS NOT NULL THEN nome ELSE nome_fantasia END AS nome FROM pessoa p LEFT JOIN fisica f USING (idpessoa) LEFT JOIN juridica j ON p.idpessoa = j.idpessoa WHERE p.idpessoa = OLD.idpessoa),
        (SELECT '(' || ddd || ')' || telefone FROM telefone WHERE idpessoa = OLD.idpessoa LIMIT 1),
        (SELECT email FROM email WHERE idpessoa = OLD.idpessoa LIMIT 1));

    DELETE FROM telefone WHERE idpessoa = OLD.idpessoa;
    DELETE FROM email WHERE idpessoa = OLD.idpessoa;

    RETURN OLD;
END;
$BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS deleta_dados_pessoa ON fisica;
CREATE TRIGGER deleta_dados_pessoa
BEFORE DELETE ON fisica
FOR EACH ROW
EXECUTE PROCEDURE deletaDadosPessoa();

DROP TRIGGER IF EXISTS deleta_dados_pessoa ON juridica;
CREATE TRIGGER deleta_dados_pessoa
BEFORE DELETE ON juridica
FOR EACH ROW
EXECUTE PROCEDURE deletaDadosPessoa();
