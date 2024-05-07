# Sistemas de Bases de Datos PRACTICAS

2023-2024

## Indice

[Sesión 1 Creación de informes](#sesión-1-creación-de-informes)

[Sesión 2 Modificar Información](#sesión-2-modificar-información)

[Sesión 3 Administración](#sesión-3-administración)

[Sesión 4 Disparadores](#sesión-4-disparadores)

[Sesión 5 PL/SQL](#sesión-5-plsql)

## Sesión 1: Creación de informes

### Creación de informes

Para mandar el resultado de la(s) próxima(s) consulta(s) a un fichero

```sql
spool <fichero_salida>;
```

Para cerrar el fichero de salida

```sql
spool off;
```

#### Formateo de la salida

**Ancho de página**: número máximo de caracteres por línea. 80 <= x >= 132

```sql
set linesize <tamaño>
show linesize
```

**Longitud de la página**: número de filas de salida. 55 <= x >= 60

```sql
set pagesize <tamaño>
show pagesize
```

**Titulo a una página**: imprimir los informes con título. El título sale centrado. Se usa `|` para que el título aparezca en dos líneas. También se muestra la fecha y el número de página.

```sql
ttitle‘texto del título | siguiente línea del título’
ttitle off
```

**Pie de página**: centra el pie de página especificado. Si lo queremos a la izquierda o derecho se añade `left` o `right`

```sql
btitle 'pie de pagina'
```

### Sesión 1: Ejercicio Ejemplo

```sql
set pagesize 100
set linesize 150
spool s1e6
ttitle 'Libros en una sucursal &1 ordenados por ISBN'
select d.ISBN, l.Titulo FROM dispone d, libro l where d.isbn=l.isbn AND d.cod_suc=&1 ORDER BY 1;
ttitle off
spool off;
```

## Sesión 2: Modificar Información

### Actualizacion (UPDATE)

```sql
UPDATE tabla
SET columna = expresión {, columna = expresión}
[WHERE condición];
```

Si omitimos la cláusula ***where*** se modificarán todas las filas de la tabla.

#### Sesión 2: Ejemplo Actualizacion

Incrementar en 2 unidades disponibles por sucursal los libros de Mario Vargas Llosa

```sql
UPDATE dispone
SET num_ejemplares= num_ejemplares+2,
num_disponibles= num_disponibles+2
WHERE ISBN IN(select ISBN from escribe where
cod_autor=(select codigo from autor where
nombre=’MARIO’ and apellido=‘VARGAS LLOSA’));
```

### Inserción de una fila (INSERT INTO)

```sql
INSERT INTO tabla [(lista_columnas)]
VALUES (lista_valores);
```

**Si la tabla está relacionada con otra*, se seguirán las **reglas de integridad referencial**.

#### Sesión 2: Ejemplo INSERT

La biblioteca ha comprado 10 ejemplares del nuevo libro de Gabriel García Márquez titulado 'Yo no vengo a decir un discurso' con ISBN 9789588640051 de la editorial Milenio y desea tenerlo disponible en la sucursal 5. Ya se tienen otros títulos de dicho autor.

```sql
INSERT INTO editorial VALUES (11, ' Milenio ');
INSERT INTO libro VALUES (‘9789588640051’, ' Yo no vengo a decir un discurso ', 2009, 11);
INSERT INTO dispone VALUES (5, ‘9789588640051’, 5, 5);
INSERT INTO escribe VALUES (42, ‘9789588640051’);
```

### Inserción de varias filas (INSERT INTO)

```sql
INSERT INTO tabla [(lista_columnas)] subselect;
```

#### Sesión 2: Ejemplo INSERT varias filas

Para la nueva sucursal 16 se ha comprado el mismo fondo de préstamo que el que tiene la sucursal 5. Dar de alta todos estos libros en dicha sucursal 16.

```sql
INSERT INTO dispone
SELECT s.codigo, ISBN, num_ejemplares,
num_dispone FROM sucursal s, dispone d
WHERE s.codigo = 16 and d.cod_suc = 5;
```

Este codigo es igual a:

```sql
INSERT INTO dispone
SELECT 16, ISBN, num_ejemplares, num_dispone from dispone d 
where d.cod_suc = 5;
```

### Eliminación (DELETE FROM)

```sql
DELETE FROM tabla
[WHERE condicion];
```

Si se omite la cláusula ***where*** se modificarán todas las filas de la tabla.

#### Sesión 2: Ejemplo DELETE

Se desea eliminar el préstamo cuyo códgo de préstamo es 9038 del lector con código 7334556.

```sql
DELETE FROM prestamo
WHERE codigo = '9038' and cod_lector = '7334556';
```

## Sesión 3: Administración

### Indices (INDEX)

Un índice es una estructura asociada con una tabla o una vista que acelera la recuperación de filas de la tabla o de la vista.

```sql
CREATE [UNIQUE] INDEX nombre_indice
ON tabla(columna{,columna});
```

**UNIQUE** indica que no se aceptarán valores duplicados en el conjunto de las columnas que forman el índice.

#### Sesión 3: Ejemplo INDEX

Crea un indice que permita acceder al nombre completo del lector(nombre, apellido1, apellido2).

```sql
CREATE INDEX apellidos_nombre
ON lector (ape_1,ape_2,nombre);
```

### Vistas (VIEW)

Define una tabla virtual cuyo contenido será el resultado de la ejecución de la sentencia *SELECT*.
La vista puede ser utilizada como tabla en las posteriores consultas.

```sql
CREATE VIEW nombre_vista[(columna {,columna})]
AS sentencia_select
[WITH CHECK OPTION]
[WITH READ ONLY];
```

Si se usa la cláusula *WITH CHECK OPTION* no se permitirá que mediante un *insert* o *update* se cree una fila que no cumpla las condiciones de la vista.
Si se incluye la cláusula *WITH READ ONLY* no podrán ejecutarse operaciones *insert/delete/update* sobre la vista.

**Condiciones para la actualización de los datos a través de vista:**
* La *select* sólo recupera filas de una única tabla (hay una única tabla base)
* Todas las columnas seleccionadas se corresponden con columnas de la tabla base (no se utilizan funciones)
* La select no incluye *distinct,group by* ni *having*
* La insercción sólo será posible si todas las columnas con *not null not default* de la tabla original se recuperan en la *select*.

#### Sesión 3: Ejemplo Vista

Crea una vista que muestre los lectores de la provincia de ZAMORA.

```sql
CREATE VIEW lector_za
AS select * from lector where provincia = 'ZAMORA'
with check option;
```

### Sinónimos (SYNONYM)

Crea un sinónimo para una tabla, vista o índice.

Un sinónimo es un alias, un nombre alternativo para un objeto.

```sql
CREATE SYNONYM nombre_sinonimo
FOR tabla|vista|indice;
```

#### Sesión 3: Ejemplo Sinónimo

Crea un sinónimo para la tabla lector.

```sql
CREATE SUNONYM usuario
FOR lector;
```

### Secuencias (SEQUENCE)

Una secuencia es un mecanismo para obtener listas de números secuenciales.

Se pueden utilizar para obtener valores que se usen como claves primarias.

```sql
CREATE SEQUENCE nombre_secuencia
[INCREMENT BY incremento] [START WITH inicio];
```

`CURRVAL` y `NEXTVAL` son pseudocolumnas de las secuencias:

* `nombre_secuencia.CURRVAL` : devuelve el valor actual de la secuencia.
* `nombre_secuencia.NEXTVAL` : calcula y devuelve el siguiente valor de la secuencia.

#### Sesión 3: Ejemplo Secuencia

Crea una tabla donde la primary key sea una secuencia e inserte dos elementos a la tabla.

```sql
CREATE TABLE mitabla (
 codigo INTEGER NOT NULL PRIMARY KEY,
 otro INTEGER
);

CREATE SEQUENCE clave_mitabla;

INSERT INTO mitabla
VALUES (clave_mitabla.nextval, 100);
INSERT INTO mitabla
VALUES (clave_mitabla.nextval, 33);
```

### Eliminación (DROP)

Se utiliza para eliminar objetos de la base de datos, como tablas, vistas, índices, procedimientos almacenados, y otros elementos.

```sql
DROP [TABLE|VIEW|INDEX|SYNONYM|SEQUENCE] nombre_objeto;
```

#### Sesión 3: Ejemplo Eliminación

```sql
DROP INDEX apellidos_nombre;
```

```sql
DROP VIEW lector_zam;
```

```sql
DROP SYNONYM usuario;
```

```sql
DROP SEQUENCE clave_mitabla;
```

### Concesión de privilegios (GRANT)

Al crear una tabla o vista, el propietario es el único que puede acceder a ella hasta que este no les conceda los privilegios de acceso, estos privilegios pueden ser: `SELECT`, `UPDATE`, `DELETE`, `INSERT`, `INDEX`, `REFERENCES`, `ALTER`, `ALL`

```sql
GRANT [ALL PRIVILEGES]|privilegio1,privilegio2,...
ON nombre_objeto
TO PUBLIC|user1,user2,....
[WITH GRANT OPTION];
```

`WITH GRANT OPTION` hace referencia a la capacidad de conceder los mismos privilegios a otras personas.

#### Revocar privilegios

```sql
REVOKE (ALL PRIVILEGES) / privilegio1, privilegio2...
ON nombre_tabla / nombre_view... 
FROM PUBLIC / usuario1, usuario2...
```

La sintaxis de revocar privilegios también tiene la capacidad para rescindir privilegios en columnas individuales de tabla.

```sql
REVOKE { INSERT | UPDATE | REFERENCES } [, ...] [ (
columna [, ...] ) ] ON objeto FROM { PUBLIC | nombre_usuario
[, ...] }
```

### Modificación de definición de tablas (ALTER TABLE)

Permite añadir o eliminar columnas y condiciones de integridad a tablas ya creadas.

```sql
ALTER TABLE tabla
ADD [CONSTRAINT nombre] restricción_tabla
| DROP CONSTRAINT nombre
| ADD especificación_columna
| DROP COLUMN columna [CASCADE CONSTRAINT ] ;
```

`CASCADE CONSTRAINT` se utiliza para especificar que se deben eliminar las restricciones (constraints) referentes a una columna específica y que todas las restricciones que dependen de esa columna también deben eliminarse

## Sesión 4: Disparadores

Un disparador define una acción que se ejecuta cuando ocurre un cierto evento en la base de datos:

* modificación de datos (`INSERT`,`UPDATE` o `DELETE`)
* modificación del esquema
* eventos del sistema (`user logon/logoff`)

Para crear un disparador sobre una tabla son necesarios privilegios de modificación sobre dicha tabla y creación de disparadores.

Los disparadores pueden referenciar tablas distintas de aquellas cuyas modificaciones disparan el trigger.

```sql
CREATE [OR REPLACE] TRIGGER <trigger_name>
 {BEFORE|AFTER|INSTEAD OF}
 {INSERT|DELETE|UPDATE [OF <column>[,<column>]...]}
 ON{<table>|<view>}
 [REFERENCING {OLD AS <old_name>|NEW AS <new_name>...}]
 [FOR EACH ROW | STATEMENT]
 [WHEN (<trigger_condition>)]

BEGIN
   ......
END;
```

### Tipos de Disparadores

#### Tipo de operación

```sql
{INSERT|DELETE|UPDATE [OF <column>[,<column>]...]}
ON {<table>|<view>}
```

La sentencia activadora especifica el tipo de operación que despierta el disparador `DELETE`,`INSERT` o `UPDATE`. Una, dos o incluso las tres pueden estar incluidas en la especificación de la sentencia activadora.

```sql
INSERT OR DELETE OR UPDATE OF salario ON empleado
```

Si la sentencia activadora especifica un `UPDATE` se puede incluir una lista de columnas en dicha sentencia.

En la sentencia activadora se especifica la tabla asociada al disparador.

#### Momento de ejecución

```sql
{BEFORE|AFTER|INSTEAD OF}
```

Dependiendo del momento de ejecución del disparador, este puede ser:

* `BEFORE`: se ejecutan inmediatamente antes de la acción que los dispara.
* `AFTER`: se ejecutan inmediatamente después de la acción que los dispara.
* `INSTEAD OF`: se ejecutan en vez del evento que los dispara. SOLO SE PUEDE APLICAR A VISTAS.

#### Nivel de ejecución

```sql
[FOR EACH ROW | STATEMENT]
```

En función del nivel en que se ejecuta el dispardor, este se clasifica en:

* ROW-LEVEL: a nivel de fila (row trigger)
  * Si está presente **FOR EACH ROW** el cuerpo del trigger se ejecuta individualmente para cada una de las filas de la tabla que haya sido afectada por la sentencia activadora.
  * La asusencia de la opción FOR EACH ROW implica que el trigger se ejecuta una sola vez, para la ejecución de una sentencia activadora.
  * Se pueden incluir restricciones en la definición de un trigger. Para ello hacemos uso de la cláusula `WHEN`, una expresión que es una condición adicional que debe comprobarse antes de disparar el trigger (no puede incluir subqueries).

* STATEMENT-LEVEL: a nivel de sentencia activadora (statement trigger)
  * El trigger se ejecuta una sola vez.
  * Se utiliza para reforzar la seguridad sobre tipos de transacciones permitidos en las tablas.

### Variables Especiales

```sql
[ REFERENCING { OLD AS <old_name> | NEW AS <new_name> ...}]
```

Las variables NEW y OLD están siempre disponibles para referirse a la nueva (después de la transacción) y vieja (previa a la transacción) tupla respectivamente.

**En el cuerpo del trigger deben de ir precedidas por dos puntos. Sin embargo en la clausula WHEN no es así.**

### Diseño de Disparadores

1. SENTENCIA DISPARADORA.
2. ANTES O DESPUÉS.
3. PARA TODAS/PARA EL BLOQUE.
4. CONDICIÓN(WHEN).
5. ACCIÓN.

### Ejemplo

Prestatario(<u>ci</u>, nombre, dir, tel, empresa, tel_ofic)
Préstamo (<u>num_prest</u>, ci, tasa, monto)
Cuota (<u>num_prest, num_cuota</u>, f_venc, f_pago)

<u>Prestatario</u> : almacena todos los prestatarios actuales del banco.
<u>Préstamo</u> : almacena todos los préstamos que aún no han sido cancelados. El atributo ci referencia a Prestatario y es candidato a clave pues el banco no otorga simultáneamente dos préstamos a la misma persona.
<u>Cuota</u> : almacena todas las cuotas de los préstamos actuales (tanto las pagadas como las pendientes). El atributo num_prest referencia a Préstamo. Se tiene como política que toda cuota debe ser pagada antes de su fecha de vencimiento.

```sql
CREATE TABLE Prestatario (
 ci VARCHAR(8) NOT NULL PRIMARY KEY,
 nombre VARCHAR(50) NOT NULL,
 dir VARCHAR(100) NOT NULL,
 tel VARCHAR(10) NOT NULL,
 empresa VARCHAR(100) NOT NULL,
 tel_ofic VARCHAR(10) NOT NULL
);

CREATE TABLE Prestamo (
 num_prest NUMBER NOT NULL PRIMARY KEY,
 ci VARCHAR(8) UNIQUE REFERENCES Prestatario(ci),
 tasa NUMBER(4,2) NOT NULL,
 monto NUMBER(8) NOT NULL CHECK(monto > 0)
);

CREATE TABLE Cuota (
 num_prest NUMBER(5) NOT NULL,
 num_cuota NUMBER(2) NOT NULL,
 f_venc DATE NOT NULL,
 f_pago DATE,
 CONSTRAINT pk_cuota
 PRIMARY KEY (num_prest, num_cuota),
 CONSTRAINT fk_cuota_prest FOREIGN KEY (num_prest) REFERENCES Prestamo(num_prest)
);
```

#### Diseñamos el disparador:

 1. SENTENCIA DISPARADORA: En la BD están todas las cuotas asociadas a los prestamos, la fecha de pago se actualiza. Esto quiere decir que la sentencia es ACTUALIZACIÓN de la fecha de pago en la tabla cuota.
 2. ANTES O DESPUÉS: La restricción de integridad no se puede violar, por lo tanto el trigger debe ser disparado ANTES de realizar la actualización.
 3. PARA TODAS/PARA EL BLOQUE: La verificación de la restricción se hace para TODAS LAS FILAS que se actualicen al ejecutar la sentencia disparadora.
 4. CONDICIÓN(WHEN): Se debe impedir la actualización, solo cuando LA FECHA DE PAGO SEA MAYOR QUE LA FECHA DE VENCIMIENTO DE LA CUOTA.
 5. ACCIÓN: Dar un error por violación de la restricción.

```sql
CREATE TRIGGER BUpCUOTA
BEFORE UPDATE OF f_pago ON Cuota
FOR EACH ROW
WHEN (new.f_pago > old.f_venc)
BEGIN
 raise_application_error(-2000,'Cuota ' || TO_CHAR(:old.num_cuota) || ' del prestamo ' || TO_CHAR(:old.num_prest) || ' vencida.');
END;
/
```

### Ejemplo Trigger+Secuencia

```sql
CREATE TABLE mitabla (
 codigo INTEGER NOT NULL PRIMARY KEY,
 dato INTEGER
);

CREATE SEQUENCE clave_mitabla;
```

```sql
CREATE TRIGGER TRIG_SEQ
BEFORE INSERT ON mitabla
FOR EACH ROW
BEGIN
SELECT clave_mitabla.NEXTVAL INTO :NEW.codigo FROM DUAL;
END;
/
```

### Modificación en Disparadores

Un Disparador no puede ser alterado explicitamente. Debe ser reemplazado por una nueva definición. Cuando se reemplaza un disparador se debe incluir la opción `OR REPLACE` en la instrucción `CREATE TRIGGER`.

La otra opción es eliminar el trigger y volverlo a crear.

Se pueden habilitar y deshabilitar los disparadores.

```sql
ALTER TRIGGER <nombre_trigger> DISABLE;
ALTER TRIGGER <nombre_trigger> ENABLE;


ALTER TABLE <nombre_tabla>
DISABLE ALL TRIGGERS;
ALTER TABLE <nombre_tabla>
ENABLE ALL TRIGGERS;
```

## Sesión 5: PL/SQL
