## Enunciado

```SQL
CLIENTE(*LOGIN*,PASSWORD,NOMBRE,APELLIDO,FECHAALTA,CIUDAD);
			CIUDAD PUEDE SER NULL
REVISTA(*IDREVISTA*,NOMBREREVISTA,TEMA,PERIODICIDAD,NUMARTICULOS);
			NUMARTICULOS NUM TOTAL DE ARTICULOS PUBLICADOS POR LA REVISTA
SUBSCRITO(*LOGINCLIENTE,IDREVISTA*,FECHASUBSCRIPCION);
			LOGINCLIENTE FK SOBRE CLIENTE 
			IDREVISTA FK SOBRE REVISTA
ARTICULO(*IDARTICULO*,IDREVISTA,FECHA,RESUMEN,ENLACETEXTO);
			IDREVISTA FK SOBRE REVISTA
```

EN INMERSO EN C, Obtener un listado de las revistas subcritas por aquellos clientes que tengan tres o mas subcripciones.En el informe se presentará el nombre,apellido de cada cliente seguido del listado alfabético de los nombres de las revistas a las que está subscrito.
