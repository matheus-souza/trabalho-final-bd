CREATE OR REPLACE VIEW clientes_recorrentes AS
   SELECT p.idpessoa,
          CASE WHEN nome IS NOT NULL THEN nome ELSE nome_fantasia END AS nome,
          p.vezes_reservadas
     FROM pessoa p
LEFT JOIN fisica f
    USING (idpessoa)
LEFT JOIN juridica j
       ON p.idpessoa = j.idpessoa
    WHERE p.vezes_reservadas > 1;
