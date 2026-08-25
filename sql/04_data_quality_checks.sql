USE RetailDataQuality;
GO

-- 1. Completeness
-- Check NULL transaction IDs
SELECT
    COUNT(*) AS null_transaction_ids
FROM dbo.fact_sales
WHERE transaction_id IS NULL;

-- Check NULL product IDs
SELECT
    COUNT(*) AS null_product_ids
FROM dbo.fact_sales
WHERE product_id IS NULL;

-- Check all important fact-table fields together
SELECT
    COUNT(*) AS total_records,

    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END)
        AS null_transaction_id,

    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END)
        AS null_transaction_date,

    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)
        AS null_customer_id,

    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END)
        AS null_product_id,

    SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END)
        AS null_store_id,

    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END)
        AS null_quantity,

    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END)
        AS null_unit_price,

    SUM(CASE WHEN net_sales IS NULL THEN 1 ELSE 0 END)
        AS null_net_sales
FROM dbo.fact_sales;

-- 2.Uniqueness
-- Are transaction IDs nuique
SELECT
    transaction_id,
    COUNT(*) AS record_count
FROM dbo.fact_sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- 3 Dimension uniqueness
-- Check product IDs
SELECT
    product_id,
    COUNT(*) AS record_count
FROM dbo.dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Check customer IDs
SELECT
    customer_id,
    COUNT(*) AS record_count
FROM dbo.dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check store IDs
SELECT
    customer_id,
    COUNT(*) AS record_count
FROM dbo.dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 4. Validity checks
-- Are values within acceptable business ranges

-- Quantity validation
SELECT
    COUNT(*) AS invalid_quantity
FROM dbo.fact_sales
WHERE quantity <= 0;

-- Unit price validation
SELECT
    COUNT(*) AS invalid_unit_price
FROM dbo.fact_sales
WHERE unit_price <= 0;

-- Discount validation
SELECT
    COUNT(*) AS invalid_discount
FROM dbo.fact_sales
WHERE discount_amount < 0
    OR discount_amount > gross_sales;

-- Cost validation
SELECT
    COUNT(*) AS invalid_cost
FROM dbo.fact_sales
WHERE unit_price < 0
    OR cost_amount < 0;


-- 5. Date validation
-- A retail transaction shouldn't occur in the  future

SELECT
    COUNT(*) AS future_transactions
FROM dbo.fact_sales
WHERE transaction_date > CAST(GETDATE() AS date);

-- Check unreasonable historical dates
SELECT
    MIN(transaction_date) AS earliest_transaction,
    MAX(transaction_date) AS latest_transaction
FROM dbo.fact_sales;


-- 6. Business-rule validation
-- Gross sales calculation
-- Gross sales = (quantity * unit price)
SELECT
    COUNT(*) AS gross_sales_mismatches
FROM dbo.fact_sales
WHERE ABS(
        gross_sales -
        (quantity * unit_price)
      ) > 0.01;

-- Net sales calculation
-- Net Sales = gross sales - discount
SELECT
    COUNT(*) AS net_sales_mismatches
FROM dbo.fact_sales
WHERE ABS(
        net_sales -
        (gross_sales - discount_amount)
    ) > 0.01;


-- Profit calculation
-- Profit = net sales - cost
SELECT
    COUNT(*) AS profit_mismatches
FROM dbo.fact_sales
WHERE ABS(
        profit_amount -
        (net_sales - cost_amount)
      ) > 0.01;


-- Gross margin calculation
-- Gross Margin % = profit / net sales  * 100
SELECT
    COUNT(*) AS margin_mismatches
FROM dbo.fact_sales
WHERE net_sales > 0
  AND ABS(
        gross_margin_pct -
        ((profit_amount / net_sales) * 100)
      ) > 0.01;



-- 7. Referential Integrity

-- Orphan products
SELECT
    COUNT(*) AS orphan_product_records
FROM dbo.fact_sales AS f
LEFT JOIN dbo.dim_product AS p
    ON f.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Orphan customers
SELECT
    COUNT(*) AS orphan_customer_records
FROM dbo.fact_sales AS f
LEFT JOIN dbo.dim_customer AS c
    ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Orphan stores
SELECT
    COUNT(*) AS orphan_store_records
FROM dbo.fact_sales AS f
LEFT JOIN dbo.dim_store AS s
    ON f.store_id = s.store_id
WHERE s.store_id IS NULL;


-- 8. EXCEPT
-- Which IDs exist in A but don't exist in B
SELECT product_id
FROM dbo.fact_sales

EXCEPT

SELECT product_id
FROM dbo.dim_product;

-- Customer EXCEPT
SELECT customer_id
FROM dbo.fact_sales

EXCEPT

SELECT customer_id
FROM dbo.dim_customer;

-- Store EXCEPT
SELECT store_id
FROM dbo.fact_sales

EXCEPT

SELECT store_id
FROM dbo.dim_store;


-- Financial reconciliation
SELECT
    COUNT(*) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(gross_sales) AS gross_sales,
    SUM(discount_amount) AS discounts,
    SUM(net_sales) AS net_sales,
    SUM(cost_amount) AS total_cost,
    SUM(profit_amount) AS gross_profit
FROM dbo.fact_sales;

-- Validate the total profit
SELECT
    SUM(net_sales - cost_amount) AS calculated_profit,
    SUM(profit_amount) AS stored_profit,
    SUM(net_sales - cost_amount)
        - SUM(profit_amount) AS difference
FROM dbo.fact_sales;

-- Validate total net sales
SELECT
    SUM(gross_sales - discount_amount) AS calculated_net_sales,
    SUM(net_sales) AS stored_net_sales,
    SUM(gross_sales - discount_amount)
        - SUM(net_sales) AS difference
FROM dbo.fact_sales;



-- Professional validation summary


SELECT
    'NULL Transaction IDs' AS validation_test,
    COUNT(*) AS failed_records,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS status
FROM dbo.fact_sales
WHERE transaction_id IS NULL

UNION ALL

SELECT
    'Invalid Quantity',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM dbo.fact_sales
WHERE quantity <= 0

UNION ALL

SELECT
    'Invalid Unit Price',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM dbo.fact_sales
WHERE unit_price <= 0

UNION ALL

SELECT
    'Invalid Discount',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM dbo.fact_sales
WHERE discount_amount < 0
   OR discount_amount > gross_sales

UNION ALL

SELECT
    'Gross Sales Mismatch',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM dbo.fact_sales
WHERE ABS(gross_sales - (quantity * unit_price)) > 0.01

UNION ALL

SELECT
    'Net Sales Mismatch',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM dbo.fact_sales
WHERE ABS(net_sales - (gross_sales - discount_amount)) > 0.01

UNION ALL

SELECT
    'Profit Mismatch',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM dbo.fact_sales
WHERE ABS(profit_amount - (net_sales - cost_amount)) > 0.01

UNION ALL

SELECT
    'Orphan Products',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM dbo.fact_sales AS f
LEFT JOIN dbo.dim_product AS p
    ON f.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT
    'Orphan Customers',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM dbo.fact_sales AS f
LEFT JOIN dbo.dim_customer AS c
    ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
    'Orphan Stores',
    COUNT(*),
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END
FROM dbo.fact_sales AS f
LEFT JOIN dbo.dim_store AS s
    ON f.store_id = s.store_id
WHERE s.store_id IS NULL;

-- Financial summary
SELECT
    COUNT(*) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(gross_sales) AS gross_sales,
    SUM(discount_amount) AS discounts,
    SUM(net_sales) AS net_sales,
    SUM(cost_amount) AS total_cost,
    SUM(profit_amount) AS gross_profit
FROM dbo.fact_sales;