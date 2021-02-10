set search_path to hotel;

INSERT INTO gosc(imie, nazwisko, email) VALUES
('Sara', 'Sowa', 'sowa@gmail.com'),
('Antoni', 'Krasny', 'krasny@gmail.com'),
('Daria', 'Malska', 'd.malska@gmail.com');

INSERT INTO termin(poczatek, koniec) VALUES
('2021-02-02', '2021-02-05'),
('2021-01-25', '2021-01-31'),
('2021-01-28', '2021-01-29');

INSERT INTO kategoria(opis, ilosc_pokoi, cena) VALUES
('1 lozko', 1, 70),
('1 podwojne lozko', 2, 100),
('2 lozka', 1, 120),
('4 lozka', 2, 200);

INSERT INTO rezerwacje(id_gosc, id_termin, id_kategoria) VALUES
(1, 1, 2),
(2, 2, 4),
(3, 3, 1),
(3, 3, 1);

INSERT INTO pokoj(id_kategoria) VALUES
(1),
(2),
(2),
(3),
(4),
(4);

INSERT INTO sniadanie(id_gosc, cena) VALUES
(1, 30),
(1, 30), 
(2, 20),
(2, 20),
(2, 30);

INSERT INTO sprzatanie(codzienne, id_gosc, id_pokoj, cena) VALUES
(true, 1, 2, 8),
(false, 2, 5, 30);

INSERT INTO lista_osob(imie, nazwisko, id_gosc) VALUES
('Kacper', 'Olkuski', 1),
('Marianna', 'Krasny', 2),
('Jędrzej', 'Krasny', 2);
