USE transactions;
-- id, iban, pan, pin, cvv, expiring_date
-- SPRINT 3
-- Nivel 1. Ejercicio 1.
CREATE table credit_card 
(id VARCHAR (100),
iban VARCHAR (100),
pan VARCHAR (100),
pin VARCHAR (100),
cvv VARCHAR (100),
expiring_date VARCHAR (100));
 -- Añadimos Primary Key
 ALTER table credit_card 
 ADD PRIMARY KEY(id);
 -- hago esta query para visualizar los resultados de la tabla credit_card
 SELECT *
 FROM credit_card;
 -- establecemos conexión entre tablas
 ALTER TABLE transaction
 ADD CONSTRAINT creditcard 
 FOREIGN KEY (credit_card_id)
 REFERENCES credit_card(id);
 
 
 SHOW tables;
 SHOW columns from credit_card;
 SHOW create table credit_card;
 
-- Nivel 1. Ejercicio 2. El departamento de Recursos Humanos ha identificado un error en el número de cuenta del usuario con ID CcU-2938. La información que tiene que mostrarse para este registro es: R323456312213576817699999. Recuerda mostrar que el cambio se realizó.
-- buscamos el id del usuario
SELECT*
FROM transactions.credit_card
WHERE id = 'CcU-2938';
-- realizamos el cambio
UPDATE transactions.credit_card
SET iban = 'R323456312213576817699999'
WHERE id = 'CcU-2938';
-- volvemos a buscar el id del usuario para ver que se hayan llevado a cabo los cambios
SELECT*
FROM transactions.credit_card
WHERE id = 'CcU-2938';

-- Nivel 1. Ejercicio 3. En la tabla  "transaction" ingresa un nuevo usuario con la siguiente información:

-- Antes de nada se debe insertar el nuevo registro en las  tablas company y credit_card. 
INSERT  INTO transactions.company (id)
VALUES ('b-9999');

INSERT INTO transactions.credit_card (id)
VALUES ('CcU-9999');

-- Ahora ya podemos crear el nuevo usuario en transaction
INSERT INTO transactions.transaction(id,credit_card_id,company_id, user_id, lat, longitude, timestamp, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', now(), '111.11', '0');
-- Nos aseguramos de que se ha registrado correctamente
SELECT * FROM transaction
WHERE id = "108B1D1D-5B23-A76C-55EF-C568E49A99DD";

-- Nivel 1. Ejercicio 4. Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_*card. Recuerda mostrar el cambio realizado.
SELECT *
FROM transactions.credit_card;

ALTER TABLE credit_card
DROP COLUMN pan;

SELECT *
FROM transactions.credit_card;

-- Nivel 2. Ejercicio 1. Elimina de la tabla transaction el registro con ID 02C6201E-D90A-1859-B4EE-*88D2986D3B02 de la base de datos.
SELECT *
FROM transactions.transaction
WHERE id='02C6201E-D90A-1859-B4EE-88D2986D3B02';

DELETE
FROM transactions.transaction
WHERE id='02C6201E-D90A-1859-B4EE-88D2986D3B02';

SELECT *
FROM transactions.transaction
WHERE id='02C6201E-D90A-1859-B4EE-88D2986D3B02';

-- Nivel 2. realizar análisis y estrategias efectivas. Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente información: Nombre de la compañía. Teléfono de contacto. País de residencia. Media de compra realizado por cada compañía. Presenta la vista creada, ordenando los datos de mayor a menor media de compra.
CREATE VIEW VistaMarketing AS
  SELECT company.company_name, company.phone, company.country, ROUND(AVG(transaction.amount), 2) AS media
  FROM transactions.company
  JOIN transactions.transaction ON company.id = transaction.company_id
  WHERE transaction.declined = 0
  GROUP BY company.company_name, company.phone, company.country;
  
SELECT *
FROM vistaMarketing
ORDER BY media DESC;

-- Nivel 2. Ejercicio 3. Filtra la vista VistaMarketing para mostrar solo las compañías que tienen su país de residencia en "Germany".
SELECT * 
FROM transactions.vistaMarketing 
WHERE country = 'Germany';
