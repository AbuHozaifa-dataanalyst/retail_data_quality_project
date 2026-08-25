USE RetailDataQuality;
GO

-- Create or update vw_clean_sales
CREATE VIEW dbo.vw_clean_sales
AS
SELECT
	f.transaction_id,
    f.transaction_date,

    f.customer_id,
    c.customer_name,
    c.gender,
    c.age,
    c.customer_segment,

    f.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.brand,

    f.store_id,
    s.store_name,
    s.city AS store_city,
    s.region,
    s.store_type,

    f.quantity,
    f.unit_price,
    f.discount_amount,
    f.gross_sales,
    f.net_sales,
    f.unit_cost,
    f.cost_amount,
    f.profit_amount,
    f.gross_margin_pct,

    f.payment_method,
    f.sales_channel
FROM dbo.fact_sales AS f
LEFT JOIN dbo.dim_product AS p
    ON f.product_id = p.product_id
LEFT JOIN dbo.dim_customer AS c
    ON f.customer_id = c.customer_id
LEFT JOIN dbo.dim_store AS s
    ON f.store_id = s.store_id;
GO

-- Validate the view's row count
SELECT
    COUNT(*) AS rows_in_view,
    COUNT(DISTINCT transaction_id) AS transactions
FROM dbo.vw_clean_sales;

SELECT COUNT(*) AS rows_in_fact_sales
FROM dbo.fact_sales;
GO

-- Create or update product performance view
CREATE OR ALTER VIEW dbo.vw_product_performance
AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.brand,

    COUNT(DISTINCT f.transaction_id) AS transactions,

    SUM(f.quantity) AS units_sold,

    SUM(f.gross_sales) AS gross_sales,

    SUM(f.discount_amount) AS discounts,

    SUM(f.net_sales) AS net_sales,

    SUM(f.cost_amount) AS total_cost,

    SUM(f.profit_amount) AS gross_profit,

    CAST(
        CASE
            WHEN SUM(f.net_sales) = 0 THEN 0
            ELSE
                SUM(f.profit_amount)
                / SUM(f.net_sales) * 100
        END
        AS DECIMAL(10,2)
    ) AS gross_margin_pct

FROM dbo.fact_sales AS f
INNER JOIN dbo.dim_product AS p
    ON f.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.brand;
GO


--Which products generated the most net sales
SELECT TOP 20 *
FROM dbo.vw_product_performance
ORDER BY net_sales DESC;

-- Store Performance View
CREATE VIEW dbo.vw_store_performance
AS
SELECT
    s.store_id,
    s.store_name,
    s.city,
    s.region,
    s.store_type,

    COUNT(DISTINCT f.transaction_id) AS transactions,

    SUM(f.quantity) AS units_sold,

    SUM(f.gross_sales) AS gross_sales,

    SUM(f.discount_amount) AS discounts,

    SUM(f.net_sales) AS net_sales,

    SUM(f.cost_amount) AS total_cost,

    SUM(f.profit_amount) AS gross_profit,

    CAST(
        CASE
            WHEN SUM(f.net_sales) = 0 THEN 0
            ELSE
                SUM(f.profit_amount)
                / SUM(f.net_sales) * 100
        END
        AS DECIMAL(10,2)
    ) AS gross_margin_pct

FROM dbo.fact_sales AS f

INNER JOIN dbo.dim_store AS s
    ON f.store_id = s.store_id

GROUP BY
    s.store_id,
    s.store_name,
    s.city,
    s.region,
    s.store_type;
GO

SELECT *
FROM dbo.vw_store_performance
ORDER BY net_sales DESC;


-- Customer Sales View
CREATE VIEW dbo.vw_customer_sales
AS
SELECT
    c.customer_id,
    c.customer_name,
    c.gender,
    c.age,
    c.city,
    c.customer_segment,

    COUNT(DISTINCT f.transaction_id) AS transactions,

    SUM(f.quantity) AS units_sold,

    SUM(f.net_sales) AS net_sales,

    SUM(f.cost_amount) AS total_cost,

    SUM(f.profit_amount) AS gross_profit,

    CAST(
        CASE
            WHEN SUM(f.net_sales) = 0 THEN 0
            ELSE
                SUM(f.profit_amount)
                / SUM(f.net_sales) * 100
        END
        AS DECIMAL(10,2)
    ) AS gross_margin_pct

FROM dbo.fact_sales AS f

INNER JOIN dbo.dim_customer AS c
    ON f.customer_id = c.customer_id

GROUP BY
    c.customer_id,
    c.customer_name,
    c.gender,
    c.age,
    c.city,
    c.customer_segment;
GO

SELECT TOP 20 *
FROM dbo.vw_customer_sales
ORDER BY net_sales DESC;