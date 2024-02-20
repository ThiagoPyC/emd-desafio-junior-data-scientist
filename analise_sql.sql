-- Localização de chamados do 1746

-- 1 - Quantos chamados foram abertos no dia 01/04/2023?
-- Resposta: 73 chamados.

SELECT COUNT('id_chamado') AS total_chamados
FROM datario.administracao_servicos_publicos.chamado_1746  
WHERE data_inicio BETWEEN '2023-04-01 00:00:00' AND '2023-04-01 23:59:59';

-- 2 - Qual o tipo de chamado que teve mais teve chamados abertos no dia 01/04/2023?
-- Resposta: O tipo de chamado com maior ocorrencia foi Poluição sonora.

SELECT tipo, COUNT('id_chamado') AS tipo_chamado
FROM datario.administracao_servicos_publicos.chamado_1746  
WHERE data_inicio BETWEEN '2023-04-01 00:00:00' AND '2023-04-01 23:59:59'
GROUP BY tipo
order by tipo_chamado DESC;

-- 3 - Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?
-- Resposta: Os 3 bairros com mais chamados foram: Engenho de dentro, Leblon e Campo Grande.

SELECT b.nome, COUNT('id_chamado') as total_chamado
FROM datario.administracao_servicos_publicos.chamado_1746 c
LEFT JOIN datario.dados_mestres.bairro b ON c.id_bairro = b.id_bairro
WHERE data_inicio BETWEEN '2023-04-01 00:00:00' AND '2023-04-01 23:59:59'
GROUP BY b.nome
ORDER BY total_chamado DESC
LIMIT 3;

-- 4 - Qual o nome da subprefeitura com mais chamados abertos nesse dia?
--Resposta: Zona Norte

SELECT b.subprefeitura, COUNT('id_chamado') as total_chamado
FROM datario.administracao_servicos_publicos.chamado_1746 c
LEFT JOIN datario.dados_mestres.bairro b ON c.id_bairro = b.id_bairro
WHERE data_inicio BETWEEN '2023-04-01 00:00:00' AND '2023-04-01 23:59:59'
GROUP BY b.subprefeitura
ORDER BY total_chamado DESC
LIMIT 1;

-- 5 - Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros? Se sim, por que isso acontece?
-- Resposta: Teve um chamado aberto que não está associado a um bairro ou subprefeitura por motivos que o chamado foi aberto para uma verificação do ar condicionado de um onibus.

SELECT *
FROM datario.administracao_servicos_publicos.chamado_1746 c
LEFT JOIN datario.dados_mestres.bairro b ON c.id_bairro = b.id_bairro
WHERE (b.id_bairro IS NULL OR b.subprefeitura IS NULL) AND data_inicio BETWEEN '2023-04-01 00:00:00' AND '2023-04-01 23:59:59';

-- Chamados do 1746 em grandes eventos 
--