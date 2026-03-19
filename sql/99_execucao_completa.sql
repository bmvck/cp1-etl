PROMPT ===== EXECUÇÃO COMPLETA DO DW DE ESTOQUE =====
PROMPT ===== Pré-requisito: o schema PF1788 deve estar acessível pela sua conexão =====

@@00_modelo_oltp_referencia.sql
@@00a_carga_origem_pf1788.sql
@@01_dw_dimensoes_reutilizadas.sql
@@02_dw_novas_dimensoes_e_fato.sql
@@03_dw_indices_e_log.sql
@@04_etl_dim_tempo.sql
@@05_etl_dim_produto.sql
@@06_etl_dim_tipo_movimento.sql
@@07_etl_dim_estoque.sql
@@08_etl_fato_estoque.sql
@@11_validacoes_rapidas.sql

PROMPT ===== Validações finais =====
SELECT COUNT(*) AS QTD_DIM_TEMPO FROM DIM_TEMPO;
SELECT COUNT(*) AS QTD_DIM_PRODUTO FROM DIM_PRODUTO;
SELECT COUNT(*) AS QTD_DIM_TIPO_MOVIMENTO FROM DIM_TIPO_MOVIMENTO;
SELECT COUNT(*) AS QTD_DIM_ESTOQUE FROM DIM_ESTOQUE;
SELECT COUNT(*) AS QTD_FATO_ESTOQUE FROM FATO_ESTOQUE;
