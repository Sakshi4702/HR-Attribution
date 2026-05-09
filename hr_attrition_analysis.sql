SELECT * FROM hr_attrition.employeeattrition;

-- SECTION 1: DATA EXPLORATION & OVERVIEW

-- Q1. How many total employees are in the dataset?
SELECT COUNT(*) AS total_employees
FROM employeeattrition;

-- Q2. What is the gender distribution?
SELECT 
    Gender,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employeeattrition), 1) AS percentage
FROM employeeattrition
GROUP BY Gender;

-- Q3. How many employees are in each department?
SELECT 
    Department,
    COUNT(*) AS total_employees
FROM employeeattrition
GROUP BY Department
ORDER BY total_employees DESC;

-- Q4. What is the distribution of employees across job roles?
SELECT 
    JobRole,
    COUNT(*) AS total_employees
FROM employeeattrition
GROUP BY JobRole
ORDER BY total_employees DESC;

-- Q5. What is the education field breakdown?
SELECT 
    EducationField,
    COUNT(*) AS total_employees
FROM employeeattrition
GROUP BY EducationField
ORDER BY total_employees DESC;


-- ============================================================
-- SECTION 2: ATTRITION ANALYSIS (CORE ANALYSIS)
-- ============================================================

-- Q6. What is the overall attrition rate?
SELECT 
    Attrition,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employeeattrition), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY Attrition;

-- Q7. Which department has the highest attrition rate?
SELECT 
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

-- Q8. Which job role has the highest attrition?
SELECT 
    JobRole,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY JobRole
ORDER BY attrition_rate_pct DESC;

-- Q9. How does attrition vary by gender?
SELECT 
    Gender,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY Gender;

-- Q10. How does attrition vary by age group?
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY age_group
ORDER BY attrition_rate_pct DESC;

-- Q11. How does business travel affect attrition?
SELECT 
    BusinessTravel,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY BusinessTravel
ORDER BY attrition_rate_pct DESC;

-- Q12. Does overtime cause higher attrition?
SELECT 
    OverTime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY OverTime;

-- Q13. How does marital status relate to attrition?
SELECT 
    MaritalStatus,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY MaritalStatus
ORDER BY attrition_rate_pct DESC;


-- ============================================================
-- SECTION 3: SALARY & COMPENSATION ANALYSIS
-- ============================================================

-- Q14. What is the average monthly income by department?
SELECT 
    Department,
    ROUND(AVG(MonthlyIncome), 0) AS avg_monthly_income,
    MIN(MonthlyIncome) AS min_income,
    MAX(MonthlyIncome) AS max_income
FROM employeeattrition
GROUP BY Department
ORDER BY avg_monthly_income DESC;

-- Q15. Do employees who left earn less than those who stayed?
SELECT 
    Attrition,
    ROUND(AVG(MonthlyIncome), 0) AS avg_monthly_income,
    ROUND(AVG(DailyRate), 0) AS avg_daily_rate,
    ROUND(AVG(HourlyRate), 0) AS avg_hourly_rate
FROM employeeattrition
GROUP BY Attrition;

-- Q16. What is the average income by job role?
SELECT 
    JobRole,
    ROUND(AVG(MonthlyIncome), 0) AS avg_monthly_income
FROM employeeattrition
GROUP BY JobRole
ORDER BY avg_monthly_income DESC;

-- Q17. Income bracket vs attrition — who is most at risk?
SELECT 
    CASE 
        WHEN MonthlyIncome < 3000  THEN 'Below 3K'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN '3K-6K'
        WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN '6K-10K'
        ELSE 'Above 10K'
    END AS income_bracket,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY income_bracket
ORDER BY attrition_rate_pct DESC;

-- Q18. Does percent salary hike affect attrition?
SELECT 
    Attrition,
    ROUND(AVG(PercentSalaryHike), 2) AS avg_salary_hike_pct
FROM employeeattrition
GROUP BY Attrition;


-- ============================================================
-- SECTION 4: SATISFACTION & ENGAGEMENT ANALYSIS
-- ============================================================

-- Q19. How does job satisfaction level affect attrition?
SELECT 
    JobSatisfaction,
    CASE JobSatisfaction
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Very High'
    END AS satisfaction_label,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY JobSatisfaction, satisfaction_label
ORDER BY JobSatisfaction;

-- Q20. How does environment satisfaction affect attrition?
SELECT 
    EnvironmentSatisfaction,
    CASE EnvironmentSatisfaction
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Very High'
    END AS satisfaction_label,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY EnvironmentSatisfaction, satisfaction_label
ORDER BY EnvironmentSatisfaction;

-- Q21. How does work-life balance affect attrition?
SELECT 
    WorkLifeBalance,
    CASE WorkLifeBalance
        WHEN 1 THEN 'Bad'
        WHEN 2 THEN 'Good'
        WHEN 3 THEN 'Better'
        WHEN 4 THEN 'Best'
    END AS balance_label,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY WorkLifeBalance, balance_label
ORDER BY WorkLifeBalance;

-- Q22. How does job involvement affect attrition?
SELECT 
    JobInvolvement,
    CASE JobInvolvement
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Very High'
    END AS involvement_label,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY JobInvolvement, involvement_label
ORDER BY JobInvolvement;


-- ============================================================
-- SECTION 5: TENURE & EXPERIENCE ANALYSIS
-- ============================================================

-- Q23. Do newer employees leave more often?
SELECT 
    CASE 
        WHEN YearsAtCompany <= 2  THEN '0-2 years'
        WHEN YearsAtCompany BETWEEN 3 AND 5  THEN '3-5 years'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 years'
        ELSE '10+ years'
    END AS tenure_group,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY tenure_group
ORDER BY attrition_rate_pct DESC;

-- Q24. Average experience profile: leavers vs stayers
SELECT 
    Attrition,
    ROUND(AVG(TotalWorkingYears), 1) AS avg_total_experience,
    ROUND(AVG(YearsAtCompany), 1) AS avg_years_at_company,
    ROUND(AVG(YearsInCurrentRole), 1) AS avg_years_in_role,
    ROUND(AVG(YearsSinceLastPromotion), 1) AS avg_years_since_promotion,
    ROUND(AVG(YearsWithCurrManager), 1) AS avg_years_with_manager
FROM employeeattrition
GROUP BY Attrition;

-- Q25. Does lack of promotion drive attrition?
SELECT 
    CASE 
        WHEN YearsSinceLastPromotion = 0 THEN 'Just Promoted'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 2 THEN '1-2 years ago'
        WHEN YearsSinceLastPromotion BETWEEN 3 AND 5 THEN '3-5 years ago'
        ELSE '5+ years ago'
    END AS promotion_group,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY promotion_group
ORDER BY attrition_rate_pct DESC;


-- ============================================================
-- SECTION 6: ADVANCED ANALYSIS (WINDOW FUNCTIONS)
-- ============================================================

-- Q26. Rank job roles by attrition rate using RANK()
SELECT 
    JobRole,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    RANK() OVER (ORDER BY SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) DESC) AS attrition_rank
FROM employeeattrition
GROUP BY JobRole;

-- Q27. Average income vs department average using window function
SELECT DISTINCT
    JobRole,
    Department,
    ROUND(AVG(MonthlyIncome) OVER (PARTITION BY JobRole), 0) AS avg_income_by_role,
    ROUND(AVG(MonthlyIncome) OVER (PARTITION BY Department), 0) AS avg_income_by_dept,
    ROUND(AVG(MonthlyIncome) OVER (), 0) AS overall_avg_income
FROM employeeattrition
ORDER BY Department, avg_income_by_role DESC;

-- Q28. Cumulative attrition count by age (running total)
SELECT 
    Age,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    SUM(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) OVER (ORDER BY Age) AS running_total_attrition
FROM employeeattrition
GROUP BY Age
ORDER BY Age;


-- ============================================================
-- SECTION 7: HIGH RISK EMPLOYEE PROFILE (KEY INSIGHT)
-- ============================================================

-- Q29. What does the typical high-risk (likely to leave) employee look like?
SELECT 
    ROUND(AVG(Age), 0) AS avg_age,
    ROUND(AVG(MonthlyIncome), 0) AS avg_monthly_income,
    ROUND(AVG(YearsAtCompany), 1) AS avg_years_at_company,
    ROUND(AVG(JobSatisfaction), 1) AS avg_job_satisfaction,
    ROUND(AVG(WorkLifeBalance), 1) AS avg_work_life_balance,
    ROUND(AVG(YearsSinceLastPromotion), 1) AS avg_years_since_promotion
FROM employeeattrition
WHERE Attrition = 'Yes';

-- Q30. Multi-factor attrition risk: Overtime + Low Satisfaction + Low Income
SELECT 
    OverTime,
    JobSatisfaction,
    CASE 
        WHEN MonthlyIncome < 5000 THEN 'Low Income'
        ELSE 'Above Average Income'
    END AS income_category,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM employeeattrition
GROUP BY OverTime, JobSatisfaction, income_category
HAVING employees_left > 0
ORDER BY attrition_rate_pct DESC
LIMIT 10;