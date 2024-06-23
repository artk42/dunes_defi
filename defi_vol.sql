with timeframe as (
select 
case 
when '{{DEX Granularity}}' = 'monthly' then date('2018-11-02')
when '{{DEX Granularity}}' = 'weekly' then now() - interval '1' year
when '{{DEX Granularity}}' = 'daily' then now() - interval '3' month
end as start_date,
case 
when '{{DEX Granularity}}' = 'monthly' then 'month'
when '{{DEX Granularity}}' = 'weekly' then 'week'
when '{{DEX Granularity}}' = 'daily' then 'day'
end as interval
)

SELECT
    date_trunc((select interval from timeframe),block_date) as time,
    SUM(amount_usd) as volume,
    count(distinct tx_from) as trader
FROM dex.trades                                                                           
WHERE amount_usd <1000000000 --ignore anomaly
AND date(block_time) >= (select start_date from timeframe) 
AND blockchain = 'ethereum'
group by 1