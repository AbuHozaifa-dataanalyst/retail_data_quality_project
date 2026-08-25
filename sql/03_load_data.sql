USE RetailDataQuality;
GO

-- Validate staging counts

SELECT
    'dim_product' AS table_name,
    COUNT(*) AS row_count
FROM dbo.stg_dim_product

UNION ALL

SELECT
    'dim_customer',
    COUNT(*)
FROM dbo.stg_dim_customer

UNION ALL

SELECT
    'dim_store',
    COUNT(*)
FROM dbo.stg_dim_store

UNION ALL

SELECT
    'fact_sales',
    COUNT(*)
FROM dbo.stg_fact_sales;

-- Load dimensions into final tables

INSERT INTO dbo.dim_product
(
    product_id,
    product_name,
    category,
    subcategory,
    brand,
    unit_cost,
    selling_price
)
SELECT
    product_id,
    product_name,
    category,
    subcategory,
    brand,
    unit_cost,
    selling_price
FROM dbo.stg_dim_product;
GO

INSERT INTO dbo.dim_customer
(
    customer_id,
    customer_name,
    gender,
    age,
    city,
    customer_segment
)
SELECT
    customer_id,
    customer_name,
    gender,
    age,
    city,
    customer_segment
FROM dbo.stg_dim_customer;
GO

INSERT INTO dbo.dim_store
(
    store_id,
    store_name,
    city,
    region,
    store_type
)
SELECT
    store_id,
    store_name,
    city,
    region,
    store_type
FROM dbo.stg_dim_store;
GO

INSERT INTO dbo.fact_sales
(
    transaction_id,
    transaction_date,
    customer_id,
    product_id,
    store_id,
    quantity,
    unit_price,
    discount_amount,
    gross_sales,
    net_sales,
    unit_cost,
    cost_amount,
    profit_amount,
    gross_margin_pct,
    payment_method,
    sales_channel
)
SELECT
    transaction_id,
    transaction_date,
    customer_id,
    product_id,
    store_id,
    quantity,
    unit_price,
    discount_amount,
    gross_sales,
    net_sales,
    unit_cost,
    cost_amount,
    profit_amount,
    gross_margin_pct,
    payment_method,
    sales_channel
FROM dbo.stg_fact_sales;
GO

-- Verify final counts
SELECT
    'dim_product' AS table_name,
    COUNT(*) AS row_count
FROM dbo.dim_product

UNION ALL

SELECT
    'dim_customer',
    COUNT(*)
FROM dbo.dim_customer

UNION ALL

SELECT
    'dim_store',
    COUNT(*)
FROM dbo.dim_store

UNION ALL

SELECT
    'fact_sales',
    COUNT(*)
FROM dbo.fact_sales;