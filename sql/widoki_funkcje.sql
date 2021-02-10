-- widoki ------------------------------------------------------
CREATE OR REPLACE VIEW hotel.rezerwacje_info(id_rezerwacje, imie, nazwisko, poczatek, koniec, opis, numer_pokoju) AS
SELECT r.id_rezerwacje, g.imie, g.nazwisko, t.poczatek, t.koniec, k.opis, p.id_pokoj
FROM hotel.gosc g
JOIN hotel.rezerwacje r USING (id_gosc)
JOIN hotel.kategoria k USING (id_kategoria)
JOIN hotel.pokoj_termin pt USING (id_termin, id_rezerwacje)
JOIN hotel.pokoj p USING (id_pokoj, id_kategoria)
JOIN hotel.termin t USING (id_termin)
ORDER BY 1;

CREATE OR REPLACE VIEW hotel.rachunek_pokoje(id_rezerwacja, cena, ilosc_dni, id_gosc) AS
SELECT r.id_rezerwacje, k.cena,
DATE_PART('day', t.koniec::timestamp -  t.poczatek::timestamp),
r.id_gosc from hotel.kategoria k
JOIN hotel.rezerwacje r USING (id_kategoria)
JOIN hotel.termin t USING (id_termin)
ORDER BY id_rezerwacje;

CREATE OR REPLACE VIEW hotel.rachunek_suma_pokoje(id_gosc, imie, nazwisko, suma) AS
WITH cte AS (SELECT r.id_gosc, SUM(r.cena*r.ilosc_dni) AS suma
FROM hotel.rachunek_pokoje r
GROUP BY r.id_gosc
ORDER BY r.id_gosc)
SELECT id_gosc, imie, nazwisko, suma
FROM hotel.gosc JOIN cte USING(id_gosc);

CREATE OR REPLACE VIEW hotel.rachunek_sniadania(id_gosc, suma) AS
SELECT g.id_gosc, SUM(s.cena*r.ilosc_dni)
FROM hotel.gosc g
JOIN hotel.rachunek_pokoje r USING (id_gosc)
FULL OUTER JOIN hotel.sniadanie s USING (id_gosc)
GROUP BY g.id_gosc
ORDER BY g.id_gosc;

CREATE OR REPLACE VIEW hotel.rachunek_sprzatanie(id_gosc, suma) AS
WITH cte AS (SELECT g.id_gosc, 
					CASE s.codzienne
						WHEN true THEN SUM(s.cena*r.ilosc_dni)
						WHEN false THEN SUM(s.cena)
					END AS suma
			FROM hotel.sprzatanie s
			FULL OUTER JOIN hotel.gosc g USING (id_gosc)
			JOIN hotel.rachunek_pokoje r USING (id_gosc)
			GROUP BY g.id_gosc, s.codzienne)
SELECT id_gosc, sum(suma) AS suma
FROM cte
GROUP BY id_gosc
ORDER BY id_gosc;

CREATE OR REPLACE VIEW hotel.rachunki(id_gosc, pokoje, sniadania, sprzatanie, suma) AS
SELECT g.id_gosc, rsp.suma AS pokoje, COALESCE(rsn.suma, 0) AS sniadania, COALESCE(rspr.suma, 0) AS sprzatanie, rsp.suma + COALESCE(rsn.suma, 0) + COALESCE(rspr.suma, 0) AS suma
FROM hotel.gosc g
JOIN hotel.rachunek_suma_pokoje rsp using(id_gosc) 
FULL OUTER JOIN hotel.rachunek_sniadania rsn using(id_gosc)
FULL OUTER JOIN hotel.rachunek_sprzatanie rspr using(id_gosc)
ORDER BY g.id_gosc;

CREATE OR REPLACE VIEW hotel.gosc_rezerwacje_voucher(id_gosc, imie, nazwisko, liczba_rezerwacji) AS
WITH cte AS 
(SELECT id_gosc, COUNT(id_rezerwacje) AS liczba_rezerwacji
FROM hotel.gosc JOIN hotel.rezerwacje USING(id_gosc)
GROUP BY id_gosc
HAVING COUNT(id_rezerwacje) > 1)
SELECT id_gosc, imie, nazwisko, liczba_rezerwacji
FROM hotel.gosc JOIN cte USING (id_gosc);

CREATE OR REPLACE VIEW hotel.lista_gosci(id_gosc, imie, nazwisko, osoba_imie, osoba_nazwisko) AS
SELECT g.id_gosc, g.imie, g.nazwisko, l.imie, l.nazwisko
FROM hotel.gosc g JOIN hotel.lista_osob l USING(id_gosc);

CREATE OR REPLACE VIEW hotel.gosc_oplata_voucher(id_gosc, imie, nazwisko, oplata) AS
WITH cte AS (SELECT r.id_gosc, SUM(r.cena*r.ilosc_dni) AS suma
FROM hotel.rachunek_pokoje r
GROUP BY r.id_gosc
HAVING SUM(r.cena*r.ilosc_dni) > 500
ORDER BY r.id_gosc)
SELECT id_gosc, imie, nazwisko, suma
FROM hotel.gosc JOIN cte USING(id_gosc);

-- funckje i wyzwalacze ------------------------------------------------
CREATE OR REPLACE FUNCTION hotel.check_rezerwacje_insert() RETURNS TRIGGER AS 
$$
	DECLARE
		P hotel.termin.poczatek%TYPE;
		K hotel.termin.koniec%TYPE;
		p2 hotel.termin.poczatek%TYPE;
		k2 hotel.termin.koniec%TYPE;
		r RECORD;
		pok RECORD;
		ilosc hotel.kategoria.ilosc_pokoi%TYPE;
		i INTEGER := 0;
    BEGIN
    	SELECT INTO P poczatek FROM hotel.termin WHERE id_termin=NEW.id_termin;
    	SELECT INTO K koniec FROM hotel.termin WHERE id_termin=NEW.id_termin;
    	CREATE TEMP TABLE zajete(id_pokoj INTEGER);
    	
    	FOR r IN (SELECT id_termin, id_kategoria FROM hotel.rezerwacje)
		LOOP
		 		SELECT INTO p2 poczatek FROM hotel.termin WHERE id_termin=r.id_termin;
    			SELECT INTO k2 koniec FROM hotel.termin WHERE id_termin=r.id_termin;
    			IF (NOT (p2::timestamp > K::timestamp OR k2::timestamp < P::timestamp)) 
    			AND NEW.id_kategoria = r.id_kategoria THEN
    				i := i + 1;	
    				INSERT INTO zajete SELECT id_pokoj FROM hotel.pokoj_termin WHERE id_termin=r.id_termin;
    			END IF;
		END LOOP;
		
		SELECT INTO ilosc ilosc_pokoi FROM hotel.kategoria WHERE id_kategoria=NEW.id_kategoria; 
		IF i < ilosc THEN 
			FOR pok IN (SELECT id_pokoj FROM hotel.pokoj WHERE id_kategoria=NEW.id_kategoria)
			LOOP
				IF NOT EXISTS (SELECT * FROM zajete WHERE id_pokoj=pok.id_pokoj) THEN
					RETURN NEW;
				END IF;
			END LOOP;
        END IF;
        RAISE EXCEPTION 'Nie ma dostępnych pokoi w tym terminie z tej kategorii.';
        DROP TABLE zajete;
        RETURN NULL;
    END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER rezerwacje_insert 
    BEFORE INSERT ON hotel.rezerwacje
    FOR EACH ROW EXECUTE PROCEDURE hotel.check_rezerwacje_insert();

    
CREATE OR REPLACE FUNCTION hotel.rezerwacje_insert_pokoj_termin() RETURNS TRIGGER AS 
$$
	DECLARE
		pok RECORD;
    BEGIN
			FOR pok IN (SELECT id_pokoj FROM hotel.pokoj WHERE id_kategoria=NEW.id_kategoria)
			LOOP 
				IF NOT EXISTS (SELECT * FROM zajete WHERE id_pokoj=pok.id_pokoj) THEN
					INSERT INTO hotel.pokoj_termin(id_termin, id_pokoj, id_rezerwacje) VALUES (NEW.id_termin, pok.id_pokoj, NEW.id_rezerwacje);
					DROP TABLE zajete;
					RETURN NULL;
				END IF;
			END LOOP;
        DROP TABLE zajete;
        RETURN NULL;
    END;
$$ LANGUAGE 'plpgsql'; 

CREATE TRIGGER rezerwacje_insert_pokoj_termin 
    AFTER INSERT ON hotel.rezerwacje
    FOR EACH ROW EXECUTE PROCEDURE hotel.rezerwacje_insert_pokoj_termin();
    
    
CREATE OR REPLACE FUNCTION hotel.pokoj_insert_kategoria_update() RETURNS TRIGGER AS 
$$
	BEGIN
		IF TG_OP = 'INSERT' THEN
			UPDATE hotel.kategoria SET ilosc_pokoi = ilosc_pokoi + 1 WHERE id_kategoria=NEW.id_kategoria;
			RETURN NEW;
		ELSIF TG_OP = 'UPDATE' THEN
			UPDATE hotel.kategoria SET ilosc_pokoi = ilosc_pokoi - 1 WHERE id_kategoria=OLD.id_kategoria;
			UPDATE hotel.kategoria SET ilosc_pokoi = ilosc_pokoi + 1 WHERE id_kategoria=NEW.id_kategoria;
			RETURN NEW;
		ELSIF TG_OP = 'DELETE' THEN
			UPDATE hotel.kategoria SET ilosc_pokoi = ilosc_pokoi - 1 WHERE id_kategoria=OLD.id_kategoria;
			RETURN NULL;
		END IF;
	END;
$$ LANGUAGE 'plpgsql';  

CREATE TRIGGER pokoj_insert 
    AFTER INSERT OR UPDATE OR DELETE ON hotel.pokoj
    FOR EACH ROW EXECUTE PROCEDURE hotel.pokoj_insert_kategoria_update();
    

CREATE OR REPLACE FUNCTION hotel.termin_insert_check() RETURNS TRIGGER AS 
$$
	DECLARE 
	BEGIN
		IF NEW.poczatek::timestamp < NEW.koniec::timestamp 
		AND NEW.poczatek::timestamp > CURRENT_TIMESTAMP 
		AND NEW.koniec::timestamp < CURRENT_TIMESTAMP + '6 months'::interval THEN
			RETURN NEW;
		ELSE
			RAISE NOTICE 'Data początkowa musi być wcześniejsza niż końcowa oraz późniejsza niż dzisiejsza data. Data końcowa może być najpóźniej za 6 miesięcy.';
			RETURN NULL;
		END IF;
	EXCEPTION WHEN OTHERS THEN
		RAISE EXCEPTION 'Niepoprawna data lub format daty.';
		RETURN NULL;
	END;
$$ LANGUAGE 'plpgsql';  

CREATE TRIGGER termin_insert
    BEFORE INSERT ON hotel.termin
    FOR EACH ROW EXECUTE PROCEDURE hotel.termin_insert_check();
