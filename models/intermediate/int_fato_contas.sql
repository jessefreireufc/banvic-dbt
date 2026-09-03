with
contas as (
    select *
    from {{ ref('stg_erp__contas') }}
),

selecionar_colunas as (
    select
        pk_conta
        , fk_cliente
        , fk_agencia
        , saldo_total
        , saldo_disponivel
        , ts_ultimo_lancamento
    from contas
)

select *
from contas