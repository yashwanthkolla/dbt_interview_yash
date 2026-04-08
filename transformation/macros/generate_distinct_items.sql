{% macro generate_distinct_items(table_name, column_name) -%}

    {%- set query_to_run -%}
     select distinct {{column_name}} from {{table_name}}
    {% endset%}

    {% if execute %}
    {% set distinct_items = run_query(query_to_run).columns[0].values() %}

    {%- endif -%}

    {{ return(distinct_items) }}

{%- endmacro %}