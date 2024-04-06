# View Contents of Each Table
-- Customers Table
SELECT * FROM Customers;
-- Employees Table
SELECT * FROM Employees;
-- Offices Table
SELECT * FROM Offices;
-- OrderDetails Table
SELECT * FROM OrderDetails;
-- Orders Table
SELECT * FROM Orders;
-- Payments Table
SELECT * FROM Payments;
-- ProductLines Table
SELECT * FROM ProductLines;
-- Products Table
SELECT * FROM Products;
-- Warehouses Table
SELECT * FROM Warehouses;

# Business problem: Mint Classics Company is hoping to close one of their storage facilities. They want 
-- suggestions and recommendations for reorganizing or reducing inventory, while still maintaining timely 
-- service to their customers. 

-- Query to identify the storage locations of items
SELECT p.ProductCode, p.ProductName, w.WarehouseCode, w.WarehouseName
FROM Products p
JOIN Warehouses w ON p.WarehouseCode = w.WarehouseCode;

-- Query to count products in each warehouse
SELECT w.WarehouseCode, w.WarehouseName, COUNT(*) AS ProductCount
FROM Products p
JOIN Warehouses w ON p.WarehouseCode = w.WarehouseCode
GROUP BY w.WarehouseCode, w.WarehouseName;

-- Query exploring quantity in stock of each products
SELECT w.WarehouseCode, w.WarehouseName, p.ProductCode, p.ProductName, p.QuantityInStock
FROM Warehouses w
JOIN Products p ON w.WarehouseCode = p.WarehouseCode
ORDER BY w.WarehouseCode, p.ProductCode;

-- Query exploring the total quantity of products in each warehouse
SELECT w.WarehouseCode, w.WarehouseName, SUM(p.QuantityInStock) AS TotalQuantity
FROM Warehouses w
JOIN Products p ON w.WarehouseCode = p.WarehouseCode
GROUP BY w.WarehouseCode, w.WarehouseName;

# Given the information provided, Warehouse D has the lowest quantity of products at 79,380 
-- and the fewest number of unique products, totaling 23. 
-- This suggests that Warehouse D may experience high sales turnover, leading to lower stock levels.
-- Conversely, Warehouse B has the highest quantity of products at 219,183 and the highest number of unique
-- products, totaling 38.
-- This could indicate that Warehouse B experiences lower sales turnover or maintains a larger inventory.
-- To further analyze this scenario, we will examine the sales activity OF products within each warehouse.

-- Query to analyze inventory levels and sales figures
# By using COALESCE(SUM(od.QuantityOrdered), 0),
-- any null values in the TotalQuantityOrdered column will be replaced with 0. 
SELECT p.ProductCode, p.ProductName, p.QuantityInStock, COALESCE(SUM(od.QuantityOrdered), 0) AS TotalQuantityOrdered, w.WarehouseName, w.warehousecode
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductCode = od.ProductCode
LEFT JOIN Warehouses w ON p.WarehouseCode = w.WarehouseCode
GROUP BY p.ProductCode, p.ProductName, p.QuantityInStock, w.WarehouseName
ORDER BY TotalQuantityOrdered DESC;

-- Query showing the inventory sales difference
SELECT 
    p.ProductCode, 
    p.ProductName, 
    p.QuantityInStock, 
    COALESCE(SUM(od.QuantityOrdered), 0) AS TotalQuantityOrdered,
    p.QuantityInStock - COALESCE(SUM(od.QuantityOrdered), 0) AS Inventory_Sales_Difference,
    p.WarehouseCode,
    w.WarehouseName
FROM 
    Products p
LEFT JOIN 
    OrderDetails od ON p.ProductCode = od.ProductCode
LEFT JOIN
    Warehouses w ON p.WarehouseCode = w.WarehouseCode
GROUP BY 
    p.ProductCode, p.ProductName, p.QuantityInStock, p.WarehouseCode, w.WarehouseName
ORDER BY 
    Inventory_Sales_Difference;

-- Query showing a table of product with the highest and lowest sales and inventory with the warehouse location
(SELECT 
    'Product with the Highest Sales' AS `Analysis`,
    p.ProductCode,
    p.ProductName,
    p.QuantityInStock,
    COALESCE(SUM(od.QuantityOrdered), 0) AS TotalQuantityOrdered,
    (p.QuantityInStock - COALESCE(SUM(od.QuantityOrdered), 0)) AS InventorySalesDifference,
    w.WarehouseCode,
    w.WarehouseName
FROM 
    Products p
LEFT JOIN 
    OrderDetails od ON p.ProductCode = od.ProductCode
JOIN 
    Warehouses w ON p.WarehouseCode = w.WarehouseCode
GROUP BY 
    p.ProductCode, p.ProductName, p.QuantityInStock, w.WarehouseCode, w.WarehouseName
ORDER BY 
    TotalQuantityOrdered DESC
LIMIT 1)

UNION

(SELECT 
    'Product with the Lowest Sales' AS `Analysis`,
    p.ProductCode,
    p.ProductName,
    p.QuantityInStock,
    COALESCE(SUM(od.QuantityOrdered), 0) AS TotalQuantityOrdered,
    (p.QuantityInStock - COALESCE(SUM(od.QuantityOrdered), 0)) AS InventorySalesDifference,
    w.WarehouseCode,
    w.WarehouseName
FROM 
    Products p
LEFT JOIN 
    OrderDetails od ON p.ProductCode = od.ProductCode
JOIN 
    Warehouses w ON p.WarehouseCode = w.WarehouseCode
GROUP BY 
    p.ProductCode, p.ProductName, p.QuantityInStock, w.WarehouseCode, w.WarehouseName
ORDER BY 
    TotalQuantityOrdered ASC
LIMIT 1)

UNION

(SELECT 
    'Product with the Highest Inventory' AS `Analysis`,
    p.ProductCode,
    p.ProductName,
    p.QuantityInStock,
    COALESCE(SUM(od.QuantityOrdered), 0) AS TotalQuantityOrdered,
    (p.QuantityInStock - COALESCE(SUM(od.QuantityOrdered), 0)) AS InventorySalesDifference,
    w.WarehouseCode,
    w.WarehouseName
FROM 
    Products p
LEFT JOIN 
    OrderDetails od ON p.ProductCode = od.ProductCode
JOIN 
    Warehouses w ON p.WarehouseCode = w.WarehouseCode
GROUP BY 
    p.ProductCode, p.ProductName, p.QuantityInStock, w.WarehouseCode, w.WarehouseName
ORDER BY 
    QuantityInStock DESC
LIMIT 1)

UNION

(SELECT 
    'Product with the Lowest Inventory' AS `Analysis`,
    p.ProductCode,
    p.ProductName,
    p.QuantityInStock,
    COALESCE(SUM(od.QuantityOrdered), 0) AS TotalQuantityOrdered,
    (p.QuantityInStock - COALESCE(SUM(od.QuantityOrdered), 0)) AS InventorySalesDifference,
    w.WarehouseCode,
    w.WarehouseName
FROM 
    Products p
LEFT JOIN 
    OrderDetails od ON p.ProductCode = od.ProductCode
JOIN 
    Warehouses w ON p.WarehouseCode = w.WarehouseCode
GROUP BY 
    p.ProductCode, p.ProductName, p.QuantityInStock, w.WarehouseCode, w.WarehouseName
ORDER BY 
    QuantityInStock ASC
LIMIT 1)

UNION

(SELECT 
    'Product with the Highest Inventory Sales Difference' AS `Analysis`,
    p.ProductCode,
    p.ProductName,
    p.QuantityInStock,
    COALESCE(SUM(od.QuantityOrdered), 0) AS TotalQuantityOrdered,
    (p.QuantityInStock - COALESCE(SUM(od.QuantityOrdered), 0)) AS InventorySalesDifference,
    w.WarehouseCode,
    w.WarehouseName
FROM 
    Products p
LEFT JOIN 
    OrderDetails od ON p.ProductCode = od.ProductCode
JOIN 
    Warehouses w ON p.WarehouseCode = w.WarehouseCode
GROUP BY 
    p.ProductCode, p.ProductName, p.QuantityInStock, w.WarehouseCode, w.WarehouseName
ORDER BY 
    InventorySalesDifference DESC
LIMIT 1)

UNION

(SELECT 
    'Product with the Lowest Inventory Sales Difference' AS `Analysis`,
    p.ProductCode,
    p.ProductName,
    p.QuantityInStock,
    COALESCE(SUM(od.QuantityOrdered), 0) AS TotalQuantityOrdered,
    (p.QuantityInStock - COALESCE(SUM(od.QuantityOrdered), 0)) AS InventorySalesDifference,
    w.WarehouseCode,
    w.WarehouseName
FROM 
    Products p
LEFT JOIN 
    OrderDetails od ON p.ProductCode = od.ProductCode
JOIN 
    Warehouses w ON p.WarehouseCode = w.WarehouseCode
GROUP BY 
    p.ProductCode, p.ProductName, p.QuantityInStock, w.WarehouseCode, w.WarehouseName
ORDER BY 
    InventorySalesDifference ASC
LIMIT 1);

# Table Interpretaion
-- Product with the Highest Sales: S18_3232, 1992 Ferrari 360 Spider red, Total Quantity Ordered: 1808, Inventory Sales Difference: 6539, Warehouse: b (East)
-- Product with the Lowest Sales: S18_3233, 1985 Toyota Supra, Total Quantity Ordered: 0, Inventory Sales Difference: 7733, Warehouse: b (East)
-- Product with the Highest Inventory: S12_2823, 2002 Suzuki XREO, Quantity In Stock: 9997, Total Quantity Ordered: 1028, Inventory Sales Difference: 8969, Warehouse: a (North)
-- Product with the Lowest Inventory: S24_2000, 1960 BSA Gold Star DBD34, Quantity In Stock: 15, Total Quantity Ordered: 1015, Inventory Sales Difference: -1000, Warehouse: a (North)
-- Product with the Highest Inventory Sales Difference: S12_2823, 2002 Suzuki XREO, Quantity In Stock: 9997, Total Quantity Ordered: 1028, Inventory Sales Difference: 8969, Warehouse: a (North)
-- Product with the Lowest Inventory Sales Difference: S24_2000, 1960 BSA Gold Star DBD34, Quantity In Stock: 15, Total Quantity Ordered: 1015, Inventory Sales Difference: -1000, Warehouse: a (North)

-- Query to identify patterns in sales and pricing
SELECT 
    p.ProductCode, 
    p.ProductName, 
    p.WarehouseCode,
    AVG(od.QuantityOrdered) AS AvgQuantityOrdered, 
    AVG(od.PriceEach) AS AvgPrice,
    (COALESCE(p.QuantityInStock, 0) - COALESCE(SUM(od.QuantityOrdered), 0)) AS InventorySalesDifference
FROM 
    OrderDetails od
JOIN 
    Products p ON od.ProductCode = p.ProductCode
GROUP BY 
    p.ProductCode, 
    p.ProductName, 
    p.WarehouseCode,
    p.QuantityInStock
ORDER BY 
    AvgQuantityOrdered DESC;


 
-- Query to simulate reducing the quantity on hand for every item by 5%
UPDATE Products
SET QuantityInStock = QuantityInStock * 0.95;

# SUGGESTIONS AND RECOMMENDATIONS
-- 1. Don't Close Warehouses: 
-- Since the top 10 average quantity ordered products are distributed across all warehouses, 
-- closing any warehouse could potentially disrupt timely delivery and customer satisfaction.
-- Maintaining warehouses in different geographical locations ensures efficient distribution and delivery of products to customers.

-- 2. Match Inventory with Demand:
-- Matching product inventory with the quantity ordered is crucial to avoid overstocking or understocking.
-- By optimizing inventory management practices, the company can minimize carrying costs, reduce the risk of stockouts,
-- and improve overall operational efficiency.

-- Overall, my suggestions prioritize customer satisfaction, operational efficiency, and cost-effectiveness,
-- which are key factors for the company's success in the long term. It's essential for the company to continue monitoring sales trends,
-- inventory levels, and customer demand to make informed decisions and adapt its strategies accordingly.