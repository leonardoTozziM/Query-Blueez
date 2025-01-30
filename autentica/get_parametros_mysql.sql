SELECT 
    COALESCE(moon_parametros_empresas.valor, moon_parametros.valor_padrao) AS valor,
    moon_parametros.tipo AS tipo
FROM 
    moon_parametros
LEFT JOIN 
    moon_parametros_tipo ON moon_parametros_tipo.id = moon_parametros.tipo
LEFT JOIN 
    moon_parametros_empresas ON moon_parametros_empresas.parametro = moon_parametros.id 
    AND moon_parametros_empresas.empresa_moon = 3
WHERE 
    moon_parametros.codigo = "modulo_autenticacao.ocultar_menu_troca_senha";