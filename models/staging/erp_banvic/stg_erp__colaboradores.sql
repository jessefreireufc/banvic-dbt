with
fonte_colaboradores as (
    select *
    from {{ source('erp', 'colaboradores') }}
),

renomeado as (
    select
        cast(cod_colaborador as int) as pk_colaborador
        , primeiro_nome || ' ' || ultimo_nome as nome_colaborador
        , email as email_colaborador
        , cast(cod_gerente as int) as fk_gerente
    from fonte_colaboradores
)

select *
from renomeado