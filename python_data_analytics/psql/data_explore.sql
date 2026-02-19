-- Show table schema
\d+ retail;

-- Q1: Show first 10 rows
SELECT * FROM retail LIMIT 10;

-- Q2: Check # of records
SELECT COUNT(*) FROM retail;

-- Q3: number of clients (e.g. unique client ID)
SELECT COUNT(DISTINCT customer_id) FROM retail;

-- 04:invoice date range (e.g. max/min dates)
SELECT MIN(invoice_date), MAX(invoice_date) FROM retail;

-- Q5: number of unique stock codes
SELECT COUNT(DISTINCT stock_code) FROM retail;

-- Q6: average invoice amount (exclude negative invoices)
SELECT AVG(invoice_total)
FROM (
  SELECT invoice_no,
         SUM(unit_price * quantity) AS invoice_total
  FROM retail
  GROUP BY invoice_no
  HAVING SUM(unit_price * quantity) > 0
) t;

-- Q7: total revenue
SELECT SUM(unit_price * quantity) FROM retail;

-- Q8: total revenue by YYYYMM
SELECT TO_CHAR(invoice_date, 'YYYYMM') AS yyyymm,
       SUM(unit_price * quantity)
FROM retail
GROUP BY yyyymm
ORDER BY yyyymm;

