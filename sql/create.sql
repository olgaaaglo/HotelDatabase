CREATE SEQUENCE hotel.termin_id_termin_seq;

CREATE TABLE hotel.termin (
                id_termin INTEGER NOT NULL DEFAULT nextval('hotel.termin_id_termin_seq'),
                poczatek VARCHAR NOT NULL,
                koniec VARCHAR NOT NULL,
                CONSTRAINT termin_pk PRIMARY KEY (id_termin)
);

ALTER SEQUENCE hotel.termin_id_termin_seq OWNED BY hotel.termin.id_termin;

--------------------------------------------------------

CREATE SEQUENCE hotel.kategoria_id_kategoria_seq;

CREATE TABLE hotel.kategoria (
                id_kategoria INTEGER NOT NULL DEFAULT nextval('hotel.kategoria_id_kategoria_seq'),
                opis VARCHAR NOT NULL,
                ilosc_pokoi INTEGER NOT NULL,
                cena DOUBLE PRECISION NOT NULL,
                CONSTRAINT kategoria_pk PRIMARY KEY (id_kategoria)
);

ALTER SEQUENCE hotel.kategoria_id_kategoria_seq OWNED BY hotel.kategoria.id_kategoria;

---------------------------------------------------------

CREATE SEQUENCE hotel.pokoj_id_pokoj_seq;

CREATE TABLE hotel.pokoj (
                id_pokoj INTEGER NOT NULL DEFAULT nextval('hotel.pokoj_id_pokoj_seq'),
                id_kategoria INTEGER NOT NULL,
                CONSTRAINT pokoj_pk PRIMARY KEY (id_pokoj)
);

ALTER SEQUENCE hotel.pokoj_id_pokoj_seq OWNED BY hotel.pokoj.id_pokoj;

-----------------------------------------------------------

CREATE TABLE hotel.pokoj_termin (
                id_termin INTEGER NOT NULL,
                id_pokoj INTEGER NOT NULL,
                id_rezerwacje INTEGER NOT NULL,
                CONSTRAINT pokoj_termin_pk PRIMARY KEY (id_termin, id_pokoj)
);

------------------------------------------------------------

CREATE SEQUENCE hotel.gosc_id_gosc_seq;

CREATE TABLE hotel.gosc (
                id_gosc INTEGER NOT NULL DEFAULT nextval('hotel.gosc_id_gosc_seq'),
                imie VARCHAR(20) NOT NULL,
                nazwisko VARCHAR(20) NOT NULL,
                email VARCHAR(30) NOT NULL,
                CONSTRAINT gosc_pk PRIMARY KEY (id_gosc)
);

ALTER SEQUENCE hotel.gosc_id_gosc_seq OWNED BY hotel.gosc.id_gosc;

-----------------------------------------------------------

CREATE SEQUENCE hotel.lista_osob_id_osoba_seq;

CREATE TABLE hotel.lista_osob (
                id_osoba INTEGER NOT NULL DEFAULT nextval('hotel.lista_osob_id_osoba_seq'),
                imie VARCHAR NOT NULL,
                nazwisko VARCHAR NOT NULL,
                id_gosc INTEGER NOT NULL,
                CONSTRAINT lista_osob_pk PRIMARY KEY (id_osoba)
);

ALTER SEQUENCE hotel.lista_osob_id_osoba_seq OWNED BY hotel.lista_osob.id_osoba;

--------------------------------------------------------------

CREATE SEQUENCE hotel.sprzatanie_id_sprzatanie_seq;

CREATE TABLE hotel.sprzatanie (
                id_sprzatanie INTEGER NOT NULL DEFAULT nextval('hotel.sprzatanie_id_sprzatanie_seq'),
                codzienne BOOLEAN NOT NULL,
                id_gosc INTEGER NOT NULL,
                id_pokoj INTEGER NOT NULL,
                cena DOUBLE PRECISION NOT NULL,
                CONSTRAINT sprzatanie_pk PRIMARY KEY (id_sprzatanie)
);

ALTER SEQUENCE hotel.sprzatanie_id_sprzatanie_seq OWNED BY hotel.sprzatanie.id_sprzatanie;

--------------------------------------------------------------

CREATE SEQUENCE hotel.sniadanie_id_sniadanie_seq;

CREATE TABLE hotel.sniadanie (
                id_sniadanie INTEGER NOT NULL DEFAULT nextval('hotel.sniadanie_id_sniadanie_seq'),
                id_gosc INTEGER NOT NULL,
                cena DOUBLE PRECISION NOT NULL,
                CONSTRAINT sniadanie_pk PRIMARY KEY (id_sniadanie)
);

ALTER SEQUENCE hotel.sniadanie_id_sniadanie_seq OWNED BY hotel.sniadanie.id_sniadanie;

---------------------------------------------------------------

CREATE SEQUENCE hotel.rezerwacje_id_rezerwacje_seq;

CREATE TABLE hotel.rezerwacje (
                id_rezerwacje INTEGER NOT NULL DEFAULT nextval('hotel.rezerwacje_id_rezerwacje_seq'),
                id_gosc INTEGER NOT NULL,
                id_termin INTEGER NOT NULL,
                id_kategoria INTEGER NOT NULL,
                CONSTRAINT rezerwacje_pk PRIMARY KEY (id_rezerwacje)
);

ALTER SEQUENCE hotel.rezerwacje_id_rezerwacje_seq OWNED BY hotel.rezerwacje.id_rezerwacje;

----------------------------------------------------------------

ALTER TABLE hotel.rezerwacje ADD CONSTRAINT termin_rezerwacje_fk
FOREIGN KEY (id_termin)
REFERENCES hotel.termin (id_termin)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hotel.pokoj_termin ADD CONSTRAINT termin_pokoj_termin_fk
FOREIGN KEY (id_termin)
REFERENCES hotel.termin (id_termin)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hotel.pokoj ADD CONSTRAINT kategoria_1_pokoj_fk
FOREIGN KEY (id_kategoria)
REFERENCES hotel.kategoria (id_kategoria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hotel.rezerwacje ADD CONSTRAINT kategoria_rezerwacje_fk
FOREIGN KEY (id_kategoria)
REFERENCES hotel.kategoria (id_kategoria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hotel.pokoj_termin ADD CONSTRAINT pokoj_pokoj_termin_fk
FOREIGN KEY (id_pokoj)
REFERENCES hotel.pokoj (id_pokoj)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hotel.sprzatanie ADD CONSTRAINT pokoj_sprzatanie_fk
FOREIGN KEY (id_pokoj)
REFERENCES hotel.pokoj (id_pokoj)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hotel.rezerwacje ADD CONSTRAINT gosc_rezerwacje_fk
FOREIGN KEY (id_gosc)
REFERENCES hotel.gosc (id_gosc)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hotel.sniadanie ADD CONSTRAINT gosc_sniadanie_fk
FOREIGN KEY (id_gosc)
REFERENCES hotel.gosc (id_gosc)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hotel.sprzatanie ADD CONSTRAINT gosc_sprzatanie_fk
FOREIGN KEY (id_gosc)
REFERENCES hotel.gosc (id_gosc)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hotel.lista_osob ADD CONSTRAINT gosc_lista_osob_fk
FOREIGN KEY (id_gosc)
REFERENCES hotel.gosc (id_gosc)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hotel.pokoj_termin ADD CONSTRAINT rezerwacje_pokoj_termin_fk
FOREIGN KEY (id_rezerwacje)
REFERENCES hotel.rezerwacje (id_rezerwacje)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
