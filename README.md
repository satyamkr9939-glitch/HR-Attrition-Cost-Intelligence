# 💼 HR Attrition Cost Intelligence Dashboard

> **Quantifying the rupee cost of employee attrition using Excel and SQL**  
> IBM HR Analytics Dataset | 1,470 Employees | DataVedh Analytics | SATYAM

---

## 📌 Business Problem

A mid-size organization with 1,470 employees was experiencing high attrition with no visibility into its financial impact. Leadership could see *who* was leaving — but had no answer to the critical question:

**"What is employee attrition actually costing us in rupees?"**

This project answers that question with data.

---

## 🎯 Objective

- Quantify the total annual rupee cost of employee attrition
- Identify which departments, roles, and employee profiles drive the highest attrition
- Build a What-If Simulator to model potential savings from retention improvements
- Deliver actionable recommendations to HR and leadership

---

## 🛠️ Tools Used

| Tool | Purpose |
|---|---|
| Microsoft Excel | Data cleaning, derived columns, financial cost model, What-If Simulator |
| MySQL | 12 SQL queries including window functions and multi-factor analysis |
| Power BI | Executive dashboard with drill-through and interactive visuals |

---

## 📂 Project Files

| File | Description |
|---|---|
| `HR_Attrition_Cost_Intelligence.xlsx` | Cleaned data + cost model + what-if simulator |
| `hr_attrition_analysis.sql` | All 12 SQL queries |
| `README.md` | Project documentation |

---

## 🔢 Key Metrics

| Metric | Value |
|---|---|
| Total Employees | 1,470 |
| Employees Who Left | 237 |
| Attrition Rate | 16.1% |
| **Total Annual Attrition Cost** | **₹1,47,68,152** |
| Average Cost Per Leaver | ₹62,313 |

---

## 🔍 Key Findings

### 1. Overtime is the #1 Attrition Driver
Employees working overtime quit at **30.5%** — nearly **3x higher** than non-overtime employees at 10.4%. Even overtime employees with high job satisfaction quit at 21.1% — higher than dissatisfied non-overtime employees.

### 2. Sales Department Bleeds the Most Talent
Sales had the highest attrition rate at **20.6%** — 1.5x higher than R&D at 13.8%. Sales Representatives specifically had a **39.8% attrition rate** — nearly 2 in 5 quit.

### 3. Early Tenure Employees Are the Highest Flight Risk
Employees in their **first 2 years** quit at **29.8%** — nearly 3x the rate of 5+ year employees at 10.8%. This points to an onboarding and early engagement gap.

### 4. Salary Gap Between Leavers and Stayers
Employees who left earned an average of **₹4,787/month** — ₹2,046 less than those who stayed at ₹6,833/month.

### 5. Under-25 Employees Leave at Nearly 40%
The youngest age group had a **39.2% attrition rate** — nearly 4x the rate of 35-44 year olds at 10.1%.

### 6. R&D Bears the Highest Absolute Cost
Despite a lower attrition rate, R&D incurred **₹76.78 Lakhs** in attrition cost due to its larger headcount — Rank 1 among all departments.

---

## 💡 Business Recommendations

### Recommendation 1 — Overtime Policy Reform
Introduce overtime caps and compensatory off policies for Sales and R&D teams. A 15% reduction in overtime-driven attrition could save approximately **₹22 Lakhs annually**.

### Recommendation 2 — Early Tenure Retention Program
Implement a structured 90-day onboarding program and 6-month check-in process for new hires. Targeting the 0-2 year group could prevent up to **102 annual departures**.

### Recommendation 3 — Salary Band Review for Low Earners
Low salary band employees quit at 21.8% vs 8.9% for high earners. A targeted salary review for bottom-band employees in Sales Representative and Laboratory Technician roles could significantly reduce attrition.

---

## 📊 What-If Simulator

The Excel model includes an interactive What-If Simulator:

| Retention Improvement | Annual Savings |
|---|---|
| 10% reduction in attrition | ₹14,76,815 |
| 20% reduction in attrition | ₹29,53,630 |
| 30% reduction in attrition | ₹44,30,446 |

> Change one cell in the Excel model — all savings figures update automatically.

---

## 🧠 SQL Highlights

12 queries written covering:
- Aggregate analysis (COUNT, SUM, AVG, GROUP BY)
- Multi-factor analysis (GROUP BY two columns)
- Window functions (RANK() OVER, SUM() OVER for running totals)
- Filtered profiling (WHERE with multiple AND conditions)

**Most powerful query — High Risk Employee Profile:**
```sql
SELECT `Job Role`, Department,
    ROUND(AVG(`Monthly Income`), 0) AS Avg_Monthly_Income,
    ROUND(AVG(`Years At Company`), 1) AS Avg_Tenure,
    COUNT(*) AS High_Risk_Count
FROM hr_cleaned
WHERE AttritionFlag = 1 
    AND `Over Time` = 'Yes' 
    AND `Job Satisfaction` <= 2
GROUP BY `Job Role`, Department
ORDER BY High_Risk_Count DESC;
