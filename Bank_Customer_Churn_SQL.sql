 --- SQL Customer Churn Analysis P2
 Use sql_project_p2;
 Create table Customer_Churn_Analysis
 (customer_id int primary key,
 credit_score int,
 country VARCHAR(50),
 gender	VARCHAR(20),
 age int,
 tenure int,
 balance decimal(15,2),
 products_number int,
 credit_card int,
 active_member int,
 estimated_salary decimal(15,2),
 churn int);
 
Select * from Customer_Churn_Analysis
where customer_id is null or credit_score is null or country is null or	gender is null or age is null or tenure
is null or balance is null or products_number is null or credit_card is null or	active_member	is null or
estimated_salary is null or churn is null;

-- 1. What percentage of customers churned in the last 6 months?

select Round((sum(churn) * 100) / count(*),2) as churn_percentage from customer_churn_analysis
where tenure <=6;

-- 2. Which customer segments have the highest churn rate?

-- By Geographic region
select country, Round((sum(churn) * 100) / count(*),2) as churn_rate_percentage from customer_churn_analysis
group by country
order by churn_rate_percentage desc;

-- By Gender
select gender, Round((sum(churn) * 100) / count(*),2) as churn_rate_percentage from customer_churn_analysis
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
 Round((sum(churn) * 100) / count(*),2) as churn_rate_percentage from customer_churn_analysis
group by age_group
order by churn_rate_percentage desc;

-- BY geography, gender, activity_status
 
select country, gender, active_member, Round((sum(churn) * 100) / count(*),2) as churn_rate_percentage from customer_churn_analysis
group by country, gender, active_member
order by churn_rate_percentage desc;

-- 3. Identify customers who have been active for less than 12 months — are they more likely to churn?

SELECT 
    CASE 
        WHEN tenure < 12 THEN 'Less than 12 Months'
        ELSE '12 Months or More'
    END AS tenure_group,
    Round((sum(churn) * 100) / count(*),2) as churn_rate_percentage from customer_churn_analysis
GROUP BY tenure_group
ORDER BY churn_rate_percentage DESC;
    
-- 4.	Build a churn-risk customer segmentation model

SELECT churn_risk_segment, COUNT(*) AS total_customers, SUM(churn) AS churned_customers,
ROUND((SUM(churn) * 100.0) / COUNT(*),2) AS churn_rate_percentage
FROM (SELECT customer_id, churn,
CASE WHEN active_member = 0 
AND products_number = 1
AND balance > 100000
THEN 'High Risk'
WHEN credit_score < 500
AND age > 45
THEN 'High Risk'
WHEN active_member = 0
AND products_number <= 2
THEN 'Medium Risk' ELSE 'Low Risk'
END AS churn_risk_segment
FROM customer_churn_analysis) AS risk_segments
GROUP BY churn_risk_segment
ORDER BY churn_rate_percentage DESC;
