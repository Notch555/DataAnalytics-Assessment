/* 
Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .
 */

SELECT 
    p.id AS plan_id, -- Selects the plan ID from plans_plan
    p.owner_id, -- Selects the owner ID (linked to users_customuser.id)
    CASE 
        WHEN p.plan_type_id = 1 THEN 'Savings' -- Maps plan_type_id = 1 to 'Savings'
        WHEN p.plan_type_id = 2 THEN 'Investment' -- Maps plan_type_id = 2 to 'Investment'
    END AS type, -- Converts plan_type_id to human-readable plan type
    MAX(s.transaction_date) AS last_transaction_date, -- Finds the most recent transaction date for the plan
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days -- Calculates days since the last transaction
FROM 
    plans_plan p
LEFT JOIN 
    savings_savingsaccount s 
    ON p.id = s.plan_id -- Left join to include plans with no transactions
WHERE 
    p.is_deleted = 0 -- Filters for non-deleted plans
    AND p.is_archived = 0 -- Filters for non-archived plans
    AND p.amount > 0 -- Ensures plans are funded (positive balance)
    AND (p.plan_type_id = 1 OR p.plan_type_id = 2) -- Limits to savings or investment plans
GROUP BY 
    p.id, p.owner_id, p.plan_type_id -- Groups by plan ID, owner ID, and plan type to aggregate transactions
HAVING 
    last_transaction_date IS NULL -- Includes plans with no transactions
    OR DATEDIFF(CURDATE(), last_transaction_date) >= 365 -- Includes plans with no transactions in the last 365 days
ORDER BY 
    inactivity_days DESC; -- Sorts by inactivity days, longest to shortest
    
    
    
    
    
    
    
    
    