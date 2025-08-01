/*
==============================================================================
Quality Checks
==============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading into the Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
==============================================================================
*/

-- ============================
-- 1. Quality Checks for silver.crm_cust_info
-- ============================

-- Check for NULLs or Duplicates in Primary Key (cst_id)
SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces in String Fields (cst_firstname, cst_lastname)
SELECT
    cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check for Data Standardization & Consistency (cst_gndr, cst_marital_status)
SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;

-- Final Look at the Table
SELECT *
FROM silver.crm_cust_info;

-- ============================
-- 2. Quality Checks for silver.crm_prd_info
-- ============================

-- Check for NULLs or Duplicates in Primary Key (prd_id)
SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces in String Fields (prd_nm)
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for Nulls or Negative Numbers (prd_cost)
SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check for Data Standardization & Consistency (prd_line)
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders (prd_end_dt < prd_start_dt)
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Final Look at the Table
SELECT *
FROM silver.crm_prd_info;

-- ============================
-- 3. Quality Checks for silver.crm_sales_details
-- ============================

-- Check for Invalid Date Orders (sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt)
SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check for Data Consistency Between Sales, Quantity, and Price (sls_sales = sls_quantity * sls_price)
SELECT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- Final Look at the Table
SELECT *
FROM silver.crm_sales_details;

-- ============================
-- 4. Quality Checks for silver.erp_cust_az12
-- ============================

-- Check for Out-of-Range Dates (bdate > GETDATE())
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Check for Data Standardization & Consistency (gen)
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;

-- Final Look at the Table
SELECT *
FROM silver.erp_cust_az12;

-- ============================
-- 5. Quality Checks for silver.erp_loc_a101
-- ============================

-- Check for Data Standardization & Consistency (cntry)
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101;

-- Final Look at the Table
SELECT *
FROM silver.erp_loc_a101;
