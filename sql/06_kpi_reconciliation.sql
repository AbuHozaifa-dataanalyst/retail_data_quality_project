USE RetailDataQuality;
GO


CREATE OR ALTER VIEW dbo.vw_kpi_reconciliation
AS
SELECT
    COUNT(DISTINCT transaction_id) AS transactions,

    SUM(quantity) AS units_sold,

    SUM(gross_sales) AS gross_sales,

    SUM(discount_amount) AS discounts,

    SUM(net_sales) AS net_sales,

    SUM(cost_amount) AS total_cost,

    SUM(profit_amount) AS gross_profit,

    CAST(
        SUM(profit_amount)
        / NULLIF(SUM(net_sales), 0)
        * 100
        AS DECIMAL(10,2)
    ) AS gross_margin_pct,

    CAST(
        SUM(net_sales)
        / NULLIF(COUNT(DISTINCT transaction_id), 0)
        AS DECIMAL(18,2)
    ) AS average_transaction_value,

    CAST(
        SUM(quantity)
        / NULLIF(COUNT(DISTINCT transaction_id), 0)
        AS DECIMAL(18,2)
    ) AS units_per_transaction,

    COUNT(DISTINCT customer_id) AS customers,

    COUNT(DISTINCT store_id) AS stores,

    COUNT(DISTINCT product_id) AS products

FROM dbo.fact_sales;
GO

SELECT *
FROM dbo.vw_kpi_reconciliation;