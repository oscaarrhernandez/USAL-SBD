set pagesize 100
set linesize 132
spool s1e2
ttile 'Sesion1Ejercicio2|Listado pr�stamos ordenador por sucursales y cronol�gicamente'
select codigo, isbn, cod_suc, cod_lector, to_char(Fecha_ini,'yyyy') AS ANIO
FROM prestamo ORDER BY 3,5;
ttitle off
spool off;