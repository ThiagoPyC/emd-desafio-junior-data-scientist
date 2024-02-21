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

-- 6 - Quantos chamados com o subtipo "Perturbação do sossego" foram abertos desde 01/01/2022 até 31/12/2023 (incluindo extremidades)?
-- Resposta: 42408

SELECT COUNT('id_chamado') AS total_chamados FROM datario.administracao_servicos_publicos.chamado_1746 
WHERE data_inicio BETWEEN '2022-01-01 00:00:00' AND '2023-12-31 23:59:59' AND subtipo = 'Perturbação do sossego';

-- 7 - Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).
-- Resposta: 

SELECT * FROM datario.administracao_servicos_publicos.chamado_1746 c
INNER JOIN datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos o ON c.data_inicio BETWEEN o.data_inicial AND o.data_final
WHERE data_inicio BETWEEN '2022-01-01 00:00:00' AND '2023-12-31 23:59:59' AND subtipo = 'Perturbação do sossego';

-- 8 - Quantos chamados desse subtipo foram abertos em cada evento?
--Resposta: Rock in Rio:518 Carnaval:197 Reveillon:79.

SELECT o.evento, COUNT('id_chamado') AS total_chamados FROM datario.administracao_servicos_publicos.chamado_1746 c
INNER JOIN datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos o ON c.data_inicio BETWEEN o.data_inicial AND o.data_final
WHERE data_inicio BETWEEN '2022-01-01 00:00:00' AND '2023-12-31 23:59:59' AND subtipo = 'Perturbação do sossego'
GROUP BY o.evento;

-- 9 - Qual evento teve a maior média diária de chamados abertos desse subtipo?
--Resposta: Rock in Rio: 103.6, Carnaval: 65.6, Reveillon: 39.5.

SELECT o.evento, AVG(contagem_eventos) as Media_eventos
FROM datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos o
LEFT JOIN (
    SELECT o.evento, DATE(c.data_inicio), COUNT(*) as contagem_eventos
    FROM datario.administracao_servicos_publicos.chamado_1746 c
    LEFT JOIN datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos o ON c.data_inicio BETWEEN o.data_inicial AND o.data_final
    WHERE data_inicio BETWEEN '2022-01-01 00:00:00' AND '2023-12-31 23:59:59' AND subtipo = 'Perturbação do sossego'
    GROUP BY o.evento, DATE(c.data_inicio)
) as subquery ON o.evento = subquery.evento
GROUP BY o.evento
ORDER BY Media_eventos DESC;


-- 10 - Compare as médias diárias de chamados abertos desse subtipo durante os eventos específicos (Reveillon, Carnaval e Rock in Rio) e a média diária de chamados abertos desse subtipo considerando todo o período de 01/01/2022 até 31/12/2023.
-- Resposta: A média diária de chamados do período 01/01/2022 até 31/12/2023 é de 63.2 chamados. Enquanto a média diária de chamados durante eventos foi, 
-- Rock in Rio: 103.6, Carnaval: 65.6, Reveillon: 39.5.

SELECT AVG(Media_total) as media_total 
FROM (
    SELECT c.subtipo, DATE(c.data_inicio), COUNT(*) as Media_total
    FROM datario.administracao_servicos_publicos.chamado_1746 c
    WHERE data_inicio BETWEEN '2022-01-01 00:00:00' AND '2023-12-31 23:59:59' AND subtipo = 'Perturbação do sossego'
    GROUP BY c.subtipo, DATE(c.data_inicio)
) as subquery
ORDER BY media_total DESC;
