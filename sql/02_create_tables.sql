USE RetailDataQuality;
GO

CREATE TABLE dbo.dim_product
(
    product_id      VARCHAR(20)      NOT NULL,
    product_name    NVARCHAR(200)    NOT NULL,
    category        NVARCHAR(100)    NOT NULL,
    subcategory     NVARCHAR(100)    NOT NULL,
    brand           NVARCHAR(100)    NOT NULL,
    unit_cost       DECIMAL(18,2)    NOT NULL,
    selling_price   DECIMAL(18,2)    NOT NULL,

    CONSTRAINT PK_dim_product
        PRIMARY KEY (product_id),

    CONSTRAINT CK_dim_product_unit_cost
        CHECK (unit_cost >= 0),

    CONSTRAINT CK_dim_product_selling_price
        CHECK (selling_price > 0)
);
GO

CREATE TABLE dbo.dim_customer
(
    customer_id       VARCHAR(20)      NOT NULL,
    customer_name     NVARCHAR(200)    NOT NULL,
    gender            VARCHAR(20)      NULL,
    age               INT              NULL,
    city              NVARCHAR(100)    NULL,
    customer_segment  VARCHAR(50)      NULL,

    CONSTRAINT PK_dim_customer
        PRIMARY KEY (customer_id),

    CONSTRAINT CK_dim_customer_age
        CHECK (
            age IS NULL
            OR age BETWEEN 18 AND 100
        )
);
GO

CREATE TABLE dbo.dim_store
(
    store_id     VARCHAR(20)      NOT NULL,
    store_name   NVARCHAR(200)    NOT NULL,
    city         NVARCHAR(100)    NOT NULL,
    region       NVARCHAR(100)    NOT NULL,
    store_type   VARCHAR(50)      NOT NULL,

    CONSTRAINT PK_dim_store
        PRIMARY KEY (store_id)
);
GO

CREATE TABLE dbo.fact_sales
(
    transaction_id       VARCHAR(30)      NOT NULL,
    transaction_date     DATE             NOT NULL,
    customer_id          VARCHAR(20)      NOT NULL,
    product_id           VARCHAR(20)      NOT NULL,
    store_id             VARCHAR(20)      NOT NULL,

    quantity             INT              NOT NULL,
    unit_price           DECIMAL(18,2)    NOT NULL,
    discount_amount      DECIMAL(18,2)    NOT NULL,
    gross_sales          DECIMAL(18,2)    NOT NULL,
    net_sales            DECIMAL(18,2)    NOT NULL,

    unit_cost            DECIMAL(18,2)    NOT NULL,
    cost_amount          DECIMAL(18,2)    NOT NULL,
    profit_amount        DECIMAL(18,2)    NOT NULL,
    gross_margin_pct     DECIMAL(10,2)    NULL,

    payment_method       VARCHAR(50)      NOT NULL,
    sales_channel        VARCHAR(30)      NOT NULL,

    CONSTRAINT PK_fact_sales
        PRIMARY KEY (transaction_id),

    CONSTRAINT CK_fact_sales_quantity
        CHECK (quantity > 0),

    CONSTRAINT CK_fact_sales_unit_price
        CHECK (unit_price > 0),

    CONSTRAINT CK_fact_sales_discount
        CHECK (
            discount_amount >= 0
            AND discount_amount <= gross_sales
        ),

    CONSTRAINT CK_fact_sales_unit_cost
        CHECK (unit_cost >= 0),

    CONSTRAINT CK_fact_sales_financials
        CHECK (
            gross_sales >= 0
            AND net_sales >= 0
        )
);
GO

ALTER TABLE dbo.fact_sales
ADD CONSTRAINT FK_fact_sales_product
    FOREIGN KEY (product_id)
    REFERENCES dbo.dim_product(product_id);
GO

ALTER TABLE dbo.fact_sales
ADD CONSTRAINT FK_fact_sales_customer
    FOREIGN KEY (customer_id)
    REFERENCES dbo.dim_customer(customer_id);
GO

ALTER TABLE dbo.fact_sales
ADD CONSTRAINT FK_fact_sales_store
    FOREIGN KEY (store_id)
    REFERENCES dbo.dim_store(store_id);
GO

CREATE INDEX IX_fact_sales_transaction_date
ON dbo.fact_sales(transaction_date);
GO

CREATE INDEX IX_fact_sales_customer_id
ON dbo.fact_sales(customer_id);
GO

CREATE INDEX IX_fact_sales_product_id
ON dbo.fact_sales(product_id);
GO

CREATE INDEX IX_fact_sales_store_id
ON dbo.fact_sales(store_id);
GO

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
VALUES
(
    'UNKNOWN',
    'Unknown Product',
    'Unknown',
    'Unknown',
    'Unknown',
    0,
    0.01
);
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
VALUES
(
    'UNKNOWN',
    'Unknown Customer',
    NULL,
    NULL,
    'Unknown',
    'Unknown'
);
GO

INSERT INTO dbo.dim_store
(
    store_id,
    store_name,
    city,
    region,
    store_type
)
VALUES
(
    'UNKNOWN',
    'Unknown Store',
    'Unknown',
    'Unknown',
    'Unknown'
);
GO

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY
    TABLE_NAME,
    ORDINAL_POSITION;

SELECT
    name AS constraint_name,
    type_desc
FROM sys.objects
WHERE type IN ('PK', 'F', 'C')
ORDER BY name;


USE RetailDataQuality;
GO
CREATE TABLE dbo.stg_dim_product
(
    product_id      VARCHAR(20),
    product_name    NVARCHAR(200),
    category        NVARCHAR(100),
    subcategory     NVARCHAR(100),
    brand           NVARCHAR(100),
    unit_cost       DECIMAL(18,2),
    selling_price   DECIMAL(18,2)
);
GO

CREATE TABLE dbo.stg_dim_customer
(
    customer_id       VARCHAR(20),
    customer_name     NVARCHAR(200),
    gender            VARCHAR(20),
    age               INT,
    city              NVARCHAR(100),
    customer_segment  VARCHAR(50)
);
GO

CREATE TABLE dbo.stg_dim_store
(
    store_id     VARCHAR(20),
    store_name   NVARCHAR(200),
    city         NVARCHAR(100),
    region       NVARCHAR(100),
    store_type   VARCHAR(50)
);
GO

CREATE TABLE dbo.stg_fact_sales
(
    transaction_id      VARCHAR(30),
    transaction_date    DATE,
    customer_id         VARCHAR(20),
    product_id          VARCHAR(20),
    store_id            VARCHAR(20),
    quantity            INT,
    unit_price          DECIMAL(18,2),
    discount_amount     DECIMAL(18,2),
    gross_sales         DECIMAL(18,2),
    net_sales           DECIMAL(18,2),
    unit_cost           DECIMAL(18,2),
    cost_amount         DECIMAL(18,2),
    profit_amount       DECIMAL(18,2),
    gross_margin_pct    DECIMAL(10,2),
    payment_method      VARCHAR(50),
    sales_channel       VARCHAR(30)
);
GO