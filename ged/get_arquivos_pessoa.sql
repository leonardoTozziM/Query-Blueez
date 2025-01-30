SELECT distinct 
  arquivos.id, 
  arquivos.pai, 
  arquivos.nome, 
  arquivos.tamanho, 
  arquivos.local, 
  arquivos.data_criacao, 
  arquivos.usuario_moon, 
  CONCAT(usuarios.nome, ' ', usuarios.sobrenome) as usuario, 
  arquivos.acesso_publico, 
  arquivos.link_acesso, 
  arquivos.link_interno, 
  arquivos.diretorio_pai, 
  arquivos.data_exclusao  
FROM ged_arquivos arquivos  
LEFT JOIN ged_permissoes_grupos permissoes_grupos on arquivos.id = permissoes_grupos.arquivo  
LEFT JOIN moon_grupos grupos on grupos.id = permissoes_grupos.grupo  
LEFT JOIN ged_permissoes_usuarios permissoes_usuarios on arquivos.id = permissoes_usuarios.arquivo  
LEFT JOIN ged_permissoes_pessoas	 permissoes_pessoas ON arquivos.id = permissoes_pessoas.arquivo  
LEFT JOIN moon_usuarios usuarios ON arquivos.usuario_moon = usuarios.id  
LEFT JOIN ged_permissoes_perfil permissoes_perfil ON permissoes_perfil.arquivo = arquivos.id  
LEFT JOIN moon_usuario_grupo usuario_grupo on usuario_grupo.grupo = grupos.id AND usuario_grupo.usuario = 26748  
WHERE arquivos.data_exclusao is null 
  AND arquivos.lixeira = 0  
  and permissoes_pessoas.pessoa = 148281
  AND arquivos.pai = 20880 
GROUP BY arquivos.id;


select * from ged_arquivos order by id desc;
select * from ged_arquivos order by id desc;
SELECT * FROM ged_permissoes_pessoas where pessoa = 26500;
select * from moon_usuario_pessoas where pessoa = 35432;
SELECT * FROM ged_permissoes_usuarios where u = 20719;
SELECT * FROM moon_usuario_grupo where usuario = 26748;
SELECT perfil FROM moon_usuario_perfil_empresa WHERE usuario = 26748;