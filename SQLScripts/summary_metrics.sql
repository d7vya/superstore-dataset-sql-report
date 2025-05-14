use superstore_kpi;

CREATE VIEW Summary_Metrics AS
WITH Total_Rev_Customer AS (
    SELECT 
        1 AS SNo, 
        COUNT(DISTINCT CustomerID) AS Customers,
        ROUND(SUM(Sales), 2) AS Revenue,COUNT(DISTINCT orderid) as Orders
    FROM Orders
),
Total_Products AS (
    SELECT 
        1 AS SNo, 
        COUNT(DISTINCT ProductID) AS Products 
    FROM Products
),
Total_Returns AS (
    SELECT 
        1 AS SNo, 
        COUNT(OrderID) AS Returned_Orders 
    FROM Returns
),
Total_Markets AS (
    SELECT 
        1 AS SNo, 
        COUNT(DISTINCT Market) AS Total_Markets 
    FROM Locations
),
Summary_Together AS (
    SELECT 
        Customers,
        Revenue,
        Products,
        Returned_Orders,
        Total_Markets,Orders
    FROM Total_Rev_Customer TRC 
    JOIN Total_Products TP ON TRC.SNo = TP.SNo
    JOIN Total_Returns TR ON TP.SNo = TR.SNo
    JOIN Total_Markets TM ON TR.SNo = TM.SNo
)
SELECT * FROM Summary_Together;

SELECT * FROM Summary_Metrics;
