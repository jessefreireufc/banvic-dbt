with
fonte_agencias as (
    select *
    from {{ source('erp', 'agencias') }}
),

renomeado as (
    select
        cast(cod_agencia as int) as pk_agencia
        , nome as nome_agencia
        , tipo_agencia as tipo_agencia
        , cast(cod_localidade as int) as fk_localidade
    from fonte_agencias
)

select *
from renomeado