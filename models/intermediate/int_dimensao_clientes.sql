with
clientes as (
    select *
    from {{ ref('stg_erp__clientes') }}
),

localidades as (
    select *
    from {{ ref('stg_erp__localidades') }}
),

contas as (
    select *
    from {{ ref('stg_erp__contas') }}
),

clientes_enriquecido as (
    select
        clientes.pk_cliente
        , clientes.nome_cliente
        , clientes.email_cliente
        , clientes.tipo_cliente
        , clientes.cpfcnpj_cliente
        , clientes.ts_inclusao
        , clientes.data_nascimento_cliente
        , clientes.endereco_cliente
        , clientes.cep_cliente
        , localidades.cidade as cidade_cliente
        , localidades.uf as uf_cliente
        , contas.fk_agencia as cod_agencia
        , contas.fk_colaborador as cod_colaborador
        , cast(contas.ts_abertura_conta as date) as data_abertura
    from clientes
    left join localidades on clientes.fk_localidade = localidades.pk_localidade
    left join contas on clientes.pk_cliente = contas.fk_cliente
)

select *
from clientes_enriquecido