{{ config(
    schema = 'nft_polygon',
    alias = 'base_trades',
    materialized = 'view'
    )
}}
-- (project, project_version, model)
{% set nft_models = [
     ref('aavegotchi_polygon_base_trades')
    ,ref('aurem_polygon_base_trades')
    ,ref('dew_polygon_base_trades')
    ,ref('decentraland_polygon_base_trades')
    ,ref('element_polygon_base_trades')
    ,ref('fractal_polygon_base_trades')
    ,ref('opensea_v2_polygon_base_trades')
    ,ref('rarible_polygon_base_trades')
    ,ref('tofu_polygon_base_trades')
    ,ref('magiceden_polygon_base_trades')
    ,ref('magiceden_v2_polygon_base_trades')
    ,ref('opensea_v3_polygon_base_trades')
    ,ref('opensea_v4_polygon_base_trades')
] %}

with base_union as (
SELECT * FROM  (
{% for nft_model in nft_models %}
    SELECT
        blockchain,
        project,
        project_version,
        block_time,
        block_date,
        block_month,
        block_number,
        tx_hash,
        project_contract_address,
        trade_category,
        trade_type,
        buyer,
        seller,
        nft_contract_address,
        nft_token_id,
        nft_amount,
        price_raw,
        currency_contract,
        platform_fee_amount_raw,
        royalty_fee_amount_raw,
        platform_fee_address,
        royalty_fee_address,
        sub_tx_trade_id,
        tx_from,
        tx_to,
        tx_data_marker
    FROM {{ nft_model }}
    {% if not loop.last %}
    UNION ALL
    {% endif %}
    {% endfor %}
    )
)
select * from base_union