set pagesize 100
set linesize 150
spool s1e5
ttitle 'Sesion1Ejercicio5|Libros en Suc1,2,3 ordenados por ISBN y sucursal'
select l.ISBN, l.Titulo, d.cod_suc, l.Ano_Edicion, l.Cod_Editorial from libro l, dispone d where l.ISBN = d.ISBN and d.cod_suc in (1,2,3) 
ORDER BY 1, 3;
ttitle off
spool off;