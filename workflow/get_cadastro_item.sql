select 
    erp_itens.id,  
    erp_itens.codigo,  
    erp_itens.descricao,  
    erp_unidades.descricao as unidade,  
    erp_unidades.codigo as codigo_unidade,  
    erp_itens.reembolso,  
    erp_itens.tipo,  
    erp_itens.fundo_fixo,  
    erp_itens.conta_contabil,  
    erp_itens.tipo_despesa,  
    if(erp_itens.obriga_descricao, 'true', 'false') as obriga_descricao,  
    erp_tipos_despesas.despesa as desc_despesa,
    CASE 
        WHEN erp_itens.multiplo_fator IS NOT NULL THEN CAST(erp_itens.multiplo_fator AS DECIMAL) 
        ELSE false 
    END multiplo_fator,  
    erp_itens.valor_multiplo_fator,  
    erp_categorias.codigo as codigo_categoria,  
    erp_categorias.descricao as nome_categoria,  
    erp_naturezas.codigo as codigo_natureza,  
    erp_naturezas.descricao as nome_natureza,  
    erp_itens.ncm,  
    erp_itens.id_externo   
from erp_itens  
inner join erp_unidades on erp_unidades.id = erp_itens.unidade  
left join erp_naturezas on erp_naturezas.id = erp_itens.natureza  
left join erp_tipos_despesas on erp_itens.tipo_despesa = erp_tipos_despesas.id  
left join erp_itens_marca on erp_itens_marca.item = erp_itens.id  
left join erp_marcas on erp_marcas.id = erp_itens_marca.marca  
left join erp_categorias on erp_categorias.id = erp_itens.categoria  
where 1 = 1  
    and (erp_itens.empresa is null or erp_itens.empresa = '326')  
    and (erp_itens.filial is null or erp_itens.filial = '387')  
    and erp_itens.ativo = true  
    and erp_itens.status_cadastro = 3  
    and erp_itens.empresa_moon = 245  
order by erp_itens.descricao asc 
LIMIT 0, 10;