# Módulo 2 — GROUP BY e Funções Agregadas

> Continuação do caderno de SQL. Preencher conforme avança nos estudos.

---

## 1. O que é agregação

Transforma **várias linhas** de um grupo em **um único valor** de resumo.

| Função | O que faz |
|--------|-----------|
| `COUNT(*)` | conta linhas (inclui nulas) |
| `COUNT(col)` | conta valores não-nulos da coluna |
| `SUM(col)` | soma |
| `AVG(col)` | média |
| `MIN(col)` / `MAX(col)` | mínimo / máximo |

---

## 2. GROUP BY — particiona o conjunto em subconjuntos

Quebra a tabela em grupos pela(s) coluna(s) indicada. **Toda coluna do SELECT que não é agregada PRECISA estar no GROUP BY.**

```sql
SELECT COD_CLIENTE, COUNT(*) AS qtd_contas
FROM contas
GROUP BY COD_CLIENTE;
```

Esquema (teoria dos conjuntos): o conjunto total é particionado em subconjuntos disjuntos por `COD_CLIENTE`.

---

## 3. WHERE vs HAVING (revisão da ordem de execução)

- `WHERE` filtra **linhas** ANTES de agrupar (não aceita agregação).
- `HAVING` filtra **grupos** DEPOIS de agrupar (aceita agregação).

```sql
SELECT COD_CLIENTE, COUNT(*) AS qtd
FROM contas
WHERE TIPO_CONTA = 'PF'
GROUP BY COD_CLIENTE
HAVING COUNT(*) > 1;
```

---

## 4. Exemplos no Banvic (já validados)

> Sintaxe Databricks/Spark SQL. Colunas em MAIÚSCULAS (igual ao schema).
> Mais exemplos em `Módulo 0 - Banco de Dados BanVic/banvic_queries.md`.

**GROUP BY simples — saldo médio por UF:**
```sql
SELECT l.UF,
       COUNT(*)                     AS NUM_CONTAS,
       ROUND(AVG(c.SALDO_TOTAL), 2) AS SALDO_MEDIO
FROM erp_banvic.contas c
JOIN erp_banvic.clientes cl ON cl.COD_CLIENTE = c.COD_CLIENTE
JOIN erp_banvic.localidades l ON l.COD_LOCALIDADE = cl.COD_LOCALIDADE
GROUP BY l.UF
ORDER BY SALDO_MEDIO DESC;
```

**WHERE (linhas) vs HAVING (grupo) — clientes com mais de 1 conta:**
```sql
SELECT COD_CLIENTE, COUNT(*) AS QTD_CONTAS
FROM erp_banvic.contas
WHERE TIPO_CONTA = 'PF'        -- filtra LINHAS antes de agrupar
GROUP BY COD_CLIENTE
HAVING COUNT(*) > 1;            -- filtra o GRUPO depois de agrupar
```

**COUNT(*) vs COUNT(col) — FK órfã (conta sem cliente):**
```sql
SELECT COUNT(*)                AS total_linhas,
       COUNT(COD_CLIENTE)      AS com_cliente
FROM erp_banvic.contas;
-- diferença = contas com COD_CLIENTE nulo (COUNT(col) ignora nulos)
```

**Agregação + GROUP BY — volume de transações por tipo:**
```sql
SELECT NOME_TRANSACAO,
       COUNT(*)                       AS QTD,
       ROUND(SUM(VALOR_TRANSACAO), 2) AS TOTAL
FROM erp_banvic.transacoes
GROUP BY NOME_TRANSACAO
ORDER BY QTD DESC;
```

## 5. Exercícios para praticar

- [x] Total de contas por `TIPO_CONTA`
- [ ] Saldo médio por agência (`contas` + `agencias`)
- [x] Clientes com mais de 1 conta (`HAVING COUNT(*) > 1`)
- [x] Soma de `VALOR_TRANSACAO` por `NOME_TRANSACAO` (tabela `transacoes`)

---

## 5. Window Functions (próximo após agregações)

`FUNCAO() OVER (PARTITION BY ... ORDER BY ...)` — calcula sobre uma "janela" sem
colapsar as linhas. Ex: `ROW_NUMBER()`, `RANK()`, `SUM() OVER (...)`.

---

## Checklist
- [x] Escrever GROUP BY simples (saldo médio por UF)
- [x] Usar HAVING com agregação (clientes c/ >1 conta)
- [x] Diferenciar COUNT(*) de COUNT(col) (FK órfã)
- [ ] Primeira Window Function no Banvic (ver `RANK() OVER` em banvic_queries.md)
