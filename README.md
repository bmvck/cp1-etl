# Atividade ETL Manual – Página 7

Este repositório contém a entrega da atividade da página 7 sobre ETL manual, staging, modelo dimensional e carga da tabela fato e dimensões.

## Objetivo

Construir um processo de ETL a partir do modelo transacional `CP_*`, criando uma estrutura analítica capaz de responder perguntas como:

- volume de vendas por estado
- volume de vendas por ano
- volume de vendas por mês
- volume de vendas por vendedor
- volume de vendas por cliente
- produto mais rentável
- perfil de consumo

## Estrutura do repositório

```text
etl-pagina-7-repo/
├── README.md
└── sql/
    ├── 00_modelo_transacional.sql
    ├── 01_correcao_carga_origem.sql
    ├── 02_staging.sql
    ├── 03_dimensoes.sql
    ├── 04_carga_dimensoes.sql
    ├── 05_fato_venda.sql
    ├── 06_carga_fato.sql
    ├── 07_consultas_analiticas.sql
    └── 08_execucao_completa.sql
```

## O que foi ajustado nesta versão

Esta versão do repositório foi corrigida para o cenário encontrado no Oracle SQL Developer:

1. inclusão do script `00_modelo_transacional.sql` para criar as tabelas `CP_*` antes da carga
2. ajuste do `02_staging.sql` para buscar o endereço do pedido e, quando necessário, usar um endereço ativo do cliente como fallback
3. ajuste do `04_carga_dimensoes.sql` para recarregar as dimensões e impedir que a `DIM_LOCAL` receba registros incompletos
4. ajuste do `06_carga_fato.sql` para recarregar a `FATO_VENDA` com joins mais seguros entre staging e dimensões

## Ordem correta de execução

### Opção 1: script único

Execute:

```sql
@08_execucao_completa.sql
```

### Opção 2: por etapas

1. `sql/00_modelo_transacional.sql`
2. `sql/01_correcao_carga_origem.sql`
3. `sql/02_staging.sql`
4. `sql/03_dimensoes.sql`
5. `sql/04_carga_dimensoes.sql`
6. `sql/05_fato_venda.sql`
7. `sql/06_carga_fato.sql`
8. `sql/07_consultas_analiticas.sql`

## Observação importante sobre o script 01

O arquivo `01_correcao_carga_origem.sql` usa comandos como:

```sql
INSERT INTO CP_PAIS SELECT * FROM PF1788.PAIS;
```

Ou seja, ele depende de acesso ao schema `PF1788`.

Se o ambiente da faculdade já possui esse acesso, execute normalmente.
Se não possuir, o script pode retornar `ORA-00942` para as tabelas do schema `PF1788`.

## Visão da solução

### Extração

Os dados são extraídos principalmente de:

- `CP_PEDIDO`
- `CP_ITEM_PEDIDO`
- `CP_CLIENTE`
- `CP_VENDEDOR`
- `CP_PRODUTO`
- `CP_ENDERECO_CLIENTE`
- `CP_CIDADE`
- `CP_ESTADO`
- `CP_PAIS`

### Transformação

Foi criada uma tabela de staging chamada `STG_VENDA`, responsável por:

- consolidar pedidos e itens de pedido
- enriquecer dados com cliente, vendedor, produto e local
- calcular o valor total do item
- preparar os dados para a carga analítica

### Carga

Os dados tratados são carregados em:

- `DIM_TEMPO`
- `DIM_CLIENTE`
- `DIM_VENDEDOR`
- `DIM_PRODUTO`
- `DIM_LOCAL`
- `FATO_VENDA`

## Granularidade da fato

A granularidade da `FATO_VENDA` é:

**1 linha por item de pedido vendido**

Isso permite análise por tempo, cliente, vendedor, produto e localização.

## Regras adotadas

### Valor total do item

```sql
(QTD_ITEM * VAL_UNITARIO_ITEM) - NVL(VAL_DESCONTO_ITEM, 0)
```

### Localização

Na montagem da staging, a localização segue esta prioridade:

1. endereço informado diretamente no pedido
2. endereço ativo do cliente, quando o pedido não trouxer um endereço utilizável

Esse ajuste foi necessário porque, no ambiente testado, a `DIM_LOCAL` estava ficando vazia, o que impedia a carga da `FATO_VENDA`.

## Arquivos do repositório

### `00_modelo_transacional.sql`
Cria o modelo transacional `CP_*`.

### `01_correcao_carga_origem.sql`
Corrige o texto fornecido no enunciado e tenta popular as tabelas `CP_*` com dados de `PF1788`.

### `02_staging.sql`
Cria a tabela `STG_VENDA` com fallback de endereço para preencher cidade, estado e país quando possível.

### `03_dimensoes.sql`
Cria as dimensões com surrogate key.

### `04_carga_dimensoes.sql`
Limpa e recarrega as dimensões a partir da `STG_VENDA`.

### `05_fato_venda.sql`
Cria a tabela fato.

### `06_carga_fato.sql`
Limpa e recarrega a tabela fato usando joins entre a staging e as dimensões.

### `07_consultas_analiticas.sql`
Contém as consultas analíticas da atividade.

### `08_execucao_completa.sql`
Executa toda a sequência recomendada.

## Diagnóstico rápido

Se a `FATO_VENDA` ficar vazia, valide nesta ordem:

```sql
SELECT COUNT(*) FROM STG_VENDA;
SELECT COUNT(*) FROM DIM_LOCAL;
SELECT COUNT(*) FROM FATO_VENDA;
```

Se a `DIM_LOCAL` estiver zerada, verifique:

```sql
SELECT COUNT(*) FROM STG_VENDA WHERE COD_CIDADE IS NOT NULL;
```

## Como subir no Git

```bash
git init
git add .
git commit -m "Entrega atividade ETL pagina 7"
git branch -M main
git remote add origin <URL_DO_REPOSITORIO>
git push -u origin main
```
