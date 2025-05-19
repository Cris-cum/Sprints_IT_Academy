CREATE DATABASE sprint4;

-- tabla companies: company_id,company_name,phone,email,country,website. 100 rows. Import Wizard ok.

CREATE TABLE  companies(
company_id VARCHAR (100) PRIMARY KEY,
company_name VARCHAR(100),
phone VARCHAR(100),
email VARCHAR(100),
country VARCHAR(100),
website VARCHAR(100)
);
SELECT SUM(CHAR_LENGTH(company_id)) AS total_char_length
FROM companies;
SELECT MAX(CHAR_LENGTH(company_id)) AS max_length
FROM companies;

-- Medir las longitudes de las cadenas
SELECT
    MAX(CHAR_LENGTH(company_id)) AS max_length,
    MIN(CHAR_LENGTH(company_id)) AS min_length,
    AVG(CHAR_LENGTH(company_id)) AS avg_length
FROM tabla_prueba;
SELECT * FROM companies;
-- SHOW VARIABLES LIKE 'secure_file_priv';


-- tabla products: id, product_name, price, colour, weight, warehouse_id. 100 rows. Import manual code ok.
CREATE TABLE products (
    id VARCHAR(100) PRIMARY KEY,
    product_name VARCHAR(100),
    price VARCHAR(100),
    colour VARCHAR(100),
    weight DECIMAL(5,2),
    warehouse_id VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- tabla credit_cards: id, user_id, iban, pan, pin, cvv, track1, track2, expiring_date. 275 rows. Import manual code ok, he tenido que alterar la tabla para aumentar datos en id y cambiar el fields terminated by ",", estaba en ";" y por eso no salía.
CREATE TABLE credit_cards (
    id VARCHAR(100) PRIMARY KEY,
    user_id VARCHAR(100),
    iban VARCHAR(100),
    pan VARCHAR(100),
    pin VARCHAR(100),
    cvv VARCHAR(100),
    track1 VARCHAR(150),
    track2 VARCHAR(150),
    expiring_date VARCHAR(100)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- tabla users_ca: id, name, surname, phone, email, birth_date, country, city, postal_code, address. 75 rows. Manual code import ok, he tenido que cambiar '\r\n'
CREATE TABLE users_ca (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(100),
    email VARCHAR(100),
    birth_date VARCHAR(100),
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(100),
    address VARCHAR(100)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv'
INTO TABLE users_ca
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED by '\r\n'
IGNORE 1 ROWS;

-- tabla users_uk: id, name, surname, phone, email, birth_date, country, city, postal_code, address. 50 row

CREATE TABLE users_uk (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(100),
    email VARCHAR(100),
    birth_date VARCHAR(100),
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(100),
    address VARCHAR(100)
);
ALTER TABLE users_uk MODIFY COLUMN address VARCHAR(255);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv'
INTO TABLE users_uk
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
-- table users_usa: id, name, surname, phone, email, birth_date, country, city, postal_code, address. 150 rows. Import manual code ok.
CREATE TABLE users_usa (
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(100),
    email VARCHAR(100),
    birth_date VARCHAR(100),
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(100),
    address VARCHAR(100)
);

SELECT*
FROM users_usa;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv'
INTO TABLE users_usa
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED by '\r\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';
-- Deseo unificar tablas para que las subconsultas sean más fáciles.
CREATE TABLE users AS
SELECT id, name, surname, phone, email, birth_date, country, city, postal_code, address FROM users_ca
UNION ALL
SELECT id, name, surname, phone, email, birth_date, country, city, postal_code, address FROM users_uk
UNION ALL
SELECT id, name, surname, phone, email, birth_date, country, city, postal_code, address FROM users_usa;

-- Me aseguro de que me devuelve 275 rows, que es la suma de las demás tablas users
SELECT*
FROM users;

-- Procedo a eliminar las tablas que ya no me sirven:
DROP TABLE users_ca;
DROP TABLE users_uk;
DROP TABLE users_usa;
-- doy una PK

ALTER TABLE users
ADD PRIMARY KEY (id);

-- tabla transactions: id, card_id,	business_id, timestamp,	amount,	declined, product_ids, user_id, lat, longitude. 587 rows. Import code manual ok.

CREATE TABLE transactions (
    id VARCHAR(100) PRIMARY KEY,
    card_id VARCHAR(100),
    business_id VARCHAR(100),
    timestamp DATETIME,
    amount DECIMAL(6,2),
    declined VARCHAR(100),
    product_ids VARCHAR(100),
    user_id VARCHAR(100),
    lat FLOAT,
    longitude FLOAT
);


ALTER TABLE transactions MODIFY COLUMN id VARCHAR(150);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE transactions; 

CREATE TABLE transactions (
    id VARCHAR(255) PRIMARY KEY,
    card_id VARCHAR(100),
    business_id VARCHAR(100),
    timestamp DATETIME,
    amount DECIMAL(6,2),
    declined VARCHAR(100),
    product_ids VARCHAR(100),
    user_id VARCHAR(100),
    lat VARCHAR(100),
    longitude VARCHAR(100)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select*
from transaction_products;


-- quiero añadir las fk 
--  para card_id
ALTER TABLE transactions
ADD CONSTRAINT fk_card
FOREIGN KEY (card_id) REFERENCES credit_cards(id);
-- para user_id 
ALTER TABLE transactions
ADD CONSTRAINT fk_user_transaction
FOREIGN KEY (user_id) REFERENCES users(id);
-- para companies
ALTER TABLE transactions
ADD CONSTRAINT fk_business
FOREIGN KEY (business_id) REFERENCES companies(company_id);


-- Creo una nueva tabla entre products y transactions


CREATE TABLE transaction_products (
    transaction_id VARCHAR(255),
    product_id VARCHAR (100),
   FOREIGN KEY (transaction_id) REFERENCES transactions(id),
   FOREIGN KEY (product_id) REFERENCES products(id));
   -- AÑADIMOS DATOS
 INSERT INTO transaction_products (transaction_id, product_id)
SELECT 
    id AS transaction_id, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(product_ids, ' ', ''), ',', numbers.n), ',', -1)) AS product_id
FROM 
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 
    UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) numbers 
    INNER JOIN transactions ON CHAR_LENGTH(REPLACE(product_ids, ' ', ''))
    - CHAR_LENGTH(REPLACE(REPLACE(product_ids, ' ', ''), ',', '')) >= numbers.n - 1;

-- Ejercicio 1 nivel 1. Realiza una subconsulta que muestre todos los usuarios con más de 30 transacciones utilizando al menos 2 tablas.

SELECT u.id, u.name, u.surname
FROM users u
WHERE (
    SELECT COUNT(t.id)
    FROM transactions t
    WHERE t.user_id = u.id
) > 30;

-- Ejercicio 2. Nivel 1. Muestra la media de amount por IBAN de las tarjetas de crédito a la compañía Donec Ltd, utiliza al menos 2 tablas.
SELECT cc.iban, c.company_name, ROUND(AVG(t.amount), 2) AS media
FROM credit_cards cc
JOIN transactions t ON cc.id = t.card_id
JOIN companies c ON t.business_id = c.company_id
WHERE c.company_name = 'Donec Ltd'
GROUP BY cc.iban, c.company_name;

-- Ejercicio 1. Nivel 2. Crea una nueva tabla que refleje el estado de las tarjetas de crédito basado en si las últimas tres transacciones fueron declinadas y genera la siguiente consulta:

-- Crear una tabla temporal para almacenar las filas con el número de transacción
CREATE TEMPORARY TABLE TempTransacciones AS
SELECT 
    card_id, 
    declined, 
    @row_num := IF(@prev_card_id = card_id, @row_num + 1, 1) AS Rank_Transaccion,
    @prev_card_id := card_id
FROM 
    (SELECT @row_num := 0, @prev_card_id := NULL) AS vars,
    (SELECT card_id, declined 
     FROM transactions 
     ORDER BY card_id, timestamp DESC) AS T;

-- Crear la tabla card_status usando los datos de la tabla temporal
CREATE TABLE card_status AS
SELECT
    card_id,
    CASE
        WHEN COUNT(*) < 3 THEN 'Activa'
        WHEN SUM(declined) = 3 THEN 'Inactiva'
        ELSE 'Activa'
    END AS status
FROM TempTransacciones
WHERE Rank_Transaccion <= 3
GROUP BY card_id;

CREATE INDEX idx_card_id ON transactions(card_id);
ALTER TABLE card_status
ADD INDEX idx_card_id (card_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_card_id
FOREIGN KEY (card_id)
REFERENCES card_status(card_id);

-- ¿Cuántas están activas?

SELECT COUNT(*) AS cantidad_activas
FROM card_status
WHERE status = 'Activa';