---Group hosts by hardware info
SELECT
  cpu_number,
  id AS host_id,
  total_mem
FROM
  host_info
ORDER BY
  cpu_number,
  total_mem DESC;

---Average used memory in percentage over 5 mins interval for each host.

SELECT
  host_id,
  hostname,
  time_bucket,
  AVG(used_mem_percentage) AS avg_used_mem_percentage
FROM (
  SELECT
    u.host_id,
    h.hostname,
    date_trunc('hour', u.timestamp)
      + (FLOOR(EXTRACT(MINUTE FROM u.timestamp) / 5) * 5)
        * INTERVAL '1 minute' AS time_bucket,
    ((h.total_mem - u.memory_free) / h.total_mem) * 100.0
      AS used_mem_percentage
  FROM
    host_usage u
  JOIN
    host_info h
      ON u.host_id = h.id
) AS usage_with_buckets
GROUP BY
  host_id,
  hostname,
  time_bucket
ORDER BY
  host_id,
  time_bucket;
