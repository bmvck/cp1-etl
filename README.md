# CP1 ETL - Estoque (página 7 em diante)

Este repositório contém a entrega da atividade **BLOCO 5 - Prova Prática** da aula **ETL com PL/SQL, Data Warehouse e Power BI**, agora corrigida para o cenário de **movimentação de estoque**.

## Escopo correto da atividade

A atividade correta começa na **página 7 do PDF** e pede a construção de um ETL completo para **FATO_ESTOQUE**, reaproveitando as dimensões **DIM_TEMPO** e **DIM_PRODUTO** e criando as novas dimensões **DIM_TIPO_MOVIMENTO** e **DIM_ESTOQUE**.

### Fontes OLTP utilizadas
- `CP_MOVIMENTO_ESTOQUE`
- `CP_ESTOQUE_PRODUTO`
- `CP_TIPO_MOVIMENTO_ESTOQUE`
- `CP_ESTOQUE`
- `CP_PRODUTO`

## Estrutura do repositório

```text
cp1-etl-estoque-repo/
├─ README.md
├─ docs/
│  ├─ 01_modelagem_dimensional.md
│  └─ 02_power_bi.md
└─ sql/
   ├─ 00_modelo_oltp_referencia.sql
   ├─ 00a_carga_origem_pf1788.sql
   ├─ 01_dw_dimensoes_reutilizadas.sql
   ├─ 02_dw_novas_dimensoes_e_fato.sql
   ├─ 03_dw_indices_e_log.sql
   ├─ 04_etl_dim_tempo.sql
   ├─ 05_etl_dim_produto.sql
   ├─ 06_etl_dim_tipo_movimento.sql
   ├─ 07_etl_dim_estoque.sql
   ├─ 08_etl_fato_estoque.sql
   ├─ 09_etl_orquestrador.sql
   ├─ 10_consultas_analiticas.sql
   ├─ 11_validacoes_rapidas.sql
   └─ 99_execucao_completa.sql
```

---

## PARTE 1 - Modelagem Dimensional

### 1.1 Star Schema

```text
DIM_TEMPO --------\
                   \
DIM_PRODUTO ------- FATO_ESTOQUE
                   /
DIM_TIPO_MOVIMENTO/
                 \
                  DIM_ESTOQUE
```

### 1.2 Granularidade da FATO_ESTOQUE
**Cada linha da FATO_ESTOQUE representa 1 movimento de estoque** (`SEQ_MOVIMENTO_ESTOQUE`).

### 1.3 Dimensões reaproveitadas do modelo de vendas
- `DIM_TEMPO`
- `DIM_PRODUTO`

### 1.4 Novas dimensões
- `DIM_TIPO_MOVIMENTO`
- `DIM_ESTOQUE`

### 1.5 Colunas da FATO_ESTOQUE

| Coluna | Tipo | Origem OLTP / Regra |
|---|---|---|
| `SK_FATO_ESTOQUE` | NUMBER | Surrogate key do DW |
| `SK_TEMPO` | NUMBER | Lookup em `DIM_TEMPO` usando `CP_MOVIMENTO_ESTOQUE.DAT_MOVIMENTO_ESTOQUE` |
| `SK_PRODUTO` | NUMBER | Lookup em `DIM_PRODUTO` usando `CP_MOVIMENTO_ESTOQUE.COD_PRODUTO` |
| `SK_TIPO_MOVIMENTO` | NUMBER | Lookup em `DIM_TIPO_MOVIMENTO` usando `CP_MOVIMENTO_ESTOQUE.COD_TIPO_MOVIMENTO_ESTOQUE` |
| `SK_ESTOQUE` | NUMBER | Lookup em `DIM_ESTOQUE` a partir do depósito derivado de `CP_ESTOQUE_PRODUTO` |
| `SEQ_MOVIMENTO` | NUMBER(15) | `CP_MOVIMENTO_ESTOQUE.SEQ_MOVIMENTO_ESTOQUE` |
| `QTD_MOVIMENTO` | NUMBER(10) | `CP_MOVIMENTO_ESTOQUE.QTD_MOVIMENTACAO_ESTOQUE` transformada: saída = negativo, entrada = positivo |
| `STA_SAIDA_ENTRADA` | CHAR(1) | `CP_TIPO_MOVIMENTO_ESTOQUE.STA_SAIDA_ENTRADA` |

### 1.6 Regra de derivação do depósito
O modelo OLTP de movimento não possui `COD_ESTOQUE` diretamente em `CP_MOVIMENTO_ESTOQUE`.
Por isso, a carga da `FATO_ESTOQUE` deriva o depósito por meio da tabela `CP_ESTOQUE_PRODUTO`, escolhendo o **último estoque conhecido do produto em data menor ou igual à data do movimento**.

---

## PARTE 2 - DDL do Data Warehouse

Os scripts DDL foram separados assim:

- `01_dw_dimensoes_reutilizadas.sql`
  - recria `DIM_TEMPO`
  - recria `DIM_PRODUTO`

- `02_dw_novas_dimensoes_e_fato.sql`
  - cria `DIM_TIPO_MOVIMENTO`
  - cria `DIM_ESTOQUE`
  - cria `FATO_ESTOQUE`
  - define foreign keys

- `03_dw_indices_e_log.sql`
  - cria índices analíticos
  - cria tabela `LOG_ETL`
  - cria procedure `SP_REGISTRA_LOG_ETL`

### Por que usar surrogate keys?
As surrogate keys:
- desacoplam o DW das chaves naturais do OLTP
- melhoram performance de joins
- permitem histórico e padronização do modelo dimensional
- evitam dependência de alterações no sistema transacional

---

## PARTE 3 - ETL em PL/SQL

### Procedures incluídas
- `SP_CARGA_DIM_TEMPO`
- `SP_CARGA_DIM_PRODUTO`
- `SP_CARGA_DIM_TIPO_MOVIMENTO`
- `SP_CARGA_DIM_ESTOQUE`
- `SP_CARGA_FATO_ESTOQUE`
- `SP_ETL_ESTOQUE_COMPLETO`

### Técnicas atendidas
- `MERGE` nas dimensões para idempotência
- `NOT EXISTS` na fato para não duplicar
- `NVL` para tratamento de nulos
- `EXCEPTION` com `ROLLBACK`
- `LOG_ETL` com procedure autônoma
- transformação da quantidade:
  - `S` = multiplica por `-1`
  - `E` = mantém positivo

### Registros "desconhecido"
Para robustez do ETL, as dimensões possuem um membro padrão:
- `DIM_TEMPO` → `1900-01-01`
- `DIM_PRODUTO` → `COD_PRODUTO = -1`
- `DIM_TIPO_MOVIMENTO` → `COD_TIPO_MOVIMENTO_ESTOQUE = -1`
- `DIM_ESTOQUE` → `COD_ESTOQUE = -1`

Esses membros são usados quando houver ausência de chave na origem.

---

## PARTE 4 - Consultas Analíticas no DW

Arquivo:
- `10_consultas_analiticas.sql`

Consultas entregues:
1. Total de movimentações de entrada e saída por produto no último trimestre
2. Saldo atual de cada produto por depósito
3. Top 5 produtos com maior volume de saída no mês atual
4. Comparativo mensal de entradas vs saídas com meses nas colunas
5. Produto com maior variação de estoque entre o mês atual e o anterior

---

## PARTE 5 - Power BI

Documentação:
- `docs/02_power_bi.md`

Conteúdo:
- conexão Oracle no Power BI
- relacionamentos entre fato e dimensões
- medidas DAX pedidas
- layout proposto de dashboard
- visuais recomendados e justificativa

---

## Ordem de execução

### Pré-requisito
- O schema `PF1788` precisa estar acessível pela sua conexão no Oracle.
- As tabelas OLTP `CP_*` podem ser criadas pelo script do modelo e depois populadas pelo script de carga da origem.

### Ordem recomendada
1. `sql/00_modelo_oltp_referencia.sql`  
   Cria o modelo transacional `CP_*`.

2. `sql/00a_carga_origem_pf1788.sql`  
   Corrige a estrutura (`ALTER TABLE`) e popula as tabelas `CP_*` com os dados do schema `PF1788`.

3. `sql/01_dw_dimensoes_reutilizadas.sql`

4. `sql/02_dw_novas_dimensoes_e_fato.sql`

5. `sql/03_dw_indices_e_log.sql`

6. `sql/04_etl_dim_tempo.sql`

7. `sql/05_etl_dim_produto.sql`

8. `sql/06_etl_dim_tipo_movimento.sql`

9. `sql/07_etl_dim_estoque.sql`

10. `sql/08_etl_fato_estoque.sql`

11. `sql/09_etl_orquestrador.sql`

12. `sql/10_consultas_analiticas.sql`

13. `sql/11_validacoes_rapidas.sql`

Para executar tudo de uma vez:
```sql
@sql/99_execucao_completa.sql
```

---

## Execução manual sugerida

```sql
BEGIN
    SP_CARGA_DIM_TEMPO;
    SP_CARGA_DIM_PRODUTO;
    SP_CARGA_DIM_TIPO_MOVIMENTO;
    SP_CARGA_DIM_ESTOQUE;
    SP_CARGA_FATO_ESTOQUE;
END;
/
```

Ou então:

```sql
BEGIN
    SP_ETL_ESTOQUE_COMPLETO;
END;
/
```

---

## Validações rápidas

### Contagem das dimensões
```sql
SELECT COUNT(*) FROM DIM_TEMPO;
SELECT COUNT(*) FROM DIM_PRODUTO;
SELECT COUNT(*) FROM DIM_TIPO_MOVIMENTO;
SELECT COUNT(*) FROM DIM_ESTOQUE;
```

### Contagem da fato
```sql
SELECT COUNT(*) FROM FATO_ESTOQUE;
```

### Ver log
```sql
SELECT *
FROM LOG_ETL
ORDER BY ID_LOG DESC;
```

---

## Observações importantes

1. O depósito na fato é derivado de `CP_ESTOQUE_PRODUTO`, pois a tabela `CP_MOVIMENTO_ESTOQUE` não traz `COD_ESTOQUE` diretamente.
2. O ETL foi escrito para ser **idempotente**, podendo ser executado novamente sem duplicar fatos.
3. As dimensões reaproveitadas (`DIM_TEMPO` e `DIM_PRODUTO`) foram mantidas como parte do repositório para deixar a entrega executável de ponta a ponta.


## Correção aplicada nesta versão

A versão anterior criava o DW e as procedures, mas não incluía explicitamente a etapa de carga da origem `CP_*` a partir do schema `PF1788`. Nesta versão foi adicionado o arquivo `sql/00a_carga_origem_pf1788.sql`, com o bloco corrigido de `ALTER TABLE` e `INSERT INTO ... SELECT * FROM PF1788...`, além de limpeza prévia das tabelas para permitir recarga.

Também foram ajustadas as consultas analíticas para usar a **data máxima disponível na FATO_ESTOQUE**, em vez de depender de `SYSDATE`. Isso evita resultados em branco quando a base de movimentos está em meses anteriores ao mês corrente do servidor.


## Atenção ao executar no SQL Developer
Use **F5 (Run Script)** para rodar os arquivos `.sql`. Se usar apenas **Ctrl+Enter / Run Statement**, você pode criar as procedures sem executá-las, e as dimensões/fato ficarão com `0` linhas.

### Ordem recomendada
1. `sql/00_modelo_oltp_referencia.sql`
2. `sql/00a_carga_origem_pf1788.sql`
3. `sql/01_dw_dimensoes_reutilizadas.sql`
4. `sql/02_dw_novas_dimensoes_e_fato.sql`
5. `sql/03_dw_indices_e_log.sql`
6. `sql/04_etl_dim_tempo.sql`
7. `sql/05_etl_dim_produto.sql`
8. `sql/06_etl_dim_tipo_movimento.sql`
9. `sql/07_etl_dim_estoque.sql`
10. `sql/08_etl_fato_estoque.sql`
11. `sql/11_validacoes_rapidas.sql`

Ou rode direto:
- `sql/98_execucao_passo_a_passo.sql`
- ou `sql/99_execucao_completa.sql`
