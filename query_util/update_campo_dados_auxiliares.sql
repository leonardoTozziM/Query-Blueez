
UPDATE compras_requisicoes
SET dados_auxiliares = JSON_SET(
    JSON_REMOVE(dados_auxiliares, '$.codigo_projeto'),  -- Remove o campo antigo ex: "codigo_projeto"
    '$.projeto', JSON_UNQUOTE(JSON_EXTRACT(dados_auxiliares, '$.codigo_projeto')) -- Cria o novo campo ex: "projeto" com o valor de "codigo_projeto"
)
WHERE JSON_EXTRACT(dados_auxiliares, '$.codigo_projeto') IS NOT NULL and empresa_moon = 176 and id = ?;
