-- Resolve date ties by the smallest OrderID.
-- Orders with unknown dates cannot establish a first date.
WITH ranked_orders AS (
    SELECT CustomerID, OrderID,
           ROW_NUMBER() OVER (
               PARTITION BY CustomerID
               ORDER BY OrderDate, OrderID
           ) AS rn
    FROM Orders
    WHERE OrderDate IS NOT NULL
)
SELECT CustomerID, OrderID
FROM ranked_orders
WHERE rn = 1
ORDER BY CustomerID;
