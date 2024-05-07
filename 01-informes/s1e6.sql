set pagesize 100
set linesize 150
spool s1e6
ttitle 'Libros en una sucursal &1 ordenados por ISBN'
select d.ISBN, l.Titulo FROM dispone d, libro l where d.isbn=l.isbn AND d.cod_suc=&1 ORDER BY 1;
ttitle off
spool off;
/*@s1e6 cod_suc*/