# Módulo 2 — SQL: Caderno de Estudos

> Notas vivas do Módulo 2 (Consultando dados com SQL). Atualizar a cada conceito novo.
> Referência prática: banco fictício **Banvic** (tabelas em `seeds/banvic/`).

---

## 1. Aliases (renomeação / apelidos)

A sintaxe é sempre `objeto apelido` (o `AS` é opcional).

| Onde | Exemplo | Efeito |
|------|---------|--------|
| **Tabela** (FROM/JOIN) | `FROM contas c` | apelida a tabela para referenciar colunas |
| **Coluna** (SELECT) | `c.SALDO_TOTAL AS saldo` | renomeia a **saída** exibida |
| **CTE** | `WITH contas_pf AS (SELECT ...)` | nomeia uma subquery inteira |
| **Subquery** (FROM) | `FROM (SELECT ...) t` | tabela derivada precisa de apelido |

Exemplo Banvic (CTE + tabela + coluna):
```sql
WITH contas_ativas AS (
    SELECT NUM_CONTA, COD_CLIENTE, SALDO_TOTAL
    FROM contas
    WHERE SALDO_TOTAL > 0
)
SELECT ca.NUM_CONTA                              AS num_conta,
       cl.PRIMEIRO_NOME || ' ' || cl.ULTIMO_NOME AS nome_cliente,
       ca.SALDO_TOTAL                            AS saldo
FROM contas_ativas ca
INNER JOIN clientes cl
    ON cl.COD_CLIENTE = ca.COD_CLIENTE
ORDER BY ca.SALDO_TOTAL DESC;
```
> `||` é o operador de concatenação no Databricks/Spark SQL.

---

## 2. Ordem de ESCRITA vs EXECUÇÃO

**Escrita (sintaxe fixa):**
```
SELECT → FROM → JOIN → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT
```

**Execução (lógica do banco):**
```
FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

Regras práticas que vêm daí:
- `WHERE` filtra **antes** de agrupar; `HAVING` filtra o **grupo** (depois).
- `WHERE` **não** aceita função agregada (`COUNT`, `SUM`...).
- Alias do `SELECT` **não** existe em `WHERE`/`GROUP BY`, mas **existe** em `ORDER BY`.

```sql
-- ERRADO no Spark SQL:
SELECT SALDO_TOTAL AS saldo FROM contas WHERE saldo > 0;
-- CERTO:
SELECT SALDO_TOTAL AS saldo FROM cont…… WHERE SALDO_TOTAL > 0 ORDER BY saldo;
```

---

## 3. INNER JOIN — interseção (∩)

Só traz linhas onde a chave combina **nos dois** lados. O que não tem par, some.

```sql
SELECT c.NUM_CONTA, cl.PRIMEIRO_NOME
FROM contas c
INNER JOIN clientes cl
    ON cl.COD_CLIENTE = c.COD_CLIENTE;
```
`ON` = regra do encontro (a FK em comum). No Banvic: `COD_CLIENTE`, `COD_AGENCIA`, `NUM_CONTA`.

Esquema:
```
contas:   [A, B, C, D]
clientes: [B, C, E]
INNER → [B, C]
```

---

## 4. LEFT vs RIGHT JOIN

| Tipo | Traz |
|------|------|
| **INNER** | só o que bate nos dois |
| **LEFT** | **tudo da esquerda** + o que casar da direita (NULL se não achar) |
| **RIGHT** | tudo da direita + o que casar da esquerda |
| **FULL** | tudo dos dois (NULL onde não bater) |

**"LEFT" é literal:** é a tabela à esquerda do `JOIN` (a do `FROM`).
```sql
FROM clientes cl LEFT JOIN contas c   -- cl nunca some
```
`RIGHT JOIN` é redundante (sempre dá pra reescrever como LEFT trocando a ordem). Por isso quase ninguém usa.

Esquema:
```
contas:   [A,B,C,D]   clientes: [B,C,E]
LEFT  (de contas)  → [A,B,C,D]
RIGHT (de contas)  → [B,C,E]
```

---

## 5. UNION vs UNION ALL — empilha (vertical)

Diferente do JOIN (horizontal, colunas lado a lado), UNION **empilha linhas**.

| | Efeito | Conjunto |
|--|--------|----------|
| **UNION** | empilha e **remove duplicatas** | união ∪ |
| **UNION ALL** | empilha **tudo** (inclusive repetidos) | concatena listas |

Regras obrigatórias: mesma **quantidade**, **ordem** e **tipos** de colunas.

Exemplo Banvic (clientes + colaboradores têm `PRIMEIRO_NOME, ULTIMO_NOME, EMAIL`):
```sql
SELECT PRIMEIRO_NOME, ULTIMO_NOME, EMAIL, 'cliente' AS tipo FROM clientes
UNION ALL
SELECT PRIMEIRO_NOME, ULTIMO_NOME, EMAIL, 'colaborador' AS tipo FROM colaboradores;
```

**UNION (vertical) vs JOIN (horizontal):**
- JOIN: colunas das tabelas na mesma linha.
- UNION: linhas das tabelas empilhadas.

---

## Checklist de fixação
- [ ] Escrever query com alias de tabela + coluna
- [ ] Escrever CTE
- [ ] INNER JOIN entre 2 tabelas Banvic
- [ ] LEFT JOIN mostrando clientes sem conta (NULL)
- [ ] UNION ALL de clientes + colaboradores
