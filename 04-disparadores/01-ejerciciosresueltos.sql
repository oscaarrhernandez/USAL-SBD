/*
1. Se desea llevar un control de las actualizaciones que se realizan sobre una base de
datos que está compuesta por las siguientes tablas:
    PROYECTO (COD_PROY, NOMBRE, PRESUPUESTO)
    DEPARTAMENTO (COD_DPTO, NOMBRE, DIRECCION, NUM_EMPLEADOS)
Para ello, se crea una tabla donde se registrará cada acción que se realice sobre las
tablas anteriores. Dicha tabla tendrá el siguiente esquema:
    REGISTRO (ID, FECHA, USUARIO, TABLA, COD_ITEM, ACCION)
En la tabla REGISTRO se incluirá una tupla por cada acción que se realice en las
tablas anteriores y que contendrá los siguientes atributos:
    - ID. Será la clave de la tabla registro y se gestionará automáticamente mediante
    un disparador que obtenga el valor correspondiente a partir de una secuencia.
    - Fecha en la que se ha realizado la modificación
    - Usuario que ha realizado la acción
    - Nombre de la tabla modificada (PROYECTO o DEPARTAMENTO)
    - Clave de la tupla insertada, cambiada o borrada
    - Acción que se ha realizado (INSERT, UPDATE o DELETE)
        a) Crear las tres tablas indicadas y los disparadores necesarios para registrar los
        datos de modificación de las tablas.
        b) Insertar, modificar y borrar varias tuplas en las tablas PROYECTO y
        DEPARTAMENTO y consultar el contenido de la tabla REGISTRO para
        comprobar que los disparadores han funcionado correctamente.
*/
CREATE TABLE PROYECTO (
	COD_PROY INTEGER PRIMARY KEY,
	NOMBRE VARCHAR(20),
	PRESUPUESTO DECIMAL(8,2)
);
CREATE TABLE DEPARTAMENTO (
	COD_DPTO INTEGER PRIMARY KEY,
	NOMBRE VARCHAR(20),
	DIRECCION VARCHAR(50),
	NUM_EMPLEADOS INTEGER
);
CREATE REGISTRO (
	ID INTEGER PRIMARY KEY,
	FECHA DATE DEFAULT SYSDATE,
	USUARIO VARCHAR(20),
	TABLA VARCHAR(20) CHECK (TABLA='PROYECTO' OR TABLA='DEPARTAMENTO'),
	COD_ITEM INTEGER,
	ACCION VARCHAR(6) CHECK (ACCION = 'INSERT' OR ACCION = 'UPDATE' OR ACCION = 'DELETE')
);
CREATE SEQUENCE clave_reg;
CREATE OR REPLACE TRIGGER clave_reg
 BEFORE INSERT ON REGISTRO
 FOR EACH ROW 
 BEGIN
 SELECT clave_reg.NEXTVAL INTO :NEW.ID FROM DUAL;
 END;
/
CREATE OR REPLACE TRIGGER ins_proy
 AFTER INSERT ON PROYECTO
 FOR EACH ROW 
 BEGIN
 INSERT INTO REGISTRO (USUARIO, TABLA, COD_ITEM, ACCION) VALUES (USER, 'PROYECTO', :NEW.COD_PROY, 'INSERT');
 END;
/
CREATE OR REPLACE TRIGGER ins_dep
 AFTER INSERT ON DEPARTAMENTO
 FOR EACH ROW
 BEGIN
 INSERT INTO REGISTRO (USUARIO, TABLA, COD_ITEM, ACCION) VALUES ( USER, 'DEPARTAMENTO', :NEW.COD_PROY, 'INSERT');
 END;
/
CREATE OR REPLACE TRIGGER up_proy
 AFTER UPDATE ON PROYECTO
 FOR EACH ROW 
 BEGIN
 INSERT INTO REGISTRO (USUARIO, TABLA, COD_ITEM, ACCION) VALUES (USER, 'PROYECTO', :NEW.COD_PROY, 'UPDATE');
 END;
/
CREATE OR REPLACE TRIGGER up_dep
 AFTER UPDATE ON DEPARTAMENTO
 FOR EACH ROW
 BEGIN
 INSERT INTO REGISTRO (USUARIO, TABLA, COD_ITEM, ACCION) VALUES (USER, 'DEPARTAMENTO', :NEW.COD_PROY, 'UPDATE');
 END;
/
CREATE OR REPLACE TRIGGER del_proy
 AFTER DELETE ON PROYECTO
 FOR EACH ROW
 INSERT INTO REGISTRO (USUARIO, TABLA, COD_ITEM, ACCION) VALUES (USER, 'PROYECTO', :NEW.COD_PROY, 'DELETE');
 END;
/
CREATE OR REPLACE TRIGGER del_dep
 AFTER DELETE ON DEPARTAMENTO
 FOR EACH ROW
 INSERT INTO REGISTRO (USUARIO, TABLA, COD_ITEM, ACCION) VALUES (USER, 'DEPARTAMENTO', :NEW.COD_PROY, 'DELETE');
 END;
/

/*
Hacer IMPORT, UPDATE Y DELETE para comprobar el funcionamiento de los TRIGGERS
*/
/*
2. Crear una nueva tabla EMPLEADO (DNI, NOMBRE, APELLIDO, COD_DEPTO).
Crear los disparadores precisos para que el atributo derivado NUM_EMPLEADOS
de la tabla DEPARTAMENTO se mantenga consistente con el contenido de la tabla
EMPLEADOS de modo automático. Comprobar el funcionamiento de los
disparadores en los siguientes casos:
    - Se insertan varios empleados en distintos departamentos
    - Se cambia el departamento al que está asignado un empleado
    - Se elimina un usuario
    - Se eliminan varios usuarios
    - Se inserta un empleado sin departamentos asignado y posteriormente se
    modifica para asignarlo a un departamento existente
    - Se modifica un empleado asignado a un departamento para que deje de estar
    asignado a ninguno
*/
CREATE TABLE EMPLEADO (
 DNI VARCHAR(9) PRIMARY KEY,
 NOMBRE VARCHAR(10),
 APELLIDO VARCHAR(15),
 COD_DEPTO INTEGER REFERENCES DEPARTAMENTO
);
CREATE OR REPLACE TRIGGER EMPLEADO_INS
 AFTER INSERT ON EMPLEADO
 FOR EACH ROW
 WHEN (new.COD_DPTO IS NOT NULL)
 BEGIN
 UPDATE DEPARTAMENTO SET NUM_EMPLEADOS = NUM_EMPLEADOS + 1
  WHERE COD_DPTO = :new.COD_DEPTO;
 END;
/
CREATE OR REPLACE TRIGGER EMPLEADO_DEL
 AFTER DELETE ON EMPLEADO
 FOR EACH ROW 
 WHEN (new.COD_DPTO IS NOT NULL)
 BEGIN
 UPDATE DEPARTAMENTO SET NUM_EMPLEADOS = NUM_EMPLEADOS - 1
  WHERE COD_DPTO = :OLD.COD_DEPTO;
 END:
/
CREATE OR REPLACE TRIGGER EMPLEADO_UPD
 AFTER UPDATE ON EMPLEADO
 FOR EACH ROW
 WHEN (new.COD_DPTO IS NOT NULL)
 BEGIN
 UPDATE DEPARTAMENTO SET NUM_EMPLEADOS = NUM_EMPLEADOS + 1
  WHERE COD_DPTO = :NEW.COD_DEPTO;
 UPDATE DEPARTAMENTO SET NUM_EMPLEADOS = NUM_EMPLEADOS - 1
  WHERE COD_DPTO = :OLD.COD_DEPTO;
 END;
/

/*
3. Crear dos tablas con los mismos esquemas de las tablas DISPONE y la tabla
PRESTAMO de la base de datos usada en las prácticas (no es necesario definir en
ellas las claves externas correspondientes al resto de las tablas de la base de datos
de prácticas). Crear los disparadores necesarios para que el atributo derivado
NUM_DISPONIBLES de la tabla creada a imagen de DISPONE se mantenga
consistente de manera automática.
Se desea impedir que en la tabla creada a imagen de PRESTAMO se realicen
modificaciones sobre las columnas ISBN o COD_SUC. Crear un disparador que
garantice que no se producirán modificaciones de este tipo.
*/
CREATE TABLE MI_DISPONE (
 Cod_Suc INTEGER NOT NULL,
 ISBN INTEGER NOT NULL,
 Num_Ejemplares INTEGER NOT NULL,
 Num_Disponibles INTEGER NOT NULL,
 PRIMARY KEY(Cod_Suc,ISBN),
 CHECK (Num_Disponibles <= Num_Ejemplares AND Num_Disponibles >= 0 AND Num_Ejemplares >= 0)
);
CREATE TABLE MI_PRESTAMO (
 Codigo INTEGER NOT NULL PRIMARY KEY,
 Cod_Lector INTEGER NOT NULL,
 ISBN INTEGER NOT NULL,
 Cod_Suc INTEGER NOT NULL,
 Fecha_Ini DATE NOT NULL DEFAULT SYSDATE,
 Fecha_Dev DATE,
 FOREIGN KEY (ISBN,Cod_Suc) REFERENCES MI_DISPONE (ISBN,Cod_Suc)
);
CREATE TRIGGER INS_PRESTAMO
 AFTER INSERT ON MI_PRESTAMO 
 FOR EACH ROW 
 WHEN (NEW.FECHA_DEV IS NULL)
 BEGIN 
 UPDATE MI_DISPONE SET NUM_DISPONIBLES=NUM_DISPONIBLES-1
  WHERE ISBN=NEW.ISBN AND COD_SUC=NEW.COD_SUC;
 END;
/
CREATE TRIGGER DEL_PRESTAMO
 AFTER DELETE ON MI_PRESTAMO 
 FOR EACH ROW 
 WHEN (OLD.FECHA_DEV IS NULL)
 BEGIN 
 UPDATE MI_DISPONE SET NUM_DISPONIBLES=NUM_DISPONIBLES-1
  WHERE ISBN=OLD.ISBN AND COD_SUC=OLD.COD_SUC;
 END;
/
CREATE TRIGGER UPD_PRESTAMO
 AFTER UPDATE OF COD_SUC, ISB ON MI_PRESTAMO
 FOR EACH ROW
 BEGIN 
 raise_application_error(-20000, 'OPERACION NO PERMITIDA');
 END;
/
CREATE TRIGGER UPD_FDEV_PRESTAMO
 AFTER UPDATE OF FECHA_DEV ON MI_PRESTAMO
 FOR EACH ROW
 WHEN (OLD.FECHA_DEV IS NULL AND NEW.FECHA_DEV IS NOT NULL)
 BEGIN
 UPDATE MI_DISPONE SET NUM_DISPONIBLES=NUM_DISPONIBLES+1
  WHERE ISBN=OLD.ISBN AND COD_SUC=OLD.COD_SUC;
 END;
/
/*
4. La biblioteca desea incentivar los hábitos de lectura de sus socios estableciendo una
clasificación de los mismos en función del número de prestamos que han realizado.
Solo se incluirán en la clasificación aquellos lectores que hayan realizado como
mínimo 10 préstamos. En el caso de que varios lectores coincidan con el mismo nº
de prestamos, se les asignarán números consecutivos en la clasificación sin importar
el criterio. Para ello, se desea crear una tabla que contenga las siguientes columnas:
nº de orden en la clasificación a fecha de hoy, código del lector y nº de prestamos
realizados.
    a. Crear la tabla anterior tomando como clave primaria el nº de orden en la
    clasificación.
    b. Crear una secuencia que se utilizará para obtener los valores de la clave
    primaria de la tabla anterior.
    c. Crear un trigger que genere de forma automática durante la inserción los
    valores para la clave de la tabla.
    d. Rellenar la tabla con los valores correspondientes a partir del contenido
    de la Base de Datos en el momento actual.
*/

CREATE TABLE clasificación (
 ORDENCLASI INTEGER NOT NULL PRIMARY KEY,
 COD_LECTOR INTEGER NOT NULL,
 NUMEROPRESTAMOS INTEGER NOT NULL CHECK(NUMEROPRESTAMOS>=10),
 FOREIGN KEY COD_LECTOR REFERENCES LECTOR(CODIGO)
);

CREATE SEQUENCE SEQORDCLASI;
CREATE TRIGGER INS_CLASIFICACION
 BEFORE INSERT ON clasificación
 FOR EACH ROW
 BEGIN
 SELECT SEQORDCLASI.NEXTVAL INTO :NEW.ORDENCLASI FROM DUAL;
 END;
/
INSERT INTO clasificación(COD_LECTOR,NUMEROPRESTAMOS)
 SELECT COD_LECTOR, COUNT(*) FROM PRESTAMO GROUP BY COD_LECTOR
  HAVING COUNT(*)>=10 ORDER BY 2 DESC;

