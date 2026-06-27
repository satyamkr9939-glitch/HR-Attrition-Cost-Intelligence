-- ============================================================
-- HR ATTRITION COST INTELLIGENCE — SQL ANALYSIS
-- Author: SATYAM | DataVedh Analytics
-- Dataset: IBM HR Analytics | 1,470 Employees
-- Tool: MySQL
-- ============================================================

USE hr_attrition;

-- ────────────────────────────────────────────────────────────
-- QUERY 1: Overall Attrition Rate
-- Business Question: How many employees left and what % is that?
-- ────────────────────────────────────────────────────────────
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(AttritionFlag) AS Employees_Left,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_cleaned;
-- Result: 1470 | 237 | 16.12%

-- ────────────────────────────────────────────────────────────
-- QUERY 2: Attrition by Department
-- Business Question: Which department loses the most people?
-- ────────────────────────────────────────────────────────────
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(AttritionFlag) AS Employees_Left,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_cleaned
GROUP BY Department
ORDER BY Attrition_Rate_Pct DESC;
-- Result: Sales 20.63% | HR 19.05% | R&D 13.84%

-- ────────────────────────────────────────────────────────────
-- QUERY 3: Overtime vs Attrition
-- Business Question: Do overtime employees leave more?
-- ────────────────────────────────────────────────────────────
SELECT 
    `Over Time`,
    COUNT(*) AS Total_Employees,
    SUM(AttritionFlag) AS Employees_Left,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_cleaned
GROUP BY `Over Time`
ORDER BY Attrition_Rate_Pct DESC;
-- Result: Yes 30.53% | No 10.44% — 3x higher with overtime

-- ────────────────────────────────────────────────────────────
-- QUERY 4: Attrition by Salary Band
-- Business Question: Do low paid employees leave more?
-- ────────────────────────────────────────────────────────────
SELECT 
    SalaryBand,
    COUNT(*) AS Total_Employees,
    SUM(AttritionFlag) AS Employees_Left,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_cleaned
GROUP BY SalaryBand
ORDER BY Attrition_Rate_Pct DESC;
-- Result: Low 21.76% | Mid 11.14% | High 8.90%

-- ────────────────────────────────────────────────────────────
-- QUERY 5: Attrition by Tenure Bucket
-- Business Question: Do new employees leave faster?
-- ────────────────────────────────────────────────────────────
SELECT 
    TenureBucket,
    COUNT(*) AS Total_Employees,
    SUM(AttritionFlag) AS Employees_Left,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_cleaned
GROUP BY TenureBucket
ORDER BY Attrition_Rate_Pct DESC;
-- Result: 0-2 Yrs 29.82% | 3-5 Yrs 13.82% | 5+ Yrs 10.81%

-- ────────────────────────────────────────────────────────────
-- QUERY 6: Average Salary — Left vs Stayed
-- Business Question: Do leavers earn less than stayers?
-- ────────────────────────────────────────────────────────────
SELECT 
    Attrition,
    ROUND(AVG(`Monthly Income`), 0) AS Avg_Monthly_Income,
    ROUND(AVG(`Years At Company`), 1) AS Avg_Tenure_Years,
    COUNT(*) AS Total_Employees
FROM hr_cleaned
GROUP BY Attrition;
-- Result: Leavers avg Rs.4787 | Stayers avg Rs.6833

-- ────────────────────────────────────────────────────────────
-- QUERY 7: Top 5 Job Roles with Highest Attrition
-- Business Question: Which roles are bleeding talent?
-- ────────────────────────────────────────────────────────────
SELECT 
    `Job Role`,
    COUNT(*) AS Total_Employees,
    SUM(AttritionFlag) AS Employees_Left,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_cleaned
GROUP BY `Job Role`
ORDER BY Attrition_Rate_Pct DESC
LIMIT 5;
-- Result: Sales Rep 39.76% | Lab Technician 23.94% | HR 23.08%

-- ────────────────────────────────────────────────────────────
-- QUERY 8: Window Function — Rank Departments by Attrition Cost
-- Business Question: Which department costs the most in rupees?
-- ────────────────────────────────────────────────────────────
SELECT 
    Department,
    SUM(AttritionFlag) AS Employees_Left,
    SUM(AttritionCost) AS Total_Cost,
    RANK() OVER (ORDER BY SUM(AttritionCost) DESC) AS Cost_Rank
FROM hr_cleaned
GROUP BY Department;
-- Result: R&D Rs.76.78L Rank1 | Sales Rs.64.29L Rank2 | HR Rs.6.61L Rank3

-- ────────────────────────────────────────────────────────────
-- QUERY 9: Attrition by Age Group
-- Business Question: Which age group leaves the most?
-- ────────────────────────────────────────────────────────────
SELECT 
    AgeGroup,
    COUNT(*) AS Total_Employees,
    SUM(AttritionFlag) AS Employees_Left,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_cleaned
GROUP BY AgeGroup
ORDER BY Attrition_Rate_Pct DESC;
-- Result: Under 25 at 39.18% — nearly 4x the rate of 35-44

-- ────────────────────────────────────────────────────────────
-- QUERY 10: Multi-Factor — Overtime + Job Satisfaction
-- Business Question: What happens when overtime meets low satisfaction?
-- ────────────────────────────────────────────────────────────
SELECT 
    `Over Time`,
    `Job Satisfaction`,
    COUNT(*) AS Total_Employees,
    SUM(AttritionFlag) AS Employees_Left,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM hr_cleaned
GROUP BY `Over Time`, `Job Satisfaction`
ORDER BY Attrition_Rate_Pct DESC
LIMIT 6;
-- Result: Overtime alone drives attrition more than satisfaction

-- ────────────────────────────────────────────────────────────
-- QUERY 11: Window Function — Running Total Cost by Department
-- Business Question: How does attrition cost accumulate?
-- ────────────────────────────────────────────────────────────
SELECT 
    Department,
    `Job Role`,
    SUM(AttritionCost) AS Role_Cost,
    SUM(SUM(AttritionCost)) OVER (
        ORDER BY Department
    ) AS Running_Total_Cost
FROM hr_cleaned
GROUP BY Department, `Job Role`
ORDER BY Department, Role_Cost DESC;
-- Result: Running total reaches Rs.1,47,68,186 — matches Excel exactly

-- ────────────────────────────────────────────────────────────
-- QUERY 12: High Risk Employee Profile
-- Business Question: Who exactly is our highest flight risk?
-- ────────────────────────────────────────────────────────────
SELECT 
    `Job Role`,
    Department,
    ROUND(AVG(`Monthly Income`), 0) AS Avg_Monthly_Income,
    ROUND(AVG(`Years At Company`), 1) AS Avg_Tenure,
    COUNT(*) AS High_Risk_Count
FROM hr_cleaned
WHERE AttritionFlag = 1 
    AND `Over Time` = 'Yes' 
    AND `Job Satisfaction` <= 2
GROUP BY `Job Role`, Department
ORDER BY High_Risk_Count DESC;
-- Result: Research Scientist in R&D — Rs.2652/month, 4.5 yr tenure, 15 high risk employees
