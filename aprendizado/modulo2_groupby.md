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

## 4. Exemplos no Banvic (preencher/praticar)

- [ ] Total de contas por `TIPO_CONTA`
- [ ] Saldo médio por agência (`contas` + `agencias`)
- [ ] Clientes com mais de 1 conta (`HAVING COUNT(*) > 1`)
- [ ] Soma de `VALOR_TRANSACAO` por `NOME_TRANSACAO` (tabela `transacoes`)

---

## 5. Window Functions (próximo após agregações)

`FUNCAO() OVER (PARTITION BY ... ORDER BY ...)` — calcula sobre uma "janela" sem
colapsar as linhas. Ex: `ROW_NUMBER()`, `RANK()`, `SUM() OVER (...)`.

---

## Checklist
- [ ] Escrever GROUP BY simples
- [ ] Usar HAVING com agregação
- [ ] Diferenciar COUNT(*) de COUNT(col)
- [ ] Primeira Window Function no Banvic
