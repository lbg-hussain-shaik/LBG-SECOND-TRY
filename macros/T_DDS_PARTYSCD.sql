
{% macro T_DDS_PARTYSCD(PARTY_EXT_TABLE_NAME) %}
{%- set var_ext_job_name = dbt.string_literal(PARTY_EXT_TABLE_NAME) -%}

WITH

CURR_DATA AS 
(
    SELECT TEMP_DATA.*,
        {{ dbt_utils.generate_surrogate_key(['PARTY_ID', 'SOURCE_PARTY_NAME','SOURCE_PARTY_CODE'])
        }} as UNQ_HASH_KEY
    FROM
        (
            SELECT 
              PARTY_ID,
              SOURCE_PARTY_NAME,
              SOURCE_PARTY_CODE,
              SOURCE_SYSTEM_IDENTIFIER
            FROM
                    {{ ref(PARTY_EXT_TABLE_NAME) }} PARTY_CMD
              --  {{source('test_01','T_DDS_PARTY_CMD')}}  PARTY_CMD
        ) TEMP_DATA
),

PREV_DATA AS 
(
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['PARTY_ID', 'PARTY_NAME','SOURCE_PARTY_CODE'])
        }} as UNQ_HASH_KEY
    FROM
        (
            SELECT PARTY_ID,PARTY_NAME,SOURCE_PARTY_CODE,SOURCE_SYSTEM_IDENTIFIER FROM
                (SELECT PARTY_ID,PARTY_NAME,SOURCE_PARTY_CODE,SOURCE_SYSTEM_IDENTIFIER, ROW_NUMBER() OVER (PARTITION BY PARTY_ID ORDER BY RDH_INSERT_TIMESTAMP DESC) as TP 
            FROM {{source('test_01','T_DDS_PARTY')}})  where TP=1
    )
)

    SELECT  
        CURR_DATA.PARTY_ID,
        CURR_DATA.SOURCE_PARTY_NAME AS PARTY_NAME,
        CURR_DATA.SOURCE_PARTY_CODE,
        CURR_DATA.SOURCE_SYSTEM_IDENTIFIER,
        PARSE_TIMESTAMP('%F %X', '{{ run_started_at.strftime("%F %X") }}') AS RDH_INSERT_TIMESTAMP,
        CAST(NULL AS DATE) AS RDH_CLOSURE_TIMESTAMP,
        CAST(NULL AS DATE) AS BUSINESS_START_DATE,
        CAST(NULL AS DATE) AS BUSINESS_END_DATE,
        '{{ this.name }}' AS JOB_NAME,
        CAST(NULL AS STRING) AS SCHEDULER_NAME,
    FROM 
        CURR_DATA
    LEFT OUTER JOIN 
        PREV_DATA
    ON 
        TRIM(PREV_DATA.UNQ_HASH_KEY) = TRIM(CURR_DATA.UNQ_HASH_KEY)
    WHERE 
        PREV_DATA.UNQ_HASH_KEY IS NULL

{% endmacro %}

