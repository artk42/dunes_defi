WITH blockchains_filter AS (
    SELECT blockchain
    FROM evms.info
    WHERE name = '{{Blockchain}}'
    )

SELECT date_trunc('day', block_time) AS time
, approx_percentile(gas_price, 0.5)/POWER(10, 9) AS median_gas
FROM evms.transactions txs
INNER JOIN blockchains_filter bf ON bf.blockchain=txs.blockchain
WHERE block_time > NOW() - interval '6' month
AND block_time < date_trunc('day', NOW())
GROUP BY 1