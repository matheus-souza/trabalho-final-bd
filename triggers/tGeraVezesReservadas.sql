CREATE TRIGGER gera_vezes_reservadas
AFTER INSERT OR DELETE ON reservas
FOR EACH ROW
EXECUTE PROCEDURE geraVezesReservadas();
