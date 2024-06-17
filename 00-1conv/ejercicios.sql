/*
* Modificación de información 
*/
UPDATE DISPONE 
SET num_ejemplares=num_ejemplares+3 AND num_disponibles=num_disponibles+3
WHERE ISBN=5025496 AND cod_sucursal=9;


UPDATE LECTOR 
SET Direccion = 'C/Sevilla,1' AND Poblacion='Aldeadávila' AND Provincia='Salamanca' WHERE Cod_Lector=7395860;


UPDATE SUCURSAL 
SET Poblacion='Segovia' AND Provincia='Segovia'  AND Direccion='C/San Agustin, 10' 
WHERE cod_sucursal=15;


UPDATE LECTOR 
SET Direccion = 'Av.Alemania,49' AND Poblacion='Miajadas' AND Provincia='Cáceres' WHERE Cod_Lector=71259836;


INSERT INTO AUTOR(Codigo, Nombre,Apellido,Ano_Nac,Cod_Nacionalidad) VALUES(999,'Javier','Moro',1955,(Select Codigo FROM NACIONALIDAD WHERE Nombre='España'));
INSERT INTO LIBRO(ISBN,Titulo,Ano_Edicion,Cod_Editorial) VALUES (8408104829,'EL PREMIO ERES TU',2001,(Select Codigo FROM EDITORIAL WHERE Nombre='Planeta'));
INSERT INTO ESCRIBE(Cod_Autor,ISBN) VALUES(999,8408104829);
INSERT INTO DISPONE(ISBN,Cod_Sucursal,Num_Ejemplares,Num_Disponibles) VALUES(8408104829,1,1,1);
INSERT INTO DISPONE(ISBN,Cod_Sucursal,Num_Ejemplares,Num_Disponibles) VALUES(8408104829,2,1,1);
/*-...-*/
INSERT INTO DISPONE(ISBN,Cod_Sucursal,Num_Ejemplares,Num_Disponibles) VALUES(8408104829,14,1,1);
INSERT INTO DISPONE(ISBN,Cod_Sucursal,Num_Ejemplares,Num_Disponibles) VALUES(8408104829,15,1,1);


INSERT INTO SUCURSAL(Cod_Sucursal,Direccion,Poblacion,Provincia) VALUES(16,'Calle de los Caballeros,32','Soria','Soria');


INSERT INTO DISPONE(Cod_Sucursal,ISBN,Num_Ejemplares,Num_Disponibles) Select 16,ISBN, num_ejemplares,num_ejemplares FROM DISPONE WHERE Cod_Sucursal=2;


DELETE FROM PRESTAMO WHERE Cod_Lector=Select Cod_Lector FROM LECTOR WHERE NOMBRE='Francisco' AND Apellido1='Roldan';
DELETE FROM LECTOR WHERE NOMBRE='Francisco' AND Apellido1='Roldan';


UPDATE DISPONE SET num_ejemplares=num_ejemplares+1, num_disponibles=num_disponibles+1 WHERE ISBN IN (Select ISBN FROM PRESTAMO GROUP BY ISBN HAVING COUNT(*)= (Select MAX(COUNT(*)) FROM PRESTAMO GROUP BY ISBN));


UPDATE DISPONE SET num_ejemplares=num_ejemplares+1 AND num_disponible=num_disponible+1 WHERE ISBN IN (SELECT ISBN FROM PRESTAMO GROUP BY ISBN,COD_SUC HAVING COUNT(*)>4);


/*
* INDEX VIEW SYNOMYM SEQUENCE
*/
CREATE INDEX index_provincia ON LECTOR(Provincia);


CREATE VIEW viewprestamosactivos AS SELECT * FROM PRESTAMO WHERE Fecha_Devolucion IS NULL;


CREATE VIEW viewprestados AS SELECT DISTINCT ISBN, l.Titulo FROM prestamo p, libro l WHERE p.ISBN=l.ISBN AND p.Fecha_Devolucion IS NULL;


CREATE VIEW viewfondosucursal3 AS SELECT d.ISBN, l.Titulo, d.Num_Ejemplares, d.Num_Disponibles FROM DISPONE d, LIBRO l WHERE d.ISBN=l.ISBN AND d.Cod_Sucursal=3;


CREATE VIEW viewprestamosacabadossuc1 AS SELECT * FROM PRESTAMO WHERE Cod_Sucursal=1 AND Fecha_Devolucion IS NOT NULL;


DROP VIEW prestamosfinsuc1;

CREATE VIEW prestamofin1 AS
SELECT * FROM prestamo
WHERE fecha_dev IS NOT NULL AND cod_suc=1
WITH READ ONLY;

DELETE FROM prestamofin1 WHERE fecha_dev < SYSDATE - 365*5;


CREATE SYNOMYM DIPONE2 FOR DISPONE;


CREATE TABLE SUCURSAL2 AS SELECT * FROM SUCURSAL;
ALTER TABLE SUCURSAL2 ADD NombreSuc VARCHAR(20);


CREATE SEQUENCE SEQAUTORESP;
CREATE TABLE AUTORESP (
	CODAUTORESP INTEGER PRIMARY KEY,
	NOMBRE VARCHAR(20),
	APELLIDO VARCHAR(20)
);
INSERT INTO AUTORESP 
SELECT SEQAUTORESP.NEXTVAL, NOMBRE, APELLIDO FROM AUTOR WHERE cod_nacion=(SELECT CODIGO FROM NACIONALIDAD WHERE NOMBRE='España');


CREATE SEQUENCE SEQANUNCIO;
GRANT ALL ON SEQ_ANUNCIO TO PUBLIC;
CREATE TABLE ANUNCIO (
	CODIGO INTEGER PRIMARY KEY,
	AUTOR VARCHAR(20) DEFAULT USER,
	TEXTO VARCHAR(200)
);
GRANT ALL ON ANUNCIO TO PUBLIC;
INSERT INTO ANUNCIO (Codigo,texto) VALUES (SEQ_ANUNCIO.NEXTVAL, 'Anuncio1');
INSERT INTO ANUNCIO (Codigo,texto) VALUES (SEQ_ANUNCIO.NEXTVAL, 'Anuncio2');


CREATE VIEW VIEWMISANUNCIOS AS SELECT * FROM ANUNCIO WHERE AUTOR=USER;
GRANT ALL ON VIEWMISANUNCIOS TO USER;
/*GRAND SELECT ON MISANUNCIOS TO PUBLIC;*/
