# Setup de Execução (Databricks + dbt) — fazer DEPOIS de estudar a teoria

> Este arquivo é um **lembrete de como rodar de fato** o projeto. Não é necessário
> durante o estudo de SQL via chat. Use quando quiser executar queries/seed/run no banco.

---

## Pré-requisitos

- Conta Databricks (a do trabalho já serve — catálogo `mesh_dev_db`, schema base `dev_carlos_castro_dbt`)
- `dbt-databricks` instalado (`pip install dbt-databricks`)
- dbt no PATH: `C:\Users\Jesse\AppData\Roaming\Python\Python314\Scripts`

---

## 1. Criar o `profiles.yml` (FORA do repo)

Local: `C:\Users\Jesse\.dbt\profiles.yml`

```yaml
default:
  target: dev
  outputs:
    dev:
      type: databricks
      catalog: mesh_dev_db
      schema: dev_carlos_castro_dbt
      host: <SEU_WORKSPACE>.cloud.databricks.com
      http_path: /sql/1.0/warehouses/<WAREHOUSE_ID>
      token: <SEU_TOKEN_PESSOAL>
      threads: 4
```

Onde pegar:
- **host** → URL do workspace (sem `https://`)
- **http_path** → SQL → Warehouses → seu warehouse → Connection details
- **token** → Settings (⚙️) → Developer → Access tokens → Generate

⚠️ **NUNCA** commite o `profiles.yml` (tem token = senha). Ele fica fora do repo.

---

## 2. Validar conexão

```bash
cd <pasta do banvic-dbt>
dbt debug
```
Se der OK, a ponte está feita.

---

## 3. Carregar as tabelas do Banvic (seeds)

As seeds estão desabilitadas por padrão em `dbt_project.yml` (`+enabled: false`).
Carregar uma por uma:
```bash
dbt seed -s clientes
dbt seed -s contas
dbt seed -s transacoes
dbt seed -s agencias
dbt seed -s localidades
dbt seed -s colaboradores
dbt seed -s colaborador_agencia
dbt seed -s propostas_credito
```
(Schemas criados: `mesh_dev_db.erp_banvic` para as seeds.)

---

## 4. Rodar models e testes

```bash
dbt run --select staging        # camada staging
dbt run --select +marts.fact_transacoes
dbt test                         # validação de qualidade
```

---

## 5. Onde rodar queries ad-hoc (SQL puro do Módulo 2)

No Databricks: **SQL → Query Editor** → aponte pro catálogo `mesh_dev_db` e pro schema
das tabelas (`erp_banvic` após o seed, ou `dev_carlos_castro_dbt_staging` após o run).
É lá que você pratica os `SELECT`/`JOIN`/`UNION` do caderno `modulo2_sql.md`.

> Enquanto estuda só a teoria, não precisa de nada disso — o chat já serve.
