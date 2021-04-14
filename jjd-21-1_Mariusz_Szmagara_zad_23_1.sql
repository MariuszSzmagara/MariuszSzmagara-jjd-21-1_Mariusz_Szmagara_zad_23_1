CREATE SCHEMA homework_23_1 CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci;

-- 1. Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko).
--    W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.
CREATE TABLE employee(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30),
last_name VARCHAR(30),
gender ENUM('M', 'F'),
date_of_birth DATE,
position VARCHAR(30),
date_of_employment DATE,
salary DOUBLE
); 
  
-- 2. Wstawia do tabeli co najmniej 6 pracowników.
INSERT INTO employee
(first_name, last_name, gender, date_of_birth, position, date_of_employment, salary)
VALUES
('Georgi', 'Facello', 'M', '1953-09-02', 'Senior Staff', '1986-06-26', 65909),
('Bezalel', 'Simmel', 'F', '1964-06-02', 'Staff', '1985-11-21', 67534),
('Parto', 'Bamford', 'M', '1959-12-03', 'Senior Engineer', '1986-08-28', 69366),
('Chirstian', 'Koblick', 'M', '1954-05-01', 'Senior Staff', '1986-12-01', 71963),
('Kyoichi', 'Maliniak', 'M', '1955-01-21', 'Staff', '1989-09-12', 72527),
('Anneke', 'Preusig', 'F', '1953-04-20', 'Assistant Engineer', '1989-06-02', 40006),
('Tzvetan', 'Zielinski', 'F', '1957-05-23', 'Assistant Engineer', '1989-02-10', 43616),
('Saniya', 'Kalloufi', 'M', '1958-02-19', 'Engineer', '1994-09-15', 43466),
('Sumant', 'Peac', 'F', '1952-04-19', 'Senior Engineer', '1985-02-18', 43636),
('Duangkaew', 'Piveteau',  'F', '1963-06-01', 'Engineer', '1989-08-24', 43478);

-- 3. Pobiera wszystkich pracowników 
--    i wyświetla ich w kolejności alfabetycznej po nazwisku.
SELECT * FROM employee ORDER BY last_name ASC;

-- 4. Pobiera pracowników na wybranym stanowisku.
SELECT * FROM employee WHERE position = 'Staff';

-- 5. Pobiera pracowników, którzy mają co najmniej 30 lat.
SELECT * FROM employee WHERE (DATEDIFF(CURDATE(), date_of_birth) / 365.25) >= 30;

-- 6. Zwiększa wypłatę pracowników na wybranym stanowisku o 10%.
UPDATE employee SET salary = salary + (salary * 0.1) WHERE position = 'Engineer';

-- 7. Usuwa najmłodszego pracownika.
DELETE FROM employee WHERE date_of_birth = (SELECT MAX(date_of_birth) FROM employee);

-- 8. Usuwa tabelę pracownik.
DROP TABLE IF EXISTS employee;

-- 9. Tworzy tabelę stanowisko 
--    (nazwa stanowiska, opis, wypłata na danym stanowisku).
CREATE TABLE employee_position (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30),
description VARCHAR(2000),
salary DOUBLE
);

-- 10. Tworzy tabelę adres 
--     (ulica+numer domu/mieszkania, kod pocztowy, miejscowość).
CREATE TABLE employee_contact_info (
id INT PRIMARY KEY AUTO_INCREMENT,
street_name_and_house_or_flat_no VARCHAR(30),
place VARCHAR(30),
postcode VARCHAR(30)
); 

-- 11. Tworzy tabelę pracownik 
--     (imię, nazwisko) + relacje do tabeli stanowisko i adres.
CREATE TABLE employee (
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30),
last_name VARCHAR(30),
gender ENUM('M', 'F')
); 

ALTER TABLE employee
ADD position_id INT,
ADD FOREIGN KEY(position_id) REFERENCES employee_position(id);

ALTER TABLE employee_contact_info
ADD employee_id INT UNIQUE NOT NULL,
ADD FOREIGN KEY(employee_id) REFERENCES employee(id);

-- 12. Dodaje dane testowe 
--     (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania).
INSERT INTO employee_position
(name, description, salary)
VALUES
('Assistant Engineer', 'Assist in designing, developing and executing construction projects.', 40006),
('Engineer', 'Develop new products by recording and analyzing performance and material parts for testing.', 43466),
('Senior Engineer', 'Oversee operating processes used to complete projects and create products.', 43636),
('Senior Staff', 'Responsible for planning and directing the work of a group of individuals.', 65909),
('Staff', 'Employed as a clerical worker in an office.', 67534);

INSERT INTO employee
(first_name, last_name, gender, position_id)
VALUES
('Georgi', 'Facello', 'M', 4),
('Bezalel', 'Simmel', 'F', 5),
('Parto', 'Bamford', 'M', 3),
('Chirstian', 'Koblick', 'M', 4),
('Kyoichi', 'Maliniak', 'M', 5),
('Anneke', 'Preusig', 'F', 1),
('Tzvetan', 'Zielinski', 'F', 1),
('Saniya', 'Kalloufi', 'M', 2),
('Sumant', 'Peac', 'F', 3),
('Duangkaew', 'Piveteau', 'F', 2);

INSERT INTO employee_contact_info
(employee_id, street_name_and_house_or_flat_no, place, postcode)
VALUES
(6, 'P.O. Box 418, 2249 Ut, Av.', 'Puqueldón', '81098'),
(3, '9481 Eu Av.', 'Durg', '90210'),
(1, '8745 Nunc. Road', 'Tranent', '24622'),
(8, '821-5631 Mauris Rd.', 'Dorgali', '35663'),
(10, '7320 Ut, Rd.', 'Roselies', '72314'),
(2, '1434 Tellus Av.', 'Tanjung Pinang', '38185'),
(9, '9687 Lectus Avenue', 'Matlock', '05447'),
(7, '631-9762 Elit, Road', 'Ełk', '90210'),
(4, '288-2006 Ac, Avenue', 'Rajkot', '04476'),
(5, '6472 Rhoncus St.', 'Kursk', '90210');

-- 13. Pobiera pełne informacje o pracowniku 
--     (imię, nazwisko, adres, stanowisko).
SELECT * FROM employee LEFT JOIN employee_contact_info ON employee.id = employee_contact_info.employee_id
  LEFT JOIN employee_position ON employee.position_id = employee_position.id
WHERE employee.id = 1;

-- 14. Oblicza sumę wypłat dla wszystkich pracowników w firmie.
SELECT SUM(salary) FROM employee LEFT JOIN employee_contact_info ON employee.id = employee_contact_info.employee_id
  LEFT JOIN employee_position ON employee.position_id = employee_position.id;

-- 15. Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 
--     (albo innym, który będzie miał sens dla Twoich danych testowych).
SELECT * FROM employee LEFT JOIN employee_contact_info ON employee.id = employee_contact_info.employee_id
  LEFT JOIN employee_position ON employee.position_id = employee_position.id
WHERE employee_contact_info.postcode = '90210';


