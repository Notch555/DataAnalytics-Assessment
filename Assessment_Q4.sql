/* 
Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest
 */


SELECT 
    u.id AS customer_id, -- Selects the customer ID from users_customuser
    CONCAT(u.first_name, ' ', u.last_name) AS user_name, -- Concatenates first_name and last_name with a space to form full name
    GREATEST(
        TIMESTAMPDIFF(MONTH, u.date_joined, '2025-05-19'), -- Calculates months between signup date and May 19, 2025
        1 -- Ensures tenure is at least 1 to prevent division by zero in CLV calculation
    ) AS tenure_months,
    COALESCE(COUNT(s.id), 0) AS total_transactions, -- Counts transactions; returns 0 if no transactions (due to LEFT JOIN)
    ROUND(
        COALESCE(
            (COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, '2025-05-19'), 1)) * 
            12 * 
            AVG(s.amount * 0.001), -- Calculates CLV: (transactions per month) * 12 * average profit per transaction
            0 -- Returns 0 if no transactions to avoid NULL in CLV
        ),
        2 -- Rounds CLV to two decimal places (e.g., 600.00)
    ) AS estimated_clv
FROM 
    users_customuser u
LEFT JOIN 
    savings_savingsaccount s 
    ON u.id = s.owner_id 
    AND s.transaction_date IS NOT NULL -- Ensures only transactions with valid dates are included
    AND s.amount > 0 -- Filters for positive transaction amounts to exclude invalid or zero transactions
WHERE 
    u.is_active = 1 -- Includes only active users
    AND u.is_account_deleted = 0 -- Excludes deleted accounts
GROUP BY 
    u.id, u.name, u.date_joined -- Groups by customer ID, name, and signup date to aggregate transactions and calculate CLV
ORDER BY 
    estimated_clv DESC; -- Sorts results by CLV in descending order (highest to lowest)