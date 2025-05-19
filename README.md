# DataAnalytics-Assessment

## Challenges and approach

### Loading Data:
I encountered little difficulty while running the queries containing the data, especially with the user_customuser data. I had to add the IGNORE clause due to error messages caused by duplicate data. It was not as straight forward as I thought but it was a worthy challenge. I had to troubleshoot before I was able to successfully load the user_customuser data.

### Task 1 challenges and approach:
What I was trying to do: Find customers with at least one funded savings plan and one funded investment plan, showing plan counts and total deposits, sorted by deposits.
The difficult thing about this task is the fact that after every written query and troubleshooting, I still happen to arive at zero clients with saving plans and investment plans. 
A lot could be done differently and more straight forward, an actual plan_type_id values or a related table (e.g., a plan type lookup table) would have made this much clearer.

### Task 2 challenges and approach:
What I was trying to do: Calculate how many transactions customers make per month, group them into "High," "Medium," or "Low Frequency" buckets, and summarize the counts and averages by category.
* Empty Results: The query initially spat out nothing, which was super frustrating. It was likely because I used an INNER JOIN that skipped customers with no transactions, but I needed everyone, even the inactive folks.
* Formatting Fuss: The output needed averages rounded to one decimal place (like 15.2), and getting that just right took some tweaking.
* Zero Averages: Customers with no transactions needed to show up as “Low Frequency” with a zero average, which required COALESCE to handle NULLs gracefully.

### Task 3 challenges and approach:
What I was trying to do: Find savings or investment plans that are active (funded, not deleted) but haven’t had transactions in the last 365 days, showing their last transaction date and inactivity days.
* No Transactions, No Problem?: Plans with zero transactions were supposed to show up (with NULL dates), but INNER JOIN would’ve excluded them. We needed a LEFT JOIN to catch these dormant plans.
* Inactivity Days Misstep: The example output showed 92 days of inactivity for a date that was actually 648 days ago (2023-08-10 to 2025-05-19). This typo threw me off, making me double-check my DATEDIFF logic.
* Funded Plans: I assumed “funded” meant amount > 0, but if the data had zero or negative balances, it could explain empty results.

### Task 4 challenges and approach:
What I was trying to do: Calculate CLV for each customer based on their account tenure, total transactions, and a 0.1% profit per transaction, sorting by CLV.
* Tenure Troubles: Calculating months since signup (date_joined to May 19, 2025) was fine, but new users with zero months caused division-by-zero errors. I used GREATEST(..., 1) to fix this.
* No Transactions: Customers with no transactions needed a CLV of 0, which required COALESCE to handle NULLs in the average profit calculation.
* Name Field: The query used CONCAT(first_name, last_name), but the GROUP BY mistakenly used name, causing a mismatch I had to fix.

#### This was a challenging assessment and I am happy to have participated to the best of my ability, I believe that challenges like this are the building blocks to growth or mastering one's skills as a Data Analyst.
