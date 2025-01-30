 SELECT 
    COALESCE(compras_cotacoes_fornecedor.id, 0) AS id,
    compras_requisicoes.item AS cod_item,
    erp_unidades.descricao AS Un,
    erp_unidades.codigo AS Cod_un,
    compras_requisicoes.quantidade AS Qtd,
    erp_itens.descricao AS Descricao_prod,
    erp_itens.codigo AS codigo_item,
    compras_requisicoes.id AS Requisicao,
    compras_solicitacoes_cotacao.id AS Solicitacao,
    compras_requisicoes.cotacao AS Cotacao,
    compras_cotacoes_fornecedor.valor_unitario AS V_Un,
    compras_cotacoes_fornecedor.decimais AS qtd_Decimais,
    compras_cotacoes_fornecedor.imposto AS Imp,
    compras_cotacoes_fornecedor.adicionais_item AS AdicionaisPedido,
    CASE 
        WHEN compras_cotacoes_fornecedor.condicao IS NULL 
            THEN compras_cotacoes_fornecedor_rodada_anterior.condicao
        ELSE compras_cotacoes_fornecedor.condicao 
    END AS Cond,
    CASE 
        WHEN compras_cotacoes_fornecedor.condicao IS NULL 
            THEN compras_condicoes_pagamento_rodada_anterior.descricao
        ELSE compras_condicoes_pagamento.descricao 
    END AS descCond,
    CASE 
        WHEN compras_cotacoes_fornecedor.condicao IS NULL 
            THEN CASE 
                    WHEN compras_condicoes_pagamento_rodada_anterior.adiantamento = 1 
                        THEN 'true'
                    ELSE 'false'
                 END
        ELSE CASE 
                WHEN compras_condicoes_pagamento.adiantamento = 1 
                    THEN 'true'
                ELSE 'false'
             END 
    END AS adiantamento,
    compras_cotacoes_fornecedor.percentual_adiantamento AS percentualAdiantamento,
    compras_cotacoes_fornecedor.parcelas AS Parc,
    compras_cotacoes_fornecedor.valor_parcela AS V_Parc,
    compras_cotacoes_fornecedor.valor_total AS V_Total,
    DATE_FORMAT(compras_cotacoes_fornecedor.data_previsao_entrega, '%d/%m/%Y') AS previsao_entrega_item,
    compras_cotacoes_fornecedor.sequencia AS Seq,
    compras_cotacoes_fornecedor_cabecalho.id AS Id_Cabecalho,
    compras_cotacoes_fornecedor_cabecalho.compra_direta AS C_Ditera,
    compras_cotacoes_fornecedor_cabecalho.cnpj AS CNPJ_C_Direta,
    compras_cotacoes_fornecedor_cabecalho.razao_social AS Razao_Social,
    compras_cotacoes_fornecedor_cabecalho.usuario AS Responsavel,
    compras_cotacoes_fornecedor_cabecalho.tipo_entrega AS Tipo_Entrega,
    compras_cotacoes_fornecedor_cabecalho.frete AS Frete,
    compras_cotacoes_fornecedor_cabecalho.telefone_responsavel AS telefone_responsavel,
    compras_cotacoes_fornecedor_cabecalho.email_responsavel AS email_responsavel,
    compras_cotacoes_fornecedor_cabecalho.validade_proposta AS validade_proposta,
    DATE_FORMAT(compras_cotacoes_fornecedor_cabecalho.previsao_entrega, '%Y-%m-%d') AS Prev_Entrega,
    COALESCE(compras_cotacoes_fornecedor.desconto, 0) AS Desconto,
    compras_cotacoes.moeda,
    erp_moeda.simbolo,
    erp_moeda.descricao AS sigla_moeda,
    compras_requisicoes.especificacoes AS obs,
    compras_cotacoes.frete AS frete_cotacao,
    compras_cotacoes.condicao AS condicao,
    erp_depositos.id AS deposito,
    COALESCE(erp_depositos.codigo, '') AS deposito_codigo,
    erp_depositos.descricao AS descricao_deposito,
    erp_depositos.cep AS cep_deposito,
    erp_depositos.endereco AS endereco_deposito,
    erp_depositos.bairro AS bairro_deposito,
    erp_depositos.cidade AS cidade_deposito,
    erp_depositos.estado AS estado_deposito,
    erp_depositos.telefone AS telefone_deposito,
    erp_pessoas.cnpj_cpf AS CNPJ,
    erp_pessoas.email,
    erp_pessoas.id AS forne,
    erp_pessoas.nome_fantasia AS Nome_Fornecedor,
    erp_itens.ncm AS ncm_item,
    JSON_OBJECTAGG(
        CONCAT(
            COALESCE(compras_especificacoes.id, ee.id, 'NULL'), 
            '-', 
            CASE 
                WHEN ccp_comprador.trava_edicao OR compras_cotacoes_especificacoes.id IS NOT NULL 
                    THEN 'true'
                ELSE 'false'
            END
        ), 
        COALESCE(compras_cotacoes_especificacoes.valor_especificacao, ccp_comprador.valor_especificacao)
    ) AS especificacoes,
    JSON_OBJECTAGG(
        COALESCE(ee.id, 'NULL'), 
        IF(ccp_comprador.obrigatorio = 1, 'true', 'false')
    ) AS especificacoes_obrigatorias
FROM 
    compras_requisicoes
INNER JOIN erp_itens ON compras_requisicoes.item = erp_itens.id
INNER JOIN erp_unidades ON erp_itens.unidade = erp_unidades.id
LEFT JOIN compras_solicitacoes_cotacao ON compras_requisicoes.cotacao = compras_solicitacoes_cotacao.cotacao
LEFT JOIN compras_cotacoes_fornecedor ON compras_solicitacoes_cotacao.id = compras_cotacoes_fornecedor.solicitacao
    AND compras_cotacoes_fornecedor.solicitacao = compras_solicitacoes_cotacao.id
    AND compras_cotacoes_fornecedor.requisicao = compras_requisicoes.id
    AND compras_cotacoes_fornecedor.sequencia = 1
LEFT JOIN compras_cotacoes_fornecedor AS compras_cotacoes_fornecedor_rodada_anterior 
    ON compras_solicitacoes_cotacao.id = compras_cotacoes_fornecedor_rodada_anterior.solicitacao
    AND compras_cotacoes_fornecedor_rodada_anterior.solicitacao = compras_solicitacoes_cotacao.id
    AND compras_cotacoes_fornecedor_rodada_anterior.requisicao = compras_requisicoes.id
    AND compras_cotacoes_fornecedor_rodada_anterior.sequencia = 0
LEFT JOIN compras_cotacoes_fornecedor_cabecalho ON compras_requisicoes.cotacao = compras_cotacoes_fornecedor_cabecalho.cotacao 
    AND compras_cotacoes_fornecedor_cabecalho.pessoa = compras_solicitacoes_cotacao.pessoa
LEFT JOIN compras_condicoes_pagamento ON compras_condicoes_pagamento.id = compras_cotacoes_fornecedor.condicao
LEFT JOIN compras_condicoes_pagamento AS compras_condicoes_pagamento_rodada_anterior 
    ON compras_condicoes_pagamento_rodada_anterior.id = compras_cotacoes_fornecedor_rodada_anterior.condicao
INNER JOIN compras_cotacoes ON compras_solicitacoes_cotacao.cotacao = compras_cotacoes.id
INNER JOIN erp_depositos ON compras_requisicoes.deposito = erp_depositos.id
INNER JOIN erp_pessoas ON compras_solicitacoes_cotacao.pessoa = erp_pessoas.id
INNER JOIN erp_moeda ON erp_moeda.id = compras_cotacoes.moeda
LEFT JOIN compras_cotacoes_especificacoes 
    ON compras_cotacoes_especificacoes.cotacao = compras_requisicoes.cotacao
    AND compras_cotacoes_especificacoes.pessoa = compras_solicitacoes_cotacao.pessoa
    AND compras_cotacoes_especificacoes.item = compras_requisicoes.item
    AND compras_cotacoes_especificacoes.sequencia = 1
LEFT JOIN compras_cotacoes_especificacoes ccp_comprador 
    ON ccp_comprador.cotacao = compras_requisicoes.cotacao
    AND ccp_comprador.pessoa IS NULL
    AND ccp_comprador.item = compras_requisicoes.item
    AND ccp_comprador.sequencia = ( 
        SELECT MAX(sequencia) 
        FROM compras_cotacoes_especificacoes cce
        WHERE cce.empresa_moon = compras_requisicoes.empresa_moon
            AND cce.pessoa IS NULL
            AND cce.cotacao = compras_requisicoes.cotacao
            AND cce.item = compras_requisicoes.item
            AND cce.sequencia != 2
    )
LEFT JOIN compras_especificacoes_empresa 
    ON compras_especificacoes_empresa.especificacao = compras_cotacoes_especificacoes.especificacao
    AND compras_especificacoes_empresa.empresa_moon = compras_requisicoes.empresa_moon
LEFT JOIN compras_especificacoes_empresa eee 
    ON eee.especificacao = ccp_comprador.especificacao
    AND eee.empresa_moon = compras_requisicoes.empresa_moon
LEFT JOIN compras_especificacoes 
    ON compras_especificacoes.id = compras_especificacoes_empresa.especificacao
LEFT JOIN compras_especificacoes ee 
    ON ee.id = eee.especificacao
WHERE 
    compras_requisicoes.cotacao = 4565
    AND compras_solicitacoes_cotacao.pessoa = 34921
GROUP BY 
    compras_requisicoes.id;