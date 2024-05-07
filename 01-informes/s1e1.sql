spool s1e1
ttitle 'Sesion1Ejercicio1|Lectores de Salamanca que realizaron préstamos en 2011'
select distinct l.nombre, l.ape_1, l.ape_2 FROM lector l, prestamo p WHERE l.codigo=p.cod_lector AND l.poblacion = 'SALAMANCA' AND to_char(p.Fecha_ini,'yyyy')=2011;
ttitle off
spool off;