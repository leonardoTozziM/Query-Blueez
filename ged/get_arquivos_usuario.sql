SELECT DISTINCT 
    ged_arquivos.id, 
    ged_arquivos.pai, 
    ged_arquivos.nome, 
    ged_arquivos.tamanho, 
    ged_arquivos.local, 
    ged_arquivos.data_criacao, 
    ged_arquivos.usuario_moon, 
    CONCAT(moon_usuarios.nome, ' ', moon_usuarios.sobrenome) AS usuario, 
    ged_arquivos.acesso_publico, 
    ged_arquivos.link_acesso, 
    ged_arquivos.link_interno, 
    ged_arquivos.diretorio_pai, 
    ged_arquivos.data_exclusao  
FROM ged_arquivos 
LEFT JOIN ged_permissoes_grupos ON ged_arquivos.id = ged_permissoes_grupos.arquivo  
LEFT JOIN moon_grupos ON moon_grupos.id = ged_permissoes_grupos.grupo  
LEFT JOIN ged_permissoes_usuarios ON ged_arquivos.id = ged_permissoes_usuarios.arquivo  
LEFT JOIN ged_permissoes_pessoas ON ged_arquivos.id = ged_permissoes_pessoas.arquivo  
LEFT JOIN moon_usuarios ON ged_arquivos.usuario_moon = moon_usuarios.id  
LEFT JOIN ged_permissoes_perfil ON ged_permissoes_perfil.arquivo = ged_arquivos.id  
LEFT JOIN moon_usuario_grupo ON moon_usuario_grupo.grupo = moon_grupos.id 
    AND moon_usuario_grupo.usuario = 26500  
WHERE 
    ged_arquivos.data_exclusao IS NULL 
    AND ged_arquivos.lixeira = 0  
    AND (
        ged_permissoes_usuarios.usuario = 26500 
        OR moon_usuario_grupo.usuario = 26500 
        OR ged_permissoes_perfil.perfil IN (
            SELECT perfil 
            FROM moon_usuario_perfil_empresa 
            WHERE usuario = 26500 
            AND empresa = 245
        )
    ) 
    AND ged_arquivos.pai = 20722
GROUP BY ged_arquivos.id;   