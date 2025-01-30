SELECT
    authorize_cadastros.id,
    authorize_tipos_campos.codigo AS codigo_aprovacao,
    authorize_tipos.descricao AS descricao_tipos
FROM
    authorize_cadastros
LEFT JOIN
    authorize_tipos_campos
    ON authorize_tipos_campos.id = authorize_cadastros.campo
LEFT JOIN
    authorize_tipos
    ON authorize_tipos.id = authorize_cadastros.tipo
WHERE
    1 = 1
    AND authorize_tipos.descricao = 'Pedido de Compras'
    AND authorize_tipos_campos.codigo LIKE '%centro_custo%'
    AND authorize_tipos_campos.empresa_moon = 245
GROUP BY
    authorize_tipos_campos.codigo;
