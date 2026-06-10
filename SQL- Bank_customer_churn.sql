--- SQL Customer Churn Analysis P2
Use sql_project3;
-- Create Table
Create table bank_customer_churn
(  CustomerId INT PRIMARY KEY,
    Surname VARCHAR(100),
    CreditScore INT,
    Geography VARCHAR(50),
    Gender VARCHAR(20),
    Age INT,
    Tenure INT,
    Balance DECIMAL(15,2),
    NumOfProducts INT,
    HasCrCard INT,
    IsActiveMember INT,
    EstimatedSalary DECIMAL(15,2),
    Exited INT
);

select * from bank_customer_churn;

-- Data Analysis and Business insights

-- 1. What percentage of customers churned in the last 6 months?

select Round((sum(exited) * 100) / count(*),2) as churn_percentage from bank_customer_churn
where tenure <=6;

-- 2. Which customer segments have the highest churn rate?

-- By Geographic region
select geography, Round((sum(exited) * 100) / count(*),2) as churn_rate_percentage from bank_customer_churn
group by geography
order by churn_rate_percentage desc;

-- By Gender
select gender, Round((sum(exited) * 100) / count(*),2) as churn_rate_percentage from bank_customer_churn
group by gender
order by churn_rate_percentage desc;

-- By Age Group
select 
 CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END AS age_group,
Round((sum(exited) * 100) / count(*),2) as churn_rate_percentage from bank_customer_churn
group by age_group
order by churn_rate_percentage desc;

-- BY geography, gender, activity_status
 
select geography, gender, isactivemember, Round((sum(exited) * 100) / count(*),2) as churn_rate_percentage from bank_customer_churn
group by geography, gender, isactivemember
order by churn_rate_percentage desc;

-- 3. Identify customers who have been active for less than 12 months — are they more likely to churn?

SELECT 
    CASE 
        WHEN tenure < 6 THEN 'Less than 6 Months'
        ELSE '6 Months or More'
    END AS tenure_group,
    Round((sum(exited) * 100) / count(*),2) as churn_rate_percentage from bank_customer_churn
GROUP BY tenure_group
ORDER BY churn_rate_percentage DESC;
    
-- 4.	Build a churn-risk customer segmentation model

SELECT churn_risk_segment, COUNT(*) AS total_customers, SUM(exited) AS churned_customers,
ROUND((SUM(exited) * 100.0) / COUNT(*),2) AS churn_rate_percentage
FROM (SELECT customerid, churn,
CASE WHEN isactivemember = 0 
AND numofproducts = 1
AND balance > 100000
THEN 'High Risk'
WHEN creditscore < 500
AND age > 45
THEN 'High Risk'
WHEN isactivemember = 0
AND numofproducts <= 2
THEN 'Medium Risk' ELSE 'Low Risk'
END AS churn_risk_segment
FROM bank_customer_churn ) AS risk_segments
GROUP BY churn_risk_segment
ORDER BY churn_rate_percentage DESC;
-- End of Project