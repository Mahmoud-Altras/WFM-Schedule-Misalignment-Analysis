/*
===============================================================================
Project: Call Center WFM Schedule Misalignment & Occupancy Audit
Author: Mahmoud Nasr Hassan Altras
Date: 2026-06-13
Description: This script analyzes Intraday Call Center performance directly from 
BigQuery tables, highlighting Schedule Inefficiency, true Occupancy compared 
to Legacy Excel caps, and SLA-crashing Staffing Variances.
===============================================================================
*/

-- 1. Exposing the Excel Artificial Cap vs. True SQL Occupancy
-- Proving that legacy reporting hid SLA failures by capping occupancy at 100%
WITH Row_Data AS (
  SELECT 
    v.Day_Name, 
    v.Time_Interval,
    v.AHT,
    v.Offered_Calls,
    s.Actual_Post_Shrinkage,
    ROUND((v.Offered_Calls * v.AHT / 3600) / NULLIF((s.Actual_Post_Shrinkage * 0.5), 0) * 100, 2) AS SQL_Occupancy 
  FROM `turing-seeker-498011-n9.WFM_Project_Data.Fact_Volume` v
  JOIN `turing-seeker-498011-n9.WFM_Project_Data.Fact_Staffing` s
    ON v.Time_Interval = s.Time_Interval
    AND v.Day_Name = s.Day_Name
)
SELECT 
  Time_Interval,
  Day_Name,
  Offered_Calls,
  Actual_Post_Shrinkage,
  SQL_Occupancy,
  CASE
    WHEN SQL_Occupancy >= 100 THEN 100
    ELSE SQL_Occupancy
  END AS Excel_Occupancy
FROM Row_Data
ORDER BY SQL_Occupancy DESC;

-- ============================================================================

-- 2. Detect Staffing Variance (The Misalignment/SLA Failure Trap)
-- Identifying intervals where Actual Staff is LESS than Required Staff 
SELECT 
    v.Time_Interval,
    SUM(s.Actual_Post_Shrinkage) AS Total_Actual_Agents,
    SUM(s.Required_Agent) AS Total_Required_Agents,
    -- Negative variance means Understaffed (SLA Failure)
    SUM(s.Actual_Post_Shrinkage) - SUM(s.Required_Agent) AS Staffing_Variance
FROM 
    `turing-seeker-498011-n9.WFM_Project_Data.Fact_Volume` v
JOIN 
    `turing-seeker-498011-n9.WFM_Project_Data.Fact_Staffing` s 
    ON v.Day_Name = s.Day_Name AND v.Time_Interval = s.Time_Interval
GROUP BY 
    v.Time_Interval
HAVING 
    (SUM(s.Actual_Post_Shrinkage) - SUM(s.Required_Agent)) < 0 -- Focusing only on SLA crisis points
ORDER BY 
    Staffing_Variance ASC;

-- ============================================================================

-- 3. Shrinkage Abuse Detection (Scheduled vs. Actual Post Shrinkage)
-- Finding periods where the drop-off between Scheduled and Actual is severely impacting operations
SELECT 
    Day_Name,
    Time_Interval,
    Scheduled_Agents,
    Actual_Post_Shrinkage,
    Scheduled_Agents - Actual_Post_Shrinkage AS Lost_Agents,
    -- Using FLOAT64 for BigQuery exact decimal division
    ROUND(CAST((Scheduled_Agents - Actual_Post_Shrinkage) AS FLOAT64) / NULLIF(Scheduled_Agents, 0) * 100, 2) AS Shrinkage_Pct
FROM 
    `turing-seeker-498011-n9.WFM_Project_Data.Fact_Staffing`
WHERE 
    (Scheduled_Agents - Actual_Post_Shrinkage) > 5 -- Threshold for severe shrinkage (more than 5 agents lost)
ORDER BY 
    Shrinkage_Pct DESC;