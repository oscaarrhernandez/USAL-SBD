/*s1e1: Devolver el nombre y los apellidos de todos los
lectores que vivan en Salamanca y hayan realizado préstamos en el 2011.*/
set pagesize 100
set linesize 150
spool s1e1
ttitle 'Sesion1Ejercicio1|Lectores de Salamanca que realizaron préstamos en 2011'
select distinct l.nombre, l.ape_1, l.ape_2 FROM lector l, prestamo p WHERE l.codigo=p.cod_lector AND l.poblacion = 'Salamanca' AND to_char(p.Fecha_ini,'yyyy')=2011;
ttitle off
spool off;
/*s1e2: Realice un listado de todos los préstamos ordenados por sucursales
 y para cada sucursal ordenar dichos préstamos cronológicamente.*/
set pagesize 100
set linesize 150
spool s1e2
ttile 'Sesion1Ejercicio2|Listado préstamos ordenador por sucursales y cronológicamente'
select codigo, isbn, cod_suc, cod_lector, to_char(Fecha_ini,'yyyy') AS ANIO PRESTAMO
FROM prestamo ORDER BY 3,5;
ttitle off
spool off;
/*s1e3: Mostrar la información de todos los autores de los que o bien no se conoce
su fecha de nacimiento o de muerte*/
set pagesize 100
set linesize 150
spool s1e3
ttitle 'Sesion1Ejercicio3|Autores cuyas fechas no se conocen'
select nombre, apellido from autor where ano_nac IS NULL OR ano_fall IS NULL;
ttitle off
spool off;
/*s1e5: Saque el listado de todos los libros con los que cuenta 
la sucursal 1, 2 y 3 ordenados por ISBN y por sucursal*/
set pagesize 100
set linesize 150
spool s1e5
ttitle 'Sesion1Ejercicio5|Libros en Suc1,2,3 ordenados por ISBN y sucursal'
select l.ISBN, l.Titulo, d.cod_suc, l.Ano_Edicion, l.Cod_Editorial from libro l, dispone d where l.ISBN = d.ISBN and d.cod_suc in (1,2,3) 
ORDER BY 1, 3;
ttitle off
spool off;
/*s1e6: Listado de todos los libros con los que cuenta una sucursal, 
cuyo código se pasará como parámetro, ordenados por ISBN*/
set pagesize 100
set linesize 150
spool s1e6
ttitle 'Libros en una sucursal &1 ordenados por ISBN'
select d.ISBN, l.Titulo FROM dispone d, libro l where d.isbn=l.isbn AND d.cod_suc=&1 ORDER BY 1;
ttitle off
spool off;
/*@s1e6 cod_suc*/
