PROMPT ===== EXECUCAO PASSO A PASSO DO DW DE ESTOQUE =====
PROMPT ===== Rode com F5 (Run Script), nao com Ctrl+Enter =====

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
