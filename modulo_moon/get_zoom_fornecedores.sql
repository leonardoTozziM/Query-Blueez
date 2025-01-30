SELECT *, 
    (quantidade_fornecedor_atende / quantidade_itens_requisicao) * 100 AS percentual
FROM 
    (
        SELECT 
            erp_pessoas.id, 
            erp_pessoas.codigo, 
            erp_pessoas.cnpj_cpf, 
            erp_pessoas.razao_social, 
            erp_pessoas.nome_fantasia, 
            erp_pessoas.telefone, 
            erp_pessoas.cidade, 
			COALESCE(erp_pessoas.estado, '') AS estado, 
            erp_pessoas.email, 
            erp_pessoas.homologado, 
            COALESCE(erp_servicos.descricao, '') AS descricao, 
            IFNULL(GROUP_CONCAT(erp_setores.descricao SEPARATOR ', '), '') AS grupos, 
            (
                SELECT COUNT(compras_requisicoes.item)
                FROM compras_requisicoes 
                WHERE compras_requisicoes.cotacao = cotacao
            ) AS quantidade_itens_requisicao, 
            (
                SELECT COUNT(fornecedores)
                FROM 
                    (
                        SELECT 
                            cr.item, 
                            erp_itens.descricao AS descricao, 
                            compras_pedidos_compra.pessoa AS fornecedores
                        FROM 
                            compras_requisicoes cr 
                            INNER JOIN compras_pedidos_compra ON compras_pedidos_compra.id = cr.pedido 
                            INNER JOIN erp_itens ON erp_itens.id = cr.item 
                        WHERE 
                            cr.empresa_moon = 274 
                            AND cr.status IN (18) 
                            AND cr.item IN (
                                SELECT compras_requisicoes.item 
                                FROM compras_requisicoes 
                                WHERE compras_requisicoes.cotacao = cotacao
                            ) 
                        UNION 
                        SELECT 
                            erp_itens_pessoa.item, 
                            erp_itens.descricao AS descricao, 
                            erp_itens_pessoa.pessoa AS fornecedores 
                        FROM 
                            erp_itens_pessoa 
                            INNER JOIN erp_itens ON erp_itens.id = erp_itens_pessoa.item 
                        WHERE 
                            erp_itens_pessoa.empresa_moon = 274
                            AND erp_itens_pessoa.item IN (
                                SELECT compras_requisicoes.item 
                                FROM compras_requisicoes 
                                WHERE compras_requisicoes.cotacao = cotacao
                            )
                    ) AS tabela 
                WHERE 
                    fornecedores = erp_pessoas.id
            ) AS quantidade_fornecedor_atende 
        FROM 
            erp_pessoas 
            LEFT JOIN erp_pessoas_servicos ON erp_pessoas.id = erp_pessoas_servicos.id 
            LEFT JOIN erp_servicos ON erp_pessoas_servicos.servico = erp_servicos.id 
            LEFT JOIN erp_setores_pessoa ON erp_setores_pessoa.pessoa = erp_pessoas.id 
            LEFT JOIN erp_setores ON erp_setores.id = erp_setores_pessoa.grupos
        WHERE 
            erp_pessoas.fornecedor = 1 
            AND erp_pessoas.ativa = 1 
            AND erp_pessoas.empresa_moon = 274
            and erp_pessoas.razao_social like '%VINDI TECNOLOGIA E MARKETING SA%'
        GROUP BY 
            erp_pessoas.id
    ) AS zoom
ORDER BY 
    percentual DESC, nome_fantasia ;