/*Question 1 : Use Github Copilot to create a table SalesData whose columns are CustomerID, Name, Age, City,
PurchaseAmount, PurchaseDate and then ask to insert 10,000 rows of random data.*/

CREATE TABLE dbo.SalesData1
(
    CustomerID     INT IDENTITY(1,1) NOT NULL,
    Name           VARCHAR(100) NULL,
    Age            INT NULL,
    City           VARCHAR(100) NULL,
    PurchaseAmount DECIMAL(12,2) NULL,
    PurchaseDate   DATE NULL
);

;WITH Numbers AS
(
    SELECT 1 AS RowNum

    UNION ALL

    SELECT RowNum + 1
    FROM Numbers
    WHERE RowNum < 10000
)
INSERT INTO dbo.SalesData1
(
    Name,
    Age,
    City,
    PurchaseAmount,
    PurchaseDate
)
SELECT
    CHOOSE(
        1 + RandomValues.Random1 % 10,
        'John Smith',
        'Emily Johnson',
        'Michael Williams',
        'Sarah Brown',
        'David Brown',
        'Jessica Garcia',
        'Daniel Miller',
        'Ashley Davis',
        'Robert Wilson',
        'Sophia Moore'
    ) AS Name,

    18 + RandomValues.Random2 % 63 AS Age,

    CHOOSE(
        1 + RandomValues.Random3 % 10,
        'New York',
        'Los Angeles',
        'Chicago',
        'Houston',
        'Phoenix',
        'Philadelphia',
        'San Antonio',
        'San Diego',
        'Dallas',
        'Seattle'
    ) AS City,

    CAST(
        25.00 + RandomValues.Random4 % 49975
        + (RandomValues.Random5 % 100) / 100.00
        AS DECIMAL(12, 2)
    ) AS PurchaseAmount,

    DATEADD(
        DAY,
        -(RandomValues.Random6 % 1095),
        CAST(GETDATE() AS DATE)
    ) AS PurchaseDate
FROM Numbers
CROSS APPLY
(
    SELECT
        ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) AS Random1,
        ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) AS Random2,
        ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) AS Random3,
        ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) AS Random4,
        ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) AS Random5,
        ABS(CONVERT(BIGINT, CHECKSUM(NEWID()))) AS Random6
) AS RandomValues
OPTION (MAXRECURSION 0);

SELECT COUNT(*) AS TotalRows
FROM dbo.SalesData1;

/*Question 2 : Use Copilot to:
Find total sales per city
Top 5 cities by revenue */

SELECT
    City,
    SUM(PurchaseAmount) AS TotalSales
FROM dbo.SalesData1
GROUP BY City
ORDER BY TotalSales DESC;

SELECT TOP (5)
    City,
    SUM(PurchaseAmount) AS TotalRevenue
FROM dbo.SalesData1
GROUP BY City
ORDER BY TotalRevenue DESC;

/*Question 3  : Ask Copilot:
Find customers with purchases above average */

SELECT
    CustomerID,
    Name,
    Age,
    City,
    PurchaseAmount,
    PurchaseDate
FROM dbo.SalesData1
WHERE PurchaseAmount >
(
    SELECT AVG(PurchaseAmount)
    FROM dbo.SalesData1
)
ORDER BY PurchaseAmount DESC;