/*
Task 2: Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)

 */

-- SOLUTION ---
SELECT 
    frequency_category, -- Selects the frequency category (High, Medium, Low)
    COUNT(*) AS customer_count, -- Counts the number of customers in each frequency category
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month -- Calculates the average transactions per month across customers in each category, rounded to one decimal place
FROM (
    SELECT 
        u.id, -- Selects the customer ID
        CASE 
            WHEN COALESCE(AVG(monthly_txns.transaction_count), 0) >= 10 THEN 'High Frequency' -- Classifies customers with ≥10 transactions/month as High Frequency
            WHEN COALESCE(AVG(monthly_txns.transaction_count), 0) BETWEEN 3 AND 9 THEN 'Medium Frequency' -- Classifies customers with 3–9 transactions/month as Medium Frequency
            ELSE 'Low Frequency' -- Classifies customers with ≤2 transactions/month as Low Frequency
        END AS frequency_category, -- Assigns the frequency category based on average monthly transactions
        COALESCE(AVG(monthly_txns.transaction_count), 0) AS avg_transactions_per_month -- Calculates the average monthly transactions per customer, defaulting to 0 if no transactions
    FROM 
        users_customuser u
    LEFT JOIN (
        SELECT 
            owner_id, -- Selects the customer ID for transactions
            YEAR(transaction_date) AS txn_year, -- Extracts the year from transaction_date
            MONTH(transaction_date) AS txn_month, -- Extracts the month from transaction_date
            COUNT(*) AS transaction_count -- Counts transactions per customer per month
        FROM 
            savings_savingsaccount
        WHERE 
            transaction_date IS NOT NULL -- Ensures only transactions with valid dates are included
        GROUP BY 
            owner_id, 
            YEAR(transaction_date), 
            MONTH(transaction_date) -- Groups transactions by customer, year, and month
    ) monthly_txns ON u.id = monthly_txns.owner_id -- Joins monthly transaction counts to users, including those with no transactions
    WHERE 
        u.is_active = 1 -- Filters for active users
        AND u.is_account_deleted = 0 -- Excludes deleted accounts
    GROUP BY 
        u.id -- Groups by customer ID to compute per-customer averages
) customer_freq -- Subquery alias for customer frequency data
GROUP BY 
    frequency_category -- Groups results by frequency category to aggregate customer counts and averages
ORDER BY 
    avg_transactions_per_month DESC; -- Sorts categories by average transactions per month, highest to lowest