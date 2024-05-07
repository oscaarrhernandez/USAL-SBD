SELECT direccion, poblacion, provincia FROM LECTOR WHERE codigo = 15838332;

UPDATE LECTOR 
SET direccion = 'C/Sevilla, 1', poblacion = 'Aldeadavila', provincia = 'Salamanca'
WHERE codigo = 15838332;

SELECT direccion, poblacion, provincia FROM LECTOR WHERE codigo = 15838332;
