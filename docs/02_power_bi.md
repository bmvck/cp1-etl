# Power BI - FATO_ESTOQUE

## Conexão com Oracle
1. Abra o Power BI Desktop.
2. Clique em **Obter Dados**.
3. Escolha **Banco de Dados Oracle**.
4. Informe o servidor no formato `hostname:porta/servico`.
5. Selecione as tabelas:
   - `FATO_ESTOQUE`
   - `DIM_TEMPO`
   - `DIM_PRODUTO`
   - `DIM_TIPO_MOVIMENTO`
   - `DIM_ESTOQUE`

## Relacionamentos esperados
- `DIM_TEMPO[SK_TEMPO]` 1:N `FATO_ESTOQUE[SK_TEMPO]`
- `DIM_PRODUTO[SK_PRODUTO]` 1:N `FATO_ESTOQUE[SK_PRODUTO]`
- `DIM_TIPO_MOVIMENTO[SK_TIPO_MOVIMENTO]` 1:N `FATO_ESTOQUE[SK_TIPO_MOVIMENTO]`
- `DIM_ESTOQUE[SK_ESTOQUE]` 1:N `FATO_ESTOQUE[SK_ESTOQUE]`

Direção do filtro: **única**, da dimensão para a fato.

## Medidas DAX

```DAX
Total Entradas =
CALCULATE(
    SUM(FATO_ESTOQUE[QTD_MOVIMENTO]),
    DIM_TIPO_MOVIMENTO[STA_SAIDA_ENTRADA] = "E"
)
```

```DAX
Total Saidas =
CALCULATE(
    ABS(SUM(FATO_ESTOQUE[QTD_MOVIMENTO])),
    DIM_TIPO_MOVIMENTO[STA_SAIDA_ENTRADA] = "S"
)
```

```DAX
Saldo Liquido = [Total Entradas] - [Total Saidas]
```

```DAX
Saldo Medio Periodo =
AVERAGEX(
    VALUES(DIM_TEMPO[NUM_MES]),
    [Saldo Liquido]
)
```

```DAX
Giro de Estoque = DIVIDE([Total Saidas], [Saldo Medio Periodo])
```

## Layout do dashboard

### Página 1 - Visão Geral
**Visuais sugeridos:**
- **Cards/KPIs** para `Total Entradas`, `Total Saidas` e `Saldo Liquido`
- **Gráfico de linhas** para movimentação mensal
- **Gráfico de barras horizontais** para top produtos movimentados

**Por quê?**
- KPI destaca números principais
- Linha mostra evolução temporal
- Barras facilitam ranking

### Página 2 - Análise por depósito
**Visuais sugeridos:**
- **Matriz** com `Depósito x Produto`
- **Gráfico de colunas agrupadas** para comparar depósitos
- **Tabela detalhada** para apoio analítico

**Por quê?**
- Matriz é ideal para cruzamento entre duas dimensões
- Colunas agrupadas facilitam comparação entre depósitos
- Tabela ajuda a detalhar registros e auditoria

## Slicers obrigatórios
- Período (`Ano/Mês`)
- Produto
- Depósito
- Tipo de Movimento


<img width="594" height="454" alt="image" src="https://github.com/user-attachments/assets/105015b9-9e51-4090-876b-58e6cd5b8065" />

<img width="432" height="497" alt="image" src="https://github.com/user-attachments/assets/564c7b14-306d-46cc-96dd-b38f6f64a8b9" />


