SELECT 
    contratos_contratos.id, 
    contratos_contratos.codigo, 
    contratos_contratos.descricao, 
    DATE_FORMAT(contratos_contratos.periodo_inicio, '%d/%m/%Y') AS periodo_inicio, 
    DATE_FORMAT(contratos_contratos.periodo_fim, '%d/%m/%Y') AS periodo_fim, 
    DATE_FORMAT(contratos_contratos.data_renovacao, '%d/%m/%Y') AS data_renovacao, 
    contratos_contratos.vencimentos, 
    contratos_contratos.valor_total, 
    contratos_contratos.aviso_previo, 
    contratos_contratos.observacoes, 
    contratos_contratos.indice, 
    contratos_contratos.pai, 
    contratos_contratos.id_externo, 
    contratos_contratos.tipo, 
    contratos_contratos.campos_custom, 
    contrato_pai.codigo AS codigo_pai, 
    contrato_pai.descricao AS descricao_pai, 
    contratos_contratos.ativo, 
    contratos_contratos.usuario_inicio_automatico, 
    CONCAT(moon_usuarios.nome, ' ', moon_usuarios.sobrenome) AS nome_usuario_inicio_automatico, 
    contratos_contratos.aprovado, 
    contratos_alertas.vencimento_contrato, 
    contratos_alertas.vencimento_parcela, 
    contratos_alertas.renovacao_contrato, 
    contratos_controles.tem_formulario_pep, 
    contratos_controles.travar_valor_parcela, 
    contratos_controles.travar_quando_saldo_atingido, 
    contratos_controles.aprovacao_por_gestor_contrato, 
    contratos_controles.exigir_aprovacao_parcelas, 
    contratos_controles.inicio_medicao_automatica, 
    contratos_controles.permite_aditivo, 
    contratos_controles.exigir_validacao_fornecedor, 
    contratos_controles.guarda_chuva, 
    contratos_controles.sem_vencimento, 
    contratos_controles.prazo_indeterminado, 
    contratos_controles.vigencia_contrato_prazo_indeterminado, 
    contratos_controles.validar_periodo_medicao, 
    contratos_controles.nao_permitir_multiplas_medicoes, 
    contratos_controles.importar_xml, 
    contratos_controles.retencao, 
    contratos_controles.percentual_retencao, 
    contratos_contratos.condicao_pagamento AS id_condicao_pagamento, 
    compras_condicoes_pagamento.codigo AS codigo_condicao_pagamento, 
    compras_condicoes_pagamento.descricao AS descricao_condicao_pagamento, 
    contratos_status.id AS id_status, 
    contratos_status.descricao AS status, 
    contratos_empresa_moon.empresa_moon_parceiro, 
    contratos_confeccao.solicitacao AS solicitacao_confeccao, 
    contratos_naturezas.id AS id_natureza, 
    contratos_naturezas.codigo AS codigo_natureza, 
    contratos_naturezas.descricao AS descricao_natureza, 
    contratos_categorias.id AS id_categoria, 
    contratos_categorias.codigo AS codigo_categoria, 
    contratos_categorias.descricao AS descricao_categoria, 
    financeiro_tipo_formas_pagamento.id AS tipo_forma_pagamento, 
    financeiro_tipo_formas_pagamento.tipo_descricao AS descricao_forma_pagamento, 
    financeiro_formas_pagamento.id AS id_forma_pagamento, 
    financeiro_formas_pagamento.codigo AS codigo_forma_pagamento, 
    COALESCE(MAX(contratos_historico_edicoes.versao), 1) AS versao_contrato  
FROM contratos_contratos
LEFT JOIN moon_usuarios ON moon_usuarios.id = contratos_contratos.usuario_inicio_automatico
LEFT JOIN contratos_alertas ON contratos_alertas.contrato = contratos_contratos.id
LEFT JOIN contratos_controles ON contratos_controles.contrato = contratos_contratos.id
LEFT JOIN contratos_contratos contrato_pai ON contrato_pai.id = contratos_contratos.pai
LEFT JOIN contratos_empresa_moon ON contratos_empresa_moon.contrato = contratos_contratos.id
INNER JOIN compras_condicoes_pagamento ON compras_condicoes_pagamento.id = contratos_contratos.condicao_pagamento
INNER JOIN contratos_status ON contratos_contratos.status = contratos_status.id
LEFT JOIN contratos_confeccao ON contratos_contratos.id = contratos_confeccao.contrato
LEFT JOIN contratos_naturezas ON contratos_naturezas.id = contratos_contratos.natureza
LEFT JOIN contratos_categorias ON contratos_categorias.id = contratos_contratos.categoria
INNER JOIN contratos_empresas ON contratos_empresas.contrato = contratos_contratos.id
LEFT JOIN financeiro_tipo_formas_pagamento ON financeiro_tipo_formas_pagamento.id = contratos_contratos.forma_pagamento
LEFT JOIN financeiro_formas_pagamento ON financeiro_formas_pagamento.tipo = financeiro_tipo_formas_pagamento.id
    AND financeiro_formas_pagamento.empresa_moon = contratos_contratos.empresa_moon
    AND (financeiro_formas_pagamento.empresa = contratos_empresas.empresa OR financeiro_formas_pagamento.empresa IS NULL)
LEFT JOIN contratos_historico_edicoes ON contratos_contratos.id = contratos_historico_edicoes.contrato
WHERE contratos_contratos.empresa_moon = 245;