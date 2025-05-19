/*
Task 1: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
*/

-- SOLUTION --
SELECT 
    u.id AS owner_id, -- Selects the customer ID from users_customuser
    CONCAT(u.first_name, ' ', u.last_name) AS name, -- Concatenates first_name and last_name with a space to form full name
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count, -- Counts distinct savings plans (is_regular_savings = 1)
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count, -- Counts distinct investment plans (is_a_fund = 1)
    ROUND(
        SUM(
            CASE 
                WHEN s.confirmed_amount - COALESCE(s.deduction_amount, 0) > 0 -- Checks if net balance (inflows minus withdrawals) is positive
                THEN s.confirmed_amount - COALESCE(s.deduction_amount, 0) -- Includes positive net balance in sum
                ELSE 0 -- Excludes non-positive net balances
            END
        ) / 100, 
        2
    ) AS total_deposits -- Sums positive net balances, converts kobo to Naira, and rounds to two decimal places
FROM 
    users_customuser u
INNER JOIN 
    plans_plan p ON u.id = p.owner_id -- Joins users to their plans based on owner_id
INNER JOIN 
    savings_savingsaccount s ON p.id = s.plan_id -- Joins plans to their transactions based on plan_id
WHERE 
    u.is_active = 1 -- Filters for active users
    AND u.is_account_deleted = 0 -- Excludes deleted user accounts
    AND p.is_deleted = 0 -- Filters for non-deleted plans
    AND p.is_archived = 0 -- Filters for non-archived plans
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1) -- Limits to savings or investment plans
    AND s.transaction_status = 'success' -- Includes only successful transactions
GROUP BY 
    u.id, CONCAT(u.first_name, ' ', u.last_name) -- Groups by customer ID and full name to aggregate plan counts and deposits
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 AND (s.confirmed_amount - COALESCE(s.deduction_amount, 0)) > 0 THEN p.id END) >= 1 -- Ensures at least one funded savings plan
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 AND (s.confirmed_amount - COALESCE(s.deduction_amount, 0)) > 0 THEN p.id END) >= 1 -- Ensures at least one funded investment plan
ORDER BY 
    total_deposits DESC; -- Sorts results by total deposits in descending order (highest to lowest)
    



    
