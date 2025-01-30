select * from authorize_cadastros
left join authorize_tipos on authorize_tipos.id = authorize_cadastros.tipo
left join authorize_tipos_campos on authorize_tipos_campos.id = authorize_cadastros.campo
where authorize_tipos.empresa_moon = 495 and authorize_cadastros.tipo = 372;