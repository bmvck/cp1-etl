# Atividade ETL Manual – Página 7

Este repositório contém a entrega da atividade da página 7 sobre **ETL manual**, **staging**, **modelo dimensional** e **carga da tabela fato e dimensões**.

## Objetivo da atividade

Construir um processo de ETL a partir do modelo transacional `CP_*`, criando uma estrutura analítica capaz de responder perguntas de negócio como:

- volume de vendas por estado
- volume de vendas por ano
- volume de vendas por mês
- volume de vendas por vendedor
- volume de vendas por cliente
- produto mais rentável
- perfil de consumo

O material de apoio da aula destaca que o ETL é composto por **Extração, Transformação e Carga**, e que a modelagem dimensional usa **fatos**, **dimensões** e **métricas**, normalmente em **Star Schema**. Também ressalta que as dimensões devem preferencialmente usar **surrogate keys** para melhorar o desempenho e desacoplar o DW da chave natural da origem.

## Estrutura do repositório

```text
etl-pagina-7-repo/
├── README.md
└── sql/
    ├── 01_correcao_carga_origem.sql
    ├── 02_staging.sql
    ├── 03_dimensoes.sql
    ├── 04_carga_dimensoes.sql
    ├── 05_fato_venda.sql
    ├── 06_carga_fato.sql
    ├── 07_consultas_analiticas.sql
    └── 08_execucao_completa.sql
```

## Visão geral da solução

### 1. Extração
Os dados são extraídos das tabelas do sistema transacional, principalmente:

- `CP_PEDIDO`
- `CP_ITEM_PEDIDO`
- `CP_CLIENTE`
- `CP_VENDEDOR`
- `CP_PRODUTO`
- `CP_ENDERECO_CLIENTE`
- `CP_CIDADE`
- `CP_ESTADO`
- `CP_PAIS`

### 2. Transformação
Foi criada uma tabela de **staging** chamada `STG_VENDA`, responsável por:

- consolidar pedidos e itens de pedido
- enriquecer dados com cliente, vendedor, produto e local
- calcular o valor total do item
- preparar os dados para carga no modelo dimensional

### 3. Carga
Os dados tratados são carregados nas dimensões:

- `DIM_TEMPO`
- `DIM_CLIENTE`
- `DIM_VENDEDOR`
- `DIM_PRODUTO`
- `DIM_LOCAL`

e na tabela fato:

- `FATO_VENDA`

## Granularidade da fato

A granularidade escolhida para `FATO_VENDA` é:

**1 linha para cada item de pedido vendido**

Essa decisão permite consultas detalhadas por:

- tempo
- cliente
- vendedor
- produto
- localização

e também possibilita agregações por ano, mês, estado, cliente e vendedor.

## Modelo dimensional proposto

### Fato
`FATO_VENDA`

Principais métricas:
- `QTD_ITEM`
- `VAL_UNITARIO`
- `VAL_DESCONTO`
- `VAL_TOTAL_ITEM`

### Dimensões
- `DIM_TEMPO`
- `DIM_CLIENTE`
- `DIM_VENDEDOR`
- `DIM_PRODUTO`
- `DIM_LOCAL`

## Ordem de execução

Execute os scripts nesta ordem:

1. `sql/01_correcao_carga_origem.sql`
2. `sql/02_staging.sql`
3. `sql/03_dimensoes.sql`
4. `sql/04_carga_dimensoes.sql`
5. `sql/05_fato_venda.sql`
6. `sql/06_carga_fato.sql`
7. `sql/07_consultas_analiticas.sql`

Se preferir, execute apenas:

- `sql/08_execucao_completa.sql`

## Detalhamento de cada arquivo

### `01_correcao_carga_origem.sql`
Contém:
- ajustes iniciais na origem
- correção dos comandos fornecidos no enunciado
- carga das tabelas `CP_*` a partir do schema `PF1788`

Observação importante:
o enunciado tinha erros de digitação como `SEeLECT`, `FfROM`, `SELfECT`, `CbP_ESTOQUE`, `CP_PEDIDOf`, `CP_ITEM_PEDfIDO`, entre outros. Esse arquivo já contém a versão corrigida.

### `02_staging.sql`
Cria a tabela `STG_VENDA` com os dados integrados para o ETL.  
Nessa etapa são feitas as junções principais entre pedido, item, cliente, vendedor, produto e local.

### `03_dimensoes.sql`
Cria todas as tabelas dimensionais com surrogate key.

### `04_carga_dimensoes.sql`
Popula as dimensões a partir da `STG_VENDA`.

### `05_fato_venda.sql`
Cria a tabela `FATO_VENDA`.

### `06_carga_fato.sql`
Carrega a `FATO_VENDA` relacionando as chaves naturais da staging às surrogate keys das dimensões.

### `07_consultas_analiticas.sql`
Traz as consultas para responder as perguntas do exercício.

### `08_execucao_completa.sql`
Script agregador com a ordem de execução recomendada.

## Regras adotadas no ETL

### Cálculo do valor total do item
Foi adotada a seguinte regra:

```sql
(QTD_ITEM * VAL_UNITARIO_ITEM) - NVL(VAL_DESCONTO_ITEM, 0)
```

### Cancelamento
O campo `DAT_CANCELAMENTO` foi mantido na staging para permitir que o professor ou a equipe escolha, se desejar, filtrar apenas pedidos válidos em versões futuras da carga.

### Tempo
A dimensão tempo foi baseada em `DAT_PEDIDO`, permitindo análise por:
- dia
- mês
- ano
- nome do mês

### Local
A dimensão local foi construída com base em:
- cidade
- estado
- país

## Consultas analíticas incluídas

O arquivo `07_consultas_analiticas.sql` responde:

- vendas por estado
- vendas por ano
- vendas por mês
- vendas por vendedor
- vendas por cliente
- produto mais rentável
- perfil de consumo

## Como subir no Git

Exemplo:

```bash
git init
git add .
git commit -m "Entrega atividade ETL pagina 7"
git branch -M main
git remote add origin <URL_DO_REPOSITORIO>
git push -u origin main
```

## Observações finais

Esta solução foi construída em linha com os conceitos apresentados na aula:

- ETL manual
- staging area
- modelo dimensional
- star schema
- surrogate keys
- separação entre camada transacional e camada analítica

Ela está pronta para ser usada como entrega acadêmica e também como base para evolução futura em ferramentas de BI.
