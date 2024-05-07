select num_ejemplares, num_disponibles from dispone where ISBN=5025496 AND cod_suc=9;

UPDATE DISPONE
SET num_ejemplares = num_ejemplares+3, num_disponibles = num_disponibles + 3
WHERE ISBN=5025496 AND cod_suc=9;

select num_ejemplares, num_disponibles from dispone where ISBN=5025496 AND cod_suc=9;
