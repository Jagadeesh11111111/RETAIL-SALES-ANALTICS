select DB_NAME() AS CurrentDatabase;
select TABLE_SCHEMA,TABLE_NAME
from INFORMATION_SCHEMA.TABLES;
-- check the no of rows
select COUNT(*) as total_rows 
from  Retailsales$ ;
-- check all column
select top 30 * 
from Retailsales$;
-- check table structure
EXEC sp_help 'Retailsales$';
-- check the null value
select * 
from Retailsales$ 
where Customer_ID is null;
select count(*) as total_rows,
sum(case when customer_ID is null then 1 else 0 end) as null_customer_ID ,
sum(case when product_ID is null then 1 else 0 end) as null_product_ID
from Retailsales$;
-- check duplicated id 
SELECT
    Customer_ID,
    COUNT(*) AS Record_Count
FROM RetailSales$
GROUP BY Customer_ID
HAVING COUNT(*) > 1;
-- TOTAL SALES
SELECT 
        SUM(SALES) AS TOTAL_SALES
FROM Retailsales$
-- TOTAL CUSTOMER
SELECT 
    COUNT(DISTINCT Customer_ID) AS TOTAL_CUSTOMER
FROM Retailsales$;
-- TOTAL QUANTITY
SELECT
    SUM(Quantity) AS TOTAL_QUANTITY
FROM Retailsales$
-- Sales  Category
SELECT 
     Category,
       SUM(sales) AS TOTAL_SALES
FROM Retailsales$
GROUP BY Category
ORDER BY TOTAL_SALES DESC;
-- CHECK DUPLICATE ROWS
SELECT *,
       COUNT(*) AS Duplicate_Count
FROM Retailsales$
GROUP BY
    Customer_ID,
    Product_ID,
    Product_Name,
    Category,
    Sales,
    Quantity,
    Order_Date,
    Region
HAVING COUNT(*) > 1;
-- check duplicated
SELECT
    [ORDER_ID],
    COUNT(*) AS Duplicate_Count
FROM Retailsales$
GROUP BY [ORDER_ID]
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;
-- check zero sales
SELECT COUNT(*) AS ZERO_SALES
FROM Retailsales$
WHERE Sales=0;
-- check negative sales
SELECT COUNT(*) AS NEGATIVE_SALES
FROM Retailsales$
WHERE Sales <0;
-- find sales above average 
SELECT TOP 20 *
FROM Retailsales$
WHERE Sales >
(
        SELECT AVG(Sales)
        from Retailsales$
)
ORDER BY Sales desc;
-- check sales distribution 
select 
    case 
        when sales=0 then 'zero'
        when sales<1000 then 'zero -999'
        when sales<5000 then '1000-4999'
        when sales<10000 then '5000-9999'
        when sales<50000 then '10000-49999'
        else '50000+'
        END AS Sales_Range,
        COUNT(*) as NUMBER_OF_ORDER
        FROM Retailsales$
GROUP BY 
    CASE
        when sales=0 then 'zero'
        when sales<1000 then 'zero -999'
        when sales<5000 then '1000-4999'
        when sales<10000 then '5000-9999'
        when sales<50000 then '10000-49999'
        else '50000+'
    END 
    ORDER BY NUMBER_OF_ORDER DESC;
        
-- CHECK THE DUPLICATE ORDER ID
SELECT
    [ORDER_ID],
    COUNT(*) AS Duplicate_Count
FROM dbo.[Retailsales$]
GROUP BY [ORDER_ID]
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;
-- CHCK THE NULL QUANTITY 
SELECT COUNT(*) AS NULL_QUANTITY
FROM Retailsales$
WHERE Quantity IS NULL;
-- CHECK ZERO QUANTITY 
SELECT COUNT(*) AS ZERO_QUANTITY 
FROM Retailsales$
WHERE Quantity=0;
-- CHECK NEGATIVE QUANTITY 
SELECT COUNT(*) AS ZERO_QUANTITY 
FROM Retailsales$
WHERE Quantity<0;
-- CHECK MAXAND MIN QUANTITY 
SELECT 
    MAX(QUANTITY) AS MAXIMUM_QUANTITY,
    MIN(QUANTITY) AS MINIMUM_QUANTITY
FROM Retailsales$;
-- CHECK AVERAGE QUANTITY 
SELECT AVG(QUANTITY) AS AVERAGE_QUANTITY
FROM Retailsales$;

-- CHECK CUSTOMER_ID
SELECT COUNT(*) AS NULL_CUSTOMER_ID 
FROM Retailsales$
WHERE Customer_ID IS NULL ;
-- CHECK UNIQUE CUSTOMER_ID
SELECT COUNT(DISTINCT[CUSTOMER_ID]) AS UNIQUE_CUSTOMER_ID
FROM Retailsales$
WHERE Customer_ID IS NOT NULL ;

-- CHECK PRODUCT_ID 
SELECT COUNT(*) AS NULL_PRODUCT_ID
FROM Retailsales$
WHERE Product_ID IS NULL ;
-- CHECK ORDER_DATE
SELECT COUNT(*) AS NILL_ORDER_DATE
FROM Retailsales$
WHERE Order_Date IS NULL ;
-- CHECK LATEST AND EARLIEST DATE 
SELECT 
    MIN(Order_Date) AS EARLIEST_ORDER_DATE ,
    MAX(Order_Date) AS LATEST_ORDER_DATE
FROM Retailsales$;

-- check categories
select 
        category,
        COUNT(*) AS NUMBER_OF_ROWS
FROM Retailsales$
GROUP BY Category
ORDER BY NUMBER_OF_ROWS DESC ;
-- CREATE THE COLUMN OF MONTH 
ALTER TABLE Retailsales$
ADD MONTH FLOAT ;
UPDATE Retailsales$
SET MONTH =MONTH([Order_Date]);
SELECT 
    ORDER_DATE ,
    MONTH,
    [Month Name]
FROM Retailsales$;

-- VALIDATION MONTHVS MONTH NAME 
SELECT
        MONTH,
        [Month Name],
        COUNT(*) AS NUMBER_OF_ROWS
FROM Retailsales$
GROUP BY 
        MONTH ,
       [Month Name]
ORDER BY MONTH ;
-- validation quaters
SELECT 
    Quarter,
    COUNT(*) AS NUMBER_OF_ROWS
FROM Retailsales$
GROUP BY Quarter
ORDER BY Quarter ;
-- FINAL DATE VALIDATION 
SELECT 
    COUNT(*) as number_of_rows,
    SUM(case when [ORDER_DATE] IS NULL THEN 0 ELSE 1 END) AS NULL_ORDER_DATE,
    MIN(ORDER_DATE) AS MINIMUM_ORDER_DATE,
    MAX(ORDER_DATE) AS MAXIMUM_ORDER_DATE,
    COUNT(DISTINCT YEAR) AS NUMBER_OF_YEAR,
    COUNT(DISTINCT MONTH) AS NUMBER_OF_MONTH,
    COUNT(DISTINCT QUARTER) AS NUMBER_OF_QUARTER
FROM Retailsales$;
-- check sales > 5000
SELECT 
        ORDER_DATE,
        PRODUCT_ID,
         PRODUCT_NAME,
         SALES,
          PROFIT
FROM Retailsales$
WHERE SALES>5000;
-- WHERE WITH CATEGORY 
SELECT 
    ORDER_DATE,
    Product_Name,
    CATEGORY,
    SALES
FROM Retailsales$
WHERE Category='ELECTRONICS';
-- CHECK THE AND CONDITION 
SELECT 
        ORDER_DATE,
        PRODUCT_NAME,
        CATEGORY,
        SALES
FROM Retailsales$
WHERE CATEGORY='ELECTRONICS'
  AND Sales=1000;
  -- CHECK THE OR CONDITION 
SELECT
    ORDER_DATE,
    PRODUCT_NAME,
    Category,
    SALES
FROM Retailsales$
WHERE Category ='ELECTRONICS'
OR Category='FURNITURE';
-- FIND THE TOP 10 SALES 
SELECT TOP 10
    ORDER_ID,
    PRODUCT_NAME,
    CATEGORY,
    SALES
FROM Retailsales$
ORDER BY Sales DESC;
-- CASE WHEN SALES HIGH 
SELECT 
    PRODUCT_NAME,
    SALES ,
    CASE 
        WHEN SALES>=10000 THEN 'HIGH'
        WHEN SALES>=5000 THEN ' MEDIUM'
        ELSE 'LOW'
        END AS SALES_CATEGORY
FROM Retailsales$;
-- find the qiantity > 10 and sales>10000
SELECT 
    PRODUCT_NAME,
    CATEGORY,
    QUANTITY,
    SALES
FROM Retailsales$
WHERE QUANTITY>=10
AND SALES>10000
ORDER BY SALES DESC;
-- SALES PER YEAR 
SELECT 
    YEAR,
    SUM(SALES) AS TOTAL_SALES
FROM Retailsales$
GROUP BY YEAR
ORDER BY TOTAL_SALES DESC;
-- SALES PER MONTH
SELECT 
    MONTH,
    SUM(SALES) AS TOTAL_SALES
FROM Retailsales$
GROUP BY MONTH 
ORDER BY TOTAL_SALES DESC;
--- MAKE THE MULTIPLE CODITION 
SELECT 
    CATEGORY,
    SUM(SALES) AS TOTAL_SALES,
    SUM(QUANTITY) AS TOTAL_QUANTITY,
    COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDER,
    AVG(SALES) AS AVERAGE_SALES
FROM Retailsales$
GROUP BY CATEGORY 
ORDER BY TOTAL_SALES DESC ;
-- CATEGORY WHOSE TOTAL SALES OS GREATER THEN 100000
SELECT
    CATEGORY,
    SUM(SALES) AS TOTAL_SALES
FROM Retailsales$
GROUP BY CATEGORY
HAVING SUM(SALES) >100000
ORDER BY TOTAL_SALES DESC;
-- CREATE A PROFITAVLE FLAG 
SELECT 
    PRODUCT_NAME,
    PROFIT,
    CASE
        WHEN PROFIT>1000 THEN 'PROFITABLE'
         WHEN PROFIT<1000 THEN 'BREAKEVEN'
    ELSE 'LOSS'
    END AS PROFIT_STATUS
FROM Retailsales$;
-- SALES AND VOLUME 
SELECT 
    PRODUCT_NAME,
    SALES,
    QUANTITY,
    CASE
        WHEN SALES>10000 AND QUANTITY>10 THEN 
                    'HIGH_SALES-HIGH_VOLUME'
        WHEN SALES>10000 THEN 
                    'HIGH_SALES-LOW_VOLUME'
        WHEN QUANTITY>10 THEN 
                    'LOW_SALES-HIGH_VOLUME'
        ELSE 'LOW_SALES-LOW VOLUME'
    END AS product_performance
FROM Retailsales$;
--total sales by sales levels 
SELECT 
    CASE 
        WHEN SALES>=10000 THEN 'HIGH'
        WHEN SALES>=5000 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS SALES_LEVEL,
    SUM(SALES) AS TOTAL_SALES
FROM Retailsales$
GROUP BY 
        CASE
            WHEN SALES>=10000 THEN 'HIGH'
            WHEN SALES>=5000 THEN 'MEDIUM'
            ELSE 'LOW'
        END
ORDER BY TOTAL_SALES DESC;
-- LET CREATE THE BUSINESS REPORT
SELECT 
    CATEGORY,
    SUM(SALES) AS TOTAL_SALES,
    SUM
    (
        CASE
            WHEN SALES>=10000 THEN SALES
            ELSE 0
        END ) AS HIGH_SALES,
    SUM
       (
        CASE
            WHEN SALES<=5000 THEN SALES
            ELSE 0
        END ) AS LOW_SALES
FROM Retailsales$
GROUP BY CATEGORY 
ORDER BY TOTAL_SALES DESC ;
-- CREATE A CUSTOMER TABLE 
SELECT 
    CUSTOMER_ID,
    COUNT(DISTINCT CUSTOMER_NAME) AS NAME_COUNT,
    COUNT(DISTINCT REGION) AS REGION_COUNT,
    COUNT(DISTINCT CITY) AS CITY_COUNT
FROM Retailsales$
WHERE CUSTOMER_ID IS NOT NULL
GROUP BY CUSTOMER_ID
HAVING COUNT(DISTINCT CUSTOMER_NAME)>1
       OR COUNT(DISTINCT REGION)>1
        OR COUNT(DISTINCT CITY)>1;

-- CREATE A CUSTOMER TABLE 
SELECT 
  Customer_ID,
    CUSTOMER_NAME,
    REGION,
    CITY
INTO CUSTOMER
FROM Retailsales$
WHERE Customer_ID IS NOT NULL;
SELECT * FROM CUSTOMER
-- CHECK THE PRODUCT 
SELECT 
    Product_id,
    COUNT(DISTINCT PRODUCT_NAME) AS PRODUCT_NUMBER_COUNT,
    COUNT(DISTINCT CATEGORY) AS CATEGORY_COUNT
FROM Retailsales$
WHERE Product_ID IS NOT NULL
GROUP BY Product_ID
HAVING COUNT(DISTINCT Product_id) > 1
    or COUNT(DISTINCT Category) > 1;
-- CREATE THE PRODUCT TABLE
SELECT DISTINCT 
    PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY
    INTO PRODUCT
FROM Retailsales$
WHERE Product_ID IS NOT NULL;
SELECT TOP 20 *
FROM PRODUCT;
-- CREATE A SALES TABLE 
SELECT 
    ORDER_ID,
    ORDER_DATE,
    CUSTOMER_ID,
    PRODUCT_ID,
    QUANTITY,
    SALES
    INTO SALES
FROM Retailsales$;
SELECT TOP 100 * 
FROM SALES ;
SELECT SUM(SALES) AS TOTAL_SALES
FROM SALES;
--- CHECK THE SALES RECORD WOTHOUT MATCHING 
SELECT 
    COUNT(*) AS SALES_WITHOUT_MATCHING
    FROM SALES AS S
    LEFT JOIN CUSTOMER AS C
    ON S.Customer_ID=C.Customer_ID
    WHERE C.Customer_ID IS NULL;
    --- CHECK THE SALES WITHOUR PRODUCT MATCHING 
    SELECT 
        COUNT(*) AS SALES_WITHOUT_MATCHING
        FROM SALES AS S
        LEFT JOIN PRODUCT AS P
        ON S.PRODUCT_ID=P.PRODUCT_ID
        WHERE P.PRODUCT_ID IS NULL;
-- INNER JOIN 
SELECT 
    S.ORDER_ID,
    S.ORDER_DATE,
    S.CUSTOMER_ID,
    C.CUSTOMER_NAME,
    C.REGION,
    P.PRODUCT_NAME ,
    P.CATEGORY ,
    S.PRODUCT_ID,
    S.QUANTITY,
    S.SALES
FROM SALES AS S
INNER JOIN CUSTOMER AS C
ON S.CUSTOMER_ID=C.Customer_ID
INNER JOIN PRODUCT AS P
ON S.PRODUCT_ID=P.PRODUCT_ID
ORDER BY SALES DESC;
--- TOTAL SALES BY PRODUCT CATEGORY 
SELECT 
P.CATEGORY ,
SUM(SALES) AS TOTAL_SALES 
FROM SALES AS S
INNER JOIN PRODUCT AS P
ON S.PRODUCT_ID=P.PRODUCT_ID
GROUP BY P.CATEGORY
ORDER BY TOTAL_SALES;
-- SALES BY PRODUCT & CATEGORY 
SELECT 
    P.CATEGORY,
    P.PRODUCT_NAME,
    SUM(SALES) AS TOTAL_SALES,
    SUM(QUANTITY) AS TOTAL_QUANTITY,
COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDER   
FROM SALES AS S
INNER JOIN PRODUCT AS P
ON S.PRODUCT_ID=P.PRODUCT_ID
GROUP BY 
    P.CATEGORY ,
    P.PRODUCT_NAME
ORDER BY TOTAL_SALES;
--FIND SALE BY CATEGORY AND REGION 
SELECT 
    P.CATEGORY,
    C.REGION,
    SUM(SALES) AS TOTAL_SALES
FROM SALES AS S
INNER JOIN PRODUCT AS P
ON S.PRODUCT_ID=P.PRODUCT_ID
INNER JOIN CUSTOMER AS C
ON S.CUSTOMER_ID=C.Customer_ID
GROUP BY P.CATEGORY ,
C.REGION
ORDER BY 
C.REGION,
TOTAL_SALES DESC;
-- WHICH SALES RECORDS HAVE SALES GREATER THAN THE AVAERAGE SALES AMOUNT 
SELECT TOP 10
    ORDER_ID,
    PRODUCT_ID,
    QUANTITY,
    SALES
FROM SALES
WHERE SALES >
(
    SELECT AVG(SALES) FROM SALES
)
ORDER BY SALES DESC;
--- Which products have total sales greater than the average total sales per product?
SELECT 
    P.PRODUCT_ID,
    P.PRODUCT_NAME ,
    SUM(SALES) AS TOTAL_SALES
FROM SALES AS S
INNER JOIN PRODUCT AS P 
ON S.PRODUCT_ID=P.PRODUCT_ID
GROUP BY 
    P.PRODUCT_ID,
    P.PRODUCT_NAME
HAVING SUM(SALES) > ( 
                        SELECT AVG(PRODUCT_TOTAL)
                        FROM ( 
                                SELECT SUM(SALES) AS PRODUCT_TOTAL
                                FROM SALES
                                WHERE PRODUCT_ID IS NOT NULL
                                GROUP BY PRODUCT_ID
                                ) AS PRODUCT_SALES
                    )
ORDER BY TOTAL_SALES DESC ;
-- FIND CUSTOMERSNWITH ABOVE AVERAGE SALES 
WITH CUSTOMERSALES AS
( 
    SELECT 
        CUSTOMER_ID,
        SUM(SALES) AS TOTAL_SALES
    FROM SALES 
    WHERE CUSTOMER_ID IS NOT NULL
    GROUP BY CUSTOMER_ID
)
    SELECT 
        C.CUSTOMER_ID,
        C.CUSTOMER_NAME,
        CS.TOTAL_SALES
        FROM CUSTOMERSALES AS CS
        INNER JOIN CUSTOMER AS C 
        ON CS.CUSTOMER_ID=C.Customer_ID
        WHERE CS.TOTAL_SALES > (
                                SELECT 
                                       AVG(TOTAL_SALES)
                                FROM CUSTOMERSALES
                                )
ORDER BY TOTAL_SALES DESC ;
-- MONTHLY SALES 
WITH SALESREGION AS
(
SELECT 
    YEAR([ORDER_DATE]) AS SALES_YEAR,
    MONTH([ORDER_DATE]) AS SALES_MONTH,
    SUM(SALES) AS TOTAL_SALES
    FROM SALES
    WHERE ORDER_DATE IS NOT NULL 
    GROUP BY 
            YEAR([ORDER_DATE]),
            MONTH([ORDER_DATE])
)
    SELECT 
        SALES_YEAR,
        SALES_MONTH ,
        TOTAL_SALES 
FROM SALESREGION
ORDER BY 
        SALES_YEAR,
        SALES_MONTH;
--- How can we assign a unique sequence number to sales records, starting with the highest sale?
SELECT 
    ORDER_ID,
    PRODUCT_ID,
    SALES,
    ROW_NUMBER () OVER(ORDER BY SALES DESC)
    AS ROW_NUMBER
FROM SALES;
--- Find the top 10 products using RANK()
WITH PRODUCTSALES AS
( 
    SELECT 
        PRODUCT_ID,
        SUM(SALES) AS TOTAL_SALES
        FROM SALES
        WHERE PRODUCT_ID IS NOT NULL
        GROUP BY PRODUCT_ID
)
SELECT 
        PRODUCT_ID,
        TOTAL_SALES,
        RANK() OVER (ORDER BY TOTAL_SALES DESC) AS 
        SALES_RANK
FROM PRODUCTSALES
ORDER BY SALES_RANK;






