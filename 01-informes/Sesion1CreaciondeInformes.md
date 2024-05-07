# CREACION DE INFORMES

## Ficheros de resultados

Para mandar los resultados de la(s) próxima(s) consulta(s) a un fichero:
```spool <fichero_salida>;```

Para cerrar el fichero spool:
```spool off;```

## Fichero de comandos

Contiene sentencias SQL. La extensión de dichos ficheros debe de ser ".sql".

Para editar un fichero de comandos(creación/modificación)
```edit <f_comandos>;```

Guardar el contenido del buffer en un fichero(nombre.sql). REPLACE sirve para sobrescribir el fichero:
```SAVE <nombre> [REPLACE]```

Limpiar el buffer:
```clear buffer```

Ver o no el contenido del fichero de comandos que se va a ejecutar
```set echo [ON|OFF]```

Hacer pausas o no en la salida de un informe:
```set pause [ON|OFF|text]```

## Creación de informes

### Formateo de la salida

Para ponerle título a una página:

```sql
ttitle 'texto del título | siguiente línea del título'
ttile off
```

El titulo saldrá centrado. El caracter ```|``` se utiliza si queremos que el título aparezca en dos líneas.Además se muestra la fecha y el número de página.

Como añadir un pie de página

```sql
btitle 'pie de pagina'
```

Centra el pie de página.

### Formateo de la salida(COLUMNA)
