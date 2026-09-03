with
fonte_transacoes as (
    select *
    from {{ source('erp', 'transacoes') }}
),

renomeado as (
    select
        cast(cod_transacao as int) as pk_transacao
        , cast(num_conta as int) as fk_conta
        , cast(data_transacao as timestamp) as ts_transacao
        , nome_transacao
        , cast(valor_transacao as numeric(32,2)) as valor_transacao
    from fonte_transacoes
)

select *
from renomeado
