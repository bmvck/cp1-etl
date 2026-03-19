-- 08_execucao_completa.sql
-- Ordem completa de execucao.
-- Observacao: o script 01 depende de acesso ao schema PF1788.

@@00_modelo_transacional.sql
@@01_correcao_carga_origem.sql
@@02_staging.sql
@@03_dimensoes.sql
@@04_carga_dimensoes.sql
@@05_fato_venda.sql
@@06_carga_fato.sql
@@07_consultas_analiticas.sql
