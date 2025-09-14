-- Question 1 
use salesdb;
WITH RECURSIVE split_products AS (
    SELECT
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
        SUBSTRING(Products, LOCATE(',', Products) + 1) AS rest
    FROM ProductDetail

    UNION ALL

    SELECT
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS Product,
        CASE 
            WHEN LOCATE(',', rest) > 0 
            THEN SUBSTRING(rest, LOCATE(',', rest) + 1) 
            ELSE ''
        END
    FROM split_products
    WHERE rest <> ''
)
SELECT OrderID, CustomerName, Product
FROM split_products
WHERE Product <> '';

-- Question 2
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;


CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;



