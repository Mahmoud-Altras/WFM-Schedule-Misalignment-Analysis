# 📉 WFM Call Center Operations: Uncovering Shift Misalignment & SLA Failures

### 🎬 [Click Here to Watch the Interactive Dashboard Demo](https://youtu.be/gajMGFjeUYw)

## 📌 Project Overview
In many call centers, operations managers rely on flawed daily aggregates or outdated Excel macros to assess performance, leading to a false sense of security. This project exposes a classic Workforce Management (WFM) crisis: **Schedule Inefficiency (Misalignment)**. 

By migrating intraday interval data from a fragile Excel environment into a robust Power BI Data Model, this project proves that despite the center being financially "Overstaffed" on a daily level (with a maximum true Occupancy of only 76%), the Service Level Agreement (SLA) is still collapsing due to catastrophic scheduling gaps during peak hours.

## 🎯 Business Problem
* **The Illusion:** Previous management reporting showed total headcount was sufficient, capping occupancy artificially at 100% in Excel.
* **The Reality:** Customers are waiting in queues, agents are burning out at 1:00 PM, while dozens of agents are being paid to sit idle at 9:00 PM. The issue isn't a lack of staff; it's *when* they are scheduled.

## 🛠️ Tech Stack & Skills Demonstrated
* **SQL:** Data extraction, joining Fact Tables (`Fact_Volume`, `Fact_Staffing`), and calculating net variance and true occupancy.
* **Power BI:** 
  * Built a Star Schema data model.
  * Authored advanced DAX measures (`Staffing_Variance`, `Workload_Hours`, `Occupancy_Pct`).
  * Engineered a strict Conditional Formatting logic (Rules-based Heatmaps) avoiding standard percentile traps to reveal true operational gaps.
* **WFM Domain Expertise:** Shift Realignment, Shrinkage Abuse Detection, SLA Optimization, VTO implementation.

## 📊 Key Insights Discovered
1. **Financial Hemorrhage (The Yellow Zones):** During early mornings and late evenings, Occupancy drops as low as 15-30%. The company is burning budget on agents who have no calls to answer.
2. **SLA Collapse (The Red Zones):** Despite the daily overstaffing, critical intervals (e.g., 1:00 PM) show a sharp **Negative Staffing Variance (-53 agents aggregate)**. This is where calls are abandoned and the SLA crashes.
3. **Data Integrity Rescue:** Replaced a static Excel macro that hid SLA failures with a dynamic DAX-powered environment that prevents manual data manipulation.

## 🚀 Strategic Recommendations (Action Plan)
To fix this operational crisis without requesting an additional hiring budget, I propose the following immediate actions:

1. **Shift Sliding (Realignment):**
   Re-roster current agents by shifting start times. Pull agents from the "Yellow" overstaffed morning/evening intervals and slide their shifts 1-2 hours to cover the "Red" mid-day peaks.
2. **Break & Shrinkage Optimization:**
   The massive deficit at 1:00 PM indicates simultaneous, unmanaged lunch breaks. Stagger break schedules aggressively across a wider 11:30 AM - 2:30 PM window to flatten the shrinkage curve.
3. **Activate Voluntary Time Off (VTO):**
   To stop the financial bleed during 20% occupancy periods, implement a VTO protocol before these shifts start, saving the company immediate operational costs.

## 📂 Repository Structure
* `WFM_Misalignment_Analysis.sql`: Contains the core ETL queries and variance detection logic.
* `Dashboard_Screenshots/`: Visual evidence of the DAX Heatmap and Variance charts proving the intraday gaps.
* `Datasets/`: Dummy CSV files representing `Fact_Volume` and `Fact_Staffing`.

## 💡 How to Run This Project
1. Run the `.sql` script in **Google BigQuery**. *(Note: Update the project path `turing-seeker-498011-n9.WFM_Project_Data` to match your own BigQuery dataset environment).*
2. Open the `.pbix` file in **Power BI Desktop** to interact with the Cross-Filtering capabilities, DAX measures, and Conditional Formatting Rules.