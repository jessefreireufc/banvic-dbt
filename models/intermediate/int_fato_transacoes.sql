with
transacoes as (
    select *
    from {{ ref('stg_erp__transacoes') }}
),

contas as (
    select *
    from {{ ref('stg_erp__contas') }}
),

datas as (
    select *
    from {{ ref('int_dimensao_datas') }}
),

fato_transacoes as (
    select
        transacoes.pk_transacao
        , transacoes.fk_conta
        , contas.fk_cliente
        , contas.fk_agencia
        , contas.fk_colaborador
        , datas.pk_data as fk_data
        , transacoes.ts_transacao
        , transacoes.nome_transacao
        , transacoes.valor_transacao
    from transacoes
    left join contas on transacoes.fk_conta = contas.pk_conta
    left join datas on cast(transacoes.ts_transacao as date) = datas.dt_data
)

select *
from fato_transacoes
